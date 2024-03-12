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

// MARK: - View Modifier

/// A SwiftUI ViewModifier for dynamically selecting and applying environment values.
///
/// This ViewModifier leverages `ObservableObject` for state management, enabling dynamic
/// updates of SwiftUI views based on user-selected values. It is designed to facilitate
/// customization and enhance interactivity within the SwiftUI environment.
///
/// Usage:
///
/// ```swift
/// struct ContentView: View {
///     var body: some View {
///         Text("Hello, Dynamic World!")
///             .propertyPicker(MyDynamicKey.self)
///     }
/// }
/// ```
///
/// - Requires: `Key` conforming to `PropertyPickerEnvironmentKey` protocol.
struct PropertyPickerEnvironmentWriter<Key>: ViewModifier where Key: PropertyPickerEnvironmentKey {
    let key: Key.Type

    func body(content: Content) -> some View {
        PropertyPickerReader(key) { value in
            content.environment(key.keyPath, value)
        }
    }
}

struct PropertyPickerReader<Key, Content>: View where Key: PropertyPickerKey, Content: View {
    /// Internal ObservableObject for managing the dynamic selection state.
    private class Store: ObservableObject {
        @Published 
        var selection = Key.defaultCase
    }

    /// The current selection state of the dynamic value.
    @StateObject 
    private var store = Store()

    @ViewBuilder 
    private var content: (Key.Value) -> Content

    private var selectedValue: PropertyPickerContent {
        .init(selection: $store.selection)
    }

    init(
        _ key: Key.Type = Key.self,
        @ViewBuilder content: @escaping (Key.Value) -> Content
    ) {
        self.content = content
    }

    var body: some View {
        content(store.selection.value).background(background)
    }

    private var background: some View {
        Color.clear.preference(
            key: PropertyPickerPreferenceKey.self,
            value: [selectedValue]
        )
    }
}

public extension View {
    /// Applies a dynamic value selector to the view based on the specified key.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - action: A closure to run when the selected value changes.
    ///   
    /// - Returns: A view modified to dynamically select and apply an environment value.
    func propertyPicker<Key: PropertyPickerKey>(
        _ key: Key.Type,
        onUpdate action: @escaping (_ value: Key.Value) -> Void
    ) -> some View where Key.Value: Equatable {
        PropertyPickerReader(key) { value in
            onChange(of: value, perform: action)
        }
    }

    /// Applies a dynamic value selector to the view based on the specified key.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - state: A property that can read and write a value owned by a source of truth.
    ///
    /// - Returns: A view modified to dynamically select a value and update a source of truth.
    func propertyPicker<Key: PropertyPickerKey>(
        _ key: Key.Type,
        _ state: Binding<Key.Value>
    ) -> some View where Key.Value: Equatable {
        PropertyPickerReader(key) { initialValue in
            onChange(of: initialValue) { newValue in
                state.wrappedValue = newValue
            }
        }
    }

    /// Applies a dynamic value selector to the view based on the specified key.
    ///
    /// - Parameter key: The type of the property picker environment key.
    ///
    /// - Returns: A view modified to dynamically select and apply an environment value.
    func propertyPicker<Key: PropertyPickerEnvironmentKey>(
        _ key: Key.Type
    ) -> some View {
        modifier(PropertyPickerEnvironmentWriter(key: key))
    }
}

public extension View {
    /// Applies a dynamic value selector to the view.
    /// - Parameter key: The type of the property picker key.
    /// - Returns: A view modified to select and apply a dynamic environment value based on the given key.
    func propertyPickerStyle<S: PropertyPickerStyle>(_ style: S) -> some View {
        environment(\.propertyPickerStyle, style)
    }
}

// MARK: - Key Protocol

/// Defines the requirements for keys used with dynamic environment values in SwiftUI.
///
/// Conforming types can dynamically select and apply values to the SwiftUI environment,
/// enabling customizable and responsive UI components.
public protocol PropertyPickerEnvironmentKey<Value>: PropertyPickerKey {
    /// The key path to the associated value in the environment.
    static var keyPath: WritableKeyPath<EnvironmentValues, Value> { get }
}

