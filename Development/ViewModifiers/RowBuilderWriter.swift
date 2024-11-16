import SwiftUI

@usableFromInline
struct RowBuilderWriter<Key, Row>: ViewModifier where Key: PropertyPickerKey, Row: View {
    var key: Key.Type

    @ViewBuilder
    var row: (Property) -> Row

    @usableFromInline
    init(key: Key.Type, row: @escaping (_ data: Property) -> Row) {
        self.key = key
        self.row = row
    }

    private var id: PropertyID {
        PropertyID(key)
    }

    private var rowBuilder: RowBuilder {
        .init(id: id, body: { data in
            AnyView(row(data))
        })
    }

    @usableFromInline
    func body(content: Content) -> some View {
        content.modifier(
            PreferenceWriter(
                type: ViewBuilderPreference.self,
                value: [id: rowBuilder],
                verbose: false
            )
        )
    }
}
