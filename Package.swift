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
            name: "PropertyPicker-Development",
            targets: ["PropertyPicker-Development"]
        ),
    ],
    targets: [
        .target(
            name: "PropertyPicker",
            path: ".",
            sources: ["PropertyPicker.swift"]
        ),
        .target(
            name: "PropertyPicker-Development",
            path: "Sources/PropertyPicker",
            swiftSettings: [.define("VERBOSE")]
        ),
        .target(
            name: "PropertyPicker-Examples",
            dependencies: ["PropertyPicker"],
            path: "Sources/Examples"
        ),
    ]
)

