import protocol SwiftUI.PreferenceKey
import protocol SwiftUI.View
import protocol SwiftUI.ViewModifier
import struct SwiftUI.Spacer

/// A container view that sets a value for any given preference key.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
struct PreferenceWriter<Key>: ViewModifier where Key: PreferenceKey {
    var type: Key.Type
    var value: Key.Value
    var verbose: Bool = true

    func body(content: Content) -> some View {
        #if VERBOSE
        if verbose {
            Self._printChanges()
        }
        #endif
        return content.background(
            Spacer().preference(key: Key.self, value: value)
        )
    }
}
