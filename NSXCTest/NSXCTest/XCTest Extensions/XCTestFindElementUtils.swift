import Foundation

enum XCTestWDRoutingError: Error {
    case noSuchUsingMethod
}

extension RawRepresentable where Self.RawValue == String {

    /// Get first matching element.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.element(arguments: ["hello"])
    ///
    /// let label = CL.userNameLabel.element(arguments: ["hello"])
    /// ```
    ///
    public func element(arguments: String...) -> XCUIElement {
        return String(format: self.rawValue, arguments: arguments).element
    }
    
    /// Get first matching element.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.element(arguments: 0)
    ///
    /// let label = CL.userNameLabel.element(arguments: 0)
    /// ```
    ///
    public func element(arguments: Int...) -> XCUIElement {
        return String(format: self.rawValue, arguments: arguments).element
    }

    /// Get list of all the matching elements.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.elements(arguments: ["hello"])
    ///
    /// let label = CL.userNameLabel.elements(arguments: ["hello"])
    /// ```
    ///
    public func elements(arguments: String...) -> [XCUIElement] {
        return String(format: self.rawValue, arguments: arguments).elements
    }

    /// Get first matching element.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.element
    ///
    /// let label = CL.userNameLabel.element
    /// ```
    ///
    public var element: XCUIElement {
        return self.rawValue.element
    }

    /// Get list of all the matching elements.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.elements
    ///
    /// let label = CL.userNameLabel.elements
    /// ```
    ///
    public var elements: [XCUIElement] {
        return self.rawValue.elements
    }
}

internal extension String {

    /// Get first matching element.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.element
    ///
    /// let label = CL.userNameLabel.element
    /// ```
    ///
    var element: XCUIElement {
        LicenseKey.shared.verifyLicenseKey()
        let unnderElement = XCPlusApp.activeApplication()

        if self.starts(with: By.id.strategy) {
            let withValue = String(self.components(separatedBy: By.id.strategy)[1])
            return unnderElement.descendants(matching: .any).matching(identifier: withValue).firstMatch

        } else if self.starts(with: By.className.strategy) {
            let withValue = String(self.components(separatedBy: By.className.strategy)[1])
            let type = XCUIElementTypeTransformer.shared.elementTypeWithTypeName(withValue)
            return unnderElement.descendants(matching: type).firstMatch

        } else if self.starts(with: By.predicate.strategy) {
            let withValue = String(self.components(separatedBy: By.predicate.strategy)[1])
            let formattedPredicate = NSPredicate(format: withValue)
            return unnderElement.descendants(matching: .any).matching(formattedPredicate).firstMatch

        } else if self.starts(with: By.classChain.strategy) {
            let withValue = String(self.components(separatedBy: By.classChain.strategy)[1])
            return unnderElement.descendantsMatchingClassChainQuery(classChainQuery: withValue, returnAfterFirstMatch: true)[0]

        } else if self.starts(with: By.xpath.strategy) {
            let withValue = String(self.components(separatedBy: By.xpath.strategy)[1])
            return unnderElement.descendantsMatchingXPathQuery(xpathQuery: withValue, returnAfterFirstMatch: true)[0]

        } else {
            return unnderElement.descendants(matching: .any).matching(identifier: self).firstMatch
        }
    }

    /// Get list of all the matching elements.
    /// **Example:**
    ///
    /// ```swift
    /// let label = app.userNameLabel.elements
    ///
    /// let label = CL.userNameLabel.elements
    /// ```
    ///
    var elements: [XCUIElement] {
        LicenseKey.shared.verifyLicenseKey()
        let unnderElement = XCPlusApp.activeApplication()

        if self.starts(with: By.id.strategy) {
            let withValue = String(self.components(separatedBy: By.id.strategy)[1])
            return unnderElement.descendants(matching: .any).matching(identifier: withValue).allElementsBoundByIndex

        } else if self.starts(with: By.className.strategy) {
            let withValue = String(self.components(separatedBy: By.className.strategy)[1])
            let type = XCUIElementTypeTransformer.shared.elementTypeWithTypeName(withValue)
            return unnderElement.descendants(matching: type).allElementsBoundByIndex

        } else if self.starts(with: By.predicate.strategy) {
            let withValue = String(self.components(separatedBy: By.predicate.strategy)[1])
            let formattedPredicate = NSPredicate(format: withValue)
            return unnderElement.descendants(matching: .any).matching(formattedPredicate).allElementsBoundByIndex

        } else if self.starts(with: By.classChain.strategy) {
            let withValue = String(self.components(separatedBy: By.classChain.strategy)[1])
            return unnderElement.descendantsMatchingClassChainQuery(classChainQuery: withValue, returnAfterFirstMatch: false)

        } else if self.starts(with: By.xpath.strategy) {
            let withValue = String(self.components(separatedBy: By.xpath.strategy)[1])
            return unnderElement.descendantsMatchingXPathQuery(xpathQuery: withValue, returnAfterFirstMatch: false)

        } else {
            return unnderElement.descendants(matching: .any).matching(identifier: self).allElementsBoundByIndex
        }
    }
}
