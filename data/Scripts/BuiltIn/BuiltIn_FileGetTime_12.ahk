#Requires AutoHotkey v2.0

/**
* BuiltIn_FileGetTime_12.ahk
*
* DESCRIPTION:
* Advanced timestamp operations and time-based automation
*
* FEATURES:
* - Timestamp arithmetic
* - Time-based triggers
* - Scheduled file operations
* - Timestamp synchronization
* - Time-based automation
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/FileGetTime.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - FileGetTime() for automation
* - FileSetTime() for modification
* - DateAdd() and DateDiff()
* - Timestamp manipulation
* - Automated scheduling
*
* LEARNING POINTS:
* 1. Perform timestamp arithmetic
* 2. Trigger actions based on file time
* 3. Synchronize file timestamps
* 4. Implement time-based automation
* 5. Schedule file operations
* 6. Track file modification patterns
*/

; ============================================================
; Example 1: Timestamp Arithmetic
; ============================================================

/**
* Calculate future/past timestamps relative to file
*
* @param {String} filePath - File to use as reference
* @param {Integer} offset - Days to add/subtract
* @returns {Object} - Calculated timestamps
*/
CalculateRelativeTimestamp(filePath, offset) {
    if (!FileExist(filePath))
    return {valid: false}

    fileTime := FileGetTime(filePath, "M")
    futureTime := DateAdd(fileTime, offset, "Days")
    pastTime := DateAdd(fileTime, -offset, "Days")

    return {
        valid: true,
        original: FormatTime(fileTime, "yyyy-MM-dd HH:mm:ss"),
        future: FormatTime(futureTime, "yyyy-MM-dd HH:mm:ss"),
        past: FormatTime(pastTime, "yyyy-MM-dd HH:mm:ss"),
        offsetDays: offset
    }
}

; Create test file
testFile := A_ScriptDir "\timestamp_calc.txt"
FileAppend("Test content", testFile)

; Calculate relative timestamps
calc := CalculateRelativeTimestamp(testFile, 7)

if (calc.valid) {
    output := "TIMESTAMP ARITHMETIC:`n`n"
    output .= "Original: " calc.original "`n"
    output .= "+" calc.offsetDays " days: " calc.future "`n"
    output .= "-" calc.offsetDays " days: " calc.past

    MsgBox(output, "Timestamp Calc", "Icon!")
}

; ============================================================
; Example 2: Time-Based File Trigger
; ============================================================

/**
* Check if file should trigger action based on time
*
* @param {String} filePath - File to check
* @param {Object} trigger - Trigger conditions
* @returns {Object} - Trigger status
*/
CheckTimeTrigger(filePath, trigger) {
    result := {
        shouldTrigger: false,
        reason: ""
    }

    if (!FileExist(filePath)) {
        result.reason := "File not found"
        return result
    }

    fileTime := FileGetTime(filePath, trigger.timeType)
    ageDays := DateDiff(A_Now, fileTime, "Days")

    ; Check if file age meets trigger condition
    if (trigger.HasOwnProp("olderThan") && ageDays >= trigger.olderThan) {
        result.shouldTrigger := true
        result.reason := "File is " ageDays " days old (threshold: " trigger.olderThan ")"
    } else if (trigger.HasOwnProp("newerThan") && ageDays < trigger.newerThan) {
        result.shouldTrigger := true
        result.reason := "File is only " ageDays " days old (threshold: " trigger.newerThan ")"
    }

    return result
}

; Test trigger
trigger := {
    timeType: "M",
    olderThan: 0  ; Trigger if any age (for demo)
}

triggerStatus := CheckTimeTrigger(testFile, trigger)

output := "TIME-BASED TRIGGER:`n`n"
output .= "File: timestamp_calc.txt`n"
output .= "Should Trigger: " (triggerStatus.shouldTrigger ? "YES" : "NO") "`n"
output .= "Reason: " triggerStatus.reason

MsgBox(output, "Trigger Check", triggerStatus.shouldTrigger ? "Icon!" : "IconX")

; ============================================================
; Example 3: Scheduled File Actions
; ============================================================

/**
* Determine if scheduled action should run
*
* @param {String} filePath - File to check
* @param {String} schedule - Schedule type
* @returns {Boolean} - Should run now
*/
ShouldRunScheduledAction(filePath, schedule := "daily") {
    if (!FileExist(filePath))
    return false

    lastModified := FileGetTime(filePath, "M")
    hoursSince := DateDiff(A_Now, lastModified, "Hours")

    switch schedule {
        case "hourly":
        return hoursSince >= 1
        case "daily":
        return hoursSince >= 24
        case "weekly":
        return hoursSince >= 168
        case "monthly":
        return hoursSince >= 720
        default:
        return false
    }
}

; Test schedule
schedules := ["hourly", "daily", "weekly"]

