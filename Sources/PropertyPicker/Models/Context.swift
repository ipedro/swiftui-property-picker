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
    var properties: Set<Property> = []

    @Published
    var title = TitlePreference.defaultValue

    @Published
    var viewBuilders = [ObjectIdentifier: PropertyViewBuilder]()

    var isEmpty: Bool { properties.isEmpty }
}

struct ContextObserving: ViewModifier {
    @EnvironmentObject
    private var context: Context

    func body(content: Content) -> some View {
        content.onPreferenceChange(PropertyPreference.self) { newValue in
            if context.properties != newValue {
                context.properties = newValue
            }
        }
        .onPreferenceChange(TitlePreference.self) { newValue in
            if context.title != newValue {
                context.title = newValue
            }
        }
        .onPreferenceChange(ViewBuilderPreference.self) { newValue in
            if context.viewBuilders != newValue {
                context.viewBuilders = newValue
            }
        }
    }
}
