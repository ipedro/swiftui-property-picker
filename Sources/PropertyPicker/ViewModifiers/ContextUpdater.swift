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

/// A view modifier that updates a shared context with changes from preference keys.
///
/// This modifier listens for changes in specified preference keys and updates the corresponding properties
/// in the `Context` object. It ensures that the `Context` stays in sync with the UI elements that might modify these properties.
struct ContextUpdater: ViewModifier {
    @EnvironmentObject
    private var context: Context  // Shared context object.

    /// The body of the modifier which subscribes to preference changes and updates the context.
    func body(content: Content) -> some View {
        content
            .onPreferenceChange(PropertyPreference.self) { newValue in
                if context.rows != newValue {
                    context.rows = newValue
                }
            }
            .onPreferenceChange(TitlePreference.self) { newValue in
                if context.title != newValue {
                    context.title = newValue
                }
            }
            .onPreferenceChange(ViewBuilderPreference.self) { newValue in
                if context.rowBuilders != newValue {
                    context.rowBuilders = newValue
                }
            }
    }
}

