# SwiftUI Property Picker

![Swift Version](https://img.shields.io/badge/swift-5.7-orange.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![SPM Compatible](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)

The `swiftui-property-picker` is a comprehensive SwiftUI package designed to enhance dynamic property selection and application within your SwiftUI views. By leveraging the power of property pickers, you can offer a richer, more interactive user experience that adapts on the fly.

## Features

- **Dynamic Property Selection**: Enable views to adjust their properties dynamically based on user selection or other criteria.
- **Flexible Configuration**: Easily configure property pickers to use state, environment values, or custom binding for dynamic updates.
- **Customizable Presentation Styles**: Choose from multiple presentation styles for your pickers, or define your own for full control over the UI.
- **Streamlined Integration**: Designed for ease of use, the package can be seamlessly integrated into any SwiftUI project to enhance its dynamic capabilities.

## Installation

### Swift Package Manager

Add `swiftui-property-picker` to your project by including it in your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/ipedro/swiftui-property-picker", .upToNextMajor(from: "1.0.0"))
]
```

Then, import `swiftui-property-picker` in your SwiftUI views to start using it.

## Usage

Here's how to get started with the SwiftUI Property Picker:

### Basic Usage

To apply a dynamic property picker to a view, use one of the `propertyPicker` view modifiers provided by the extension on `View`. Here are some examples:

```swift
import SwiftUI
import PropertyPicker

// Define a custom view that users can adjust using property pickers
struct AdjustablePreviewView: View {
    @PropertyPickerState<FontSizeKey>
    private var fontSize

    @PropertyPickerState<ColorSchemeKey>
    private var colorScheme

    @PropertyPickerState<DisabledStateKey>
    private var isButtonDisabled
    
    var body: some View {
        PropertyPicker {
            VStack {
                Text("Dynamic Preview")
                    .font(.system(size: fontSize))
                
                Button("Action") {}
                    .disabled(isButtonDisabled)
                    .padding()
                    .background(colorScheme == .dark ? Color.white : Color.black)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .clipShape(Capsule())
                
                Spacer()
            }
            .padding()
            // Apply dynamic property pickers for adjusting settings
            .propertyPicker($fontSize)
            .propertyPicker($colorScheme)
            .propertyPicker($isButtonDisabled)
        }
        // Optional: Apply a custom style to the PropertyPicker if needed
        .propertyPickerStyle(.inline) // This is just an example; choose the style as per your design.
    }
}

// Example PropertyPickerKey implementations for fontSize, colorScheme, and isButtonDisabled
enum FontSizeKey: String, PropertyPickerKey {
    case small, medium, large
    
    static var defaultValue: Self { .medium }
    
    var value: Double {
        switch self {
        case .small: return 12
        case .medium: return 16
        case .large: return 20
        }
    }
}

enum ColorSchemeKey: String, PropertyPickerKey {
    case light, dark
    
    static var defaultValue: Self { .light }
    
    var value: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}

enum DisabledStateKey: String, PropertyPickerKey {
    case enabled, disabled
    
    static var defaultValue: Self { .enabled }
    
    var value: Bool {
        self == .disabled
    }
}
```

### Defining Property Picker Keys

Implement the `PropertyPickerKey` protocol to define the keys used for selecting properties. Here's an example:

```swift
enum YourPickerKey: String, PropertyPickerKey {
    case optionOne = "Option One"
    case optionTwo = "Option Two"
    
    static var defaultValue: Self { .optionOne }
    
    var value: SomeType {
        switch self {
        case .optionOne: return .someValue
        case .optionTwo: return .anotherValue
        }
    }
}
```

#### Using PropertyPickerState

```swift
import SwiftUI
import PropertyPicker

struct ContentView: View {
    @PropertyPickerState<YourPickerKey>
    private var myValue
    
    var body: some View {
        YourView(value: myValue)
            .propertyPicker($myValue)
    }
}
```

#### Using PropertyPickerEnvironment

```swift
import SwiftUI
import PropertyPicker

