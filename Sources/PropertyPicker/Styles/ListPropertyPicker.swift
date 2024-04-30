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

// MARK: - List Style

/// A `PropertyPickerStyle` for displaying property picker content within a styled list.
///
/// This style component wraps property picker content in a SwiftUI List, applying a specified list style
/// and optional row background. It integrates additional UI adjustments like content background styling,
/// animations based on user interactions, and custom headers to enhance the visual presentation.
///
/// - Parameters:
///   - S: A `ListStyle` type that defines the appearance of the list.
///   - B: A `View` type used for the background of each list row.
public struct ListPropertyPicker<S: ListStyle, B: View>: PropertyPickerStyle {
    let listStyle: S
    let listRowBackground: B?

    @State
    private var backgroundPreference = ContentBackgroundStylePreference.defaultValue

    private var contentBackground: some ShapeStyle {
        backgroundPreference?.data ?? AnyShapeStyle(.background)
    }

    public func body(content: Content) -> some View {
        List {
            Section {
                content.rows.listRowBackground(listRowBackground)
            } header: {
                VStack(spacing: .zero) {
                    ZStack {
                        GroupBox {
                            Spacer().frame(maxWidth: .infinity)
                        }
                        .ios16_backgroundStyle(contentBackground)
                        .animation(backgroundPreference?.animation, value: backgroundPreference)

                        content
                            .padding()
                            .onPreferenceChange(ContentBackgroundStylePreference.self) {
                                backgroundPreference = $0
                            }
                    }
                    .environment(\.textCase, nil)
                    .padding(.vertical)

                    content.title
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .listStyle(listStyle)
    }
}

private extension View {
    @ViewBuilder
    func ios16_backgroundStyle<S: ShapeStyle>(_ background: S) -> some View {
        if #available(iOS 16.0, *) {
            backgroundStyle(background)
        } else {
            // Fallback on earlier versions
            self
        }
    }
}