public protocol PropertyPickerKey<Value>: CaseIterable, RawRepresentable, Hashable where AllCases == [Self], RawValue == String {
    /// The associated value type for the dynamic key.
    associatedtype Value
    /// The default selection case for the key.
    static var defaultCase: Self { get }
    /// A user-friendly description for the key, improving UI readability.
    static var defaultDescription: String { get }
    /// The current value associated with the key.
    var value: Value { get }
}

/// Provides default implementations for the `PropertyPickerKey` protocol,
/// ensuring a minimal configuration is required for conforming types.
public extension PropertyPickerKey {
    /// Returns the first case as the default selection if available, otherwise triggers a runtime error.
    static var defaultCase: Self {
        guard let first = allCases.first else {
            fatalError("\(Self.self) requires at least one case.")
        }
        return first
    }

    /// Generates a user-friendly description by adding spaces before capital letters in the type name.
    static var defaultDescription: String {
        String(describing: Self.self).addingSpacesToCamelCase()
    }
}

/// A preference key for storing dynamic value entries.
///
/// This key aggregates values to be displayed in a custom selection menu, allowing
/// for dynamic updates and customization of menu content based on user selection.
struct PropertyPickerPreferenceKey: PreferenceKey {
    /// The default value for the dynamic value entries.
    static var defaultValue: [PropertyPickerContent] = []

    /// Combines the current value with the next value.
    ///
    /// - Parameters:
    ///   - value: The current value of dynamic value entries.
    ///   - nextValue: A closure that returns the next set of dynamic value entries.
    static func reduce(value: inout [PropertyPickerContent], nextValue: () -> [PropertyPickerContent]) {
        value.append(contentsOf: nextValue())
    }
}

// MARK: - Sheet Style

public extension PropertyPickerStyle where Self == SheetPropertyPicker {
    static func sheet(isPresented: Binding<Bool>) -> Self {
        .init(isPresenting: isPresented)
    }
}

/// Defines static presentation detents for menu sizes.
@available(iOS 16.4, macOS 13.0, *)
extension PresentationDetent {
    enum PropertyPicker {
        /// A detent representing an expanded menu.
        static let expanded = PresentationDetent.fraction(2/3)
        /// A detent representing the default menu size.
        static let `default` = PresentationDetent.fraction(1/2)
        /// A detent representing a compact menu.
        static let compact = PresentationDetent.fraction(1/3)
    }
}

/// A view modifier that adds a custom expandable menu to a SwiftUI view.
/// This modifier tracks and displays menu items dynamically added to the view,
/// providing a customizable and interactive menu experience.
public struct SheetPropertyPicker: PropertyPickerStyle {
    /// Indicates whether the menu is expanded.
    @Binding var presenting: Bool

    public init(isPresenting: Binding<Bool>) {
        _presenting = isPresenting
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .safeAreaInset(edge: .bottom) {
                Spacer().frame(height: presenting ? UIScreen.main.bounds.midY : 0)
            }
            .toolbar(content: {
                ToolbarItem {
                    if !configuration.isEmpty {
                        Button {
                            withAnimation(.interactiveSpring) {
                                presenting.toggle()
                            }
                        } label: {
                            Image(systemName: presenting ? "xmark.circle" : "gear")
                                .rotationEffect(.degrees(presenting ? 180 : 0))
                        }
                    }
                }
            })
            .animation(.snappy, value: presenting)
            .overlay(
                Spacer().sheet(isPresented: $presenting) {
                    makePickerList(configuration: configuration)
                }
            )
    }

    private func makePickerList(configuration: Configuration) -> some View {
        List {
            configuration.pickers
        }
        .padding([.top, .horizontal])
        .listStyle(.plain)
        .blendMode(.multiply)
        .menuPresentationDetents()
        .hideScrollContentBackground()
    }
}

