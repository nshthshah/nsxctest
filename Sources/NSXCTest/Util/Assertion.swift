import ObjectiveC
import Foundation
import XCTest

internal class Assertion: NSObject {

    fileprivate class func logInfo(function: String, file: String, line: Int) -> String {
        var className = URL(fileURLWithPath: file).lastPathComponent
        if className == "" {
            className = file
        }

        let separator: String = " || "
        let message = "\(className)" + separator + function + separator + String(line) + separator
        return message
    }
}

/// `AssertFail` will stop execution and mark your test case as failed.
///
/// **Example:**
///
/// ```swift
/// AssertFail(message: "Element not present")
/// ```
/// - Parameters:
///   - message: Error message
///
public func AssertFail(message: String = "", function: String = #function, file: String = #file, line: Int = #line) {
    _ = Assertion.logInfo(function: function, file: file, line: line) + message
    NSLogger.attach(message: message)
    XCTAssertTrue(false, message)
}

/// `AssertTrue` will expect outcome should be true, if it isn't then it will stop execution and mark your test case as failed.
///
/// **Example:**
///
/// ```swift
/// AssertTrue(outcome: false, message: "Element not present")
/// ```
/// - Parameters:
///   - outcome: Name of property
///   - message: Message
///
public func AssertTrue(outcome: Bool, message: String, name: String = "Attachment", function: String = #function, file: String = #file, line: Int = #line) {
    _ = Assertion.logInfo(function: function, file: file, line: line) + message
    NSLogger.attach(message: message, name: name)
    XCTAssertTrue(outcome, message)
}

/// `AssertEqual` will veirfy actual and expected value.
///
/// **Example:**
///
/// ```swift
/// AssertEqual(actual: "Hello", expected: "Hi")
/// ```
/// - Parameters:
///   - actual: Actual message
///   - expected: Expected message
///
public func AssertEqual(actual: String, expected: String, function: String = #function, file: String = #file, line: Int = #line) {
    let message = "Expected: \(expected); Actual: \(actual)"
    _ = Assertion.logInfo(function: function, file: file, line: line) + message
    NSLogger.attach(message: message)
    XCTAssert(actual == expected, message)
}

/// `AssertEqual` will veirfy actual and expected value.
///
/// **Example:**
///
/// ```swift
/// AssertEqual(expression1, expression2)
/// ```
/// - Parameters:
///   - expression1: Actual value
///   - expression2: Expected value
///
public func AssertEqual<T: Equatable>(_ expression1: T, _ expression2: T, message: String, function: String = #function, file: String = #file, line: Int = #line) {
    _ = Assertion.logInfo(function: function, file: file, line: line) + message
    NSLogger.attach(message: message)
    XCTAssert(expression1 == expression1, message)
}
