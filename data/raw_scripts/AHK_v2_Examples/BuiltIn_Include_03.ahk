/**
 * ============================================================================
 * AutoHotkey v2 #Include Directive - Library Structure and Organization
 * ============================================================================
 *
 * @description Comprehensive examples demonstrating library structure,
 *              organization patterns, and best practices for AutoHotkey v2
 *
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 *
 * DIRECTIVE: #Include
 * PURPOSE: Organize code into reusable library structures
 * RECOMMENDED STRUCTURE:
 *   MyScript.ahk          (main script)
 *   Lib/
 *     ├─ Core.ahk         (core functionality)
 *     ├─ Utils/
 *     │  ├─ String.ahk
 *     │  └─ File.ahk
 *     └─ Vendor/          (third-party libraries)
 *
 * @reference https://www.autohotkey.com/docs/v2/lib/_Include.htm
 * @reference https://www.autohotkey.com/docs/v2/Scripts.htm#lib
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Standard Library Structure
 * ============================================================================
 *
 * @description Demonstrate standard AutoHotkey library organization
 * @concept Library structure, standard locations, organization patterns
 */

/**
 * Library structure manager
 * @class
 */
class LibraryStructure {
    /**
     * Get standard library locations
     * @returns {Array} List of standard library paths
     */
    static GetStandardLocations() {
        return [
            {
                Path: A_ScriptDir "\Lib",
                Type: "Local",
                Priority: 1,
                Description: "Script-local libraries"
            },
            {
                Path: A_MyDocuments "\AutoHotkey\Lib",
                Type: "User",
                Priority: 2,
                Description: "User library folder"
            },
            {
                Path: A_ProgramFiles "\AutoHotkey\Lib",
                Type: "Standard",
                Priority: 3,
                Description: "Standard library folder"
            }
        ]
    }

    /**
     * Check library location status
     * @param {String} path - Library path
     * @returns {Object} Status information
     */
    static CheckLocation(path) {
        exists := DirExist(path)
        return {
            Path: path,
            Exists: exists ? true : false,
            Accessible: exists ? true : false,
            FileCount: exists ? this.CountFiles(path) : 0
        }
    }

    /**
     * Count files in directory
     * @param {String} path - Directory path
     * @returns {Integer} Number of .ahk files
     */
    static CountFiles(path) {
        count := 0
        Loop Files path "\*.ahk", "R"
            count++
        return count
    }

    /**
     * Display library structure information
     * @returns {void}
     */
    static ShowStructure() {
        output := "Standard Library Structure`n"
        output .= "==========================`n`n"

        for loc in this.GetStandardLocations() {
            status := this.CheckLocation(loc.Path)

            output .= loc.Type " Library:`n"
            output .= "  Path: " loc.Path "`n"
            output .= "  Priority: " loc.Priority "`n"
            output .= "  Exists: " (status.Exists ? "Yes" : "No") "`n"

            if (status.Exists)
                output .= "  Files: " status.FileCount " .ahk file(s)`n"

            output .= "  " loc.Description "`n`n"
        }

        MsgBox(output, "Library Structure", "Iconi")
    }

    /**
     * Create recommended directory structure
     * @param {String} basePath - Base directory path
     * @returns {Boolean} True if successful
     */
    static CreateStructure(basePath := "") {
        if (basePath = "")
            basePath := A_ScriptDir

        dirs := [
            "Lib",
            "Lib\Core",
            "Lib\Utils",
            "Lib\Vendor",
            "Lib\UI",
            "Config",
            "Data"
        ]

        created := []
        failed := []

        for dir in dirs {
            fullPath := basePath "\" dir
            try {
                if (!DirExist(fullPath)) {
                    DirCreate(fullPath)
                    created.Push(dir)
                }
            } catch Error as err {
                failed.Push(dir ": " err.Message)
            }
        }

        ; Show results
        output := "Structure Creation Results`n"
        output .= "==========================`n`n"

        if (created.Length > 0) {
            output .= "Created:`n"
            for dir in created
                output .= "  ✓ " dir "`n"
            output .= "`n"
        }

        if (failed.Length > 0) {
            output .= "Failed:`n"
            for err in failed
                output .= "  ✗ " err "`n"
        }

        if (created.Length = 0 && failed.Length = 0)
            output .= "All directories already exist."

        MsgBox(output, "Structure Creation", "Iconi")
        return failed.Length = 0
    }
}

^!1::LibraryStructure.ShowStructure()

