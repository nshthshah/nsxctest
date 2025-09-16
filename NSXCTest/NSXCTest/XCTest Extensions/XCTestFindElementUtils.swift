import Foundation

enum XCTestWDRoutingError: Error {
    case noSuchUsingMethod
}

extension RawRepresentable where Self.RawValue == String {

    public func element(arguments: String..., underElement: XCUIElement? = nil) -> XCUIElement {
        if let underElement = underElement {
            return String(format: self.rawValue, arguments: arguments).element(underElement: underElement)
        }
        return String(format: self.rawValue, arguments: arguments).element
    }

    public func element(arguments: Int..., underElement: XCUIElement? = nil) -> XCUIElement {
        if let underElement = underElement {
            return String(format: self.rawValue, arguments: arguments).element(underElement: underElement)
        }
        return String(format: self.rawValue, arguments: arguments).element
    }

    public func elements(arguments: String..., underElement: XCUIElement? = nil) -> [XCUIElement] {
        if let underElement = underElement {
            return String(format: self.rawValue, arguments: arguments).elements(underElement: underElement)
        }
        return String(format: self.rawValue, arguments: arguments).elements
    }

    public var element: XCUIElement {
        return self.rawValue.element
    }

    public var elements: [XCUIElement] {
        return self.rawValue.elements
    }

    public func element(underElement: XCUIElement) -> XCUIElement {
        return self.rawValue.element(underElement: underElement)
    }

    public func elements(underElement: XCUIElement) -> [XCUIElement] {
        return self.rawValue.elements(underElement: underElement)
    }

    public func parent(matching parentLocator: String)  -> XCUIElement {
        return self.rawValue.findParentElement(matching: parentLocator)
    }

    public func parent(matching parentLocator: String, position: Int)  -> XCUIElement {
        return self.rawValue.findParentElement(matching: parentLocator, position: position)
    }

    public func parent(matching parentLocator: String, arguments: String...)  -> XCUIElement {
        return String(format: self.rawValue, arguments: arguments).findParentElement(matching: parentLocator)
    }

    public func parent(matching parentLocator: String, arguments: Int...)  -> XCUIElement {
        return String(format: self.rawValue, arguments: arguments).findParentElement(matching: parentLocator)
    }

    public func sibling(matching siblingLocator: String)  -> XCUIElement {
        return self.rawValue.findSiblingElement(matching: siblingLocator)
    }

    public func sibling(matching siblingLocator: String, arguments: String...)  -> XCUIElement {
        return String(format: self.rawValue, arguments: arguments).findSiblingElement(matching: siblingLocator)
    }

    public func sibling(matching siblingLocator: String, arguments: Int...)  -> XCUIElement {
        return String(format: self.rawValue, arguments: arguments).findSiblingElement(matching: siblingLocator)
    }
}

internal extension String {

    func element(underElement: XCUIElement) -> XCUIElement {
        if self.starts(with: By.id.strategy) {
            let withValue = String(self.components(separatedBy: By.id.strategy)[1])
            return underElement.descendants(matching: .any).matching(identifier: withValue).firstMatch

        } else if self.starts(with: By.className.strategy) {
            let withValue = String(self.components(separatedBy: By.className.strategy)[1])
            let type = XCUIElementTypeTransformer.shared.elementTypeWithTypeName(withValue)
            return underElement.descendants(matching: type).firstMatch

        } else if self.starts(with: By.predicate.strategy) {
            let withValue = String(self.components(separatedBy: By.predicate.strategy)[1])
            let formattedPredicate = NSPredicate(format: withValue)
            return underElement.descendants(matching: .any).matching(formattedPredicate).firstMatch

        } else if self.starts(with: By.classChain.strategy) {
            let withValue = String(self.components(separatedBy: By.classChain.strategy)[1])
            return underElement.descendantsMatchingClassChainQuery(classChainQuery: withValue, returnAfterFirstMatch: true)[0]

        } else if self.starts(with: By.xpath.strategy) {
            let withValue = String(self.components(separatedBy: By.xpath.strategy)[1])
            return underElement.descendantsMatchingXPathQuery(xpathQuery: withValue, returnAfterFirstMatch: true)[0]

        } else {
            return underElement.descendants(matching: .any).matching(identifier: self).firstMatch
        }
    }