struct ContentView: View {
    @PropertyPickerEnvironment(YourPickerKey.self, \.myEnvironmentValue)
    private var myEnvironmentValue
    
    var body: some View {
        YourView().propertyPicker($myEnvironmentValue)
    }
}
```

or

```swift
import SwiftUI
import PropertyPicker

struct ContentView: View {
    var body: some View {
        YourView().propertyPicker(YourPickerKey.self, \.myEnvironmentValue)
    }
}
```

### Customizing Picker Styles

You can customize the presentation of your property pickers by applying different styles:

```swift
.propertyPickerStyle(.inline) // For inline presentation
.propertyPickerStyle(.contextMenu) // For context menu presentation
.propertyPickerStyle(.sheet(isPresented: $isSheetPresented)) // For sheet presentation
```

### Advanced Customization

#### Using `PropertyPickerState` for Local State Management

The `PropertyPickerState` property wrapper can be used to manage a local state that dynamically updates based on user selection. Here's an example demonstrating its usage:

```swift
import SwiftUI
import PropertyPicker

struct DynamicFontSizeView: View {
    @PropertyPickerState<FontSizeKey>
    private var fontSize
    
    var body: some View {
        Text("Adjustable Font Size")
            .font(.system(size: fontSize))
            .propertyPicker($fontSize)
    }
}

enum FontSizeKey: String, PropertyPickerKey {
    case small, medium, large
    
    static var defaultValue: Self { .medium }
    
    var value: CGFloat {
        switch self {
        case .small: return 12
        case .medium: return 16
        case .large: return 20
        }
    }
}
```

#### Using `PropertyPickerEnvironment` for Environment Value Adjustments

The `PropertyPickerEnvironment` property wrapper enables the adjustment of environment values directly. Here's how you can use it to modify the environment's `ColorScheme`:

```swift
import SwiftUI
import PropertyPicker

struct ThemeSwitcherView: View {
    var body: some View {
        VStack {
            Text("Theme Switcher")
            Toggle(isOn: .constant(true)) {
                Text("Dark Mode")
            }
            .propertyPicker(ColorSchemeKey.self, \.colorScheme)
        }
    }
}

enum ColorSchemeKey: String, PropertyPickerKey {
    case light, dark
    
    static var defaultValue: Self { .light }
    
    var value: ColorScheme {
        switch self {
        case .light: return .light
        case .dark: return .dark
        }
    }
}
```

#### Using Bindings Directly with `PropertyPicker`

For direct manipulation of view properties through bindings, the `propertyPicker` modifier can be utilized as follows:

```swift
import SwiftUI
import PropertyPicker

struct ContentView: View {
    @State private var isButtonDisabled: Bool = false
    
    var body: some View {
        Button(action: {}) {
            Text("Button")
        }
        .disabled(isButtonDisabled)
        .propertyPicker(DisabledStateKey.self, $isButtonDisabled)
    }
}

enum DisabledStateKey: String, PropertyPickerKey {
    case enabled, disabled
    
    static var defaultValue: Self { .enabled }
    
    var value: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        }
    }
}
```

#### Customizing Picker Presentation with `PropertyPickerStyle`

Apply custom styles to modify how property pickers are presented in the UI. The following example demonstrates using the `.sheet` style:

```swift
import SwiftUI
import PropertyPicker

struct CustomizedPickerView: View {
    @State private var isPickerPresented: Bool = false
    
    var body: some View {
        VStack {
            Text("Customized Picker Presentation")
            Button("Show Picker") {
                isPickerPresented = true
            }
        }
        .propertyPickerStyle(SheetPropertyPicker(isPresented: $isPickerPresented))
    }
}
```

These examples should provide a comprehensive understanding of how to leverage the various capabilities of the `swiftui-property-picker` package. By incorporating these dynamic and customizable property pickers into your SwiftUI views, you can create more interactive and responsive applications.

## Contributing

We welcome contributions! If you'd like to contribute, please fork the repository and use a feature branch. Pull requests are warmly welcome.

## License

The `swiftui-property-picker` package is released under the MIT License. See [LICENSE](LICENSE) for details.
