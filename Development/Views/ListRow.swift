import SwiftUI

struct ListRow: View {
    var data: Property

    var body: some View {
        #if VERBOSE
        let _ = Self._printChanges()
        #endif
        Picker(data.title, selection: data.$selection) {
            ForEach(data.options) { option in
                Text(option.label)
            }
        }
    }
}
