#Requires AutoHotkey v2.0

/**
 * BuiltIn_FileGetSize_05.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of FileGetSize() function to get file sizes
 * 
 * FEATURES:
 * - Get file size in bytes
 * - Size unit conversion (KB, MB, GB)
 * - Human-readable formatting
 * - File size comparison
 * - Storage calculations
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetSize.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetSize() function
 * - Size unit conversion
 * - Number formatting
 * - Mathematical operations
 * - String concatenation
 * 
 * LEARNING POINTS:
 * 1. FileGetSize() returns file size in bytes
 * 2. Can specify size units (K=KB, M=MB)
 * 3. Useful for storage management
 * 4. Can track file growth
 * 5. Essential for disk space monitoring
 * 6. Supports human-readable formatting
 */

; ============================================================
; Example 1: Basic File Size Retrieval
; ============================================================

; Create test file with known content
testFile := A_ScriptDir "\testfile.txt"
testContent := "This is test content for measuring file size.`n"
testContent .= "Each line adds to the total size.`n"
testContent .= "File size is measured in bytes by default."

FileAppend(testContent, testFile)

; Get file size in bytes
sizeBytes := FileGetSize(testFile)

MsgBox("File: " testFile "`n`n"
    . "Size: " sizeBytes " bytes`n"
    . "Content length: " StrLen(testContent) " characters",
    "Basic File Size", "Icon!")

; ============================================================
; Example 2: Size in Different Units
; ============================================================

/**
 * Get file size in different units
 * 
 * @param {String} filePath - Path to file
 * @returns {Object} - Size in multiple units
 */
GetSizeInUnits(filePath) {
    return {
        bytes: FileGetSize(filePath),
        kilobytes: FileGetSize(filePath, "K"),
        megabytes: FileGetSize(filePath, "M")
    }
}

; Create larger test file
largeFile := A_ScriptDir "\largefile.txt"
largeContent := ""
Loop 1000
    largeContent .= "This is line " A_Index " with some content to make the file larger.`n"

FileAppend(largeContent, largeFile)

; Get sizes in different units
sizes := GetSizeInUnits(largeFile)

MsgBox("File: largefile.txt`n`n"
    . "Bytes: " sizes.bytes " B`n"
    . "Kilobytes: " sizes.kilobytes " KB`n"
    . "Megabytes: " sizes.megabytes " MB",
    "Size Units", "Icon!")

; ============================================================
; Example 3: Human-Readable Size Formatting
; ============================================================

/**
 * Format file size in human-readable format
 * 
 * @param {Integer} bytes - Size in bytes
 * @param {Integer} decimals - Number of decimal places
 * @returns {String} - Formatted size string
 */
FormatFileSize(bytes, decimals := 2) {
    if (bytes < 1024)
        return bytes " B"

    if (bytes < 1024 * 1024)
        return Round(bytes / 1024, decimals) " KB"

    if (bytes < 1024 * 1024 * 1024)
        return Round(bytes / (1024 * 1024), decimals) " MB"

    return Round(bytes / (1024 * 1024 * 1024), decimals) " GB"
}

/**
 * Get formatted file size
 * 
 * @param {String} filePath - Path to file
 * @returns {String} - Human-readable size
 */
GetFormattedSize(filePath) {
    if (!FileExist(filePath))
        return "File not found"

    bytes := FileGetSize(filePath)
    return FormatFileSize(bytes)
}

; Test with various files
testFiles := [
    testFile,
    largeFile,
    A_AhkPath
]

output := "HUMAN-READABLE FILE SIZES:`n`n"
for file in testFiles {
    SplitPath(file, &name)
    bytes := FileGetSize(file)
    formatted := GetFormattedSize(file)
    output .= name ":`n"
    output .= "  " bytes " bytes = " formatted "`n`n"
}

MsgBox(output, "Formatted Sizes", "Icon!")

; ============================================================
; Example 4: File Size Comparison
; ============================================================

