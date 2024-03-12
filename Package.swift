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
            targets: ["PropertyPicker"]),
    ],
    targets: [
        .target(
            name: "PropertyPicker",
            path: ".",
            sources: ["PropertyPicker.swift"]
        ),
        .testTarget(
            name: "PropertyPickerTests",
            dependencies: ["PropertyPicker"]),
    ]
)
