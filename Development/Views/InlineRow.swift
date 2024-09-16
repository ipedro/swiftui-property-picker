import SwiftUI

struct InlineRow: View {
    var data: Property

    @Environment(\.selectionAnimation)
    private var animation

    private var picker: some View {
        Picker(data.title, selection: data.$selection) {
            ForEach(data.options) { option in
                Text(option.label)
            }
        }
    }

    var body: some View {
        #if VERBOSE
        let _ = Self._printChanges()
        #endif
        Menu {
            picker
        } label: {
            HStack {
                Text(verbatim: data.title).layoutPriority(1)
                Group {
                    Text(verbatim: data.selection)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    Image(systemName: "chevron.up.chevron.down")
                }
                .opacity(0.5)
            }
            .padding(.vertical, 8)
        }
        .foregroundStyle(.foreground)
        .safeAreaInset(
            edge: .bottom,
            spacing: .zero,
            content: Divider.init
        )
    }
}
