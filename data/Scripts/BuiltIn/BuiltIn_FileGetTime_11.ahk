#Requires AutoHotkey v2.0

/**
 * BuiltIn_FileGetTime_11.ahk
 * 
 * DESCRIPTION:
 * Sorting files by date and timestamp-based organization
 * 
 * FEATURES:
 * - Sort files by modification time
 * - Sort by creation time
 * - Find newest/oldest files
 * - Time-based file ordering
 * - Chronological file listing
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetTime.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetTime() for sorting
 * - Array sorting algorithms
 * - Timestamp comparisons
 * - File organization
 * - Custom sort functions
 * 
 * LEARNING POINTS:
 * 1. Use FileGetTime() to get sort keys
 * 2. Compare timestamps for ordering
 * 3. Sort arrays of file information
 * 4. Find newest and oldest files
 * 5. Create chronological listings
 * 6. Implement custom sort orders
 */

; ============================================================
; Example 1: Sort Files by Modification Time
; ============================================================

/**
 * Get files sorted by modification time
 * 
 * @param {String} dirPath - Directory to scan
 * @param {Boolean} newestFirst - Sort order
 * @returns {Array} - Sorted file list
 */
GetFilesSortedByTime(dirPath, newestFirst := true) {
    files := []

    if (!DirExist(dirPath))
        return files

    ; Collect files with timestamps
    Loop Files, dirPath "\*.*", "F" {
        files.Push({
            name: A_LoopFileName,
            path: A_LoopFilePath,
            modified: FileGetTime(A_LoopFilePath, "M"),
            size: A_LoopFileSize
        })
    }

    ; Sort by timestamp
    Loop files.Length {
        outerIndex := A_Index
        Loop files.Length - outerIndex {
            innerIndex := A_Index
            shouldSwap := newestFirst
                ? (files[innerIndex].modified < files[innerIndex + 1].modified)
                : (files[innerIndex].modified > files[innerIndex + 1].modified)

            if (shouldSwap) {
                temp := files[innerIndex]
                files[innerIndex] := files[innerIndex + 1]
                files[innerIndex + 1] := temp
            }
        }
    }

    return files
}

; Create test files with delays
testDir := A_ScriptDir "\SortTest"
DirCreate(testDir)

Loop 5 {
    FileAppend("Content " A_Index, testDir "\file" A_Index ".txt")
    Sleep(100)
}

; Sort newest first
sorted := GetFilesSortedByTime(testDir, true)

output := "FILES SORTED BY TIME (Newest First):`n`n"
for file in sorted {
    output .= file.name "`n"
    output .= "  Modified: " FormatTime(file.modified, "yyyy-MM-dd HH:mm:ss") "`n"
    output .= "  Size: " file.size " bytes`n`n"
}

MsgBox(output, "Sorted Files", "Icon!")

; ============================================================
; Example 2: Find Newest and Oldest Files
; ============================================================

/**
 * Find newest and oldest files in directory
 * 
 * @param {String} dirPath - Directory to search
 * @param {String} timeType - Time type (M/C/A)
 * @returns {Object} - Newest and oldest files
 */
FindNewestOldest(dirPath, timeType := "M") {
    result := {
        newest: { name: "", timestamp: "", path: "" },
        oldest: { name: "", timestamp: "99999999999999", path: "" },
        found: false
    }

    if (!DirExist(dirPath))
        return result

    Loop Files, dirPath "\*.*", "F" {
        timestamp := FileGetTime(A_LoopFilePath, timeType)

        ; Check if newest
        if (timestamp > result.newest.timestamp) {
            result.newest.name := A_LoopFileName
            result.newest.timestamp := timestamp
            result.newest.path := A_LoopFilePath
        }

        ; Check if oldest
        if (timestamp < result.oldest.timestamp) {
            result.oldest.name := A_LoopFileName
            result.oldest.timestamp := timestamp
            result.oldest.path := A_LoopFilePath
        }

        result.found := true
    }

    return result
}

; Find newest and oldest
extremes := FindNewestOldest(testDir, "M")

