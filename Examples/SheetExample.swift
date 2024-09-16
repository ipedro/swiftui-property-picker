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
#Preview {
    NavigationView {
       SheetExample()
    }
}

@available(iOS 16.4, *)
struct SheetExample: View {
    // changes are local
    @PropertyPickerState(ContentKey.self)
    private var content

    // changes are written to the SwiftUI environment
    @PropertyPickerState(InteractionKey.self, keyPath: \.isEnabled)
    private var interaction

    // changes are written to the SwiftUI environment
    @PropertyPickerState(ColorSchemeKey.self, keyPath: \.colorScheme)
    private var colorScheme

    @State private var presented = true

    var body: some View {
        PropertyPicker(isPresented: $presented) {
            Button {
                presented.toggle()
            } label: {
                switch content {
                case .image:
                    Image(systemName: "circle")
                case .text:
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

    private enum ContentKey: String, PropertyPickerKey {
        case text, image
    }

    private enum InteractionKey: String, PropertyPickerKey {
        static var defaultValue: InteractionKey = .enabled

        case disabled, enabled

        var value: Bool {
            self == .enabled
        }
    }

    private enum ColorSchemeKey: String, PropertyPickerKey {
        case light, dark

        var value: ColorScheme {
            switch self {
            case .light: .light
            case .dark: .dark
            }
        }
    }
}


