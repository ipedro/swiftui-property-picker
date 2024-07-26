import SwiftUI

/// A view modifier that updates a shared context with changes from preference keys.
///
/// This modifier listens for changes in specified preference keys and updates the corresponding properties
/// in the `Context` object. It ensures that the `Context` stays in sync with the UI elements that might modify these properties.
struct Context: ViewModifier {
    /// A context object that holds and manages UI related data for property pickers within a SwiftUI application.
    @StateObject
    private var data = Data()

    /// The body of the modifier which subscribes to preference changes and updates the context.
    func body(content: Content) -> some View {
        content.onPreferenceChange(PropertyPreference.self) { newValue in
            if data.rows != newValue {
                data.rows = newValue
            }
        }.onPreferenceChange(TitlePreference.self) { newValue in
            if data.title != newValue {
                data.title = newValue
            }
        }.onPreferenceChange(ViewBuilderPreference.self) { newValue in
            if data.rowBuilders != newValue {
                data.rowBuilders = newValue
            }
        }.environmentObject(data)
    }
}
