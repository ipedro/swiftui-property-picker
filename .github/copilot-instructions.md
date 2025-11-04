# SwiftUI Property Picker - AI Coding Agent Instructions

## Project Overview

This is a **SwiftUI package** that provides dynamic property selection capabilities through property pickers. The package allows SwiftUI views to adjust their properties dynamically based on user selection, offering multiple presentation styles (inline, list, sheet).

**Key Links**:
- Documentation: https://ipedro.github.io/swiftui-property-picker/documentation/propertypicker/
- Repository: https://github.com/ipedro/swiftui-property-picker
- Minimum platforms: iOS 15, macOS 12

## Development Tools & Environment

### MCP Xcode Build Tools

**IMPORTANT**: This project has access to specialized Xcode build and simulation tools via Model Context Protocol (MCP). Always check `.vscode/mcp.json` for available tool configurations.

**Current Configuration** (`.vscode/mcp.json`):
- **Server**: `xcodebuildmcp` (via npx)
- **Workspace**: Auto-configured to current workspace folder
- **Project**: `Package.swift`
- **Scheme**: `PropertyPicker`

**Preferred Workflows**:
1. **Building & Running**: Use `mcp_xcodebuildmcp_build_run_sim` or `mcp_xcodebuildmcp_build_sim` instead of terminal commands
2. **Simulator Management**: Use `mcp_xcodebuildmcp_boot_sim`, `mcp_xcodebuildmcp_list_sims` for simulator control
3. **Testing**: Use `mcp_xcodebuildmcp_swift_package_test` for running tests
4. **UI Interaction**: Use `mcp_xcodebuildmcp_tap`, `mcp_xcodebuildmcp_type_text`, `mcp_xcodebuildmcp_screenshot` for simulator interaction
5. **Log Capture**: Use `mcp_xcodebuildmcp_start_sim_log_cap` and `mcp_xcodebuildmcp_launch_app_logs_sim` for debugging

**Available Tool Categories**:
- Building: `build_sim`, `build_macos`, `build_device`, `build_run_sim`, `build_run_macos`
- Swift Package: `swift_package_build`, `swift_package_run`, `swift_package_test`, `swift_package_clean`
- Simulators: `list_sims`, `boot_sim`, `erase_sims`, `open_sim`, `set_sim_appearance`, `set_sim_location`
- Apps: `install_app_sim`, `launch_app_sim`, `launch_app_logs_sim`, `stop_app_sim`
- UI Interaction: `tap`, `swipe`, `type_text`, `button`, `long_press`, `screenshot`, `describe_ui`
- Logging: `start_sim_log_cap`, `stop_sim_log_cap`, `launch_app_logs_sim`
- Project Info: `discover_projs`, `list_schemes`, `show_build_settings`, `get_sim_app_path`

**Why use MCP tools instead of terminal commands?**
- Native Xcode integration (no need to manually craft `xcodebuild` commands)
- Structured output (JSON responses instead of parsing terminal output)
- Automatic error handling and retries
- Simulator state management (boot, location, appearance)
- Built-in screenshot and UI interaction capabilities
- Log capture with structured filtering

## Critical Architecture Patterns

### Dual-Build System (Development vs. Release)

The package uses a **context-aware build configuration** in `Package.swift`:

- **Development mode**: `isDevelopment = !Context.packageDirectory.contains("/checkouts/")`
  - Sources from `Development/` directory (modular structure)
  - Enables `VERBOSE` compiler flag for debug logging (`#if VERBOSE`)
  - Includes SwiftLint and SwiftFormat dependencies
  - ⚠️ SwiftLint plugin currently **commented out** (lines 44-48 in Package.swift)

- **Release mode** (when in SPM checkouts):
  - Single concatenated file: `PropertyPicker.swift` at root
  - No dependencies, no VERBOSE logging
  - Minimal footprint for distribution

**When editing**: Always modify files in `Development/` directory. The root `PropertyPicker.swift` is auto-generated.

#### How Concatenation Works

The `.github/workflows/merge-sources.yml` workflow automatically runs on push to `main`:

1. **Finds all Swift files**: `find Development -type f -name '*.swift' | sort | xargs cat`
2. **Removes SwiftLint directives**: `sed '/\/\/ swiftlint:/d'`
3. **Consolidates imports**: Extracts, sorts, and deduplicates all `import` statements
4. **Prepends LICENSE**: Comments out entire LICENSE file with `// ` prefix
5. **Outputs**: Single `PropertyPicker.swift` with LICENSE → imports → code
6. **Auto-commits**: Bot pushes changes back to main

**Never manually edit** `PropertyPicker.swift` - your changes will be overwritten.

### Protocol-Driven Design

