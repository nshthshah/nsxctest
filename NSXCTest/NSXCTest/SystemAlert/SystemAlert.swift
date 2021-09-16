import Foundation

/// Provides essential definitions for system alerts giving the ability to handle them in the UI tests.
///
/// **Example:**
///
/// ```swift
/// let token = allowAccess(optional: true, alertClosure: { PushNotificationAlert(element: $0) })
///
/// homePage.goToPermissionsScreen()
/// // Interruption won't happen without some kind of action.
/// if let token = token {
///      removeUIInterruptionMonitor(token)
/// }
/// ```
///
/// Handlers should return `true` if they handled the UI, `false` if they did not.
public protocol SystemAlert: SystemMessages {
    /// Collection of messages possible to receive due to system service request.
    static var messages: [String] { get }
    /// Alert element.
    var alert: XCUIElement { get set }

    // MARK: Initializers
    /// Initialize system alert with interrupting element.
    ///
    /// - note:
    ///   Method returns `nil` if the `element` doesn't represent specified system alert.
    ///
    /// - Parameter element: Interrupting element containing system alert.
    init?(element: XCUIElement)
}
