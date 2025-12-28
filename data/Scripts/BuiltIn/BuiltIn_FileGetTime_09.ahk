#Requires AutoHotkey v2.0

/**
 * BuiltIn_FileGetTime_09.ahk
 * 
 * DESCRIPTION:
 * Basic usage of FileGetTime() to retrieve file timestamps
 * 
 * FEATURES:
 * - Get file modification time
 * - Get file creation time
 * - Get file access time
 * - Format timestamps
 * - Time comparisons
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetTime.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetTime() function
 * - FormatTime() for display
 * - DateDiff() for calculations
 * - Timestamp formats
 * - Time type parameters
 * 
 * LEARNING POINTS:
 * 1. FileGetTime() returns timestamp in YYYYMMDDHH24MISS format
 * 2. Three time types: M (modified), C (created), A (accessed)
 * 3. Default is modified time if type not specified
 * 4. Use FormatTime() to make timestamps readable
 * 5. Can compare timestamps directly as strings/numbers
 * 6. Essential for file management and organization
 */

; ============================================================
; Example 1: Basic Timestamp Retrieval
; ============================================================

; Create test file
testFile := A_ScriptDir "\timestamp_test.txt"
FileAppend("Test content for timestamp demo", testFile)

; Get all three timestamps
modifiedTime := FileGetTime(testFile, "M")
creationTime := FileGetTime(testFile, "C")
accessTime := FileGetTime(testFile, "A")

output := "FILE TIMESTAMPS:`n`n"
output .= "File: timestamp_test.txt`n`n"
output .= "Modified Time:`n"
output .= "  Raw: " modifiedTime "`n"
output .= "  Formatted: " FormatTime(modifiedTime, "yyyy-MM-dd HH:mm:ss") "`n`n"

output .= "Creation Time:`n"
output .= "  Raw: " creationTime "`n"
output .= "  Formatted: " FormatTime(creationTime, "yyyy-MM-dd HH:mm:ss") "`n`n"

output .= "Access Time:`n"
output .= "  Raw: " accessTime "`n"
output .= "  Formatted: " FormatTime(accessTime, "yyyy-MM-dd HH:mm:ss")

MsgBox(output, "Basic Timestamps", "Icon!")

; ============================================================
; Example 2: Timestamp Formatting Options
; ============================================================

/**
 * Get formatted file timestamp
 * 
 * @param {String} filePath - File path
 * @param {String} timeType - Time type (M/C/A)
 * @param {String} format - Format string
 * @returns {String} - Formatted timestamp
 */
GetFormattedTime(filePath, timeType := "M", format := "yyyy-MM-dd HH:mm:ss") {
    if (!FileExist(filePath))
        return "File not found"

    timestamp := FileGetTime(filePath, timeType)
    return FormatTime(timestamp, format)
}

; Test various formats
formats := [{
    name: "ISO 8601", format: "yyyy-MM-dd HH:mm:ss" }, {
        name: "US Format", format: "MM/dd/yyyy h:mm tt" }, {
            name: "Long Date", format: "dddd, MMMM d, yyyy" }, {
                name: "Short Date", format: "M/d/yy" }, {
                    name: "Time Only", format: "HH:mm:ss" }, {
                        name: "Relative", format: "ddd MMM d"
                    }
]

output := "TIMESTAMP FORMATS:`n`n"
for item in formats {
    formatted := GetFormattedTime(testFile, "M", item.format)
    output .= item.name ":`n  " formatted "`n`n"
}

MsgBox(output, "Format Options", "Icon!")

; ============================================================
; Example 3: Time Difference Calculation
; ============================================================

/**
 * Calculate age of file
 * 
 * @param {String} filePath - File path
 * @param {String} timeType - Time type to use
 * @returns {Object} - Age information
 */
GetFileAge(filePath, timeType := "M") {
    if (!FileExist(filePath))
        return { valid: false }

    timestamp := FileGetTime(filePath, timeType)

    ; Calculate differences
    daysDiff := DateDiff(A_Now, timestamp, "Days")
    hoursDiff := DateDiff(A_Now, timestamp, "Hours")
    minutesDiff := DateDiff(A_Now, timestamp, "Minutes")
    secondsDiff := DateDiff(A_Now, timestamp, "Seconds")

    return {
        valid: true,
        timestamp: timestamp,
        formatted: FormatTime(timestamp, "yyyy-MM-dd HH:mm:ss"),
        days: daysDiff,
        hours: hoursDiff,
        minutes: minutesDiff,
        seconds: secondsDiff
    }
}

/**
 * Format age as human-readable string
 * 
 * @param {Object} age - Age information
 * @returns {String} - Formatted age string
 */
FormatAge(age) {
    if (!age.valid)
        return "Unknown"

    if (age.days > 365)
        return Round(age.days / 365, 1) " years"
    if (age.days > 30)
        return Round(age.days / 30, 1) " months"
    if (age.days > 0)
        return age.days " days"
    if (age.hours > 0)
        return age.hours " hours"
    if (age.minutes > 0)
        return age.minutes " minutes"
    return age.seconds " seconds"
}

