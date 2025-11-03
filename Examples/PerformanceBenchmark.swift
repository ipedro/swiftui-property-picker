//  Copyright (c) 2024 Pedro Almeida
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import PropertyPicker
import SwiftUI

/// Performance benchmarking suite for PropertyPicker optimizations
/// Tests real-world usage patterns with PropertyPicker components
@MainActor
struct PerformanceBenchmark {
    
    // MARK: - Benchmark: Property Picker Key Title Transformation
    
    static func benchmarkTitleTransformation(iterations: Int = 1000) -> BenchmarkResult {
        let testKeys: [any PropertyPickerKey.Type] = [
            BenchmarkKey1.self,
            BenchmarkKey2.self,
            BenchmarkKey3.self,
            BenchmarkKey4.self,
            BenchmarkKey5.self
        ]
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            for keyType in testKeys {
                _ = keyType.title // Triggers transformation with cached regex
            }
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        let operationsPerSecond = Double(iterations * testKeys.count) / duration
        
        return BenchmarkResult(
            name: "Title Transformation",
            iterations: iterations * testKeys.count,
            duration: duration,
            operationsPerSecond: operationsPerSecond
        )
    }
    
    // MARK: - Benchmark: String Sorting
    
    static func benchmarkStringSorting(iterations: Int = 1000) -> BenchmarkResult {
        let strings = (0..<20).map { "Property \($0)" }
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = strings.sorted()
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        let operationsPerSecond = Double(iterations) / duration
        
        return BenchmarkResult(
            name: "String Sorting (20 items)",
            iterations: iterations,
            duration: duration,
            operationsPerSecond: operationsPerSecond
        )
    }
    
    // MARK: - Benchmark: Dictionary Lookup
    
    static func benchmarkCacheLookup(iterations: Int = 100000) -> BenchmarkResult {
        let cache: [String: String] = [
            "key1": "value1",
            "key2": "value2",
            "key3": "value3"
        ]
        
        let startTime = CFAbsoluteTimeGetCurrent()
        
        for _ in 0..<iterations {
            _ = cache["key1"]
        }
        
        let endTime = CFAbsoluteTimeGetCurrent()
        let duration = endTime - startTime
        let operationsPerSecond = Double(iterations) / duration
        
        return BenchmarkResult(
            name: "Cache Lookup",
            iterations: iterations,
            duration: duration,
            operationsPerSecond: operationsPerSecond
        )
    }
    
    // MARK: - Run All Benchmarks
    
    static func runAll() -> [BenchmarkResult] {
        print("\n🏁 PropertyPicker Performance Benchmarks")
        print(String(repeating: "=", count: 80))
        
        let results = [
            benchmarkTitleTransformation(),
            benchmarkStringSorting(),
            benchmarkCacheLookup()
        ]
        
        print("\n📊 Results:")
        print(String(repeating: "-", count: 80))
        
        for result in results {
            result.print()
        }
        
        print(String(repeating: "=", count: 80))
        print("✅ All benchmarks completed\n")
        
        return results
    }
}

// MARK: - Benchmark Result

struct BenchmarkResult {
    let name: String
    let iterations: Int
    let duration: TimeInterval
    let operationsPerSecond: Double
    
    var averageTimePerOperation: TimeInterval {
        duration / Double(iterations)
    }
    
    func print() {
        let formattedOpsPerSec = String(format: "%.0f", operationsPerSecond)
        Swift.print("""
        
        \(name):
          Iterations: \(iterations)
          Duration: \(String(format: "%.4f", duration))s
          Avg/operation: \(String(format: "%.6f", averageTimePerOperation * 1000))ms
          Ops/second: \(formattedOpsPerSec)
        """)
    }
}

// MARK: - Test Keys

private enum BenchmarkKey1: String, PropertyPickerKey {
    case colorSchemeKey
    var value: Self { self }
}

private enum BenchmarkKey2: String, PropertyPickerKey {
    case interactionKey
    var value: Self { self }
}

private enum BenchmarkKey3: String, PropertyPickerKey {
    case contentKey
    var value: Self { self }
}

private enum BenchmarkKey4: String, PropertyPickerKey {
    case fontSizeKey
    var value: Self { self }
}

private enum BenchmarkKey5: String, PropertyPickerKey {
    case animationDurationKey
    var value: Self { self }
}

// MARK: - Preview with Benchmark Button

#Preview("Performance Benchmark") {
    VStack(spacing: 20) {
        Text("PropertyPicker Performance")
            .font(.title)
            .bold()
        
        Button("Run Benchmarks") {
            _ = PerformanceBenchmark.runAll()
        }
        .buttonStyle(.borderedProminent)
        
        Text("Check console for results")
            .font(.caption)
            .foregroundStyle(.secondary)
    }
    .padding()
}
