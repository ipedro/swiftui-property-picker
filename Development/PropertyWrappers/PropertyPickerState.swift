import SwiftUI

@available(*, deprecated, renamed: "PropertyPicker", message: "Renamed PropertyPicker")
public typealias PropertyPickerEnvironment<K: PropertyPickerKey> = PropertyPickerState<K, K.KeyPath>

/// A property wrapper that provides state management for a selection within a property picker.
///
/// This property wrapper is designed to work with ``PropertyPickerKey`` and `DynamicProperty`
/// to manage the state of a selected value in a picker view.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey, Data>: DynamicProperty {
    private enum Storage: DynamicProperty {
        case state(State<Key>)
        case binding(Binding<Key>)
    }

    private var storage: Storage

    @usableFromInline
    var data: Data

    /// The value that this property wrapper manages.
    ///
    /// This property returns the value associated with the current selection key.
    public var wrappedValue: Key.PickerValue {
        switch storage {
        case let .state(state):
            state.wrappedValue.value
        case let .binding(binding):
            binding.wrappedValue.value
        }
    }

    /// The projected value of the property wrapper.
    ///
    /// This property returns the instance of `PropertyPickerState` itself.
    public var projectedValue: Self { self }

    /// A binding to the selection key.
    ///
    /// This property provides a binding to the current selection key, allowing the selection
    /// to be read and modified.
    public var selection: Binding<Key> {
        switch storage {
        case let .state(state):
            state.projectedValue
        case let .binding(binding):
            binding.projectedValue
        }
    }
}

public extension PropertyPickerState where Data == Void {
    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue, _: Key.Type = Key.self) {
        storage = .state(State(initialValue: value))
        data = ()
    }

    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue) where Key == Key.PickerValue {
        storage = .state(State(initialValue: value))
        data = ()
    }
}

public extension PropertyPickerState where Data == Void {
    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - selection: A binding to the currently selected option.
    init(selection: Binding<Key>) {
        storage = .binding(selection)
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
    init(keyPath: Key.KeyPath, selection: Binding<Key>) {
        storage = .binding(selection)
        data = keyPath
    }

    /// Initializes the property picker state, linking the local selection to an environment value.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _: Key.Type = Key.self, keyPath: Key.KeyPath) {
        storage = .state(State(initialValue: value))
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
        storage = .state(State(initialValue: value))
        data = keyPath
    }
}
