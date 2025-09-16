import Foundation
import NSXCTestObjC
import XCTest

public extension XCUIApplication {

    /// :nodoc:
    func mainWindowSnapshot() -> XCElementSnapshot? {
        let mainWindows = (self.fb_lastSnapshot()).descendantsByFiltering { snapshot -> Bool in
            return snapshot?.isMainWindow ?? false
        }
        return mainWindows?.last
    }
}

public extension XCUIElement {

    /// :nodoc:
    func descendantsMatchingXPathQuery(xpathQuery: String, returnAfterFirstMatch: Bool) -> [XCUIElement] {

        let query = xpathQuery.replacingOccurrences(of: "XCUIElementTypeAny", with: "*")
        guard var matchSnapShots = XCTestWDXPath.findMatchesIn(self.fb_lastSnapshot(), query),
            !matchSnapShots.isEmpty else {
            return [XCUIElement]()
        }

        if returnAfterFirstMatch {
            matchSnapShots = [matchSnapShots[0]]
        }

        var matchingTypes = Set<XCUIElement.ElementType>()
        for snapshot in matchSnapShots {
            matchingTypes.insert(XCUIElementTypeTransformer.shared.elementTypeWithTypeName(snapshot.wdType()))
        }

        var map = [XCUIElement.ElementType: [XCUIElement]]()
        for type in matchingTypes {
            let descendantsOfType = self.descendants(matching: type).allElementsBoundByIndex
            map[type] = descendantsOfType
        }

        var matchingElements = [XCUIElement]()
        for snapshot in matchSnapShots {
            if var elements = map[snapshot.elementType] {
                if query.contains("last()") {
                    elements = elements.reversed()
                }

                innerLoop: for element in elements {
                    if element.checkLastSnapShot()._matchesElement(snapshot) {
                        matchingElements.append(element)
                        break innerLoop
                    }
                }
            }
        }
        return matchingElements
    }

    /// :nodoc:
    func descendantsMatchingClassChainQuery(classChainQuery: String, returnAfterFirstMatch: Bool) -> [XCUIElement] {
        var matchingElements = [XCUIElement]()

        var lookupChain = ClassChainQueryParser(classChainQuery: classChainQuery).classChainItems

        var currentRoot = self
        var chainItem = lookupChain[0]
        var query = currentRoot.queryWith(classChainItem: chainItem, query: nil)
        lookupChain.remove(at: 0)

        while !lookupChain.isEmpty {
            var isRootChanged = false

            if let position = chainItem.position {
                currentRoot = query.element(boundBy: position)
                isRootChanged = true
            }
            chainItem = lookupChain[0]
            query = currentRoot.queryWith(classChainItem: chainItem, query: isRootChanged ? nil : query)
            lookupChain.remove(at: 0)
        }
        if let position = chainItem.position {
            return [query.element(boundBy: position)]
        }
        if returnAfterFirstMatch {
            matchingElements.append(query.element(boundBy: 0))
        } else {
            matchingElements.append(contentsOf: query.allElementsBoundByIndex)
        }
        return matchingElements
    }
    
    /// :nodoc:
    func elementQueryFromClassChain(classChainQuery: String) -> XCUIElementQuery {
        var matchingElements = [XCUIElement]()

        var lookupChain = ClassChainQueryParser(classChainQuery: classChainQuery).classChainItems

        var currentRoot = self
        var chainItem = lookupChain[0]
        var query = currentRoot.queryWith(classChainItem: chainItem, query: nil)
        lookupChain.remove(at: 0)

        while !lookupChain.isEmpty {
            var isRootChanged = false

            if let position = chainItem.position {
                currentRoot = query.element(boundBy: position)
                isRootChanged = true
            }
            chainItem = lookupChain[0]
            query = currentRoot.queryWith(classChainItem: chainItem, query: isRootChanged ? nil : query)
            lookupChain.remove(at: 0)
        }
        if let position = chainItem.position {
            return query.element(boundBy: position).children(matching: .any)
        }
        return query
    }
}