output := "SCHEDULED ACTIONS:`n`n"
output .= "File: timestamp_calc.txt`n`n"

for schedule in schedules {
    shouldRun := ShouldRunScheduledAction(testFile, schedule)
    output .= schedule . ": " . (shouldRun ? "RUN NOW" : "Skip") "`n"
}

MsgBox(output, "Schedule Check", "Icon!")

; ============================================================
; Example 4: Timestamp Synchronization
; ============================================================

/**
* Synchronize timestamps between files
*
* @param {String} sourceFile - File to copy timestamp from
* @param {Array} targetFiles - Files to update
* @param {String} timeType - Time type to sync
* @returns {Object} - Sync results
*/
SynchronizeTimestamps(sourceFile, targetFiles, timeType := "M") {
    result := {
        success: false,
        sourceTime: "",
        updated: 0,
        failed: 0
    }

    if (!FileExist(sourceFile))
    return result

    sourceTime := FileGetTime(sourceFile, timeType)
    result.sourceTime := FormatTime(sourceTime, "yyyy-MM-dd HH:mm:ss")

    for targetFile in targetFiles {
        if (!FileExist(targetFile)) {
            result.failed++
            continue
        }

        try {
            FileSetTime(sourceTime, targetFile, timeType)
            result.updated++
        } catch {
            result.failed++
        }
    }

    result.success := (result.updated > 0)
    return result
}

; Create target files
target1 := A_ScriptDir "\target1.txt"
target2 := A_ScriptDir "\target2.txt"
FileAppend("Target 1", target1)
FileAppend("Target 2", target2)

; Synchronize timestamps
syncResult := SynchronizeTimestamps(testFile, [target1, target2], "M")

output := "TIMESTAMP SYNCHRONIZATION:`n`n"
output .= "Source Time: " syncResult.sourceTime "`n"
output .= "Files Updated: " syncResult.updated "`n"
output .= "Failed: " syncResult.failed

MsgBox(output, "Timestamp Sync", syncResult.success ? "Icon!" : "IconX")

; ============================================================
; Example 5: Modification Pattern Detection
; ============================================================

/**
* Detect modification pattern by tracking changes
*/
class ModificationTracker {
    __New(filePath) {
        this.filePath := filePath
        this.snapshots := []
        this.RecordSnapshot()
    }

    RecordSnapshot() {
        if (!FileExist(this.filePath))
        return false

        this.snapshots.Push({
            time: A_Now,
            modified: FileGetTime(this.filePath, "M"),
            size: FileGetSize(this.filePath)
        })
        return true
    }

    DetectPattern() {
        if (this.snapshots.Length < 2)
        return "Insufficient data"

        intervals := []

        Loop this.snapshots.Length - 1 {
            current := this.snapshots[A_Index]
            next := this.snapshots[A_Index + 1]

            if (current.modified != next.modified) {
                interval := DateDiff(next.time, current.time, "Minutes")
                intervals.Push(interval)
            }
        }

        if (intervals.Length = 0)
        return "No modifications detected"

        ; Calculate average interval
        total := 0
        for interval in intervals
        total += interval

        avgInterval := Round(total / intervals.Length)

        if (avgInterval < 5)
        return "Frequent modifications (< 5 min)"
        else if (avgInterval < 60)
        return "Regular modifications (" avgInterval " min avg)"
        else if (avgInterval < 1440)
        return "Hourly modifications (" Round(avgInterval/60) " hr avg)"
        else
        return "Daily modifications (" Round(avgInterval/1440) " days avg)"
    }

    GetReport() {
        report := "MODIFICATION TRACKER:`n`n"
        report .= "File: " this.filePath "`n"
        report .= "Snapshots: " this.snapshots.Length "`n`n"

        report .= "Pattern: " this.DetectPattern() "`n`n"

        report .= "History:`n"
        for snapshot in this.snapshots {
            report .= FormatTime(snapshot.time, "HH:mm:ss") . " - "
            report .= FormatTime(snapshot.modified, "HH:mm:ss")
            report .= " (" snapshot.size " bytes)`n"
        }

        return report
    }
}

; Track modifications
tracker := ModificationTracker(testFile)
Sleep(100)
tracker.RecordSnapshot()
Sleep(100)
FileAppend("`nNew line", testFile)
Sleep(100)
tracker.RecordSnapshot()

MsgBox(tracker.GetReport(), "Modification Tracking", "Icon!")

; ============================================================
; Example 6: Time-Based File Rotation
; ============================================================

