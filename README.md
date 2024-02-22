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

Apply the `environmentPickerOption` modifier to any SwiftUI view to enable dynamic value selection based on a specified key.

```swift
import SwiftUI
import swiftui-environment-picker

struct ContentView: View {
    var body: some View {
        Button("Hello, Dynamic World!") {
            // do something
        }
        .environmentPickerOption(MyDynamicKey.self)
        .environmentPickerOption(ForegroundStyleKey.self)
        .environmentPickerOption(DisabledStateKey.self)
    }
}
```

### Defining Dynamic Keys

Conform to the `EnvironmentPickerKey` protocol to define your dynamic keys. Here are two examples that change native `EnvironmentValues`:


#### Example 1: Changing Custom Properties

Conform to the `EnvironmentPickerKey` protocol to define your dynamic keys.

```swift
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

Implement the `EnvironmentPickerStyle` protocol to create custom picker styles. Here's how you can apply a custom style:

```swift
Text("Select Option")
    .environmentPickerStyle(CustomPickerStyle())
```

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
