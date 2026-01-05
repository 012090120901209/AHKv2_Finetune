#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * ============================================================================
 * AutoHotkey v2 #Include Directive - Library Management
 * ============================================================================
 * 
 * @description Comprehensive examples demonstrating #Include for library
 *              management and code organization in AutoHotkey v2
 * 
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 * 
 * DIRECTIVE: #Include
 * PURPOSE: Include external script files and libraries
 * SYNTAX: #Include <LibName>
 *         #Include LibName.ahk
 *         #Include %A_ScriptDir%\Lib\MyLib.ahk
 *         #Include *i Optional.ahk
 * 
 * @reference https://www.autohotkey.com/docs/v2/lib/_Include.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Basic Library Inclusion
 * ============================================================================
 * 
 * @description Demonstrate basic #Include usage for external libraries
 * @concept Library inclusion, code organization, modularity
 */

/**
 * Simulated library inclusion (would normally be in separate file)
 * In practice: #Include MyUtilities.ahk
 */

/**
 * String utility library
 * @namespace StringUtils
 */
class StringUtils {
    /**
     * Reverse a string
     * @param {String} str - Input string
     * @returns {String} Reversed string
     */
    static Reverse(str) {
        result := ""
        Loop Parse str
            result := A_LoopField result
        return result
    }

    /**
     * Count occurrences of substring
     * @param {String} str - String to search
     * @param {String} substr - Substring to count
     * @returns {Integer} Number of occurrences
     */
    static CountOccurrences(str, substr) {
        count := 0
        pos := 1
        while (pos := InStr(str, substr, , pos)) {
            count++
            pos += StrLen(substr)
        }
        return count
    }

    /**
     * Truncate string with ellipsis
     * @param {String} str - String to truncate
     * @param {Integer} maxLen - Maximum length
     * @returns {String} Truncated string
     */
    static Truncate(str, maxLen := 50) {
        if (StrLen(str) <= maxLen)
            return str
        return SubStr(str, 1, maxLen - 3) "..."
    }

    /**
     * Convert to title case
     * @param {String} str - Input string
     * @returns {String} Title cased string
     */
    static ToTitleCase(str) {
        result := ""
        wordStart := true

        Loop Parse str {
            char := A_LoopField
            if (char = " " || char = "`t" || char = "`n") {
                wordStart := true
                result .= char
            } else {
                result .= wordStart ? StrUpper(char) : StrLower(char)
                wordStart := false
            }
        }

        return result
    }
}

/**
 * Test string utilities
 */
^!1:: {
    str := "Hello World AutoHotkey"

    output := "String Utilities Demo`n"
    output .= "=====================`n`n"
    output .= "Original: " str "`n"
    output .= "Reversed: " StringUtils.Reverse(str) "`n"
    output .= "Count 'o': " StringUtils.CountOccurrences(str, "o") "`n"
    output .= "Truncate(15): " StringUtils.Truncate(str, 15) "`n"
    output .= "Title Case: " StringUtils.ToTitleCase("hello world autohotkey") "`n"

    MsgBox(output, "StringUtils", "Iconi")
}

/**
 * ============================================================================
 * Example 2: Standard Library Inclusion
 * ============================================================================
 * 
 * @description Use angle brackets for standard library includes
 * @concept Standard library, built-in modules
 */

/**
 * Example: #Include ../JSON.ahk
 * Would include JSON.ahk from standard library locations
 */

/**
 * Simulated JSON library (simplified version)
 * @namespace JSON
 */
class JSON {
    /**
     * Parse JSON string
     * @param {String} jsonStr - JSON string
     * @returns {Object|Array} Parsed object
     */
    static Parse(jsonStr) {
        ; Simplified JSON parsing for demonstration
        ; In practice, use a full JSON library
        return Map()
    }

    /**
     * Stringify object to JSON
     * @param {Object} obj - Object to stringify
     * @param {Integer} indent - Indentation spaces
     * @returns {String} JSON string
     */
    static Stringify(obj, indent := 2) {
        return this._StringifyValue(obj, 0, indent)
    }

