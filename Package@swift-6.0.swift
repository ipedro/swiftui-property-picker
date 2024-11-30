// swift-tools-version: 6.0

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains("/checkouts/")

var package = Package(
    name: "swiftui-property-picker",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v13),
        .watchOS(.v7)
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
            name: "PropertyPicker-Examples",
            dependencies: ["PropertyPicker"],
            path: "Examples"
        )
    ],
    swiftLanguageModes: [.v5]
)

if isDevelopment {
    package.dependencies = [
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins",
            from: "0.55.1"
        )
    ]
    package.targets += [
        .target(
            name: "PropertyPicker",
            path: "Development",
            swiftSettings: [
                .define("VERBOSE"),
                .enableUpcomingFeature("StrictConcurrency")
            ],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLintPlugins"
                )
            ]
        )
    ]
} else {
    package.targets += [
        .target(
            name: "PropertyPicker",
            path: ".",
            sources: ["PropertyPicker.swift"],
            swiftSettings: [.enableUpcomingFeature("StrictConcurrency")]
        )
    ]
}
