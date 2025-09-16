## How to use element properties

Documented APIs from `XCUIElement+Property.swift`.

### Properties

- `isVisible: Bool`
- `isReallyVisible: Bool`
- `text: String`
- `hasKeyboardFocus: Bool`

### Methods

- `wdValue() -> Any`
- `wdLabel() -> String`
- `wdName() -> String?`
- `wdType() -> String`
- `isWDEnabled() -> Bool`
- `wdFrame() -> CGRect`
- `wdRect() -> [String: CGFloat]`
- `checkLastSnapShot() -> XCElementSnapshot`
- `customValue(forKey key: String) -> Any`
- `hasValidHitPoint() -> Bool`

### Usage

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()
let field = app.textFields.element

// Properties
_ = field.isVisible
_ = field.isReallyVisible
_ = field.text
_ = field.hasKeyboardFocus

// Methods
_ = field.wdValue()
_ = field.wdLabel()
_ = field.wdName()
_ = field.wdType()
_ = field.isWDEnabled()
_ = field.wdFrame()
_ = field.wdRect()
_ = field.checkLastSnapShot()
_ = field.customValue(forKey: "label")
_ = field.hasValidHitPoint()
```



