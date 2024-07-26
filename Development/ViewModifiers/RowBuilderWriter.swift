import SwiftUI

struct RowBuilderWriter<Key, Row>: ViewModifier where Key: PropertyPickerKey, Row: View {
    var key: Key.Type

    @ViewBuilder
    var row: (_ data: Property) -> Row

    private var id: PropertyID {
        PropertyID(key)
    }

    private var rowBuilder: RowBuilder {
        .init(id: id, body: { data in
            AnyView(row(data))
        })
    }

    func body(content: Content) -> some View {
        #if VERBOSE
            Self._printChanges()
        #endif
        return content.modifier(
            PreferenceWriter(
                type: ViewBuilderPreference.self,
                value: [id: rowBuilder],
                verbose: false
            )
        )
    }
}
