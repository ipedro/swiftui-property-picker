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

import Foundation

public enum PropertyPickerRowSorting {
    case ascending
    case descending
    case custom(comparator: (_ lhs: PropertyData, _ rhs: PropertyData) -> Bool)

    func sort<D>(_ data: D) -> [PropertyData] where D: Collection, D.Element == PropertyData {
        switch self {
        case .ascending:
            data.sorted()
        case .descending:
            data.sorted().reversed()
        case .custom(let comparator):
            data.sorted { lhs, rhs in
                comparator(lhs, rhs)
            }
        }
    }
}

extension Optional<PropertyPickerRowSorting> {
    func sort<D>(_ data: D) -> [PropertyData] where D: Collection, D.Element == PropertyData {
        switch self {
        case .none:
            return Array(data)
        case .some(let wrapped):
            return wrapped.sort(data)
        }
    }
}
