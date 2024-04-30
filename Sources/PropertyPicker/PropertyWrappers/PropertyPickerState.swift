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
public struct PropertyPickerState<K: PropertyPickerKey>: DynamicProperty {
    @State<K> var _state: K = K.defaultValue

    var _environment: Environment<K.Value>?

    var keyPath: WritableKeyPath<EnvironmentValues, K.Value>?

    /// Initializes the state with the specified key.
    public init() {}

    /// Initializes the state tied to an environment key.
    public init(_ keyPath: WritableKeyPath<EnvironmentValues, K.Value>) {
        self.keyPath = keyPath
        self._environment = Environment(keyPath)
    }

    /// The current value of the property being adjusted.
    public var wrappedValue: K.Value {
        _environment?.wrappedValue ?? _state.value
    }

    /// The projected value, providing access to the binding of the state.
    public var projectedValue: Self {
        self
    }
}
