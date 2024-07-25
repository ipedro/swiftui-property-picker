import SwiftUI

struct Title: View {
    @EnvironmentObject
    private var context: Context.Data

    var body: some View {
        context.title
    }
}
