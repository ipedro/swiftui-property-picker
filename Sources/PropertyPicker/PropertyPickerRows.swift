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

/// Represents the dynamic value entries within the selector.
public struct PropertyPickerRows: View {
    @EnvironmentObject
    private var context: Context

    public var body: some View {
        ForEach(context.properties.sorted()) { property in
            if let customPicker = makeBody(configuration: (property, context.viewBuilders)) {
                customPicker
            } else {
                defaultPicker(configuration: property)
            }
        }
    }

    private var emptyMessage: String {
        "Nothing yet"
    }

    private func makeBody(configuration: (item: Property, source: [ObjectIdentifier: PropertyViewBuilder])) -> AnyView? {
        for key in configuration.source.keys where key == configuration.item.key {
            if let view = configuration.source[key]?.view(configuration.item) {
                return view
            }
        }
        return nil
    }

    // TODO: move to view builder
    private func defaultPicker(configuration property: Property) -> some View {
        Picker(property.title, selection: property.$selection) {
            ForEach(property.options, id: \.self) { option in
                Text(option).tag(option)
            }
        }
    }
}
