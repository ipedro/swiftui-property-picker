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

import Foundation
import SwiftUI

#if DEBUG
// MARK: - Example

@available(iOS 16.4, *)
#Preview(body: {
    NavigationView(content: {
       Example()
    })
})

@available(iOS 16.4, *)
struct Example: View {
    @PropertyPickerState<ContentKey>
    private var content

    @State private var presented = false

    var body: some View {
        PropertyPicker/*(isPresented: $presented)*/ {
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
            //.propertyPickerTitle(nil)
            //.propertyPickerListContentBackground(Color.blue)
            //.propertyPickerListContentBackground(Color.red)
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
