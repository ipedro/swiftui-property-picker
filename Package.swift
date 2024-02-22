// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "swiftui-environment-picker",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
    ],
    products: [
        .library(
            name: "EnvironmentPicker",
            targets: ["EnvironmentPicker"]),
    ],
    targets: [
        .target(
            name: "EnvironmentPicker",
            path: ".",
            sources: ["EnvironmentPicker.swift"]
        ),
        .testTarget(
            name: "EnvironmentPickerTests",
            dependencies: ["EnvironmentPicker"]),
    ]
)