    /**
     * Internal stringify helper
     * @private
     */
    static _StringifyValue(value, depth, indent) {
        if (Type(value) = "String")
            return '"' this._EscapeString(value) '"'
        else if (Type(value) = "Integer" || Type(value) = "Float")
            return String(value)
        else if (Type(value) = "Map")
            return this._StringifyMap(value, depth, indent)
        else if (Type(value) = "Array")
            return this._StringifyArray(value, depth, indent)
        else
            return "null"
    }

    /**
     * Stringify Map object
     * @private
     */
    static _StringifyMap(map, depth, indent) {
        if (map.Count = 0)
            return "{}"

        result := "{"
        indentStr := this._GetIndent(depth + 1, indent)
        first := true

        for key, value in map {
            if (!first)
                result .= ","
            result .= "`n" indentStr '"' key '": '
            result .= this._StringifyValue(value, depth + 1, indent)
            first := false
        }

        result .= "`n" this._GetIndent(depth, indent) "}"
        return result
    }

    /**
     * Stringify Array object
     * @private
     */
    static _StringifyArray(arr, depth, indent) {
        if (arr.Length = 0)
            return "[]"

        result := "["
        indentStr := this._GetIndent(depth + 1, indent)

        for index, value in arr {
            if (index > 1)
                result .= ","
            result .= "`n" indentStr
            result .= this._StringifyValue(value, depth + 1, indent)
        }

        result .= "`n" this._GetIndent(depth, indent) "]"
        return result
    }

    /**
     * Escape string for JSON
     * @private
     */
    static _EscapeString(str) {
        str := StrReplace(str, "\", "\\")
        str := StrReplace(str, '"', '\"')
        str := StrReplace(str, "`n", "\n")
        str := StrReplace(str, "`r", "\r")
        str := StrReplace(str, "`t", "\t")
        return str
    }

    /**
     * Get indentation string
     * @private
     */
    static _GetIndent(depth, spaces) {
        return StrReplace(Format("{:" depth * spaces "s}", ""), " ", " ")
    }
}

/**
 * Test JSON library
 */
^!2:: {
    ; Create sample data
    data := Map(
        "name", "AutoHotkey",
        "version", "2.0",
        "features", ["hotkeys", "automation", "GUI"]
    )

    ; Convert to JSON
    jsonStr := JSON.Stringify(data)

    MsgBox(jsonStr, "JSON Output", "Iconi")
}

/**
 * ============================================================================
 * Example 3: Conditional Include with Error Handling
 * ============================================================================
 * 
 * @description Include files conditionally with *i flag
 * @concept Optional includes, error handling
 */

/**
 * Include manager for conditional loading
 * @class
 */
class IncludeManager {
    static LoadedModules := Map()
    static FailedModules := []

    /**
     * Try to include a module
     * @param {String} moduleName - Module identifier
     * @param {Func} loader - Function to call if available
     * @returns {Boolean} True if loaded successfully
     */
    static TryInclude(moduleName, loader := "") {
        try {
            if (loader != "" && HasMethod(loader, "Call"))
                loader.Call()

            this.LoadedModules[moduleName] := true
            OutputDebug("✓ Loaded module: " moduleName)
            return true
        } catch Error as err {
            this.FailedModules.Push(moduleName)
            OutputDebug("✗ Failed to load module: " moduleName " - " err.Message)
            return false
        }
    }

    /**
     * Check if module is loaded
     * @param {String} moduleName - Module identifier
     * @returns {Boolean} True if loaded
     */
    static IsLoaded(moduleName) {
        return this.LoadedModules.Get(moduleName, false)
    }

    /**
     * Get load report
     * @returns {String} Report of loaded/failed modules
     */
    static GetLoadReport() {
        report := "Module Load Report`n"
        report .= "==================`n`n"

        report .= "Loaded Modules (" this.LoadedModules.Count "):`n"
        for module, status in this.LoadedModules {
            report .= "  ✓ " module "`n"
        }

        if (this.FailedModules.Length > 0) {
            report .= "`nFailed Modules (" this.FailedModules.Length "):`n"
            for module in this.FailedModules {
                report .= "  ✗ " module "`n"
            }
        }

        return report
    }
}

; Load optional modules
IncludeManager.TryInclude("StringUtils", () => StringUtils.Reverse("test"))
IncludeManager.TryInclude("JSON", () => JSON.Stringify(Map()))

^!3:: MsgBox(IncludeManager.GetLoadReport(), "Modules", "Iconi")

/**
 * ============================================================================
 * Example 4: Library Version Management
 * ============================================================================
 * 
 * @description Manage library versions and compatibility
 * @concept Version checking, library compatibility
 */

/**
 * Library version manager
 * @class
 */
class LibraryVersionManager {
    /**
     * Registered libraries with versions
     */
    static Libraries := Map()