// MARK: - Inline Style

/// Provides a convenient static property for accessing the inline selector style.
public extension PropertyPickerStyle where Self == InlinePropertyPicker {
    /// A style that presents dynamic value options inline within the view hierarchy.
    static var inline: Self { .init() }
}

/// A style that presents dynamic value options inline within the view hierarchy.
public struct InlinePropertyPicker: PropertyPickerStyle {
    /// Creates the view for the inline style, embedding the dynamic value options directly within a scrollable area.
    ///
    /// - Parameter configuration: The configuration containing the dynamic value options and content.
    /// - Returns: A view displaying the dynamic value options inline.
    public func makeBody(configuration: Configuration) -> some View {
        VStack(spacing: .zero) {
            configuration.content
            Divider().padding(.horizontal)
            configuration.pickers.padding(.top, 8)
        }
    }
}

/// A private extension to View to customize the scroll bounce behavior based on the iOS version.
private extension View {
    /// Applies scroll bounce behavior based on the size for iOS 16.4 and later; otherwise, does nothing.
    @ViewBuilder func scrollBounceBehaviorBasedOnSize() -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            scrollBounceBehavior(.basedOnSize)
        } else {
            self
        }
    }
}

// MARK: - Context Menu Style

/// Provides a convenient static property for accessing the context menu selector style.
public extension PropertyPickerStyle where Self == ContextMenuPropertyPicker {
    /// A static property to access a context menu selector style instance.
    static var contextMenu: Self { .init() }
}

/// A style that presents dynamic value options within a context menu.
public struct ContextMenuPropertyPicker: PropertyPickerStyle {
    /// Creates the view for the context menu style, presenting the dynamic value options within a context menu.
    ///
    /// - Parameter configuration: The configuration containing the dynamic value options and content.
    /// - Returns: A view displaying the dynamic value options in a context menu.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.content.contextMenu {
            configuration.pickers
        }
    }
}

// MARK: - PropertyPickerStyle

/// A protocol for defining custom styles for presenting dynamic value selectors.
public protocol PropertyPickerStyle {
    /// The associated type representing the body of the selector style.
    associatedtype Body: View

    /// A typealias for the configuration used by the selector style.
    typealias Configuration = PropertyPickerStyleConfiguration

    /// Creates the body of the selector style using the provided configuration.
    ///
    /// - Parameter configuration: The configuration for the selector style.
    /// - Returns: A view representing the body of the selector style.
    @ViewBuilder func makeBody(configuration: Configuration) -> Body
}

// MARK: - Configuration for Picker Styles

/// Represents the configuration for dynamic value selector styles, encapsulating the content and dynamic value entries.
public struct PropertyPickerStyleConfiguration {
    /// The content to be presented alongside the dynamic value entries.
    public typealias Content = AnyView
    /// The actual content view.
    public let content: Content
    /// A boolean indicating if there are no dynamic value entries.
    public let isEmpty: Bool
    /// The dynamic value entries to be presented.
    public let pickers: PickerEntries

    /// Represents the dynamic value entries within the selector.
    public struct PickerEntries: View {
        /// The data for each dynamic value entry.
        let data: [PropertyPickerContent]

        /// Creates the view for each dynamic value entry, typically as a picker.
        public var body: some View {
            ForEach(data, content: picker(_:))
        }

        private func picker(_ content: PropertyPickerContent) -> some View {
            Picker(content.title, selection: content.selection) {
                ForEach(content.options, id: \.self) { item in
                    Text(item).tag(item)
                }
            }
        }
    }
}

// MARK: - Environment Key for Picker Style

/// An environment key for storing the current dynamic value selector style.
private struct PropertyPickerStyleKey: EnvironmentKey {
    /// The default value for the selector style, using `PropertyPickerInlineStyle` as the default.
    static let defaultValue: any PropertyPickerStyle = InlinePropertyPicker()
}

