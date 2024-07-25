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

/// `PropertyWriter` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameter Key: The type of the property picker key, conforming to `PropertyPickerKey`.
struct PropertyWriter<Key>: ViewModifier where Key: PropertyPickerKey {
    let type: Key.Type

    @Binding
    var selection: Key

    @Environment(\.labelTransformation)
    private var labelTransformation

    @Environment(\.titleTransformation)
    private var titleTransformation

    func body(content: Content) -> some View {
        #if VERBOSE
        Self._printChanges()
        #endif
        return content.modifier(
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
        let title = titleTransformation.apply(to: Key.title)
        let options = Key.allCases.map {
            PropertyOption(
                label: labelTransformation.apply(to: $0.label),
                rawValue: $0.rawValue
            )
        }
        return Property(
            id: id,
            title: title,
            options: options, 
            token: selection.rawValue.hashValue,
            selection: Binding {
                selection.rawValue
            } set: { newValue in
                guard newValue != selection.rawValue else {
                    return
                }
                if let newKey = Key(rawValue: newValue) {
                    selection = newKey
                } else {
                    assertionFailure("\(Self.self): Couldn't initialize case with \"\(newValue)\". Valid options: \(options.map(\.label))")
                }
            }
        )
    }
}
