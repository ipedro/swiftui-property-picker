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

public extension View {
    @available(iOS 16.0, *)
    func propertyPickerListContentBackground(_ background: Color?) -> some View {
        setPreferenceChange(
            ListStyleContentBackgroundPreference.self,
            value: background
        )
    }

    func propertyPicker<K: PropertyPickerKey, Row: View>(
        for key: K.Type = K.self,
        @ViewBuilder body: @escaping (_ property: Property) -> Row
    ) -> some View {
        let keyType = String(describing: key)
        let viewBuilder = PropertyViewBuilder { someProp in
            if someProp.keyType == String(describing: key) {
                return AnyView(body(someProp))
            }
            return nil
        }
        let value = [keyType: viewBuilder]
        return setPreferenceChange(
            ViewBuilderPreference.self,
            value: value
        )
    }

    func propertyPickerTitle(_ title: LocalizedStringKey?) -> some View {
        setPreferenceChange(
            TitlePreference.self,
            value: {
                if let title { return Text(title) }
                return nil
            }()
        )
    }

    func propertyPickerTitle(_ title: String?) -> some View {
        setPreferenceChange(
            TitlePreference.self,
            value: {
                if let title { return Text(verbatim: title) }
                return nil
            }()
        )
    }

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
        PickerSelectionReader(pickerState.key) { initialValue in
            onChange(of: initialValue) { newValue in
                pickerState.state = newValue
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
        PickerSelectionReader(pickerEnvironment.key) { value in
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
        PickerSelectionReader(key) { initialValue in
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
        PickerSelectionReader(key) { value in
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

private final class Storage: ObservableObject {
    @Published
    var properties: [Property] = []

    @Published
    var title = TitlePreference.defaultValue

    @Published
    var bottomInset: Double = 0

    @Published
    var viewBuilders = [String: PropertyViewBuilder]()

    var isEmpty: Bool { properties.isEmpty }
}

/// A SwiftUI view that enables dynamic property selection.
///
/// This view acts as a container that integrates with the property picker system to allow users
/// to dynamically select properties and apply them to the enclosed content.
public struct PropertyPicker<Content: View>: View {
    /// The content to be presented alongside the dynamic value selector.
    let content: Content
    /// The state holding the dynamic value entries.

    @StateObject
    private var data = Storage()

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
    private var configuration: PropertyPickerStyleConfiguration {
        PropertyPickerStyleConfiguration(
            title: data.title,
            content: PropertyPickerContent(content),
            isEmpty: data.isEmpty
        )
    }

    /// The body of the dynamic value selector, presenting the content using the current selector style.
    public var body: some View {
        AnyView(style.resolve(configuration: configuration))
            .safeAreaInset(edge: .bottom) {
                Spacer().frame(height: data.bottomInset)
            }
            .animation(.snappy, value: data.bottomInset)
            .environmentObject(data)
    }
}

// MARK: - State Picker

/// A property wrapper that holds the state of a property to be adjusted using the property picker.
/// It automatically updates the view when the selection changes.
@propertyWrapper
public struct PropertyPickerState<Key: PropertyPickerKey>: DynamicProperty {
    let key: Key.Type
    @State<Key.Value> var state: Key.Value

    /// Initializes the state with the specified key.
    ///
    /// - Parameter key: The type of the key that represents the property being adjusted.
    public init(_ key: Key.Type, initialValue: Key.Value = Key.defaultCase.value) {
        self.key = key
        self._state = State(initialValue: initialValue)
    }

    /// The current value of the property being adjusted.
    public var wrappedValue: Key.Value {
        get { state }
        nonmutating set { state = newValue }
    }

    /// The projected value, providing access to the binding of the state.
    public var projectedValue: Self {
        self
    }

    public var binding: Binding<Key.Value> { $state }
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

// MARK: - PropertyPickerKey Protocol

/// Defines the requirements for a type to act as a key in the property picker system.
/// Each key represents a property that can be dynamically adjusted within a SwiftUI view.
public protocol PropertyPickerKey<Value>: RawRepresentable, CaseIterable, Hashable where AllCases.Element: RawRepresentable<String> {
    /// The associated value type that the key controls.
    associatedtype Value
    /// The default case to use when no other value is specified.
    static var defaultCase: AllCases.Element { get }
    /// A user-friendly description of the key. Used in UI elements like labels.
    static var defaultDescription: String { get }
    /// The current value associated with the key. This value is used to update the view's state.
    var value: Value { get }
}

public extension PropertyPickerKey where Value == Self {
    var value: Self { self }
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

// MARK: - ## Styles ##

@available(iOS 16.4, *)
public extension PropertyPickerStyle where Self == SheetPropertyPicker {
    static func sheet(
        isPresented: Binding<Bool>,
        adjustsBottomInset: Bool = true,
        detent: PresentationDetent = .fraction(1/4),
        presentationDetents: Set<PresentationDetent> = [
            .fraction(1/4),
            .medium,
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

/// Provides a convenient static property for accessing the inline selector style.
public extension PropertyPickerStyle where Self == InlinePropertyPicker {
    /// A style that presents dynamic value options inline within the view hierarchy.
    static var inline: Self { .init() }
}

// MARK: - Context Menu Style

/// Provides a convenient static property for accessing the context menu selector style.
public extension PropertyPickerStyle where Self == ContextMenuPropertyPicker {
    /// A static property to access a context menu selector style instance.
    static var contextMenu: Self { .init() }
}

/// A protocol for defining custom styles for presenting dynamic value selectors.
public protocol PropertyPickerStyle: DynamicProperty {
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
    /// The optional text
    public let title: Text?
    /// The actual content view.
    public let content: PropertyPickerContent
    /// A boolean indicating if there are no dynamic value entries.
    public let isEmpty: Bool
    /// The dynamic value entries to be presented.
    public let rows = PropertyPickerRows()
}

/// The content to be presented alongside the dynamic value entries.
public struct PropertyPickerContent: View {
    let content: AnyView

    init<V: View>(_ content: V) {
        self.content = AnyView(content)
    }

    @EnvironmentObject
    private var data: Storage

    public var body: some View {
        content
            .onPreferenceChange(PropertyPreference.self) { data.properties = $0 }
            .onPreferenceChange(BottomInsetPreference.self) { data.bottomInset = $0 }
            .onPreferenceChange(TitlePreference.self) { data.title = $0 }
            .onPreferenceChange(ViewBuilderPreference.self) { data.viewBuilders = $0 }
    }
}

/// Represents the dynamic value entries within the selector.
public struct PropertyPickerRows: View {
    @EnvironmentObject
    private var data: Storage

    public var body: some View {
        ForEach(data.properties) { property in
            if let customPicker = makeBody(configuration: (property, data.viewBuilders)) {
                customPicker
            } else {
                defaultPicker(configuration: property)
            }
        }
    }
    
    private var emptyMessage: String {
        "Nothing yet"
    }

    private func makeBody(configuration: (item: Property, source: [String: PropertyViewBuilder])) -> AnyView? {
        for key in configuration.source.keys where key == configuration.item.keyType {
            if let view = configuration.source[key]?.view(configuration.item) {
                return view
            }
        }
        return nil
    }

    // TODO: move to view builder
    private func defaultPicker(configuration property: Property) -> some View {
        Picker(property.title, selection: property.selection) {
            ForEach(property.options, id: \.self) { item in
                Text(item).tag(item)
            }
        }
    }
}

private struct ViewBuilderPreference: PreferenceKey {
    static let defaultValue = [String: PropertyViewBuilder]()
    static func reduce(value: inout [String: PropertyViewBuilder], nextValue: () -> [String: PropertyViewBuilder]) {
        value.merge(nextValue()) { content, _ in
            content
        }
    }
}

// MARK: - Row Builder

private struct PropertyViewBuilder: Equatable, Identifiable {
    let id = UUID()
    let view: (Property) -> AnyView?

    static func == (lhs: PropertyViewBuilder, rhs: PropertyViewBuilder) -> Bool {
        lhs.id == rhs.id
    }
}


private struct HashableBox<Value>: Identifiable, Hashable, CustomStringConvertible {
    static func == (lhs: HashableBox<Value>, rhs: HashableBox<Value>) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    var id: String { description }

    let value: Value

    let description: String

    init(value: Value) {
        self.value = value
        self.description = String(describing: value)
    }
}

// MARK: - Sheet Style

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
                configuration.rows
                    .listRowBackground(Color.clear)
            } header: {
                configuration.title
                    .bold()
                    .padding(
                        EdgeInsets(top: 16, leading: 0, bottom: 8, trailing: 0)
                    )
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
            configuration.rows.padding(.top, 8)
        }
    }
}

/// A style that presents dynamic value options within a context menu.
public struct ContextMenuPropertyPicker: PropertyPickerStyle {
    /// Creates the view for the context menu style, presenting the dynamic value options within a context menu.
    ///
    /// - Parameter configuration: The configuration containing the dynamic value options and content.
    /// - Returns: A view displaying the dynamic value options in a context menu.
    public func makeBody(configuration: Configuration) -> some View {
        configuration.content.contextMenu {
            configuration.rows
        }
    }
}

private struct ResolvedStyle<Style: PropertyPickerStyle>: View {
    var configuration: PropertyPickerStyleConfiguration
    var style: Style

    var body: some View {
        style.makeBody(configuration: configuration)
    }
}

private extension PropertyPickerStyle {
    func resolve(configuration: Configuration) -> some View {
        ResolvedStyle(configuration: configuration, style: self)
    }
}

// MARK: - SelectionReader

/// `SelectionReader` is a generic SwiftUI view responsible for presenting the content associated with a property picker key
/// and handling the dynamic selection of property values. It leverages SwiftUI's `@StateObject` to track the current selection and
/// updates the UI accordingly when a new selection is made.
///
/// This view serves as the foundation for integrating property picker functionality into SwiftUI views, enabling dynamic configuration
/// of view properties based on user selection.
///
/// - Parameters:
///   - Key: The type of the property picker key, conforming to `PropertyPickerKey`.
///   - Content: The type of the SwiftUI view to be presented, which will adjust based on the selected property value.
private struct PickerSelectionReader<Key, Content>: View where Key: PropertyPickerKey, Content: View {

    /// Internal ObservableObject for managing the dynamic selection state.
    private class Store: ObservableObject {
        private(set) var id = UUID()
        @Published var selection = Key.defaultCase {
            willSet { id = UUID() }
        }
    }

    /// The current selection state of the dynamic value, observed for changes to update the view.
    @StateObject private var store = Store()

    /// A view builder closure that creates the content view based on the current selection.
    /// This allows the view to reactively update in response to changes in the selection.
    @ViewBuilder private var content: (Key.Value) -> Content

    /// The item representing the currently selected value, used for updating the UI and storing preferences.
    private var data: Property {
        Property(id: store.id, selection: $store.selection)
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

    private var selectedValue: Key.Value {
        store.selection.value
    }
    /// The body of the `PropertyPickerContentView`, rendering the content based on the current selection.
    /// It uses a clear background view to capture preference changes, allowing the dynamic property picker system to react.
    var body: some View {
        content(selectedValue).modifier(
            PreferenceValueModifier<PropertyPreference>([data])
        )
    }
}

// MARK: - Preference Keys

private struct BottomInsetPreference: PreferenceKey {
    static var defaultValue: Double = 0
    static func reduce(value: inout Double, nextValue: () -> Double) {}
}

private struct TitlePreference: PreferenceKey {
    static var defaultValue: Text?
    static func reduce(value: inout Text?, nextValue: () -> Text?) {}
}

private struct ListStyleContentBackgroundPreference: PreferenceKey {
    static var defaultValue: Color?
    static func reduce(value: inout Color?, nextValue: () -> Color?) {
        if let nextValue = nextValue() {
            value = nextValue
        }
    }
}

/// A preference key for storing dynamic value entries.
///
/// This key aggregates values to be displayed in a custom selection menu, allowing
/// for dynamic updates and customization of menu content based on user selection.
private struct PropertyPreference: PreferenceKey {
    /// The default value for the dynamic value entries.
    static var defaultValue: [Property] = []

    /// Combines the current value with the next value.
    ///
    /// - Parameters:
    ///   - value: The current value of dynamic value entries.
    ///   - nextValue: A closure that returns the next set of dynamic value entries.
    static func reduce(value: inout [Property], nextValue: () -> [Property]) {
        value = nextValue() + value
    }
}

// MARK: - Environment Key for Picker Styles

/// An environment key for storing the current dynamic value selector style.
private struct StyleKey: EnvironmentKey {
    /// The default value for the selector style, using `ListPropertyPicker` as the default.
    static let defaultValue: any PropertyPickerStyle = ListPropertyPicker.list
}

/// Extends `EnvironmentValues` to include a property for accessing the dynamic value selector style.
private extension EnvironmentValues {
    /// The current dynamic value selector style within the environment.
    var propertyPickerStyle: any PropertyPickerStyle {
        get { self[StyleKey.self] }
        set { self[StyleKey.self] = newValue }
    }
}

/// A modifier that you apply to a view or another view modifier to set a value for any given preference key.
private struct PreferenceValueModifier<K: PreferenceKey>: ViewModifier {
    let value: K.Value

    init(_ value: K.Value) {
        self.value = value
    }

    func body(content: Content) -> some View {
        content.background(
            Spacer().preference(key: K.self, value: value)
        )
    }
}

// MARK: - Content

/// Represents a dynamic value entry with a unique identifier, title, and selectable options.
public struct Property: Identifiable, Equatable {
    /// A unique identifier for the entry.
    public let id: UUID
    /// The title of the entry, used as a label in the UI.
    public let title: String
    /// A binding to the currently selected option.
    public let selection: Binding<String>
    /// The options available for selection.
    public let options: [String]

    let keyType: String

    /// Initializes a new dynamic value entry with the specified parameters.
    ///
    /// - Parameters:
    ///   - key: The property picker key type.
    ///   - selection: A binding to the currently selected key.
    init<Key: PropertyPickerKey>(
        _ key: Key.Type = Key.self,
        id: UUID = UUID(),
        selection: Binding<Key>
    ) {
        self.id = id
        self.keyType = String(describing: key)
        self.options = Key.allCases.map(\.rawValue)
        self.title = Key.defaultDescription
        self.selection = Binding {
            selection.wrappedValue.rawValue
        } set: { rawValue in
            if let newValue = Key(rawValue: rawValue), selection.wrappedValue != newValue {
                selection.wrappedValue = newValue
            }
        }
    }

    /// Determines if two entries are equal based on their identifiers.
    public static func == (lhs: Property, rhs: Property) -> Bool {
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

public extension PropertyPickerStyle where Self == ListPropertyPicker<PlainListStyle, Color> {
    static var list: Self { .list() }

    static func list(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

public extension PropertyPickerStyle where Self == ListPropertyPicker<InsetGroupedListStyle, Color> {
    static var insetGroupedList: Self { .insetGroupedList() }

    static func insetGroupedList(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

public extension PropertyPickerStyle where Self == ListPropertyPicker<GroupedListStyle, Color> {
    static var groupedList: Self { .groupedList() }

    static func groupedList(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

public extension PropertyPickerStyle where Self == ListPropertyPicker<SidebarListStyle, Color> {
    static var sidebarList: Self { .sidebarList() }

    static func sidebarList(
        rowBackground: Color = Color(uiColor: .systemBackground)
    ) -> Self {
        .init(
            listStyle: .init(),
            listRowBackground: rowBackground
        )
    }
}

// MARK: - List Style

public struct ListPropertyPicker<S: ListStyle, B: View>: PropertyPickerStyle {
    let listStyle: S
    let listRowBackground: B

    @State
    private var contentBackground: Color?

    public func makeBody(configuration: Configuration) -> some View {
        List {
            Section {
                configuration.rows.listRowBackground(listRowBackground)
            } header: {
                VStack(spacing: .zero) {
                    ZStack {
                        GroupBox {
                            Spacer().frame(maxWidth: .infinity)
                        }
                        .ios16_backgroundStyle(contentBackground ?? Color(uiColor: .systemBackground))
                        .animation(.smooth, value: contentBackground)

                        configuration.content
                            .padding()
                            .onPreferenceChange(ListStyleContentBackgroundPreference.self) {
                                contentBackground = $0
                            }
                    }
                    .environment(\.textCase, nil)
                    .padding(.vertical)

                    configuration.title
                        .multilineTextAlignment(.leading)
                        .padding(.top)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                }
                .frame(maxWidth: .infinity)
            }
        }
        .listStyle(listStyle)
    }
}

private extension View {
    @ViewBuilder
    func ios16_backgroundStyle<S: ShapeStyle>(_ background: S) -> some View {
        if #available(iOS 16.0, *) {
            backgroundStyle(background)
        } else {
            // Fallback on earlier versions
            self
        }
    }

    func setPreferenceChange<K: PreferenceKey>(
        _ key: K.Type,
        value: K.Value
    ) -> some View {
        modifier(PreferenceValueModifier<K>(value))
    }

//    func setPreferenceChange<K: PreferenceKey, C: View, T>(
//        _ key: K.Type,
//        @ViewBuilder content: @escaping (T) -> C
//    ) -> some View where K.Value == [String: RowViewBuilder] {
//        let dataType = String(describing: T.self)
//        let viewBuilder = RowViewBuilder { value in
//            if let castedValue = value as? T {
//                return AnyView(content(castedValue))
//            }
//            return nil
//        }
//        let value = [dataType: viewBuilder]
//        return modifier(PreferenceValueModifier<K>(value))
//    }
}

// MARK: - Preview

#if DEBUG
@available(iOS 16.0, *)
struct Example: PreviewProvider {

    static var previews: some View {
        PropertyPicker {
            Button {
                //
            } label: {
                Text("Button")
            }
            .buttonStyle(.bordered)
            .propertyPicker(UserInteractionKey.self, \.isEnabled)
            .propertyPicker(ColorSchemeKey.self, \.colorScheme)
            .propertyPickerListContentBackground(Color.blue)
            .propertyPickerListContentBackground(Color.red)
        }
        .propertyPickerStyle(.list)
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
