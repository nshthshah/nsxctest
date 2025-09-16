import Foundation

public extension Data {
    func toJson() -> Any? {
        do {
            let json = try JSONSerialization.jsonObject(with: self, options: .allowFragments)
            return json
        } catch {
            return nil
        }
    }
}
