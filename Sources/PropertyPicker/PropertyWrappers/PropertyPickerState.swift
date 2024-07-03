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
public typealias PropertyPickerEnvironment<K: PropertyPickerKey> = PropertyPickerState<K, WritableKeyPath<EnvironmentValues, K.Value>>

/**
 `PropertyPickerState` encapsulates the functionality needed to maintain and update the state of a ``PropertyPickerKey`` in a SwiftUI view, either locally or in the SwiftUI environment.

 - Note: **DynamicProperty**: `PropertyPickerState` participates in SwiftUI's dependency and invalidation system, ensuring the view updates reactively to state changes.

 - Note: When provided with a `keyPath` parameter, state changes are linked directly to the SwiftUI enviroment.
 */
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey, Data>: DynamicProperty {

    /// Initializes the property picker state for local usage without linking to an environment value.
    /// - Parameter key: The type of the property key.
    public init(_ key: Key.Type = Key.self) where Data == Void {
        data = ()
    }

    /// Initializes the property picker state, linking it to an environment value using a key path.
    /// - Parameters:
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    ///   - key: The type of the property key.
    public init(
        _ keyPath: WritableKeyPath<EnvironmentValues, Key.Value>,
        _ key: Key.Type = Key.self
    ) where Data == WritableKeyPath<EnvironmentValues, Key.Value> {
        data = keyPath
    }

    @State
    var state: Key = Key.defaultSelection

    var data: Data

    public var wrappedValue: Key.Value {
        state.value
    }

    public var projectedValue: PropertyPickerState<Key, Data> {
        self
    }
}