/**
 * ============================================================================
 * Example 2: Module System Implementation
 * ============================================================================
 *
 * @description Implement a module system for organizing libraries
 * @concept Modules, namespaces, encapsulation
 */

/**
 * Module registry and loader
 * @class
 */
class ModuleSystem {
    static Modules := Map()
    static LoadOrder := []

    /**
     * Define a module
     * @param {String} name - Module name
     * @param {Array} dependencies - Required modules
     * @param {Func} factory - Module factory function
     * @returns {void}
     */
    static Define(name, dependencies, factory) {
        if (this.Modules.Has(name)) {
            throw Error("Module '" name "' already defined")
        }

        this.Modules[name] := {
            Name: name,
            Dependencies: dependencies,
            Factory: factory,
            Exports: unset,
            Loaded: false
        }

        OutputDebug("Defined module: " name)
    }

    /**
     * Require a module
     * @param {String} name - Module name
     * @returns {Any} Module exports
     */
    static Require(name) {
        if (!this.Modules.Has(name)) {
            throw Error("Module '" name "' not found")
        }

        module := this.Modules[name]

        ; Return cached exports if already loaded
        if (module.Loaded)
            return module.Exports

        ; Load dependencies first
        depExports := []
        for dep in module.Dependencies {
            depExports.Push(this.Require(dep))
        }

        ; Call factory function
        try {
            module.Exports := module.Factory.Call(depExports*)
            module.Loaded := true
            this.LoadOrder.Push(name)
            OutputDebug("Loaded module: " name)
        } catch Error as err {
            throw Error("Failed to load module '" name "': " err.Message)
        }

        return module.Exports
    }

    /**
     * Check if module is loaded
     * @param {String} name - Module name
     * @returns {Boolean} True if loaded
     */
    static IsLoaded(name) {
        return this.Modules.Has(name) && this.Modules[name].Loaded
    }

    /**
     * Get module dependency tree
     * @param {String} name - Module name
     * @param {Integer} depth - Current depth
     * @returns {String} Tree representation
     */
    static GetDependencyTree(name, depth := 0) {
        if (!this.Modules.Has(name))
            return ""

        indent := StrReplace(Format("{:" depth * 2 "s}", ""), " ", " ")
        module := this.Modules[name]
        tree := indent "• " name

        if (module.Loaded)
            tree .= " ✓"

        tree .= "`n"

        for dep in module.Dependencies {
            tree .= this.GetDependencyTree(dep, depth + 1)
        }

        return tree
    }

    /**
     * Display module information
     * @returns {void}
     */
    static ShowModules() {
        output := "Module System Status`n"
        output .= "====================`n`n"

        output .= "Registered Modules: " this.Modules.Count "`n"
        output .= "Loaded Modules: " this.LoadOrder.Length "`n`n"

        if (this.Modules.Count > 0) {
            output .= "Modules:`n"
            for name, module in this.Modules {
                status := module.Loaded ? "✓" : "○"
                output .= "  " status " " name
                if (module.Dependencies.Length > 0)
                    output .= " (depends on: " this.Join(module.Dependencies) ")"
                output .= "`n"
            }

            if (this.LoadOrder.Length > 0) {
                output .= "`nLoad Order:`n"
                for name in this.LoadOrder {
                    output .= "  " A_Index ". " name "`n"
                }
            }
        }

        MsgBox(output, "Modules", "Iconi")
    }

    /**
     * Join array elements
     * @private
     */
    static Join(arr, separator := ", ") {
        result := ""
        for item in arr {
            result .= (result = "" ? "" : separator) item
        }
        return result
    }
}

; Define example modules
ModuleSystem.Define("Core", [], (*) => {
    return {
        Version: "1.0.0",
        Name: "Core Module"
    }
})

ModuleSystem.Define("Utils", ["Core"], (core) => {
    return {
        Core: core,
        Uppercase: (str) => StrUpper(str),
        Lowercase: (str) => StrLower(str)
    }
})

ModuleSystem.Define("App", ["Core", "Utils"], (core, utils) => {
    return {
        Init: () => MsgBox("App initialized with " core.Name, "App", "Iconi")
    }
})

^!2::ModuleSystem.ShowModules()
^!+2::ModuleSystem.Require("App").Init()

/**
 * ============================================================================
 * Example 3: Library Manifest System
 * ============================================================================
 *
 * @description Create manifest files for library metadata
 * @concept Metadata, versioning, library information
 */

/**
 * Library manifest manager
 * @class
 */
