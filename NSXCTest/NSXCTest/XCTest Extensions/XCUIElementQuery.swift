/// Represents available string comparison operations to perform with `NSPredicate` API.
///
/// Enum value describing NSPredicate string comparison operator.
///
/// - `equals`: `==` operator
/// - `beginsWith`: `BEGINSWITH` operator
/// - `contains`: `CONTAINS` operator
/// - `endsWith`: `ENDSWITH` operator
/// - `like`: `LIKE` operator
/// - `matches`: `MATCHES` operator
/// - `other`: Custom operator

/// :nodoc:
public enum StringComparisonOperator: RawRepresentable {
     /// `==` operator
    case equals

    /// `!=` operator
    case notequals

    /// `BEGINSWITH` operator
    case beginsWith

    /// `CONTAINS` operator
    case contains

    /// `ENDSWITH` operator
    case endsWith

    /// `LIKE` operator
    case like

    /// `MATCHES` operator
    case matches

    /// Custom string operator.
    case other(comparisonOperator: String)

    /// String representation of the `self`.
    public var rawValue: String {
        switch self {
        case .equals: return "=="
        case .notequals: return "!="
        case .beginsWith: return "BEGINSWITH"
        case .contains: return "CONTAINS"
        case .endsWith: return "ENDSWITH"
        case .like: return "LIKE"
        case .matches: return "MATCHES"
        case .other(let comparisonOperator): return comparisonOperator
        }
    }

    /// Initialize comparison operator with string.
    ///
    /// - Parameter rawValue: String to use. If it doesn't match any preexisting cases, it will be parsed as `.other`.
    public init(rawValue: String) {
        switch rawValue {
        case "==": self = .equals
        case "!=": self = .notequals
        case "BEGINSWITH": self = .beginsWith
        case "CONTAINS": self = .contains
        case "ENDSWITH": self = .endsWith
        case "LIKE": self = .like
        case "MATCHES": self = .matches
        default: self = .other(comparisonOperator: rawValue)
        }
    }
}

// MARK: - Element Label Methods
public extension XCUIElementQuery {

    /// Returns element with label matching provided string.
    ///
    /// - note:
    /// String matching is customizable with operators available in `NSPredicate` specification.
    /// Check the `StringComparisonOperator` for available options.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelMatching: "NSXCTest*", comparisonOperator: .like)
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameters:
    ///   - text: String to search for.
    ///   - comparisonOperator: Operation to use when performing comparison.
    /// - Returns: `XCUIElement` that label matches to given text.
    ///
    func element(withLabelMatching text: String, comparisonOperator: StringComparisonOperator = .matches) -> XCUIElement {
        return element(matching: NSPredicate(format: "label \(comparisonOperator.rawValue) %@", text))
    }

    /// Returns element with label which equals to provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelEqualTo: "NSXCTest")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withLabelEqualTo text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .equals)
    }

    /// Returns element with label which does not equal to provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelNotEqualTo: "NSXCTest")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withLabelNotEqualTo text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .notequals)
    }

    /// Returns element with label which begins with provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelBeginsWith: "NSXCTest")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withLabelBeginsWith text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .beginsWith)
    }

    /// Returns element with label which contains provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelContaining: "NSXCTest")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withLabelContaining text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .contains)
    }

    /// Returns element with label which ends with provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelEndsWith: "NSXCTest")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withLabelEndsWith text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .endsWith)
    }

    /// Returns element with label which `like` provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withLabelLike: "NSXCTest")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter text: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withLabelLike text: String) -> XCUIElement {
        return element(withLabelMatching: text, comparisonOperator: .like)
    }
}

// MARK: - Elements Label Methods
public extension XCUIElementQuery {

