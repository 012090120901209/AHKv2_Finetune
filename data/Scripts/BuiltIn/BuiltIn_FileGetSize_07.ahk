#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_FileGetSize_07.ahk
 * 
 * DESCRIPTION:
 * Disk usage analysis and storage management using FileGetSize()
 * 
 * FEATURES:
 * - Directory space analysis
 * - Disk usage reports
 * - Storage quota monitoring
 * - Large file detection
 * - Space optimization suggestions
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetSize.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetSize() for analysis
 * - Loop Files for directory traversal
 * - Recursive size calculation
 * - Data aggregation
 * - Storage statistics
 * 
 * LEARNING POINTS:
 * 1. Calculate total directory sizes recursively
 * 2. Identify space-consuming files
 * 3. Generate storage usage reports
 * 4. Implement quota systems
 * 5. Track storage trends
 * 6. Optimize disk space usage
 */

; Helper function for formatting
FormatSize(bytes) {
    if (bytes < 1024)
        return bytes " B"
    if (bytes < 1024 * 1024)
        return Round(bytes / 1024, 2) " KB"
    if (bytes < 1024 * 1024 * 1024)
        return Round(bytes / (1024 * 1024), 2) " MB"
    return Round(bytes / (1024 * 1024 * 1024), 2) " GB"
}

; ============================================================
; Example 1: Comprehensive Directory Analysis
; ============================================================

/**
 * Analyze directory storage usage in detail
 * 
 * @param {String} dirPath - Directory to analyze
 * @param {Boolean} recursive - Include subdirectories
 * @returns {Object} - Detailed analysis results
 */
AnalyzeDirectoryUsage(dirPath, recursive := true) {
    analysis := {
        path: dirPath,
        totalSize: 0,
        fileCount: 0,
        dirCount: 0,
        largestFile: { path: "", size: 0 },
        smallestFile: { path: "", size: 999999999999 },
        extensions: Map(),
        subdirs: []
    }

    if (!DirExist(dirPath))
        return analysis

    ; Analyze files
    recurseFlag := recursive ? "FR" : "F"
    Loop Files, dirPath "\*.*", recurseFlag {
        fileSize := A_LoopFileSize
        analysis.totalSize += fileSize
        analysis.fileCount++

        ; Track largest file
        if (fileSize > analysis.largestFile.size) {
            analysis.largestFile.size := fileSize
            analysis.largestFile.path := A_LoopFilePath
        }

        ; Track smallest file
        if (fileSize < analysis.smallestFile.size) {
            analysis.smallestFile.size := fileSize
            analysis.smallestFile.path := A_LoopFilePath
        }

        ; Track by extension
        SplitPath(A_LoopFilePath, , , &ext)
        if (!ext)
            ext := "(no extension)"

        if (!analysis.extensions.Has(ext))
            analysis.extensions[ext] := { count: 0, totalSize: 0 }

        extData := analysis.extensions[ext]
        extData.count++
        extData.totalSize += fileSize
    }

    ; Count subdirectories
    if (recursive) {
        Loop Files, dirPath "\*.*", "DR"
            analysis.dirCount++
    }

    return analysis
}

; Create test directory structure
testDir := A_ScriptDir "\DiskAnalysis"
DirCreate(testDir)
DirCreate(testDir "\Subdir1")
DirCreate(testDir "\Subdir2")

; Create files of various sizes and types
FileAppend("Small file", testDir "\small.txt")

mediumContent := ""
Loop 1000
    mediumContent .= "Medium file content line " A_Index "`n"
FileAppend(mediumContent, testDir "\medium.log")

largeContent := ""
Loop 5000
    largeContent .= "Large file data " A_Index "`n"
FileAppend(largeContent, testDir "\Subdir1\large.dat")

FileAppend("Data", testDir "\Subdir2\data.csv")

; Analyze directory
analysis := AnalyzeDirectoryUsage(testDir, true)

output := "DIRECTORY USAGE ANALYSIS:`n`n"
output .= "Path: " analysis.path "`n"
output .= "Total Size: " FormatSize(analysis.totalSize) "`n"
output .= "Files: " analysis.fileCount "`n"
output .= "Subdirectories: " analysis.dirCount "`n`n"

output .= "Largest File:`n"
output .= "  " FormatSize(analysis.largestFile.size) "`n"
SplitPath(analysis.largestFile.path, &largestName)
output .= "  " largestName "`n`n"

