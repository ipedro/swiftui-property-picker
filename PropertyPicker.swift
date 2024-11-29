// MIT License
// 
// Copyright (c) 2024 Pedro Almeida
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

// auto-generated file, do not edit directly

import Foundation
import SwiftUI

struct SafeAreaAdjustmentKey: EnvironmentKey {
    static var defaultValue: PropertyPickerSafeAreaAdjustmentStyle = .automatic
}

struct SheetAnimationKey: EnvironmentKey {
    static var defaultValue: Animation? = .easeOut
}

struct SelectionAnimationKey: EnvironmentKey {
    static var defaultValue: Animation?
}

struct TitleTransformKey: EnvironmentKey {
    static var defaultValue: PropertyPickerTextTransformation = [.camelCaseToWords, .snakeCaseToWords, .capitalize]
}

struct RowSortingKey: EnvironmentKey {
    static var defaultValue: PropertyPickerRowSorting? = .ascending
}

struct RowBackgroundKey: EnvironmentKey {
    static var defaultValue: AnyView?
}

@usableFromInline
struct LabelTransformKey: EnvironmentKey {
    @usableFromInline
    static var defaultValue: PropertyPickerTextTransformation = [.camelCaseToWords, .snakeCaseToWords, .capitalize]
}

@available(iOS 16.0, macOS 13.0, *)
struct PresentationDetentKey: EnvironmentKey {
    static var defaultValue: Binding<PresentationDetent>?
}

@available(iOS 16.0, macOS 13.0, *)
struct PresentationDetentsKey: EnvironmentKey {
    static var defaultValue: Set<PresentationDetent> = [
        .fraction(1 / 3),
        .fraction(2 / 3),
        .large,
    ]
}

extension EnvironmentValues {
    @usableFromInline
    var safeAreaAdjustment: PropertyPickerSafeAreaAdjustmentStyle {
        get { self[SafeAreaAdjustmentKey.self] }
        set { self[SafeAreaAdjustmentKey.self] = newValue }
    }

    var sheetAnimation: Animation? {
        get { self[SheetAnimationKey.self] }
        set { self[SheetAnimationKey.self] = newValue }
    }

    @usableFromInline
    var selectionAnimation: Animation? {
        get { self[SelectionAnimationKey.self] }
        set { self[SelectionAnimationKey.self] = newValue }
    }

    @available(iOS 16.0, macOS 13.0, *) @usableFromInline
    var presentationDetents: Set<PresentationDetent> {
        get { self[PresentationDetentsKey.self] }
        set { self[PresentationDetentsKey.self] = newValue }
    }

    @available(iOS 16.0, macOS 13.0, *) @usableFromInline
    var selectedDetent: Binding<PresentationDetent>? {
        get { self[PresentationDetentKey.self] }
        set { self[PresentationDetentKey.self] = newValue }
    }

    @usableFromInline
    var titleTransformation: PropertyPickerTextTransformation {
        get { self[TitleTransformKey.self] }
        set { self[TitleTransformKey.self] = newValue }
    }

    @usableFromInline
    var labelTransformation: PropertyPickerTextTransformation {
        get { self[LabelTransformKey.self] }
        set { self[LabelTransformKey.self] = newValue }
    }

    @usableFromInline
    var rowSorting: PropertyPickerRowSorting? {
        get { self[RowSortingKey.self] }
        set { self[RowSortingKey.self] = newValue }
    }

    @usableFromInline
    var rowBackground: AnyView? {
        get { self[RowBackgroundKey.self] }
        set { self[RowBackgroundKey.self] = newValue }
    }
}

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

/// A generic container that associates arbitrary data with an animation, suitable for use in SwiftUI animations.
///
/// This struct is designed to facilitate the animation of changes to data in SwiftUI views. It encapsulates
/// data along with an optional `Animation` object, allowing SwiftUI to manage and animate transitions
/// when the data changes. It includes an `id` to uniquely identify instances, supporting SwiftUI's
/// requirements for identifying views in a list or similar collection.
///
/// - Parameter Data: The type of the data to be stored and possibly animated.
@usableFromInline
struct AnimationBox<Data>: Equatable, Identifiable {
    /// Conforms to the Equatable protocol, allowing SwiftUI to determine when the box's contents have changed.
    /// Compares two instances based on their unique identifiers.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `AnimationBox` instance for comparison.
    ///   - rhs: The right-hand side `AnimationBox` instance for comparison.
    /// - Returns: A Boolean value indicating whether the two instances are considered equivalent.
    @usableFromInline
    static func == (lhs: AnimationBox<Data>, rhs: AnimationBox<Data>) -> Bool {
        lhs.id == rhs.id
    }

    /// A unique identifier for each instance, used by SwiftUI to manage and animate views efficiently.
    @usableFromInline
    let id = UUID()

    /// The animation to apply when the data changes. If nil, changes to the data will not be animated.
    let animation: Animation?

    /// The data held by this box. Changes to this data might be animated if `animation` is not nil.
    let data: Data

    /// The type of the data stored in this box. This is used to support type-safe operations on the data.
    let type: Any.Type

    /// Initializes a new `AnimatableBox` with the specified animation and data.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply to changes in the data. Pass nil if changes should not be animated.
    ///   - data: The data to store and animate in this box.
    @usableFromInline
    init(_ animation: Animation?, _ data: Data) {
        self.animation = animation
        self.data = data
        type = Data.self
    }
}

