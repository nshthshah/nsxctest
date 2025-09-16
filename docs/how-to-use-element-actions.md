## How to use element actions

Utilities extending `XCUIElement` to make interactions more reliable in UI tests.

### Types

```swift
public enum ScrollDirection: Int {
    case up
    case down
    case left
    case right
}
```

### API

#### tapWithWait()
Tap an element after ensuring it exists; falls back to center‑coordinate tap if not hittable.

```swift
let button = app.buttons["Continue"]
button.tapWithWait()
```

#### clearTextField()
Clears a text/secure text field by sending delete keys.

```swift
app.textFields.element.clearTextField()
```

#### typeText(withText: String)
Types into an element. If needed, sets keyboard focus first.

```swift
app.textFields.element.typeText(withText: "hello")
```

#### clear(andType: String)
Clears then types text.

```swift
app.textFields.element.clear(andType: "new value")
```

#### keyBoardReturnKey()
If the element has keyboard focus, taps the Return key.

```swift
app.textFields.element.keyBoardReturnKey()
```

#### setValue(_ value: String)
Sets values for pickers, sliders, or types into text fields; otherwise fails.

```swift
app.sliders.element.setValue("0.75")
```

#### setDate(_ date: String)
Sets date on a visible `UIDatePicker` using a `YYYY-MM-DD` or app‑specific format.

```swift
app.datePickers.element.setDate("1978-12-12")
```

#### setTime(_ time: String, format: String = "hh:mm a")
Sets time on a visible `UIDatePicker`. Default expects formats like `6:50 PM`.

```swift
app.datePickers.element.setTime("6:50 PM")
```

### Notes
- These helpers assume a running `XCUIApplication()` assigned to `app` within scope where referenced.
- Use with iOS 13+ under XCTest UI test targets.


