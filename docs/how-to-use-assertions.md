## How to use assertions

Assertion helpers that integrate with XCTest to fail fast with descriptive messages.

### Examples

```swift
import XCTest
import NSXCTest

final class ExampleTests: XCTestCase {
    func testWelcome() {
        let app = XCUIApplication()
        app.launch()

        let title = app.staticTexts["Welcome"]
        title.shouldExist(timeout: 10)
        title.shouldBeVisible()
        title.shouldHaveLabel("Welcome")
    }
}
```

### Notes
- Prefer assertion helpers for must-have conditions; they fail the test on unmet expectations.
- For optional checks or branching logic, use verification helpers instead.