extension Context {
    /// A data object that holds and manages UI related data for property pickers within a SwiftUI application.
    ///
    /// This class serves as a centralized store for various configurations and properties related to displaying
    /// property pickers. It uses `@Published` properties to ensure that views observing this context will
    /// update automatically in response to changes, supporting reactive UI updates.
    final class Data: ObservableObject {
        init() {}

        @Published
        var title: Text? = TitlePreference.defaultValue {
            didSet {
                #if VERBOSE
                    print("\(Self.self): Updated Title \"\(String(describing: title))\"")
                #endif
            }
        }

        @Published
        var rows: Set<Property> = [] {
            didSet {
                #if VERBOSE
                    print("\(Self.self): Updated Rows \(rows.map(\.title).sorted())")
                #endif
            }
        }

        @Published
        var rowBuilders: [PropertyID: RowBuilder] = [:] {
            didSet {
                #if VERBOSE
                    print("\(Self.self): Updated Builders \(rowBuilders.keys.map(\.debugDescription))")
                #endif
            }
        }
    }
}

/// Represents a dynamic value entry with a unique identifier, title, and selectable labels.
public struct Property: Identifiable {
    /// A unique identifier for the entry.
    public let id: PropertyID

    /// The title of the entry, used as a label in the UI.
    public let title: String

    /// The options available for selection.
    public let options: [PropertyOption]

    /// Signal view updates
    let token: AnyHashable

    /// The formatted selection.
    let formattedSelection: String

    /// A binding to the currently selected option.
    @Binding public var selection: String
}

extension Property: Equatable {
    /// Determines if two entries are equal based on their identifiers.
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.id == rhs.id && lhs.token == rhs.token
    }
}

extension Property: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(token)
    }
}

extension Property: Comparable {
    public static func < (lhs: Property, rhs: Property) -> Bool {
        lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
    }
}

/// `PropertyID` provides a unique identifier for property picker elements,
/// facilitating the tracking and management of property picker states and configurations
/// across different components of an application.
public struct PropertyID: Hashable, CustomDebugStringConvertible {
    public var metadata: UnsafeRawPointer

    public init<K: PropertyPickerKey>(_: K.Type = K.self) {
        metadata = unsafeBitCast(K.self, to: UnsafeRawPointer.self)
    }

    public var debugDescription: String {
        _typeName(unsafeBitCast(metadata, to: Any.Type.self), qualified: false)
    }
}

/// A representation of a property option that can be identified by a unique string.
///
/// `PropertyOption` is a structure that represents an option with a label and a raw value.
/// It conforms to the `Identifiable` protocol, which requires an `id` property.
public struct PropertyOption: Identifiable {
    /// A unique identifier for the property option.
    ///
    /// This identifier is derived from the `rawValue` property.
    public var id: String { rawValue }

    /// A human-readable label for the property option.
    ///
    /// This label is intended to be displayed to users.
    public var label: String

    /// The raw value of the property option.
    ///
    /// This value is typically used internally to represent the option.
    public var rawValue: String

    /// Initializes a new `PropertyOption`.
    ///
    /// - Parameters:
    ///   - label: A human-readable label for the property option.
    ///   - rawValue: The raw value of the property option.
    init(label: String, rawValue: String) {
        self.label = label
        self.rawValue = rawValue
    }
}

public enum PropertyPickerRowSorting {
    case ascending
    case descending
    case custom(comparator: (_ lhs: Property, _ rhs: Property) -> Bool)

    func sort<D>(_ data: D) -> [Property] where D: Collection, D.Element == Property {
        switch self {
        case .ascending:
            data.sorted()
        case .descending:
            data.sorted().reversed()
        case let .custom(comparator):
            data.sorted { lhs, rhs in
                comparator(lhs, rhs)
            }
        }
    }
}

extension PropertyPickerRowSorting? {
    func sort<D>(_ data: D) -> [Property] where D: Collection, D.Element == Property {
        switch self {
        case .none:
            return Array(data)
        case let .some(wrapped):
            return wrapped.sort(data)
        }
    }
}

/// An enumeration that defines the adjustment styles for safe area insets in property picker contexts.
///
/// It specifies how a property picker should adjust its content to accommodate safe area insets,
/// ensuring that the picker does not obstruct critical parts of the user interface, such as input fields or buttons.
/// This adjustment is particularly useful in scenarios where property pickers alter the layout dynamically,
/// such as appearing as overlays or within modal presentations.
public enum PropertyPickerSafeAreaAdjustmentStyle {
    /// Adjusts the safe area insets automatically based on system guidelines and the presence of elements like keyboards
    /// or bottom bars that may overlap the property picker's content.
    case automatic

    /// Does not make any adjustments to the safe area insets, allowing the content to maintain its layout
    /// irrespective of environmental changes. This setting is suitable when the UI design specifies that elements
    /// should not react to overlaying interfaces.
    case never
}

public struct PropertyPickerTextTransformation: OptionSet {
    public let rawValue: Int8

    public init(rawValue: Int8) {
        self.rawValue = rawValue
    }

    public static let none = Self()
    public static let capitalize = Self(rawValue: 1 << 0)
    public static let lowercase = Self(rawValue: 1 << 1)
    public static let uppercase = Self(rawValue: 1 << 2)
    public static let camelCaseToWords = Self(rawValue: 1 << 3)
    public static let snakeCaseToWords = Self(rawValue: 1 << 4)

    func apply(to text: String) -> String {
        var text = text
        if contains(.camelCaseToWords) {
            text = text.addingSpacesToCamelCase()
        }
        if contains(.snakeCaseToWords) {
            text = text.replacingOccurrences(of: "_", with: " ")
        }
        if contains(.capitalize) {
            text = text.localizedCapitalized
        }
        if contains(.uppercase) {
            text = text.localizedUppercase
        }
        if contains(.lowercase) {
            text = text.localizedLowercase
        }
        return text
    }
}

