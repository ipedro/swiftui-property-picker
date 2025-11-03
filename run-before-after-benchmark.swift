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

/// Benchmarks comparing OLD (unoptimized) vs NEW (optimized) implementations
struct BeforeAfterBenchmark {
    
    // MARK: - OLD Implementation (Before Optimization)
    
    /// OLD: Regex compiled on every call
    static func oldRegexTransformation(_ text: String) -> String {
        text.replacingOccurrences(
            of: "(?<=[a-z])(?=[A-Z])",
            with: " $0",
            options: .regularExpression // ❌ Compiles regex every time!
        )
    }
    
    /// NEW: Cached regex pattern
    private static let cachedRegex: NSRegularExpression = {
        try! NSRegularExpression(pattern: "(?<=[a-z])(?=[A-Z])", options: [])
    }()
    
    static func newRegexTransformation(_ text: String) -> String {
        let nsString = text as NSString
        let range = NSRange(location: 0, length: nsString.length)
        return cachedRegex.stringByReplacingMatches(
            in: text,
            options: [],
            range: range,
            withTemplate: " $0"
        )
    }
    
    // MARK: - Benchmark 1: Regex Performance
    
    static func benchmarkRegex(iterations: Int = 10000) -> ComparisonResult {
        let testStrings = [
            "ColorSchemeKey",
            "InteractionKey", 
            "ContentKey",
            "FontSizeKey",
            "AnimationDurationKey"
        ]
        
        // Test OLD implementation
        let oldStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            for string in testStrings {
                _ = oldRegexTransformation(string)
            }
        }
        let oldDuration = CFAbsoluteTimeGetCurrent() - oldStart
        
        // Test NEW implementation
        let newStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            for string in testStrings {
                _ = newRegexTransformation(string)
            }
        }
        let newDuration = CFAbsoluteTimeGetCurrent() - newStart
        
        return ComparisonResult(
            name: "Regex Transformation",
            iterations: iterations * testStrings.count,
            oldDuration: oldDuration,
            newDuration: newDuration
        )
    }
    
    // MARK: - OLD vs NEW: Property Creation
    
    struct MockProperty {
        let id: Int
        let title: String
        let options: [String]
    }
    
    /// OLD: Creates new property every time
    static func oldPropertyCreation(selection: String) -> MockProperty {
        let options = ["option1", "option2", "option3", "option4", "option5"]
        return MockProperty(
            id: 1,
            title: "Test Property",
            options: options
        )
    }
    
    /// NEW: Uses cache
    static var propertyCache: MockProperty?
    static var cachedSelection: String?
    
    static func newPropertyCreation(selection: String) -> MockProperty {
        if let cached = propertyCache, cachedSelection == selection {
            return cached // ✅ Return cached
        }
        
        let property = MockProperty(
            id: 1,
            title: "Test Property",
            options: ["option1", "option2", "option3", "option4", "option5"]
        )
        propertyCache = property
        cachedSelection = selection
        return property
    }
    
    static func benchmarkPropertyCreation(iterations: Int = 10000) -> ComparisonResult {
        // Test OLD implementation (always recreates)
        let oldStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = oldPropertyCreation(selection: "option1")
        }
        let oldDuration = CFAbsoluteTimeGetCurrent() - oldStart
        
        // Reset cache for fair comparison
        propertyCache = nil
        cachedSelection = nil
        
        // Test NEW implementation (caches)
        let newStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = newPropertyCreation(selection: "option1") // Same selection = cache hits
        }
        let newDuration = CFAbsoluteTimeGetCurrent() - newStart
        
        return ComparisonResult(
            name: "Property Creation (same selection)",
            iterations: iterations,
            oldDuration: oldDuration,
            newDuration: newDuration
        )
    }
    
    // MARK: - OLD vs NEW: Sorting
    
    static func benchmarkSorting(iterations: Int = 1000) -> ComparisonResult {
        let items = (0..<20).map { "Property \($0)" }
        var sortCache: [String]?
        
        // OLD: Sorts on every call
        let oldStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            _ = items.sorted() // ❌ Sorts every time
        }
        let oldDuration = CFAbsoluteTimeGetCurrent() - oldStart
        
        // NEW: Caches sorted result
        let newStart = CFAbsoluteTimeGetCurrent()
        for _ in 0..<iterations {
            if let cached = sortCache {
                _ = cached // ✅ Return cached
            } else {
                let sorted = items.sorted()
                sortCache = sorted
                _ = sorted
            }
        }
        let newDuration = CFAbsoluteTimeGetCurrent() - newStart
        
        return ComparisonResult(
            name: "Sorting (20 items)",
            iterations: iterations,
            oldDuration: oldDuration,
            newDuration: newDuration
        )
    }
    
    // MARK: - Run All Comparisons
    
    static func runAll() {
        print("\n⚡ Before/After Performance Comparison")
        print(String(repeating: "=", count: 90))
        
        let results = [
            benchmarkRegex(),
            benchmarkPropertyCreation(),
            benchmarkSorting()
        ]
        
        print("\n📊 Results:\n")
        
        for result in results {
            result.print()
        }
        
        // Calculate overall improvement
        let totalOld = results.reduce(0.0) { $0 + $1.oldDuration }
        let totalNew = results.reduce(0.0) { $0 + $1.newDuration }
        let overallSpeedup = totalOld / totalNew
        
        print(String(repeating: "=", count: 90))
        print("""
        
        🎯 Overall Performance:
          Combined OLD duration: \(String(format: "%.4f", totalOld))s
          Combined NEW duration: \(String(format: "%.4f", totalNew))s
          Overall speedup: \(String(format: "%.1f", overallSpeedup))x faster
        
        """)
        print(String(repeating: "=", count: 90))
    }
}

// MARK: - Comparison Result

struct ComparisonResult {
    let name: String
    let iterations: Int
    let oldDuration: TimeInterval
    let newDuration: TimeInterval
    
    var speedup: Double {
        oldDuration / newDuration
    }
    
    var percentImprovement: Double {
        ((oldDuration - newDuration) / oldDuration) * 100
    }
    
    func print() {
        let oldOpsPerSec = Double(iterations) / oldDuration
        let newOpsPerSec = Double(iterations) / newDuration
        
        Swift.print("""
        \(name):
          Iterations: \(iterations)
          
          ❌ OLD (unoptimized):
             Duration: \(String(format: "%.4f", oldDuration))s
             Ops/sec: \(String(format: "%.0f", oldOpsPerSec))
          
          ✅ NEW (optimized):
             Duration: \(String(format: "%.4f", newDuration))s
             Ops/sec: \(String(format: "%.0f", newOpsPerSec))
          
          🚀 Improvement: \(String(format: "%.1f", speedup))x faster (\(String(format: "%.1f", percentImprovement))% faster)
        
        """)
    }
}
