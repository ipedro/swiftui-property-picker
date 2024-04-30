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

import Foundation

/// An enumeration that defines the adjustment styles for safe area insets in property picker contexts.
///
/// It specifies how a property picker should adjust its content to accommodate safe area insets,
/// ensuring that the picker does not obstruct critical parts of the user interface, such as input fields or buttons.
/// This adjustment is particularly useful in scenarios where property pickers alter the layout dynamically,
/// such as appearing as overlays or within modal presentations.
public enum PropertyPickerSafeAreaAdjustmentStyle {
    /// Adjusts the safe area insets automatically based on system guidelines and the presence of elements like keyboards
    /// or bottom bars that may overlap the property picker's content.
    case automatic

    /// Does not make any adjustments to the safe area insets, allowing the content to maintain its layout
    /// irrespective of environmental changes. This setting is suitable when the UI design specifies that elements
    /// should not react to overlaying interfaces.
    case never
}