#### PropertyPickerKey Protocol
Core protocol that enum cases must implement to work with property pickers:
```swift
enum YourKey: String, PropertyPickerKey {
    case option1, option2
    
    static var defaultValue: Self { .option1 }
    
    var value: SomeType {
        // Map enum case to actual value
        switch self {
        case .option1: return .someValue
        case .option2: return .anotherValue
        }
    }
}
```

Key requirements:
- `RawRepresentable<String>` + `CaseIterable` 
- Must have at least one case (runtime `fatalError()` if empty)
- Automatic title/label transformation (camelCase → "Camel Case")
- See `Development/Protocols/PropertyPickerKey.swift`

#### PropertyPickerStyle Protocol
View modifiers for presentation styles (`_InlinePropertyPicker`, `_ListPropertyPicker`, `_SheetPropertyPicker`).
Access pre-built components via extension properties: `listRows`, `inlineRows`, `title`.

### Property Wrapper Pattern

**@PropertyPickerState** (formerly @PropertyPickerEnvironment):
- Manages selection state for picker keys
- Two modes:
  1. **Local state**: `@PropertyPickerState(YourKey.self)` 
  2. **Environment-bound**: `@PropertyPickerState(YourKey.self, keyPath: \.yourEnvironmentValue)`
- Always use with `$` binding: `.propertyPicker($yourPicker)`

### SwiftUI Preferences System

The package uses a **preference key flow** to bubble picker configuration up the view tree:

1. **View modifiers** write to preference keys:
   - `PropertyPreference` → picker rows/options
   - `TitlePreference` → picker title
   - `ViewBuilderPreference` → custom row builders

2. **Context modifier** collects preferences into `Context.Data` ObservableObject
   - See `Development/ViewModifiers/Context.swift`
   - Updates trigger UI refresh via `@Published` properties

3. **Styles** read from `@EnvironmentObject` to render UI

### Key Components

- **Property**: Represents a picker row with id, title, options, and selection binding
- **PropertyOption**: Individual selectable option within a picker
- **PropertyID**: Type-erased identifier for property keys
- **RowBuilder**: Protocol for custom row views

## Common Workflows

### Adding a New Property Picker Style

1. Create struct conforming to `PropertyPickerStyle` in `Development/Styles/`
2. Implement `body(content:)` view modifier
3. Use `content.listRows` or `content.inlineRows` for picker rows
4. Use `content.title` for header
5. Add convenience initializer to `PropertyPicker` in `Development/PropertyPicker.swift`

### Testing with Examples

The `Examples/` directory contains three reference implementations demonstrating different use cases:

#### 1. InlineExample.swift (Inline Picker)
- Simplest form - picker appears inline within view hierarchy
- Uses default `PropertyPicker()` initializer (no style parameter)
- Shows custom picker styles: `.pickerStyle(.segmented)` modifier
- Demonstrates local state (`content`) and environment-bound state (`interaction`, `colorScheme`)
- **Pattern**: Three-option enum with `.both` case showing `Label` composition

```swift
PropertyPicker {
    Button { /* ... */ } label: { /* ... */ }
        .propertyPicker($interaction)
        .propertyPicker($colorScheme)
        .propertyPicker($content)
}
```

#### 2. ListExample.swift (List Style Picker)
- Uses `PropertyPicker(style: S)` where `S: ListStyle`
- Shows platform-specific list styles (`.insetGrouped`, `.plain`)
- Demonstrates custom row backgrounds: `.propertyPickerRowBackground(.yellow.opacity(0.2))`
- **Key difference**: Provides explicit `ListStyle` to constructor

```swift
PropertyPicker(style: .insetGrouped) {
    // content with .propertyPicker() modifiers
}
```

#### 3. SheetExample.swift (Modal Sheet - iOS 16.4+)
- Most complex - modal presentation with detents
- Uses `PropertyPicker(isPresented: $presented)` binding
- Shows environment customization: `.propertyPickerListContentBackground(.bar)`, `.propertyPickerTitle("Example")`
- Requires `@available(iOS 16.4, macOS 13.3, *)` attribute
- **Pattern**: Button triggers sheet toggle, picker configures button appearance

**Running Examples**:
1. Import `PropertyPicker-Examples` product (separate library target)
2. Examples have `#Preview` macros for Xcode Previews
3. Each example is self-contained with private enum keys

### Debugging

**Verbose Logging** (Development builds only):
- Build automatically defines `VERBOSE` compiler flag in dev mode
- Logs print when `Context.Data` properties update:
  - `title` changes
  - `rows` changes (shows sorted titles)
  - `rowBuilders` changes (shows property IDs)
- Check `#if VERBOSE` blocks in `Development/Models/Context.Data.swift`
- Example output: `"Context.Data: Updated Rows ["Color Scheme", "Content", "Interaction"]"`

**Common Debug Scenarios**:
1. **Picker not appearing**: Check if view has `.propertyPicker($binding)` modifiers
2. **Selection not updating**: Verify binding uses `$` (projected value)
3. **Environment values not changing**: Ensure `keyPath:` parameter is correct
4. **Assertion failure on selection**: Check enum `rawValue` matches `PropertyOption.rawValue`

