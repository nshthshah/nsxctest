import Foundation

private enum ElementProperty: String {
    case hasKeyboardFocus

    var value: String {
        return self.rawValue
    }
}

public extension XCUIElement {

    /// Indicates if the element is currently visible on the screen.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let button = app.buttons.element
    ///
    /// let button = CL.helpButton.element
    ///
    /// XCTAssertTrue(button.isVisible)
    /// ```
    ///

    var isVisible: Bool {
        let returnValue = exists && isHittable
        NSLogger.info(message: String(returnValue))
        return returnValue
    }

    /// Returns `value` as a String
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textField.element
    /// let text = textField.text
    /// ```
    ///
    /// - note:
    /// It will fail if `value` is not a `String` type.
    ///

    var text: String {
        guard let text = value as? String else {
            return ""
        }
        NSLogger.info(message: text)
        return text
    }

    /// Indicates if the keyboard is focused on element.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    ///
    /// XCTAssertTrue(textField.hasKeyboardFocus)
    /// ```
    ///

    var hasKeyboardFocus: Bool {
        let returnValue = (self.getPropertyName(ElementProperty.hasKeyboardFocus.value) as? Bool) ?? false
        NSLogger.info(message: String(returnValue))
        return returnValue
    }

    /// Get value of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.wdValue()
    /// ```
    ///

    func wdValue() -> Any {
        var value = self.value
        if self.elementType == XCUIElement.ElementType.staticText {
            value = self.value != nil ? self.value : self.label
        }
        if self.elementType == XCUIElement.ElementType.button {
            if let temp = self.value {
                if String(describing: temp).isEmpty {
                    value = self.isSelected
                } else {
                    value = self.value
                }
            } else {
                value = self.isSelected
            }
        }
        if self.elementType == XCUIElement.ElementType.switch {
            if let val = value as? NSString {
                value = val.doubleValue > 0
            } else {
                value = false
            }
        }
        if self.elementType == XCUIElement.ElementType.textField ||
            self.elementType == XCUIElement.ElementType.textView ||
            self.elementType == XCUIElement.ElementType.secureTextField {
            if let temp = self.value {
                if let str = temp as? String {
                    if !str.isEmpty {
                        value = self.value
                    } else {
                        value = self.placeholderValue
                    }
                } else {
                    value = self.value
                }
            } else {
                value = self.placeholderValue
            }
        }

        NSLogger.info(message: value as? String ?? "")
        return value as Any
    }

    /// Get label of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.wdLabel()
    /// ```
    ///

    func wdLabel() -> String {
        var returnValue = ""
        if self.elementType == XCUIElement.ElementType.textField {
            returnValue = self.label
        } else if !self.label.isEmpty {
            returnValue = self.label
        }
        NSLogger.info(message: returnValue)
        return returnValue
    }

    /// Get name of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.wdName()
    /// ```
    ///

    func wdName() -> String? {
        var returnValue: String?
        let name = firstNonEmptyValue(self.identifier, self.label)

        if name?.isEmpty ?? true {
            returnValue = nil
        } else {
            returnValue = name
        }
        NSLogger.info(message: returnValue ?? "")
        return returnValue
    }

    /// Get type of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.wdType()
    /// ```
    ///

    func wdType() -> String {
        let returnValue = XCUIElementTypeTransformer.shared.stringWithElementType(self.elementType)
        NSLogger.info(message: returnValue)
        return returnValue
    }

    /// Check element is enabled
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let button = app.buttons.element
    ///
    /// let button = CL.buttons.element
    /// button.isWDEnabled()
    /// ```
    ///

    func isWDEnabled() -> Bool {
        let returnValue = self.isEnabled
        NSLogger.info(message: String(returnValue))
        return returnValue
    }

    /// Get frame of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.wdFrame()
    /// ```
    ///

    func wdFrame() -> CGRect {
        let returnValue = self.frame.integral
        NSLogger.info(message: returnValue.debugDescription)
        return returnValue
    }

    /// Get rect of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.wdRect()
    /// ```
    ///

    func wdRect() -> [String: CGFloat] {
        let returnValue = [
            "x": self.frame.minX,
            "y": self.frame.minY,
            "width": self.frame.width,
            "height": self.frame.height]
        NSLogger.info(message: returnValue.debugDescription)
        return returnValue
    }

    /// Check last snapshot
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.checkLastSnapShot()
    /// ```
    ///

    func checkLastSnapShot() -> XCElementSnapshot {
        NSLogger.info()
        self.fb_nativeResolve()
        return self.fb_lastSnapshot()
    }

    /// Check custom value of element
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let textField = app.textFields.element
    ///
    /// let textField = CL.textFields.element
    /// textField.customValue(forKey: "name")
    /// ```
    ///

    func customValue(forKey key: String) -> Any {
        NSLogger.info()
        if key.lowercased().contains("enable") {
            return self.isEnabled
        } else if key.lowercased().contains("name") {
            return self.wdName() ?? ""
        } else if key.lowercased().contains("value") {
            return self.wdValue()
        } else if key.lowercased().contains("label") {
            return self.wdLabel()
        } else if key.lowercased().contains("type") {
            return self.wdType()
        } else if key.lowercased().contains("visible") {
            return self.fb_lastSnapshot().isWDVisible()
        } else if key.lowercased().contains("access") {
            return self.fb_lastSnapshot().isAccessibile()
        }
        return ""
    }
}
