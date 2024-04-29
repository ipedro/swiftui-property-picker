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

// MARK: - State Picker

/// A property wrapper that holds the state of a property to be adjusted using the property picker.
/// It automatically updates the view when the selection changes.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey>: DynamicProperty {
    let key: Key.Type
    @State<Key.Value> var state: Key.Value

    /// Initializes the state with the specified key.
    ///
    /// - Parameter key: The type of the key that represents the property being adjusted.
    public init(_ key: Key.Type, initialValue: Key.Value = Key.defaultCase.value) {
        self.key = key
        self._state = State(initialValue: initialValue)
    }

    /// The current value of the property being adjusted.
    public var wrappedValue: Key.Value {
        get { state }
        nonmutating set { state = newValue }
    }

    /// The projected value, providing access to the binding of the state.
    public var projectedValue: Self {
        self
    }

    public var binding: Binding<Key.Value> { $state }
}