/**
 * Compare sizes of two files
 * 
 * @param {String} file1 - First file path
 * @param {String} file2 - Second file path
 * @returns {Object} - Comparison result
 */
CompareFileSizes(file1, file2) {
    size1 := FileGetSize(file1)
    size2 := FileGetSize(file2)

    result := {
        file1: file1,
        file2: file2,
        size1: size1,
        size2: size2,
        difference: Abs(size1 - size2),
        larger: "",
        percentDiff: 0
    }

    if (size1 > size2) {
        result.larger := "file1"
        result.percentDiff := Round(((size1 - size2) / size2) * 100, 2)
    } else if (size2 > size1) {
        result.larger := "file2"
        result.percentDiff := Round(((size2 - size1) / size1) * 100, 2)
    } else {
        result.larger := "equal"
        result.percentDiff := 0
    }

    return result
}

; Compare files
comparison := CompareFileSizes(testFile, largeFile)

SplitPath(comparison.file1, &name1)
SplitPath(comparison.file2, &name2)

output := "FILE SIZE COMPARISON:`n`n"
output .= name1 ": " FormatFileSize(comparison.size1) "`n"
output .= name2 ": " FormatFileSize(comparison.size2) "`n`n"
output .= "Difference: " FormatFileSize(comparison.difference) "`n"

if (comparison.larger != "equal")
    output .= name2 " is " comparison.percentDiff "% larger"
else
    output .= "Files are equal size"

MsgBox(output, "Size Comparison", "Icon!")

; ============================================================
; Example 5: Total Directory Size
; ============================================================

/**
 * Calculate total size of all files in directory
 * 
 * @param {String} dirPath - Directory path
 * @param {Boolean} recursive - Include subdirectories
 * @returns {Object} - Directory size information
 */
GetDirectorySize(dirPath, recursive := false) {
    result := {
        totalBytes: 0,
        fileCount: 0,
        dirCount: 0,
        formatted: ""
    }

    if (!DirExist(dirPath))
        return result

    ; Count files and sum sizes
    recurseFlag := recursive ? "FR" : "F"
    Loop Files, dirPath "\*.*", recurseFlag {
        result.fileCount++
        result.totalBytes += A_LoopFileSize
    }

    ; Count directories if recursive
    if (recursive) {
        Loop Files, dirPath "\*.*", "D"
            result.dirCount++
    }

    result.formatted := FormatFileSize(result.totalBytes)
    return result
}

; Create directory with multiple files
testDir := A_ScriptDir "\SizeTest"
DirCreate(testDir)

Loop 5
    FileAppend("File " A_Index " content here.`n", testDir "\file" A_Index ".txt")

; Get directory size
dirSize := GetDirectorySize(testDir, false)

output := "DIRECTORY SIZE:`n`n"
output .= "Directory: SizeTest\`n"
output .= "Files: " dirSize.fileCount "`n"
output .= "Total Size: " dirSize.formatted "`n"
output .= "(" dirSize.totalBytes " bytes)"

MsgBox(output, "Directory Size", "Icon!")

; ============================================================
; Example 6: File Size Validator
; ============================================================

/**
 * Validate file size is within acceptable range
 * 
 * @param {String} filePath - File to validate
 * @param {Integer} minBytes - Minimum size in bytes
 * @param {Integer} maxBytes - Maximum size in bytes
 * @returns {Object} - Validation result
 */
ValidateFileSize(filePath, minBytes := 0, maxBytes := 0) {
    result := {
        valid: false,
        size: 0,
        reason: ""
    }

    if (!FileExist(filePath)) {
        result.reason := "File does not exist"
        return result
    }

    size := FileGetSize(filePath)
    result.size := size

    if (minBytes > 0 && size < minBytes) {
        result.reason := "File too small (min: " FormatFileSize(minBytes) ")"
        return result
    }

    if (maxBytes > 0 && size > maxBytes) {
        result.reason := "File too large (max: " FormatFileSize(maxBytes) ")"
        return result
    }

    result.valid := true
    result.reason := "File size acceptable"
    return result
}

