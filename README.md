# SwiftUI Environment Picker

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
        Text("Hello, Dynamic World!")
            .environmentPickerOption(MyDynamicKey.self)
    }
}
```

### Defining Dynamic Keys

Conform to the `EnvironmentPickerKey` protocol to define your dynamic keys.

```swift
enum MyDynamicKey: String, EnvironmentPickerKey {
    case optionOne, optionTwo

    static var keyPath: WritableKeyPath<EnvironmentValues, String> {
        \.myDynamicValue
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

### Customizing Picker Styles

Implement the `EnvironmentPickerStyle` protocol to create custom picker styles.

```swift
struct CustomPickerStyle: EnvironmentPickerStyle {
    // Implementation details...
}
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

---

For more information on how to use `swiftui-environment-picker`, please refer to the [documentation](https://github.io/ipedro/swiftui-environment-picker/).
