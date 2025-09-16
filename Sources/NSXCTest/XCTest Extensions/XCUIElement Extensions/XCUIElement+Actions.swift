import Foundation
import XCTest

/// :nodoc:
public enum ScrollDirection: Int {
    case up
    case down
    case left
    case right
}

public extension XCUIElement {

    /// Tap on the element.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let button = CL.button.element
    /// button.tap()
    /// ```
    ///

    func tapWithWait() {
        ensurePresent()
        if isHittable {
            tap()
        } else {
            self.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.5)).tap()
        }
    }

    /// Remove text from textField or secureTextField.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textField.element
    /// textField.clearTextField()
    /// ```
    ///

    func clearTextField() {
        ensurePresent()
        let deleteString = self.text.map { _ in XCUIKeyboardKey.delete.rawValue }.joined(separator: "")
        typeText(withText: deleteString)
    }

    /// Type the provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textField.element
    /// textField.typeText(withText: "text")
    /// ```
    ///
    /// - Parameters:
    ///   - text: Text to type.
    ///

    func typeText(withText text: String) {
        ensurePresent()
        if !hasKeyboardFocus {
            app.tap(at: Double(self.frame.size.width + self.frame.origin.x - 20), and: Double(self.frame.origin.y + 10))
        }
        typeText(text)
    }

    /// Remove text from textField and enter new value.
    ///
    /// Useful if there is chance that the element contains text already.
    /// This helper method will execute `clearTextField` and then type the provided string.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textField.element
    /// textField.clear(andType: "text")
    /// ```
    ///
    /// - Parameter:
    ///     - text: Text to type after clearing old value.
    ///

    func clear(andType text: String) {
        clearTextField()
        typeText(withText: text)
    }

    /// Tap on the Return key of the Keyboard if keyboard is focused on the textField.
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textField.element
    /// textField.keyBoardReturnKey()
    /// ```
    ///

    func keyBoardReturnKey() {
        if hasKeyboardFocus {
            typeText(withText: XCUIKeyboardKey.return.rawValue)
        }
    }

    func setValue(_ value: String) {
        ensurePresent()
        if self.elementType == XCUIElement.ElementType.picker {
            NSLogger.attach(message: "setValue, set picker value \(value)")
            self.adjust(toPickerWheelValue: value)

        } else if self.elementType == XCUIElement.ElementType.slider {
            NSLogger.attach(message: "setValue, set slider value \(value)")
            self.adjust(toNormalizedSliderPosition: CGFloat((value as NSString).floatValue))

        } else if self.elementType == XCUIElement.ElementType.textField ||
            self.elementType == XCUIElement.ElementType.textView ||
            self.elementType == XCUIElement.ElementType.secureTextField {
            if self.hasKeyboardFocus != true {
                self.tap()
                self.typeText(value)
            }
        } else {
            AssertFail(message: "\(self.description) failed to set value")
        }
    }

    /// Set the Year, Month and Date of the visible UIDatePicker
    /// **Example:**
    ///
    /// ```swift
    /// let pickerWheel = app.datePickers.element
    ///
    /// let pickerWheel = CL.datePickers.element
    /// pickerWheel.setDate("1978-12-12")
    /// ```
    ///
    /// - Parameters:
    ///   - date: Date should be in String format.
    /// Need to pass date according to the UIDatePicker format used into the Application.
    /// For Example: "1978-Dec-12"
    ///

    func setDate(_ date: String) {
        ensurePresent()
        self.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: String(date.split(separator: "-")[0]))
        self.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: String(date.split(separator: "-")[1]))
        self.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: String(date.split(separator: "-")[2]))
    }

    /// Set the Hours and meridiem of the visible UIDatePicker
    /// **Example:**
    ///
    /// ```swift
    /// let pickerWheel = app.datePickers.element
    ///
    /// let pickerWheel = CL.datePickers.element
    /// pickerWheel.setTime("6:50 PM")
    /// ```
    ///
    /// - Parameters:
    ///   - time: Time should be in String format.
    /// Need to pass Time according to the UIDatePicker format used into the Application.
    /// For Example: "6:00 PM"
    ///

    func setTime(_ time: String, format: String = "hh:mm a") {
        ensurePresent()

        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: time) ?? Date()

        dateFormatter.dateFormat = "h"
        let hour = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "mm"
        let min = dateFormatter.string(from: date)

        dateFormatter.dateFormat = "a"
        let meridiem = dateFormatter.string(from: date)

        self.pickerWheels.element(boundBy: 0).adjust(toPickerWheelValue: hour)
        self.pickerWheels.element(boundBy: 1).adjust(toPickerWheelValue: min)
        self.pickerWheels.element(boundBy: 2).adjust(toPickerWheelValue: meridiem)
    }
}
