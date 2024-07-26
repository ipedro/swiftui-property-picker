// swift-tools-version: 5.7

import PackageDescription

let isDevelopment = !Context.packageDirectory.contains(".build/checkouts/") && !Context.packageDirectory.contains("DerivedData/")

var targets: [Target] = [.target(
        name: "PropertyPicker-Examples",
        dependencies: ["PropertyPicker"],
        path: "Sources/Examples"
)]

if isDevelopment {
    targets.append(
        .target(
            name: "PropertyPicker",
            path: "Sources/Development",
            swiftSettings: [.define("VERBOSE")],
            plugins: [
                .plugin(
                    name: "SwiftLintBuildToolPlugin",
                    package: "SwiftLintPlugins"
                )
            ]
        )
    )
} else {
    targets.append(
        .target(
            name: "PropertyPicker",
            path: ".",
            sources: ["PropertyPicker.swift"]
        )
    )
}

var dependencies = [Package.Dependency]()
if isDevelopment {
    dependencies.append(
        .package(
            url: "https://github.com/SimplyDanny/SwiftLintPlugins",
            from: "0.55.1"
        )
    )
}

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
    dependencies: dependencies,
    targets: targets
)
