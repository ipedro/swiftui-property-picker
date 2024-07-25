import struct SwiftUI.EnvironmentValues

/**
`PropertyPickerKey` encapsulates the essentials of property management within a picker interface. Conforming to this protocol enables types to be used seamlessly in conjunction with ``PropertyPicker``.

## Conformance

To conform to `PropertyPickerKey`, a type must satisfy several requirements, which enable it to interact efficiently with SwiftUI’s environment:

- **RawRepresentable**: Conformance to `RawRepresentable` with a `RawValue` of `String` allows each property key to be directly associated with a string value, facilitating easy storage and display.
- **CaseIterable**: This requirement ensures that all possible instances of the type can be listed, which is particularly useful for presenting options in a picker.

## Properties

- `title`: A static property providing a descriptive title for this property. A default value is provided.
- `defaultValue`: Also static, this property specifies the default selection for the property. It serves as a fallback and initial state when user interactions have not yet altered the current selection. By default the first case is selected.
 - `label`: The label that describes this property instance. If no label is defined, the `rawValue` used instead.
 - `value`: Each instance of a conforming type provides a specific value associated with the property key.

## Implementation Example

Here's a straightforward example of how one might implement `PropertyPickerKey` for a setting that manages text alignment within an application:

```swift
enum TextAlignmentKey: String, PropertyPickerKey {
    case left, center, right
}
```
 - Warning: The `allCases` array must contain at least one item, or a `fatalError()` will be thrown in runtime.

## Conclusion

`PropertyPickerKey` offers a robust foundation for handling selectable properties in SwiftUI. By adhering to this protocol, developers can ensure their property types are well-integrated within the SwiftUI framework, benefiting from both the type safety and the rich user interface capabilities it provides. Whether for simple settings or complex configuration screens, `PropertyPickerKey` paves the way for more organized and maintainable code.
 */
public protocol PropertyPickerKey<PickerValue>: RawRepresentable<String>, CaseIterable where AllCases == [Self] {
    /// The type of the value associated with the property. By default, it is the type of `Self`, allowing for types
    /// where the key and the value are the same.
    associatedtype PickerValue = Self

    typealias KeyPath = WritableKeyPath<EnvironmentValues, Self.PickerValue>

    /// A title for the property group, typically used as a section header or similar in UI elements. This helps users
    /// understand the context or categorization of the properties.
    static var title: String { get }

    /// The default value of the property. This is used both to provide a default state and to reset the property's value.
    static var defaultValue: Self { get }

    /// The specific value associated with an instance of this property. This allows for storing additional metadata or
    /// specifics about the property beyond its enumeration case.
    var value: Self.PickerValue { get }

    /// The label that describes this property instance. If no label is defined, the `rawValue` used instead.
    var label: String { get }
}

// MARK: - Convenience Default Label

public extension PropertyPickerKey {
    /// Convenience Default label is the `rawValue`.
    var label: String { rawValue }
}

// MARK: - Convenience Default Title

extension PropertyPickerKey {
    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    public static var title: String {
        String(describing: Self.self)
            .removingSuffix("Key")
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Convenience Default Value

extension PropertyPickerKey {
    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    public static var defaultValue: Self {
        guard let first = allCases.first else {
            fatalError("Keys should have at least one valid option")
        }
        return first
    }
}

// MARK: - Convenience Value

extension PropertyPickerKey where PickerValue == Self {
    public var value: Self { self }
}
