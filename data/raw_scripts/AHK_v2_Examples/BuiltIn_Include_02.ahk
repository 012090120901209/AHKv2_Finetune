/**
 * ============================================================================
 * AutoHotkey v2 #Include Directive - Relative Paths
 * ============================================================================
 *
 * @description Comprehensive examples demonstrating relative path handling
 *              and file resolution in AutoHotkey v2 #Include directives
 *
 * @author AHK v2 Documentation Team
 * @version 2.0.0
 * @date 2025-01-15
 *
 * DIRECTIVE: #Include
 * PURPOSE: Include files using relative and absolute paths
 * SYNTAX: #Include RelativePath\File.ahk
 *         #Include ..\ParentDir\File.ahk
 *         #Include .\CurrentDir\File.ahk
 *
 * PATH RESOLUTION:
 *   - Relative to script directory by default
 *   - Can use .. for parent directory
 *   - Can use . for current directory
 *   - %A_ScriptDir% for absolute paths
 *
 * @reference https://www.autohotkey.com/docs/v2/lib/_Include.htm
 */

#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Example 1: Path Resolution Utilities
 * ============================================================================
 *
 * @description Utilities for resolving and normalizing file paths
 * @concept Path normalization, path resolution, file system navigation
 */

/**
 * Path utility class
 * @class
 */
