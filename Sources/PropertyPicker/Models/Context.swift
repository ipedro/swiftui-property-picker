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

final class Context: ObservableObject {
    @Published
    var properties: [Property] = []

    @Published
    var title = TitlePreference.defaultValue

    @Published
    var bottomInset: Double = 0

    @Published
    var viewBuilders = [String: PropertyViewBuilder]()

    var isEmpty: Bool { properties.isEmpty }
}

struct ContextUpdatingModifier: ViewModifier {
    @EnvironmentObject
    private var context: Context

    func body(content: Content) -> some View {
        content
            .onPreferenceChange(PropertyPreference.self) { context.properties = $0 }
            .onPreferenceChange(BottomInsetPreference.self) { context.bottomInset = $0 }
            .onPreferenceChange(TitlePreference.self) { context.title = $0 }
            .onPreferenceChange(ViewBuilderPreference.self) { context.viewBuilders = $0 }
    }
}
