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

/// `PropertyID` provides a unique identifier for property picker elements,
/// facilitating the tracking and management of property picker states and configurations
/// across different components of an application.
///
/// It utilizes `ObjectIdentifier` under the hood to guarantee uniqueness, basing the identity
/// on the type information of `PropertyPickerKey` conforming types. This ensures that each
/// property picker type is associated with a distinct identifier, preventing conflicts and
/// improving traceability in systems that manage multiple types of property pickers.
///
/// Usage of this ID is crucial in scenarios where properties need to be dynamically
/// managed and accessed across various UI components or data handling layers.
public struct PropertyID: Hashable {
    public static func == (lhs: PropertyID, rhs: PropertyID) -> Bool {
        lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    let type: Any.Type

    /// The underlying value storing the unique identifier based on type information.
    private let value: ObjectIdentifier

    /// Initializes a new identifier for a property picker key.
    /// The identifier is derived from the type of the `PropertyPickerKey` conforming type,
    /// ensuring that each key type has a unique identifier.
    ///
    /// - Parameter key: The type of the property picker key. The default value `K.self`
    ///   captures the caller's type context, automatically providing type-specific uniqueness.
    init<K: PropertyPickerKey>(_ key: K.Type = K.self) {
        value = ObjectIdentifier(key)
        type = key
    }
}