// MARK: - Private Helpers

extension String {
    /// Adds spaces before each uppercase letter in a camelCase string.
    /// - Returns: A new string with spaces added before each uppercase letter.
    func addingSpacesToCamelCase() -> String {
        replacingOccurrences(
            of: "(?<=[a-z])(?=[A-Z])",
            with: " $0",
            options: .regularExpression,
            range: range(of: self)
        )
    }

    /// Removes a specified suffix from the string if it ends with that suffix.
    ///
    /// - Parameter suffix: The suffix to remove from the string.
    /// - Returns: The string after the specified suffix has been removed if it was present at the end.
    func removingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else { return self }
        return String(dropLast(suffix.count))
    }

    /// Removes a specified prefix from the string if it ends with that prefix.
    ///
    /// - Parameter prefix: The prefix to remove from the string.
    /// - Returns: The string after the specified prefix has been removed if it was present at the start.
    func removingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else { return self }
        return String(dropFirst(prefix.count))
    }
}

struct RowBuilder: Equatable, Identifiable {
    let id: PropertyID
    let body: (Property) -> AnyView?

    static func == (lhs: RowBuilder, rhs: RowBuilder) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - List Content

public extension View {
    /// Applies a background style to the list content of a property picker with optional animation.
    ///
    /// Use this method to specify a custom background for the list content within a property picker view.
    /// An optional animation parameter allows the background appearance change to be animated.
    ///
    /// - Parameters:
    ///   - style: The `ShapeStyle` to apply as the background of the list content. If nil, the background is not modified.
    ///   - animation: Optional animation to apply when the background style changes.
    @available(iOS 16.0, *)
    @inlinable
    @_disfavoredOverload
    func propertyPickerListContentBackground<S>(_ style: S?, _ animation: Animation? = nil) -> some View where S: ShapeStyle {
        modifier(
            PreferenceWriter(
                type: ContentBackgroundStylePreference.self,
                value: {
                    guard let style else { return nil }
                    return AnimationBox(animation, AnyShapeStyle(style))
                }()
            )
        )
    }

    /// Applies a background style to the list content of a property picker with optional animation.
    ///
    /// Use this method to specify a custom background for the list content within a property picker view.
    /// An optional animation parameter allows the background appearance change to be animated.
    ///
    /// - Parameters:
    ///   - style: The `ShapeStyle` to apply as the background of the list content. If nil, the background is not modified.
    ///   - animation: Optional animation to apply when the background style changes.
    @available(iOS 16.0, *)
    func propertyPickerListContentBackground<S>(_ style: S, _ animation: Animation? = nil) -> some View where S: ShapeStyle {
        modifier(
            PreferenceWriter(
                type: ContentBackgroundStylePreference.self,
                value: AnimationBox(animation, AnyShapeStyle(style))
            )
        )
    }
}

// MARK: - Row

public extension View {
    @inlinable
    func propertyPickerRowBackground(@ViewBuilder background: () -> some View) -> some View {
        environment(\.rowBackground, AnyView(background()))
    }

    @inlinable
    func propertyPickerRowBackground<S>(_ style: S) -> some View where S: ShapeStyle & View {
        environment(\.rowBackground, AnyView(style))
    }

    @inlinable
    @_disfavoredOverload
    func propertyPickerRowBackground<B>(_ background: B?) -> some View where B: View {
        environment(\.rowBackground, AnyView(background))
    }

    /// Adds a custom view builder to a property picker for a specific property key type.
    ///
    /// This method allows customization of the presentation for a specific property within a property picker.
    /// The provided view builder closure is used to generate the view whenever the specific property is rendered.
    ///
    /// - Parameters:
    ///   - key: The property key type for which the custom view is being provided.
    ///   - body: A closure that takes a `Property` instance and returns a view (`Row`) for that property.
    @inlinable
    func propertyPickerRow<K, Row>(for key: K.Type, @ViewBuilder body: @escaping (_ data: Property) -> Row) -> some View where K: PropertyPickerKey, Row: View {
        modifier(
            RowBuilderWriter(key: key, row: body)
        )
    }

    /// Hides the property picker for a specific property key type.
    ///
    /// - Parameters:
    ///   - key: The property key type for which the custom view is being provided.
    @inlinable
    func propertyPickerRowHidden<K>(for key: K.Type = K.self) -> some View where K: PropertyPickerKey {
        modifier(
            RowBuilderWriter(key: key, row: { _ in EmptyView() })
        )
    }

    /// Sets the sorting order for the rows in the property picker.
    ///
    /// This method allows you to specify a custom sorting order for the rows displayed in the property picker,
    /// ensuring that the items are presented in the desired sequence.
    ///
    /// - Parameter sort: A ``PropertyPickerRowSorting`` instance that defines the sorting order for the rows.
    ///   Pass `nil` to use the default sorting order.
    /// - Returns: A view that applies the specified sorting order to the rows.
    @inlinable
    func propertyPickerRowSorting(_ sort: PropertyPickerRowSorting?) -> some View {
        environment(\.rowSorting, sort)
    }
}

// MARK: - Title

public extension View {
    /// Sets the title for a property picker using a localized string key.
    ///
    /// This method allows you to specify a title for the property picker, supporting localization.
    ///
    /// - Parameter title: The localized string key used for the title. If nil, no title is set.
    func propertyPickerTitle(_ title: LocalizedStringKey) -> some View {
        modifier(
            PreferenceWriter(
                type: TitlePreference.self,
                value: Text(title)
            )
        )
    }

