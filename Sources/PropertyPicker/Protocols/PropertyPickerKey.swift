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

import Foundation
import SwiftUI

/// A protocol for defining keys used in property pickers.
///
/// This protocol allows for the creation of selectable property lists, where each property is
/// associated with a specific value and label.
public protocol PropertyPickerKey: RawRepresentable<String>, CaseIterable, Identifiable where AllCases == [Self] {
    /// The type of value that the property represents.
    associatedtype Value = Self

    /// A title for the property group, typically used as a section header or similar in UI.
    static var title: String { get }

    /// The default value of the property. This can be used to retrieve or set the property.
    static var defaultValue: Self { get }

    /// The specific value associated with a property instance.
    var value: Self.Value { get }
}

// MARK: - Default Title

public extension PropertyPickerKey {
    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    static var title: String {
        String(describing: Self.self)
            .removingSuffix("Key")
            .addingSpacesToCamelCase()
    }
}

// MARK: - Default Identifier

public extension PropertyPickerKey {
    var id: RawValue { rawValue }
}

// MARK: - Default Value

public extension PropertyPickerKey where Value == Self {
    var value: Self { self }
}

// MARK: - Private Helpers

private extension String {
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
