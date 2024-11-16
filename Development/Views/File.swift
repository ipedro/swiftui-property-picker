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

extension Group where Content: View {
    
    /// Constructs a group from the subviews of the given view.
    ///
    /// Use this initializer to create a group that gives you programmatic
    /// access to the group's subviews. The following `CardsView` defines the
    /// group's structure based on the set of views that you provide to it:
    ///
    ///     struct CardsView<Content: View>: View {
    ///         var content: Content
    ///
    ///         init(@ViewBuilder content: () -> Content) {
    ///             self.content = content()
    ///         }
    ///
    ///         var body: some View {
    ///             VStack {
    ///                 Group(subviews: content) { subviews in
    ///                     HStack {
    ///                         if subviews.count >= 2 {
    ///                             SecondaryCard { subview[1] }
    ///                         }
    ///                         if let first = subviews.first {
    ///                             FeatureCard { first }
    ///                         }
    ///                         if subviews.count >= 3 {
    ///                             SecondaryCard { subviews[2] }
    ///                         }
    ///                     }
    ///                     if subviews.count > 3 {
    ///                         subviews[3...]
    ///                     }
    ///                 }
    ///             }
    ///         }
    ///     }
    ///
    /// You can use `CardsView` with its view builder-based initializer to
    /// arrange a collection of subviews:
    ///
    ///     CardsView {
    ///         NavigationLink("What's New!") { WhatsNewView() }
    ///         NavigationLink("Latest Hits") { LatestHitsView() }
    ///         NavigationLink("Favorites") { FavoritesView() }
    ///         NavigationLink("Playlists") { MyPlaylists() }
    ///     }
    ///
    /// Subviews collection constructs subviews on demand, so only access the
    /// part of the collection you need to create the resulting content.
    ///
    /// Subviews are proxies to the view they represent, which means
    /// that modifiers that you apply to the original view take effect before
    /// modifiers that you apply to the subview. SwiftUI resolves the view
    /// using the environment of its container rather than the environment of
    /// its subview proxy. Additionally, because subviews represent a
    /// single view or container, a subview might represent a view after the
    /// application of styles. As a result, applying a style to a subview might
    /// have no effect.
    ///
    /// - Parameters:
    ///   - view: The view to get the subviews of.
    ///   - transform: A closure that constructs a view from the collection of
    ///     subviews.
    @available(iOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in Group(subviewsOf: ...) init")
    @available(macOS, introduced: 10.15, deprecated: 15.0, message: "Please use the built in Group(subviewsOf: ...) init")
    @available(tvOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in Group(subviewsOf: ...) init")
    @available(watchOS, introduced: 6.0, deprecated: 11.0, message: "Please use the built in Group(subviewsOf: ...) init")
    @available(visionOS, introduced: 1.0, deprecated: 2.0, message: "Please use the built in Group(subviewsOf: ...) init")
    public init<V: View, Result: View>(
        subviews view: V,
        @ViewBuilder transform: @escaping (GroupOfSubviews.Subviews) -> Result
    ) where Content == GroupOfSubviews<V, Result> {
        self.init {
            GroupOfSubviews(subviews: view, transform: transform)
        }
    }
}

public struct GroupOfSubviews<Base, Result>: View where Base: View, Result: View {
    public typealias Subviews = _VariadicView.Children
    private var _tree: _VariadicView.Tree<Root, Base>
    
    public init(
        subviews base: Base,
        @ViewBuilder transform: @escaping (_ subviews: Subviews) -> Result
    ) {
        self._tree = .init(Root(transform: transform)) {
            base
        }
    }
    
    public var body: some View {
        _tree
    }
    
    struct Root: _VariadicView.MultiViewRoot {
        var transform: (_ subviews: Subviews) -> Result
        
        func body(children: Subviews) -> some View {
            transform(children)
        }
    }
}

#if hasAttribute(retroactive)
extension Slice: @retroactive View where Element == _VariadicView.Children.Element, Index: SignedInteger, Base.Index.Stride: SignedInteger {

    public var body: some View {
        let subviews = (startIndex..<endIndex).map { index in
            return base[index]
        }
        return ForEach(subviews) { $0 }
    }
}
#else
extension Slice: View where Element == _VariadicView.Children.Element, Index: SignedInteger, Base.Index.Stride: SignedInteger {

    public var body: some View {
        let subviews = (startIndex..<endIndex).map { index in
            return base[index]
        }
        return ForEach(subviews) { $0 }
    }
}
#endif

struct CardsView<Content: View>: View {
    var content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack {
            GroupOfSubviews(subviews: content) { subviews in
                HStack {
                    if subviews.count >= 2 {
                        SecondaryCard { subviews[1] }
                    }
                    if let first = subviews.first {
                        FeatureCard { first }
                    }
                    if subviews.count >= 3 {
                        SecondaryCard { subviews[2] }
                    }
                }
                if subviews.count > 3 {
                    subviews[3...]
                }
            }
        }
    }
}

struct FeatureCard<C: View>: View {
    @ViewBuilder var content: C
    
    var body: some View {
        content.border(Color.black)
    }
}

struct SecondaryCard<C: View>: View {
    @ViewBuilder var content: C
    
    var body: some View {
        content.border(Color.blue).foregroundStyle(.secondary)
    }
}

#Preview {
    CardsView {
        ForEach(0..<10) { num in
            Text("Im card number \(num)")
        }
    }
}
