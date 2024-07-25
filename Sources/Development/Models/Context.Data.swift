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

extension Context {
    /// A data object that holds and manages UI related data for property pickers within a SwiftUI application.
    ///
    /// This class serves as a centralized store for various configurations and properties related to displaying
    /// property pickers. It uses `@Published` properties to ensure that views observing this context will
    /// update automatically in response to changes, supporting reactive UI updates.
    final class Data: ObservableObject {
        init() {}

        @Published
        var title: Text? = TitlePreference.defaultValue {
            didSet {
                #if VERBOSE
                print("\(Self.self): Updated Title \"\(String(describing: title))\"")
                #endif
            }
        }

        @Published
        var rows: Set<Property> = [] {
            didSet {
                #if VERBOSE
                print("\(Self.self): Updated Rows \(rows.map(\.title).sorted())")
                #endif
            }
        }

        @Published
        var rowBuilders: [PropertyID: RowBuilder] = [:] {
            didSet {
                #if VERBOSE
                print("\(Self.self): Updated Builders \(rowBuilders.keys.map(\.type))")
                #endif
            }
        }
    }
}