; Validate file sizes
minSize := 50        ; 50 bytes minimum
maxSize := 1024 * 10 ; 10 KB maximum

validation := ValidateFileSize(testFile, minSize, maxSize)

output := "FILE SIZE VALIDATION:`n`n"
output .= "File: testfile.txt`n"
output .= "Size: " FormatFileSize(validation.size) "`n"
output .= "Range: " FormatFileSize(minSize) " - " FormatFileSize(maxSize) "`n`n"
output .= "Status: " (validation.valid ? "VALID ✓" : "INVALID ✗") "`n"
output .= "Reason: " validation.reason

MsgBox(output, "Size Validation", validation.valid ? "Icon!" : "IconX")

; ============================================================
; Example 7: File Size Monitor
; ============================================================

/**
 * Monitor file size and track changes
 * 
 * @param {String} filePath - File to monitor
 * @returns {Object} - Size tracking information
 */
class FileSizeMonitor {
    __New(filePath) {
        this.filePath := filePath
        this.history := []
        this.RecordSize()
    }

    RecordSize() {
        if (!FileExist(this.filePath))
            return false

        size := FileGetSize(this.filePath)
        this.history.Push({
            timestamp: A_Now,
            size: size,
            formatted: FormatFileSize(size)
        })
        return true
    }

    GetGrowth() {
        if (this.history.Length < 2)
            return 0

        first := this.history[1].size
        last := this.history[this.history.Length].size
        return last - first
    }

    GetReport() {
        if (this.history.Length = 0)
            return "No data recorded"

        report := "FILE SIZE HISTORY:`n`n"
        report .= "File: " this.filePath "`n`n"

        for entry in this.history {
            timestamp := FormatTime(entry.timestamp, "yyyy-MM-dd HH:mm:ss")
            report .= timestamp ": " entry.formatted "`n"
        }

        if (this.history.Length > 1) {
            growth := this.GetGrowth()
            report .= "`nTotal Growth: " FormatFileSize(Abs(growth))
            report .= (growth >= 0 ? " (increase)" : " (decrease)")
        }

        return report
    }
}

; Create monitor and track changes
monitor := FileSizeMonitor(largeFile)

; Append more data to file
Sleep(100)
FileAppend("`nAdditional line 1", largeFile)
monitor.RecordSize()

Sleep(100)
FileAppend("`nAdditional line 2", largeFile)
monitor.RecordSize()

; Display report
MsgBox(monitor.GetReport(), "Size Monitor", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILEGETSIZE() FUNCTION REFERENCE:

Syntax:
Size := FileGetSize(Filename [, Units])

Parameters:
Filename - Path to file
Units - Optional unit ('K' for KB, 'M' for MB)

Return Value:
Integer - File size in specified units

Units:
(omitted) - Bytes
'K' - Kilobytes (1024 bytes)
'M' - Megabytes (1024 * 1024 bytes)

Key Points:
• Returns size in bytes by default
• Rounds down for K and M units
• Returns 0 if file doesn't exist (check with FileExist first)
• Works only with files, not directories
• Size is actual disk usage
• May differ from allocation size

Size Conversions:
1 KB = 1,024 bytes
1 MB = 1,048,576 bytes
1 GB = 1,073,741,824 bytes

Common Use Cases:
✓ Check if file is empty
✓ Validate upload/download sizes
✓ Monitor file growth
✓ Calculate storage usage
✓ Compare file versions
✓ Disk space management
✓ Size-based file filtering

Best Practices:
• Check file exists first with FileExist()
• Format sizes for readability
• Use appropriate units for context
• Cache sizes for performance
• Track size changes over time
• Validate against size limits
• Consider compression ratios
)"

MsgBox(info, "FileGetSize() Reference", "Icon!")

; Cleanup
FileDelete(testFile)
FileDelete(largeFile)
DirDelete(testDir, true)