/// Extends `EnvironmentValues` to include a property for accessing the dynamic value selector style.
extension EnvironmentValues {
    /// The current dynamic value selector style within the environment.
    var propertyPickerStyle: any PropertyPickerStyle {
        get { self[PropertyPickerStyleKey.self] }
        set { self[PropertyPickerStyleKey.self] = newValue }
    }
}

// MARK: - PropertyPicker View

/**

 A SwiftUI view for presenting dynamic value selectors using the specified style.

 # Dynamic SwiftUI Environment Values

 SwiftUI provides a powerful and flexible framework for building user interfaces. A key feature of SwiftUI is its ability to   dynamically adapt UI components based on environment values. This package enhances this capability by introducing a robust system for dynamically selecting environment values through custom view modifiers and selector styles.

 ## Overview

 This package offers a suite of tools to facilitate the customization and dynamic updating of UI components in SwiftUI based on selected environment values. It leverages SwiftUI's environment, `ObservableObject`, and `PreferenceKey` to create a responsive and customizable interface.

 ### Key Features

 - **Dynamic Value Selection**: Dynamically select environment values with an extendable protocol-based approach.
 - **Customizable Picker Styles**: Implement custom selector styles to provide unique UI elements for value selection.
 - **Advanced State Management**: Utilize `ObservableObject` for managing selections, enhancing reactivity and performance.

 ## Getting Started

 To start using this package, integrate it into your SwiftUI project and follow the steps below to implement dynamic value selection in your views.

 ### PropertyPickerContent Modifier

 The `PropertyPickerContent` view modifier applies dynamic environment values to SwiftUI views. This modifier uses a generic `Key` parameter conforming to the `PropertyPickerEnvironmentKey` protocol to identify the specific environment value to modify.

 #### Example Usage

 ```swift
 struct ContentView: View {
     var body: some View {
     Text("Hello, Dynamic World!")
         .propertyPicker(MyDynamicKey.self)
     }
 }
 ```

 ### Defining Dynamic Keys

 To define dynamic keys, conform to the `PropertyPickerEnvironmentKey` protocol. This protocol requires specifying a `keyPath`, `defaultCase`, and associated value type.

 ```swift
 enum MyDynamicKey: String, PropertyPickerEnvironmentKey {
     case optionOne, optionTwo

     static var keyPath: WritableKeyPath<EnvironmentValues, String> {
         \.myPropertyPicker
     }

     static var defaultCase: Self {
         .optionOne
     }

     var value: String {
         switch self {
         case .optionOne: return "Option One"
         case .optionTwo: return "Option Two"
         }
     }
 }
 ```

 ### Custom Picker Styles

 This package introduces a `PropertyPickerStyle` protocol to create customizable selector styles. Implement this protocol to define custom UI elements for selecting dynamic values.

 #### Example: Inline Style

 ```swift
 struct MyPickerStyle: PropertyPickerStyle {
     // Implementation details...
 }
 ```

 Apply your custom style using the `propertyPickerStyle` modifier:

 ```swift
 Text("Select Option")
 .propertyPickerStyle(MyPickerStyle())
 ```

 ### Extending Picker Styles

 Extend the `PropertyPickerStyle` protocol to create sophisticated selector UIs, such as context menus or custom popovers. This approach encourages modular design and reusability.

 */
public struct PropertyPicker<Content: View>: View {
    /// The content to be presented alongside the dynamic value selector.
    let content: Content
    /// The state holding the dynamic value entries.
    @State 
    private var data: [PropertyPickerContent] = []
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
    private var configuration: PropertyPickerStyle.Configuration {
        .init(
            content: .init(content),
            isEmpty: data.isEmpty,
            pickers: .init(data: data)
        )
    }

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        AnyView(style.makeBody(configuration: configuration))
            .onPreferenceChange(PropertyPickerPreferenceKey.self) { newValue in
                data = newValue
            }
    }
}

// MARK: - Content

