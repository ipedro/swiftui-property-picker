import struct SwiftUI.AnyView

struct RowBuilder: Equatable, Identifiable {
    let id: PropertyID
    let body: (Property) -> AnyView?

    static func == (lhs: RowBuilder, rhs: RowBuilder) -> Bool {
        lhs.id == rhs.id
    }
}
