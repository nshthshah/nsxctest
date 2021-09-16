import Foundation

func firstNonEmptyValue(_ value1: String?, _ value2: String?) -> String? {
    if value1 != nil && !(value1?.isEmpty ?? true) {
        return value1
    } else {
        return value2
    }
}

/// Properties of XCUIElement
public extension XCElementSnapshot {

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

    func wdValue() -> Any? {
        var value = self.value
        if self.elementType == XCUIElement.ElementType.staticText {
            value = (self.value != nil) ? self.value : self.label
        }
        if self.elementType == XCUIElement.ElementType.button {
            if let temp = self.value {
                if !((temp as? String)?.isEmpty ?? true) {
                    value = self.value
                } else {
                    value = self.isSelected
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

        return value
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

    func wdLabel() -> String? {
        if self.elementType == XCUIElement.ElementType.textField {
            return self.label
        } else if !self.label.isEmpty {
            return self.label
        } else {
            return ""
        }
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
        let name = (firstNonEmptyValue(self.identifier, self.label))
        if !(name?.isEmpty ?? true) {
            return ""
        } else {
            return name
        }
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
        return XCUIElementTypeTransformer.shared.stringWithElementType(self.elementType)
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
        return self.isEnabled
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
        return self.frame.integral
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
        return [
            "x": self.frame.minX,
            "y": self.frame.minY,
            "width": self.frame.width,
            "height": self.frame.height]
    }

    /// Check element is visible
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let button = app.buttons.element
    ///
    /// let button = CL.buttons.element
    /// button.isWDVisible()
    /// ```
    ///

    func isWDVisible() -> Bool {
        if self.frame.isEmpty || self.visibleFrame.isEmpty {
            return false
        }

        if let app = rootElement() as? XCElementSnapshot {
            let screenSize = XCUIDevice.shared.adjustDimensionsForApplication(app.frame.size, XCUIDevice.shared.orientation)
            let screenFrame = CGRect(x: CGFloat(0), y: CGFloat(0), width: CGFloat((screenSize.width)), height: CGFloat((screenSize.height)))

            if !visibleFrame.intersects(screenFrame) {
                return false
            }
        } else {
            return false
        }

        return true
    }

    /// Check element is accessible
    func isWDAccessible() -> Bool {
        if self.elementType == XCUIElement.ElementType.cell {
            if !isAccessibile() {
                if let containerView = children.first as? XCElementSnapshot {
                    if !(containerView.isAccessibile()) {
                        return false
                    }
                } else {
                    return false
                }
            }
        } else if self.elementType != XCUIElement.ElementType.textField && self.elementType != XCUIElement.ElementType.secureTextField {
            if !isAccessibile() {
                return false
            }
        }

        var parentSnapshot: XCElementSnapshot? = parent
        while parentSnapshot != nil {
            if (parentSnapshot?.isAccessibile() ?? false) && parentSnapshot?.elementType != XCUIElement.ElementType.table {
                return false
            }

            parentSnapshot = parentSnapshot?.parent
        }

        return true
    }

    internal func isAccessibile() -> Bool {
        return self.attributeValue(XCAXAIsElementAttribute)?.boolValue ?? false
    }

    internal func attributeValue(_ number: NSNumber) -> AnyObject? {
        let attributesResult = (XCTestXCAXClientProxy.sharedClient() ).attributes(forElement: self, attributes: [number])
        return attributesResult as AnyObject?
    }

}