output .= "Smallest File:`n"
output .= "  " FormatSize(analysis.smallestFile.size) "`n"
SplitPath(analysis.smallestFile.path, &smallestName)
output .= "  " smallestName "`n`n"

output .= "By Extension:`n"
for ext, data in analysis.extensions {
    output .= "  ." ext ": " data.count " files, "
    output .= FormatSize(data.totalSize) "`n"
}

MsgBox(output, "Disk Analysis", "Icon!")

; ============================================================
; Example 2: Large File Detector
; ============================================================

/**
 * Find files larger than specified size
 * 
 * @param {String} dirPath - Directory to search
 * @param {Integer} minSizeBytes - Minimum file size
 * @param {Integer} maxResults - Maximum results to return
 * @returns {Array} - Array of large files
 */
FindLargeFiles(dirPath, minSizeBytes := 1024 * 1024, maxResults := 10) {
    largeFiles := []

    if (!DirExist(dirPath))
        return largeFiles

    ; Collect all files with sizes
    allFiles := []
    Loop Files, dirPath "\*.*", "FR" {
        if (A_LoopFileSize >= minSizeBytes) {
            allFiles.Push({
                path: A_LoopFilePath,
                name: A_LoopFileName,
                size: A_LoopFileSize,
                dir: A_LoopFileDir
            })
        }
    }

    ; Sort by size (largest first)
    Loop allFiles.Length {
        outerIndex := A_Index
        Loop allFiles.Length - outerIndex {
            innerIndex := A_Index
            if (allFiles[innerIndex].size < allFiles[innerIndex + 1].size) {
                temp := allFiles[innerIndex]
                allFiles[innerIndex] := allFiles[innerIndex + 1]
                allFiles[innerIndex + 1] := temp
            }
        }
    }

    ; Return top N results
    count := Min(maxResults, allFiles.Length)
    Loop count
        largeFiles.Push(allFiles[A_Index])

    return largeFiles
}

; Find large files
minSize := 1024 * 10  ; 10 KB threshold for demo
largeFiles := FindLargeFiles(testDir, minSize, 5)

output := "LARGE FILE REPORT:`n`n"
output .= "Threshold: " FormatSize(minSize) "`n"
output .= "Found: " largeFiles.Length " files`n`n"

for file in largeFiles {
    output .= file.name "`n"
    output .= "  Size: " FormatSize(file.size) "`n"
    output .= "  Location: " file.dir "`n`n"
}

MsgBox(output, "Large Files", "Icon!")

; ============================================================
; Example 3: Storage Quota Monitor
; ============================================================

/**
 * Monitor directory size against quota
 * 
 * @param {String} dirPath - Directory to monitor
 * @param {Integer} quotaBytes - Quota limit in bytes
 * @returns {Object} - Quota status
 */
CheckStorageQuota(dirPath, quotaBytes) {
    status := {
        currentSize: 0,
        quota: quotaBytes,
        percentUsed: 0,
        remaining: 0,
        exceeded: false,
        status: "OK"
    }

    if (!DirExist(dirPath))
        return status

    ; Calculate current usage
    Loop Files, dirPath "\*.*", "FR"
        status.currentSize += A_LoopFileSize

    ; Calculate metrics
    status.percentUsed := (status.currentSize / Float(quotaBytes)) * 100
    status.remaining := quotaBytes - status.currentSize
    status.exceeded := status.currentSize > quotaBytes

    ; Determine status
    if (status.exceeded)
        status.status := "EXCEEDED"
    else if (status.percentUsed > 90)
        status.status := "CRITICAL"
    else if (status.percentUsed > 75)
        status.status := "WARNING"
    else
        status.status := "OK"

    return status
}

; Check quota
quota := 1024 * 200  ; 200 KB quota
quotaStatus := CheckStorageQuota(testDir, quota)

; Create progress bar
percentFilled := Round(quotaStatus.percentUsed)
barWidth := 40
filled := Round((percentFilled / 100) * barWidth)

progressBar := "["
Loop barWidth {
    progressBar .= (A_Index <= filled) ? "█" : "░"
}
progressBar .= "]"

