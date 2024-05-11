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

/// A property picker style that presents content in a sheet overlay, with additional customizations for presentation and dismissal.
///
/// This style encapsulates the behavior necessary to present and manage a modal sheet that contains property picker content.
/// It includes custom animations, toolbar adjustments, and dynamic insets based on interaction states.
///
/// - Requires: iOS 16.4 or newer for certain APIs used in this struct.
@available(iOS 16.4, *)
public struct SheetPropertyPicker: PropertyPickerStyle {
    @Binding
    var isPresented: Bool

    @State
    private var _selection = PresentationDetentsKey.defaultValue.first!

    @Environment(\.safeAreaAdjustment)
    private var safeAreaAdjustment

    @Environment(\.animation)
    private var animation

    @Environment(\.presentationDetents)
    private var presentationDetents

    @Environment(\.selectedDetent)
    private var customSelection

    @State
    private var contentHeight: Double = 0

    private var safeAreaInset: CGFloat {
        switch safeAreaAdjustment {
        case .automatic where isPresented: contentHeight
        case .automatic, .never: .zero
        }
    }
    
    public func body(content: Content) -> some View {
        content
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Spacer().frame(height: safeAreaInset)
            }
            .toolbar(content: {
                ToolbarButton(isPresented: $isPresented)
            })
            .animation(animation, value: safeAreaInset)
            .overlay(
                Spacer().sheet(isPresented: $isPresented) {
                    configureList(
                        List {
                            Section {
                                content.rows.listRowBackground(Color.clear)
                            } header: {
                                configureTitle(content.title)
                            }
                        }
                    )
                }
            )
    }

    private func configureTitle(_ title: some View) -> some View {
        title
            .bold()
            .padding(
                EdgeInsets(
                    top: 16,
                    leading: 0,
                    bottom: 8,
                    trailing: 0
                )
            )
            .font(.title2)
            .foregroundStyle(.primary)
    }

    private func configureList(_ list: some View) -> some View {
        list
            .listStyle(.plain)
            .presentationDetents(
                presentationDetents,
                selection: Binding(
                    get: {
                        let value = customSelection?.wrappedValue ?? _selection
                        if presentationDetents.contains(value) {
                            return value
                        } else if let first = presentationDetents.first {
                            return first
                        }
                        fatalError("A valid detent must be provided")
                    },
                    set: { newValue in
                        if let customSelection {
                            customSelection.wrappedValue = newValue
                        } else {
                            _selection = newValue
                        }
                    }
                )
            )
            .presentationBackgroundInteraction(.enabled)
            .presentationContentInteraction(.scrolls)
            .presentationCornerRadius(20)
            .presentationBackground(Material.thinMaterial)
            .edgesIgnoringSafeArea(.top)
            .listRowBackground(Color.clear)
            .scrollContentBackground(.hidden)
            .background {
                GeometryReader(content: { geometry in
                    Color.clear.onChange(of: geometry.frame(in: .global), perform: { frame in
                        contentHeight = frame.maxY - frame.minY
                    })
                })
            }
    }

    private struct ToolbarButton: View {
        @Binding
        var isPresented: Bool

        @Environment(\.animation)
        private var animation

        var body: some View {
            Button {
                withAnimation(animation) {
                    isPresented.toggle()
                }
            } label: {
                ZStack {
                    Image(systemName: "xmark.circle.fill").opacity(isPresented ? 1 : 0)
                    Image(systemName: "gear").opacity(isPresented ? 0 : 1)
                }
                .rotationEffect(.degrees(isPresented ? -180 : 0))
            }
            .animation(animation, value: isPresented)
        }
    }
}
