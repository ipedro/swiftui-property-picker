import SwiftUI

/// Represents a dynamic value entry with a unique identifier, title, and selectable labels.
public struct Property: Identifiable {
    /// A unique identifier for the entry.
    public let id: PropertyID

    /// The title of the entry, used as a label in the UI.
    public let title: String

    /// The options available for selection.
    public let options: [PropertyOption]

    /// Signal view updates
    let token: AnyHashable
    
    /// The formatted selection.
    let formattedSelection: String

    /// A binding to the currently selected option.
    @Binding public var selection: String
}

extension Property: Equatable {
    /// Determines if two entries are equal based on their identifiers.
    public static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.id == rhs.id && lhs.token == rhs.token
    }
}

extension Property: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(token)
    }
}

extension Property: Comparable {
    public static func < (lhs: Property, rhs: Property) -> Bool {
        lhs.title.localizedStandardCompare(rhs.title) == .orderedAscending
    }
}
