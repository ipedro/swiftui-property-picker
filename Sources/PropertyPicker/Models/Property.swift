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

/// Represents a dynamic value entry with a unique identifier, title, and selectable options.
public struct Property: Identifiable, Equatable {
    /// A unique identifier for the entry.
    public let id: UUID
    /// The title of the entry, used as a label in the UI.
    public let title: String
    /// A binding to the currently selected option.
    @Binding public var selection: String
    /// The options available for selection.
    public let options: [String]

    let keyType: String

    /// Initializes a new dynamic value entry with the specified parameters.
    ///
    /// - Parameters:
    ///   - key: The property picker key type.
    ///   - selection: A binding to the currently selected key.
    init<Key: PropertyPickerKey>(
        _ key: Key.Type = Key.self,
        id: UUID = UUID(),
        selection: Binding<Key>
    ) {
        self.id = id
        self.keyType = String(describing: key)
        self.options = Key.allCases.map(\.rawValue)
        self.title = Key.defaultDescription
        self._selection = Binding {
            selection.wrappedValue.rawValue
        } set: { rawValue in
            if let newValue = Key(rawValue: rawValue), selection.wrappedValue != newValue {
                selection.wrappedValue = newValue
            }
        }
    }

    /// Determines if two entries are equal based on their identifiers.
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.id == rhs.id
    }
}
