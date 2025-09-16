import Foundation
import XCTest
import AEXML
import Fuzi
import NSXCTestObjC

internal class XCTestWDXPath {

    // MARK: External API
    static let defaultTopDir = "top"

    static func findMatchesIn(_ root: XCElementSnapshot, _ xpathQuery: String) -> [XCElementSnapshot]? {

        var mapping = [String: XCElementSnapshot]()
        var results = [XCElementSnapshot]()
        guard let documentXml = generateXMLPresentation(root,
                                                  nil,
                                                  nil,
                                                  defaultTopDir,
                                                  &mapping)?.xml else {
                  return results
        }

        let document = try? XMLDocument(string: documentXml, encoding: String.Encoding.utf8)

        if let nodes = document?.xpath(xpathQuery) {
            for node in nodes {
                if let privateIndexPath = node.attr("private_indexPath"),
                    let mappingValue = mapping[privateIndexPath] {
                        results.append(mappingValue)
                }
            }
        }
        return results
    }

    // MARK: Internal Utils
    static func generateXMLPresentation(_ root: XCElementSnapshot, _ parentElement: AEXMLElement?, _ writingDocument: AEXMLDocument?, _ indexPath: String, _ mapping: inout [String: XCElementSnapshot]) -> AEXMLDocument? {

        let elementName = XCUIElementTypeTransformer.shared.stringWithElementType(root.elementType)
        let currentElement = AEXMLElement(name: elementName)
        recordAttributeForElement(root, currentElement, indexPath)

        let document: AEXMLDocument

        if let parentElement = parentElement,
            let writingDocument = writingDocument {

            document = writingDocument
            parentElement.addChild(currentElement)

        } else {
            document = AEXMLDocument()
            document.addChild(currentElement)
        }

        var index = 0
        for child in root.children {
            if let childSnapshot = child as? XCElementSnapshot {
                let childIndexPath = indexPath.appending(",\(index)")
                index += 1
                mapping[childIndexPath] = childSnapshot

                _ = generateXMLPresentation(childSnapshot, currentElement, document, childIndexPath, &mapping)
            }
        }

        return document
    }

    static func recordAttributeForElement(_ snapshot: XCElementSnapshot, _ currentElement: AEXMLElement, _ indexPath: String?) {

        currentElement.attributes["type"] = XCUIElementTypeTransformer.shared.stringWithElementType(snapshot.elementType)

        if snapshot.wdValue() != nil {
            let value = snapshot.wdValue()
            if let str = value as? String {
                currentElement.attributes["value"] = str
            } else if let bin = value as? Bool {
                currentElement.attributes["value"] = bin ? "1":"0"
            } else {
                currentElement.attributes["value"] = (value as AnyObject).debugDescription
            }
        }

        if snapshot.wdName() != nil {
            currentElement.attributes["name"] = snapshot.wdName()
        }

        if snapshot.wdLabel() != nil {
            currentElement.attributes["label"] = snapshot.wdLabel()
        }

        currentElement.attributes["enabled"] = snapshot.isWDEnabled() ? "true":"false"

        let rect = snapshot.wdRect()
        for key in ["x", "y", "width", "height"] {
            currentElement.attributes[key] = rect[key]?.description
        }

        if indexPath != nil {
            currentElement.attributes["private_indexPath"] = indexPath
        }
    }
}
