import SwiftUI

/// A protocol defining a customizable style for property pickers within a SwiftUI application.
///
/// Conforming to this protocol allows the creation of distinct visual themes or behaviors for property pickers
/// by implementing a `ViewModifier`. This customization includes the ability to style and layout picker rows, titles,
/// and other components using predefined or custom views that conform to SwiftUI's View.
///
/// Implementations of `PropertyPickerStyle` should utilize the `rows` and `title` properties provided by
/// the protocol extension to maintain consistency and leverage reusable components across different styles.
public protocol PropertyPickerStyle: ViewModifier {}

public extension _ViewModifier_Content where Modifier: PropertyPickerStyle {
    /// Provides a view representing the rows of the property picker.
    /// These rows typically display selectable options or properties within the picker.
    var rows: some View {
        Rows()
    }

    /// Provides a view representing the title of the property picker.
    /// This view is generally used to display a header or title for the picker section.
    var title: some View {
        Title()
    }
}
