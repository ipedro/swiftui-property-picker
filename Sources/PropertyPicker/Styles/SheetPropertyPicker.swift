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

/// A view modifier that adds a custom expandable menu to a SwiftUI view.
/// This modifier tracks and displays menu items dynamically added to the view,
/// providing a customizable and interactive menu experience.
@available(iOS 16.4, *)
public struct SheetPropertyPicker: PropertyPickerStyle {
    @Binding
    var isPresented: Bool

    let adjustsBottomInset: Bool

    @State
    var detent: PresentationDetent

    let presentationDetents: Set<PresentationDetent>

    @State
    private var bottomInset: Double = 0

    public func body(content: Content) -> some View {
        content
            .onChange(of: isPresented, perform: { value in
                if value == false {
                    withAnimation(.interactiveSpring) {
                        bottomInset = 0
                    }
                }
            })
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Spacer().frame(height: bottomInset)
            }
            .toolbar(content: {
                ToolbarItem {
                    Button {
                        withAnimation(.snappy) {
                            isPresented.toggle()
                        }
                    } label: {
                        Image(systemName: isPresented ? "xmark.circle" : "gear")
                            .rotationEffect(.degrees(isPresented ? 180 : 0))
                    }
                }
            })
            .overlay(
                Spacer().sheet(isPresented: $isPresented) {
                    configureList(
                        List {
                            Section {
                                content.rows
                                    .listRowBackground(Color.clear)
                            } header: {
                                content.title
                                    .bold()
                                    .padding(
                                        EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0)
                                    )
                                    .font(.title2)
                                    .foregroundStyle(.primary)
                            }
                        }
                    )
                }
            )
    }

    private func configureList(_ list: some View) -> some View {
        list
            .listStyle(.plain)
            .presentationDetents(presentationDetents, selection: $detent)
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
                        withAnimation(.interactiveSpring) {
                            bottomInset = frame.maxY - frame.minY
                        }
                    })
                })
            }
    }
}
