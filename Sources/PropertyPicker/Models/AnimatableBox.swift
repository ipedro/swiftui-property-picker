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

/// A generic container that associates arbitrary data with an animation, suitable for use in SwiftUI animations.
///
/// This struct is designed to facilitate the animation of changes to data in SwiftUI views. It encapsulates
/// data along with an optional `Animation` object, allowing SwiftUI to manage and animate transitions
/// when the data changes. It includes an `id` to uniquely identify instances, supporting SwiftUI's
/// requirements for identifying views in a list or similar collection.
///
/// - Parameter Data: The type of the data to be stored and possibly animated.
struct AnimatableBox<Data>: Equatable, Identifiable {
    /// Conforms to the Equatable protocol, allowing SwiftUI to determine when the box's contents have changed.
    /// Compares two instances based on their unique identifiers.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `AnimatableBox` instance for comparison.
    ///   - rhs: The right-hand side `AnimatableBox` instance for comparison.
    /// - Returns: A Boolean value indicating whether the two instances are considered equivalent.
    static func == (lhs: AnimatableBox<Data>, rhs: AnimatableBox<Data>) -> Bool {
        lhs.id == rhs.id
    }

    /// A unique identifier for each instance, used by SwiftUI to manage and animate views efficiently.
    let id = UUID()

    /// The animation to apply when the data changes. If nil, changes to the data will not be animated.
    let animation: Animation?

    /// The data held by this box. Changes to this data might be animated if `animation` is not nil.
    let data: Data

    /// The type of the data stored in this box. This is used to support type-safe operations on the data.
    let type: Any.Type

    /// Initializes a new `AnimatableBox` with the specified animation and data.
    ///
    /// - Parameters:
    ///   - animation: The animation to apply to changes in the data. Pass nil if changes should not be animated.
    ///   - data: The data to store and animate in this box.
    init(_ animation: Animation?, _ data: Data) {
        self.animation = animation
        self.data = data
        self.type = Data.self
    }
}