    /**
     * Register a library
     * @param {String} name - Library name
     * @param {String} version - Library version
     * @param {Object} api - Library API object
     * @returns {void}
     */
    static Register(name, version, api) {
        this.Libraries[name] := {
            Version: version,
            API: api,
            LoadedAt: A_Now
        }
        OutputDebug("Registered library: " name " v" version)
    }

    /**
     * Get library API
     * @param {String} name - Library name
     * @param {String} minVersion - Minimum required version
     * @returns {Object|false} Library API or false
     */
    static GetLibrary(name, minVersion := "") {
        if (!this.Libraries.Has(name))
            return false

        lib := this.Libraries[name]

        if (minVersion != "" && !this.CheckVersion(lib.Version, minVersion)) {
            MsgBox(
                "Library " name " version " lib.Version " is older than required " minVersion,
                "Version Error",
                "Icon!"
            )
            return false
        }

        return lib.API
    }

    /**
     * Check version compatibility
     * @param {String} current - Current version
     * @param {String} required - Required version
     * @returns {Boolean} True if compatible
     */
    static CheckVersion(current, required) {
        ParseVersion(ver) {
            parts := StrSplit(ver, ".")
            return {
                major: Integer(parts[1] ?? 0),
                minor: Integer(parts[2] ?? 0),
                patch: Integer(parts[3] ?? 0)
            }
        }

        cur := ParseVersion(current)
        req := ParseVersion(required)

        if (cur.major != req.major)
            return cur.major > req.major
        if (cur.minor != req.minor)
            return cur.minor > req.minor
        return cur.patch >= req.patch
    }

    /**
     * Display library registry
     * @returns {void}
     */
    static ShowRegistry() {
        if (this.Libraries.Count = 0) {
            MsgBox("No libraries registered", "Library Registry", "Iconi")
            return
        }

        report := "Registered Libraries`n"
        report .= "====================`n`n"

        for name, lib in this.Libraries {
            report .= name " v" lib.Version "`n"
            report .= "  Loaded: " FormatTime(lib.LoadedAt, "yyyy-MM-dd HH:mm:ss") "`n`n"
        }

        MsgBox(report, "Library Registry", "Iconi")
    }
}

; Register libraries
LibraryVersionManager.Register("StringUtils", "1.0.0", StringUtils)
LibraryVersionManager.Register("JSON", "2.1.0", JSON)

^!4:: LibraryVersionManager.ShowRegistry()

/**
 * ============================================================================
 * Example 5: Dynamic Library Loading
 * ============================================================================
 * 
 * @description Load libraries dynamically at runtime
 * @concept Dynamic loading, runtime includes
 */

/**
 * Dynamic library loader
 * @class
 */
class DynamicLoader {
    static LibraryPaths := []
    static Cache := Map()

    /**
     * Add library search path
     * @param {String} path - Path to add
     * @returns {void}
     */
    static AddPath(path) {
        if (!this.LibraryPaths.Includes(path))
            this.LibraryPaths.Push(path)
    }

    /**
     * Search for library file
     * @param {String} libName - Library name
     * @returns {String|false} Full path or false
     */
    static FindLibrary(libName) {
        ; Ensure .ahk extension
        if (!InStr(libName, ".ahk"))
            libName .= ".ahk"

        ; Check script directory
        scriptLib := A_ScriptDir "\Lib\" libName
        if FileExist(scriptLib)
            return scriptLib

        ; Check additional paths
        for path in this.LibraryPaths {
            fullPath := path "\" libName
            if FileExist(fullPath)
                return fullPath
        }

        ; Check standard library locations
        stdLib := A_MyDocuments "\AutoHotkey\Lib\" libName
        if FileExist(stdLib)
            return stdLib

        return false
    }

