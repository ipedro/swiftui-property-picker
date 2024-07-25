import Foundation

/// A representation of a property option that can be identified by a unique string.
///
/// `PropertyOption` is a structure that represents an option with a label and a raw value.
/// It conforms to the `Identifiable` protocol, which requires an `id` property.
public struct PropertyOption: Identifiable {

    /// A unique identifier for the property option.
    ///
    /// This identifier is derived from the `rawValue` property.
    public var id: String { rawValue }

    /// A human-readable label for the property option.
    ///
    /// This label is intended to be displayed to users.
    public var label: String

    /// The raw value of the property option.
    ///
    /// This value is typically used internally to represent the option.
    public var rawValue: String

    /// Initializes a new `PropertyOption`.
    ///
    /// - Parameters:
    ///   - label: A human-readable label for the property option.
    ///   - rawValue: The raw value of the property option.
    init(label: String, rawValue: String) {
        self.label = label
        self.rawValue = rawValue
    }
}
