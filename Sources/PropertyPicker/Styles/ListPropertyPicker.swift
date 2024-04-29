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

public extension PropertyPickerStyle where Self == ListPropertyPicker<PlainListStyle, Color> {
    static var list: Self { .list() }

    static func list(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

public extension PropertyPickerStyle where Self == ListPropertyPicker<InsetGroupedListStyle, Color> {
    static var insetGroupedList: Self { .insetGroupedList() }

    static func insetGroupedList(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

public extension PropertyPickerStyle where Self == ListPropertyPicker<GroupedListStyle, Color> {
    static var groupedList: Self { .groupedList() }

    static func groupedList(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

public extension PropertyPickerStyle where Self == ListPropertyPicker<SidebarListStyle, Color> {
    static var sidebarList: Self { .sidebarList() }

    static func sidebarList(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

// MARK: - List Style

public struct ListPropertyPicker<S: ListStyle, B: View>: PropertyPickerStyle {
    let listStyle: S
    let listRowBackground: B

    @State
    private var backgroundPreference = ContentBackgroundPreference.defaultValue

    private var contentBackground: some ShapeStyle {
        backgroundPreference?.style ?? AnyShapeStyle(.background)
    }

    public func makeBody(configuration: Configuration) -> some View {
        List {
            Section {
                configuration.rows.listRowBackground(listRowBackground)
            } header: {
                VStack(spacing: .zero) {
                    ZStack {
                        GroupBox {
                            Spacer().frame(maxWidth: .infinity)
                        }
                        .ios16_backgroundStyle(contentBackground)
                        .animation(backgroundPreference?.animation, value: backgroundPreference)

                        configuration.content
                            .padding()
                            .onPreferenceChange(ContentBackgroundPreference.self) {
                                backgroundPreference = $0
                            }
                    }
                    .environment(\.textCase, nil)
                    .padding(.vertical)

                    configuration.title
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