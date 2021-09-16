import Foundation

// MARK: - System alert protocols
/// Protocol defining system alert allow element.
public protocol SystemAlertAllow: SystemMessages {
    /// Allow messages.
    static var allow: [String] { get }
    /// Allow element.
    var allowElement: XCUIElement? { get }
}

/// Protocol defining system alert deny element.
public protocol SystemAlertDeny: SystemMessages {
    /// Deny messages.
    static var deny: [String] { get }
    /// Deny element.
    var denyElement: XCUIElement? { get }
}

/// Protocol defining system alert ok element.
public protocol SystemAlertOk: SystemMessages {
    /// OK messages.
    static var ok: [String] { get }
    /// OK element.
    var okElement: XCUIElement? { get }
}

/// Protocol defining system alert cancel element.
public protocol SystemAlertCancel: SystemMessages {
    /// Cancel messages.
    static var cancel: [String] { get }
    /// Cancel element.
    var cancelElement: XCUIElement? { get }
}

// MARK: - Default implementation
extension SystemAlertAllow where Self: SystemAlert {
    /// Allow element.
    public var allowElement: XCUIElement? {
        guard let button = alert.buttons.elements(withLabelsMatching: type(of: self).allow).first else {
            AssertFail(message: "Cannot find allow button.")
            return nil
        }

        return button
    }
}

extension SystemAlertDeny where Self: SystemAlert {
    /// Deny element.
    public var denyElement: XCUIElement? {
        guard let button = alert.buttons.elements(withLabelsMatching: type(of: self).deny).first else {
            AssertFail(message: "Cannot find deny button.")
            return nil
        }

        return button
    }
}

extension SystemAlertOk where Self: SystemAlert {
    /// OK element.
    public var okElement: XCUIElement? {
        guard let button = alert.buttons.elements(withLabelsMatching: type(of: self).ok).first else {
            AssertFail(message: "Cannot find ok button.")
            return nil
        }

        return button
    }
}

extension SystemAlertCancel where Self: SystemAlert {
    /// Cancel element.
    public var cancelElement: XCUIElement? {
        guard let button = alert.buttons.elements(withLabelsMatching: type(of: self).cancel).first else {
            AssertFail(message: "Cannot find cancel button.")
            return nil
        }

        return button
    }
}
