import protocol SwiftUI.View
import struct SwiftUI.ForEach
import struct SwiftUI.Picker
import struct SwiftUI.Text

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
