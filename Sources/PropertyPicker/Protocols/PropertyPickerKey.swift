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
///
/// `PropertyPickerKey` requires conforming types to be enumerable, meaning all possible instances
/// are available and can be iterated over, typically used in scenarios where a user might select
/// a property from a list.
///
/// - Requires: Conforming types must be enumerable (`CaseIterable`).
public protocol PropertyPickerKey: Identifiable, CaseIterable where AllCases == [Self] {
    /// The type of value that the property represents.
    associatedtype Value = Self

    /// A title for the property group, typically used as a section header or similar in UI.
    static var title: String { get }

//    /// The current value of the property. This can be used to retrieve or set the property.
//    static var currentValue: Self { get set }

    /// The default value of the property. This can be used to retrieve or set the property.
    static var defaultValue: Self { get }

    /// A human-readable label for each property, typically used for display in the UI.
    var label: String { get }

    /// The specific value associated with a property instance.
    var value: Self.Value { get }

    /// Initializes a new instance of the conforming type using a label.
    ///
    /// - Parameter label: The label string used to identify and initialize the property key.
    /// - Returns: An optional instance of the conforming type.
    /// - Important: The implementation should return `nil` if no corresponding property key can be found for the given label.
    init?(label: String)
}

// MARK: - Default Title

public extension PropertyPickerKey {
    var id: String { label }

    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    static var title: String {
        String(describing: Self.self).addingSpacesToCamelCase()
    }
}

public extension PropertyPickerKey where Value == Self {
    var value: Self { self }
}

// MARK: - Raw Representable

public extension PropertyPickerKey where Self: RawRepresentable<String> {
    var label: String {
        rawValue
    }

    init?(label: String) {
        self.init(rawValue: label)
    }
}

extension PropertyPickerKey {
//    static var selection: Binding<String> {
//        Binding {
//            currentValue.label
//        } set: { newValue in
//            if newValue != currentValue.label, let newValue = Self(label: newValue) {
//                currentValue = newValue
//            }
//        }
//    }
}

// MARK: - Private Helpers

/// Extension to `String` for improving readability of camelCase strings by adding spaces.
private extension String {
    /// Adds spaces before each uppercase letter in a camelCase string.
    ///
    /// Usage:
    ///
    /// ```swift
    /// let camelCaseString = "propertyPickerKey"
    /// let readableString = camelCaseString.addingSpacesToCamelCase()
    /// // readableString is "dynamic Value Key"
    /// ```
    ///
    /// - Returns: A new string with spaces added before each uppercase letter.
    func addingSpacesToCamelCase() -> String {
        replacingOccurrences(
            of: "(?<=[a-z])(?=[A-Z])",
            with: " $0",
            options: .regularExpression,
            range: range(of: self)
        )
    }
}
