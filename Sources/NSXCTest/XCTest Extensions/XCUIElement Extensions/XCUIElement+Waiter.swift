import Foundation
import XCTest

/// :nodoc:
public enum Attribute: String {
    case present = "exists == true"
    case notPresent = "exists == false"

    case visible = "exists == true && hittable == true"
    case notVisible = "hittable == false"

    case enabled = "exists == true && enabled == true"
    case notEnabled = "enabled == false"

    case selected = "exists == true && selected == true"
    case notSelected = "selected == false"

    case label = "exists == true && label == %@"
    case notLabel = "label != %@"

    case value = "exists == true && value == %@"
    case notValue = "value != %@"

    var value: NSPredicate {
        return NSPredicate(format: self.rawValue)
    }

    func value(_ argument: String) -> NSPredicate {
        return NSPredicate(format: self.rawValue, argument)
    }
}

struct NoSuchElement: Error {
    let message: String
}

public extension XCUIElement {

    private func wait(for expectations: [XCTestExpectation], timeOut: TimeInterval) throws {
        var message = ""
        for expectation in expectations {
            message += expectation.expectationDescription + "\n"
        }
        NSLogger.attach(message: message)
        let result = XCTWaiter().wait(for: expectations, timeout: timeOut)
        switch result {
            case .completed: return
            case .timedOut:
                throw NoSuchElement(message: "Timeout: Expectation not fulfilled within \(timeOut)s. \(message)")
            case .incorrectOrder:
                throw NoSuchElement(message: "Incorrect Order: Expectations fulfilled out of order. \(message)")
            case .invertedFulfillment:
                throw NoSuchElement(message: "Inverted Fulfillment: Expected event not to happen, but it did. \(message)")
            case .interrupted:
                throw NoSuchElement(message: "Interrupted: Wait got cut off early. \(message)")
            @unknown default:
                throw NoSuchElement(message: "Unexpected XCTWaiter result. \(message)")
        }
    }

    internal func ensurePresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        let exists = waitForExistence(withTimeout: timeOut)
        if !exists {
            AssertFail(message: "Element Not Present")
        }
    }

    /// Wait for an UI element to exist in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForPresent()
    ///
    /// try? CL.helpButton.element.waitForPresent()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let exists = waitForExistence(withTimeout: timeOut)
        if !exists {
            throw NoSuchElement(message: "Timeout: Expectation not fulfilled within \(timeOut)s.")
        }
    }

    /// Wait for an UI element not to exist in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitNotPresent()
    ///
    /// try? CL.helpButton.element.waitNotPresent()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForNotPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.notPresent.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element to hittable/visible in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForVisible()
    ///
    /// try? CL.helpButton.element.waitForVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.visible.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element not to hittable/visible in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForNotVisible()
    ///
    /// try? CL.helpButton.element.waitForNotVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForNotVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.notVisible.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element to enabled in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForEnabled()
    ///
    /// try? CL.helpButton.element.waitForEnabled()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.enabled.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element not to enabled in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForNotEnabled()
    ///
    /// try? CL.helpButton.element.waitForNotEnabled()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForNotEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.notEnabled.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element to selected in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForSelected()
    ///
    /// try? CL.helpButton.element.waitForSelected()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.selected.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element not to selected in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForNotSelected()
    ///
    /// try? CL.helpButton.element.waitForNotSelected()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func waitForNotSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let expectation = XCTNSPredicateExpectation(predicate: Attribute.notSelected.value,
                                                    object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element `label` matches with `Expected Value` in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForLabel(withMatching: "Expected Value")
    ///
    /// try? CL.helpButton.element.waitForLabel(withMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    func waitForLabel(withMatching text: String,
                      comparisonOperator: StringComparisonOperator = .equals,
                      timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let predicate = NSPredicate(format: "label \(comparisonOperator.rawValue) %@", text)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element `label` does not match with `Expected Value` in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForLabel(withNotMatching: "Expected Value")
    ///
    /// try? CL.helpButton.element.waitForLabel(withNotMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    func waitForLabel(withNotMatching text: String,
                      comparisonOperator: StringComparisonOperator = .notequals,
                      timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let predicate = NSPredicate(format: "label \(comparisonOperator.rawValue) %@", text)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element `label` does not have prefix with `Expected Value` in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForLabel(withPrefixed: "Expected Value")
    ///
    /// try? CL.helpButton.element.waitForLabel(withPrefixed: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    func waitForLabel(withPrefixed text: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        try waitForLabel(withMatching: text, comparisonOperator: .beginsWith, timeOut: timeOut)
    }

    /// Wait for an UI element `value` matches with `Expected Value` in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForValue(withMatching: "Expected Value")
    ///
    /// try? CL.helpButton.element.waitForValue(withMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - value: Expected value.
    ///

    func waitForValue(withMatching value: String,
                      comparisonOperator: StringComparisonOperator = .equals,
                      timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let predicate = NSPredicate(format: "value \(comparisonOperator.rawValue) %@", value)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }

    /// Wait for an UI element `value` does not match with `Expected Value` in a view hierarchy.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// try? app.buttons["appearingButton"].waitForValue(withNotMatching: "Expected Value")
    ///
    /// try? CL.helpButton.element.waitForValue(withNotMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - value: Expected value.
    ///

    func waitForValue(withNotMatching value: String,
                      comparisonOperator: StringComparisonOperator = .notequals,
                      timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws {
        let predicate = NSPredicate(format: "value \(comparisonOperator.rawValue) %@", value)
        let expectation = XCTNSPredicateExpectation(predicate: predicate, object: self)
        try wait(for: [expectation], timeOut: timeOut)
    }
}
