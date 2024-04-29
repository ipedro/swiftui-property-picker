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

/// `PickerSelectionReader` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
struct PickerSelectionReader<K, C>: View where K: PropertyPickerKey, C: View {

    /// Internal ObservableObject for managing the dynamic selection state.
    private class Store: ObservableObject {
        private(set) var id = UUID()
        @Published var selection = K.defaultCase {
            willSet { id = UUID() }
        }
    }

    /// The current selection state of the dynamic value, observed for changes to update the view.
    @StateObject private var store = Store()

    /// A view builder closure that creates the content view based on the current selection.
    /// This allows the view to reactively update in response to changes in the selection.
    @ViewBuilder private var content: (K.Value) -> C

    /// The item representing the currently selected value, used for updating the UI and storing preferences.
    private var data: Property {
        Property(id: store.id, selection: $store.selection)
    }

    /// Initializes a `PropertyPickerContentView` with the specified key and content closure.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key. Defaults to the key type itself if not specified.
    ///   - content: A view builder closure that takes the current selection's value and returns the content view.
    init(
        _ key: K.Type = K.self,
        @ViewBuilder content: @escaping (K.Value) -> C
    ) {
        self.content = content
    }

    private var selectedValue: K.Value {
        store.selection.value
    }
    /// The body of the `PropertyPickerContentView`, rendering the content based on the current selection.
    /// It uses a clear background view to capture preference changes, allowing the dynamic property picker system to react.
    var body: some View {
        content(selectedValue).modifier(
            PreferenceValueModifier<PropertyPreference>([data])
        )
    }
}
