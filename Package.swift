// swift-tools-version: 5.7

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains(".build/checkouts/") && !Context.packageDirectory.contains("DerivedData/")

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
        )
    ],
    targets: [
        .target(
            name: "PropertyPicker",
            path: isDevelopment ? "Sources/Development" : ".",
            sources: isDevelopment ? nil : ["PropertyPicker.swift"],
            swiftSettings: isDevelopment ? [.define("VERBOSE")] : nil
        ),
        .target(
            name: "PropertyPicker-Examples",
            dependencies: ["PropertyPicker"],
            path: "Sources/Examples"
        ),
    ]
)