; Calculate file age
age := GetFileAge(testFile, "M")

output := "FILE AGE CALCULATION:`n`n"
output .= "File: timestamp_test.txt`n"
output .= "Modified: " age.formatted "`n`n"
output .= "Age: " FormatAge(age) " ago`n`n"
output .= "Detailed:`n"
output .= "  Days: " age.days "`n"
output .= "  Hours: " age.hours "`n"
output .= "  Minutes: " age.minutes "`n"
output .= "  Seconds: " age.seconds

MsgBox(output, "File Age", "Icon!")

; ============================================================
; Example 4: Comparing File Times
; ============================================================

/**
 * Compare timestamps of two files
 * 
 * @param {String} file1 - First file
 * @param {String} file2 - Second file
 * @param {String} timeType - Time type to compare
 * @returns {Object} - Comparison result
 */
CompareFileTimes(file1, file2, timeType := "M") {
    result := {
        file1: file1,
        file2: file2,
        time1: 0,
        time2: 0,
        newer: "",
        difference: 0
    }

    if (!FileExist(file1) || !FileExist(file2))
        return result

    time1 := FileGetTime(file1, timeType)
    time2 := FileGetTime(file2, timeType)

    result.time1 := time1
    result.time2 := time2

    if (time1 > time2) {
        result.newer := "file1"
        result.difference := DateDiff(time1, time2, "Seconds")
    } else if (time2 > time1) {
        result.newer := "file2"
        result.difference := DateDiff(time2, time1, "Seconds")
    } else {
        result.newer := "equal"
        result.difference := 0
    }

    return result
}

; Create second test file
testFile2 := A_ScriptDir "\timestamp_test2.txt"
Sleep(100)
FileAppend("Second test file", testFile2)

; Compare files
comparison := CompareFileTimes(testFile, testFile2, "M")

SplitPath(comparison.file1, &name1)
SplitPath(comparison.file2, &name2)

output := "TIMESTAMP COMPARISON:`n`n"
output .= name1 ":`n"
output .= "  " FormatTime(comparison.time1, "yyyy-MM-dd HH:mm:ss") "`n`n"

output .= name2 ":`n"
output .= "  " FormatTime(comparison.time2, "yyyy-MM-dd HH:mm:ss") "`n`n"

if (comparison.newer = "equal")
    output .= "Files have identical timestamps"
else
    output .= (comparison.newer = "file1" ? name1 : name2) . " is newer by "
        . comparison.difference . " seconds"

MsgBox(output, "Time Comparison", "Icon!")

; ============================================================
; Example 5: File Timeline Display
; ============================================================

/**
 * Get complete file timeline
 * 
 * @param {String} filePath - File path
 * @returns {Object} - Timeline information
 */
GetFileTimeline(filePath) {
    if (!FileExist(filePath))
        return { valid: false }

    created := FileGetTime(filePath, "C")
    modified := FileGetTime(filePath, "M")
    accessed := FileGetTime(filePath, "A")

    ; Determine which happened when
    timeline := {
        valid: true,
        created: {
            timestamp: created,
            formatted: FormatTime(created, "yyyy-MM-dd HH:mm:ss"),
            age: FormatAge(GetFileAge(filePath, "C"))
        },
        modified: {
            timestamp: modified,
            formatted: FormatTime(modified, "yyyy-MM-dd HH:mm:ss"),
            age: FormatAge(GetFileAge(filePath, "M"))
        },
        accessed: {
            timestamp: accessed,
            formatted: FormatTime(accessed, "yyyy-MM-dd HH:mm:ss"),
            age: FormatAge(GetFileAge(filePath, "A"))
        }
    }

    ; Calculate time between events
    timeline.createToModify := DateDiff(modified, created, "Seconds")
    timeline.modifyToAccess := DateDiff(accessed, modified, "Seconds")

    return timeline
}

; Get file timeline
timeline := GetFileTimeline(testFile)

output := "FILE TIMELINE:`n`n"
output .= "File: timestamp_test.txt`n`n"

output .= "Created:`n"
output .= "  " timeline.created.formatted "`n"
output .= "  (" timeline.created.age " ago)`n`n"

output .= "Last Modified:`n"
output .= "  " timeline.modified.formatted "`n"
output .= "  (" timeline.modified.age " ago)`n`n"

output .= "Last Accessed:`n"
output .= "  " timeline.accessed.formatted "`n"
output .= "  (" timeline.accessed.age " ago)`n`n"

if (timeline.createToModify > 0)
    output .= "Modified " timeline.createToModify " seconds after creation"
else
    output .= "Never modified since creation"

MsgBox(output, "File Timeline", "Icon!")

; ============================================================
; Example 6: Timestamp Validation
; ============================================================

/**
 * Validate file timestamp is within acceptable range
 * 
 * @param {String} filePath - File to check
 * @param {Object} criteria - Validation criteria
 * @returns {Object} - Validation result
 */
