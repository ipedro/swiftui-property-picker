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

public extension PropertyPicker where Style == InlinePropertyPicker {
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
        self.style = .inline
    }
}

public extension PropertyPicker {
    init<S: ListStyle>(
        listStyle: ListPropertyPicker<S>,
        @ViewBuilder content: () -> Content
    ) where Style == ListPropertyPicker<S> {
        self.content = content()
        self.style = listStyle
    }
}

@available(iOS 16.4, *)
public extension PropertyPicker where Style == SheetPropertyPicker {
    /// Initializes the dynamic value selector with the specified content and optional title.
    ///
    /// - Parameters:
    ///   - content: A closure returning the content to be presented.
    init(
        isPresented: Binding<Bool>,
        adjustsBottomInset: Bool = true,
        detent: PresentationDetent = .fraction(1/4),
        presentationDetents: Set<PresentationDetent> = [
            .fraction(1/4),
            .medium,
            .fraction(2/3),
            .large
        ],
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.style = SheetPropertyPicker(
            isPresented: isPresented,
            adjustsBottomInset: adjustsBottomInset,
            detent: detent,
            presentationDetents: presentationDetents
        )
    }
}
