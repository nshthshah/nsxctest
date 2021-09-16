import Foundation

/// Protocol for locators to enforce string representation.
///
/// Locators are nicer way to store and handle `XCUIElement` identifiers or labels.
/// Instead of using String literals as an identifier, the `Locator` object can be used.
///
/// **Example:**
///
/// ```swift
/// app.buttons[Locators.ok]
///
/// enum Locators: String, Locator {
///     case ok = "okButton"
/// }
/// ```
///
public protocol Locator {
    /// :nodoc:
    var identifier: String { get }
}

public extension Locator where Self: RawRepresentable, Self.RawValue == String {
    /// :nodoc:
    var identifier: String {
        LicenseKey.shared.verifyLicenseKey()
        return rawValue
    }
}

/// :nodoc:
public enum AnyLocator: String, Locator {
    case any = "%@"
}
