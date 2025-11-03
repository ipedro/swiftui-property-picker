import SwiftUI

/// `PropertyWriter` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameter Key: The type of the property picker key, conforming to `PropertyPickerKey`.
@usableFromInline
struct PropertyWriter<Key>: ViewModifier where Key: PropertyPickerKey {
    let type: Key.Type

    @Binding
    var selection: Key

    @usableFromInline
    init(
        type: Key.Type,
        selection: Binding<Key>
    ) {
        self.type = type
        _selection = selection
    }

    @Environment(\.selectionAnimation)
    private var animation

    @Environment(\.labelTransformation)
    private var labelTransformation

    @Environment(\.titleTransformation)
    private var titleTransformation

    /// Cache for property configuration to avoid recreating on every render
    @StateObject
    private var cache = PropertyCache()

    @usableFromInline
    func body(content: Content) -> some View {
        content.modifier(
            PreferenceWriter(
                type: PropertyPreference.self,
                value: [property],
                verbose: false
            )
        )
    }

    /// The item representing the currently selected value, used for updating the UI and storing preferences.
    /// Uses memoization to avoid recreating the property configuration on every render when selection hasn't changed.
    private var property: Property {
        cache.getOrCreate(for: selection.rawValue) {
            createProperty()
        }
    }

    /// Creates a new Property configuration with all options and transformations applied.
    /// This expensive operation is only called when the selection changes.
    private func createProperty() -> Property {
        let id = PropertyID(Key.self)
        let title = title()
        let options = Key.allCases.map {
            PropertyOption(
                label: label(for: $0),
                rawValue: $0.rawValue
            )
        }
        return Property(
            id: id,
            title: title,
            options: options,
            token: selection.rawValue.hashValue,
            formattedSelection: label(for: selection),
            selection: Binding {
                selection.rawValue
            } set: { newValue in
                guard newValue != selection.rawValue else {
                    return
                }
                if let newKey = Key(rawValue: newValue) {
                    withAnimation(animation) {
                        selection = newKey
                    }
                } else {
                    // swiftlint:disable:next line_length
                    assertionFailure("\(Self.self): Couldn't initialize case with \"\(newValue)\". Valid options: \(options.map(\.label))")
                }
            }
        )
    }

    private func title() -> String {
        switch Key.titleTransformation {
        case .automatic:
            titleTransformation.apply(to: Key.title)
        case .never:
            Key.title
        }
    }

    private func label(for key: Key) -> String {
        switch Key.labelTransformation {
        case .automatic:
            labelTransformation.apply(to: key.label)
        case .never:
            key.label
        }
    }

    /// Observable cache for property configuration with smart memoization logic
    private class PropertyCache: ObservableObject {
        private var property: Property?
        private var selectionKey: String?

        /// Returns cached property if key matches, otherwise creates and caches a new one
        func getOrCreate(for key: String, create: () -> Property) -> Property {
            // Return cached property if selection hasn't changed
            if let cached = property, selectionKey == key {
                return cached
            }

            // Selection changed or first access - create new property
            let newProperty = create()

            // Update cache
            property = newProperty
            selectionKey = key

            return newProperty
        }
    }
}
