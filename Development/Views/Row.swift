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
                ForEach(data.options) { option in
                    Button(option.label) {
                        withAnimation(animation) {
                            data.selection = option.rawValue
                        }
                    }
                }
            } label: {
                HStack {
                    Text(verbatim: labelTransformation.apply(to: data.selection))
                    Image(systemName: "chevron.up.chevron.down")
                }
                .opacity(0.5)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .transaction { transaction in
                transaction.animation = nil
            }
        }
        .foregroundStyle(.foreground)
        .padding(.vertical, 4)
        .safeAreaInset(edge: .bottom, content: Divider.init)
    }
}
