import SwiftUI

/// A container view that sets a value for any given preference key.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
@usableFromInline
struct PreferenceWriter<Key>: ViewModifier where Key: PreferenceKey {
    var type: Key.Type
    var value: Key.Value
    var verbose: Bool

    @usableFromInline
    init(type: Key.Type, value: Key.Value, verbose: Bool = true) {
        self.type = type
        self.value = value
        self.verbose = verbose
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.background(
            Spacer().preference(key: Key.self, value: value)
        )
    }
}
