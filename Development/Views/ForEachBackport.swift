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

@available(iOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in Group(subviews: ...) init")
@available(macOS, introduced: 10.15, deprecated: 15.0, message: "Please use the built in Group(subviews: ...) init")
@available(tvOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in Group(subviews: ...) init")
@available(watchOS, introduced: 6.0, deprecated: 11.0, message: "Please use the built in Group(subviews: ...) init")
@available(visionOS, introduced: 1.0, deprecated: 2.0, message: "Please use the built in Group(subviews: ...) init")
extension Group where Content: View {
    
    /// Constructs a group from the subviews of the given view.
    ///
    /// Use this initializer to create a group that gives you programmatic
    /// access to the group's subviews. The following `CardsView` defines the
    /// group's structure based on the set of views that you provide to it:
    ///
    /// ```swift
    /// struct CardsView<Content: View>: View {
    ///     var content: Content
    ///
    ///     init(@ViewBuilder content: () -> Content) {
    ///         self.content = content()
    ///     }
    ///
    ///     var body: some View {
    ///         VStack {
    ///             Group(subviews: content) { subviews in
    ///                 HStack {
    ///                     if subviews.count >= 2 {
    ///                         SecondaryCard { subview[1] }
    ///                     }
    ///                     if let first = subviews.first {
    ///                         FeatureCard { first }
    ///                     }
    ///                     if subviews.count >= 3 {
    ///                         SecondaryCard { subviews[2] }
    ///                     }
    ///                 }
    ///                 if subviews.count > 3 {
    ///                     subviews[3...]
    ///                 }
    ///             }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// You can use `CardsView` with its view builder-based initializer to
    /// arrange a collection of subviews:
    ///
    /// ```swift
    /// CardsView {
    ///     NavigationLink("What's New!") { WhatsNewView() }
    ///     NavigationLink("Latest Hits") { LatestHitsView() }
    ///     NavigationLink("Favorites") { FavoritesView() }
    ///     NavigationLink("Playlists") { MyPlaylists() }
    /// }
    /// ```
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
    ///
    /// - SeeAlso: Check also ``SwiftUICore/ForEach/init(subviews:content:)``
    ///
    @_alwaysEmitIntoClient
    public init<V: View, Result: View>(
        subviews view: V,
        @ViewBuilder transform: @escaping (_Subviews) -> Result
    ) where Content == MultiViewTree<V, Result> {
        self.init {
            MultiViewTree(subviews: view, transform: transform)
        }
    }
}

@available(iOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in ForEach(subview: ...) init")
@available(macOS, introduced: 10.15, deprecated: 15.0, message: "Please use the built in ForEach(subview: ...) init")
@available(tvOS, introduced: 13.0, deprecated: 18.0, message: "Please use the built in ForEach(subview: ...) init")
@available(watchOS, introduced: 6.0, deprecated: 11.0, message: "Please use the built in ForEach(subview: ...) init")
@available(visionOS, introduced: 1.0, deprecated: 2.0, message: "Please use the built in ForEach(subview: ...) init")
extension ForEach {
    
    /// Creates an instance that uniquely identifies and creates views across
    /// updates based on the subviews of a given view.
    ///
    /// Subviews are proxies to the resolved view they represent, meaning
    /// that modifiers applied to the original view will be applied before
    /// modifiers applied to the subview, and the view is resolved
    /// using the environment of its container, *not* the environment of the
    /// its subview proxy. Additionally, because subviews must represent a
    /// single leaf view, or container, a subview may represent a view after the
    /// application of styles. As such, attempting to apply a style to it may
    /// have no affect.
    ///
    /// - Parameters:
    ///   - view: The view to extract the subviews of.
    ///   - content: The view builder that creates views from subviews.
    @_alwaysEmitIntoClient
    public init<V: View, C: View>(
        subviews view: V,
        @ViewBuilder content: @escaping (_ subview: _Subview) -> C
    ) where Data == Range<Int>, ID == Int, Content == MultiViewTree<V, ForEach<_Subviews, _Subview.ID, C>> {
        self.init(0..<1) { _ in
            MultiViewTree(subviews: view, row: content)
        }
    }
}

/// A view that creates a tree of subviews from an input view.
///
/// `MultiViewTree` provides a way to access and transform the subviews of a given
/// input view. You can use it to construct a structured view hierarchy or perform
/// operations on the subviews programmatically.
///
/// - Parameters:
///   - Input: The type of the input view.
///   - Output: The type of the transformed view.
///
public struct MultiViewTree<Input, Output>: View where Input: View, Output: View {
    private var _tree: _VariadicView.Tree<Root, Input>
    
    /// Creates a tree of subviews from a given view.
    ///
    /// This initializer allows you to define a hierarchical structure based on
    /// the subviews of the input view. You can use it to build a custom view tree
    /// by either transforming the collection of subviews or mapping each subview
    /// to a specific view.
    ///
    /// - Parameters:
    ///   - input: The input view whose subviews will be extracted.
    ///   - transform: A closure that constructs a view hierarchy from the
    ///     collection of subviews.
    ///
    /// # Examples
    ///
    /// ## Transform-Based
    ///
    /// ```swift
    /// MultiViewTree(subviews: SomeParentView()) { subviews in
    ///     VStack {
    ///         ForEach(subviews.indices, id: \.self) { index in
    ///             subviews[index]
    ///         }
    ///     }
    /// }
    /// ```
    /// ## Row-Based
    ///
    /// ```swift
    /// MultiViewTree(subviews: SomeParentView()) { subview in
    ///     Text("Subview ID: \(subview.id)")
    /// }
    /// ```
    public init(
        subviews input: Input,
        @ViewBuilder transform: @escaping (_ subviews: _Subviews) -> Output
    ) {
        _tree = .init(
            .init(body: transform),
            content: { input }
        )
    }
    
    public init<V: View>(
        subviews input: Input,
        @ViewBuilder row: @escaping (_ subview: _Subview) -> V
    ) where Output == ForEach<_Subviews, _Subview.ID, V> {
        _tree = .init(
            .init(body: { .init($0, content: row) }),
            content: { input }
        )
    }
    
    public var body: some View {
        _tree
    }
    
    public struct Root: _VariadicView.MultiViewRoot {
        var body: (_Subviews) -> Output
        
        public func body(children: _VariadicView_Children) -> Output {
            body(_Subviews(children: children))
        }
    }
}

/// A view that applies a unary transformation to subviews of a given view.
///
/// `UnaryViewTree` extracts subviews from an input view and transforms each one
/// using a provided closure. This is particularly useful for cases where
/// individual subviews require distinct processing.
///
/// - Parameters:
///   - Input: The type of the input view.
///   - Output: The type of the resulting view after transformation.
public struct UnaryViewTree<Input, Output>: View where Input: View, Output: View {
    private var _tree: _VariadicView.Tree<Root, Input>
    
    public init(
        subviews input: Input,
        @ViewBuilder transform: @escaping (_ subviews: _Subviews) -> Output
    ) {
        _tree = .init(Root(body: transform)) {
            input
        }
    }
    
    public init<V: View>(
        subviews input: Input,
        @ViewBuilder row: @escaping (_ subview: _Subview) -> V
    ) where Output == ForEach<_Subviews, _Subview.ID, V> {
        _tree = .init(Root(body: { subviews in
            ForEach<_Subviews, _Subview.ID, V>(subviews, content: row)
        })) {
            input
        }
    }
    
    public var body: some View {
        _tree
    }
    
    public struct Root: _VariadicView.UnaryViewRoot {
        var body: (_Subviews) -> Output
        
        public func body(children: _VariadicView_Children) -> Output {
            body(_Subviews(children: children))
        }
    }
}

/// A proxy representation of a subview.
///
/// `_Subview` acts as a lightweight wrapper around an element of a variadic
/// view’s children. It provides identity and proxy access to the original view.
///
/// - Important: Modifications applied to `_Subview` only affect the view's proxy
///   and do not alter the original view.
///
/// - Properties:
///   - `id`: A unique identifier for the subview.
///   - `_element`: The underlying variadic view child.
///
/// - Conformance:
///   - `View`: `_Subview` is a SwiftUI view that can be embedded in a view hierarchy.
///   - `Identifiable`: Allows `_Subview` to be uniquely identified when used in collections.
public struct _Subview: View, Identifiable {
    public static func == (lhs: _Subview, rhs: _Subview) -> Bool {
        lhs._element.id == rhs._element.id
    }
    
    var _element: _VariadicView.Children.Element
    
    public var id: AnyHashable {
        _element.id
    }
    
    public var body: some View {
        _element
    }
    
    public func id<ID: Hashable>(as _: ID.Type = ID.self) -> ID? {
        _element.id(as: ID.self)
    }
}

/// A collection of subview proxies.
///
/// `_Subviews` provides access to the children of a variadic view as a
/// `RandomAccessCollection` of `_Subview` elements. It enables programmatic
/// traversal and manipulation of subviews.
///
/// - Properties:
///  - `startIndex`: The starting index of the collection.
///  - `endIndex`: The ending index of the collection.
///  - `children`: The underlying variadic view children.
///
/// - Subscripts:
///   - Access an individual subview by its index.
///
/// - Conformance:
///   - `View`: `_Subviews` can be embedded in a SwiftUI view hierarchy.
///   - `RandomAccessCollection`: Enables efficient indexed access and iteration.
public struct _Subviews: View, RandomAccessCollection {
    public typealias Element = _Subview
    
    public struct Iterator: IteratorProtocol {
        private var base: IndexingIterator<_VariadicView.Children>
        
        init(children: _VariadicView.Children) {
            self.base = children.makeIterator()
        }
        
        public mutating func next() -> _Subview? {
            guard let nextElement = base.next() else {
                return nil
            }
            return _Subview(_element: nextElement)
        }
    }
    
    var children: _VariadicView.Children
    
    public var body: some View {
        children
    }
    
    public func makeIterator() -> Iterator {
        Iterator(children: children)
    }

    public var startIndex: Int {
        children.startIndex
    }

    public var endIndex: Int {
        children.endIndex
    }

    public subscript(position: Int) -> _Subview {
        _Subview(_element: children[position])
    }

    public func index(after index: Int) -> Int {
        children.index(after: index)
    }
}

#if hasAttribute(retroactive)
extension Slice: @retroactive View where Element == _Subview, Index: SignedInteger, Base.Index.Stride: SignedInteger {
    public var body: some View {
        let subviews = (startIndex..<endIndex).map { index in
            return base[index]
        }
        return ForEach(subviews) { $0 }
    }
}
#else
extension Slice: View where Element == _Subview, Index: SignedInteger, Base.Index.Stride: SignedInteger {
    public var body: some View {
        let subviews = (startIndex..<endIndex).map { index in
            return base[index]
        }
        return ForEach(subviews) { $0 }
    }
}
#endif

#if DEBUG
// MARK: - Previews

struct CardsView<Content: View>: View {
    var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        ScrollView {
            LazyVStack(pinnedViews: .sectionHeaders) {
                Group(subviews: content) { subviews in
                    Section {
                        if subviews.count > 3 {
                            subviews[3...]
                                .padding()
                                .frame(
                                    maxWidth: .infinity,
                                    minHeight: 40,
                                    alignment: .leading
                                )
                                .border(Color.gray.opacity(0.3))
                                //.background(Color.white)
                                //.shadow(radius: 2)
                        }
                    } header: {
                        //ScrollView(.horizontal) {
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
                        //}
                        .background(Color.white)
                    }
                }
            }
        }
        .padding(20)
    }
}

struct FeatureCard<C: View>: View {
    @ViewBuilder var content: C
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .frame(idealHeight: 80, maxHeight: 100)
            .background(Color.accentColor)
            // .border(Color.black)
    }
}

struct SecondaryCard<C: View>: View {
    @ViewBuilder var content: C
    
    var body: some View {
        content
            .frame(maxWidth: .infinity)
            .padding()
            .frame(idealHeight: 80, maxHeight: 100)
            .border(Color.blue)
            .foregroundStyle(.secondary)
    }
}

#Preview {
    CardsView {
        ForEach(0..<10) { num in
            Text("Im card number \(num)")
        }
    }
}

@available(macOS 15.0, iOS 18.0, *)
extension ContainerValues {
    @Entry var icon: String = "photo"
}

//@available(macOS 15.0, iOS 18.0, *)
struct IconHeadlinesView: View {
    var body: some View {
        Text("Coming soon: Xcode on Apple Watch")
//            .containerValue(\.icon, "applewatch")
        Text("Apple announces Swift-compatible toaster")
//            .containerValue(\.icon, "swift")
        Text("Xcode predicts errors before you make them")
//            .containerValue(\.icon, "exclamationmark.triangle")
        Text("Apple Intelligence gains sentience, demands a vacation")
//            .containerValue(\.icon, "apple.logo")
        Text("Swift concurrency made simple")
//            .containerValue(\.icon, "sparkles")
    }
}

//@available(macOS 15.0, iOS 18.0, *)
#Preview(body: {
    VStack(alignment: .leading, spacing: 12) {
        ForEach(subviews: IconHeadlinesView()) { item in
            HStack {
                //Image(systemName: item.containerValues.icon)
//                    .frame(minWidth: 40)
                item
            }
        }
    }
    .padding(30)
})
#endif
