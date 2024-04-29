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

/// A protocol for defining custom styles for presenting dynamic value selectors.
public protocol PropertyPickerStyle: DynamicProperty {
    /// The associated type representing the body of the selector style.
    associatedtype Body: View

    /// A typealias for the configuration used by the selector style.
    typealias Configuration = PropertyPickerStyleConfiguration

    /// Creates the body of the selector style using the provided configuration.
    ///
    /// - Parameter configuration: The configuration for the selector style.
    /// - Returns: A view representing the body of the selector style.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

extension PropertyPickerStyle {
    func resolve(configuration: Configuration) -> some View {
        ResolvedStyle(configuration: configuration, style: self)
    }
}

private struct ResolvedStyle<Style: PropertyPickerStyle>: View {
    var configuration: PropertyPickerStyleConfiguration
    var style: Style

    var body: some View {
        style.makeBody(configuration: configuration)
    }
}