    func elements(underElement: XCUIElement) -> [XCUIElement] {
        if self.starts(with: By.id.strategy) {
            let withValue = String(self.components(separatedBy: By.id.strategy)[1])
            return underElement.descendants(matching: .any).matching(identifier: withValue).allElementsBoundByIndex

        } else if self.starts(with: By.className.strategy) {
            let withValue = String(self.components(separatedBy: By.className.strategy)[1])
            let type = XCUIElementTypeTransformer.shared.elementTypeWithTypeName(withValue)
            return underElement.descendants(matching: type).allElementsBoundByIndex

        } else if self.starts(with: By.predicate.strategy) {
            let withValue = String(self.components(separatedBy: By.predicate.strategy)[1])
            let formattedPredicate = NSPredicate(format: withValue)
            return underElement.descendants(matching: .any).matching(formattedPredicate).allElementsBoundByIndex

        } else if self.starts(with: By.classChain.strategy) {
            let withValue = String(self.components(separatedBy: By.classChain.strategy)[1])
            return underElement.descendantsMatchingClassChainQuery(classChainQuery: withValue, returnAfterFirstMatch: false)

        } else if self.starts(with: By.xpath.strategy) {
            let withValue = String(self.components(separatedBy: By.xpath.strategy)[1])
            return underElement.descendantsMatchingXPathQuery(xpathQuery: withValue, returnAfterFirstMatch: false)

        } else {
            return underElement.descendants(matching: .any).matching(identifier: self).allElementsBoundByIndex
        }
    }

    var element: XCUIElement {
        return element(underElement: XCPlusApp.activeApplication())
    }

    var elements: [XCUIElement] {
        return elements(underElement: XCPlusApp.activeApplication())
    }

    func findParentElement(matching parentLocator: String, indexFromLast: Int = 1) -> XCUIElement {
        let _matchedParents = findParentElements(matching: parentLocator)
        return _matchedParents[_matchedParents.count - indexFromLast]
    }

    func findParentElement(matching parentLocator: String, position: Int) -> XCUIElement {
        let _matchedParents = findParentElements(matching: parentLocator)
        return _matchedParents[position]
    }

    func findParentElements(matching parentLocator: String) -> [XCUIElement] {
        let underElement = XCPlusApp.activeApplication()
                
        if self.starts(with: By.name.strategy) ||
                    self.starts(with: By.className.strategy) ||
                    self.starts(with: By.classChain.strategy) ||
                    self.starts(with: By.xpath.strategy) {
            AssertFail(message: "Invalid Locator Strategy For Child Element. Child Element should be in Predicate or Id!")
            
        } else if self.starts(with: By.predicate.strategy) {
            let withChildValue = String(self.components(separatedBy: By.predicate.strategy)[1])
            let childElementPredicate = NSPredicate(format: withChildValue)

            if parentLocator.starts(with: By.id.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.id.strategy)[1])
                return underElement.descendants(matching: .any).matching(identifier: withParentValue).containing(childElementPredicate).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.className.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.className.strategy)[1])
                let type = XCUIElementTypeTransformer.shared.elementTypeWithTypeName(withParentValue)
                return underElement.descendants(matching: type).containing(childElementPredicate).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.predicate.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.predicate.strategy)[1])
                let formattedPredicate = NSPredicate(format: withParentValue)
                return underElement.descendants(matching: .any).matching(formattedPredicate).containing(childElementPredicate).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.classChain.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.classChain.strategy)[1])
                return underElement.elementQueryFromClassChain(classChainQuery: withParentValue).containing(childElementPredicate).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.xpath.strategy) {
                AssertFail(message: "xPath not supported in Parent Element")

            } else {
                return underElement.descendants(matching: .any).matching(identifier: parentLocator).containing(childElementPredicate).allElementsBoundByIndex
            }

        } else if self.starts(with: By.id.strategy) {
            let withChildValue = String(self.components(separatedBy: By.id.strategy)[1])

            if parentLocator.starts(with: By.id.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.id.strategy)[1])
                return underElement.descendants(matching: .any)
                    .matching(identifier: withParentValue)
                    .containing(.any, identifier: withChildValue).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.className.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.className.strategy)[1])
                let type = XCUIElementTypeTransformer.shared.elementTypeWithTypeName(withParentValue)
                return underElement.descendants(matching: type)
                    .containing(.any, identifier: withChildValue).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.predicate.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.predicate.strategy)[1])
                let formattedPredicate = NSPredicate(format: withParentValue)
                return underElement.descendants(matching: .any)
                    .matching(formattedPredicate)
                    .containing(.any, identifier: withChildValue).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.classChain.strategy) {
                let withParentValue = String(parentLocator.components(separatedBy: By.classChain.strategy)[1])
                return underElement.elementQueryFromClassChain(classChainQuery: withParentValue)
                    .containing(.any, identifier: withChildValue).allElementsBoundByIndex

            } else if parentLocator.starts(with: By.xpath.strategy) {
                AssertFail(message: "xPath not supported in Parent Element")

            } else {
                return underElement.descendants(matching: .any)
                    .matching(identifier: parentLocator)
                    .containing(.any, identifier: withChildValue).allElementsBoundByIndex
            }
        } else {
            AssertFail(message: "Invalid Locator Strategy For Child Element. Child Element should be Find Element Strategy either Predicate or Id. ")
        }
        return [underElement]
    }

    func findSiblingElement(matching siblingLocator: String) -> XCUIElement {
        let anyParentLocator = "class-name=XCUIElementTypeAny"
        let anyParentElement = self.findParentElement(matching: anyParentLocator, indexFromLast: 2)
        return siblingLocator.element(underElement: anyParentElement)
    }
}
