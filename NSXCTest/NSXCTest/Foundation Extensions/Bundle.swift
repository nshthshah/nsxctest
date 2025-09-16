import Foundation

/// :nodoc:
public enum FileExtension: String {
    case json
    case plist
}

public extension Bundle {

    /// `Info.plist` key
    enum InfoItemType: String {
        /// BuildConfigurations
        case configuration = "BuildConfigurations"
        /// CFBundleVersion
        case bundleVersion = "CFBundleVersion"
        /// CFBundleName
        case bundleName = "CFBundleName"
        /// CFBundleExecutable
        case namespace = "CFBundleExecutable"
        /// CFBundleShortVersionString
        case shortBundleVersion = "CFBundleShortVersionString"
    }

    class internal var nsxctestFrameworkBundle: Bundle {
        guard let bundle = Bundle(identifier: "com.nsxctest.NSXCTest") else {
            return Bundle.main
        }
        return bundle
    }

    /// Get `Bundle` of Test Runner application
    class var xctrunnerBundle: Bundle {
        guard let bundleId = Bundle.main.bundleIdentifier,
            let bundle = Bundle(identifier: bundleId.replacingOccurrences(of: ".xctrunner", with: "")) else {
            return Bundle.main
        }
        return bundle
    }

    private func infoValueOfType<T>(for key: InfoItemType) -> T? {

        // unwrap info dict
        guard let infoDict = infoDictionary else { return nil }

        // unwrap type
        guard let value = infoDict[key.rawValue] as? T else { return nil }

        return value
    }

    /// Get Build Configurations
    func buildConfigInfo() -> JsonType {
        if let value: JsonType = infoValueOfType(for: .configuration) {
            return value as JsonType
        }
        return ["": ""] as JsonType
    }

    /// String value from build config
    func stringInfoValue(for key: InfoItemType) -> String {

        if let value: String = infoValueOfType(for: key) {
            return value
        }
        return ""
    }

    /// Get JSON value from Json file
    func loadJsonData(file: String) -> JsonType? {

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: bundleURL,
                                                                                includingPropertiesForKeys: nil,
                                                                                options: [])
            let jsonFile = directoryContents.filter { $0.pathExtension == FileExtension.json.rawValue &&
                $0.deletingPathExtension().lastPathComponent == file
            }

            // read
            let data = try Data(contentsOf: jsonFile[0], options: .alwaysMapped)
            // serialize
            let jsonAny = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            // extract
            guard let json = jsonAny as? JsonType else { return nil }
            return json

        } catch {

        }
        return nil
    }

    /// Get JSON value from Plist file
    func loadPlistData(file: String) -> JsonType? {

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: bundleURL,
                                                                                includingPropertiesForKeys: nil,
                                                                                options: [])
            let jsonFile = directoryContents.filter { $0.pathExtension == FileExtension.plist.rawValue &&
                $0.deletingPathExtension().lastPathComponent == file
            }

            let data = try Data(contentsOf: jsonFile[0])
            let plistDataAny = try PropertyListSerialization.propertyList(from: data, format: nil)
            guard let plistData = plistDataAny as? JsonType else { return nil }
            return plistData

        } catch {

        }
        return nil
    }

    internal func getValueForKeyForBundleInfo(key: CFString) -> String {
        guard let infoDictionary = self.infoDictionary else { return "" }
        guard let value = infoDictionary[key as String] else { return "" }
        guard let valueInStr = value as? String else { return "" }
        return valueInStr
    }
}
