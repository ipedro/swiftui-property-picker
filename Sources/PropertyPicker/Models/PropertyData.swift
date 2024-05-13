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

/// Represents a dynamic value entry with a unique identifier, title, and selectable labels.
public struct PropertyData: Identifiable {
    /// A unique identifier for the entry.
    public let id: PropertyID
    
    /// The title of the entry, used as a label in the UI.
    public let title: String
    
    /// The options available for selection.
    public let options: [Option]

    public struct Option: Identifiable {
        public var id: String { rawValue }
        let label: String
        let rawValue: String
    }

    /// Signal view updates
    let changeToken: Int
    
    /// A binding to the currently selected option.
    @Binding public var selection: String
}

extension PropertyData: Equatable {
    /// Determines if two entries are equal based on their identifiers.
    public static func == (lhs: PropertyData, rhs: PropertyData) -> Bool {
        lhs.id == rhs.id && lhs.changeToken == rhs.changeToken
    }
}

extension PropertyData: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(changeToken)
    }
}

extension PropertyData: Comparable {
    public static func < (lhs: PropertyData, rhs: PropertyData) -> Bool {
        lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
    }
}
