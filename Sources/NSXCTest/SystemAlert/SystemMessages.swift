import Foundation

// MARK: - System Messages helper protocol

/// Helper protocol used to reads localized messages from JSON files.
public protocol SystemMessages {
    /// Returns all localized texts from a JSON file.
    ///
    /// - Parameter json: JSON file name, without the `json` extension.
    /// - Returns: All localized tests read from the JSON.
    static func readMessages(from jsonFile: String) -> [String]
}

extension SystemMessages {
    /// Returns all localized texts from a JSON file.
    ///
    /// - Parameter json: JSON file name, without the `json` extension.
    /// - Returns: All localized tests read from the JSON.
    public static func readMessages(from jsonFile: String = String(describing: Self.self)) -> [String] {
        guard let url = Bundle.nsxctestFrameworkBundle.url(forResource: jsonFile, withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONDecoder().decode(Dictionary<String, [String]>.self, from: data) else {
                return []
        }
        return json.flatMap({ $0.value }).unique()
    }
}
