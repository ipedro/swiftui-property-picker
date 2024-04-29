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

/// A property wrapper that allows a property picker to adjust values stored in the SwiftUI Environment.
@propertyWrapper
public struct PropertyPickerEnvironment<Key: PropertyPickerKey>: DynamicProperty {
    let key: Key.Type
    let keyPath: WritableKeyPath<EnvironmentValues, Key.Value>
    let environment: Environment<Key.Value>

    public init(_ keyPath: WritableKeyPath<EnvironmentValues, Key.Value>, _ key: Key.Type) {
        self.key = key
        self.keyPath = keyPath
        self.environment = Environment(keyPath)
    }

    /// The current value of the environment property being adjusted.
    public var wrappedValue: Key.Value {
        environment.wrappedValue
    }

    /// The projected value, providing access to the environment property.
    public var projectedValue: Self {
        self
    }

}
