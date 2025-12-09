#Requires AutoHotkey v2.0

/**
* BuiltIn_FileGetTime_10.ahk
*
* DESCRIPTION:
* File age checking and time-based file management
*
* FEATURES:
* - Find old/new files
* - Age-based filtering
* - Retention policies
* - Cleanup automation
* - File freshness checking
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/FileGetTime.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - FileGetTime() for age checking
* - DateDiff() for age calculation
* - DateAdd() for date arithmetic
* - Time-based filtering
* - Automated cleanup
*
* LEARNING POINTS:
* 1. Calculate file age using DateDiff()
* 2. Filter files by age criteria
* 3. Implement retention policies
* 4. Automate time-based cleanup
* 5. Find recently modified files
* 6. Track file freshness
*/

; Helper functions
FormatAge(days) {
    if (days > 365)
    return Round(days / 365, 1) " years"
    if (days > 30)
    return Round(days / 30, 1) " months"
    return days " days"
}

; ============================================================
; Example 1: Find Old Files
; ============================================================

/**
* Find files older than specified days
*
* @param {String} dirPath - Directory to search
* @param {Integer} olderThanDays - Age threshold in days
* @param {String} timeType - Time type to check (M/C/A)
* @returns {Array} - Old files found
*/
FindOldFiles(dirPath, olderThanDays, timeType := "M") {
    oldFiles := []

    if (!DirExist(dirPath))
    return oldFiles

    ; Calculate cutoff timestamp
    cutoffDate := DateAdd(A_Now, -olderThanDays, "Days")

    Loop Files, dirPath "\*.*", "FR" {
        fileTime := FileGetTime(A_LoopFilePath, timeType)

        if (fileTime < cutoffDate) {
            ageDays := DateDiff(A_Now, fileTime, "Days")
            oldFiles.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                timestamp: fileTime,
                formatted: FormatTime(fileTime, "yyyy-MM-dd"),
                age: ageDays
            })
        }
    }

    return oldFiles
}

; Create test directory with files
testDir := A_ScriptDir "\AgeTest"
DirCreate(testDir)

Loop 5
FileAppend("File " A_Index, testDir "\file" A_Index ".txt")

; Find old files (using 0 days to include all for demo)
oldFiles := FindOldFiles(testDir, 0, "M")

output := "OLD FILES REPORT:`n`n"
output .= "Threshold: Older than 0 days`n"
output .= "Found: " oldFiles.Length " files`n`n"

for file in oldFiles {
    output .= file.name ":`n"
    output .= "  Modified: " file.formatted "`n"
    output .= "  Age: " FormatAge(file.age) " ago`n`n"
}

MsgBox(output, "Old Files", "Icon!")

; ============================================================
; Example 2: Find Recently Modified Files
; ============================================================

/**
* Find files modified within specified time
*
* @param {String} dirPath - Directory to search
* @param {Integer} withinHours - Time window in hours
* @returns {Array} - Recent files
*/
FindRecentFiles(dirPath, withinHours := 24) {
    recentFiles := []

    if (!DirExist(dirPath))
    return recentFiles

    cutoffTime := DateAdd(A_Now, -withinHours, "Hours")

    Loop Files, dirPath "\*.*", "FR" {
        fileTime := FileGetTime(A_LoopFilePath, "M")

        if (fileTime >= cutoffTime) {
            hoursAgo := DateDiff(A_Now, fileTime, "Hours")
            minutesAgo := DateDiff(A_Now, fileTime, "Minutes")

            recentFiles.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                timestamp: fileTime,
                formatted: FormatTime(fileTime, "yyyy-MM-dd HH:mm:ss"),
                hoursAgo: hoursAgo,
                minutesAgo: minutesAgo
            })
        }
    }

    return recentFiles
}

; Find recent files
recentFiles := FindRecentFiles(testDir, 24)

output := "RECENT FILES REPORT:`n`n"
output .= "Time Window: Last 24 hours`n"
output .= "Found: " recentFiles.Length " files`n`n"

for file in recentFiles {
    output .= file.name ":`n"
    output .= "  Modified: " file.formatted "`n"
    if (file.hoursAgo = 0)
    output .= "  Age: " file.minutesAgo " minutes ago`n`n"
    else
    output .= "  Age: " file.hoursAgo " hours ago`n`n"
}

MsgBox(output, "Recent Files", "Icon!")

; ============================================================
; Example 3: File Retention Policy
; ============================================================

