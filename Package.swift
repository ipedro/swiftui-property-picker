// swift-tools-version: 5.9

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains("/checkouts/")

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
    dependencies: isDevelopment ? [
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins",
            from: "0.55.1"
        ),
        .package(
            url: "https://github.com/nicklockwood/SwiftFormat",
            from: "0.54.0"
        )
    ] : [],
    targets: [
        .target(
            name: "PropertyPicker-Examples",
            dependencies: ["PropertyPicker"],
            path: "Examples"
        ),
        .target(
            name: "PropertyPicker",
            path: isDevelopment ? "Development" : ".",
            sources: isDevelopment ? nil : ["PropertyPicker.swift"],
            swiftSettings: isDevelopment ? [
                .define("VERBOSE")
            ] : nil
//            plugins: isDevelopment ? [
//                .plugin(
//                    name: "SwiftLintBuildToolPlugin",
//                    package: "SwiftLintPlugins"
//                )
//            ] : nil
        )
    ]
)
