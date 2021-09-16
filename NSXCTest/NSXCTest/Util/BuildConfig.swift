import Foundation

public enum BuildConfig: String {

    case autBundleId
    case licenseKey
    case any

    /// Get value
    public var value: String? {
        return self.value(key: self.rawValue)
    }

    /// Get list value
    public var list: [String] {
        return self.list(key: self.rawValue)
    }

    /// Check key is exists
    public var isExists: Bool {
        return self.isExists(key: self.rawValue)
    }

    /// Get value for key
    public func value(key: String) -> String? {
        let buildConfigsInfo = Bundle.xctrunnerBundle.buildConfigInfo()
        return buildConfigsInfo[key] as? String
    }

    /// Get list value for key
    public func list(key: String) -> [String] {
        let buildConfigsInfo = Bundle.xctrunnerBundle.buildConfigInfo()
        return buildConfigsInfo[key] as? [String] ?? []
    }

    /// Check key is exists
    public func isExists(key: String) -> Bool {
        let buildConfigsInfo = Bundle.xctrunnerBundle.buildConfigInfo()
        if buildConfigsInfo[key] != nil {
            return true
        }
        return false
    }
}