class LibraryManifest {
    /**
     * Create a manifest object
     * @param {Object} config - Manifest configuration
     * @returns {Object} Manifest object
     */
    static Create(config) {
        return {
            Name: config.Name ?? "Unnamed Library",
            Version: config.Version ?? "0.0.0",
            Author: config.Author ?? "Unknown",
            Description: config.Description ?? "",
            Dependencies: config.Dependencies ?? [],
            Files: config.Files ?? [],
            License: config.License ?? "MIT",
            Repository: config.Repository ?? "",
            Created: A_Now,
            Updated: A_Now
        }
    }

    /**
     * Serialize manifest to text
     * @param {Object} manifest - Manifest object
     * @returns {String} Serialized manifest
     */
    static Serialize(manifest) {
        output := "; AutoHotkey Library Manifest`n"
        output .= "; Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

        output .= "[Library]`n"
        output .= "Name=" manifest.Name "`n"
        output .= "Version=" manifest.Version "`n"
        output .= "Author=" manifest.Author "`n"
        output .= "Description=" manifest.Description "`n"
        output .= "License=" manifest.License "`n"

        if (manifest.Repository != "")
            output .= "Repository=" manifest.Repository "`n"

        if (manifest.Dependencies.Length > 0) {
            output .= "`n[Dependencies]`n"
            for dep in manifest.Dependencies {
                output .= dep.Name "=" dep.Version "`n"
            }
        }

        if (manifest.Files.Length > 0) {
            output .= "`n[Files]`n"
            for file in manifest.Files {
                output .= file "`n"
            }
        }

        return output
    }

    /**
     * Parse manifest from text
     * @param {String} text - Manifest text
     * @returns {Object} Manifest object
     */
    static Parse(text) {
        manifest := this.Create({})
        currentSection := ""

        Loop Parse text, "`n", "`r" {
            line := Trim(A_LoopField)

            ; Skip comments and empty lines
            if (line = "" || SubStr(line, 1, 1) = ";")
                continue

            ; Section header
            if (SubStr(line, 1, 1) = "[" && SubStr(line, -1) = "]") {
                currentSection := SubStr(line, 2, -1)
                continue
            }

            ; Key=Value pairs
            if InStr(line, "=") {
                eqPos := InStr(line, "=")
                key := Trim(SubStr(line, 1, eqPos - 1))
                value := Trim(SubStr(line, eqPos + 1))

                if (currentSection = "Library") {
                    manifest.%key% := value
                } else if (currentSection = "Dependencies") {
                    if (!IsObject(manifest.Dependencies))
                        manifest.Dependencies := []
                    manifest.Dependencies.Push({Name: key, Version: value})
                }
            } else if (currentSection = "Files") {
                if (!IsObject(manifest.Files))
                    manifest.Files := []
                manifest.Files.Push(line)
            }
        }

        return manifest
    }

    /**
     * Display manifest
     * @param {Object} manifest - Manifest to display
     * @returns {void}
     */
    static Display(manifest) {
        output := "Library Manifest`n"
        output .= "================`n`n"

        output .= "Name: " manifest.Name "`n"
        output .= "Version: " manifest.Version "`n"
        output .= "Author: " manifest.Author "`n"
        output .= "License: " manifest.License "`n`n"

        if (manifest.Description != "")
            output .= "Description:`n" manifest.Description "`n`n"

        if (manifest.Dependencies.Length > 0) {
            output .= "Dependencies:`n"
            for dep in manifest.Dependencies {
                output .= "  • " dep.Name " v" dep.Version "`n"
            }
            output .= "`n"
        }

        if (manifest.Files.Length > 0) {
            output .= "Files: " manifest.Files.Length "`n"
        }

        MsgBox(output, "Manifest", "Iconi")
    }
}

; Create example manifest
ExampleManifest := LibraryManifest.Create({
    Name: "MyUtilityLibrary",
    Version: "1.2.0",
    Author: "AHK Developer",
    Description: "Collection of utility functions",
    License: "MIT",
    Dependencies: [
        {Name: "StringUtils", Version: "1.0.0"},
        {Name: "FileUtils", Version: "2.1.0"}
    ],
    Files: ["Utils.ahk", "Helpers.ahk"]
})

^!3::LibraryManifest.Display(ExampleManifest)

/**
 * ============================================================================
 * Example 4: Auto-Loading Library System
 * ============================================================================
 *
 * @description Automatically discover and load libraries
 * @concept Auto-loading, discovery, lazy loading
 */

/**
 * Auto-loading library manager
 * @class
 */
