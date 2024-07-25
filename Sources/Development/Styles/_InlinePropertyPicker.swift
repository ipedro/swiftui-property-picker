import SwiftUI

/// A style that presents dynamic value options inline within the view hierarchy of a property picker.
/// This style uses a vertical stack to organize the content, adding a divider and utilizing the `rows` property
/// to display additional picker options below the main content.
public struct _InlinePropertyPicker: PropertyPickerStyle {
    @Environment(\.rowBackground)
    private var rowBackground

    /// Creates the view for the inline style, embedding the dynamic value options directly within a scrollable area.
    ///
    /// The implementation arranges the picker's standard content and its rows in a `VStack` to ensure they are
    /// displayed inline with appropriate spacing and structural divisions.
    ///
    /// - Parameter content: The dynamic value options and content.
    /// - Returns: A view displaying the dynamic value options inline, enhanced with custom spacing and dividers.
    public func body(content: Content) -> some View {
        content.safeAreaInset(edge: .bottom) {
            VStack {
                Divider().padding(.bottom)
                LazyVStack {
                    content.rows.background(rowBackground)
                }
            }
            .padding()
        }
    }
}
