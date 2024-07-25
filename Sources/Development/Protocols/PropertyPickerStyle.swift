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
