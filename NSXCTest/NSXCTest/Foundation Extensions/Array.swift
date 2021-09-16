import Foundation

internal extension Array {
    subscript(dataFor index: Int) -> String {

        guard let args = self as? [String] else {
            return ""
        }
        if args[index].hasPrefix("<") && args[index].hasSuffix("<") {
            return UserDefaults.standard.string(forKey: String(args[index].dropFirst().dropLast())) ?? ""

        } else if args[index].hasPrefix("${") && args[index].hasSuffix("}") {
            return UserDefaults.standard.string(forKey: String(args[index].dropFirst().dropLast())) ?? ""
        }
        return args[index]
    }
}