    /// Sets the title for a property picker using a plain string.
    ///
    /// This version allows you to specify a title using a non-localized string.
    ///
    /// - Parameter title: The string to use as the title. If nil, no title is set.
    @_disfavoredOverload
    func propertyPickerTitle(_ title: String? = nil) -> some View {
        modifier(
            PreferenceWriter(
                type: TitlePreference.self,
                value: {
                    if let title { return Text(verbatim: title) }
                    return nil
                }()
            )
        )
    }

    /// Sets the transformation applied to the property picker's key titles.
    ///
    /// This method allows you to define how the titles of the property picker keys should be transformed,
    /// such as applying capitalization, modifying text format, or other custom transformations.
    ///
    /// - Parameter transform: A ``PropertyPickerTextTransformation`` instance that defines the transformation
    ///   to apply to the key titles.
    /// - Returns: A view that applies the specified transformation to the key titles.
    @inlinable
    func propertyPickerTitleTransformation(_ transform: PropertyPickerTextTransformation) -> some View {
        environment(\.titleTransformation, transform)
    }
}

// MARK: - Label

public extension View {
    /// Sets the transformation applied to the property picker's key labels.
    ///
    /// This method allows you to define how the labels of the property picker keys should be transformed,
    /// enabling custom formatting or modifications to the display of key labels.
    ///
    /// - Parameter transform: A ``PropertyPickerTextTransformation`` instance that defines the transformation
    ///   to apply to the key labels.
    /// - Returns: A view that applies the specified transformation to the key labels.
    @inlinable
    func propertyPickerLabelTransformation(_ transform: PropertyPickerTextTransformation) -> some View {
        environment(\.labelTransformation, transform)
    }
}

// MARK: - State

public extension View {
    /// Registers this view for receiving selection updates of a property.
    ///
    /// This method sets up a property picker that responds to changes in the selection state. It observes and writes
    /// changes to the property picker's state, ensuring the view remains in sync with the underlying model.
    ///
    /// - Parameters:
    ///   - state: A ``PropertyPickerState`` instance which holds the current selection state and is used to update
    ///   and react to changes in the property picker's selected value.
    /// - Returns: A view that binds the property picker's selection to the provided state, ensuring the UI reflects
    ///   changes to and from the state.
    @inlinable
    func propertyPicker<K>(
        _ state: PropertyPickerState<K, Void>
    ) -> some View where K: PropertyPickerKey, K: Equatable {
        modifier(
            PropertyWriter(
                type: K.self,
                selection: state.selection
            )
        )
    }

    /// Registers this view for receiving selection updates of a property.
    ///
    /// This method sets up a property picker that responds to changes in the selection state. It observes and writes
    /// changes to the property picker's state, ensuring the view remains in sync with the underlying model.
    ///
    /// - Parameters:
    ///   - state: A ``PropertyPickerState`` instance which holds the current selection state and is used to update
    ///   and react to changes in the property picker's selected value.
    ///   - animation: An optional animation to apply the use when applying the changes.
    /// - Returns: A view that binds the property picker's selection to the provided state, ensuring the UI reflects
    ///   changes to and from the state.
    @inlinable
    func propertyPicker<K>(
        _ state: PropertyPickerState<K, Void>,
        animation: Animation?
    ) -> some View where K: PropertyPickerKey, K: Equatable {
        propertyPicker(state).propertyPickerStateAnimation(animation)
    }

    /// Registers this view for receiving selection updates of a property in the SwiftUI environment.
    ///
    /// This method sets up a property picker that responds to changes in the selection state. It observes and writes
    /// changes to the property picker's state, ensuring the view remains in sync with the underlying model.
    ///
    /// - Note:
    /// - Parameters:
    ///   - state: A ``PropertyPickerState`` instance which holds the current selection state and is used to update
    ///   and react to changes in the property picker's selected value.
    ///   - animation: Override the global when the user selection changes.
    /// - Returns: A view that binds the property picker's selection to the provided state, ensuring the UI reflects
    ///   changes to and from the state.
    @inlinable
    func propertyPicker<K>(
        _ state: PropertyPickerState<K, K.KeyPath>
    ) -> some View where K: PropertyPickerKey, K: Equatable {
        modifier(
            PropertyWriter(
                type: K.self,
                selection: state.selection
            )
        )
        .environment(state.data, state.wrappedValue)
    }

    /// Registers this view for receiving selection updates of a property in the SwiftUI environment.
    ///
    /// This method sets up a property picker that responds to changes in the selection state. It observes and writes
    /// changes to the property picker's state, ensuring the view remains in sync with the underlying model.
    ///
    /// - Note:
    /// - Parameters:
    ///   - state: A ``PropertyPickerState`` instance which holds the current selection state and is used to update
    ///   and react to changes in the property picker's selected value.
    ///   - animation: Override the global when the user selection changes.
    /// - Returns: A view that binds the property picker's selection to the provided state, ensuring the UI reflects
    ///   changes to and from the state.
    @inlinable
    func propertyPicker<K>(
        _ state: PropertyPickerState<K, K.KeyPath>,
        animation: Animation?
    ) -> some View where K: PropertyPickerKey, K: Equatable {
        propertyPicker(state).propertyPickerStateAnimation(animation)
    }

