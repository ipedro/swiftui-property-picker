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

// MARK: - Property Picker Package

import SwiftUI

// MARK: Public View Extensions

/// Extends `View` to support dynamic property selection and application using the Property Picker.
public extension View {

    /// Adds a dynamic property selection capability to the view using a `PropertyPickerState`.
    ///
    /// This allows the view to update its state based on user selection from a set of predefined options.
    ///
    /// - Parameters:
    ///   - pickerState: A `PropertyPickerState` instance representing the current selection state.
    ///
    /// - Returns: A view that updates its state based on the selected property value.
    func propertyPicker<Key: PropertyPickerKey>(
        _ pickerState: PropertyPickerState<Key>
    ) -> some View where Key.Value: Equatable {
        PropertyPickerContentView(pickerState.key) { initialValue in
            onChange(of: initialValue) { newValue in
                pickerState.state.wrappedValue = newValue
            }
        }
    }

    /// Adds a dynamic property selection capability to the view using a `PropertyPickerEnvironment`.
    ///
    /// This allows the view to update its state based on user selection from a set of predefined options.
    ///
    /// - Parameters:
    ///   - pickerEnvironment: A `PropertyPickerEnvironment` instance representing the current selection state.
    ///
    /// - Returns: A view that updates its state based on the selected property value.
    func propertyPicker<Key: PropertyPickerKey>(
        _ pickerEnvironment: PropertyPickerEnvironment<Key>
    ) -> some View where Key.Value: Equatable {
        PropertyPickerContentView(pickerEnvironment.key) { value in
            environment(pickerEnvironment.keyPath, value)
        }
    }

    /// Adds a dynamic property selector to the view for a specific state binding.
    ///
    /// This variant uses a `Binding` to directly modify a property on the view's state.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - state: A binding to the property's current value.
    ///
    /// - Returns: A modified view that reflects changes to the selected property.
    func propertyPicker<Key: PropertyPickerKey>(
        _ key: Key.Type,
        _ value: Binding<Key.Value>
    ) -> some View where Key.Value: Equatable {
        PropertyPickerContentView(key) { initialValue in
            onChange(of: initialValue) { newValue in
                value.wrappedValue = newValue
            }
        }
    }

    /// Adds a dynamic property selector that modifies an environment value.
    ///
    /// This variant allows modifying SwiftUI's environment values dynamically.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key.
    ///   - environmentKeyPath: The key path to the specific environment value to modify.
    ///
    /// - Returns: A view that modifies an environment value based on the selected property.
    func propertyPicker<Key: PropertyPickerKey>(
        _ key: Key.Type,
        _ environmentKeyPath: WritableKeyPath<EnvironmentValues, Key.Value>
    ) -> some View {
        PropertyPickerContentView(key) { value in
            environment(environmentKeyPath, value)
        }
    }

    /// Applies a custom style to the property picker presentation.
    ///
    /// - Parameter style: The property picker style to apply.
    ///
    /// - Returns: A view modified with the specified property picker style.
    func propertyPickerStyle<S: PropertyPickerStyle>(_ style: S) -> some View {
        environment(\.propertyPickerStyle, style)
    }
}

// MARK: PropertyPicker View

/// A SwiftUI view that enables dynamic property selection.
///
/// This view acts as a container that integrates with the property picker system to allow users
/// to dynamically select properties and apply them to the enclosed content.
public struct PropertyPicker<Content: View>: View {
    /// The content to be presented alongside the dynamic value selector.
    let content: Content
    /// The state holding the dynamic value entries.
    @State
    private var data: [PropertyPickerItem] = []

    @State
    private var bottomInset: Double = 0

    /// The current dynamic value selector style from the environment.
    @Environment(\.propertyPickerStyle)
    private var style

    let title: String?

    /// Initializes the dynamic value selector with the specified content and optional title.
    ///
    /// - Parameters:
    ///   - content: A closure returning the content to be presented.
    public init(
        _ title: String? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.title = title
        self.content = content()
    }

    /// Creates the configuration for the selector style and presents the content accordingly.
    private var configuration: PropertyPickerStyle.Configuration {
        .init(
            title: {
                if let title { return Text(title).bold() }
                return nil
            }(),
            content: .init(content),
            isEmpty: data.isEmpty,
            pickers: .init(data: data)
        )
    }

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        AnyView(style.makeBody(configuration: configuration))
            .safeAreaInset(edge: .bottom) {
                Spacer().frame(height: bottomInset)
            }
            .onPreferenceChange(PropertyPickerPreferenceKey.self) { newValue in
                data = newValue
            }
            .onPreferenceChange(PropertyPickerBottomInsetKey.self) { newValue in
                bottomInset = newValue
            }
            .animation(.snappy, value: bottomInset)
    }
}