/// Represents a dynamic value entry with a unique identifier, title, and selectable options.
struct PropertyPickerContent: Identifiable, Equatable {
    /// A unique identifier for the entry.
    let id = UUID()
    /// The title of the entry, used as a label in the UI.
    let title: String
    /// A binding to the currently selected option.
    let selection: Binding<String>
    /// The options available for selection.
    let options: [String]

    /// Initializes a new dynamic value entry with the specified parameters.
    ///
    /// - Parameters:
    ///   - key: The property picker key type.
    ///   - selection: A binding to the currently selected key.
    init<Key: PropertyPickerKey>(_ key: Key.Type = Key.self, selection: Binding<Key>) {
        self.options = Key.allCases.map(\.rawValue)
        self.title = Key.defaultDescription
        self.selection = Binding {
            selection.wrappedValue.rawValue
        } set: { rawValue in
            if let newValue = Key(rawValue: rawValue) {
                selection.wrappedValue = newValue
            }
        }
    }

    /// Determines if two entries are equal based on their identifiers.
    static func == (lhs: PropertyPickerContent, rhs: PropertyPickerContent) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Helper Extensions for View Presentation

/// Extension to `String` for improving readability of camelCase strings by adding spaces.
private extension String {
    /// Adds spaces before each uppercase letter in a camelCase string.
    ///
    /// Usage:
    ///
    /// ```swift
    /// let camelCaseString = "propertyPickerKey"
    /// let readableString = camelCaseString.addingSpacesToCamelCase()
    /// // readableString is "dynamic Value Key"
    /// ```
    ///
    /// - Returns: A new string with spaces added before each uppercase letter.
    func addingSpacesToCamelCase() -> String {
        self.replacingOccurrences(of: "(?<=[a-z])(?=[A-Z])", with: " $0", options: .regularExpression, range: self.range(of: self))
    }
}

/// A private extension to View for customizing the presentation detents of a menu.
private extension View {
    /// Applies presentation detents to the view for iOS 16.4 and later; otherwise, does nothing.
    @ViewBuilder func menuPresentationDetents() -> some View {
        if #available(iOS 16.4, macOS 13.3, *) {
            presentationDetents([
                .PropertyPicker.compact,
                .PropertyPicker.default,
                .PropertyPicker.expanded
            ])
            .presentationBackgroundInteraction(.enabled)
            .presentationContentInteraction(.scrolls)
            .presentationCornerRadius(20)
            .presentationBackground(.ultraThinMaterial)
        } else {
            self
        }
    }
}

/// A private extension to View for hiding the scroll content background.
private extension View {
    /// Hides the scroll content background for iOS 16.0 and later; otherwise, does nothing.
    @ViewBuilder func hideScrollContentBackground() -> some View {
        if #available(iOS 16.0, macOS 13.0, *) {
            self.edgesIgnoringSafeArea(.top)
                .listRowBackground(EmptyView())
                .scrollContentBackground(.hidden)
        } else {
            self
        }
    }
}

// MARK: - Preview

#if DEBUG
struct Example: PreviewProvider {

    static var previews: some View {
        PropertyPicker {
            NavigationView {
                VStack {
                    Button {
                        //
                    } label: {
                        Text("Button")
                    }
                    .buttonStyle(.bordered)
                }
            }
            .propertyPicker(UserInteractionOptions.self)
            .propertyPicker(ColorSchemeOptions.self)
        }
    }

    enum UserInteractionOptions: String, PropertyPickerEnvironmentKey {
        case Enabled, Disabled

        static let keyPath = \EnvironmentValues.isEnabled

        var value: Bool {
            switch self {
            case .Enabled: true
            case .Disabled: false
            }
        }
    }

    enum ColorSchemeOptions: String, PropertyPickerEnvironmentKey {
        case Light, Dark

        static let keyPath = \EnvironmentValues.colorScheme

        var value: ColorScheme {
            switch self {
            case .Light: .light
            case .Dark: .dark
            }
        }
    }
}
#endif