ValidateFileTime(filePath, criteria := "") {
    if (!criteria) {
        criteria := {
            timeType: "M",
            maxAge: 0,  ; Max age in days (0 = no limit)
            minAge: 0,  ; Min age in days (0 = no limit)
            after: "",  ; Must be after this timestamp
            before: ""  ; Must be before this timestamp
        }
    }

    result := {
        valid: false,
        timestamp: "",
        error: ""
    }

    if (!FileExist(filePath)) {
        result.error := "File does not exist"
        return result
    }

    timestamp := FileGetTime(filePath, criteria.timeType)
    result.timestamp := timestamp

    ; Check maximum age
    if (criteria.maxAge > 0) {
        age := DateDiff(A_Now, timestamp, "Days")
        if (age > criteria.maxAge) {
            result.error := "File too old (max: " criteria.maxAge " days)"
            return result
        }
    }

    ; Check minimum age
    if (criteria.minAge > 0) {
        age := DateDiff(A_Now, timestamp, "Days")
        if (age < criteria.minAge) {
            result.error := "File too new (min: " criteria.minAge " days)"
            return result
        }
    }

    ; Check after date
    if (criteria.after && timestamp < criteria.after) {
        result.error := "File timestamp before required date"
        return result
    }

    ; Check before date
    if (criteria.before && timestamp > criteria.before) {
        result.error := "File timestamp after required date"
        return result
    }

    result.valid := true
    return result
}

; Test validation
criteria := {
    timeType: "M",
    maxAge: 1,  ; Must be less than 1 day old
    minAge: 0,
    after: "",
    before: ""
}

validation := ValidateFileTime(testFile, criteria)

output := "TIMESTAMP VALIDATION:`n`n"
output .= "File: timestamp_test.txt`n"
output .= "Timestamp: " FormatTime(validation.timestamp, "yyyy-MM-dd HH:mm:ss") "`n"
output .= "Criteria: Max age 1 day`n`n"
output .= "Status: " (validation.valid ? "VALID ✓" : "INVALID ✗") "`n"
if (!validation.valid)
    output .= "Error: " validation.error

MsgBox(output, "Time Validation", validation.valid ? "Icon!" : "IconX")

; ============================================================
; Example 7: Batch Timestamp Retrieval
; ============================================================

/**
 * Get timestamps for multiple files
 * 
 * @param {Array} files - Array of file paths
 * @param {String} timeType - Time type to retrieve
 * @returns {Array} - Array of file time information
 */
GetBatchTimestamps(files, timeType := "M") {
    results := []

    for filePath in files {
        if (!FileExist(filePath))
            continue

        timestamp := FileGetTime(filePath, timeType)
        SplitPath(filePath, &name)

        results.Push({
            name: name,
            path: filePath,
            timestamp: timestamp,
            formatted: FormatTime(timestamp, "yyyy-MM-dd HH:mm:ss"),
            age: FormatAge(GetFileAge(filePath, timeType))
        })
    }

    return results
}

; Create additional test files
testFile3 := A_ScriptDir "\timestamp_test3.txt"
Sleep(100)
FileAppend("Third test file", testFile3)

; Get batch timestamps
batchFiles := [testFile, testFile2, testFile3]
timestamps := GetBatchTimestamps(batchFiles, "M")

output := "BATCH TIMESTAMP RETRIEVAL:`n`n"
output .= "Retrieved " timestamps.Length " file timestamps:`n`n"

for item in timestamps {
    output .= item.name ":`n"
    output .= "  Time: " item.formatted "`n"
    output .= "  Age: " item.age " ago`n`n"
}

MsgBox(output, "Batch Timestamps", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
                    (
                    FILEGETTIME() FUNCTION REFERENCE:

                    Syntax:
                    Timestamp := FileGetTime(Filename [, WhichTime])

                    Parameters:
                    Filename - Path to file
                    WhichTime - Optional: 'M' (modified), 'C' (created), 'A' (accessed)
                    Default is 'M' if omitted

                    Return Value:
                    String - Timestamp in YYYYMMDDHH24MISS format

                    Time Types:
                    M = Modified - When file content last changed
                    C = Created - When file was created
                    A = Accessed - When file was last opened/read

                    Timestamp Format:
                    YYYYMMDDHH24MISS
                    Example: 20240315143022 = March 15, 2024, 2:30:22 PM

                    Key Points:
                    • Returns empty string if file doesn't exist
                    • Timestamps are in local time
                    • Can be compared as strings or numbers
                    • Use FormatTime() to make readable
                    • Use DateDiff() to calculate age/difference
                    • Modified time updates when file changes
                    • Created time is set when file created
                    • Access time updates when file read (if enabled)

                    Common Use Cases:
                    ✓ Check file age
                    ✓ Sort files by date
                    ✓ Find recently modified files
                    ✓ Backup based on modification time
                    ✓ Compare file versions
                    ✓ Track file changes
                    ✓ Implement file retention policies

                    Best Practices:
                    • Use FormatTime() for display
                    • Cache timestamps for performance
                    • Check file exists first
                    • Consider timezone issues
                    • Note: Access time may be disabled on some systems
                    • Use appropriate time type for your needs
                    )"

MsgBox(info, "FileGetTime() Reference", "Icon!")

; Cleanup
FileDelete(testFile)
FileDelete(testFile2)
FileDelete(testFile3)