    /**
     * Load library dynamically
     * @param {String} libName - Library name
     * @returns {Boolean} True if loaded
     */
    static Load(libName) {
        ; Check cache
        if (this.Cache.Has(libName))
            return true

        ; Find library file
        libPath := this.FindLibrary(libName)
        if (!libPath) {
            OutputDebug("Library not found: " libName)
            return false
        }

        try {
            ; In v2, we can't truly include at runtime
            ; This demonstrates the concept
            this.Cache[libName] := {
                Path: libPath,
                LoadedAt: A_Now
            }

            OutputDebug("Loaded library: " libName " from " libPath)
            return true
        } catch Error as err {
            OutputDebug("Failed to load " libName ": " err.Message)
            return false
        }
    }

    /**
     * Get loaded libraries
     * @returns {Array} List of loaded library names
     */
    static GetLoadedLibraries() {
        loaded := []
        for libName, info in this.Cache {
            loaded.Push(libName)
        }
        return loaded
    }

    /**
     * Display loader information
     * @returns {void}
     */
    static ShowInfo() {
        info := "Dynamic Library Loader`n"
        info .= "======================`n`n"

        info .= "Search Paths:`n"
        info .= "  • " A_ScriptDir "\Lib`n"
        for path in this.LibraryPaths {
            info .= "  • " path "`n"
        }
        info .= "  • " A_MyDocuments "\AutoHotkey\Lib`n`n"

        info .= "Loaded Libraries:`n"
        if (this.Cache.Count = 0) {
            info .= "  (none)`n"
        } else {
            for libName, lib in this.Cache {
                info .= "  • " libName "`n"
                info .= "    Path: " lib.Path "`n"
            }
        }

        MsgBox(info, "Library Loader", "Iconi")
    }
}

; Add custom library paths
DynamicLoader.AddPath(A_ScriptDir "\CustomLibs")

; Attempt to load some libraries
DynamicLoader.Load("MyCustomLib")
DynamicLoader.Load("HelperFunctions")

^!5:: DynamicLoader.ShowInfo()

/**
 * ============================================================================
 * Example 6: Namespace Management with Includes
 * ============================================================================
 * 
 * @description Organize included libraries with namespaces
 * @concept Namespaces, organization, conflict prevention
 */

/**
 * Namespace registry for library organization
 * @class
 */
class NamespaceRegistry {
    static Namespaces := Map()

    /**
     * Register a namespace
     * @param {String} namespace - Namespace name
     * @param {Object} api - Namespace API
     * @returns {void}
     */
    static Register(namespace, api) {
        this.Namespaces[namespace] := api
        OutputDebug("Registered namespace: " namespace)
    }

    /**
     * Get namespace API
     * @param {String} namespace - Namespace name
     * @returns {Object|false} API object or false
     */
    static Get(namespace) {
        return this.Namespaces.Get(namespace, false)
    }

    /**
     * Check if namespace exists
     * @param {String} namespace - Namespace name
     * @returns {Boolean} True if exists
     */
    static Has(namespace) {
        return this.Namespaces.Has(namespace)
    }

    /**
     * List all namespaces
     * @returns {Array} List of namespace names
     */
    static List() {
        namespaces := []
        for ns, api in this.Namespaces {
            namespaces.Push(ns)
        }
        return namespaces
    }

    /**
     * Display namespace tree
     * @returns {void}
     */
    static ShowTree() {
        tree := "Namespace Registry`n"
        tree .= "==================`n`n"

        if (this.Namespaces.Count = 0) {
            tree .= "(no namespaces registered)`n"
        } else {
            for ns, api in this.Namespaces {
                tree .= "📦 " ns "`n"

                ; List methods if it's a class
                if (Type(api) = "Class") {
                    tree .= "  └─ Methods: "
                    try {
                        methods := []
                        ; This is conceptual - actual method enumeration
                        ; would require different approach
                        tree .= "(class object)`n"
                    }
                }
            }
        }

        MsgBox(tree, "Namespaces", "Iconi")
    }
}

; Register namespaces
NamespaceRegistry.Register("Utils.String", StringUtils)
NamespaceRegistry.Register("Data.JSON", JSON)
NamespaceRegistry.Register("Include.Manager", IncludeManager)

^!6:: NamespaceRegistry.ShowTree()

/**
 * ============================================================================
 * Example 7: Include Guards and Circular Dependency Prevention
 * ============================================================================
 * 
 * @description Prevent circular dependencies and duplicate includes
 * @concept Include guards, dependency management
 */

/**
 * Include guard manager
 * @class
 */
class IncludeGuard {
    static Included := Map()
    static Including := []

