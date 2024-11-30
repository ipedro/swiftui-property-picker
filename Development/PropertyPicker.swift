import SwiftUI

/// A SwiftUI view that enables dynamic property selection.
///
/// This view acts as a container that integrates with the property picker system to allow users
/// to dynamically select properties and apply them to the enclosed content.
public struct PropertyPicker<Content: View, Style: PropertyPickerStyle>: View {
    /// The content to be presented alongside the dynamic value selector.
    var content: Content

    /// The presentation style
    var style: Style

    @_disfavoredOverload
    public init(style: Style, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = style
    }

    /// A view modifier that updates a shared context with changes from preference keys.
    private var context = Context()

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        content
            .modifier(style)
            .modifier(context)
    }
}

// MARK: - Inline Style

public extension PropertyPicker where Style == _InlinePropertyPicker {
    /// Initializes a ``PropertyPicker`` with an inline presentation style.
    ///
    /// This initializer sets up a property picker that displays its content directly within the surrounding view hierarchy,
    /// rather than in a separate modal or layered interface. The inline style is suitable for contexts where space allows
    /// for direct embedding of components without the need for additional navigation.
    ///
    /// - Parameter content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        style = _InlinePropertyPicker()
    }
}

// MARK: - List Style

public extension PropertyPicker {
    /// Initializes a ``PropertyPicker`` using a specific `ListStyle`.
    ///
    /// This initializer configures the property picker to display its items as a list styled according to the provided `ListStyle`.
    /// It allows for customization of the list's appearance and interaction model, making it adaptable to various UI designs.
    ///
    /// - Parameters:
    ///   - style: Defines the list style.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init<S: ListStyle>(style: S, @ViewBuilder content: () -> Content) where Style == _ListPropertyPicker<S> {
        self.content = content()
        self.style = _ListPropertyPicker(listStyle: style)
    }
}

// MARK: - Sheet Style

@available(iOS 16.4, macOS 13.3, tvOS 16.4, watchOS 9.4, *)
public extension PropertyPicker where Style == _SheetPropertyPicker {
    /// Initializes a ``PropertyPicker`` with a sheet presentation style.
    ///
    /// This initializer sets up a property picker to appear as a modal sheet, which slides up from the bottom of the screen.
    /// The sheet's size and how it reacts to different device contexts can be customized through various parameters.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether the sheet is presented.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        style = _SheetPropertyPicker(isPresented: isPresented)
    }
}
