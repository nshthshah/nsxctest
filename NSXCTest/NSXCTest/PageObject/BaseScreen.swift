import Foundation

/// Base class for each Page class
///
/// **Example:**
///
/// ```swift
/// import NSXCTest
///
/// class AccountScreen: BaseScreen {
///
///     override func waitForScreenToLoad() {
///         try? app.buttons["home"].waitForPresent()
///         try? CL.homeButton.element.waitForPresent()
///     }
/// }
/// ```

open class BaseScreen {

    /// Must have to override this method.
    open func waitForScreenToLoad() {
        AssertFail(message: "This method must be overriden by the subclass")
    }

    /// :nodoc:
    @discardableResult public required init() {
        LicenseKey.shared.verifyLicenseKey()
        waitForScreenToLoad()
    }

    /// Object of `XCUIApplication` of active application.
    public var app: XCUIApplication {
        return XCPlusApp.activeApplication()
    }
}
