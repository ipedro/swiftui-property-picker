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

/// Provides a convenient static property for accessing the inline selector style.
public extension PropertyPickerStyle where Self == InlinePropertyPicker {
    /// A style that presents dynamic value options inline within the view hierarchy.
    static var inline: Self { .init() }
}

/// A style that presents dynamic value options inline within the view hierarchy.
public struct InlinePropertyPicker: PropertyPickerStyle {
    /// Creates the view for the inline style, embedding the dynamic value options directly within a scrollable area.
    ///
    /// - Parameter configuration: The configuration containing the dynamic value options and content.
    /// - Returns: A view displaying the dynamic value options inline.
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: .zero) {
            configuration.content
            Divider().padding(.horizontal)
            configuration.rows.padding(.top, 8)
        }
    }
}