    /// Returns array of existing elements matching given labels.
    ///
    /// Can be used when looking for an element which label can match to one from many texts.
    ///
    /// - note:
    /// String matching is customizable with operators available in `NSPredicate` specification.
    /// Check the `StringComparisonOperator` for available options.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let texts = ["Ok", "Done", "Go"]
    /// let elements = app.buttons.elements(withLabelsMatching: texts, comparisonOperator: .equals)
    /// ```
    ///
    /// - Parameters:
    ///   - texts: List of labels.
    ///   - comparisonOperator: Operation to use when performing comparison.
    /// - Returns: Array of `XCUIElement` elements.
    func elements(withLabelsMatching texts: [String], comparisonOperator: StringComparisonOperator = .equals) -> [XCUIElement] {
        return texts
            .compactMap({ element(withLabelMatching: $0, comparisonOperator: comparisonOperator) })
            .filter { $0.exists }
    }

    /// Returns array of existing elements containing given labels.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let texts = ["Ok", "Done", "Go"]
    /// let elements = app.buttons.elements(withLabelsContaining: texts)
    /// ```
    ///
    /// - Parameter texts: List of labels.
    /// - Returns: Array of `XCUIElement` elements.
    func elements(withLabelsContaining texts: [String]) -> [XCUIElement] {
        return elements(withLabelsMatching: texts, comparisonOperator: .contains)
    }

    /// Returns array of existing elements `like` given labels.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let texts = ["Ok", ".*Done", "Go"]
    /// let elements = app.buttons.elements(withLabelsLike: texts)
    /// ```
    ///
    /// - Parameter texts: List of labels.
    /// - Returns: Array of `XCUIElement` elements.
    func elements(withLabelsLike texts: [String]) -> [XCUIElement] {
        return elements(withLabelsMatching: texts, comparisonOperator: .like)
    }
}

// MARK: - Identifier Methods
public extension XCUIElementQuery {

    /// Returns element with identifier matching provided string.
    ///
    /// - note:
    /// String matching is customizable with operators available in `NSPredicate` specification.
    /// Check the `StringComparisonOperator` for available options.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withIdMatching: "NSXCTest*", comparisonOperator: .like)
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameters:
    ///   - id: String to search for.
    ///   - comparisonOperator: Operation to use when performing comparison.
    /// - Returns: `XCUIElement` that id matches to given text.
    ///
    func element(withIdMatching id: String, comparisonOperator: StringComparisonOperator = .matches) -> XCUIElement {
        return element(matching: NSPredicate(format: "identifier \(comparisonOperator.rawValue) %@", id))
    }

    /// Returns element with identifier which `like` provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let text = app.staticTexts.element(withIdLike: "NSXCTest*")
    /// XCTAssertTrue(text.exists)
    /// ```
    ///
    /// - Parameter id: String to search for.
    /// - Returns: `XCUIElement` that label begins with given text.
    ///
    func element(withIdLike id: String) -> XCUIElement {
        return element(withIdMatching: id, comparisonOperator: .like)
    }
}

// MARK: - Locator methods
public extension XCUIElementQuery {

    /// Returns `XCUIElement` that matches the type and locator.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let button = app.buttons[Locators.ok]
    /// ```
    ///
    /// - Parameter locator: `Locator` used to find element
    /// - Returns: `XCUIElement` matches with given `Locator`
    ///
    subscript(locator: Locator) -> XCUIElement {
        return self[locator.identifier]
    }
}

// MARK: - Attribute Methods
public extension NSPredicate {

    /// Create dynamic predicate to locate element.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// NSPredicate.predicate(withAttributeMatching: "label", value: "NSXCTest", labelComparisonOperator: .equals)
    /// ```
    ///
    /// - Parameters:
    ///   - attribute: attribute key
    ///   - value: Expected value
    ///   - labelComparisonOperator: Comparison Operator
    /// - Returns: `XCUIElement` that label matches to given text.
    ///
    class func predicate(withAttributeMatching attribute: String, value: String, labelComparisonOperator: StringComparisonOperator = .equals) -> NSPredicate {
        return NSPredicate(format: "\(attribute ) \(labelComparisonOperator.rawValue) '\(value)'")
    }
}
