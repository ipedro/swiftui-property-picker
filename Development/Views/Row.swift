import SwiftUI

struct Row: View {
    var data: Property

    var body: some View {
        #if VERBOSE
        Self._printChanges()
        #endif
        return Picker(data.title, selection: data.$selection) {
            ForEach(data.options) { option in
                Text(option.label)
            }
        }
    }
}

// FIXME: Find a cleaner solution for inline style.
struct InlineRow: View {
    var data: Property

    @Environment(\.selectionAnimation)
    private var animation

    @Environment(\.labelTransformation)
    private var labelTransformation

    var body: some View {
        #if VERBOSE
        Self._printChanges()
        #endif
        return HStack {
            Text(verbatim: data.title)
            Menu {
                Picker(data.title, selection: data.$selection) {
                    ForEach(data.options) { option in
                        Text(option.label)
                    }
                }
            } label: {
                HStack {
                    Text(verbatim: labelTransformation.apply(to: data.selection))
                    Image(systemName: "chevron.up.chevron.down")
                }
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.vertical, 8)
            }
        }
        .foregroundStyle(.foreground)
        .safeAreaInset(edge: .bottom, spacing: .zero, content: Divider.init)
    }
}
