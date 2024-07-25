import SwiftUI

extension Context {
    /// A data object that holds and manages UI related data for property pickers within a SwiftUI application.
    ///
    /// This class serves as a centralized store for various configurations and properties related to displaying
    /// property pickers. It uses `@Published` properties to ensure that views observing this context will
    /// update automatically in response to changes, supporting reactive UI updates.
    final class Data: ObservableObject {
        init() {}

        @Published
        var title: Text? = TitlePreference.defaultValue {
            didSet {
                #if VERBOSE
                print("\(Self.self): Updated Title \"\(String(describing: title))\"")
                #endif
            }
        }

        @Published
        var rows: Set<Property> = [] {
            didSet {
                #if VERBOSE
                print("\(Self.self): Updated Rows \(rows.map(\.title).sorted())")
                #endif
            }
        }

        @Published
        var rowBuilders: [PropertyID: RowBuilder] = [:] {
            didSet {
                #if VERBOSE
                print("\(Self.self): Updated Builders \(rowBuilders.keys.map(\.type))")
                #endif
            }
        }
    }
}