class AutoLoader {
    static SearchPaths := []
    static LoadedLibraries := Map()
    static AutoLoadEnabled := true

    /**
     * Initialize auto-loader
     * @returns {void}
     */
    static Initialize() {
        this.SearchPaths := [
            A_ScriptDir "\Lib",
            A_ScriptDir "\Lib\Core",
            A_ScriptDir "\Lib\Utils"
        ]

        this.DiscoverLibraries()
    }

    /**
     * Discover available libraries
     * @returns {Array} List of discovered libraries
     */
    static DiscoverLibraries() {
        discovered := []

        for path in this.SearchPaths {
            if (!DirExist(path))
                continue

            Loop Files path "\*.ahk" {
                libInfo := {
                    Name: A_LoopFileName,
                    Path: A_LoopFileFullPath,
                    Size: A_LoopFileSize,
                    Modified: A_LoopFileTimeModified
                }
                discovered.Push(libInfo)
            }
        }

        return discovered
    }

    /**
     * Auto-load library on first access
     * @param {String} className - Class name to load
     * @returns {Boolean} True if loaded
     */
    static TryAutoLoad(className) {
        if (!this.AutoLoadEnabled)
            return false

        ; Check if already loaded
        if (this.LoadedLibraries.Has(className))
            return true

        ; Search for matching file
        fileName := className ".ahk"

        for path in this.SearchPaths {
            fullPath := path "\" fileName
            if (FileExist(fullPath)) {
                try {
                    ; In practice, would include the file
                    ; For demo, just register it
                    this.LoadedLibraries[className] := {
                        Path: fullPath,
                        LoadedAt: A_Now
                    }

                    OutputDebug("Auto-loaded: " className " from " fullPath)
                    return true
                }
            }
        }

        return false
    }

    /**
     * Display auto-loader status
     * @returns {void}
     */
    static ShowStatus() {
        discovered := this.DiscoverLibraries()

        output := "Auto-Loader Status`n"
        output .= "==================`n`n"

        output .= "Enabled: " (this.AutoLoadEnabled ? "Yes" : "No") "`n"
        output .= "Search Paths: " this.SearchPaths.Length "`n"
        output .= "Discovered Libraries: " discovered.Length "`n"
        output .= "Loaded Libraries: " this.LoadedLibraries.Count "`n`n"

        if (discovered.Length > 0) {
            output .= "Available Libraries:`n"
            for lib in discovered {
                status := this.LoadedLibraries.Has(lib.Name) ? "✓" : "○"
                output .= "  " status " " lib.Name "`n"
            }
        }

        MsgBox(output, "Auto-Loader", "Iconi")
    }
}

AutoLoader.Initialize()

^!4::AutoLoader.ShowStatus()

/**
 * ============================================================================
 * Example 5: Library Categorization System
 * ============================================================================
 *
 * @description Organize libraries by category and function
 * @concept Categorization, organization, taxonomy
 */

/**
 * Library catalog manager
 * @class
 */
class LibraryCatalog {
    static Categories := Map()
    static Libraries := Map()

    /**
     * Initialize catalog with default categories
     * @returns {void}
     */
    static Initialize() {
        this.Categories := Map(
            "Core", "Core functionality and base classes",
            "Utils", "Utility functions and helpers",
            "UI", "User interface components",
            "Data", "Data structures and manipulation",
            "IO", "Input/output and file operations",
            "Network", "Network and web-related functionality",
            "System", "System integration and Windows API",
            "Vendor", "Third-party libraries"
        )
    }

    /**
     * Register a library
     * @param {String} name - Library name
     * @param {String} category - Category name
     * @param {Object} metadata - Library metadata
     * @returns {void}
     */
    static Register(name, category, metadata := unset) {
        if (!this.Categories.Has(category)) {
            throw Error("Unknown category: " category)
        }

        libInfo := {
            Name: name,
            Category: category,
            Description: IsSet(metadata) && metadata.HasOwnProp("Description")
                ? metadata.Description : "",
            Version: IsSet(metadata) && metadata.HasOwnProp("Version")
                ? metadata.Version : "0.0.0",
            Tags: IsSet(metadata) && metadata.HasOwnProp("Tags")
                ? metadata.Tags : []
        }

        this.Libraries[name] := libInfo
        OutputDebug("Registered library: " name " (" category ")")
    }

    /**
     * Get libraries by category
     * @param {String} category - Category name
     * @returns {Array} List of libraries
     */
    static GetByCategory(category) {
        results := []
        for name, lib in this.Libraries {
            if (lib.Category = category)
                results.Push(lib)
        }
        return results
    }