output := "STORAGE QUOTA MONITOR:`n`n"
output .= "Directory: " testDir "`n"
output .= "Quota: " FormatSize(quotaStatus.quota) "`n`n"
output .= "Current Usage:`n"
output .= "  " FormatSize(quotaStatus.currentSize) " / "
output .= FormatSize(quotaStatus.quota) "`n`n"
output .= progressBar " " Round(quotaStatus.percentUsed, 1) "%`n`n"
output .= "Status: " quotaStatus.status "`n"
output .= "Remaining: " FormatSize(quotaStatus.remaining)

MsgBox(output, "Quota Monitor", quotaStatus.exceeded ? "IconX" : "Icon!")

; ============================================================
; Example 4: Directory Size Comparison
; ============================================================

/**
 * Compare sizes of multiple directories
 * 
 * @param {Array} directories - Array of directory paths
 * @returns {Array} - Sorted directory information
 */
CompareDirectorySizes(directories) {
    results := []

    for dirPath in directories {
        totalSize := 0
        fileCount := 0

        if (DirExist(dirPath)) {
            Loop Files, dirPath "\*.*", "FR" {
                totalSize += A_LoopFileSize
                fileCount++
            }
        }

        SplitPath(dirPath, &dirName)
        results.Push({
            path: dirPath,
            name: dirName,
            size: totalSize,
            files: fileCount
        })
    }

    ; Sort by size (largest first)
    Loop results.Length {
        outerIndex := A_Index
        Loop results.Length - outerIndex {
            innerIndex := A_Index
            if (results[innerIndex].size < results[innerIndex + 1].size) {
                temp := results[innerIndex]
                results[innerIndex] := results[innerIndex + 1]
                results[innerIndex + 1] := temp
            }
        }
    }

    return results
}

; Compare subdirectories
dirs := [
    testDir "\Subdir1",
    testDir "\Subdir2"
]

comparison := CompareDirectorySizes(dirs)

output := "DIRECTORY SIZE COMPARISON:`n`n"
for dir in comparison {
    output .= dir.name ":`n"
    output .= "  Size: " FormatSize(dir.size) "`n"
    output .= "  Files: " dir.files "`n`n"
}

MsgBox(output, "Size Comparison", "Icon!")

; ============================================================
; Example 5: File Type Space Analysis
; ============================================================

/**
 * Analyze disk usage by file type
 * 
 * @param {String} dirPath - Directory to analyze
 * @returns {Array} - Usage by file type, sorted
 */
AnalyzeSpaceByType(dirPath) {
    types := Map()
    totalSize := 0

    if (!DirExist(dirPath))
        return []

    ; Collect data by extension
    Loop Files, dirPath "\*.*", "FR" {
        totalSize += A_LoopFileSize

        SplitPath(A_LoopFilePath, , , &ext)
        if (!ext)
            ext := "(no extension)"

        if (!types.Has(ext))
            types[ext] := { count: 0, size: 0 }

        extData := types[ext]
        extData.count++
        extData.size += A_LoopFileSize
    }

    ; Convert to array and add percentages
    results := []
    for ext, data in types {
        percent := (data.size / Float(totalSize)) * 100
        results.Push({
            extension: ext,
            count: data.count,
            size: data.size,
            percent: percent
        })
    }

    ; Sort by size
    Loop results.Length {
        outerIndex := A_Index
        Loop results.Length - outerIndex {
            innerIndex := A_Index
            if (results[innerIndex].size < results[innerIndex + 1].size) {
                temp := results[innerIndex]
                results[innerIndex] := results[innerIndex + 1]
                results[innerIndex + 1] := temp
            }
        }
    }

    return results
}

; Analyze by type
typeAnalysis := AnalyzeSpaceByType(testDir)

output := "SPACE USAGE BY FILE TYPE:`n`n"
for item in typeAnalysis {
    output .= "." item.extension ":`n"
    output .= "  Files: " item.count "`n"
    output .= "  Size: " FormatSize(item.size) "`n"
    output .= "  Percentage: " Round(item.percent, 1) "%`n`n"
}

MsgBox(output, "Type Analysis", "Icon!")

; ============================================================
; Example 6: Disk Space Trend Tracker
; ============================================================

/**
 * Track directory size over time
 */
class DiskUsageTracker {
    __New(dirPath) {
        this.dirPath := dirPath
        this.snapshots := []
    }

