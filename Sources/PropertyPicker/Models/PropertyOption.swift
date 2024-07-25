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

/// A representation of a property option that can be identified by a unique string.
///
/// `PropertyOption` is a structure that represents an option with a label and a raw value.
/// It conforms to the `Identifiable` protocol, which requires an `id` property.
public struct PropertyOption: Identifiable {

    /// A unique identifier for the property option.
    ///
    /// This identifier is derived from the `rawValue` property.
    public var id: String { rawValue }

    /// A human-readable label for the property option.
    ///
    /// This label is intended to be displayed to users.
    public var label: String

    /// The raw value of the property option.
    ///
    /// This value is typically used internally to represent the option.
    public var rawValue: String

    /// Initializes a new `PropertyOption`.
    ///
    /// - Parameters:
    ///   - label: A human-readable label for the property option.
    ///   - rawValue: The raw value of the property option.
    init(label: String, rawValue: String) {
        self.label = label
        self.rawValue = rawValue
    }
}