    /**
     * Search libraries
     * @param {String} query - Search query
     * @returns {Array} Matching libraries
     */
    static Search(query) {
        query := StrLower(query)
        results := []

        for name, lib in this.Libraries {
            if (InStr(StrLower(lib.Name), query)
                || InStr(StrLower(lib.Description), query)) {
                results.Push(lib)
            }
        }

        return results
    }

    /**
     * Display catalog
     * @returns {void}
     */
    static ShowCatalog() {
        output := "Library Catalog`n"
        output .= "===============`n`n"

        output .= "Categories: " this.Categories.Count "`n"
        output .= "Libraries: " this.Libraries.Count "`n`n"

        for category, description in this.Categories {
            libs := this.GetByCategory(category)
            output .= "📁 " category " (" libs.Length ")`n"

            if (libs.Length > 0) {
                for lib in libs {
                    output .= "  • " lib.Name " v" lib.Version "`n"
                }
            }
            output .= "`n"
        }

        MsgBox(output, "Catalog", "Iconi")
    }
}

LibraryCatalog.Initialize()

; Register example libraries
LibraryCatalog.Register("StringUtils", "Utils", {
    Description: "String manipulation functions",
    Version: "1.0.0"
})

LibraryCatalog.Register("FileHelper", "IO", {
    Description: "File operations helper",
    Version: "2.1.0"
})

LibraryCatalog.Register("WindowManager", "UI", {
    Description: "Window management utilities",
    Version: "1.5.0"
})

^!5::LibraryCatalog.ShowCatalog()

/**
 * ============================================================================
 * Example 6: Library Version Compatibility Checker
 * ============================================================================
 *
 * @description Check library compatibility and version requirements
 * @concept Version checking, compatibility, dependency resolution
 */

/**
 * Compatibility checker for library versions
 * @class
 */
class CompatibilityChecker {
    /**
     * Check if version satisfies requirement
     * @param {String} version - Installed version
     * @param {String} requirement - Required version constraint
     * @returns {Boolean} True if compatible
     */
    static CheckVersion(version, requirement) {
        ; Parse requirement (supports ^, ~, >=, <=, =, >, <)
        if (SubStr(requirement, 1, 1) = "^")
            return this.CheckCaret(version, SubStr(requirement, 2))
        else if (SubStr(requirement, 1, 1) = "~")
            return this.CheckTilde(version, SubStr(requirement, 2))
        else if (SubStr(requirement, 1, 2) = ">=")
            return this.CompareVersions(version, SubStr(requirement, 3)) >= 0
        else if (SubStr(requirement, 1, 2) = "<=")
            return this.CompareVersions(version, SubStr(requirement, 3)) <= 0
        else if (SubStr(requirement, 1, 1) = ">")
            return this.CompareVersions(version, SubStr(requirement, 2)) > 0
        else if (SubStr(requirement, 1, 1) = "<")
            return this.CompareVersions(version, SubStr(requirement, 2)) < 0
        else
            return this.CompareVersions(version, requirement) = 0
    }

    /**
     * Check caret range (^1.2.3 = >=1.2.3 <2.0.0)
     * @param {String} version - Version to check
     * @param {String} base - Base version
     * @returns {Boolean} True if in range
     */
    static CheckCaret(version, base) {
        verParts := this.ParseVersion(version)
        baseParts := this.ParseVersion(base)

        ; Must match major version
        if (verParts.Major != baseParts.Major)
            return false

        return this.CompareVersions(version, base) >= 0
    }

    /**
     * Check tilde range (~1.2.3 = >=1.2.3 <1.3.0)
     * @param {String} version - Version to check
     * @param {String} base - Base version
     * @returns {Boolean} True if in range
     */
    static CheckTilde(version, base) {
        verParts := this.ParseVersion(version)
        baseParts := this.ParseVersion(base)

        ; Must match major and minor
        if (verParts.Major != baseParts.Major
            || verParts.Minor != baseParts.Minor)
            return false

        return this.CompareVersions(version, base) >= 0
    }

    /**
     * Compare version strings
     * @param {String} v1 - First version
     * @param {String} v2 - Second version
     * @returns {Integer} -1, 0, or 1
     */
    static CompareVersions(v1, v2) {
        p1 := this.ParseVersion(v1)
        p2 := this.ParseVersion(v2)

        if (p1.Major != p2.Major)
            return (p1.Major > p2.Major) ? 1 : -1
        if (p1.Minor != p2.Minor)
            return (p1.Minor > p2.Minor) ? 1 : -1
        if (p1.Patch != p2.Patch)
            return (p1.Patch > p2.Patch) ? 1 : -1

        return 0
    }

