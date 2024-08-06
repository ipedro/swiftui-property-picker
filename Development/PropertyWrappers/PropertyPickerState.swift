import SwiftUI

@available(*, deprecated, renamed: "PropertyPicker", message: "Renamed PropertyPicker")
public typealias PropertyPickerEnvironment<K: PropertyPickerKey> = PropertyPickerState<K, K.KeyPath>

/// A property wrapper that provides state management for a selection within a property picker.
///
/// This property wrapper is designed to work with ``PropertyPickerKey`` and `DynamicProperty`
/// to manage the state of a selected value in a picker view.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey, Data>: DynamicProperty {
    @usableFromInline
    @State var store: Key

    @usableFromInline
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
    init(wrappedValue value: Key = .defaultValue, _: Key.Type = Key.self) {
        _store = State(initialValue: value)
        data = ()
    }

    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue) where Key == Key.PickerValue {
        _store = State(initialValue: value)
        data = ()
    }
}

public extension PropertyPickerState where Data == Key.KeyPath {
    /// Initializes the property picker state, linking the local selection to an environment value.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _: Key.Type = Key.self, keyPath: Key.KeyPath) {
        _store = State(initialValue: value)
        data = keyPath
    }

    /// Initializes the property picker state, linking it to an environment value using a key path.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @available(*, deprecated, renamed: "init(_:keyPath:)", message: "Renamed")
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _ keyPath: Key.KeyPath, _: Key.Type = Key.self) {
        _store = State(initialValue: value)
        data = keyPath
    }
}
