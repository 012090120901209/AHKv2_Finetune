#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_FileExist_02.ahk
 * 
 * DESCRIPTION:
 * Advanced FileExist() examples focusing on directory validation and recursive operations
 * 
 * FEATURES:
 * - Directory existence validation
 * - Recursive directory checking
 * - Path normalization
 * - Network path validation
 * - Directory tree validation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileExist.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileExist() with directories
 * - DirCreate() and DirExist()
 * - Path manipulation
 * - Recursive operations
 * - Array and Map usage
 * 
 * LEARNING POINTS:
 * 1. FileExist() works for both files and directories
 * 2. "D" in attribute string indicates directory
 * 3. Can validate entire directory structures
 * 4. Useful for ensuring output paths exist
 * 5. Can check network paths (if accessible)
 * 6. Combine with DirCreate for safe directory operations
 */

; ============================================================
; Example 1: Directory Existence Validation
; ============================================================

/**
 * Ensure directory exists, create if necessary
 * 
 * @param {String} dirPath - Directory path
 * @param {Boolean} createIfMissing - Create if doesn't exist
 * @returns {Boolean} - True if directory exists or was created
 */
EnsureDirectory(dirPath, createIfMissing := true) {
    attrs := FileExist(dirPath)

    ; Directory exists
    if (attrs && InStr(attrs, "D"))
        return true

    ; Path exists but is a file
    if (attrs && !InStr(attrs, "D")) {
        MsgBox("Error: Path exists but is a file, not a directory:`n" dirPath,
            "Path Error", "IconX")
        return false
    }

    ; Directory doesn't exist
    if (createIfMissing) {
        try {
            DirCreate(dirPath)
            return true
        } catch Error as err {
            MsgBox("Failed to create directory:`n" dirPath "`n`nError: " err.Message,
                "Creation Error", "IconX")
            return false
        }
    }

    return false
}

; Test directory creation
testDir := A_ScriptDir "\TestDirectory"
if (EnsureDirectory(testDir)) {
    MsgBox("Directory ready: " testDir "`n"
        . "Attributes: " FileExist(testDir),
        "Directory Ensured", "Icon!")
}

; ============================================================
; Example 2: Directory Tree Validation
; ============================================================

/**
 * Validate entire directory tree structure
 * 
 * @param {String} basePath - Base directory path
 * @param {Array} subdirs - Array of required subdirectories
 * @returns {Object} - Validation result
 */
ValidateDirectoryTree(basePath, subdirs) {
    result := {
        valid: true,
        missing: [],
        created: []
    }

    ; Check base directory
    if (!FileExist(basePath) || !InStr(FileExist(basePath), "D")) {
        try {
            DirCreate(basePath)
            result.created.Push(basePath)
        } catch {
            result.valid := false
            result.missing.Push(basePath)
            return result
        }
    }

    ; Check each subdirectory
    for subdir in subdirs {
        fullPath := basePath "\" subdir
        if (!FileExist(fullPath) || !InStr(FileExist(fullPath), "D")) {
            try {
                DirCreate(fullPath)
                result.created.Push(fullPath)
            } catch {
                result.valid := false
                result.missing.Push(fullPath)
            }
        }
    }

    return result
}

; Test directory tree
projectDir := A_ScriptDir "\MyProject"
requiredDirs := ["src", "bin", "data", "logs", "temp"]

treeResult := ValidateDirectoryTree(projectDir, requiredDirs)

output := "DIRECTORY TREE VALIDATION:`n`n"
output .= "Base: " projectDir "`n"
output .= "Status: " (treeResult.valid ? "VALID ✓" : "INVALID ✗") "`n`n"

if (treeResult.created.Length > 0) {
    output .= "Created (" treeResult.created.Length "):`n"
    for dir in treeResult.created
        output .= "  + " dir "`n"
}

if (treeResult.missing.Length > 0) {
    output .= "`nMissing (" treeResult.missing.Length "):`n"
    for dir in treeResult.missing
        output .= "  - " dir "`n"
}

MsgBox(output, "Tree Validation", treeResult.valid ? "Icon!" : "IconX")

; ============================================================
; Example 3: Parent Directory Chain Validation
; ============================================================

/**
 * Check if all parent directories exist in a path
 * 
 * @param {String} filePath - Full file path
 * @returns {Object} - Information about directory chain
 */
