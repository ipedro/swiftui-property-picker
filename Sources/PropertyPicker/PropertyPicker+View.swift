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
    @available(iOS 16.0, *)
    func propertyPickerListContentBackground<S: ShapeStyle>(
        _ style: S?,
        _ animation: Animation? = nil
    ) -> some View {
        setPreferenceChange(
            ContentBackgroundPreference.self,
            value: {
                guard let style else { return nil }
                return ContentBackgroundContext(animation, style)
            }()
        )
    }

    func propertyPicker<K: PropertyPickerKey, Row: View>(
        for key: K.Type = K.self,
        @ViewBuilder body: @escaping (_ property: Property) -> Row
    ) -> some View {
        let keyType = String(describing: key)
        let viewBuilder = PropertyViewBuilder { someProp in
            if someProp.keyType == String(describing: key) {
                return AnyView(body(someProp))
            }
            return nil
        }
        let value = [keyType: viewBuilder]
        return setPreferenceChange(
            ViewBuilderPreference.self,
            value: value
        )
    }

    func propertyPickerTitle(_ title: LocalizedStringKey?) -> some View {
        setPreferenceChange(
            TitlePreference.self,
            value: {
                if let title { return Text(title) }
                return nil
            }()
        )
    }

    func propertyPickerTitle(_ title: String?) -> some View {
        setPreferenceChange(
            TitlePreference.self,
            value: {
                if let title { return Text(verbatim: title) }
                return nil
            }()
        )
    }

    /// Adds a dynamic property selection capability to the view using a `PropertyPickerState`.
    ///
    /// This allows the view to update its state based on user selection from a set of predefined options.
    ///
    /// - Parameters:
    ///   - pickerState: A `PropertyPickerState` instance representing the current selection state.
    ///
    /// - Returns: A view that updates its state based on the selected property value.
    func propertyPicker<Key: PropertyPickerKey>(
        _ pickerState: PropertyPickerState<Key>
    ) -> some View where Key.Value: Equatable {
        PickerSelectionReader(pickerState.key) { initialValue in
            onChange(of: initialValue) { newValue in
                pickerState.state = newValue
            }
        }
    }

    /// Adds a dynamic property selection capability to the view using a `PropertyPickerEnvironment`.
    ///
    /// This allows the view to update its state based on user selection from a set of predefined options.
    ///
    /// - Parameters:
    ///   - pickerEnvironment: A `PropertyPickerEnvironment` instance representing the current selection state.
    ///
    /// - Returns: A view that updates its state based on the selected property value.
    func propertyPicker<Key: PropertyPickerKey>(
        _ pickerEnvironment: PropertyPickerEnvironment<Key>
    ) -> some View where Key.Value: Equatable {
        PickerSelectionReader(pickerEnvironment.key) { value in
            environment(pickerEnvironment.keyPath, value)
        }
    }

    /// Adds a dynamic property selector to the view for a specific state binding.
    ///
    /// This variant uses a `Binding` to directly modify a property on the view's state.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - state: A binding to the property's current value.
    ///
    /// - Returns: A modified view that reflects changes to the selected property.
    func propertyPicker<Key: PropertyPickerKey>(
        _ key: Key.Type,
        _ value: Binding<Key.Value>
    ) -> some View where Key.Value: Equatable {
        PickerSelectionReader(key) { initialValue in
            onChange(of: initialValue) { newValue in
                value.wrappedValue = newValue
            }
        }
    }

    /// Adds a dynamic property selector that modifies an environment value.
    ///
    /// This variant allows modifying SwiftUI's environment values dynamically.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - environmentKeyPath: The key path to the specific environment value to modify.
    ///
    /// - Returns: A view that modifies an environment value based on the selected property.
    func propertyPicker<Key: PropertyPickerKey>(
        _ key: Key.Type,
        _ environmentKeyPath: WritableKeyPath<EnvironmentValues, Key.Value>
    ) -> some View {
        PickerSelectionReader(key) { value in
            environment(environmentKeyPath, value)
        }
    }

    /// Applies a custom style to the property picker presentation.
    ///
    /// - Parameter style: The property picker style to apply.
    ///
    /// - Returns: A view modified with the specified property picker style.
    func propertyPickerStyle<S: PropertyPickerStyle>(_ style: S) -> some View {
        environment(\.propertyPickerStyle, style)
    }
}
