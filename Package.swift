// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swiftui-property-picker",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "PropertyPicker",
            targets: ["PropertyPicker"]
        ),
        .library(
            name: "PropertyPickerExamples",
            targets: ["PropertyPickerExamples"]
        ),
    ],
    targets: [
        .target(
            name: "PropertyPicker"
        ),
        .target(
            name: "PropertyPickerExamples",
            dependencies: ["PropertyPicker"],
            path: "Sources/Examples"
        ),
    ]
)