// MARK: - Property Picker State

/// A property wrapper that holds the state of a property to be adjusted using the property picker.
/// It automatically updates the view when the selection changes.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey>: DynamicProperty {
    let key: Key.Type
    let state: State<Key.Value>

    /// Initializes the state with the specified key.
    ///
    /// - Parameter key: The type of the key that represents the property being adjusted.
    public init(_ key: Key.Type) {
        self.key = key
        self.state = State(initialValue: key.defaultCase.value)
    }

    /// The current value of the property being adjusted.
    public var wrappedValue: Key.Value {
        state.wrappedValue
    }

    /// The projected value, providing access to the binding of the state.
    public var projectedValue: Self {
        self
    }

}

// MARK: - Property Picker Environment

/// A property wrapper that allows a property picker to adjust values stored in the SwiftUI Environment.
@propertyWrapper
public struct PropertyPickerEnvironment<Key: PropertyPickerKey>: DynamicProperty {
    let key: Key.Type
    let keyPath: WritableKeyPath<EnvironmentValues, Key.Value>
    let environment: Environment<Key.Value>

    public init(_ keyPath: WritableKeyPath<EnvironmentValues, Key.Value>, _ key: Key.Type) {
        self.key = key
        self.keyPath = keyPath
        self.environment = Environment(keyPath)
    }

    /// The current value of the environment property being adjusted.
    public var wrappedValue: Key.Value {
        environment.wrappedValue
    }

    /// The projected value, providing access to the environment property.
    public var projectedValue: Self {
        self
    }

}

// MARK: - Content View

// MARK: - PropertyPickerContentView

/// `PropertyPickerContentView` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
struct PropertyPickerContentView<Key, Content>: View where Key: PropertyPickerKey, Content: View {

    /// Internal ObservableObject for managing the dynamic selection state.
    private class Store: ObservableObject {
        @Published var selection = Key.defaultCase
    }

    /// The current selection state of the dynamic value, observed for changes to update the view.
    @StateObject private var store = Store()

    /// A view builder closure that creates the content view based on the current selection.
    /// This allows the view to reactively update in response to changes in the selection.
    @ViewBuilder private var content: (Key.Value) -> Content

    /// The item representing the currently selected value, used for updating the UI and storing preferences.
    private var selectedValue: PropertyPickerItem {
        PropertyPickerItem(selection: $store.selection)
    }

    /// Initializes a `PropertyPickerContentView` with the specified key and content closure.
    ///
    /// - Parameters:
    ///   - key: The type of the property picker key. Defaults to the key type itself if not specified.
    ///   - content: A view builder closure that takes the current selection's value and returns the content view.
    init(
        _ key: Key.Type = Key.self,
        @ViewBuilder content: @escaping (Key.Value) -> Content
    ) {
        self.content = content
    }

    /// The body of the `PropertyPickerContentView`, rendering the content based on the current selection.
    /// It uses a clear background view to capture preference changes, allowing the dynamic property picker system to react.
    var body: some View {
        content(store.selection.value).background(background)
    }

    /// A helper view for capturing and forwarding preference changes without altering the main content's appearance.
    private var background: some View {
        Color.clear.preference(
            key: PropertyPickerPreferenceKey.self,
            value: [selectedValue]
        )
    }
}

// MARK: - PropertyPickerKey Protocol

/// Defines the requirements for a type to act as a key in the property picker system.
/// Each key represents a property that can be dynamically adjusted within a SwiftUI view.
public protocol PropertyPickerKey: RawRepresentable, CaseIterable, Hashable where AllCases.Element: RawRepresentable<String> {
    /// The associated value type that the key controls.
    associatedtype Value
    /// The default case to use when no other value is specified.
    static var defaultCase: AllCases.Element { get }
    /// A user-friendly description of the key. Used in UI elements like labels.
    static var defaultDescription: String { get }
    /// The current value associated with the key. This value is used to update the view's state.
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

// MARK: - Preference Keys

struct PropertyPickerBottomInsetKey: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {}
}

/// A preference key for storing dynamic value entries.
///
/// This key aggregates values to be displayed in a custom selection menu, allowing
/// for dynamic updates and customization of menu content based on user selection.
struct PropertyPickerPreferenceKey: PreferenceKey {
    /// The default value for the dynamic value entries.
    static var defaultValue: [PropertyPickerItem] = []

    /// Combines the current value with the next value.
    ///
    /// - Parameters:
    ///   - value: The current value of dynamic value entries.
    ///   - nextValue: A closure that returns the next set of dynamic value entries.
    static func reduce(value: inout [PropertyPickerItem], nextValue: () -> [PropertyPickerItem]) {
        value = nextValue() + value
    }
}

