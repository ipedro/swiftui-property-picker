import SwiftUI
import PropertyPicker

/// A comprehensive design system showcase demonstrating PropertyPicker
/// in a real-world component library scenario.
@available(iOS 16.4, macOS 13.3, *)
struct DesignSystemShowcase: View {
    @PropertyPickerState(ComponentKey.self)
    private var selectedComponent
    
    @State private var isPickerPresented = false
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 32) {
                    // Component Preview
                    componentPreview
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: 200)
                    
                    // Component Description
                    componentDescription
                }
                .padding()
            }
            .navigationTitle("Design System")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        isPickerPresented.toggle()
                    } label: {
                        Label("Components", systemImage: "square.grid.2x2")
                    }
                }
            }
            .sheet(isPresented: $isPickerPresented) {
                PropertyPicker(isPresented: $isPickerPresented) {
                    componentPreview
                        .propertyPicker($selectedComponent)
                }
                .propertyPickerTitle("Component Gallery")
                .presentationDetents([.medium, .large])
            }
        }
    }
    
    @ViewBuilder
    private var componentPreview: some View {
        switch selectedComponent {
        case .button:
            ButtonShowcase()
        case .card:
            CardShowcase()
        case .badge:
            BadgeShowcase()
        case .typography:
            TypographyShowcase()
        }
    }
    
    private var componentDescription: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(selectedComponent.title)
                .font(.title2.bold())
            
            Text(selectedComponent.description)
                .font(.body)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

// MARK: - Component Showcases

@available(iOS 16.4, macOS 13.3, *)
private struct ButtonShowcase: View {
    @PropertyPickerState(ButtonSizeKey.self)
    private var buttonSize
    
    @PropertyPickerState(ButtonStateKey.self)
    private var buttonState
    
    var body: some View {
        VStack(spacing: 24) {
            Button(action: {}) {
                Label("Continue", systemImage: "arrow.right")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(buttonSize.size)
            .disabled(buttonState == .disabled)
        }
        .propertyPicker($buttonSize)
        .propertyPicker($buttonState)
        .padding()
    }
}

@available(iOS 16.4, macOS 13.3, *)
private struct CardShowcase: View {
    @PropertyPickerState(CornerRadiusKey.self)
    private var cornerRadius
    
    @PropertyPickerState(CardElevationKey.self)
    private var elevation
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                
                Text("Featured")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                
                Spacer()
            }
            
            Text("Design System Card")
                .font(.title3.weight(.semibold))
            
            Text("A beautiful card component with customizable styling options.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: cornerRadius.radius))
        .shadow(
            color: .black.opacity(elevation.opacity),
            radius: elevation.radius,
            y: elevation.y
        )
        .propertyPicker($cornerRadius)
        .propertyPicker($elevation)
        .padding()
    }
}

@available(iOS 16.4, macOS 13.3, *)
private struct BadgeShowcase: View {
    @PropertyPickerState(BadgeSizeKey.self)
    private var badgeSize
    
    var body: some View {
        HStack(spacing: 12) {
            badge(text: "New", color: .green)
            badge(text: "Beta", color: .orange)
            badge(text: "Pro", color: .blue)
        }
        .propertyPicker($badgeSize)
        .padding()
    }
    
    private func badge(text: String, color: Color) -> some View {
        Text(text)
            .font(badgeSize.font)
            .fontWeight(.semibold)
            .padding(.horizontal, badgeSize.horizontalPadding)
            .padding(.vertical, badgeSize.verticalPadding)
            .background(color.opacity(0.2))
            .foregroundStyle(color)
            .clipShape(Capsule())
    }
}

@available(iOS 16.4, macOS 13.3, *)
private struct TypographyShowcase: View {
    @PropertyPickerState(FontWeightKey.self)
    private var fontWeight
    
    @PropertyPickerState(TextSizeKey.self)
    private var textSize
    
    @PropertyPickerState(TextAlignmentKey.self)
    private var textAlignment
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Typography Scale")
                .font(textSize.font)
                .fontWeight(fontWeight.weight)
                .multilineTextAlignment(textAlignment.alignment)
            
            Text("The quick brown fox jumps over the lazy dog")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(textAlignment.alignment)
        }
        .propertyPicker($fontWeight)
        .propertyPicker($textSize)
        .propertyPicker($textAlignment)
        .padding()
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Property Keys

