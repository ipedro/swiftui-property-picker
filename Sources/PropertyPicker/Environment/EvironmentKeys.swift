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

struct SafeAreaAdjustmentKey: EnvironmentKey {
    static var defaultValue: PropertyPickerSafeAreaAdjustmentStyle = .automatic
}

struct AnimationKey: EnvironmentKey {
    static var defaultValue: Animation? = .easeOut
}

@available(iOS 16.0, *)
struct PresentationDetentKey: EnvironmentKey {
    static var defaultValue: Binding<PresentationDetent>?
}

@available(iOS 16.0, *)
struct PresentationDetentsKey: EnvironmentKey {
    static var defaultValue: Set<PresentationDetent> = [
        .fraction(1/3),
        .fraction(2/3),
        .large
    ]
}
extension EnvironmentValues {
    var safeAreaAdjustment: PropertyPickerSafeAreaAdjustmentStyle {
        get { self[SafeAreaAdjustmentKey.self] }
        set { self[SafeAreaAdjustmentKey.self] = newValue }
    }

    var animation: Animation? {
        get { self[AnimationKey.self] }
        set { self[AnimationKey.self] = newValue }
    }

    @available(iOS 16.0, *)
    var presentationDetents: Set<PresentationDetent> {
        get { self[PresentationDetentsKey.self] }
        set { self[PresentationDetentsKey.self] = newValue }
    }

    @available(iOS 16.0, *)
    var selectedDetent: Binding<PresentationDetent>? {
        get { self[PresentationDetentKey.self] }
        set { self[PresentationDetentKey.self] = newValue }
    }
}