    /**
     * Begin include operation
     * @param {String} fileName - File being included
     * @returns {Boolean} True if should proceed
     */
    static BeginInclude(fileName) {
        ; Already included
        if (this.Included.Has(fileName))
            return false

        ; Circular dependency check
        if (this.Including.Includes(fileName)) {
            this.ShowCircularDependencyError(fileName)
            return false
        }

        this.Including.Push(fileName)
        return true
    }

    /**
     * End include operation
     * @param {String} fileName - File being included
     * @returns {void}
     */
    static EndInclude(fileName) {
        this.Included[fileName] := A_Now

        ; Remove from including stack
        for index, file in this.Including {
            if (file = fileName) {
                this.Including.RemoveAt(index)
                break
            }
        }
    }

    /**
     * Check if file is included
     * @param {String} fileName - File to check
     * @returns {Boolean} True if included
     */
    static IsIncluded(fileName) {
        return this.Included.Has(fileName)
    }

    /**
     * Show circular dependency error
     * @param {String} fileName - File causing circular dependency
     * @returns {void}
     */
    static ShowCircularDependencyError(fileName) {
        chain := ""
        for file in this.Including {
            chain .= file " → "
        }
        chain .= fileName

        msg := "Circular Dependency Detected`n"
        msg .= "===========================`n`n"
        msg .= "Include chain:`n" chain "`n`n"
        msg .= "This would create a circular dependency.`n"
        msg .= "Please restructure your includes."

        MsgBox(msg, "Include Error", "Icon! 48")
    }

    /**
     * Display include tree
     * @returns {void}
     */
    static ShowIncludeTree() {
        tree := "Include Tree`n"
        tree .= "============`n`n"

        if (this.Included.Count = 0) {
            tree .= "(no files included)`n"
        } else {
            tree .= "Included Files:`n"
            for file, time in this.Included {
                tree .= "  • " file "`n"
                tree .= "    at " FormatTime(time, "HH:mm:ss") "`n"
            }
        }

        if (this.Including.Length > 0) {
            tree .= "`nCurrently Including:`n"
            for file in this.Including {
                tree .= "  ⏳ " file "`n"
            }
        }

        MsgBox(tree, "Include Tree", "Iconi")
    }
}

; Simulate include operations
IncludeGuard.BeginInclude("StringUtils.ahk")
IncludeGuard.EndInclude("StringUtils.ahk")
IncludeGuard.BeginInclude("JSON.ahk")
IncludeGuard.EndInclude("JSON.ahk")

^!7:: IncludeGuard.ShowIncludeTree()

/**
 * ============================================================================
 * HELPER FUNCTIONS
 * ============================================================================
 */

/**
 * Check if array includes value
 * @param {Array} arr - Array to search
 * @param {Any} value - Value to find
 * @returns {Boolean} True if found
 */
Array.Prototype.Includes := (this, value) => {
    for item in this {
        if (item = value)
        return true
    }
    return false
}

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

TrayTip("Library includes loaded", "Script Ready", "Iconi Mute")

/**
 * Help hotkey
 */
^!h:: {
    help := "Library Management Examples`n"
    help .= "===========================`n`n"
    help .= "^!1 - StringUtils Demo`n"
    help .= "^!2 - JSON Demo`n"
    help .= "^!3 - Module Load Report`n"
    help .= "^!4 - Library Registry`n"
    help .= "^!5 - Dynamic Loader Info`n"
    help .= "^!6 - Namespace Tree`n"
    help .= "^!7 - Include Tree`n"
    help .= "^!h - Show Help`n"

    MsgBox(help, "Help", "Iconi")
}
