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
public struct PropertyPickerView<Content: View, Style: PropertyPickerStyle>: View {
    /// The content to be presented alongside the dynamic value selector.
    var content: Content

    /// The presentation style
    var style: Style

    /// A view modifier that updates a shared context with changes from preference keys.
    private var updater = ContextWriter()

    /// A context object that holds and manages UI related data for property pickers within a SwiftUI application.
    @StateObject private var context = Context()

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        content
            .modifier(style)
            .modifier(updater)
            .environmentObject(context)
    }
}
