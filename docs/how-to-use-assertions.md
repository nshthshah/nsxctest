## How to use assertions

Documented APIs from `XCUIElement+Assertion.swift`.

### Methods

- `assertPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertNotPresent(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertNotVisible(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertNotEnabled(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertNotSelected(_ timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertForLabel(withMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertForLabel(withNotMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertForValue(withMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut)`
- `assertForValue(withNotMatching: String, timeOut: TimeInterval = XCTestCase.defaultTimeOut)`

### Usage

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()
let title = app.staticTexts["Welcome"]

title.assertPresent(10)
title.assertVisible()
title.assertForLabel(withMatching: "Welcome")
```



