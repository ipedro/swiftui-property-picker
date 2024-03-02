# SwiftUI Environment Picker

![Swift Version](https://img.shields.io/badge/swift-5.7-orange.svg)
![Build Status](https://img.shields.io/badge/build-passing-brightgreen.svg)
![License](https://img.shields.io/badge/License-MIT-blue.svg)
![SPM Compatible](https://img.shields.io/badge/Swift_Package_Manager-compatible-brightgreen.svg)

`swiftui-environment-picker` is a SwiftUI package that enhances the capability of SwiftUI views to dynamically adapt based on environment values. This package provides a robust system for selecting environment values through custom view modifiers and selector styles, enabling developers to create customizable and responsive UI components with ease.

## Features

- **Dynamic Value Selection**: Easily select and apply dynamic values to your SwiftUI environment, enabling UI components to adapt based on user interaction or other criteria.
- **Customizable Picker Styles**: Comes with a suite of picker styles that can be easily customized or extended to fit the design language of your app.
- **Advanced State Management**: Utilizes `ObservableObject` for reactive state management, ensuring your UI updates efficiently in response to changes.

## Installation

### Swift Package Manager

You can add `swiftui-environment-picker` to your project via Swift Package Manager. Add the following line to your `Package.swift` dependencies:

```swift
dependencies: [
    .package(url: "https://github.com/ipedro/swiftui-environment-picker", .upToNextMajor(from: "1.0.0"))
]
```

Then, simply import `swiftui-environment-picker` in your SwiftUI views to get started.

## Usage

### Basic Usage

Apply the `environmentPicker` modifier to any SwiftUI view to enable dynamic value selection based on a specified key.

```swift
import SwiftUI
import EnvironmentPicker

struct ContentView: View {
    var body: some View {
        Button("Hello, Dynamic World!") {
            // do something
        }
        .environmentPicker(MyDynamicKey.self)
        .environmentPicker(ForegroundStyleKey.self)
        .environmentPicker(DisabledStateKey.self)
    }
}
```

### Defining Dynamic Keys

Conform to the `EnvironmentPickerKey` protocol to define your dynamic keys. Here are two examples that change native `EnvironmentValues`:


#### Example 1: Changing Custom Properties

Conform to the `EnvironmentPickerKey` protocol to define your dynamic keys.

```swift
import SwiftUI
import EnvironmentPicker

enum MyDynamicKey: String, EnvironmentPickerKey {
    case optionOne, optionTwo

    static var keyPath: WritableKeyPath<EnvironmentValues, String> {
        \.myCustomKey // some custom key
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

#### Example 2: Changing Foreground Style

```swift
import SwiftUI
import EnvironmentPicker

enum ForegroundStyleKey: String, EnvironmentPickerKey {
    case standard, muted

    static var keyPath: WritableKeyPath<EnvironmentValues, Color> {
        \.foregroundColor
    }

    static var defaultCase: Self {
        .standard
    }

    var value: Color {
        switch self {
        case .standard: return .blue
        case .muted: return .gray
        }
    }
}
```

#### Example 3: Toggling Disabled State

```swift
import SwiftUI
import EnvironmentPicker

enum DisabledStateKey: String, EnvironmentPickerKey {
    case enabled, disabled

    static var keyPath: WritableKeyPath<EnvironmentValues, Bool> {
        \.isEnabled
    }

    static var defaultCase: Self {
        .enabled
    }

    var value: Bool {
        switch self {
        case .enabled: return false
        case .disabled: return true
        }
    }
}
```

### Customizing Picker Styles

The `swiftui-environment-picker` package includes several built-in styles for presenting dynamic value selectors. These styles allow you to easily customize the appearance and behavior of your value selectors to match the design and functionality of your app. Below are detailed examples of the built-in styles and how to apply them.

#### Built-in Styles

##### 1. Sheet

The `SheetEnvironmentPicker` style presents your dynamic value options in a modal sheet. This style is ideal for offering a focused selection experience without leaving the current context.

**Usage Example:**

```swift
import SwiftUI
import EnvironmentPicker

struct ContentView: View {
    @State private var isSheetPresented = false

    var body: some View {
        Button("Open Picker") {
            isSheetPresented = true
        }
        .environmentPickerStyle(.sheet(isPresented: $isSheetPresented))
    }
}
```

**Effect:**

When the user taps the button, a modal sheet appears with the available dynamic value options. The user can select an option, which then updates the corresponding environment value.

##### 2. Inline

The `InlineEnvironmentPicker` style embeds the dynamic value options directly within your view hierarchy. This inline style is useful for integrating the picker seamlessly within your layout.

**Usage Example:**

```swift
import SwiftUI
import EnvironmentPicker

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Select an Option")
            .environmentPickerStyle(.inline)
            // Additional content
        }
    }
}
```

##### 3. Context Menu

The `InlineEnvironmentPicker` style embeds the dynamic value options directly within your view hierarchy. This inline style is useful for integrating the picker seamlessly within your layout.

**Usage Example:**

```swift
import SwiftUI
import EnvironmentPicker

struct ContentView: View {
    var body: some View {
        VStack {
            Text("Select an Option")
            .environmentPickerStyle(.inline)
            // Additional content
        }
    }
}
```

**Effect:**

The dynamic value options are displayed inline within the `VStack`, allowing the user to select an option without navigating away from the current view.

#### Customizing Styles

You can also create your own custom styles by conforming to the `EnvironmentPickerStyle` protocol. This allows for complete control over the presentation and interaction of the picker.

**Creating a Custom Style:**

```swift
import SwiftUI
import EnvironmentPicker

struct CustomPickerStyle: EnvironmentPickerStyle {
    func makeBody(configuration: Configuration) -> some View {
        // Custom implementation
    }
}
```

**Applying a Custom Style:**

```swift
Text("Custom Picker")
    .environmentPickerStyle(CustomPickerStyle())
```

By creating and applying custom styles, you can tailor the dynamic value selection process to fit the unique needs and design language of your app, enhancing the user experience.

#### Summary

Customizing the picker styles provides flexibility and creative control over how dynamic values are selected within your SwiftUI application. Whether using the built-in styles for convenience or creating your own for a bespoke UI, this package supports a wide range of use cases and design requirements.

## Contributing

Contributions to `swiftui-environment-picker` are welcome! Whether it's submitting bugs, requesting features, or contributing code, we encourage you to get involved.

1. Fork the repository.
2. Create your feature branch (`git checkout -b feature/AmazingFeature`).
3. Commit your changes (`git commit -am 'Add some AmazingFeature'`).
4. Push to the branch (`git push origin feature/AmazingFeature`).
5. Open a pull request.

## License

`swiftui-environment-picker` is available under the MIT license. See the LICENSE file for more info.

## Acknowledgments

- Thanks to all the contributors who have helped to shape this project.
- Inspired by the dynamic and customizable nature of SwiftUI.

For more information on how to use `swiftui-environment-picker`, please refer to the [documentation](https://github.com/ipedro/swiftui-environment-picker/wiki).
