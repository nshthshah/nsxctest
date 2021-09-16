import Foundation

struct ClassChainItem {
    var position: Int?
    var type: XCUIElement.ElementType
    var isDescendant: Bool
    var predicates: NSPredicate?
}

internal class ClassChainQueryParser {
    var classChainItems: [ClassChainItem] = []
    let descendantMarker = "**"
    let starToken = "*"
    let openingBracketToken: Character = "["
    let closingBracketToken = "]"
    let splitterToken: Character = "/"
    let enclosingMarker = "`"

    init(classChainQuery: String) {
        let classChains = classChainQuery.split(separator: splitterToken)
        for eachQuery in classChains {
            if eachQuery == descendantMarker {
                let classChainItem = ClassChainItem(position: nil,
                                                    type: .any,
                                                    isDescendant: true,
                                                    predicates: nil)
                classChainItems.append(classChainItem)

            } else if eachQuery.starts(with: starToken) {
                let classChainItem = ClassChainItem(position: position(fromQuery: String(eachQuery)),
                                                    type: .any,
                                                    isDescendant: false,
                                                    predicates: predicate(fromQuery: String(eachQuery)))
                classChainItems.append(classChainItem)
            } else {
                let classChainItem = ClassChainItem(position: position(fromQuery: String(eachQuery)),
                                                    type: type(fromQuery: String(eachQuery)),
                                                    isDescendant: false,
                                                    predicates: predicate(fromQuery: String(eachQuery)))
                classChainItems.append(classChainItem)
            }
        }
    }

    private func position(fromQuery eachQuery: String) -> Int? {

        for eachMatch in eachQuery.splitUsingRegex("\\[(.*?)\\]") {
            let position = String(eachMatch.dropFirst().dropLast())
            if position.isNumber {
                return Int(position)
            }
        }
        return nil
    }

    private func type(fromQuery eachQuery: String) -> XCUIElement.ElementType {
        guard let type = eachQuery.split(separator: openingBracketToken).first else { return .any }
        return XCUIElementTypeTransformer.shared.elementTypeWithTypeName(String(type))
    }

    private func predicate(fromQuery eachQuery: String) -> NSPredicate? {

        for eachMatch in eachQuery.splitUsingRegex("\\[`(.*?)`\\]") {
            let predicateFormat = String(eachMatch.dropFirst().dropLast())
            if predicateFormat.hasPrefix(enclosingMarker) && predicateFormat.hasSuffix(enclosingMarker) {
                return NSPredicate(format: String(predicateFormat.dropFirst().dropLast()))
            }
        }
        return nil
    }
}
