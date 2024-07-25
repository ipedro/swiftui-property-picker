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

@available(*, deprecated, renamed: "PropertyPicker", message: "Renamed PropertyPicker")
public typealias PropertyPickerEnvironment<K: PropertyPickerKey> = PropertyPickerState<K, K.KeyPath>

/// A property wrapper that provides state management for a selection within a property picker.
///
/// This property wrapper is designed to work with ``PropertyPickerKey`` and `DynamicProperty`
/// to manage the state of a selected value in a picker view.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey, Data>: DynamicProperty {
    @State var store: Key

    var data: Data

    /// The value that this property wrapper manages.
    ///
    /// This property returns the value associated with the current selection key.
    public var wrappedValue: Key.PickerValue { store.value }

    /// The projected value of the property wrapper.
    ///
    /// This property returns the instance of `PropertyPickerState` itself.
    public var projectedValue: Self { self }

    /// A binding to the selection key.
    ///
    /// This property provides a binding to the current selection key, allowing the selection
    /// to be read and modified.
    public var selection: Binding<Key> { $store }
}

public extension PropertyPickerState where Data == Void {
    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue, _ key: Key.Type = Key.self) {
        self._store = State(initialValue: value)
        self.data = ()
    }

    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue) where Key == Key.PickerValue {
        self._store = State(initialValue: value)
        self.data = ()
    }
}

public extension PropertyPickerState where Data == Key.KeyPath {
    /// Initializes the property picker state, linking the local selection to an environment value.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _ key: Key.Type = Key.self, keyPath: Key.KeyPath) {
        self._store = State(initialValue: value)
        self.data = keyPath
    }
    /// Initializes the property picker state, linking it to an environment value using a key path.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @available(*, deprecated, renamed: "init(_:keyPath:)", message: "Renamed")
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _ keyPath: Key.KeyPath, _ key: Key.Type = Key.self) {
        self._store = State(initialValue: value)
        self.data = keyPath
    }
}