/**
* Apply retention policy to files
*
* @param {String} dirPath - Directory to manage
* @param {Object} policy - Retention policy rules
* @returns {Object} - Policy application results
*/
ApplyRetentionPolicy(dirPath, policy) {
    result := {
        checked: 0,
        toKeep: 0,
        toDelete: 0,
        filesToDelete: []
    }

    if (!DirExist(dirPath))
    return result

    Loop Files, dirPath "\*.*", "F" {
        result.checked++
        fileTime := FileGetTime(A_LoopFilePath, policy.timeType)
        ageDays := DateDiff(A_Now, fileTime, "Days")

        shouldDelete := false

        ; Check retention period
        if (policy.maxAgeDays > 0 && ageDays > policy.maxAgeDays)
        shouldDelete := true

        if (shouldDelete) {
            result.toDelete++
            result.filesToDelete.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                age: ageDays
            })
        } else {
            result.toKeep++
        }
    }

    return result
}

; Test retention policy
policy := {
    timeType: "M",
    maxAgeDays: 30  ; Keep files newer than 30 days
}

retentionResult := ApplyRetentionPolicy(testDir, policy)

output := "RETENTION POLICY:`n`n"
output .= "Policy: Keep files newer than " policy.maxAgeDays " days`n`n"
output .= "Files Checked: " retentionResult.checked "`n"
output .= "To Keep: " retentionResult.toKeep "`n"
output .= "To Delete: " retentionResult.toDelete "`n`n"

if (retentionResult.toDelete > 0) {
    output .= "Files Marked for Deletion:`n"
    for file in retentionResult.filesToDelete
    output .= "  • " file.name " (" FormatAge(file.age) " old)`n"
}

MsgBox(output, "Retention Policy", "Icon!")

; ============================================================
; Example 4: File Freshness Monitor
; ============================================================

/**
* Check if files are fresh (recently updated)
*
* @param {Array} files - Files to check
* @param {Integer} freshnessDays - Max age to be considered fresh
* @returns {Object} - Freshness report
*/
CheckFileFreshness(files, freshnessDays := 7) {
    report := {
        fresh: [],
        stale: [],
        threshold: freshnessDays
    }

    cutoffDate := DateAdd(A_Now, -freshnessDays, "Days")

    for filePath in files {
        if (!FileExist(filePath))
        continue

        fileTime := FileGetTime(filePath, "M")
        ageDays := DateDiff(A_Now, fileTime, "Days")
        SplitPath(filePath, &name)

        fileInfo := {
            name: name,
            path: filePath,
            age: ageDays,
            timestamp: FormatTime(fileTime, "yyyy-MM-dd")
        }

        if (fileTime >= cutoffDate)
        report.fresh.Push(fileInfo)
        else
        report.stale.Push(fileInfo)
    }

    return report
}

; Check freshness
filesToCheck := []
Loop Files, testDir "\*.txt", "F"
filesToCheck.Push(A_LoopFilePath)

freshness := CheckFileFreshness(filesToCheck, 1)

output := "FILE FRESHNESS CHECK:`n`n"
output .= "Freshness Threshold: " freshness.threshold " days`n`n"

output .= "FRESH (" freshness.fresh.Length "):`n"
for file in freshness.fresh
output .= "  ✓ " file.name " (" file.age " days old)`n"

output .= "`nSTALE (" freshness.stale.Length "):`n"
for file in freshness.stale
output .= "  ✗ " file.name " (" file.age " days old)`n"

MsgBox(output, "Freshness Check", "Icon!")

; ============================================================
; Example 5: Age-Based File Categorization
; ============================================================

/**
* Categorize files by age
*
* @param {String} dirPath - Directory to analyze
* @returns {Object} - Age categories
*/
CategorizeByAge(dirPath) {
    categories := {
        veryNew: {name: "Very New (< 1 day)", files: []},
        new: {name: "New (1-7 days)", files: []},
        recent: {name: "Recent (7-30 days)", files: []},
        old: {name: "Old (30-90 days)", files: []},
        veryOld: {name: "Very Old (> 90 days)", files: []}
    }

    if (!DirExist(dirPath))
    return categories

    Loop Files, dirPath "\*.*", "FR" {
        fileTime := FileGetTime(A_LoopFilePath, "M")
        ageDays := DateDiff(A_Now, fileTime, "Days")

        fileInfo := {
            name: A_LoopFileName,
            path: A_LoopFilePath,
            age: ageDays
        }

        if (ageDays < 1)
        categories.veryNew.files.Push(fileInfo)
        else if (ageDays <= 7)
        categories.new.files.Push(fileInfo)
        else if (ageDays <= 30)
        categories.recent.files.Push(fileInfo)
        else if (ageDays <= 90)
        categories.old.files.Push(fileInfo)
        else
        categories.veryOld.files.Push(fileInfo)
    }

    return categories
}

; Categorize files
categories := CategorizeByAge(testDir)

