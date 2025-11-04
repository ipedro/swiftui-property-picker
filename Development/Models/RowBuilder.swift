import SwiftUI

struct RowBuilder: Equatable, Identifiable, @unchecked Sendable {
    let id: PropertyID
    let body: (Property) -> AnyView?

    static func == (lhs: RowBuilder, rhs: RowBuilder) -> Bool {
        lhs.id == rhs.id
    }
}
