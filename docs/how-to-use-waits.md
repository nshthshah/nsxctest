## How to use waits

Documented APIs from `XCUIElement+Waiter.swift`.

### Methods

- `waitForPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForNotPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForNotVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForNotEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForNotSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForLabel(withMatching: String, comparisonOperator: StringComparisonOperator = .equals, timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForLabel(withNotMatching: String, comparisonOperator: StringComparisonOperator = .notequals, timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForLabel(withPrefixed: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForValue(withMatching: String, comparisonOperator: StringComparisonOperator = .equals, timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`
- `waitForValue(withNotMatching: String, comparisonOperator: StringComparisonOperator = .notequals, timeOut: TimeInterval = XCTestCase.defaultTimeOut) throws`

### Usage

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()
let login = app.buttons["Login"]

try? login.waitForPresent(10)
try? login.waitForVisible(5)
try? login.waitForEnabled(5)
try? login.waitForLabel(withMatching: "Login")
```