    /// Sets the default animation for changes when ``PropertyPickerState`` selection changes.
    @inlinable
    func propertyPickerStateAnimation(_ animation: Animation? = nil) -> some View {
        environment(\.selectionAnimation, animation)
    }
}

// MARK: - Sheet Presentation

public extension View {
    /// Sets the safe area adjustment style for a property picker within the view.
    ///
    /// This method configures how the view should adjust its content relative to the safe area insets,
    /// which is particularly useful for views like property pickers that might need to dynamically adjust
    /// their layout in response to on-screen keyboards or other overlaying UI elements.
    ///
    /// - Parameter adjustment: The `PropertyPickerSafeAreaAdjustmentStyle` specifying the adjustment behavior.
    /// - Returns: A view modified with the specified safe area adjustment style.
    @inlinable
    func propertyPickerSafeAreaAdjustment(_ adjustment: PropertyPickerSafeAreaAdjustmentStyle) -> some View {
        environment(\.safeAreaAdjustment, adjustment)
    }

    /// Sets the available detents for the picker when presented as a sheet.
    ///
    /// - Parameter detents: A set of supported detents for the sheet.
    ///   If you provide more that one detent, people can drag the sheet
    ///   to resize it.
    @available(iOS 16.0, macOS 13.0, *)
    @inlinable
    func propertyPickerPresentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        environment(\.presentationDetents, detents).environment(\.selectedDetent, nil)
    }

    /// Sets the available detents for the picker when presented as a sheet, giving you
    /// programmatic control of the currently selected detent.
    ///
    /// - Parameters:
    ///   - detents: A set of supported detents for the sheet.
    ///     If you provide more that one detent, people can drag the sheet
    ///     to resize it.
    ///   - selection: A ``Binding`` to the currently selected detent.
    ///     Ensure that the value matches one of the detents that you
    ///     provide for the `detents` parameter.
    @available(iOS 16.0, macOS 13.0, *)
    func propertyPickerPresentationDetents(_ detents: Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View {
        environment(\.presentationDetents, detents).environment(\.selectedDetent, selection)
    }
}

/// A SwiftUI view that enables dynamic property selection.
///
/// This view acts as a container that integrates with the property picker system to allow users
/// to dynamically select properties and apply them to the enclosed content.
public struct PropertyPicker<Content: View, Style: PropertyPickerStyle>: View {
    /// The content to be presented alongside the dynamic value selector.
    var content: Content

    /// The presentation style
    var style: Style

    @_disfavoredOverload
    public init(style: Style, @ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = style
    }

    /// A view modifier that updates a shared context with changes from preference keys.
    private var context = Context()

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        content
            .modifier(style)
            .modifier(context)
    }
}

// MARK: - Inline Style

public extension PropertyPicker where Style == _InlinePropertyPicker {
    /// Initializes a ``PropertyPicker`` with an inline presentation style.
    ///
    /// This initializer sets up a property picker that displays its content directly within the surrounding view hierarchy,
    /// rather than in a separate modal or layered interface. The inline style is suitable for contexts where space allows
    /// for direct embedding of components without the need for additional navigation.
    ///
    /// - Parameter content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        style = _InlinePropertyPicker()
    }
}

// MARK: - List Style

public extension PropertyPicker {
    /// Initializes a ``PropertyPicker`` using a specific `ListStyle`.
    ///
    /// This initializer configures the property picker to display its items as a list styled according to the provided `ListStyle`.
    /// It allows for customization of the list's appearance and interaction model, making it adaptable to various UI designs.
    ///
    /// - Parameters:
    ///   - style: Defines the list style.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init<S: ListStyle>(style: S, @ViewBuilder content: () -> Content) where Style == _ListPropertyPicker<S> {
        self.content = content()
        self.style = _ListPropertyPicker(listStyle: style)
    }
}

// MARK: - Sheet Style

@available(iOS 16.4, macOS 13.3, *)
public extension PropertyPicker where Style == _SheetPropertyPicker {
    /// Initializes a ``PropertyPicker`` with a sheet presentation style.
    ///
    /// This initializer sets up a property picker to appear as a modal sheet, which slides up from the bottom of the screen.
    /// The sheet's size and how it reacts to different device contexts can be customized through various parameters.
    ///
    /// - Parameters:
    ///   - isPresented: A binding to a Boolean value that determines whether the sheet is presented.
    ///   - content: A `ViewBuilder` closure that generates the content to be displayed within the picker.
    init(isPresented: Binding<Bool>, @ViewBuilder content: () -> Content) {
        self.content = content()
        style = _SheetPropertyPicker(isPresented: isPresented)
    }
}

@available(*, deprecated, renamed: "PropertyPicker", message: "Renamed PropertyPicker")
public typealias PropertyPickerEnvironment<K: PropertyPickerKey> = PropertyPickerState<K, K.KeyPath>

/// A property wrapper that provides state management for a selection within a property picker.
///
/// This property wrapper is designed to work with ``PropertyPickerKey`` and `DynamicProperty`
/// to manage the state of a selected value in a picker view.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey, Data>: DynamicProperty {
    private enum Storage: DynamicProperty {
        case state(State<Key>)
        case binding(Binding<Key>)
    }

    private var storage: Storage

    @usableFromInline
    var data: Data

    /// The value that this property wrapper manages.
    ///
    /// This property returns the value associated with the current selection key.
    public var wrappedValue: Key.PickerValue {
        switch storage {
        case let .state(state):
            state.wrappedValue.value
        case let .binding(binding):
            binding.wrappedValue.value
        }
    }

    /// The projected value of the property wrapper.
    ///
    /// This property returns the instance of `PropertyPickerState` itself.
    public var projectedValue: Self { self }

    /// A binding to the selection key.
    ///
    /// This property provides a binding to the current selection key, allowing the selection
    /// to be read and modified.
    public var selection: Binding<Key> {
        switch storage {
        case let .state(state):
            state.projectedValue
        case let .binding(binding):
            binding.projectedValue
        }
    }
}

