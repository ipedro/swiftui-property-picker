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
import PropertyPicker

// MARK: - Sheet Example

@available(iOS 16.4, *)
#Preview(body: {
    NavigationView(content: {
       ExampleSheet()
    })
})

@available(iOS 16.4, *)
struct ExampleSheet: View {
    @PropertyPicker(ContentKey.self)
    private var content

    @PropertyPicker(\.isEnabled, InteractionKey.self)
    private var interaction

    @PropertyPicker(\.colorScheme, ColorSchemeKey.self)
    private var colorScheme

    @State private var presented = false

    var body: some View {
        PropertyPickerReader(isPresented: $presented) {
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
            .propertyPicker($interaction)
            .propertyPicker($colorScheme)
            .propertyPicker($content)
            .propertyPickerTitle("Example")
            .propertyPickerListContentBackground(.bar)
        }
    }
}

enum ContentKey: String, PropertyPickerKey {
    case Text, Image
}

enum InteractionKey: String, PropertyPickerKey {
    static var defaultSelection: InteractionKey = .Enabled
    case Disabled, Enabled

    var value: Bool {
        switch self {
        case .Disabled: false
        case .Enabled: true
        }
    }
}

enum ColorSchemeKey: String, PropertyPickerKey {
    case Light, Dark

    var value: ColorScheme {
        switch self {
        case .Light: .light
        case .Dark: .dark
        }
    }
}

