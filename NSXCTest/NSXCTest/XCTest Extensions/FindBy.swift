@available(swift, introduced: 5.1, message: "Available in Swift 5.1 and later")
@propertyWrapper
public struct FindBy {
    public var locator: String

    public init(_ locator: Locator) {
        self.locator = locator.identifier
    }

    public init(_ locator: String) {
        self.locator = locator
    }

    public var wrappedValue: XCUIElement {
        self.locator.element
    }
}

internal enum By: String {
    case id = "id"
    case name = "name"
    case accessibilityId = "accessibility id"
    case className = "class-name"
    case predicate = "predicate"
    case classChain = "class-chain"
    case xpath = "xpath"

    var value: String {
        return self.rawValue
    }

    var strategy: String {
        return self.value + "="
    }
}
