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
            name: "Examples",
            targets: ["Examples"]
        ),
    ],
    targets: [
        .target(
            name: "PropertyPicker"
        ),
        .target(
            name: "Examples",
            dependencies: ["PropertyPicker"]
        ),
    ]
)
