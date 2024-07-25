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
            name: "PropertyPicker-Examples",
            targets: ["PropertyPicker-Examples"]
        ),
        .library(
            name: "PropertyPicker-Examples",
            targets: ["PropertyPicker-Examples"]
        ),
    ],
    targets: [
        .target(
            name: "PropertyPicker",
            sources: ["Sources/PropertyPicker.swift"]
        ),
        .target(
            name: "PropertyPicker-Development",
            swiftSettings: [.define("VERBOSE")]
        ),
        .target(
            name: "PropertyPicker-Examples",
            dependencies: ["PropertyPicker"],
            path: "Sources/Examples"
        ),
    ]
)

