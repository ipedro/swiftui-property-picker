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

import Combine
import SwiftUI

extension Context {
    /// A data object that holds and manages UI related data for property pickers within a SwiftUI application.
    ///
    /// This class serves as a centralized store for various configurations and properties related to displaying
    /// property pickers. It uses `@Published` properties to ensure that views observing this context will
    /// update automatically in response to changes, supporting reactive UI updates.
    final class Data: ObservableObject {
        private var cancellables = Set<AnyCancellable>()

        // Properties
        private var _title: Text? = TitlePreference.defaultValue
        private var _rows: Set<PropertyData> = []
        private var _rowBuilders: [PropertyID: PropertyRowBuilder] = [:]

        // Public facing properties
        var title: Text? {
            get { _title }
            set {
                guard _title != newValue else { return }
                objectWillChange.send()
                //print(#function, "changed")
                _title = newValue
            }
        }

        var rows: Set<PropertyData> {
            get { _rows }
            set {
                guard _rows != newValue else { return }
                objectWillChange.send()
                //print(#function, "changed")
                _rows = newValue
            }
        }

        var rowBuilders: [PropertyID: PropertyRowBuilder] {
            get { _rowBuilders }
            set {
                guard _rowBuilders != newValue else { return }
                objectWillChange.send()
                //print(#function, "changed")
                _rowBuilders = newValue
            }
        }

        init() {
            setupDebouncing()
        }

        private func setupDebouncing() {
            let oneFrame = Int((1 / UIScreen.main.maximumFramesPerSecond) * 1000)

            // Title debouncing
            Just(_title)
                .removeDuplicates()
                .debounce(for: .milliseconds(oneFrame), scheduler: RunLoop.main)
                .sink { [weak self] in self?.title = $0 }
                .store(in: &cancellables)

            // Rows debouncing
            Just(_rows)
                .removeDuplicates()
                .debounce(for: .milliseconds(oneFrame), scheduler: RunLoop.main)
                .sink { [weak self] in self?.rows = $0 }
                .store(in: &cancellables)

            // RowBuilders debouncing
            Just(_rowBuilders)
                .removeDuplicates()
                .debounce(for: .milliseconds(oneFrame), scheduler: RunLoop.main)
                .sink { [weak self] in self?.rowBuilders = $0 }
                .store(in: &cancellables)
        }
    }
}
