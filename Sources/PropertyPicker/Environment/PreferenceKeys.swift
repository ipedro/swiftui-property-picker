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

/// A preference key for storing an optional `Text` that represents a title.
///
/// This preference key is used to pass a title `Text` view up the view hierarchy. The default value is
/// set to a `Text` view containing "Properties", which can be overridden by any child views providing
/// their own title.
struct TitlePreference: PreferenceKey {
    /// The default title shown if no other title is specified by child views.
    static var defaultValue: Text? = Text("Properties")

    /// Reduces values along the view hierarchy into a single value, leaving the title unchanged from the first view that sets it.
    static func reduce(value: inout Text?, nextValue: () -> Text?) {}
}

/// A preference key for storing context about the background style of content.
///
/// This preference key helps in managing background customization of views with context about
/// the background style and optional animations. It is useful for applying consistent styling across multiple views.
struct ContentBackgroundStylePreference: PreferenceKey {
    /// The default value for the background context, initially nil indicating no background is applied.
    static var defaultValue: AnimatableBox<AnyShapeStyle>?

    /// Combines multiple values into a single context, prioritizing the latest value set by any child view.
    static func reduce(value: inout AnimatableBox<AnyShapeStyle>?, nextValue: () -> AnimatableBox<AnyShapeStyle>?) {
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}

/// A preference key for storing a dictionary of `PropertyPickerBuilder` instances indexed by `ObjectIdentifier`.
///
/// This preference key is used to pass custom view builders for specific property types identified by their `ObjectIdentifier`.
/// It allows different parts of an application to specify custom builders for rendering specific property types.
struct ViewBuilderPreference: PreferenceKey {
    /// The default value is an empty dictionary, indicating no custom view builders are provided initially.
    static let defaultValue = [ObjectIdentifier: PropertyPickerBuilder]()

    /// Merges view builders provided by child views, preferring the builder set closest to the root.
    static func reduce(value: inout [ObjectIdentifier: PropertyPickerBuilder], nextValue: () -> [ObjectIdentifier: PropertyPickerBuilder]) {
        value.merge(nextValue()) { content, _ in
            content
        }
    }
}

/// A preference key for storing a set of `Property` objects.
///
/// This preference key is designed to collect properties from various parts of the view hierarchy into a single set.
/// It is useful for aggregating properties that need to be accessible at a higher level in the application.
struct PropertyPreference: PreferenceKey {
    /// The default value, an empty set, indicates that no properties are collected initially.
    static var defaultValue: Set<Property> = []

    /// Reduces multiple sets of properties into a single set, adding any new properties found in child views to the existing set.
    static func reduce(value: inout Set<Property>, nextValue: () -> Set<Property>) {
        value = nextValue().union(value)
    }
}
