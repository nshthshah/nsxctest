import Foundation

public extension NSObject {

    /*func dumpProperties() {
        var outCount: UInt32 = 0

        let properties = class_copyPropertyList(type(of: self), &outCount)
        for index in 0...outCount {
            guard let property = properties?[Int(index)] else {
                continue
            }
            let propertyName = String(cString: property_getName(property))
            guard let propertyAttributes = property_getAttributes(property) else {
                continue
            }
            let propertyType = String(cString: propertyAttributes)
            print("\(propertyName): \(propertyAttributes) || \(propertyType)")
        }
    }*/

    /// Get property value.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let userNameLabel = CL.userNameLabel.element
    /// userNameLabel.getPropertyName("value")
    /// ```
    /// - Parameters:
    ///   - propertyName: Name of property
    /// - Returns: `Any`
    ///

    func getPropertyName(_ propertyName: String) -> Any? {
        guard let value = self.value(forKey: propertyName) else {
            return nil
        }
        return value
    }
}
