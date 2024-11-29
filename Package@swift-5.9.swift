// swift-tools-version: 5.9

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains("/checkouts/")

var package = Package(
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
            name: "PropertyPicker-Examples",
            dependencies: ["PropertyPicker"],
            path: "Examples"
        )
    ]
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
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency")]
        )
    ]
}
