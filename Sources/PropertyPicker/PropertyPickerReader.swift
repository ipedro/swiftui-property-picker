//  Copyright (c) 2024 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

/// A SwiftUI view that enables dynamic property selection.
///
/// This view acts as a container that integrates with the property picker system to allow users
/// to dynamically select properties and apply them to the enclosed content.
public struct PropertyPickerReader<Content: View, Style: PropertyPickerStyle>: View {
    /// The content to be presented alongside the dynamic value selector.
    var content: Content

    /// The presentation style
    var style: Style

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

public extension PropertyPickerReader where Style == _InlinePropertyPicker {
    /// Initializes a ``PropertyPickerReader`` with an inline presentation style.
    ///
    /// This initializer sets up a property picker that displays its content directly within the surrounding view hierarchy,
    /// rather than in a separate modal or layered interface. The inline style is suitable for contexts where space allows
    /// for direct embedding of components without the need for additional navigation.
    ///
    /// - Parameter content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = _InlinePropertyPicker()
    }
}

// MARK: - List Style

public extension PropertyPickerReader {
    /// Initializes a ``PropertyPickerReader`` using a specific `ListStyle`.
    ///
    /// This initializer configures the property picker to display its items as a list styled according to the provided `ListStyle`.
    /// It allows for customization of the list's appearance and interaction model, making it adaptable to various UI designs.
    ///
    /// - Parameters:
    ///   - listStyle: A ``_ListPropertyPicker`` instance defining the list's style.
    ///   - listRowBackground: The optional background color of the list's rows.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init<S: ListStyle>(
        listStyle: S,
        listRowBackground: Color? = nil,
        @ViewBuilder content: () -> Content
    ) where Style == _ListPropertyPicker<S, Color?> {
        self.content = content()
        self.style = _ListPropertyPicker(
            listStyle: listStyle,
            listRowBackground: listRowBackground
        )
    }

    /// Initializes a ``PropertyPickerReader`` using a specific `ListStyle`.
    ///
    /// This initializer configures the property picker to display its items as a list styled according to the provided `ListStyle`.
    /// It allows for customization of the list's appearance and interaction model, making it adaptable to various UI designs.
    ///
    /// - Parameters:
    ///   - listStyle: A ``_ListPropertyPicker`` instance defining the list's style.
    ///   - listRowBackground: The optional background view of the list's rows.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    @_disfavoredOverload
    init<S: ListStyle, B: View>(
        listStyle: S,
        listRowBackground: B,
        @ViewBuilder content: () -> Content
    ) where Style == _ListPropertyPicker<S, B> {
        self.content = content()
        self.style = _ListPropertyPicker(
            listStyle: listStyle,
            listRowBackground: listRowBackground
        )
    }
}

// MARK: - Sheet Style

@available(iOS 16.4, *)
public extension PropertyPickerReader where Style == _SheetPropertyPicker {
    /// Initializes a ``PropertyPickerReader`` with a sheet presentation style.
    ///
    /// This initializer sets up a property picker to appear as a modal sheet, which slides up from the bottom of the screen.
    /// The sheet's size and how it reacts to different device contexts can be customized through various parameters.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether the sheet is presented.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = _SheetPropertyPicker(isPresented: isPresented)
    }
}
