#Requires AutoHotkey v2.0
/**
 * BuiltIn_FileExist_04.ahk
 *
 * DESCRIPTION:
 * Advanced FileExist() patterns for complex file management scenarios
 *
 * FEATURES:
 * - Pattern matching with wildcards
 * - Version detection and management
 * - File type detection
 * - Configuration cascading
 * - Resource location
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileExist.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileExist() with wildcards
 * - Advanced pattern matching
 * - File system queries
 * - Dynamic resource loading
 * - Version management
 *
 * LEARNING POINTS:
 * 1. FileExist() accepts wildcard patterns
 * 2. Returns attributes of first match with wildcards
 * 3. Can check for specific file types
 * 4. Useful for version detection
 * 5. Enables dynamic resource loading
 * 6. Supports configuration cascading
 */

; ============================================================
; Example 1: Wildcard Pattern Matching
; ============================================================

/**
 * Check if any file matching pattern exists
 *
 * @param {String} pattern - File pattern with wildcards
 * @returns {Object} - Match information
 */
CheckPattern(pattern) {
    result := {
        hasMatch: false,
        attributes: "",
        firstMatch: ""
    }

    attrs := FileExist(pattern)

    if (attrs) {
        result.hasMatch := true
        result.attributes := attrs

        ; Find the actual first match
        SplitPath(pattern, , &dir, , )
        if (!dir)
            dir := A_ScriptDir

        Loop Files, pattern {
            result.firstMatch := A_LoopFilePath
            break
        }
    }

    return result
}

; Create test files
Loop 3
    FileAppend("Content " A_Index, A_ScriptDir "\test_" A_Index ".txt")

FileAppend("Log entry", A_ScriptDir "\app.log")

; Test pattern matching
patterns := [
    A_ScriptDir "\test_*.txt",
    A_ScriptDir "\*.log",
    A_ScriptDir "\missing_*.txt"
]

output := "WILDCARD PATTERN MATCHING:`n`n"
for pattern in patterns {
    matchInfo := CheckPattern(pattern)
    output .= "Pattern: " pattern "`n"
    output .= "  Match: " (matchInfo.hasMatch ? "Yes ✓" : "No ✗") "`n"
    if (matchInfo.hasMatch)
        output .= "  First: " matchInfo.firstMatch "`n"
    output .= "`n"
}

MsgBox(output, "Pattern Matching", "Icon!")

; ============================================================
; Example 2: Version Detection
; ============================================================

/**
 * Find latest version of a file
 *
 * @param {String} baseName - Base file name without version
 * @param {String} extension - File extension
 * @returns {Object} - Version information
 */
FindLatestVersion(baseName, extension := "txt") {
    result := {
        found: false,
        latestVersion: 0,
        filePath: "",
        allVersions: []
    }

    pattern := A_ScriptDir "\" baseName "_v*." extension

    Loop Files, pattern {
        ; Extract version number from filename
        if (RegExMatch(A_LoopFileName, "_v(\d+)\.", &match)) {
            version := Integer(match[1])
            result.allVersions.Push({
                version: version,
                path: A_LoopFilePath,
                name: A_LoopFileName
            })

            if (version > result.latestVersion) {
                result.latestVersion := version
                result.filePath := A_LoopFilePath
                result.found := true
            }
        }
    }

    return result
}

; Create versioned files
FileAppend("Version 1", A_ScriptDir "\document_v1.txt")
FileAppend("Version 2", A_ScriptDir "\document_v2.txt")
FileAppend("Version 5", A_ScriptDir "\document_v5.txt")

; Find latest version
versionInfo := FindLatestVersion("document", "txt")

output := "VERSION DETECTION:`n`n"
output .= "Base Name: document`n"
output .= "Latest Version: " (versionInfo.found ? "v" versionInfo.latestVersion : "None") "`n"
output .= "File Path: " (versionInfo.filePath ? versionInfo.filePath : "N/A") "`n`n"

