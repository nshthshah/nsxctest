## How to use element actions

Documented APIs from `XCUIElement+Actions.swift`.

### Methods

- `tapWithWait()`
- `clearTextField()`
- `typeText(withText text: String)`
- `clear(andType text: String)`
- `keyBoardReturnKey()`
- `setValue(_ value: String)`
- `setDate(_ date: String)`
- `setTime(_ time: String, format: String = "hh:mm a")`

### Usage

```swift
import XCTest
import NSXCTest

let app = XCUIApplication()

let field = app.textFields.element
field.tapWithWait()
field.clearTextField()
field.typeText(withText: "hello")
field.clear(andType: "new value")
field.keyBoardReturnKey()

let slider = app.sliders.element
slider.setValue("0.75")

let picker = app.datePickers.element
picker.setDate("1978-12-12")
picker.setTime("6:50 PM")
```


