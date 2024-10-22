import Foundation

public extension String {

    /// Split string using regex.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let str = "`ISXCTest` is a great framework"
    /// str.splitUsingRegex("\\[`(.*?)`\\]")
    /// ```
    ///
    /// - Parameters:
    ///   - regexValue: Regex
    /// - Returns: `[String]`
    ///

    func splitUsingRegex(_ regexValue: String) -> [String] {
        var result: [String] = []
        let range = NSRange(location: 0, length: self.utf16.count)
        do {
            let regex = try NSRegularExpression(pattern: regexValue)
            let matches = regex.matches(in: self, options: [], range: range)
            for match in matches {
                let matchString = (self as NSString).substring(with: match.range)
                result.append(matchString)
            }
            return result
        } catch {

        }
        return []
    }

    var splitByCapitalLetters: String {
        let splitted = self
        .splitBefore(separator: { $0.isUpperCase })
        .map { String($0) }
        return splitted.joined(separator: " ")
    }

    /// Check string is all digits
    var isNumber: Bool {
        let characters = CharacterSet.decimalDigits.inverted
        return !self.isEmpty && rangeOfCharacter(from: characters) == nil
    }

    /// Replace Space With Underscore
    func replaceSpaceWithUnderscore() -> String {
        return self.replacingOccurrences(of: " ", with: "_")
    }

    /// Unescaped string
    var unescaped: String {
        let entities = ["\0", "\t", "\n", "\r", "\"", "\'", "\\"]
        var current = self
        for entity in entities {
            let descriptionCharacters = entity.debugDescription.dropFirst().dropLast()
            let description = String(descriptionCharacters)
            current = current.replacingOccurrences(of: description, with: entity)
        }
        return current
    }

    /// Get randome chatacter from string
    func randomCharacter() -> Character {
        guard let randomChar = self.randomElement() else {
            return Character("")
        }
        return randomChar
    }

    var uppercasingFirst: String {
        return prefix(1).uppercased() + dropFirst()
    }

    var lowercasingFirst: String {
        return prefix(1).lowercased() + dropFirst()
    }

    var onlyAlphanumerics: String {
        return self.components(separatedBy: CharacterSet.alphanumerics.inverted).joined()
    }

    var stripped: String {
        let okayChars = Set("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ1234567890")
        return self.filter { okayChars.contains($0) }
    }

    /// Convert string to Camel Case
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let str = "`ISXCTest` is a great framework"
    /// str.toCamelCase()
    /// ```
    ///
    /// - Parameters:
    ///   - prefix: 3 means Return first 3 word with camel case.
    /// - Returns: `String`
    ///

    func toCamelCase(withPrefix prefix: Int = 3) -> String {
        guard !isEmpty else {
            return ""
        }

        let parts = self.components(separatedBy: " ")

        let first = String(describing: parts.first ?? "").lowercasingFirst
        var rest: [String] = []
        for part in parts.dropFirst() where !part.stripped.isEmpty {
            rest.append(part.uppercasingFirst)
        }
        return ([first] + rest).prefix(prefix).joined(separator: "").onlyAlphanumerics
    }

    /// Get `Class` from String value
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let classString = "XCUIElement"
    /// classString.stringClassFromString()
    /// ```
    ///
    /// - Returns: `AnyClass`
    ///

    func stringClassFromString() -> AnyClass? {
        if let cls: AnyClass = NSClassFromString(self) {
            return cls
        }
        return nil
    }

    /// Get file content
    ///
    /// **Example:**
    ///
    /// ```swift
    /// filePath.fileContent()
    /// ```
    ///
    /// - Returns: `[String]`
    ///

    func fileContent() -> [String] {
        var text = [String]()
        do {
            let file = try String(contentsOfFile: self, encoding: String.Encoding.utf8)
            text = file.components(separatedBy: "\n")
        } catch {
            print("Fatal Error: \(error.localizedDescription)")
        }
        return text
    }

    /// Convert string to boolean value
    var boolValue: Bool {
        return (self as NSString).boolValue
    }
}

extension Sequence {
    func splitBefore(
        separator isSeparator: (Iterator.Element) throws -> Bool
    ) rethrows -> [AnySequence<Iterator.Element>] {
        var result: [AnySequence<Iterator.Element>] = []
        var subSequence: [Iterator.Element] = []

        var iterator = self.makeIterator()
        while let element = iterator.next() {
            if try isSeparator(element) {
                if !subSequence.isEmpty {
                    result.append(AnySequence(subSequence))
                }
                subSequence = [element]
            } else {
                subSequence.append(element)
            }
        }
        result.append(AnySequence(subSequence))
        return result
    }
}

/* help property */
extension Character {
    var isUpperCase: Bool { return String(self) == String(self).uppercased() }
}
