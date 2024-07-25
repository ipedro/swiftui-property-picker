import struct SwiftUI.Animation
import struct SwiftUI.UUID

/// A generic container that associates arbitrary data with an animation, suitable for use in SwiftUI animations.
///
/// This struct is designed to facilitate the animation of changes to data in SwiftUI views. It encapsulates
/// data along with an optional `Animation` object, allowing SwiftUI to manage and animate transitions
/// when the data changes. It includes an `id` to uniquely identify instances, supporting SwiftUI's
/// requirements for identifying views in a list or similar collection.
///
/// - Parameter Data: The type of the data to be stored and possibly animated.
struct AnimationBox<Data>: Equatable, Identifiable {
    /// Conforms to the Equatable protocol, allowing SwiftUI to determine when the box's contents have changed.
    /// Compares two instances based on their unique identifiers.
    ///
    /// - Parameters:
    ///   - lhs: The left-hand side `AnimationBox` instance for comparison.
    ///   - rhs: The right-hand side `AnimationBox` instance for comparison.
    /// - Returns: A Boolean value indicating whether the two instances are considered equivalent.
    static func == (lhs: AnimationBox<Data>, rhs: AnimationBox<Data>) -> Bool {
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