class PathUtils {
    /**
     * Normalize path separators
     * @param {String} path - Input path
     * @returns {String} Normalized path
     */
    static Normalize(path) {
        ; Convert forward slashes to backslashes
        path := StrReplace(path, "/", "\")

        ; Remove duplicate slashes
        while InStr(path, "\\")
            path := StrReplace(path, "\\", "\")

        ; Remove trailing slash
        if (SubStr(path, -1) = "\")
            path := SubStr(path, 1, -1)

        return path
    }

    /**
     * Join path components
     * @param {String} parts* - Path parts to join
     * @returns {String} Joined path
     */
    static Join(parts*) {
        result := ""
        for part in parts {
            if (result = "")
                result := part
            else
                result .= "\" part
        }
        return this.Normalize(result)
    }

    /**
     * Get absolute path
     * @param {String} path - Relative or absolute path
     * @param {String} basePath - Base path for relative resolution
     * @returns {String} Absolute path
     */
    static GetAbsolute(path, basePath := "") {
        if (basePath = "")
            basePath := A_ScriptDir

        ; Already absolute
        if (this.IsAbsolute(path))
            return this.Normalize(path)

        ; Resolve relative path
        return this.Normalize(basePath "\" path)
    }

    /**
     * Check if path is absolute
     * @param {String} path - Path to check
     * @returns {Boolean} True if absolute
     */
    static IsAbsolute(path) {
        ; Check for drive letter
        if RegExMatch(path, "i)^[A-Z]:\\")
            return true

        ; Check for UNC path
        if (SubStr(path, 1, 2) = "\\")
            return true

        return false
    }

    /**
     * Get relative path
     * @param {String} path - Target path
     * @param {String} basePath - Base path
     * @returns {String} Relative path
     */
    static GetRelative(path, basePath := "") {
        if (basePath = "")
            basePath := A_ScriptDir

        path := this.Normalize(path)
        basePath := this.Normalize(basePath)

        ; Split paths into components
        pathParts := StrSplit(path, "\")
        baseParts := StrSplit(basePath, "\")

        ; Find common prefix
        commonLen := 0
        Loop Min(pathParts.Length, baseParts.Length) {
            if (pathParts[A_Index] != baseParts[A_Index])
                break
            commonLen := A_Index
        }

        ; Build relative path
        result := ""

        ; Add ".." for each remaining base component
        Loop (baseParts.Length - commonLen)
            result .= (result = "" ? "" : "\") ".."

        ; Add remaining path components
        Loop (pathParts.Length - commonLen) {
            component := pathParts[commonLen + A_Index]
            result .= (result = "" ? "" : "\") component
        }

        return result = "" ? "." : result
    }

    /**
     * Get directory name
     * @param {String} path - File path
     * @returns {String} Directory path
     */
    static GetDirectory(path) {
        path := this.Normalize(path)
        lastSlash := InStrRev(path, "\")
        if (lastSlash = 0)
            return "."
        return SubStr(path, 1, lastSlash - 1)
    }

    /**
     * Get file name
     * @param {String} path - File path
     * @param {Boolean} withExtension - Include extension
     * @returns {String} File name
     */
    static GetFileName(path, withExtension := true) {
        path := this.Normalize(path)
        lastSlash := InStrRev(path, "\")
        fileName := lastSlash ? SubStr(path, lastSlash + 1) : path

        if (!withExtension) {
            lastDot := InStrRev(fileName, ".")
            if (lastDot > 0)
                fileName := SubStr(fileName, 1, lastDot - 1)
        }

        return fileName
    }

    /**
     * Get file extension
     * @param {String} path - File path
     * @returns {String} Extension (without dot)
     */
    static GetExtension(path) {
        fileName := this.GetFileName(path)
        lastDot := InStrRev(fileName, ".")
        return lastDot ? SubStr(fileName, lastDot + 1) : ""
    }
}

/**
 * Test path utilities
 */
^!1::{
    output := "Path Utilities Demo`n"
    output .= "===================`n`n"

    testPath := "C:\Users\Test\Documents\Scripts\MyScript.ahk"

    output .= "Original: " testPath "`n`n"

    output .= "Components:`n"
    output .= "  Directory: " PathUtils.GetDirectory(testPath) "`n"
    output .= "  FileName: " PathUtils.GetFileName(testPath) "`n"
    output .= "  Name (no ext): " PathUtils.GetFileName(testPath, false) "`n"
    output .= "  Extension: " PathUtils.GetExtension(testPath) "`n`n"

    output .= "Path Operations:`n"
    output .= "  Is Absolute: " (PathUtils.IsAbsolute(testPath) ? "Yes" : "No") "`n"
    output .= "  Joined: " PathUtils.Join("C:", "Users", "Test", "file.txt") "`n"

    MsgBox(output, "Path Utils", "Iconi")
}

/**
 * ============================================================================
 * Example 2: Include Path Resolver
 * ============================================================================
 *
 * @description Resolve #Include directives to actual file paths
 * @concept Path resolution, include search paths
 */

/**
 * Include path resolver
 * @class
 */
class IncludeResolver {
    static SearchPaths := []

    /**
     * Initialize search paths
     * @returns {void}
     */
    static Initialize() {
        ; Standard search locations
        this.SearchPaths := [
            A_ScriptDir,
            A_ScriptDir "\Lib",
            A_MyDocuments "\AutoHotkey\Lib",
            A_ProgramFiles "\AutoHotkey\Lib"
        ]
    }

    /**
     * Resolve include path
     * @param {String} includePath - Path from #Include directive
     * @param {String} includeFrom - File containing the #Include
     * @returns {String|false} Resolved path or false
     */
    static Resolve(includePath, includeFrom := "") {
        if (includeFrom = "")
            includeFrom := A_ScriptDir

        ; Remove quotes if present
        includePath := Trim(includePath, '"' . "'")

        ; Handle angle bracket notation <LibName>
        if (SubStr(includePath, 1, 1) = "<" && SubStr(includePath, -1) = ">") {
            libName := SubStr(includePath, 2, -1)
            return this.ResolveStandardLib(libName)
        }

        ; Absolute path
        if (PathUtils.IsAbsolute(includePath)) {
            if FileExist(includePath)
                return PathUtils.Normalize(includePath)
            return false
        }

        ; Relative path - try multiple locations
        searchDirs := [PathUtils.GetDirectory(includeFrom)]
        searchDirs.Push(this.SearchPaths*)

        for dir in searchDirs {
            fullPath := PathUtils.Join(dir, includePath)
            if FileExist(fullPath)
                return fullPath
        }

        return false
    }

    /**
     * Resolve standard library include
     * @param {String} libName - Library name
     * @returns {String|false} Resolved path or false
     */
    static ResolveStandardLib(libName) {
        ; Add .ahk extension if missing
        if (!InStr(libName, ".ahk"))
            libName .= ".ahk"

        ; Search standard library paths
        stdPaths := [
            A_MyDocuments "\AutoHotkey\Lib",
            A_ProgramFiles "\AutoHotkey\Lib"
        ]

        for path in stdPaths {
            fullPath := PathUtils.Join(path, libName)
            if FileExist(fullPath)
                return fullPath
        }

        return false
    }

    /**
     * Display resolution results
     * @param {String} includePath - Path to resolve
     * @returns {void}
     */
    static ShowResolution(includePath) {
        resolved := this.Resolve(includePath)

        output := "Include Path Resolution`n"
        output .= "=======================`n`n"
        output .= "Input: " includePath "`n`n"

        if (resolved) {
            output .= "✓ Resolved to:`n"
            output .= resolved "`n`n"
            output .= "Exists: " (FileExist(resolved) ? "Yes" : "No") "`n"
            output .= "Type: " (InStr(FileExist(resolved), "D") ? "Directory" : "File") "`n"
        } else {
            output .= "✗ Could not resolve path`n`n"
            output .= "Searched in:`n"
            for path in this.SearchPaths {
                output .= "  • " path "`n"
            }
        }

        MsgBox(output, "Path Resolution", "Iconi")
    }
}

IncludeResolver.Initialize()

^!2::IncludeResolver.ShowResolution("Lib\MyLib.ahk")

/**
 * ============================================================================
 * Example 3: Relative Path Navigation
 * ============================================================================
 *
 * @description Navigate directory structures with relative paths
 * @concept Directory traversal, parent directories, current directory
 */

/**
 * Relative path navigator
 * @class
 */
class RelativePathNavigator {
    /**
     * Resolve parent directory references
     * @param {String} path - Path with .. references
     * @param {String} basePath - Base path
     * @returns {String} Resolved path
     */
    static ResolveParents(path, basePath := "") {
        if (basePath = "")
            basePath := A_ScriptDir

        ; Split into components
        parts := StrSplit(path, "\")
        baseParts := StrSplit(basePath, "\")

        result := []
        result.Push(baseParts*)

        for part in parts {
            if (part = "..") {
                ; Go up one directory
                if (result.Length > 1)
                    result.Pop()
            } else if (part = "." || part = "") {
                ; Current directory or empty - skip
                continue
            } else {
                ; Regular directory name
                result.Push(part)
            }
        }

        return PathUtils.Join(result*)
    }

    /**
     * Calculate directory depth
     * @param {String} path - Path to analyze
     * @returns {Integer} Directory depth
     */
    static GetDepth(path) {
        path := PathUtils.Normalize(path)
        parts := StrSplit(path, "\")

        ; Filter out drive letter and empty parts
        depth := 0
        for part in parts {
            if (part != "" && !InStr(part, ":"))
                depth++
        }

        return depth
    }

    /**
     * Generate relative path with .. notation
     * @param {Integer} levelsUp - Number of parent directories
     * @param {String} targetPath - Target path from that point
     * @returns {String} Relative path
     */
    static BuildRelativePath(levelsUp, targetPath := "") {
        result := ""

        ; Add parent directory references
        Loop levelsUp {
            result .= (result = "" ? "" : "\") ".."
        }

        ; Add target path if provided
        if (targetPath != "")
            result .= (result = "" ? "" : "\") targetPath

        return result
    }

    /**
     * Test relative path navigation
     * @returns {void}
     */
    static TestNavigation() {
        basePath := "C:\Projects\MyApp\Scripts"

        tests := [
            {path: "..\Lib\Utils.ahk", desc: "Parent + Lib"},
            {path: "..\..\Config\settings.ahk", desc: "Two levels up"},
            {path: ".\Helpers\helper.ahk", desc: "Current + subdirectory"},
            {path: "..\..\..\Common\common.ahk", desc: "Three levels up"}
        ]

        output := "Relative Path Navigation Tests`n"
        output .= "==============================`n"
        output .= "Base: " basePath "`n`n"

        for test in tests {
            resolved := this.ResolveParents(test.path, basePath)
            output .= test.desc ":`n"
            output .= "  Input: " test.path "`n"
            output .= "  Result: " resolved "`n`n"
        }

        MsgBox(output, "Navigation Tests", "Iconi")
    }
}

^!3::RelativePathNavigator.TestNavigation()

/**
 * ============================================================================
 * Example 4: Include Path Validator
 * ============================================================================
 *
 * @description Validate include paths and detect issues
 * @concept Path validation, error detection, file system checks
 */

/**
 * Include path validator
 * @class
 */
class IncludeValidator {
    /**
     * Validate include path
     * @param {String} includePath - Path to validate
     * @returns {Object} Validation result
     */
    static Validate(includePath) {
        result := {
            Valid: true,
            Errors: [],
            Warnings: [],
            Info: {}
        }

        ; Check for empty path
        if (includePath = "") {
            result.Valid := false
            result.Errors.Push("Path is empty")
            return result
        }

        ; Check for invalid characters
        invalidChars := ['<', '>', ':', '"', '|', '?', '*']
        for char in invalidChars {
            if InStr(includePath, char) && !(char = '<' || char = '>') {
                result.Warnings.Push("Path contains invalid character: " char)
            }
        }

        ; Try to resolve path
        resolved := IncludeResolver.Resolve(includePath)
        if (!resolved) {
            result.Valid := false
            result.Errors.Push("Path could not be resolved")
            return result
        }

        result.Info.ResolvedPath := resolved

        ; Check if file exists
        if (!FileExist(resolved)) {
            result.Valid := false
            result.Errors.Push("File does not exist: " resolved)
            return result
        }

        ; Check if it's a directory
        if InStr(FileExist(resolved), "D") {
            result.Valid := false
            result.Errors.Push("Path points to directory, not file")
            return result
        }

        ; Check file extension
        ext := PathUtils.GetExtension(resolved)
        if (ext != "ahk" && ext != "ah2") {
            result.Warnings.Push("File extension is not .ahk or .ah2: " ext)
        }

        ; Check file size
        try {
            size := FileGetSize(resolved)
            result.Info.FileSize := size

            if (size = 0)
                result.Warnings.Push("File is empty")
            else if (size > 1000000)  ; > 1MB
                result.Warnings.Push("File is very large: " Round(size/1024) " KB")
        }

        return result
    }

    /**
     * Display validation results
     * @param {String} includePath - Path to validate
     * @returns {void}
     */
    static ShowValidation(includePath) {
        result := this.Validate(includePath)

        output := "Include Path Validation`n"
        output .= "=======================`n`n"
        output .= "Path: " includePath "`n`n"

        if (result.Valid) {
            output .= "✓ Valid`n`n"

            if (result.Info.HasOwnProp("ResolvedPath"))
                output .= "Resolved: " result.Info.ResolvedPath "`n"

            if (result.Info.HasOwnProp("FileSize"))
                output .= "Size: " Round(result.Info.FileSize/1024, 2) " KB`n"
        } else {
            output .= "✗ Invalid`n`n"
        }

        if (result.Errors.Length > 0) {
            output .= "`nErrors:`n"
            for err in result.Errors
                output .= "  • " err "`n"
        }

        if (result.Warnings.Length > 0) {
            output .= "`nWarnings:`n"
            for warn in result.Warnings
                output .= "  ⚠ " warn "`n"
        }

        icon := result.Valid ? "Iconi" : "Icon!"
        MsgBox(output, "Validation", icon)
    }
}

^!4::IncludeValidator.ShowValidation("Lib\MyLib.ahk")

/**
 * ============================================================================
 * Example 5: Cross-Platform Path Handling
 * ============================================================================
 *
 * @description Handle paths across different Windows configurations
 * @concept Platform compatibility, path portability
 */

/**
 * Cross-platform path handler
 * @class
 */
class CrossPlatformPath {
    /**
     * Convert Unix-style paths to Windows
     * @param {String} path - Unix-style path
     * @returns {String} Windows path
     */
    static FromUnix(path) {
        ; Convert forward slashes
        path := StrReplace(path, "/", "\")

        ; Handle Unix root
        if (SubStr(path, 1, 1) = "\")
            path := "C:" path

        return PathUtils.Normalize(path)
    }

    /**
     * Convert to portable path format
     * @param {String} path - Absolute path
     * @returns {String} Portable path with variables
     */
    static MakePortable(path) {
        path := PathUtils.Normalize(path)

        ; Replace common paths with variables
        replacements := Map(
            A_ScriptDir, "%A_ScriptDir%",
            A_WorkingDir, "%A_WorkingDir%",
            A_MyDocuments, "%A_MyDocuments%",
            A_AppData, "%A_AppData%",
            A_AppDataCommon, "%A_AppDataCommon%",
            A_ProgramFiles, "%A_ProgramFiles%"
        )

        for original, variable in replacements {
            if (InStr(path, original) = 1) {
                path := StrReplace(path, original, variable)
                break
            }
        }

        return path
    }

    /**
     * Expand portable path
     * @param {String} path - Path with variables
     * @returns {String} Expanded path
     */
    static ExpandPortable(path) {
        ; Expand built-in variables
        path := StrReplace(path, "%A_ScriptDir%", A_ScriptDir)
        path := StrReplace(path, "%A_WorkingDir%", A_WorkingDir)
        path := StrReplace(path, "%A_MyDocuments%", A_MyDocuments)
        path := StrReplace(path, "%A_AppData%", A_AppData)
        path := StrReplace(path, "%A_AppDataCommon%", A_AppDataCommon)
        path := StrReplace(path, "%A_ProgramFiles%", A_ProgramFiles)

        return PathUtils.Normalize(path)
    }

    /**
     * Test cross-platform paths
     * @returns {void}
     */
    static TestPaths() {
        output := "Cross-Platform Path Handling`n"
        output .= "============================`n`n"

        ; Unix path conversion
        unixPath := "/home/user/scripts/test.ahk"
        output .= "Unix Path: " unixPath "`n"
        output .= "Windows: " this.FromUnix(unixPath) "`n`n"

        ; Portable paths
        absPath := A_ScriptDir "\Lib\Utils.ahk"
        portable := this.MakePortable(absPath)
        expanded := this.ExpandPortable(portable)

        output .= "Absolute: " absPath "`n"
        output .= "Portable: " portable "`n"
        output .= "Expanded: " expanded "`n"

        MsgBox(output, "Cross-Platform", "Iconi")
    }
}

^!5::CrossPlatformPath.TestPaths()

/**
 * ============================================================================
 * Example 6: Include Dependency Tracker
 * ============================================================================
 *
 * @description Track and visualize include dependencies
 * @concept Dependency tracking, include graph
 */

/**
 * Include dependency tracker
 * @class
 */
class DependencyTracker {
    static Dependencies := Map()

    /**
     * Register a dependency
     * @param {String} parent - File with #Include
     * @param {String} child - Included file
     * @returns {void}
     */
    static Register(parent, child) {
        parent := PathUtils.Normalize(parent)
        child := PathUtils.Normalize(child)

        if (!this.Dependencies.Has(parent))
            this.Dependencies[parent] := []

        deps := this.Dependencies[parent]
        if (!this.ArrayIncludes(deps, child))
            deps.Push(child)
    }

    /**
     * Get dependencies for file
     * @param {String} file - File path
     * @param {Boolean} recursive - Get recursive dependencies
     * @returns {Array} List of dependencies
     */
    static GetDependencies(file, recursive := false) {
        file := PathUtils.Normalize(file)

        if (!this.Dependencies.Has(file))
            return []

        deps := this.Dependencies[file].Clone()

        if (recursive) {
            for dep in deps {
                childDeps := this.GetDependencies(dep, true)
                for childDep in childDeps {
                    if (!this.ArrayIncludes(deps, childDep))
                        deps.Push(childDep)
                }
            }
        }

        return deps
    }

    /**
     * Generate dependency tree
     * @param {String} file - Root file
     * @param {Integer} indent - Indentation level
     * @returns {String} Tree representation
     */
    static GenerateTree(file, indent := 0) {
        file := PathUtils.Normalize(file)
        indentStr := StrReplace(Format("{:" indent * 2 "s}", ""), " ", " ")

        tree := indentStr "• " PathUtils.GetFileName(file) "`n"

        if (this.Dependencies.Has(file)) {
            for dep in this.Dependencies[file] {
                tree .= this.GenerateTree(dep, indent + 1)
            }
        }

        return tree
    }

    /**
     * Display dependency tree
     * @returns {void}
     */
    static ShowTree() {
        output := "Include Dependency Tree`n"
        output .= "=======================`n`n"

        mainScript := A_ScriptFullPath
        output .= this.GenerateTree(mainScript)

        MsgBox(output, "Dependencies", "Iconi")
    }

    /**
     * Helper: Check if array includes value
     * @private
     */
    static ArrayIncludes(arr, value) {
        for item in arr {
            if (item = value)
                return true
        }
        return false
    }
}

; Register some example dependencies
DependencyTracker.Register(A_ScriptFullPath, A_ScriptDir "\Lib\StringUtils.ahk")
DependencyTracker.Register(A_ScriptFullPath, A_ScriptDir "\Lib\PathUtils.ahk")
DependencyTracker.Register(A_ScriptDir "\Lib\StringUtils.ahk", A_ScriptDir "\Lib\Common.ahk")

^!6::DependencyTracker.ShowTree()

/**
 * ============================================================================
 * Example 7: Smart Include Path Generator
 * ============================================================================
 *
 * @description Generate optimal include paths based on file locations
 * @concept Path optimization, smart includes
 */

/**
 * Smart include path generator
 * @class
 */
class SmartIncludeGenerator {
    /**
     * Generate best include path
     * @param {String} targetFile - File to include
     * @param {String} fromFile - File containing #Include
     * @returns {String} Optimal include path
     */
    static Generate(targetFile, fromFile := "") {
        if (fromFile = "")
            fromFile := A_ScriptFullPath

        targetFile := PathUtils.Normalize(targetFile)
        fromFile := PathUtils.Normalize(fromFile)

        fromDir := PathUtils.GetDirectory(fromFile)

        ; Check if in standard library location
        if (this.IsInStandardLib(targetFile))
            return "<" PathUtils.GetFileName(targetFile) ">"

        ; Calculate relative path
        relativePath := PathUtils.GetRelative(targetFile, fromDir)

        ; If relative path is shorter and reasonable, use it
        if (StrLen(relativePath) < StrLen(targetFile) && !InStr(relativePath, "..\..\..")) {
            return relativePath
        }

        ; Otherwise use absolute path
        return targetFile
    }

    /**
     * Check if file is in standard library location
     * @param {String} file - File path
     * @returns {Boolean} True if in standard lib
     */
    static IsInStandardLib(file) {
        file := PathUtils.Normalize(file)
        stdPaths := [
            A_MyDocuments "\AutoHotkey\Lib",
            A_ProgramFiles "\AutoHotkey\Lib"
        ]

        for path in stdPaths {
            if (InStr(file, path) = 1)
                return true
        }

        return false
    }

    /**
     * Generate include directive
     * @param {String} targetFile - File to include
     * @param {Boolean} optional - Make it optional (*i)
     * @returns {String} Full #Include directive
     */
    static GenerateDirective(targetFile, optional := false) {
        path := this.Generate(targetFile)
        directive := "#Include "

        if (optional)
            directive .= "*i "

        directive .= path

        return directive
    }

    /**
     * Test include generation
     * @returns {void}
     */
    static TestGeneration() {
        output := "Smart Include Generation`n"
        output .= "========================`n`n"

        testFiles := [
            A_ScriptDir "\Lib\Utils.ahk",
            A_ScriptDir "\..\Common\shared.ahk",
            "C:\AutoHotkey\Lib\JSON.ahk"
        ]

        for file in testFiles {
            generated := this.Generate(file)
            directive := this.GenerateDirective(file)

            output .= "File: " PathUtils.GetFileName(file) "`n"
            output .= "  Path: " generated "`n"
            output .= "  Directive: " directive "`n`n"
        }

        MsgBox(output, "Include Generation", "Iconi")
    }
}

^!7::SmartIncludeGenerator.TestGeneration()

/**
 * ============================================================================
 * STARTUP
 * ============================================================================
 */

OutputDebug("Script directory: " A_ScriptDir)
TrayTip("Relative paths loaded", "Script Ready", "Iconi Mute")

/**
 * Help hotkey
 */
^!h::{
    help := "Relative Path Examples`n"
    help .= "======================`n`n"
    help .= "^!1 - Path Utilities Demo`n"
    help .= "^!2 - Include Resolution`n"
    help .= "^!3 - Navigation Tests`n"
    help .= "^!4 - Path Validation`n"
    help .= "^!5 - Cross-Platform Paths`n"
    help .= "^!6 - Dependency Tree`n"
    help .= "^!7 - Include Generation`n"
    help .= "^!h - Show Help`n"

    MsgBox(help, "Help", "Iconi")
}
