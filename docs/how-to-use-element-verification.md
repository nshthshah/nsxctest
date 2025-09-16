## How to use element verification

Documented APIs from `XCUIElement+Verification.swift`.

### Methods

- `verifyPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyNotPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyNotVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyNotEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifySelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyNotSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyForLabel(withMatching: String, comparisonOperator: StringComparisonOperator = .equals, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyForLabel(withNotMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyForValue(withMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`
- `verifyForValue(withNotMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut) -> Bool`

### Usage

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()
let ok = app.buttons["OK"]

_ = ok.verifyPresent(10)
_ = ok.verifyVisible(5)
_ = ok.verifyEnabled(5)
_ = ok.verifyForLabel(withMatching: "OK")
_ = ok.verifyForValue(withNotMatching: "")
```



