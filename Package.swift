// swift-tools-version: 5.7

import PackageDescription

let isRemoteCheckout = Context.packageDirectory.contains("Library/Developer/Xcode/DerivedData/")

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
            name: "PropertyPickerExamples",
            targets: ["PropertyPickerExamples"]
        ),
    ],
    targets: [
        .target(
            name: "PropertyPicker",
            swiftSettings: {
                if isRemoteCheckout {
                    []
                } else {
                    [.define("VERBOSE")]
                }
            }()
        ),
        .target(
            name: "PropertyPickerExamples",
            dependencies: ["PropertyPicker"],
            path: "Sources/Examples"
        ),
    ]
)
