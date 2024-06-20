//  Copyright (c) 2024 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

public struct PropertyPickerTextTransformation: OptionSet {
    public let rawValue: Int8

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public static let none             = Self()
    public static let camelCaseToWords = Self(rawValue: 1 << 3)
    public static let capitalize       = Self(rawValue: 1 << 0)
    public static let lowercase        = Self(rawValue: 1 << 1)
    public static let uppercase        = Self(rawValue: 1 << 2)

    func apply(to text: String) -> String {
        var text = text
        if contains(.camelCaseToWords) {
            text = text.addingSpacesToCamelCase()
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
    /// Adds spaces before each uppercase letter in a camelCase string.
    /// - Returns: A new string with spaces added before each uppercase letter.
    func addingSpacesToCamelCase() -> String {
        replacingOccurrences(
            of: "(?<=[a-z])(?=[A-Z])",
            with: " $0",
            options: .regularExpression,
            range: range(of: self)
        )
    }

    /// Removes a specified suffix from the string if it ends with that suffix.
    ///
    /// - Parameter suffix: The suffix to remove from the string.
    /// - Returns: The string after the specified suffix has been removed if it was present at the end.
    func removingSuffix(_ suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }
        return String(self.dropLast(suffix.count))
    }
}
