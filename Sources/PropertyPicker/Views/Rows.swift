import protocol SwiftUI.View
import struct SwiftUI.AnyView
import struct SwiftUI.Environment
import struct SwiftUI.EnvironmentObject
import struct SwiftUI.ForEach
import struct SwiftUI.Picker
import struct SwiftUI.ViewBuilder

struct Rows: View {
    @EnvironmentObject
    private var context: Context.Data

    @Environment(\.rowSorting)
    private var rowSorting

    var body: some View {
        #if VERBOSE
        Self._printChanges()
        #endif
        return ForEach(rowSorting.sort(context.rows)) { property in
            if let custom = makeBody(configuration: property) {
                custom
            } else {
                Row(data: property)
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
