## How to use element properties

Helpers that expose convenient properties for `XCUIElement` and related snapshots.

### Examples

```swift
import XCTest
import NSXCTest

let element = XCUIApplication().buttons["Continue"]

// Read common attributes safely
let label = element.label
let isEnabled = element.isEnabled
let isVisible = element.isWDVisible?() ?? element.exists

// Access geometry
let rect = element.frame
let x = rect.origin.x
let width = rect.size.width

// Snapshot-based info (if available in your target)
_ = element.checkLastSnapShot()
```

### Notes
- Some helpers rely on accessibility snapshots available only during UI tests.
- Prefer using these computed properties over ad-hoc sleeps; they are designed to be safe with waits.


