#!/usr/bin/env swift

import Foundation

// Import the benchmark from Examples
@_silgen_name("_$s28PropertyPicker_Examples0aB11BenchmarkV6runAllSayAC0C6ResultVGyFZ")
func runBenchmarks() -> [Any]

print("Running PropertyPicker Performance Benchmarks...")
print("")

// Note: To run these benchmarks properly, use the Xcode Preview in PerformanceBenchmark.swift
// or create a simple Mac/iOS app that calls PerformanceBenchmark.runAll()

print("""
To run the benchmarks:

1. Open Package.swift in Xcode
2. Navigate to Examples/PerformanceBenchmark.swift
3. Click the Preview button (▶️) or use the #Preview at the bottom
4. Click "Run Benchmarks" button
5. Check the Console output for results

Or run in an iOS/Mac app:
```swift
import PropertyPicker_Examples

Button("Run Benchmarks") {
    _ = PerformanceBenchmark.runAll()
}
```
""")