public extension PropertyPickerState where Data == Void {
    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue, _: Key.Type = Key.self) {
        storage = .state(State(initialValue: value))
        data = ()
    }

    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    init(wrappedValue value: Key = .defaultValue) where Key == Key.PickerValue {
        storage = .state(State(initialValue: value))
        data = ()
    }
}

public extension PropertyPickerState where Data == Void {
    /// Initializes the property picker state for local usage.
    /// - Parameters:
    ///   - selection: A binding to the currently selected option.
    init(selection: Binding<Key>) {
        storage = .binding(selection)
        data = ()
    }
}

public extension PropertyPickerState where Data == Key.KeyPath {
    /// Initializes the property picker state, linking the local selection to an environment value.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @_disfavoredOverload
    init(keyPath: Key.KeyPath, selection: Binding<Key>) {
        storage = .binding(selection)
        data = keyPath
    }

    /// Initializes the property picker state, linking the local selection to an environment value.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _: Key.Type = Key.self, keyPath: Key.KeyPath) {
        storage = .state(State(initialValue: value))
        data = keyPath
    }

    /// Initializes the property picker state, linking it to an environment value using a key path.
    /// - Parameters:
    ///   - value: An initial value to store in the state property.
    ///   - key: The type of the property key.
    ///   - keyPath: A key path to an environment value that this picker state will sync with.
    @available(*, deprecated, renamed: "init(_:keyPath:)", message: "Renamed")
    @_disfavoredOverload
    init(wrappedValue value: Key = .defaultValue, _ keyPath: Key.KeyPath, _: Key.Type = Key.self) {
        storage = .state(State(initialValue: value))
        data = keyPath
    }
}

/**
 `PropertyPickerKey` encapsulates the essentials of property management within a picker interface. Conforming to this protocol enables types to be used seamlessly in conjunction with ``PropertyPicker``.

 ## Conformance

 To conform to `PropertyPickerKey`, a type must satisfy several requirements, which enable it to interact efficiently with SwiftUI’s environment:

 - **RawRepresentable**: Conformance to `RawRepresentable` with a `RawValue` of `String` allows each property key to be directly associated with a string value, facilitating easy storage and display.
 - **CaseIterable**: This requirement ensures that all possible instances of the type can be listed, which is particularly useful for presenting options in a picker.

 ## Properties

 - `title`: A static property providing a descriptive title for this property. A default value is provided.
 - `defaultValue`: Also static, this property specifies the default selection for the property. It serves as a fallback and initial state when user interactions have not yet altered the current selection. By default the first case is selected.
  - `label`: The label that describes this property instance. If no label is defined, the `rawValue` used instead.
  - `value`: Each instance of a conforming type provides a specific value associated with the property key.

 ## Implementation Example

 Here's a straightforward example of how one might implement `PropertyPickerKey` for a setting that manages text alignment within an application:

 ```swift
 enum TextAlignmentKey: String, PropertyPickerKey {
     case left, center, right
 }
 ```
  - Warning: The `allCases` array must contain at least one item, or a `fatalError()` will be thrown in runtime.

 ## Conclusion

 `PropertyPickerKey` offers a robust foundation for handling selectable properties in SwiftUI. By adhering to this protocol, developers can ensure their property types are well-integrated within the SwiftUI framework, benefiting from both the type safety and the rich user interface capabilities it provides. Whether for simple settings or complex configuration screens, `PropertyPickerKey` paves the way for more organized and maintainable code.
  */
public protocol PropertyPickerKey<PickerValue>: RawRepresentable<String>, CaseIterable where AllCases == [Self] {
    /// The type of the value associated with the property. By default, it is the type of `Self`, allowing for types
    /// where the key and the value are the same.
    associatedtype PickerValue = Self

    typealias KeyPath = WritableKeyPath<EnvironmentValues, Self.PickerValue>

    /// A title for the property group, typically used as a section header or similar in UI elements. This helps users
    /// understand the context or categorization of the properties.
    static var title: String { get }

    /// The title transformation behavior. Default is automatic.
    static var titleTransformation: PropertyPickerTextTransformationBehavior { get }

    /// The default value of the property. This is used both to provide a default state and to reset the property's value.
    static var defaultValue: Self { get }

    /// The specific value associated with an instance of this property. This allows for storing additional metadata or
    /// specifics about the property beyond its enumeration case.
    var value: Self.PickerValue { get }

    /// The label that describes this property instance. If no label is defined, the `rawValue` used instead.
    var label: String { get }

    /// The label transformation behavior. Default is automatic.
    static var labelTransformation: PropertyPickerTextTransformationBehavior { get }
}

public enum PropertyPickerTextTransformationBehavior {
    case automatic, never
}

// MARK: - Convenience Default Label

public extension PropertyPickerKey {
    /// Convenience Default label is the `rawValue`.
    var label: String { rawValue }

    static var labelTransformation: PropertyPickerTextTransformationBehavior { .automatic }

    static var titleTransformation: PropertyPickerTextTransformationBehavior { .automatic }
}

// MARK: - Convenience Default Title

