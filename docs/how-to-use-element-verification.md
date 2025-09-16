## How to use element verification

Lightweight verification helpers that read state and return booleans/results without throwing test failures.

### Examples

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()
app.launch()

let ok = app.buttons["OK"]

// Verify existence/visibility quickly
if ok.fb_isVisible() {
    ok.tap()
}

// Verify text
_ = ok.fb_label()

// Verify enabled state
if ok.isWDEnabled() {
    // proceed
}
```

### Notes
- Use verification helpers in control flow; pair with assertion helpers for hard expectations.
- All functions should be safe to call repeatedly, e.g., inside waits.