if (versionInfo.allVersions.Length > 0) {
    output .= "All Versions Found:`n"
    for ver in versionInfo.allVersions
        output .= "  v" ver.version ": " ver.name "`n"
}

MsgBox(output, "Version Detection", versionInfo.found ? "Icon!" : "IconX")

; ============================================================
; Example 3: File Type Detection
; ============================================================

/**
 * Detect file type by extension and content
 *
 * @param {String} filePath - File to check
 * @returns {Object} - File type information
 */
DetectFileType(filePath) {
    result := {
        exists: false,
        isFile: false,
        extension: "",
        category: "Unknown",
        mimeType: ""
    }

    if (!FileExist(filePath))
        return result

    result.exists := true

    if (InStr(FileExist(filePath), "D")) {
        result.category := "Directory"
        return result
    }

    result.isFile := true
    SplitPath(filePath, , , &ext)
    result.extension := ext

    ; Categorize by extension
    extensionMap := Map(
        "txt", {category: "Text", mime: "text/plain"},
        "log", {category: "Log", mime: "text/plain"},
        "ini", {category: "Configuration", mime: "text/plain"},
        "csv", {category: "Data", mime: "text/csv"},
        "json", {category: "Data", mime: "application/json"},
        "xml", {category: "Data", mime: "application/xml"},
        "ahk", {category: "Script", mime: "text/plain"},
        "exe", {category: "Executable", mime: "application/x-msdownload"},
        "dll", {category: "Library", mime: "application/x-msdownload"}
    )

    if (extensionMap.Has(ext)) {
        info := extensionMap[ext]
        result.category := info.category
        result.mimeType := info.mime
    }

    return result
}

; Test file type detection
testFiles := [
    A_ScriptDir "\test_1.txt",
    A_ScriptDir "\app.log",
    A_ScriptDir,
    A_AhkPath
]

output := "FILE TYPE DETECTION:`n`n"
for file in testFiles {
    typeInfo := DetectFileType(file)
    SplitPath(file, &name)
    output .= "File: " name "`n"
    output .= "  Exists: " (typeInfo.exists ? "Yes" : "No") "`n"
    if (typeInfo.exists) {
        output .= "  Category: " typeInfo.category "`n"
        if (typeInfo.extension)
            output .= "  Extension: ." typeInfo.extension "`n"
        if (typeInfo.mimeType)
            output .= "  MIME: " typeInfo.mimeType "`n"
    }
    output .= "`n"
}

MsgBox(output, "File Type Detection", "Icon!")

; ============================================================
; Example 4: Configuration Cascade
; ============================================================

/**
 * Load configuration from cascading sources
 *
 * @param {String} configName - Configuration file name
 * @returns {Object} - Configuration result
 */
LoadCascadingConfig(configName) {
    ; Configuration cascade (highest priority first)
    sources := [
        A_ScriptDir "\" configName ".local.ini",      ; Local override
        A_AppData "\MyApp\" configName ".ini",        ; User config
        A_ScriptDir "\" configName ".ini",            ; Default config
        A_ScriptDir "\config\" configName ".ini"      ; Fallback
    ]

    result := {
        loaded: false,
        source: "",
        sources: [],
        content: ""
    }

    ; Check each source
    for source in sources {
        exists := FileExist(source) ? true : false
        isFile := exists && !InStr(FileExist(source), "D")

        result.sources.Push({
            path: source,
            exists: exists,
            isFile: isFile,
            priority: A_Index
        })

        ; Load from first available valid source
        if (!result.loaded && isFile) {
            try {
                result.content := FileRead(source)
                result.loaded := true
                result.source := source
            }
        }
    }

    return result
}

; Create config in fallback location
DirCreate(A_ScriptDir "\config")
FileAppend("[App]`nVersion=1.0`nMode=Production", A_ScriptDir "\config\settings.ini")

