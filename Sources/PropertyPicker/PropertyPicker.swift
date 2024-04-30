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
public struct PropertyPicker<Content: View, Style: PropertyPickerStyle>: View {
    /// The content to be presented alongside the dynamic value selector.
    var content: Content
    /// The presentation style
    var style: Style

    private var observer = ContextObserving()

    /// The state holding the dynamic value entries.
    @StateObject
    private var context = Context()

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        content
            .modifier(style)
            .modifier(observer)
            .environmentObject(context)
    }
}

#if DEBUG
// MARK: - Example

@available(iOS 16.4, *)
#Preview(body: {
    Example()
})

@available(iOS 16.4, *)
struct Example: View {
    @PropertyPickerState<ContentKey>
    private var content

    @State private var presented = false

    var body: some View {
        PropertyPicker(isPresented: $presented) {
            Button {
                presented.toggle()
            } label: {
                switch content {
                case .Image:
                    Image(systemName: "circle")
                case .Text:
                    Text("Button")
                }
            }
            .buttonStyle(.bordered)
            .propertyPicker(\.isEnabled, UserInteractionKey.self)
            .propertyPicker(\.colorScheme, ColorSchemeKey.self)
            .propertyPicker($content)
//            .propertyPickerTitle(nil)
//            .propertyPickerListContentBackground(Color.blue)
//            .propertyPickerListContentBackground(Color.red)
        }
    }

    enum ContentKey: String, PropertyPickerKey {
        static var defaultValue: Example.ContentKey = .Text
        case Text, Image
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