    /**
     * Parse version string
     * @param {String} version - Version string
     * @returns {Object} Parsed version
     */
    static ParseVersion(version) {
        parts := StrSplit(version, ".")
        return {
            Major: Integer(parts[1] ?? 0),
            Minor: Integer(parts[2] ?? 0),
            Patch: Integer(parts[3] ?? 0)
        }
    }

    /**
     * Test version compatibility
     * @returns {void}
     */
    static TestCompatibility() {
        tests := [
            {version: "1.2.3", requirement: "^1.2.0", expected: true},
            {version: "1.2.3", requirement: "~1.2.0", expected: true},
            {version: "2.0.0", requirement: "^1.2.0", expected: false},
            {version: "1.3.0", requirement: "~1.2.0", expected: false},
            {version: "1.5.0", requirement: ">=1.2.0", expected: true}
        ]

        output := "Version Compatibility Tests`n"
        output .= "===========================`n`n"

        for test in tests {
            result := this.CheckVersion(test.version, test.requirement)
            status := (result = test.expected) ? "✓" : "✗"

            output .= status " " test.version " " test.requirement
            output .= " → " (result ? "Compatible" : "Incompatible") "`n"
        }

        MsgBox(output, "Compatibility Tests", "Iconi")
    }
}

^!6::CompatibilityChecker.TestCompatibility()

/**
 * ============================================================================
 * Example 7: Library Documentation Generator
 * ============================================================================
 *
 * @description Generate documentation for library structures
 * @concept Documentation, metadata extraction, code analysis
 */

/**
 * Library documentation generator
 * @class
 */
class LibraryDocGenerator {
    /**
     * Generate documentation for a library
     * @param {Object} library - Library information
     * @returns {String} Documentation text
     */
    static Generate(library) {
        doc := "# " library.Name "`n`n"

        if (library.HasOwnProp("Version"))
            doc .= "**Version:** " library.Version "`n"

        if (library.HasOwnProp("Author"))
            doc .= "**Author:** " library.Author "`n"

        if (library.HasOwnProp("License"))
            doc .= "**License:** " library.License "`n"

        doc .= "`n"

        if (library.HasOwnProp("Description"))
            doc .= "## Description`n`n" library.Description "`n`n"

        if (library.HasOwnProp("Dependencies")
            && library.Dependencies.Length > 0) {
            doc .= "## Dependencies`n`n"
            for dep in library.Dependencies {
                doc .= "- " dep.Name " (v" dep.Version ")`n"
            }
            doc .= "`n"
        }

        if (library.HasOwnProp("Installation"))
            doc .= "## Installation`n`n" library.Installation "`n`n"

        if (library.HasOwnProp("Usage"))
            doc .= "## Usage`n`n" library.Usage "`n`n"

        return doc
    }

    /**
     * Display generated documentation
     * @param {Object} library - Library to document
     * @returns {void}
     */
    static ShowDocumentation(library) {
        doc := this.Generate(library)
        MsgBox(doc, "Library Documentation", "Iconi")
    }
}

; Example library for documentation
ExampleLibDoc := {
    Name: "AdvancedStringUtils",
    Version: "2.0.0",
    Author: "AHK Developer",
    License: "MIT",
    Description: "Advanced string manipulation utilities for AutoHotkey v2.",
    Dependencies: [
        {Name: "CoreUtils", Version: "1.0.0"}
    ],
    Installation: "#Include <AdvancedStringUtils>",
    Usage: "str := StringUtils.Reverse('hello')"
}

^!7::LibraryDocGenerator.ShowDocumentation(ExampleLibDoc)

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

TrayTip("Library structure system loaded", "Script Ready", "Iconi Mute")

/**
 * Help hotkey
 */
^!h::{
    help := "Library Structure Examples`n"
    help .= "==========================`n`n"
    help .= "^!1 - Library Structure Info`n"
    help .= "^!2 - Module System Status`n"
    help .= "^!+2 - Load App Module`n"
    help .= "^!3 - Show Manifest`n"
    help .= "^!4 - Auto-Loader Status`n"
    help .= "^!5 - Library Catalog`n"
    help .= "^!6 - Compatibility Tests`n"
    help .= "^!7 - Library Documentation`n"
    help .= "^!h - Show Help`n"

    MsgBox(help, "Help", "Iconi")
}
