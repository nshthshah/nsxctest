## How to use waits

Robust waiting strategies built on top of XCTest expectations and polling.

### Examples

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()
app.launch()

// Wait for an element to exist/visible
let login = app.buttons["Login"]
XCTAssertTrue(login.waitForExistence(timeout: 10))

// Using helpers that retry/poll internally
_ = login.fb_waitUntilHittable(timeout: 10)
_ = login.fb_waitUntilInvisible(timeout: 5)
```

### Notes
- Favor condition-based waits over fixed sleeps.
- Combine waits with assertions for clear pass/fail signals.