ValidatePathChain(filePath) {
    result := {
        valid: true,
        chain: [],
        missingStart: -1
    }

    ; Split path into components
    SplitPath(filePath, , &dir)

    ; Build chain of directories
    current := ""
    parts := StrSplit(dir, "\")

    for index, part in parts {
        if (index = 1 && SubStr(part, 2, 1) = ":") {
            ; Drive letter
            current := part
        } else {
            current .= (current ? "\" : "") . part
        }

        exists := FileExist(current) && InStr(FileExist(current), "D")
        result.chain.Push({ path: current, exists: exists })

        if (!exists && result.missingStart = -1) {
            result.missingStart := index
            result.valid := false
        }
    }

    return result
}

; Test path validation
testPath := A_ScriptDir "\Level1\Level2\Level3\file.txt"
chainResult := ValidatePathChain(testPath)

output := "PATH CHAIN VALIDATION:`n`n"
output .= "Path: " testPath "`n`n"
output .= "Directory Chain:`n"

for index, item in chainResult.chain {
    status := item.exists ? "✓" : "✗"
    output .= status " " item.path "`n"
}

output .= "`nFirst Missing: " (chainResult.missingStart = -1 ? "None" : "Level " chainResult.missingStart)

MsgBox(output, "Path Chain", chainResult.valid ? "Icon!" : "IconX")

; ============================================================
; Example 4: Multi-Location File Search
; ============================================================

/**
 * Search for file in multiple possible directories
 * 
 * @param {String} fileName - File name to search for
 * @param {Array} searchPaths - Array of directories to search
 * @returns {String} - Full path if found, empty string otherwise
 */
FindInPaths(fileName, searchPaths) {
    for dirPath in searchPaths {
        ; Skip if directory doesn't exist
        if (!FileExist(dirPath) || !InStr(FileExist(dirPath), "D"))
            continue

        fullPath := dirPath "\" fileName

        ; Check if file exists in this directory
        if (FileExist(fullPath) && !InStr(FileExist(fullPath), "D"))
            return fullPath
    }

    return ""  ; Not found
}

; Create test file in one location
testFile := projectDir "\data\config.ini"
DirCreate(projectDir "\data")
FileAppend("[Settings]`nValue=Test", testFile)

; Search in multiple locations
searchLocations := [
    A_ScriptDir,
    projectDir "\bin",
    projectDir "\data",
    projectDir "\config"
]

foundPath := FindInPaths("config.ini", searchLocations)

output := "MULTI-LOCATION SEARCH:`n`n"
output .= "Searching for: config.ini`n`n"
output .= "Search Paths:`n"

for path in searchLocations {
    exists := FileExist(path) && InStr(FileExist(path), "D")
    output .= (exists ? "✓ " : "✗ ") . path "`n"
}

output .= "`nResult: " (foundPath ? "FOUND" : "NOT FOUND") "`n"
if (foundPath)
    output .= "Location: " foundPath

MsgBox(output, "File Search", foundPath ? "Icon!" : "IconX")

; ============================================================
; Example 5: Conditional Directory Operations
; ============================================================

/**
 * Perform operation only if directory is valid and not empty
 * 
 * @param {String} dirPath - Directory to check
 * @returns {Object} - Directory information
 */
GetDirectoryInfo(dirPath) {
    info := {
        exists: false,
        isDirectory: false,
        isEmpty: true,
        fileCount: 0,
        dirCount: 0
    }

    attrs := FileExist(dirPath)

    if (!attrs)
        return info

    info.exists := true
    info.isDirectory := InStr(attrs, "D") ? true : false

    if (!info.isDirectory)
        return info

    ; Count contents
    Loop Files, dirPath "\*.*", "F"
        info.fileCount++

    Loop Files, dirPath "\*.*", "D"
        info.dirCount++

    info.isEmpty := (info.fileCount = 0 && info.dirCount = 0)

    return info
}

; Test directory info
dirInfo := GetDirectoryInfo(projectDir "\data")

output := "DIRECTORY INFORMATION:`n`n"
output .= "Path: " projectDir "\data`n`n"
output .= "Exists: " (dirInfo.exists ? "Yes" : "No") "`n"
output .= "Is Directory: " (dirInfo.isDirectory ? "Yes" : "No") "`n"
output .= "Empty: " (dirInfo.isEmpty ? "Yes" : "No") "`n"
output .= "Files: " dirInfo.fileCount "`n"
output .= "Subdirectories: " dirInfo.dirCount

MsgBox(output, "Directory Info", "Icon!")

; ============================================================
; Example 6: Safe Output Directory Selection
; ============================================================

/**
 * Get valid output directory, creating if necessary
 * 
 * @param {Array} preferredPaths - Ordered list of preferred directories
 * @param {String} createDir - Directory name to create if none exist
 * @returns {String} - Valid output directory path
 */
GetOutputDirectory(preferredPaths, createDir := "") {
    ; Try preferred paths first
    for dirPath in preferredPaths {
        attrs := FileExist(dirPath)
        if (attrs && InStr(attrs, "D")) {
            ; Check if writable by attempting to create temp file
            try {
                testFile := dirPath "\~temp_write_test.tmp"
                FileAppend("test", testFile)
                FileDelete(testFile)
                return dirPath
            }
        }
    }

    ; No preferred path available, create new one
    if (createDir) {
        try {
            DirCreate(createDir)
            return createDir
        }
    }

    ; Fallback to script directory
    return A_ScriptDir
}

; Test output directory selection
preferredOutputs := [
    A_Temp "\MyApp",
    projectDir "\output",
    A_ScriptDir "\output"
]

outputDir := GetOutputDirectory(preferredOutputs, A_ScriptDir "\output")

MsgBox("Selected Output Directory:`n" outputDir "`n`n"
    . "Exists: " (FileExist(outputDir) ? "Yes" : "No") "`n"
    . "Attributes: " FileExist(outputDir),
    "Output Directory", "Icon!")

; ============================================================
; Example 7: Directory Hierarchy Browser
; ============================================================

/**
 * Build directory hierarchy map
 * 
 * @param {String} rootPath - Root directory
 * @param {Integer} maxDepth - Maximum depth to traverse
 * @returns {Array} - Array of directory information
 */
BuildDirectoryHierarchy(rootPath, maxDepth := 2) {
    hierarchy := []

    if (!FileExist(rootPath) || !InStr(FileExist(rootPath), "D"))
        return hierarchy

    BuildLevel(rootPath, 0, hierarchy, maxDepth)
    return hierarchy

    BuildLevel(path, level, &result, maxDepth) {
        if (level >= maxDepth)
            return

        indent := ""
        Loop level
            indent .= "  "

        Loop Files, path "\*.*", "D" {
            result.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                level: level,
                display: indent "└─ " A_LoopFileName
            })

            BuildLevel(A_LoopFilePath, level + 1, &result, maxDepth)
        }
    }
}

