import SwiftUI

// MARK: - List Style

/// A `PropertyPickerStyle` for displaying property picker content within a styled list.
///
/// This style component wraps property picker content in a SwiftUI List, applying a specified list style
/// and optional row background. It integrates additional UI adjustments like content background styling,
/// animations based on user interactions, and custom headers to enhance the visual presentation.
///
/// - Parameters:
///   - S: A `ListStyle` type that defines the appearance of the list.
public struct _ListPropertyPicker<S: ListStyle>: PropertyPickerStyle {
    let listStyle: S

    @Environment(\.rowBackground)
    private var rowBackground

    @State
    private var backgroundPreference = ContentBackgroundStylePreference.defaultValue

    private var contentBackground: some ShapeStyle {
        backgroundPreference?.data ?? AnyShapeStyle(.background)
    }

    public func body(content: Content) -> some View {
        List {
            Section {
                content.rows.listRowBackground(rowBackground)
            } header: {
                VStack(spacing: .zero) {
                    ZStack {
                        GroupBox {
                            Spacer().frame(maxWidth: .infinity)
                        }
                        .ios16_backgroundStyle(contentBackground)
                        .animation(backgroundPreference?.animation, value: backgroundPreference)

                        content
                            .padding()
                            .onPreferenceChange(ContentBackgroundStylePreference.self) {
                                backgroundPreference = $0
                            }
                    }
                    .environment(\.textCase, nil)
                    .padding(.vertical)

                    content.title
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .listStyle(listStyle)
    }
}

private extension View {
    @ViewBuilder
    func ios16_backgroundStyle<S: ShapeStyle>(_ background: S) -> some View {
        if #available(iOS 16.0, *) {
            backgroundStyle(background)
        } else {
            // Fallback on earlier versions
            self
        }
    }
}
