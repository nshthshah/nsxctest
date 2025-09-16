import Foundation
import XCTest

public extension XCUIElement {

    /// Wait for an UI element to exist in a view hierarchy.
    /// After given time, if element is not found, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertPresent()
    /// 
    /// CL.helpButton.element.assertPresent()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForPresent(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "present", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element not to exist in a view hierarchy.
    /// After given time, if element is found, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertNotPresent()
    ///
    /// CL.helpButton.element.assertNotPresent()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertNotPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForNotPresent(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notpresent", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element to hittable/visible in a view hierarchy.
    /// After given time, if element is not hittable/visible, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertVisible()
    ///
    /// CL.helpButton.element.assertVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForVisible(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "visible", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element not to hittable/visible in a view hierarchy.
    /// After given time, if element is hittable/visible, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertNotVisible()
    ///
    /// CL.helpButton.element.assertNotVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertNotVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForNotVisible(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notvisible", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element to enabled in a view hierarchy.
    /// After given time, if element is not enabled, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertEnabled()
    ///
    /// CL.helpButton.element.assertEnabled()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForEnabled(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "enabled", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element not to enabled in a view hierarchy.
    /// After given time, if element is enabled, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertNotEnabled()
    ///
    /// CL.helpButton.element.assertNotEnabled()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertNotEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForNotEnabled(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notenabled", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element to selected in a view hierarchy.
    /// After given time, if element is not selected, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertSelected()
    ///
    /// CL.helpButton.element.assertSelected()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForSelected(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "selected", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element not to selected in a view hierarchy.
    /// After given time, if element is selected, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertNotSelected()
    ///
    /// CL.helpButton.element.assertNotSelected()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    func assertNotSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForNotSelected(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notselected", outcome: outcome, locator: self.description)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element `label` matches with `Expected Value` in a view hierarchy.
    /// After given time, if element `label` does not match with `Expected Value`, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertForLabel(withMatching: "Expected Value")
    ///
    /// CL.helpButton.element.assertForLabel(withMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    func assertForLabel(withMatching label: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForLabel(withMatching: label, timeOut: timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "labeled",
                          outcome: outcome,
                          locator: self.description,
                          expected: label,
                          actual: self.label)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element `label` does not match with `Expected Value` in a view hierarchy.
    /// After given time, if element `label` matches `Expected Value`, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertForLabel(withNotMatching: "Expected Value")
    ///
    /// CL.helpButton.element.assertForLabel(withNotMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    func assertForLabel(withNotMatching label: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForLabel(withNotMatching: label, timeOut: timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notlabeled",
                          outcome: outcome,
                          locator: self.description,
                          expected: label,
                          actual: self.label)
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element `value` matches with `Expected Value` in a view hierarchy.
    /// After given time, if element `value` does not match with `Expected Value`, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertForValue(withMatching: "Expected Value")
    ///
    /// CL.helpButton.element.assertForValue(withMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - value: Expected value.
    ///

    func assertForValue(withMatching value: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForValue(withMatching: value, timeOut: timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "value",
                          outcome: outcome,
                          locator: self.description,
                          expected: value,
                          actual: self.value as? String ?? "")
        AssertTrue(outcome: outcome, message: msg)
    }

    /// Wait for an UI element `value` does not match with `Expected Value` in a view hierarchy.
    /// After given time, if element `value` matches `Expected Value`, test fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].assertForValue(withNotMatching: "Expected Value")
    ///
    /// CL.helpButton.element.assertForValue(withNotMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - value: Expected value.
    ///

    func assertForValue(withNotMatching value: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) {
        var outcome = false
        do {
            try waitForValue(withNotMatching: value, timeOut: timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notvalue",
                          outcome: outcome,
                          locator: self.description,
                          expected: value,
                          actual: self.value as? String ?? "")
        AssertTrue(outcome: outcome, message: msg)
    }
}
