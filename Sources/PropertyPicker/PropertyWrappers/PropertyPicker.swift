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
public typealias PropertyPickerState<K: PropertyPickerKey> = PropertyPicker<K, _LocalStorage<K>>

@available(*, deprecated, renamed: "PropertyPicker", message: "Renamed PropertyPicker")
public typealias PropertyPickerEnvironment<K: PropertyPickerKey> = PropertyPicker<K, _EnvironmentStorage<K>>

/**
`PropertyPicker` encapsulates the functionality needed to maintain and update the state of a property key in a SwiftUI view either locally or in the SwiftUI environemnt.

## Structure and Functionality

- **keyPath**: When provided, this `WritableKeyPath` directs the picker to sync with a specific environment value, linking external changes directly to the property key's state.

## Constructor Details

- **Public Initializer**:
  - **Purpose**: Allows instantiation without linking to any specific environment value. This is useful when the state does not need to be shared or influenced by the broader application context.
  - **Parameters**: None explicitly; however, it utilizes the type of the key implicitly.

- **Public Initializer with keyPath**:
  - **Purpose**: Initializes the state with a connection to a specific environment value, allowing the property key's state to be directly influenced by changes in the environment.
  - **Parameters**:
    - `keyPath`: A path to the specific environment value that should be linked to the property key's state.
    - `key`: The type of the property key, provided implicitly by the call.

## Documentation Notes

- **DynamicProperty Conformance**: As a `DynamicProperty`, `PropertyPicker` can participate in SwiftUI's dependency and invalidation system, ensuring the view updates reactively to state changes.
 */
@propertyWrapper
public struct PropertyPicker<Key: PropertyPickerKey, Storage: _PropertyPickerStorage>: DynamicProperty where Storage.Key == Key {

    /// Initializes a new `PropertyPicker` without tying it to a specific environment value.
    ///
    /// This initializer sets up a local state for the specified property key, initialized to its default value.
    /// Use this when you want to manage the property state locally within a view or component, without external influences.
    ///
    /// - Parameter key: The type of the property key. This parameter is optional and inferred from the usage context.
    public init(_ key: Key.Type = Key.self) where Storage == _LocalStorage<Key> {
        self.storage = _LocalStorage()
    }

    /// Initializes a new `PropertyPicker` that synchronizes with a specific environment value.
    ///
    /// By specifying a `keyPath`, this initializer binds the property state to a corresponding value stored in the
    /// SwiftUI environment. Changes to this environment value automatically update the property state, ensuring
    /// consistency across the UI.
    ///
    /// - Parameters:
    ///   - keyPath: A `WritableKeyPath` pointing to the environment value to bind the property state to.
    ///   - key: The type of the property key, typically inferred from the usage context.
    public init(
        _ keyPath: WritableKeyPath<EnvironmentValues, Key.Value>,
        _ key: Key.Type = Key.self
    ) where Storage == _EnvironmentStorage<Key> {
        self.storage = _EnvironmentStorage(keyPath: keyPath)
    }

    var storage: Storage

    public var wrappedValue: Key.Value {
        storage.currentValue
    }

    public var projectedValue: Self {
        self
    }
}