    TakeSnapshot() {
        totalSize := 0
        fileCount := 0

        if (DirExist(this.dirPath)) {
            Loop Files, this.dirPath "\*.*", "FR" {
                totalSize += A_LoopFileSize
                fileCount++
            }
        }

        this.snapshots.Push({
            timestamp: A_Now,
            size: totalSize,
            files: fileCount
        })
    }

    GetGrowthRate() {
        if (this.snapshots.Length < 2)
            return 0

        first := this.snapshots[1]
        last := this.snapshots[this.snapshots.Length]

        return last.size - first.size
    }

    GetReport() {
        if (this.snapshots.Length = 0)
            return "No snapshots recorded"

        report := "DISK USAGE TREND:`n`n"
        report .= "Directory: " this.dirPath "`n`n"

        for snapshot in this.snapshots {
            time := FormatTime(snapshot.timestamp, "yyyy-MM-dd HH:mm:ss")
            report .= time ":`n"
            report .= "  Size: " FormatSize(snapshot.size) "`n"
            report .= "  Files: " snapshot.files "`n`n"
        }

        if (this.snapshots.Length > 1) {
            growth := this.GetGrowthRate()
            report .= "Total Growth: " FormatSize(Abs(growth))
            report .= (growth >= 0 ? " (increased)" : " (decreased)")
        }

        return report
    }
}

; Track usage
tracker := DiskUsageTracker(testDir)
tracker.TakeSnapshot()

; Simulate adding file
Sleep(100)
FileAppend("New content", testDir "\newfile.txt")
tracker.TakeSnapshot()

; Display trend
MsgBox(tracker.GetReport(), "Usage Trends", "Icon!")

; ============================================================
; Example 7: Space Optimization Suggestions
; ============================================================

/**
 * Generate space optimization suggestions
 * 
 * @param {String} dirPath - Directory to analyze
 * @returns {Array} - Optimization suggestions
 */
GetOptimizationSuggestions(dirPath) {
    suggestions := []

    if (!DirExist(dirPath))
        return suggestions

    ; Check for duplicate files
    fileHashes := Map()
    duplicates := 0

    Loop Files, dirPath "\*.*", "FR" {
        size := A_LoopFileSize
        if (fileHashes.Has(size)) {
            duplicates++
        } else {
            fileHashes[size] := true
        }
    }

    if (duplicates > 0) {
        suggestions.Push({
            type: "Duplicates",
            message: duplicates " potential duplicate files found",
            savings: "Unknown"
        })
    }

    ; Check for old files (simulated)
    oldFiles := 0
    oldSize := 0
    cutoffTime := DateAdd(A_Now, -90, "Days")

    Loop Files, dirPath "\*.*", "FR" {
        if (A_LoopFileTimeModified < cutoffTime) {
            oldFiles++
            oldSize += A_LoopFileSize
        }
    }

    if (oldFiles > 0) {
        suggestions.Push({
            type: "Old Files",
            message: oldFiles " files older than 90 days",
            savings: FormatSize(oldSize)
        })
    }

    return suggestions
}

; Get suggestions
suggestions := GetOptimizationSuggestions(testDir)

output := "SPACE OPTIMIZATION:`n`n"
if (suggestions.Length > 0) {
    for suggestion in suggestions {
        output .= "• " suggestion.type ":`n"
        output .= "  " suggestion.message "`n"
        output .= "  Potential savings: " suggestion.savings "`n`n"
    }
} else {
    output .= "No optimization suggestions at this time."
}

MsgBox(output, "Optimization", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
DISK USAGE ANALYSIS:

Key Techniques:
1. Recursive Size Calculation
Loop Files, path '\*.*', 'FR'
Sum all A_LoopFileSize values

2. Extension Analysis
Group by extension
Calculate totals per type

3. Large File Detection
Filter by size threshold
Sort descending

4. Quota Monitoring
Compare against limits
Track percentage used

Common Use Cases:
✓ Storage reports
✓ Cleanup automation
✓ Quota enforcement
✓ Backup planning
✓ Capacity planning
✓ Cost optimization

Best Practices:
• Cache results for performance
• Use recursive flags wisely
• Handle access denied errors
• Consider symbolic links
• Track trends over time
• Set appropriate thresholds
• Automate regular checks

Performance Tips:
• Limit recursion depth
• Filter early
• Use appropriate intervals
• Batch operations
• Cache frequently accessed data
)"

MsgBox(info, "Disk Analysis Reference", "Icon!")

; Cleanup
DirDelete(testDir, true)
