import Foundation

public extension XCUIElement {

    /// Get Page Source
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.tree()
    /// ```
    ///

    func tree() -> JsonType? {
        self.fb_nativeResolve()
        return dictionaryForElement(self.fb_lastSnapshot())
    }

    /// Get Element Description
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.digest(windowName: "Main Window")
    /// ```
    ///

    func digest(windowName: String) -> String {

        let description = """
        \(windowName)_
        \(self.buttons.count)_
        \(self.textViews.count)_
        \(self.textFields.count)_
        \(self.otherElements.count)_
        \(self.descendants(matching: .any).count)_
        \(self.traits())
        """

        return description
    }

    /// Get accessibility tree
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.accessibilityTree()
    /// ```
    ///

    func accessibilityTree() -> JsonType? {
        self.fb_nativeResolve()
        _ = self.query

        return accessibilityInfoForElement(self.fb_lastSnapshot())
    }

    /// Get Element Information
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.dictionaryForElement(app.textFields.element)
    /// ```
    ///

    func dictionaryForElement(_ snapshot: XCElementSnapshot) -> JsonType? {
        var info = JsonType()
        info["type"] = XCUIElementTypeTransformer.shared.shortStringWithElementType(snapshot.elementType) as AnyObject?
        info["rawIndentifier"] = (!snapshot.identifier.isEmpty ? snapshot.identifier : "") as AnyObject
        info["name"] = snapshot.wdName() as AnyObject? ?? "" as AnyObject
        info["value"] = snapshot.wdValue() as AnyObject? ?? "" as AnyObject
        info["label"] = snapshot.wdLabel() as AnyObject? ?? "" as AnyObject
        info["rect"] = snapshot.wdRect() as AnyObject
        info["frame"] = NSCoder.string(for: snapshot.wdFrame()) as AnyObject
        info["isEnabled"] = snapshot.isWDEnabled() as AnyObject
        info["isVisible"] = snapshot.isWDVisible() as AnyObject

        // If block is not visible, return
        if info["isVisible"] as? Bool == false {
            return nil
        }

        // If block is visible, iterate through all its children
        if let childrenElements = snapshot.children {
            var children = [AnyObject]()
            for child in childrenElements {
                if let childSnapshot = child as? XCElementSnapshot,
                    let temp = dictionaryForElement(childSnapshot) {
                    children.append(temp as AnyObject)
                }
            }

            if !children.isEmpty {
                info["children"] = children as AnyObject
            }
        }

        return info
    }

    /// Get Element accessibility information
    ///
    /// **Example:**
    ///
    /// ```swift
    /// app.dictionaryForElement(app.textFields.element)
    /// ```
    ///

    func accessibilityInfoForElement(_ snapshot: XCElementSnapshot) -> JsonType? {
        let isAccessible = snapshot.isWDAccessible()
        let isVisible = snapshot.isWDVisible()

        var info = JsonType()

        if isAccessible {
            if isVisible {
                info["value"] = snapshot.wdValue as AnyObject
                info["label"] = snapshot.wdLabel as AnyObject
            }
        } else {
            var children = [AnyObject]()
            if let childrenElements = snapshot.children {
                for child in childrenElements {
                    if let childSnapshot = child as? XCElementSnapshot,
                        let childInfo: JsonType = self.accessibilityInfoForElement(childSnapshot) {
                        if !childInfo.keys.isEmpty {
                            children.append(childInfo as AnyObject)
                        }
                    }
                }

                if !children.isEmpty {
                    info["children"] = children as AnyObject
                }
            }
        }

        return info
    }
}