if (extremes.found) {
    output := "NEWEST AND OLDEST FILES:`n`n"
    output .= "NEWEST:`n"
    output .= "  File: " extremes.newest.name "`n"
    output .= "  Modified: " FormatTime(extremes.newest.timestamp, "yyyy-MM-dd HH:mm:ss") "`n`n"

    output .= "OLDEST:`n"
    output .= "  File: " extremes.oldest.name "`n"
    output .= "  Modified: " FormatTime(extremes.oldest.timestamp, "yyyy-MM-dd HH:mm:ss") "`n`n"

    diff := DateDiff(extremes.newest.timestamp, extremes.oldest.timestamp, "Seconds")
    output .= "Time Span: " diff " seconds"

    MsgBox(output, "Extremes", "Icon!")
}

; ============================================================
; Example 3: Multi-Level Sorting
; ============================================================

/**
 * Sort files by timestamp, then by name
 * 
 * @param {String} dirPath - Directory to scan
 * @returns {Array} - Multi-level sorted files
 */
SortFilesMultiLevel(dirPath) {
    files := []

    if (!DirExist(dirPath))
        return files

    Loop Files, dirPath "\*.*", "F" {
        files.Push({
            name: A_LoopFileName,
            path: A_LoopFilePath,
            modified: FileGetTime(A_LoopFilePath, "M"),
            created: FileGetTime(A_LoopFilePath, "C")
        })
    }

    ; Sort by modified time, then by name
    Loop files.Length {
        outerIndex := A_Index
        Loop files.Length - outerIndex {
            innerIndex := A_Index
            f1 := files[innerIndex]
            f2 := files[innerIndex + 1]

            shouldSwap := false

            ; Primary sort: by modified time (newest first)
            if (f1.modified < f2.modified)
                shouldSwap := true
            ; Secondary sort: by name (if same time)
            else if (f1.modified = f2.modified && f1.name > f2.name)
                shouldSwap := true

            if (shouldSwap) {
                files[innerIndex] := f2
                files[innerIndex + 1] := f1
            }
        }
    }

    return files
}

; Multi-level sort
multiSorted := SortFilesMultiLevel(testDir)

output := "MULTI-LEVEL SORT (Time then Name):`n`n"
for file in multiSorted {
    output .= file.name "`n"
    output .= "  Modified: " FormatTime(file.modified, "HH:mm:ss") "`n`n"
}

MsgBox(output, "Multi-Level Sort", "Icon!")

; ============================================================
; Example 4: Top N Recent Files
; ============================================================

/**
 * Get top N most recently modified files
 * 
 * @param {String} dirPath - Directory to search
 * @param {Integer} count - Number of files to return
 * @returns {Array} - Top N recent files
 */
GetTopRecentFiles(dirPath, count := 5) {
    allFiles := GetFilesSortedByTime(dirPath, true)
    topFiles := []

    maxCount := Min(count, allFiles.Length)
    Loop maxCount
        topFiles.Push(allFiles[A_Index])

    return topFiles
}

; Get top 3 recent files
topRecent := GetTopRecentFiles(testDir, 3)

output := "TOP 3 RECENT FILES:`n`n"
for file in topRecent {
    output .= A_Index ". " file.name "`n"
    output .= "   Modified: " FormatTime(file.modified, "yyyy-MM-dd HH:mm:ss") "`n`n"
}

MsgBox(output, "Top Recent", "Icon!")

; ============================================================
; Example 5: Chronological File Listing
; ============================================================

/**
 * Create chronological listing with grouping
 * 
 * @param {String} dirPath - Directory to scan
 * @returns {Object} - Grouped chronological listing
 */
CreateChronologicalListing(dirPath) {
    listing := {
        today: [],
        yesterday: [],
        thisWeek: [],
        thisMonth: [],
        older: []
    }

    if (!DirExist(dirPath))
        return listing

    now := A_Now
    todayStart := FormatTime(now, "yyyyMMdd") . "000000"
    yesterdayStart := DateAdd(todayStart, -1, "Days")
    weekStart := DateAdd(now, -7, "Days")
    monthStart := DateAdd(now, -30, "Days")

    Loop Files, dirPath "\*.*", "F" {
        modified := FileGetTime(A_LoopFilePath, "M")
        fileInfo := {
            name: A_LoopFileName,
            path: A_LoopFilePath,
            modified: modified,
            formatted: FormatTime(modified, "HH:mm:ss")
        }

        if (modified >= todayStart)
            listing.today.Push(fileInfo)
        else if (modified >= yesterdayStart)
            listing.yesterday.Push(fileInfo)
        else if (modified >= weekStart)
            listing.thisWeek.Push(fileInfo)
        else if (modified >= monthStart)
            listing.thisMonth.Push(fileInfo)
        else
            listing.older.Push(fileInfo)
    }

    return listing
}

