import Foundation

public extension XCUIElement {

    /// Wait for an UI element to exist in a view hierarchy.
    /// After given time, if element is not found, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyPresent()
    ///
    /// CL.helpButton.element.verifyPresent()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForPresent(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "present", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element not to exist in a view hierarchy.
    /// After given time, if element is found, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyNotPresent()
    ///
    /// CL.helpButton.element.verifyNotPresent()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyNotPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForNotPresent(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notpresent", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element to hittable/visible in a view hierarchy.
    /// After given time, if element is not hittable/visible, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyVisible()
    ///
    /// CL.helpButton.element.verifyVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForVisible(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "visible", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element not to hittable/visible in a view hierarchy.
    /// After given time, if element is hittable/visible, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyNotVisible()
    ///
    /// CL.helpButton.element.verifyNotVisible()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyNotVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForNotVisible(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notvisible", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element to enabled in a view hierarchy.
    /// After given time, if element is not enabled, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyEnabled()
    ///
    /// CL.helpButton.element.verifyEnabled()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForEnabled(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "enabled", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element not to enabled in a view hierarchy.
    /// After given time, if element is enabled, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyNotEnabled()
    ///
    /// CL.helpButton.element.verifyNotEnabled()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyNotEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForNotEnabled(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notenabled", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element to selected in a view hierarchy.
    /// After given time, if element is not selected, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifySelected()
    ///
    /// CL.helpButton.element.verifySelected()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifySelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForSelected(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "selected", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element not to selected in a view hierarchy.
    /// After given time, if element is selected, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyNotSelected()
    ///
    /// CL.helpButton.element.verifyNotSelected()
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///

    @discardableResult
    func verifyNotSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForNotSelected(timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "notselected", outcome: outcome, locator: self.description)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element `label` matches with `Expected Value` in a view hierarchy.
    /// After given time, if element `label` does not match with `Expected Value`, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyForLabel(withMatching: "Expected Value")
    ///
    /// CL.helpButton.element.verifyForLabel(withMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    @discardableResult
    func verifyForLabel(withMatching label: String, comparisonOperator: StringComparisonOperator = .equals, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
        var outcome = false
        do {
            try waitForLabel(withMatching: label, comparisonOperator:comparisonOperator, timeOut: timeOut)
            outcome = true
        } catch {
            outcome = false
        }

        let msg = Message.message(forOperation: "labeled",
                          outcome: outcome,
                          locator: self.description,
                          expected: label,
                          actual: self.label)
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element `label` does not match with `Expected Value` in a view hierarchy.
    /// After given time, if element `label` matches `Expected Value`, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyForLabel(withNotMatching: "Expected Value")
    ///
    /// CL.helpButton.element.verifyForLabel(withNotMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - label: Expected label value.
    ///

    @discardableResult
    func verifyForLabel(withNotMatching label: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
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
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element `value` matches with `Expected Value` in a view hierarchy.
    /// After given time, if element `value` does not match with `Expected Value`, test case will continue with next step and
    /// after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyForValue(withMatching: "Expected Value")
    ///
    /// CL.helpButton.element.verifyForValue(withMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - value: Expected value.
    ///

    @discardableResult
    func verifyForValue(withMatching value: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
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
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }

    /// Wait for an UI element `value` does not match with `Expected Value` in a view hierarchy.
    /// After given time, if element `value` matches `Expected Value`, test case will continue with next step and after the completion of the test case fails.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.buttons["appearingButton"].verifyForValue(withNotMatching: "Expected Value")
    ///
    /// CL.helpButton.element.verifyForValue(withNotMatching: "Expected Value")
    /// ```
    ///
    /// - Parameters:
    ///   - timeOut: Waiting time in seconds (default: 60 seconds).
    ///   - value: Expected value.
    ///

    @discardableResult
    func verifyForValue(withNotMatching value: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool {
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
        XCTestCase.currentTestCase?.continueAfterFailure = true
        AssertTrue(outcome: outcome, message: msg)
        XCTestCase.currentTestCase?.continueAfterFailure = false
        return outcome
    }
}
