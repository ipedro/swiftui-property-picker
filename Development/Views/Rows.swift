import SwiftUI

struct Rows<V>: View where V: View {
    var row: (Property) -> V

    @EnvironmentObject
    private var context: Context.Data

    @Environment(\.rowSorting)
    private var rowSorting

    var body: some View {
        ForEach(rowSorting.sort(context.rows)) { property in
            if let body = makeBody(configuration: property) {
                body
            } else {
                row(property)
            }
        }
    }

    private func makeBody(configuration property: Property) -> AnyView? {
        if let customBuilder = context.rowBuilders[property.id] {
            let body = customBuilder.body(property)
            return body
        }
        return nil
    }
}