; Create listing
chronListing := CreateChronologicalListing(testDir)

output := "CHRONOLOGICAL LISTING:`n`n"

if (chronListing.today.Length > 0) {
    output .= "TODAY:`n"
    for file in chronListing.today
        output .= "  • " file.name " (" file.formatted ")`n"
    output .= "`n"
}

if (chronListing.yesterday.Length > 0) {
    output .= "YESTERDAY:`n"
    for file in chronListing.yesterday
        output .= "  • " file.name "`n"
    output .= "`n"
}

if (chronListing.thisWeek.Length > 0) {
    output .= "THIS WEEK:`n"
    for file in chronListing.thisWeek
        output .= "  • " file.name "`n"
    output .= "`n"
}

if (chronListing.older.Length > 0) {
    output .= "OLDER:`n"
    for file in chronListing.older
        output .= "  • " file.name "`n"
}

MsgBox(output, "Chronological", "Icon!")

; ============================================================
; Example 6: Sort by Creation vs Modification
; ============================================================

/**
 * Compare creation and modification order
 * 
 * @param {String} dirPath - Directory to analyze
 * @returns {Object} - Comparison results
 */
CompareCreationModification(dirPath) {
    files := []

    if (!DirExist(dirPath))
        return files

    Loop Files, dirPath "\*.*", "F" {
        created := FileGetTime(A_LoopFilePath, "C")
        modified := FileGetTime(A_LoopFilePath, "M")

        files.Push({
            name: A_LoopFileName,
            created: created,
            modified: modified,
            wasModified: (modified > created),
            timeDiff: DateDiff(modified, created, "Seconds")
        })
    }

    return files
}

; Compare times
comparison := CompareCreationModification(testDir)

output := "CREATION vs MODIFICATION:`n`n"
for file in comparison {
    output .= file.name ":`n"
    output .= "  Created: " FormatTime(file.created, "HH:mm:ss") "`n"
    output .= "  Modified: " FormatTime(file.modified, "HH:mm:ss") "`n"
    output .= "  Status: " (file.wasModified ? "Modified" : "Unchanged") "`n"
    if (file.wasModified)
        output .= "  Diff: " file.timeDiff " seconds`n"
    output .= "`n"
}

MsgBox(output, "Time Comparison", "Icon!")

; ============================================================
; Example 7: File Timeline View
; ============================================================

/**
 * Create timeline view of file modifications
 * 
 * @param {String} dirPath - Directory to analyze
 * @returns {String} - Timeline display
 */
CreateFileTimeline(dirPath) {
    files := GetFilesSortedByTime(dirPath, false)  ; Oldest first

    if (files.Length = 0)
        return "No files found"

    timeline := "FILE MODIFICATION TIMELINE:`n`n"

    for file in files {
        time := FormatTime(file.modified, "yyyy-MM-dd HH:mm:ss")
        timeline .= time " - " file.name "`n"
    }

    return timeline
}

; Create timeline
timeline := CreateFileTimeline(testDir)
MsgBox(timeline, "Timeline View", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
SORTING FILES BY TIME:

Basic Sort Pattern:
1. Collect files with timestamps
2. Compare timestamps
3. Swap if out of order
4. Repeat until sorted

Timestamp Comparison:
; Newer file first
if (time1 > time2)
file1 is newer

; Older file first
if (time1 < time2)
file1 is older

Common Sort Orders:
✓ Newest first (recent activity)
✓ Oldest first (chronological)
✓ Modified time (most common)
✓ Created time (original order)
✓ Accessed time (usage patterns)

Multi-Level Sorting:
1. Primary: By timestamp
2. Secondary: By name/size
3. Tertiary: Custom criteria

Use Cases:
✓ Recent files list
✓ Backup selection
✓ Log file rotation
✓ Activity monitoring
✓ Change tracking
✓ Version management

Performance Tips:
• Cache timestamps
• Sort smaller sets
• Use binary search
• Index for large sets
• Consider lazy loading

Best Practices:
• Choose appropriate time type
• Handle equal timestamps
• Consider timezone issues
• Document sort criteria
• Test edge cases
)"

MsgBox(info, "Sorting Reference", "Icon!")

; Cleanup
DirDelete(testDir, true)
