import Foundation

public enum PropertyPickerRowSorting {
    case ascending
    case descending
    case custom(comparator: (_ lhs: Property, _ rhs: Property) -> Bool)

    func sort<D>(_ data: D) -> [Property] where D: Collection, D.Element == Property {
        switch self {
        case .ascending:
            data.sorted()
        case .descending:
            data.sorted().reversed()
        case let .custom(comparator):
            data.sorted { lhs, rhs in
                comparator(lhs, rhs)
            }
        }
    }
}

extension PropertyPickerRowSorting? {
    func sort<D>(_ data: D) -> [Property] where D: Collection, D.Element == Property {
        switch self {
        case .none:
            return Array(data)
        case let .some(wrapped):
            return wrapped.sort(data)
        }
    }
}