@available(iOS 16.4, macOS 13.3, *)
private enum ComponentKey: String, PropertyPickerKey {
    case button, card, badge, typography
    
    nonisolated(unsafe) static var defaultValue: Self { .button }
    
    var title: String {
        switch self {
        case .button: return "Button Component"
        case .card: return "Card Component"
        case .badge: return "Badge Component"
        case .typography: return "Typography"
        }
    }
    
    var description: String {
        switch self {
        case .button:
            return "Interactive buttons with multiple sizes and states. Demonstrates control sizing and disabled states."
        case .card:
            return "Content containers with customizable styling. Configure corner radius and elevation effects."
        case .badge:
            return "Small status indicators with semantic colors. Perfect for labels, tags, and notifications."
        case .typography:
            return "Text styling system with various sizes, weights, and alignment options. Demonstrates font hierarchy."
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum ButtonSizeKey: String, PropertyPickerKey {
    case mini, small, regular, large
    
    nonisolated(unsafe) static var defaultValue: Self { .regular }
    
    var size: ControlSize {
        switch self {
        case .mini: return .mini
        case .small: return .small
        case .regular: return .regular
        case .large: return .large
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum ButtonStateKey: String, PropertyPickerKey {
    case enabled, disabled
    
    nonisolated(unsafe) static var defaultValue: Self { .enabled }
}

@available(iOS 16.4, macOS 13.3, *)
private enum CornerRadiusKey: String, PropertyPickerKey {
    case none, small, medium, large, extraLarge
    
    nonisolated(unsafe) static var defaultValue: Self { .medium }
    
    var radius: CGFloat {
        switch self {
        case .none: return 0
        case .small: return 8
        case .medium: return 12
        case .large: return 16
        case .extraLarge: return 24
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum CardElevationKey: String, PropertyPickerKey {
    case none, small, medium, large
    
    nonisolated(unsafe) static var defaultValue: Self { .small }
    
    var opacity: Double {
        switch self {
        case .none: return 0
        case .small: return 0.1
        case .medium: return 0.15
        case .large: return 0.2
        }
    }
    
    var radius: CGFloat {
        switch self {
        case .none: return 0
        case .small: return 4
        case .medium: return 8
        case .large: return 16
        }
    }
    
    var y: CGFloat {
        switch self {
        case .none: return 0
        case .small: return 2
        case .medium: return 4
        case .large: return 8
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum BadgeSizeKey: String, PropertyPickerKey {
    case small, medium, large
    
    nonisolated(unsafe) static var defaultValue: Self { .medium }
    
    var font: Font {
        switch self {
        case .small: return .caption2
        case .medium: return .caption
        case .large: return .subheadline
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small: return 6
        case .medium: return 8
        case .large: return 12
        }
    }
    
    var verticalPadding: CGFloat {
        switch self {
        case .small: return 2
        case .medium: return 4
        case .large: return 6
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum FontWeightKey: String, PropertyPickerKey {
    case ultraLight, light, regular, medium, semibold, bold, heavy, black
    
    nonisolated(unsafe) static var defaultValue: Self { .regular }
    
    var weight: Font.Weight {
        switch self {
        case .ultraLight: return .ultraLight
        case .light: return .light
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        case .heavy: return .heavy
        case .black: return .black
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum TextSizeKey: String, PropertyPickerKey {
    case caption, body, title3, title2, title, largeTitle
    
    nonisolated(unsafe) static var defaultValue: Self { .title2 }
    
    var font: Font {
        switch self {
        case .caption: return .caption
        case .body: return .body
        case .title3: return .title3
        case .title2: return .title2
        case .title: return .title
        case .largeTitle: return .largeTitle
        }
    }
}

@available(iOS 16.4, macOS 13.3, *)
private enum TextAlignmentKey: String, PropertyPickerKey {
    case leading, center, trailing
    
    nonisolated(unsafe) static var defaultValue: Self { .center }
    
    var alignment: TextAlignment {
        switch self {
        case .leading: return .leading
        case .center: return .center
        case .trailing: return .trailing
        }
    }
}

// MARK: - Preview

@available(iOS 16.4, macOS 13.3, *)
#Preview("Design System Showcase") {
    DesignSystemShowcase()
}
