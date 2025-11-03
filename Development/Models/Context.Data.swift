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
                invalidateSortedRowsCache()
            }
        }

        @Published
        var rowBuilders: [PropertyID: RowBuilder] = [:] {
            didSet {
                #if VERBOSE
                    print("\(Self.self): Updated Builders \(rowBuilders.keys.map(\.debugDescription))")
                #endif
            }
        }

        // MARK: - Sorted Rows Cache

        private var sortedRowsCache: [Property]?
        private var cachedSortingKey: String?

        /// Returns sorted rows using memoization to avoid re-sorting on every render.
        /// Cache invalidates when rows change or sorting configuration changes.
        func sortedRows(using sorting: PropertyPickerRowSorting?) -> [Property] {
            let sortingKey = makeSortingKey(for: sorting)

            // Return cached result if rows and sorting haven't changed
            if let cached = sortedRowsCache, cachedSortingKey == sortingKey {
                return cached
            }

            // Rows or sorting changed - recompute
            let sorted = sorting.sort(rows)

            // Update cache
            sortedRowsCache = sorted
            cachedSortingKey = sortingKey

            return sorted
        }

        private func invalidateSortedRowsCache() {
            sortedRowsCache = nil
            cachedSortingKey = nil
        }

        private func makeSortingKey(for sorting: PropertyPickerRowSorting?) -> String {
            switch sorting {
            case .none:
                return "none"
            case .ascending:
                return "ascending"
            case .descending:
                return "descending"
            case .custom:
                // For custom comparators, we can't easily create a stable key
                // so we'll use object identity. This means cache won't work
                // across different custom comparator instances, but that's acceptable.
                return "custom_\(ObjectIdentifier(sorting as AnyObject).hashValue)"
            }
        }
    }
}
