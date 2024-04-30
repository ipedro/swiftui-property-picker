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

// MARK: - Inline Style

public extension PropertyPicker where Style == InlinePropertyPicker {
    /// Initializes a ``PropertyPicker`` with an inline presentation style.
    ///
    /// This initializer sets up a property picker that displays its content directly within the surrounding view hierarchy,
    /// rather than in a separate modal or layered interface. The inline style is suitable for contexts where space allows
    /// for direct embedding of components without the need for additional navigation.
    ///
    /// - Parameter content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = InlinePropertyPicker()
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
    ///   - listStyle: A ``ListPropertyPicker`` instance defining the list's style.
    ///   - listRowBackground: The optional background color of the list's rows.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init<S: ListStyle>(
        listStyle: S,
        listRowBackground: Color? = nil,
        @ViewBuilder content: () -> Content
    ) where Style == ListPropertyPicker<S, Color?> {
        self.content = content()
        self.style = ListPropertyPicker(
            listStyle: listStyle,
            listRowBackground: listRowBackground
        )
    }

    /// Initializes a ``PropertyPicker`` using a specific `ListStyle`.
    ///
    /// This initializer configures the property picker to display its items as a list styled according to the provided `ListStyle`.
    /// It allows for customization of the list's appearance and interaction model, making it adaptable to various UI designs.
    ///
    /// - Parameters:
    ///   - listStyle: A ``ListPropertyPicker`` instance defining the list's style.
    ///   - listRowBackground: The optional background view of the list's rows.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    @_disfavoredOverload
    init<S: ListStyle, B: View>(
        listStyle: S,
        listRowBackground: B,
        @ViewBuilder content: () -> Content
    ) where Style == ListPropertyPicker<S, B> {
        self.content = content()
        self.style = ListPropertyPicker(
            listStyle: listStyle,
            listRowBackground: listRowBackground
        )
    }
}

// MARK: - Sheet Style

@available(iOS 16.4, *)
public extension PropertyPicker where Style == SheetPropertyPicker {
    /// Initializes a ``PropertyPicker`` with a sheet presentation style.
    ///
    /// This initializer sets up a property picker to appear as a modal sheet, which slides up from the bottom of the screen.
    /// The sheet's size and how it reacts to different device contexts can be customized through various parameters.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether the sheet is presented.
    ///   - adjustsBottomInset: A Boolean value that indicates whether the sheet should adjust its height to account for the bottom safe area.
    ///   - detent: The default position of the sheet when it appears.
    ///   - presentationDetents: A set of detents specifying the allowed positions that the sheet can settle into when presented.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(
        isPresented: Binding<Bool>,
        adjustsBottomInset: Bool = true,
        detent: PresentationDetent = .fraction(1/3),
        presentationDetents: Set<PresentationDetent> = [
            .fraction(1/3),
            .fraction(2/3),
            .large
        ],
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = SheetPropertyPicker(
            isPresented: isPresented,
            adjustsBottomInset: adjustsBottomInset,
            detent: detent,
            presentationDetents: presentationDetents
        )
    }
}
