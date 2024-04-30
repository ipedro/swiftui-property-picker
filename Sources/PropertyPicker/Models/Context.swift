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

/// A context object that holds and manages UI related data for property pickers within a SwiftUI application.
///
/// This class serves as a centralized store for various configurations and properties related to displaying
/// property pickers. It uses `@Published` properties to ensure that views observing this context will
/// update automatically in response to changes, supporting reactive UI updates.
final class Context: ObservableObject {
    /// The current title of the property picker, with a default value provided by `TitlePreference`.
    /// This title is observed by the UI components for updates.
    @Published
    var title: Text?

    /// A collection of `Property` objects that are currently active or selected in the UI.
    /// Changes to this set trigger UI updates where this context is observed.
    @Published
    var rows: Set<Property> = []

    /// A dictionary mapping object identifiers to `PropertyPickerBuilder` instances.
    /// These builders are used to dynamically construct views for different types of properties.
    @Published
    var rowBuilders = [ObjectIdentifier: PropertyPickerBuilder]()
}
