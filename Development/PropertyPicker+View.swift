import SwiftUI

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
    @available(iOS 16.0, *)
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
    @available(iOS 16.0, *)
    func propertyPickerPresentationDetents(_ detents: Set<PresentationDetent>, selection: Binding<PresentationDetent>) -> some View {
        environment(\.presentationDetents, detents).environment(\.selectedDetent, selection)
    }
}