; Build and display hierarchy
hierarchy := BuildDirectoryHierarchy(projectDir, 3)

output := "DIRECTORY HIERARCHY:`n`n"
output .= "Root: " projectDir "`n`n"

if (hierarchy.Length > 0) {
    for item in hierarchy
        output .= item.display "`n"
} else {
    output .= "(No subdirectories or directory doesn't exist)"
}

MsgBox(output, "Directory Browser", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILEEXIST() FOR DIRECTORIES:

Key Points:
• FileExist() returns attributes for both files and directories
• Check for 'D' in attribute string to confirm directory
• Use DirExist() as alternative (v2.0+ only)
• Always validate before directory operations

Directory Detection:
attrs := FileExist(path)
isDir := InStr(attrs, 'D') ? true : false

; Or use DirExist (simpler)
isDir := DirExist(path) ? true : false

Common Patterns:

1. Ensure Directory Exists:
if (!DirExist(path))
DirCreate(path)

2. Distinguish File vs Directory:
attrs := FileExist(path)
if (attrs && InStr(attrs, 'D'))
; It's a directory
else if (attrs)
; It's a file

3. Validate Path Chain:
Loop through each level
Check if each parent exists

4. Safe Directory Operations:
Always check existence before:
• Reading directory contents
• Creating subdirectories
• Moving/copying files

Best Practices:
✓ Check existence before operations
✓ Distinguish files from directories
✓ Handle network paths carefully
✓ Create parent directories as needed
✓ Validate write permissions
✓ Use try-catch for creation operations
)"

MsgBox(info, "Directory Validation Reference", "Icon!")

; Cleanup
try {
    DirDelete(projectDir, true)
    DirDelete(testDir, true)
}
