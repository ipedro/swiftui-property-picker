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
    func propertyPickerListContentBackground<S>(
        _ style: S?,
        _ animation: Animation? = nil
    ) -> some View where S: ShapeStyle {
        self.setPreference(
            ContentBackgroundStylePreference.self,
            value: {
                guard let style else { return nil }
                return AnimationBox(animation, AnyShapeStyle(style))
            }()
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
    func propertyPickerListContentBackground<S>(
        _ style: S,
        _ animation: Animation? = nil
    ) -> some View where S: ShapeStyle {
        self.setPreference(
            ContentBackgroundStylePreference.self,
            value: AnimationBox(animation, AnyShapeStyle(style))
        )
    }

    /// Adds a custom view builder to a property picker for a specific property key type.
    ///
    /// This method allows customization of the presentation for a specific property within a property picker.
    /// The provided view builder closure is used to generate the view whenever the specific property is rendered.
    ///
    /// - Parameters:
    ///   - key: The property key type for which the custom view is being provided.
    ///   - body: A closure that takes a `PropertyData` instance and returns a view (`Row`) for that property.
    func propertyPicker<K, Row>(
        for key: K.Type = K.self,
        @ViewBuilder body: @escaping (_ data: PropertyData) -> Row
    ) -> some View where K: PropertyPickerKey, Row: View {
        let id = PropertyID(key)
        let viewBuilder = PropertyRowBuilder(id: id) { someProp in
            return AnyView(body(someProp))
        }
        return self.setPreference(
            ViewBuilderPreference.self,
            value: [id: viewBuilder]
        )
    }

    /// Sets the title for a property picker using a localized string key.
    ///
    /// This method allows you to specify a title for the property picker, supporting localization.
    ///
    /// - Parameter title: The localized string key used for the title. If nil, no title is set.
    func propertyPickerTitle(_ title: LocalizedStringKey?) -> some View {
        self.setPreference(
            TitlePreference.self,
            value: {
                if let title { return Text(title) }
                return nil
            }()
        )
    }

    /// Sets the title for a property picker using a plain string.
    ///
    /// This version allows you to specify a title using a non-localized string.
    ///
    /// - Parameter title: The string to use as the title. If nil, no title is set.
    @_disfavoredOverload
    func propertyPickerTitle(_ title: String?) -> some View {
        self.setPreference(
            TitlePreference.self,
            value: {
                if let title { return Text(verbatim: title) }
                return nil
            }()
        )
    }

    /// Registers this view for receiving selection updates of a property.
    ///
    /// This method sets up a property picker that responds to changes in the selection state. It observes and writes
    /// changes to the property picker's state, ensuring the view remains in sync with the underlying model.
    ///
    /// - Parameter property: A ``PropertyPicker`` instance which holds the current selection state and is used to update
    ///   and react to changes in the property picker's selected value.
    /// - Returns: A view that binds the property picker's selection to the provided state, ensuring the UI reflects
    ///   changes to and from the state.
    func propertyPicker<K>(_ property: PropertyPicker<K, _LocalStorage<K>>) -> some View where K: PropertyPickerKey, K: Equatable {
        PropertySelector(type: K.self) { data in
            self.onChange(of: data) { newValue in
                property.storage.state = newValue
            }
        }
    }

    /// Registers this view for receiving selection updates of a property in the SwiftUI environment.
    ///
    /// This method sets up a property picker that responds to changes in the selection state. It observes and writes
    /// changes to the property picker's state, ensuring the view remains in sync with the underlying model.
    ///
    /// - Parameter property: A ``PropertyPicker`` instance which holds the current selection state and is used to update
    ///   and react to changes in the property picker's selected value.
    /// - Returns: A view that binds the property picker's selection to the provided state, ensuring the UI reflects
    ///   changes to and from the state.
    func propertyPicker<K>(_ property: PropertyPicker<K, _EnvironmentStorage<K>>) -> some View where K: PropertyPickerKey, K: Equatable {
        PropertySelector(type: K.self) { data in
            self.environment(property.storage.keyPath, data.value)
        }
    }

    /// Sets the safe area adjustment style for a property picker within the view.
    ///
    /// This method configures how the view should adjust its content relative to the safe area insets,
    /// which is particularly useful for views like property pickers that might need to dynamically adjust
    /// their layout in response to on-screen keyboards or other overlaying UI elements.
    ///
    /// - Parameter adjustment: The `PropertyPickerSafeAreaAdjustmentStyle` specifying the adjustment behavior.
    /// - Returns: A view modified with the specified safe area adjustment style.
    func propertyPickerSafeAreaAdjustment(_ adjustment: PropertyPickerSafeAreaAdjustmentStyle) -> some View {
        self.environment(\.safeAreaAdjustment, adjustment)
    }

    /// Sets the available detents for the picker when presented as a sheet.
    ///
    /// - Parameter detents: A set of supported detents for the sheet.
    ///   If you provide more that one detent, people can drag the sheet
    ///   to resize it.
    @available(iOS 16.0, *)
    func propertyPickerPresentationDetents(_ detents: Set<PresentationDetent>) -> some View {
        self.environment(\.presentationDetents, detents)
            .environment(\.selectedDetent, nil)
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
    func propertyPickerPresentationDetents(
        _ detents: Set<PresentationDetent>,
        selection: Binding<PresentationDetent>
    ) -> some View {
        self.environment(\.presentationDetents, detents)
            .environment(\.selectedDetent, selection)
    }
}
