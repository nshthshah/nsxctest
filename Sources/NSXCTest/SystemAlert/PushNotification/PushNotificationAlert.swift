import Foundation

public protocol PushNotificationAlertAllow: SystemAlertAllow { }

extension PushNotificationAlertAllow {

    /// Represents all possible "allow" buttons in PushNotification permission view.
    public static var allow: [String] {
        return readMessages()
    }
}

public protocol PushNotificationAlertDeny: SystemAlertDeny { }

extension PushNotificationAlertDeny {

    /// Represents all possible "deny" buttons in PushNotification permission view.
    public static var deny: [String] {
        return readMessages(from: "PushNotificationAlertDeny")
    }
}

public struct PushNotificationAlert: SystemAlert, PushNotificationAlertAllow, PushNotificationAlertDeny {

    /// Represents all possible messages in `PushNotificationAlert` service alert.
    public static let messages = readMessages()

    /// System service alert element.
    public var alert: XCUIElement

    /// Initialize `PushNotificationAlert` with alert element.
    ///
    /// - Parameter element: An alert element.
    public init?(element: XCUIElement) {
        guard element.staticTexts.elements(withLabelsLike: type(of: self).messages).first != nil else {
            return nil
        }

        self.alert = element
    }
}

public func allowAccess(optional: Bool = false, alertClosure: @escaping (XCUIElement) -> SystemAlertAllow?) -> NSObjectProtocol? {

    if let currentTestCase = XCTestCase.currentTestCase {

        return currentTestCase.addUIInterruptionMonitor(withDescription: "Access request.") { alert -> Bool in
            guard let alertView = alertClosure(alert) else {
                if !optional {
                    AssertFail(message: "Cannot create Allow System Alert object.")
                }
                return false
            }
            alertView.allowElement?.tapWithWait()
            return true
        }
    }
    return nil
}

public func denyAccess(optional: Bool = false, alertClosure: @escaping (XCUIElement) -> SystemAlertDeny?) -> NSObjectProtocol? {

    if let currentTestCase = XCTestCase.currentTestCase {

        return currentTestCase.addUIInterruptionMonitor(withDescription: "Deny Access request.") { alert -> Bool in
            guard let alertView = alertClosure(alert) else {
                if !optional {
                    AssertFail(message: "Cannot create Deny System Alert object.")
                }
                return false
            }
            alertView.denyElement?.tapWithWait()
            return true
        }
    }
    return nil
}
