import Foundation

/// `PropertyID` provides a unique identifier for property picker elements,
/// facilitating the tracking and management of property picker states and configurations
/// across different components of an application.
public struct PropertyID: Hashable, CustomDebugStringConvertible {
    public var metadata: UnsafeRawPointer

    public init<K: PropertyPickerKey>(_: K.Type = K.self) {
        self.metadata = unsafeBitCast(K.self, to: UnsafeRawPointer.self)
    }

    public var debugDescription: String {
        _typeName(unsafeBitCast(metadata, to: Any.Type.self), qualified: false)
    }
}