/**
* Rotate files based on time criteria
*
* @param {String} filePath - File to rotate
* @param {Integer} maxAgeDays - Maximum age before rotation
* @returns {Object} - Rotation result
*/
RotateFileByAge(filePath, maxAgeDays) {
    result := {
        rotated: false,
        newPath: "",
        reason: ""
    }

    if (!FileExist(filePath)) {
        result.reason := "File not found"
        return result
    }

    fileTime := FileGetTime(filePath, "M")
    ageDays := DateDiff(A_Now, fileTime, "Days")

    if (ageDays < maxAgeDays) {
        result.reason := "File not old enough (" ageDays "/" maxAgeDays " days)"
        return result
    }

    ; Create rotated filename with timestamp
    SplitPath(filePath, &fileName, &fileDir, &fileExt, &fileNameNoExt)
    timestamp := FormatTime(fileTime, "yyyyMMdd_HHmmss")
    rotatedPath := fileDir "\" fileNameNoExt "_" timestamp "." fileExt

    try {
        FileCopy(filePath, rotatedPath, false)
        FileDelete(filePath)
        FileAppend("", filePath)  ; Create new empty file

        result.rotated := true
        result.newPath := rotatedPath
        result.reason := "File rotated successfully"
    } catch Error as err {
        result.reason := "Rotation failed: " err.Message
    }

    return result
}

; Test rotation
rotation := RotateFileByAge(testFile, 0)  ; Rotate immediately for demo

output := "FILE ROTATION:`n`n"
output .= "Original: timestamp_calc.txt`n"
output .= "Rotated: " (rotation.rotated ? "YES" : "NO") "`n"
output .= "Reason: " rotation.reason "`n"
if (rotation.rotated)
output .= "`nNew File: " rotation.newPath

MsgBox(output, "File Rotation", rotation.rotated ? "Icon!" : "IconX")

; ============================================================
; Example 7: Timestamp-Based Workflow
; ============================================================

/**
* Execute workflow based on file timestamps
*
* @param {String} inputFile - Input file
* @param {String} outputFile - Output file
* @returns {Object} - Workflow result
*/
TimestampBasedWorkflow(inputFile, outputFile) {
    result := {
        executed: false,
        reason: ""
    }

    ; Check if input exists
    if (!FileExist(inputFile)) {
        result.reason := "Input file not found"
        return result
    }

    inputTime := FileGetTime(inputFile, "M")

    ; Check if output exists and is newer
    if (FileExist(outputFile)) {
        outputTime := FileGetTime(outputFile, "M")

        if (outputTime >= inputTime) {
            result.reason := "Output is up-to-date (input not modified)"
            return result
        }
    }

    ; Execute workflow (input is newer or output doesn't exist)
    try {
        content := FileRead(inputFile)
        processed := StrUpper(content)  ; Simple processing
        FileDelete(outputFile)
        FileAppend(processed, outputFile)

        result.executed := true
        result.reason := "Workflow executed successfully"
    } catch Error as err {
        result.reason := "Workflow failed: " err.Message
    }

    return result
}

; Test workflow
inputFile := A_ScriptDir "\input.txt"
outputFile := A_ScriptDir "\output.txt"

FileAppend("workflow input content", inputFile)

workflow := TimestampBasedWorkflow(inputFile, outputFile)

output := "TIMESTAMP-BASED WORKFLOW:`n`n"
output .= "Input: input.txt`n"
output .= "Output: output.txt`n`n"
output .= "Executed: " (workflow.executed ? "YES" : "NO") "`n"
output .= "Reason: " workflow.reason

MsgBox(output, "Workflow", workflow.executed ? "Icon!" : "IconX")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED TIMESTAMP OPERATIONS:

Timestamp Arithmetic:
future := DateAdd(timestamp, 7, 'Days')
past := DateAdd(timestamp, -30, 'Days')
diff := DateDiff(time1, time2, 'Hours')

Time-Based Triggers:
• Age-based (older than X days)
• Schedule-based (every X hours)
• Change-based (modified since last)
• Pattern-based (regular intervals)

Synchronization:
sourceTime := FileGetTime(source, 'M')
FileSetTime(sourceTime, target, 'M')

Common Automation:
✓ Log rotation
✓ Cache invalidation
✓ Backup triggers
✓ Build systems
✓ Data synchronization
✓ Scheduled cleanup

Workflow Patterns:
1. Check input timestamp
2. Check output timestamp
3. Execute if input newer
4. Update output timestamp

Best Practices:
• Use timestamps for cache validation
• Implement rotation policies
• Track modification patterns
• Automate based on age
• Sync related files
• Log timestamp changes
• Handle timezone issues

Performance:
• Cache timestamp values
• Batch timestamp operations
• Use efficient comparisons
• Minimize FileGetTime calls
)"

MsgBox(info, "Advanced Timestamps Reference", "Icon!")

; Cleanup
FileDelete(testFile)
FileDelete(target1)
FileDelete(target2)
FileDelete(inputFile)
FileDelete(outputFile)

; Clean up rotated files
Loop Files, A_ScriptDir "\timestamp_calc_*.txt"
FileDelete(A_LoopFilePath)
