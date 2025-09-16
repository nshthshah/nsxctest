import Foundation
import XCTest

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
        waitForScreenToLoad()
    }

    /// Object of `XCUIApplication` of active application.
    public var app: XCUIApplication {
        return XCPlusApp.aut
    }

    /// Object of `Springboard` of active application.
    public var springboardApp: XCUIApplication {
        return XCPlusApp.activeApplication()
    }

    /// Wait for AUT_BUNDLE_ID app becomes active
    public func waitForAUTAppActive(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {

        if let autBundleId = ProcessInfo.processInfo.getValue(forKey: BuildConfig.autBundleId.rawValue) {
            let startTime = Date()

            while Date().timeIntervalSince(startTime) < timeOut {
                let activeApplication = XCPlusApp.activeApplication()
                if activeApplication.bundleID == autBundleId {
                    return
                }
            }
            AssertFail(message: "\(autBundleId) is not active app")
        } else {
            AssertFail(message: "'AUT_BUNDLE_ID' not found!")
        }
    }
}