## Environment Values & Customization

The package extends SwiftUI's environment with picker-specific values:

- `.propertyPickerListContentBackground(_:)` - List background style (iOS 16+)
- `.propertyPickerRowBackground(_:)` - Individual row backgrounds
- `.propertyPickerTitle(_:)` - Custom picker title
- `.propertyPickerRowSorting(_:)` - Sort order for rows
- `.propertyPickerSafeAreaAdjustmentStyle(_:)` - Sheet inset behavior
- Internal: `selectionAnimation`, `sheetAnimation`, `titleTransformation`, `labelTransformation`

## CI/CD Workflows

### merge-sources.yml (Auto-Concatenation)
**Trigger**: Push to `main` branch

**Purpose**: Generates single-file `PropertyPicker.swift` for release distribution

**Steps**:
1. Finds and sorts all `.swift` files in `Development/`
2. Removes SwiftLint directives (`// swiftlint:*`)
3. Extracts and deduplicates `import` statements
4. Prepends commented LICENSE header
5. Commits result back to `main` as `github-actions[bot]`

**Important**: This means every push to main triggers two commits (yours + bot's). Don't be alarmed by the double commit.

### generate-documentation.yml (DocC)
**Trigger**: Tag pushes (`*`) or manual workflow dispatch

**Purpose**: Builds and deploys DocC documentation to GitHub Pages

**Steps**:
1. Runs on macOS 14 (requires Xcode for `xcodebuild`)
2. Builds: `xcodebuild docbuild -scheme PropertyPicker -destination 'generic/platform=iOS'`
3. Transforms archive for static hosting: `docc process-archive transform-for-static-hosting`
4. Deploys to: `https://ipedro.github.io/swiftui-property-picker/`
5. Auto-redirects root to `/documentation/propertypicker`

**Hosting**: Uses GitHub Pages with base path `/swiftui-property-picker`

## Development Workflows

### Local Development
```bash
# Open in Xcode
open Package.swift

# Build development version (modular sources)
swift build

# Run SwiftFormat (if installed)
swift package plugin --allow-writing-to-package-directory swiftformat

# Run SwiftLint (currently disabled in Package.swift)
# Uncomment lines 44-48 in Package.swift to enable
```

### Testing Changes
1. Edit files in `Development/` directory
2. Test with `PropertyPicker-Examples` target
3. Use Xcode Previews on example files for quick iteration
4. Push to main → CI auto-generates `PropertyPicker.swift`
5. Tag release → CI deploys documentation

### Creating a New Release
1. Update version in README.md installation instructions
2. Create git tag: `git tag 3.x.x && git push --tags`
3. CI automatically builds and deploys documentation
4. Create GitHub Release with tag

## Code Conventions

- **Naming**: Property picker keys use `*Key` suffix (e.g., `ColorSchemeKey`, `InteractionKey`)
- **Access control**: Public API uses `public`, internal components use `@usableFromInline`
- **Deprecation**: Old names retained with `@available(*, deprecated, renamed:)` attributes
  - Example: `PropertyPickerEnvironment` → `PropertyPickerState`
- **Platform availability**: Sheet styles require `@available(iOS 16.4, macOS 13.3, *)`
- **Type names**: Styles prefixed with `_` indicate internal implementation details (e.g., `_SheetPropertyPicker`)
- **SwiftLint**: Allows `_` in type names, ignores comments/URLs in line length
- **File organization**: Group related functionality (Models/, Protocols/, ViewModifiers/, etc.)

## SwiftLint Configuration

See `.swiftlint.yml`:
- **Disabled rules**: `redundant_discardable_let`
- **Type names**: Allows `_` prefix (for internal style implementations)
- **Line length**: Ignores comments, function declarations, URLs

## Platform Support

- **Minimum**: iOS 15, macOS 12
- **Conditional features**: 
  - Sheet with detents: iOS 16.4+, macOS 13.3+
  - Presentation background: iOS 16+, macOS 13+
  - List content background: iOS 16+
- **Testing**: No automated tests; relies on manual testing via Examples/

## Critical Don'ts

- ❌ **Don't edit `PropertyPicker.swift` at root** (auto-generated by CI on every push)
- ❌ **Don't remove `isDevelopment` logic** from Package.swift (breaks release builds)
- ❌ **Don't forget `@available` attributes** for iOS 16+ features (causes compilation errors for users)
- ❌ **Don't create `PropertyPickerKey` enums with zero cases** (runtime `fatalError()`)
- ❌ **Don't use view modifiers without `$` binding** for property wrappers (breaks reactivity)
- ❌ **Don't push directly to main** without testing in Examples/ first
- ❌ **Don't add imports to individual files** - they'll be consolidated at root during concatenation
