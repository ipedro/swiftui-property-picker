import SwiftUI

struct SafeAreaAdjustmentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: PropertyPickerSafeAreaAdjustmentStyle = .automatic
}

struct SheetAnimationKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Animation? = .easeOut
}

struct SelectionAnimationKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Animation?
}

struct TitleTransformKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: PropertyPickerTextTransformation = [
        .camelCaseToWords,
        .snakeCaseToWords,
        .capitalize,
    ]
}

struct RowSortingKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: PropertyPickerRowSorting? = .ascending
}

struct RowBackgroundKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: AnyView?
}

@usableFromInline
struct LabelTransformKey: @preconcurrency EnvironmentKey {
    @usableFromInline
    @MainActor static var defaultValue: PropertyPickerTextTransformation = [
        .camelCaseToWords,
        .snakeCaseToWords,
        .capitalize,
    ]
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct PresentationDetentKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Binding<PresentationDetent>?
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
struct PresentationDetentsKey: @preconcurrency EnvironmentKey {
    @MainActor static var defaultValue: Set<PresentationDetent> = [
        .fraction(1 / 3),
        .fraction(2 / 3),
        .large,
    ]
}

extension EnvironmentValues {
    @usableFromInline
    var safeAreaAdjustment: PropertyPickerSafeAreaAdjustmentStyle {
        get { self[SafeAreaAdjustmentKey.self] }
        set { self[SafeAreaAdjustmentKey.self] = newValue }
    }

    var sheetAnimation: Animation? {
        get { self[SheetAnimationKey.self] }
        set { self[SheetAnimationKey.self] = newValue }
    }

    @usableFromInline
    var selectionAnimation: Animation? {
        get { self[SelectionAnimationKey.self] }
        set { self[SelectionAnimationKey.self] = newValue }
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @usableFromInline
    var presentationDetents: Set<PresentationDetent> {
        get { self[PresentationDetentsKey.self] }
        set { self[PresentationDetentsKey.self] = newValue }
    }

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    @usableFromInline
    var selectedDetent: Binding<PresentationDetent>? {
        get { self[PresentationDetentKey.self] }
        set { self[PresentationDetentKey.self] = newValue }
    }

    @usableFromInline
    var titleTransformation: PropertyPickerTextTransformation {
        get { self[TitleTransformKey.self] }
        set { self[TitleTransformKey.self] = newValue }
    }

    @usableFromInline
    var labelTransformation: PropertyPickerTextTransformation {
        get { self[LabelTransformKey.self] }
        set { self[LabelTransformKey.self] = newValue }
    }

    @usableFromInline
    var rowSorting: PropertyPickerRowSorting? {
        get { self[RowSortingKey.self] }
        set { self[RowSortingKey.self] = newValue }
    }

    @usableFromInline
    var rowBackground: AnyView? {
        get { self[RowBackgroundKey.self] }
        set { self[RowBackgroundKey.self] = newValue }
    }
}