public extension PropertyPickerKey {
    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    static var title: String {
        String(describing: Self.self)
            .removingSuffix("Key")
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

// MARK: - Convenience Default Value

public extension PropertyPickerKey {
    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    static var defaultValue: Self {
        guard let first = allCases.first else {
            fatalError("Keys should have at least one valid option")
        }
        return first
    }
}

// MARK: - Convenience Value

public extension PropertyPickerKey where PickerValue == Self {
    var value: Self { self }
}

/// A protocol defining a customizable style for property pickers within a SwiftUI application.
///
/// Conforming to this protocol allows the creation of distinct visual themes or behaviors for property pickers
/// by implementing a `ViewModifier`. This customization includes the ability to style and layout picker rows, titles,
/// and other components using predefined or custom views that conform to SwiftUI's View.
///
/// Implementations of `PropertyPickerStyle` should utilize the `rows` and `title` properties provided by
/// the protocol extension to maintain consistency and leverage reusable components across different styles.
public protocol PropertyPickerStyle: ViewModifier {}

public extension _ViewModifier_Content where Modifier: PropertyPickerStyle {
    /// Provides a view representing the rows of the property picker.
    /// These rows typically display selectable options or properties within the picker.
    var listRows: some View {
        Rows<ListRow>(row: ListRow.init(data:))
    }

    var inlineRows: some View {
        Rows<InlineRow>(row: InlineRow.init(data:))
    }

    /// Provides a view representing the title of the property picker.
    /// This view is generally used to display a header or title for the picker section.
    var title: some View {
        Title()
    }
}

/// A style that presents dynamic value options inline within the view hierarchy of a property picker.
/// This style uses a vertical stack to organize the content, adding a divider and utilizing the `rows` property
/// to display additional picker options below the main content.
public struct _InlinePropertyPicker: PropertyPickerStyle {
    /// Creates the view for the inline style, embedding the dynamic value options directly within a scrollable area.
    ///
    /// The implementation arranges the picker's standard content and its rows in a `VStack` to ensure they are
    /// displayed inline with appropriate spacing and structural divisions.
    ///
    /// - Parameter content: The dynamic value options and content.
    /// - Returns: A view displaying the dynamic value options inline, enhanced with custom spacing and dividers.
    public func body(content: Content) -> some View {
        preview(content).safeAreaInset(edge: .bottom, spacing: 30) {
            LazyVStack {
                content.inlineRows
            }
        }
    }

    private func preview(_ content: some View) -> some View {
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
    }

    @Environment(\.rowBackground)
    private var rowBackground

    @State
    private var backgroundPreference = ContentBackgroundStylePreference.defaultValue

    private var contentBackground: some ShapeStyle {
        backgroundPreference?.data ?? AnyShapeStyle(.background)
    }
}

// MARK: - List Style

/// A `PropertyPickerStyle` for displaying property picker content within a styled list.
///
/// This style component wraps property picker content in a SwiftUI List, applying a specified list style
/// and optional row background. It integrates additional UI adjustments like content background styling,
/// animations based on user interactions, and custom headers to enhance the visual presentation.
///
/// - Parameters:
///   - S: A `ListStyle` type that defines the appearance of the list.
public struct _ListPropertyPicker<S: ListStyle>: PropertyPickerStyle {
    let listStyle: S

    @Environment(\.rowBackground)
    private var rowBackground

    @State
    private var backgroundPreference = ContentBackgroundStylePreference.defaultValue

    private var contentBackground: some ShapeStyle {
        backgroundPreference?.data ?? AnyShapeStyle(.background)
    }

    public func body(content: Content) -> some View {
        List {
            Section {
                content.listRows.listRowBackground(rowBackground)
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

extension View {
    @ViewBuilder
    func ios16_backgroundStyle<S: ShapeStyle>(_ background: S) -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            backgroundStyle(background)
        } else {
            // Fallback on earlier versions
            self
        }
    }
}

/// A property picker style that presents content in a sheet overlay, with additional customizations for presentation and dismissal.
///
/// This style encapsulates the behavior necessary to present and manage a modal sheet that contains property picker content.
/// It includes custom animations, toolbar adjustments, and dynamic insets based on interaction states.
///
/// - Requires: iOS 16.4 or newer for certain APIs used in this struct.
@available(iOS 16.4, macOS 13.3, *)
public struct _SheetPropertyPicker: PropertyPickerStyle {
    @Binding
    var isPresented: Bool

    @State
    private var _selection = PresentationDetentsKey.defaultValue.first!

    @Environment(\.safeAreaAdjustment)
    private var safeAreaAdjustment

    @Environment(\.sheetAnimation)
    private var animation

    @Environment(\.presentationDetents)
    private var presentationDetents

    @Environment(\.selectedDetent)
    private var customSelection

    @State
    private var contentHeight: Double = 0

    private var safeAreaInset: CGFloat {
        switch safeAreaAdjustment {
        case .automatic where isPresented:
            contentHeight
        case .automatic, .never:
            .zero
        }
    }

    public func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                Spacer().frame(height: safeAreaInset)
            }
            .toolbar(content: {
                ToolbarButton(isPresented: $isPresented)
            })
            .animation(animation, value: safeAreaInset)
            .overlay {
                Spacer().sheet(isPresented: $isPresented) {
                    configureList(
                        Form {
                            Section {
                                content.listRows.listRowBackground(Color.clear)
                            } header: {
                                configureTitle(content.title)
                            }
                        }
                    )
                }
            }
    }

    private func configureTitle(_ title: some View) -> some View {
        title
            .bold()
            .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
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

        @Environment(\.sheetAnimation)
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

/// A view modifier that updates a shared context with changes from preference keys.
///
/// This modifier listens for changes in specified preference keys and updates the corresponding properties
/// in the `Context` object. It ensures that the `Context` stays in sync with the UI elements that might modify these properties.
struct Context: ViewModifier {
    /// A context object that holds and manages UI related data for property pickers within a SwiftUI application.
    @StateObject
    private var data = Data()

    /// The body of the modifier which subscribes to preference changes and updates the context.
    func body(content: Content) -> some View {
        content.onPreferenceChange(PropertyPreference.self) { newValue in
            if data.rows != newValue {
                data.rows = newValue
            }
        }.onPreferenceChange(TitlePreference.self) { newValue in
            if data.title != newValue {
                data.title = newValue
            }
        }.onPreferenceChange(ViewBuilderPreference.self) { newValue in
            if data.rowBuilders != newValue {
                data.rowBuilders = newValue
            }
        }.environmentObject(data)
    }
}

/// A container view that sets a value for any given preference key.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
@usableFromInline
struct PreferenceWriter<Key>: ViewModifier where Key: PreferenceKey {
    var type: Key.Type
    var value: Key.Value
    var verbose: Bool

    @usableFromInline
    init(type: Key.Type, value: Key.Value, verbose: Bool = true) {
        self.type = type
        self.value = value
        self.verbose = verbose
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.background(
            Spacer().preference(key: Key.self, value: value)
        )
    }
}

/// `PropertyWriter` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameter Key: The type of the property picker key, conforming to `PropertyPickerKey`.
@usableFromInline
struct PropertyWriter<Key>: ViewModifier where Key: PropertyPickerKey {
    let type: Key.Type

    @Binding
    var selection: Key

    @usableFromInline
    init(
        type: Key.Type,
        selection: Binding<Key>
    ) {
        self.type = type
        _selection = selection
    }

    @Environment(\.selectionAnimation)
    private var animation

    @Environment(\.labelTransformation)
    private var labelTransformation

    @Environment(\.titleTransformation)
    private var titleTransformation

    @usableFromInline
    func body(content: Content) -> some View {
        content.modifier(
            PreferenceWriter(
                type: PropertyPreference.self,
                value: [property],
                verbose: false
            )
        )
    }

    /// The item representing the currently selected value, used for updating the UI and storing preferences.
    private var property: Property {
        let id = PropertyID(Key.self)
        let title = title()
        let options = Key.allCases.map {
            PropertyOption(
                label: label(for: $0),
                rawValue: $0.rawValue
            )
        }
        return Property(
            id: id,
            title: title,
            options: options,
            token: selection.rawValue.hashValue,
            formattedSelection: label(for: selection),
            selection: Binding {
                selection.rawValue
            } set: { newValue in
                guard newValue != selection.rawValue else {
                    return
                }
                if let newKey = Key(rawValue: newValue) {
                    withAnimation(animation) {
                        selection = newKey
                    }
                } else {
                    assertionFailure("\(Self.self): Couldn't initialize case with \"\(newValue)\". Valid options: \(options.map(\.label))")
                }
            }
        )
    }

    private func title() -> String {
        switch Key.titleTransformation {
        case .automatic:
            titleTransformation.apply(to: Key.title)
        case .never:
            Key.title
        }
    }

    private func label(for key: Key) -> String {
        switch Key.labelTransformation {
        case .automatic:
            labelTransformation.apply(to: key.label)
        case .never:
            key.label
        }
    }
}

@usableFromInline
struct RowBuilderWriter<Key, Row>: ViewModifier where Key: PropertyPickerKey, Row: View {
    var key: Key.Type

    @ViewBuilder
    var row: (Property) -> Row

    @usableFromInline
    init(key: Key.Type, row: @escaping (_ data: Property) -> Row) {
        self.key = key
        self.row = row
    }

    private var id: PropertyID {
        PropertyID(key)
    }

    private var rowBuilder: RowBuilder {
        .init(id: id, body: { data in
            AnyView(row(data))
        })
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.modifier(
            PreferenceWriter(
                type: ViewBuilderPreference.self,
                value: [id: rowBuilder],
                verbose: false
            )
        )
    }
}

struct InlineRow: View {
    var data: Property

    @Environment(\.selectionAnimation)
    private var animation

    private var picker: some View {
        Picker(data.title, selection: data.$selection) {
            ForEach(data.options) { option in
                Text(option.label)
            }
        }
    }

    var body: some View {
        Menu {
            picker
        } label: {
            HStack {
                Text(verbatim: data.title).layoutPriority(1)
                Group {
                    Text(verbatim: data.formattedSelection)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "chevron.up.chevron.down")
                }
                .opacity(0.5)
            }
            .padding(.vertical, 8)
        }
        .foregroundStyle(.foreground)
        .safeAreaInset(
            edge: .bottom,
            spacing: .zero,
            content: Divider.init
        )
    }
}

struct ListRow: View {
    var data: Property

    var body: some View {
        Picker(data.title, selection: data.$selection) {
            ForEach(data.options) { option in
                Text(option.label)
            }
        }
    }
}

struct Rows<V>: View where V: View {
    var row: (Property) -> V

    @EnvironmentObject
    private var context: Context.Data

    @Environment(\.rowSorting)
    private var rowSorting

    var body: some View {
        ForEach(rowSorting.sort(context.rows)) { property in
            if let body = makeBody(configuration: property) {
                body
            } else {
                row(property)
            }
        }
    }

    private func makeBody(configuration property: Property) -> AnyView? {
        if let customBuilder = context.rowBuilders[property.id] {
            let body = customBuilder.body(property)
            return body
        }
        return nil
    }
}

struct Title: View {
    @EnvironmentObject
    private var context: Context.Data

    var body: some View {
        context.title
    }
}
