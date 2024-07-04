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

/// `PropertyDataWriter` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
struct PropertyDataWriter<Key, Content>: View where Key: PropertyPickerKey, Content: View {
    let type: Key.Type

    /// A view builder closure that creates the content view based on the current selection.
    /// This allows the view to reactively update in response to changes in the selection.
    @ViewBuilder 
    var content: (Key) -> Content

    /// Internal ObservableObject for managing the dynamic selection state.
    private class Context: ObservableObject { // FIXME: change to struct and move to state with injectable context
        var selection = Key.defaultSelection

        @Published
        var changes = 0
    }

    /// The current selection state of the dynamic value, observed for changes to update the view.
    @StateObject
    private var context = Context()

    @Environment(\.labelTransformation)
    private var labelTransformation

    @Environment(\.titleTransformation)
    private var titleTransformation

    var body: some View {
        PreferenceWriter(
            type: PropertyPreference.self,
            value: [property],
            content: content(context.selection)
        )
    }

    /// The item representing the currently selected value, used for updating the UI and storing preferences.
    private var property: PropertyData {
        let id = PropertyID(Key.self)
        let title = titleTransformation.apply(to: Key.title)
        let options = Key.allCases.map {
            PropertyData.Option(
                label: labelTransformation.apply(to: $0.label),
                rawValue: $0.rawValue
            )
        }
        return PropertyData(
            id: id,
            title: title,
            options: options,
            changeToken: context.changes,
            selection: Binding(
                get: {
                    context.selection.rawValue
                },
                set: { newValue in
                    guard newValue != context.selection.rawValue else { return }
                    if let newKey = Key(rawValue: newValue) {
                        context.selection = newKey
                        context.changes += 1
                    }
                }
            )
        )
    }
}
