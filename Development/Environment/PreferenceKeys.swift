import SwiftUI

/// A preference key for storing an optional `Text` that represents a title.
///
/// This preference key is used to pass a title `Text` view up the view hierarchy. The default value is
/// set to a `Text` view containing "Properties", which can be overridden by any child views providing
/// their own title.
struct TitlePreference: PreferenceKey {
    /// The default title shown if no other title is specified by child views.
    static var defaultValue: Text?

    static func reduce(value: inout Text?, nextValue: () -> Text?) {
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}

/// A preference key for storing context about the background style of content.
///
/// This preference key helps in managing background customization of views with context about
/// the background style and optional animations. It is useful for applying consistent styling across multiple views.
@usableFromInline
struct ContentBackgroundStylePreference: PreferenceKey {
    /// The default value for the background context, initially nil indicating no background is applied.
    @usableFromInline
    static var defaultValue: AnimationBox<AnyShapeStyle>?

    /// Combines multiple values into a single context, prioritizing the latest value set by any child view.
    @usableFromInline
    static func reduce(value: inout AnimationBox<AnyShapeStyle>?, nextValue: () -> AnimationBox<AnyShapeStyle>?) {
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}

/// A preference key for storing a dictionary of `RowBuilder` instances indexed by `ObjectIdentifier`.
///
/// This preference key is used to pass custom view builders for specific property types identified by their `ObjectIdentifier`.
/// It allows different parts of an application to specify custom builders for rendering specific property types.
struct ViewBuilderPreference: PreferenceKey {
    /// The default value is an empty dictionary, indicating no custom view builders are provided initially.
    static let defaultValue = [PropertyID: RowBuilder]()

    /// Merges view builders provided by child views, preferring the builder set closest to the root.
    static func reduce(value: inout [PropertyID: RowBuilder], nextValue: () -> [PropertyID: RowBuilder]) {
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
        value.formUnion(nextValue())
    }
}
