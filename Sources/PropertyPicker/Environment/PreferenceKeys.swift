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

struct TitlePreference: PreferenceKey {
    static var defaultValue: Text? = Text("Properties")
    static func reduce(value: inout Text?, nextValue: () -> Text?) {}
}

struct ContentBackgroundPreference: PreferenceKey {
    static var defaultValue: ContentBackgroundContext?

    static func reduce(value: inout ContentBackgroundContext?, nextValue: () -> ContentBackgroundContext?) {
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}

struct ViewBuilderPreference: PreferenceKey {
    static let defaultValue = [ObjectIdentifier: PropertyViewBuilder]()
    static func reduce(value: inout [ObjectIdentifier: PropertyViewBuilder], nextValue: () -> [ObjectIdentifier: PropertyViewBuilder]) {
        value.merge(nextValue()) { content, _ in
            content
        }
    }
}
/// A preference key for storing dynamic value entries.
///
/// This key aggregates values to be displayed in a custom selection menu, allowing
/// for dynamic updates and customization of menu content based on user selection.
struct PropertyPreference: PreferenceKey {
    /// The default value for the dynamic value entries.
    static var defaultValue: Set<Property> = []

    /// Combines the current value with the next value.
    ///
    /// - Parameters:
    ///   - value: The current value of dynamic value entries.
    ///   - nextValue: A closure that returns the next set of dynamic value entries.
    static func reduce(value: inout Set<Property>, nextValue: () -> Set<Property>) {
        value = nextValue().union(value)
    }
}
