import Foundation

public extension ProcessInfo {

    func getValue(forKey key: String) -> String? {
        let arguments = ProcessInfo.processInfo.arguments
        let environment = ProcessInfo.processInfo.environment

        if let index = arguments.firstIndex(of: key) {
            return arguments[index + 1]

        } else if let value = environment[key] {
            return value

        } else if let value = BuildConfig.any.value(key: key) {
            return value
        }
        return nil
    }
}
