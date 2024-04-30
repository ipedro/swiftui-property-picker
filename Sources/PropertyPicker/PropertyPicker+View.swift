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
        let id = ObjectIdentifier(key)
        let viewBuilder = PropertyViewBuilder { someProp in
            if someProp.id == id {
                return AnyView(body(someProp))
            }
            return nil
        }
        let value = [id: viewBuilder]
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

    /// Adds a dynamic property selection capability to the view using a ``PropertyPickerKey``.
    ///
    /// This allows the view to update its state based on user selection from a set of predefined options.
    ///
    /// - Parameters:
    ///   - state: A ``PropertyPickerState`` instance representing the current selection state.
    ///
    /// - Returns: A view that updates its state based on the selected property value.
    func propertyPicker<K: PropertyPickerKey>(_ state: PropertyPickerState<K>) -> some View where K: Equatable {
        PropertyPickerKeyWriter(K.self) { value in
            onChange(of: value) { newValue in
                if state.selection != newValue {
                    state.selection = newValue
                }
            }
        }
    }

    /// Adds a dynamic property selector that modifies an environment value.
    ///
    /// This variant allows modifying SwiftUI's environment values dynamically.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - keyPath: The key path to the specific environment value to modify.
    ///
    /// - Returns: A view that modifies an environment value based on the selected property.
    func propertyPicker<K: PropertyPickerKey>( _ key: K.Type, _ keyPath: WritableKeyPath<EnvironmentValues, K.Value>) -> some View {
        PropertyPickerKeyWriter(key) { value in
            environment(keyPath, value.value)
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