; Load cascading configuration
configResult := LoadCascadingConfig("settings")

output := "CONFIGURATION CASCADE:`n`n"
output .= "Configuration: settings.ini`n"
output .= "Loaded: " (configResult.loaded ? "Yes ✓" : "No ✗") "`n"
output .= "Source: " (configResult.source ? configResult.source : "None") "`n`n"

output .= "Cascade Order (Priority):`n"
for source in configResult.sources {
    status := source.exists ? (source.isFile ? "✓" : "D") : "✗"
    output .= "  " status " Priority " source.priority "`n"
    output .= "    " source.path "`n"
}

MsgBox(output, "Config Cascade", configResult.loaded ? "Icon!" : "IconX")

; ============================================================
; Example 5: Resource Locator
; ============================================================

/**
 * Locate resource file in multiple search paths
 *
 * @param {String} resourceName - Resource file name
 * @param {String} resourceType - Type of resource (images, sounds, etc)
 * @returns {String} - Full path to resource or empty string
 */
LocateResource(resourceName, resourceType := "") {
    searchPaths := []

    ; Build search paths
    if (resourceType) {
        searchPaths.Push(A_ScriptDir "\" resourceType "\" resourceName)
        searchPaths.Push(A_ScriptDir "\resources\" resourceType "\" resourceName)
    }

    searchPaths.Push(A_ScriptDir "\resources\" resourceName)
    searchPaths.Push(A_ScriptDir "\" resourceName)
    searchPaths.Push(A_AppData "\MyApp\resources\" resourceName)

    ; Search each path
    for path in searchPaths {
        if (FileExist(path) && !InStr(FileExist(path), "D"))
            return path
    }

    return ""  ; Not found
}

; Create test resources
DirCreate(A_ScriptDir "\resources\images")
FileAppend("Image data", A_ScriptDir "\resources\images\icon.png")

; Test resource locator
resources := ["icon.png", "missing.png", "app.log"]

output := "RESOURCE LOCATOR:`n`n"
for resource in resources {
    location := LocateResource(resource, "images")
    output .= "Resource: " resource "`n"
    output .= "  Found: " (location ? "Yes ✓" : "No ✗") "`n"
    if (location)
        output .= "  Path: " location "`n"
    output .= "`n"
}

MsgBox(output, "Resource Locator", "Icon!")

; ============================================================
; Example 6: Backup File Finder
; ============================================================

/**
 * Find all backup files for a given file
 *
 * @param {String} originalFile - Original file path
 * @returns {Array} - Array of backup file information
 */
FindBackups(originalFile) {
    backups := []

    if (!FileExist(originalFile))
        return backups

    SplitPath(originalFile, &fileName, &fileDir, &ext, &nameNoExt)

    ; Search for backup files with various patterns
    patterns := [
        fileDir "\" nameNoExt ".backup." ext,
        fileDir "\" nameNoExt "_backup_*." ext,
        fileDir "\" nameNoExt "_*.bak",
        fileDir "\backups\" fileName,
        fileDir "\backups\" nameNoExt "_*." ext
    ]

    for pattern in patterns {
        Loop Files, pattern {
            backups.Push({
                path: A_LoopFilePath,
                name: A_LoopFileName,
                size: A_LoopFileSize,
                modified: A_LoopFileTimeModified
            })
        }
    }

    return backups
}

; Create backup files
FileAppend("Backup 1", A_ScriptDir "\document_v1.backup.txt")
FileAppend("Backup 2", A_ScriptDir "\document_v1_backup_20240101.txt")

; Find backups
backupList := FindBackups(A_ScriptDir "\document_v1.txt")

output := "BACKUP FILE FINDER:`n`n"
output .= "Original: document_v1.txt`n"
output .= "Backups Found: " backupList.Length "`n`n"

if (backupList.Length > 0) {
    for backup in backupList {
        output .= "• " backup.name "`n"
        output .= "  Size: " backup.size " bytes`n"
        output .= "  Modified: " FormatTime(backup.modified, "yyyy-MM-dd HH:mm:ss") "`n`n"
    }
}

MsgBox(output, "Backup Finder", "Icon!")

; ============================================================
; Example 7: File Extension Analyzer
; ============================================================

/**
 * Analyze files by extension in a directory
 *
 * @param {String} dirPath - Directory to analyze
 * @returns {Object} - Analysis results
 */
AnalyzeFileExtensions(dirPath) {
    result := {
        totalFiles: 0,
        extensions: Map(),
        hasFiles: false
    }

    if (!FileExist(dirPath) || !InStr(FileExist(dirPath), "D"))
        return result

    Loop Files, dirPath "\*.*", "F" {
        result.totalFiles++
        result.hasFiles := true

        SplitPath(A_LoopFilePath, , , &ext)

        if (!ext)
            ext := "(no extension)"

        if (!result.extensions.Has(ext))
            result.extensions[ext] := {count: 0, totalSize: 0, files: []}

        extInfo := result.extensions[ext]
        extInfo.count++
        extInfo.totalSize += A_LoopFileSize
        extInfo.files.Push(A_LoopFileName)
    }

    return result
}

; Analyze current directory
analysis := AnalyzeFileExtensions(A_ScriptDir)

output := "FILE EXTENSION ANALYSIS:`n`n"
output .= "Directory: " A_ScriptDir "`n"
output .= "Total Files: " analysis.totalFiles "`n`n"

if (analysis.hasFiles) {
    output .= "Extensions Found:`n"
    for ext, info in analysis.extensions {
        output .= "• ." ext " (" info.count " files)`n"
        output .= "  Total Size: " info.totalSize " bytes`n"
    }
}

MsgBox(output, "Extension Analysis", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED FILEEXIST() PATTERNS:

Wildcard Matching:
  ; Check if any matching file exists
  if (FileExist('C:\Logs\*.log'))
      MsgBox('Log files found')

  ; Note: Returns attributes of FIRST match only
  attrs := FileExist('C:\Data\*.csv')

Version Management:
  ; Find versioned files
  Loop Files, 'app_v*.exe' {
      ; Process each version
  }

  ; Combined with FileExist for quick check
  hasVersions := FileExist('app_v*.exe') ? true : false

Resource Location:
  FindFile(name) {
      paths := [dir1, dir2, dir3]
      for path in paths {
          full := path '\' name
          if (FileExist(full))
              return full
      }
      return ''
  }

Configuration Cascade:
  1. Check local override
  2. Check user config
  3. Check default config
  4. Use built-in defaults

Pattern Matching Tips:
  • * matches any characters
  • ? matches single character
  • Use for existence checks, not file lists
  • Combine with Loop Files for full control
  • Returns first match only

Best Practices:
✓ Validate wildcard results with Loop Files
✓ Use specific patterns over broad ones
✓ Document cascade order clearly
✓ Implement fallback mechanisms
✓ Cache located resources
✓ Handle missing resources gracefully

Common Patterns:
  • Config cascade loading
  • Version detection
  • Resource location
  • Backup file finding
  • Extension filtering
  • Multi-path searching
)"

MsgBox(info, "Advanced FileExist() Reference", "Icon!")

; Cleanup
Loop 3
    FileDelete(A_ScriptDir "\test_" A_Index ".txt")
FileDelete(A_ScriptDir "\app.log")
FileDelete(A_ScriptDir "\document_v1.txt")
FileDelete(A_ScriptDir "\document_v2.txt")
FileDelete(A_ScriptDir "\document_v5.txt")
FileDelete(A_ScriptDir "\document_v1.backup.txt")
FileDelete(A_ScriptDir "\document_v1_backup_20240101.txt")
try DirDelete(A_ScriptDir "\config", true)
try DirDelete(A_ScriptDir "\resources", true)
