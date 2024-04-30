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
            if let custom = makeBody(configuration: property) {
                custom
            } else {
                Row(data: property)
            }
        }
    }

    private func makeBody(configuration property: Property) -> AnyView? {
        for key in context.rowBuilders.keys where key == property.id {
            if let body = context.rowBuilders[key]?.body(property) {
                return body
            }
        }
        return nil
    }
}

struct Row: View {
    var data: Property

    var body: some View {
        Row._printChanges()
        return Picker(data.title, selection: data.$selection) {
            ForEach(data.options, id: \.self) { option in
                Text(option)
            }
        }
    }
}
