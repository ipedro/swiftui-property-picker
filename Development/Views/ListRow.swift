import SwiftUI

struct ListRow: View {
    var data: Property

    var body: some View {
        Picker(data.title, selection: data.$selection) {
            ForEach(data.options) { option in
                Text(option.label)
            }
        }
    }
}
