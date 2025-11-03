import Foundation

public struct PropertyPickerTextTransformation: OptionSet {
    public let rawValue: Int8

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public static let none = Self()
    public static let capitalize = Self(rawValue: 1 << 0)
    public static let lowercase = Self(rawValue: 1 << 1)
    public static let uppercase = Self(rawValue: 1 << 2)
    public static let camelCaseToWords = Self(rawValue: 1 << 3)
    public static let snakeCaseToWords = Self(rawValue: 1 << 4)

    func apply(to text: String) -> String {
        var text = text
        if contains(.camelCaseToWords) {
            text = text.addingSpacesToCamelCase()
        }
        if contains(.snakeCaseToWords) {
            text = text.replacingOccurrences(of: "_", with: " ")
        }
        if contains(.capitalize) {
            text = text.localizedCapitalized
        }
        if contains(.uppercase) {
            text = text.localizedUppercase
        }
        if contains(.lowercase) {
            text = text.localizedLowercase
        }
        return text
    }
}

// MARK: - Private Helpers

extension String {
    /// Cached regex pattern for camelCase to words conversion.
    /// Compiled once and reused across all string transformations for better performance.
    private static let camelCaseRegex: NSRegularExpression = {
        // swiftlint:disable:next force_try
        try! NSRegularExpression(
            pattern: "(?<=[a-z])(?=[A-Z])",
            options: []
        )
    }()

    /// Adds spaces before each uppercase letter in a camelCase string.
    /// - Returns: A new string with spaces added before each uppercase letter.
    func addingSpacesToCamelCase() -> String {
        let nsString = self as NSString
        let range = NSRange(location: 0, length: nsString.length)
        return Self.camelCaseRegex.stringByReplacingMatches(
            in: self,
            options: [],
            range: range,
            withTemplate: " $0"
        )
    }

    /// Removes a specified suffix from the string if it ends with that suffix.
    ///
    /// - Parameter suffix: The suffix to remove from the string.
    /// - Returns: The string after the specified suffix has been removed if it was present at the end.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// Removes a specified prefix from the string if it ends with that prefix.
    ///
    /// - Parameter prefix: The prefix to remove from the string.
    /// - Returns: The string after the specified prefix has been removed if it was present at the start.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}