output := "AGE CATEGORIZATION:`n`n"
for catName, catData in categories.OwnProps() {
    if (catData.files.Length > 0) {
        output .= catData.name " (" catData.files.Length "):`n"
        for file in catData.files
        output .= "  • " file.name "`n"
        output .= "`n"
    }
}

MsgBox(output, "Age Categories", "Icon!")

; ============================================================
; Example 6: Automated Cleanup by Age
; ============================================================

/**
* Clean up files older than threshold
*
* @param {String} dirPath - Directory to clean
* @param {Integer} maxAgeDays - Maximum age to keep
* @param {Boolean} dryRun - Preview without deleting
* @returns {Object} - Cleanup results
*/
CleanupByAge(dirPath, maxAgeDays, dryRun := true) {
    result := {
        scanned: 0,
        eligible: 0,
        deleted: 0,
        errors: 0,
        files: []
    }

    if (!DirExist(dirPath))
    return result

    cutoffDate := DateAdd(A_Now, -maxAgeDays, "Days")

    Loop Files, dirPath "\*.*", "F" {
        result.scanned++
        fileTime := FileGetTime(A_LoopFilePath, "M")

        if (fileTime < cutoffDate) {
            result.eligible++
            ageDays := DateDiff(A_Now, fileTime, "Days")

            result.files.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                age: ageDays
            })

            if (!dryRun) {
                try {
                    FileDelete(A_LoopFilePath)
                    result.deleted++
                } catch {
                    result.errors++
                }
            }
        }
    }

    return result
}

; Test cleanup (dry run)
cleanup := CleanupByAge(testDir, 0, true)

output := "AUTOMATED CLEANUP (DRY RUN):`n`n"
output .= "Max Age: " 0 " days`n"
output .= "Files Scanned: " cleanup.scanned "`n"
output .= "Eligible for Deletion: " cleanup.eligible "`n`n"

if (cleanup.files.Length > 0) {
    output .= "Files to be deleted:`n"
    for file in cleanup.files
    output .= "  • " file.name " (" file.age " days old)`n"
}

MsgBox(output, "Cleanup Preview", "Icon!")

; ============================================================
; Example 7: File Age Statistics
; ============================================================

/**
* Calculate age statistics for files
*
* @param {String} dirPath - Directory to analyze
* @returns {Object} - Age statistics
*/
CalculateAgeStats(dirPath) {
    ages := []

    if (!DirExist(dirPath))
    return {valid: false}

    Loop Files, dirPath "\*.*", "F" {
        fileTime := FileGetTime(A_LoopFilePath, "M")
        ageDays := DateDiff(A_Now, fileTime, "Days")
        ages.Push(ageDays)
    }

    if (ages.Length = 0)
    return {valid: false}

    ; Calculate statistics
    total := 0
    min := ages[1]
    max := ages[1]

    for age in ages {
        total += age
        if (age < min)
        min := age
        if (age > max)
        max := age
    }

    return {
        valid: true,
        count: ages.Length,
        average: Round(total / ages.Length, 1),
        min: min,
        max: max,
        range: max - min
    }
}

; Calculate statistics
stats := CalculateAgeStats(testDir)

if (stats.valid) {
    output := "FILE AGE STATISTICS:`n`n"
    output .= "Files Analyzed: " stats.count "`n`n"
    output .= "Average Age: " FormatAge(Round(stats.average)) "`n"
    output .= "Newest: " FormatAge(stats.min) "`n"
    output .= "Oldest: " FormatAge(stats.max) "`n"
    output .= "Age Range: " FormatAge(stats.range)

    MsgBox(output, "Age Statistics", "Icon!")
}

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILE AGE CHECKING:

Calculating Age:
timestamp := FileGetTime(file, 'M')
ageDays := DateDiff(A_Now, timestamp, 'Days')

Age-Based Filtering:
cutoffDate := DateAdd(A_Now, -30, 'Days')
if (fileTime < cutoffDate)
; File is older than 30 days

Common Retention Policies:
• Logs: 30-90 days
• Backups: 7-30 days
• Temp files: 1-7 days
• Archives: 365+ days
• Cache: 1-7 days

Use Cases:
✓ Automated cleanup
✓ Backup rotation
✓ Log management
✓ Cache invalidation
✓ Compliance requirements
✓ Storage optimization

Best Practices:
• Use dry run for testing
• Log deletion actions
• Implement retention tiers
• Consider file importance
• Allow manual overrides
• Backup before deletion
• Schedule regular cleanup

Time Types for Age:
• 'M' - Modified (most common)
• 'C' - Created (for new files)
• 'A' - Accessed (for usage)
)"

MsgBox(info, "Age Checking Reference", "Icon!")

; Cleanup
DirDelete(testDir, true)
