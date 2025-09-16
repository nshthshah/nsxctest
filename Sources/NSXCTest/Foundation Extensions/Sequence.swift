import Foundation

public extension Sequence where Iterator.Element: Hashable {

    /// Returns an array with unique elements preserving an order of elements.
    ///
    /// - Returns: Unique elements.
    func unique() -> [Iterator.Element] {
        var buffer: [Iterator.Element] = []
        var added = Set<Iterator.Element>()
        for element in self {
            if !added.contains(element) {
                buffer.append(element)
                added.insert(element)
            }
        }
        return buffer
    }
}