// MARK: - ## Styles ##

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

// MARK: - Environment Key for Picker Styles

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

// MARK: - Configuration for Picker Styles

/// Represents the configuration for dynamic value selector styles, encapsulating the content and dynamic value entries.
public struct PropertyPickerStyleConfiguration {
    /// The content to be presented alongside the dynamic value entries.
    public typealias Content = AnyView
    /// The optional text
    public let title: Text?
    /// The actual content view.
    public let content: Content
    /// A boolean indicating if there are no dynamic value entries.
    public let isEmpty: Bool
    /// The dynamic value entries to be presented.
    public let pickers: PickerEntries

    /// Represents the dynamic value entries within the selector.
    public struct PickerEntries: View {
        /// The data for each dynamic value entry.
        let data: [PropertyPickerItem]

        /// Creates the view for each dynamic value entry, typically as a picker.
        public var body: some View {
            ForEach(data, content: picker(_:))
        }

        private func picker(_ item: PropertyPickerItem) -> some View {
            Picker(item.title, selection: item.selection) {
                ForEach(item.options, id: \.self) { item in
                    Text(item).tag(item)
                }
            }
        }
    }
}

// MARK: - Sheet Style

@available(iOS 16.4, *)
public extension PropertyPickerStyle where Self == SheetPropertyPicker {
    static func sheet(
        isPresented: Binding<Bool>,
        adjustsBottomInset: Bool = true,
        detent: PresentationDetent = .fraction(1/3),
        presentationDetents: Set<PresentationDetent> = [
            .fraction(1/3),
            .fraction(2/3),
            .large
        ]
    ) -> Self {
        .init(
            isPresented: isPresented,
            adjustsBottomInset: adjustsBottomInset,
            detent: detent,
            presentationDetents: presentationDetents
        )
    }
}

/// A view modifier that adds a custom expandable menu to a SwiftUI view.
/// This modifier tracks and displays menu items dynamically added to the view,
/// providing a customizable and interactive menu experience.
@available(iOS 16.4, *)
public struct SheetPropertyPicker: PropertyPickerStyle {
    @Binding
    var isPresented: Bool

    let adjustsBottomInset: Bool

    @State
    var detent: PresentationDetent

    let presentationDetents: Set<PresentationDetent>

    private var bottomInset: Double {
        adjustsBottomInset && isPresented ? UIScreen.main.bounds.midY : 0
    }

    public func makeBody(configuration: Configuration) -> some View {
        configuration.content
            .safeAreaInset(edge: .bottom) {
                Spacer().frame(height: bottomInset)
            }
            .toolbar(content: {
                ToolbarItem {
                    if !configuration.isEmpty {
                        Button {
                            withAnimation(.interactiveSpring) {
                                isPresented.toggle()
                            }
                        } label: {
                            Image(systemName: isPresented ? "xmark.circle" : "gear")
                                .rotationEffect(.degrees(isPresented ? 180 : 0))
                        }
                    }
                }
            })
            .animation(.snappy, value: isPresented)
            .overlay(
                Spacer().sheet(isPresented: $isPresented) {
                    makePickerList(configuration: configuration)
                }
            )
    }

    private func makePickerList(configuration: Configuration) -> some View {
        List {
            Section {
                configuration.pickers.listRowBackground(Color.clear)
            } header: {
                configuration.title
                    .bold()
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0))
                    .font(.title2)
                    .foregroundStyle(.primary)
            }
        }
        .listStyle(.plain)
        .presentationDetents(presentationDetents, selection: $detent)
        .presentationBackgroundInteraction(.enabled)
        .presentationContentInteraction(.scrolls)
        .presentationCornerRadius(20)
        .presentationBackground(Material.thinMaterial)
        .edgesIgnoringSafeArea(.top)
        .listRowBackground(Color.clear)
        .scrollContentBackground(.hidden)
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

// MARK: - Content

/// Represents a dynamic value entry with a unique identifier, title, and selectable options.
struct PropertyPickerItem: Identifiable, Equatable {
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
    static func == (lhs: PropertyPickerItem, rhs: PropertyPickerItem) -> Bool {
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
            .propertyPicker(UserInteractionKey.self, \.isEnabled)
            .propertyPicker(ColorSchemeKey.self, \.colorScheme)
        }
    }

    enum UserInteractionKey: String, PropertyPickerKey {
        case Enabled, Disabled

        var value: Bool {
            switch self {
            case .Enabled: true
            case .Disabled: false
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
}
#endif
