//  Copyright (c) 2024 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import SwiftUI

/// A SwiftUI view that enables dynamic property selection.
///
/// This view acts as a container that integrates with the property picker system to allow users
/// to dynamically select properties and apply them to the enclosed content.
public struct PropertyPicker<Content: View>: View {
    /// The content to be presented alongside the dynamic value selector.
    let content: Content
    /// The state holding the dynamic value entries.

    @StateObject
    private var context = Context()

    /// The current dynamic value selector style from the environment.
    @Environment(\.propertyPickerStyle)
    private var style

    /// Initializes the dynamic value selector with the specified content and optional title.
    ///
    /// - Parameters:
    ///   - content: A closure returning the content to be presented.
    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    /// Creates the configuration for the selector style and presents the content accordingly.
    private var configuration: PropertyPickerStyleConfiguration {
        PropertyPickerStyleConfiguration(
            title: context.title,
            content: AnyView(content),
            isEmpty: context.isEmpty
        )
    }

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        AnyView(style.resolve(configuration: configuration))
            .modifier(ContextUpdatingModifier())
            .safeAreaInset(edge: .bottom) {
                Spacer().frame(height: context.bottomInset)
            }
            .animation(.snappy, value: context.bottomInset)
            .environmentObject(context)
    }
}

// MARK: - Preview

@available(iOS 16.0, *)
#Preview(body: {
    Example()
})

#if DEBUG
@available(iOS 16.0, *)
struct Example: View {
    @PropertyPickerState<Content>
    private var content

    var body: some View {
        PropertyPicker {
            Button {
                //
            } label: {
                switch content {
                case .image:
                    Image(systemName: "circle")
                case .text:
                    Text("Button")
                }
            }
            .buttonStyle(.bordered)
            .propertyPicker(UserInteractionKey.self, \.isEnabled)
            .propertyPicker(ColorSchemeKey.self, \.colorScheme)
            .propertyPicker($content)
//            .propertyPickerListContentBackground(Color.blue)
//            .propertyPickerListContentBackground(Color.red)
        }
        .propertyPickerStyle(.list)
    }

    enum Content: String, PropertyPickerKey {
        static var defaultValue: Example.Content = .text

        case text, image
    }

    enum UserInteractionKey: String, PropertyPickerKey {
        static var defaultValue: Example.UserInteractionKey = .Enabled

        case Enabled, Disabled

        var value: Bool {
            switch self {
            case .Enabled: true
            case .Disabled: false
            }
        }
    }

    enum ColorSchemeKey: String, PropertyPickerKey {
        static var defaultValue: Example.ColorSchemeKey = .Light

        case Light, Dark

        var value: ColorScheme {
            switch self {
            case .Light: .light
            case .Dark: .dark
            }
        }
    }
}
#endif
