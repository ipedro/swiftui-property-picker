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
struct Rows: View {
    @EnvironmentObject
    private var context: Context

    var body: some View {
        ForEach(context.rows.sorted()) { property in
            if let custom = makeCustom(configuration: property) {
                custom
            } else {
                makeDefault(configuration: property)
            }
        }
    }

    private var emptyMessage: String {
        "Nothing yet"
    }

    private func makeCustom(configuration property: Property) -> AnyView? {
        for key in context.rowBuilders.keys where key == property.key {
            if let view = context.rowBuilders[key]?.body(property) {
                return view
            }
        }
        return nil
    }

    private func makeDefault(configuration property: Property) -> Picker<Text, String, ForEach<[String], String, Text>> {
        Picker(property.title, selection: property.$selection) {
            ForEach(property.options, id: \.self) { option in
                Text(option)
            }
        }
    }
}
