#Requires AutoHotkey v2.0
/**
 * BuiltIn_FileGetSize_08.ahk
 *
 * DESCRIPTION:
 * File size limits, validation, and constraint enforcement
 *
 * FEATURES:
 * - Size limit validation
 * - Upload/download size checks
 * - File size constraints
 * - Automatic size management
 * - Size-based file filtering
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetSize.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetSize() for validation
 * - Size constraint checking
 * - Error handling
 * - Automated size management
 * - File filtering by size
 *
 * LEARNING POINTS:
 * 1. Enforce size limits before operations
 * 2. Validate file sizes for uploads
 * 3. Implement size-based quotas
 * 4. Automatic file cleanup by size
 * 5. Size-based file categorization
 * 6. Prevent oversized files
 */

; Helper function
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
; Example 1: File Size Validator
; ============================================================

/**
 * Validate file size against constraints
 *
 * @param {String} filePath - File to validate
 * @param {Object} constraints - Size constraints
 * @returns {Object} - Validation result
 */
ValidateFileSize(filePath, constraints := "") {
    if (!constraints) {
        constraints := {
            minSize: 0,
            maxSize: 1024 * 1024 * 10,  ; 10 MB default
            exactSize: 0,
            allowEmpty: true
        }
    }

    result := {
        valid: false,
        size: 0,
        error: "",
        warnings: []
    }

    ; Check file exists
    if (!FileExist(filePath)) {
        result.error := "File does not exist"
        return result
    }

    ; Get size
    size := FileGetSize(filePath)
    result.size := size

    ; Check if empty
    if (size = 0) {
        if (!constraints.allowEmpty) {
            result.error := "File is empty (0 bytes)"
            return result
        } else {
            result.warnings.Push("File is empty")
        }
    }

    ; Check exact size if specified
    if (constraints.exactSize > 0) {
        if (size != constraints.exactSize) {
            result.error := "File size must be exactly " FormatSize(constraints.exactSize)
            return result
        }
    }

    ; Check minimum size
    if (constraints.minSize > 0 && size < constraints.minSize) {
        result.error := "File too small (min: " FormatSize(constraints.minSize) ")"
        return result
    }

    ; Check maximum size
    if (constraints.maxSize > 0 && size > constraints.maxSize) {
        result.error := "File too large (max: " FormatSize(constraints.maxSize) ")"
        return result
    }

    ; All checks passed
    result.valid := true
    return result
}

; Create test files
testFile1 := A_ScriptDir "\small.txt"
FileAppend("Small content", testFile1)

testFile2 := A_ScriptDir "\large.txt"
content := ""
Loop 5000
    content .= "Large file content line " A_Index "`n"
FileAppend(content, testFile2)

; Test validation
constraints := {
    minSize: 100,
    maxSize: 1024 * 50,  ; 50 KB
    exactSize: 0,
    allowEmpty: false
}

validation1 := ValidateFileSize(testFile1, constraints)
validation2 := ValidateFileSize(testFile2, constraints)

output := "FILE SIZE VALIDATION:`n`n"
output .= "Constraints:`n"
output .= "  Min: " FormatSize(constraints.minSize) "`n"
output .= "  Max: " FormatSize(constraints.maxSize) "`n`n"

output .= "File 1 (small.txt):`n"
output .= "  Size: " FormatSize(validation1.size) "`n"
output .= "  Valid: " (validation1.valid ? "Yes ✓" : "No ✗") "`n"
if (!validation1.valid)
    output .= "  Error: " validation1.error "`n"
output .= "`n"

output .= "File 2 (large.txt):`n"
output .= "  Size: " FormatSize(validation2.size) "`n"
output .= "  Valid: " (validation2.valid ? "Yes ✓" : "No ✗") "`n"
if (!validation2.valid)
    output .= "  Error: " validation2.error

MsgBox(output, "Size Validation", "Icon!")

; ============================================================
; Example 2: Upload Size Checker
; ============================================================

/**
 * Check if file is acceptable for upload
 *
 * @param {String} filePath - File to check
 * @param {Integer} maxUploadSize - Maximum upload size
 * @returns {Object} - Upload eligibility
 */
CheckUploadEligibility(filePath, maxUploadSize := 1024 * 1024 * 5) {
    result := {
        eligible: false,
        size: 0,
        maxSize: maxUploadSize,
        message: ""
    }

    if (!FileExist(filePath)) {
        result.message := "File not found"
        return result
    }

    size := FileGetSize(filePath)
    result.size := size

    if (size = 0) {
        result.message := "Cannot upload empty file"
        return result
    }

    if (size > maxUploadSize) {
        exceededBy := size - maxUploadSize
        result.message := "File exceeds upload limit by " FormatSize(exceededBy)
        return result
    }

    result.eligible := true
    result.message := "File ready for upload"
    return result
}

; Test upload checker
maxUpload := 1024 * 100  ; 100 KB limit

upload1 := CheckUploadEligibility(testFile1, maxUpload)
upload2 := CheckUploadEligibility(testFile2, maxUpload)

output := "UPLOAD SIZE CHECKER:`n`n"
output .= "Upload Limit: " FormatSize(maxUpload) "`n`n"

output .= "small.txt:`n"
output .= "  Size: " FormatSize(upload1.size) "`n"
output .= "  Eligible: " (upload1.eligible ? "Yes ✓" : "No ✗") "`n"
output .= "  " upload1.message "`n`n"

output .= "large.txt:`n"
output .= "  Size: " FormatSize(upload2.size) "`n"
output .= "  Eligible: " (upload2.eligible ? "Yes ✓" : "No ✗") "`n"
output .= "  " upload2.message

MsgBox(output, "Upload Check", "Icon!")

; ============================================================
; Example 3: Size-Based File Categorization
; ============================================================

/**
 * Categorize file by size
 *
 * @param {Integer} bytes - File size in bytes
 * @returns {String} - Size category
 */
CategorizeBySize(bytes) {
    if (bytes = 0)
        return "Empty"
    if (bytes < 1024)
        return "Tiny"
    if (bytes < 1024 * 100)
        return "Small"
    if (bytes < 1024 * 1024)
        return "Medium"
    if (bytes < 1024 * 1024 * 10)
        return "Large"
    if (bytes < 1024 * 1024 * 100)
        return "Very Large"
    return "Huge"
}

/**
 * Categorize files in directory
 *
 * @param {String} dirPath - Directory to analyze
 * @returns {Object} - Categorization results
 */
CategorizeFiles(dirPath) {
    categories := Map(
        "Empty", {count: 0, totalSize: 0, files: []},
        "Tiny", {count: 0, totalSize: 0, files: []},
        "Small", {count: 0, totalSize: 0, files: []},
        "Medium", {count: 0, totalSize: 0, files: []},
        "Large", {count: 0, totalSize: 0, files: []},
        "Very Large", {count: 0, totalSize: 0, files: []},
        "Huge", {count: 0, totalSize: 0, files: []}
    )

    if (!DirExist(dirPath))
        return categories

    Loop Files, dirPath "\*.*", "F" {
        size := A_LoopFileSize
        category := CategorizeBySize(size)

        catData := categories[category]
        catData.count++
        catData.totalSize += size
        catData.files.Push(A_LoopFileName)
    }

    return categories
}

; Create test directory with various file sizes
testDir := A_ScriptDir "\SizeCategories"
DirCreate(testDir)

FileAppend("", testDir "\empty.txt")
FileAppend("Tiny", testDir "\tiny.txt")
FileAppend(StrRepeat("Small file ", 50), testDir "\small.txt")

medContent := ""
Loop 500
    medContent .= "Medium content " A_Index "`n"
FileAppend(medContent, testDir "\medium.txt")

; Categorize files
categories := CategorizeFiles(testDir)

output := "FILE SIZE CATEGORIES:`n`n"
for category, data in categories {
    if (data.count > 0) {
        output .= category " (" data.count " files):`n"
        output .= "  Total: " FormatSize(data.totalSize) "`n"
        output .= "  Files: " StrReplace(StrJoin(data.files, ", "), ",", ",") "`n`n"
    }
}

MsgBox(output, "Categorization", "Icon!")

StrJoin(arr, delimiter) {
    result := ""
    for item in arr {
        if (A_Index > 1)
            result .= delimiter
        result .= item
    }
    return result
}

StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

; ============================================================
; Example 4: Automatic Size-Based Cleanup
; ============================================================

/**
 * Remove files exceeding size limit
 *
 * @param {String} dirPath - Directory to clean
 * @param {Integer} maxFileSize - Maximum file size
 * @param {Boolean} dryRun - Preview without deleting
 * @returns {Object} - Cleanup results
 */
CleanupOversizedFiles(dirPath, maxFileSize, dryRun := true) {
    result := {
        found: 0,
        deleted: 0,
        totalSizeFreed: 0,
        files: []
    }

    if (!DirExist(dirPath))
        return result

    Loop Files, dirPath "\*.*", "F" {
        if (A_LoopFileSize > maxFileSize) {
            result.found++
            result.files.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                size: A_LoopFileSize
            })

            if (!dryRun) {
                try {
                    FileDelete(A_LoopFilePath)
                    result.deleted++
                    result.totalSizeFreed += A_LoopFileSize
                }
            } else {
                result.totalSizeFreed += A_LoopFileSize
            }
        }
    }

    return result
}

; Test cleanup (dry run)
maxSize := 1024 * 30  ; 30 KB limit
cleanup := CleanupOversizedFiles(testDir, maxSize, true)

output := "SIZE-BASED CLEANUP (DRY RUN):`n`n"
output .= "Max Size: " FormatSize(maxSize) "`n"
output .= "Files Found: " cleanup.found "`n"
output .= "Potential Space Freed: " FormatSize(cleanup.totalSizeFreed) "`n`n"

if (cleanup.files.Length > 0) {
    output .= "Files to Remove:`n"
    for file in cleanup.files {
        output .= "  • " file.name " (" FormatSize(file.size) ")`n"
    }
}

MsgBox(output, "Cleanup Preview", "Icon!")

; ============================================================
; Example 5: Size Quota Enforcement
; ============================================================

/**
 * Enforce total size quota for directory
 *
 * @param {String} dirPath - Directory to monitor
 * @param {Integer} quotaBytes - Maximum total size
 * @returns {Object} - Quota status and enforcement
 */
EnforceQuota(dirPath, quotaBytes) {
    status := {
        currentSize: 0,
        quota: quotaBytes,
        withinQuota: true,
        exceeded: 0,
        oldestFiles: []
    }

    if (!DirExist(dirPath))
        return status

    ; Calculate current usage and collect file info
    files := []
    Loop Files, dirPath "\*.*", "F" {
        status.currentSize += A_LoopFileSize
        files.Push({
            path: A_LoopFilePath,
            name: A_LoopFileName,
            size: A_LoopFileSize,
            modified: A_LoopFileTimeModified
        })
    }

    ; Check quota
    if (status.currentSize > quotaBytes) {
        status.withinQuota := false
        status.exceeded := status.currentSize - quotaBytes

        ; Sort by modification time (oldest first)
        Loop files.Length {
            outerIndex := A_Index
            Loop files.Length - outerIndex {
                innerIndex := A_Index
                if (files[innerIndex].modified > files[innerIndex + 1].modified) {
                    temp := files[innerIndex]
                    files[innerIndex] := files[innerIndex + 1]
                    files[innerIndex + 1] := temp
                }
            }
        }

        ; Find oldest files to remove to meet quota
        sizeToFree := status.exceeded
        sizeFreed := 0

        for file in files {
            if (sizeFreed >= sizeToFree)
                break
            status.oldestFiles.Push(file)
            sizeFreed += file.size
        }
    }

    return status
}

; Test quota enforcement
quota := 1024 * 100  ; 100 KB quota
quotaStatus := EnforceQuota(testDir, quota)

output := "QUOTA ENFORCEMENT:`n`n"
output .= "Quota: " FormatSize(quotaStatus.quota) "`n"
output .= "Current Usage: " FormatSize(quotaStatus.currentSize) "`n"
output .= "Status: " (quotaStatus.withinQuota ? "OK ✓" : "EXCEEDED ✗") "`n"

if (!quotaStatus.withinQuota) {
    output .= "`nExceeded By: " FormatSize(quotaStatus.exceeded) "`n"
    output .= "`nOldest Files (suggested for removal):`n"
    for file in quotaStatus.oldestFiles {
        output .= "  • " file.name " (" FormatSize(file.size) ")`n"
    }
}

MsgBox(output, "Quota Status", quotaStatus.withinQuota ? "Icon!" : "IconX")

; ============================================================
; Example 6: File Size Range Filter
; ============================================================

/**
 * Filter files by size range
 *
 * @param {String} dirPath - Directory to search
 * @param {Integer} minSize - Minimum size (0 = no min)
 * @param {Integer} maxSize - Maximum size (0 = no max)
 * @returns {Array} - Filtered files
 */
FilterFilesBySize(dirPath, minSize := 0, maxSize := 0) {
    filtered := []

    if (!DirExist(dirPath))
        return filtered

    Loop Files, dirPath "\*.*", "F" {
        size := A_LoopFileSize

        ; Check minimum
        if (minSize > 0 && size < minSize)
            continue

        ; Check maximum
        if (maxSize > 0 && size > maxSize)
            continue

        filtered.Push({
            name: A_LoopFileName,
            path: A_LoopFilePath,
            size: size
        })
    }

    return filtered
}

; Test filtering
min := 1024 * 10   ; 10 KB minimum
max := 1024 * 50   ; 50 KB maximum

filtered := FilterFilesBySize(testDir, min, max)

output := "FILE SIZE FILTER:`n`n"
output .= "Range: " FormatSize(min) " - " FormatSize(max) "`n"
output .= "Matching Files: " filtered.Length "`n`n"

if (filtered.Length > 0) {
    for file in filtered {
        output .= "• " file.name "`n"
        output .= "  " FormatSize(file.size) "`n"
    }
} else {
    output .= "(No files in this size range)"
}

MsgBox(output, "Size Filter", "Icon!")

; ============================================================
; Example 7: Dynamic Size Limit Calculator
; ============================================================

/**
 * Calculate appropriate size limits based on available space
 *
 * @param {String} drive - Drive letter (e.g., "C:")
 * @param {Float} percentAllowed - Percentage of free space allowed
 * @returns {Object} - Calculated limits
 */
CalculateDynamicLimits(drive, percentAllowed := 10.0) {
    ; Note: Getting actual drive space requires DriveGetCapacity/DriveGetFree
    ; For demo, we'll use simulated values
    totalSpace := 1024 * 1024 * 1024 * 500  ; Simulate 500 GB
    freeSpace := 1024 * 1024 * 1024 * 100   ; Simulate 100 GB free

    allowedSpace := Round(freeSpace * (percentAllowed / 100))

    return {
        totalSpace: totalSpace,
        freeSpace: freeSpace,
        percentAllowed: percentAllowed,
        maxFileSize: Round(allowedSpace * 0.1),  ; 10% of allowed for single file
        maxDirSize: allowedSpace,
        recommendations: {
            singleFileLimit: FormatSize(Round(allowedSpace * 0.1)),
            directoryLimit: FormatSize(allowedSpace),
            uploadLimit: FormatSize(Round(allowedSpace * 0.05))
        }
    }
}

; Calculate dynamic limits
limits := CalculateDynamicLimits("C:", 10.0)

output := "DYNAMIC SIZE LIMITS:`n`n"
output .= "Drive Analysis:`n"
output .= "  Total Space: " FormatSize(limits.totalSpace) "`n"
output .= "  Free Space: " FormatSize(limits.freeSpace) "`n"
output .= "  Allowed Usage: " limits.percentAllowed "%`n`n"

output .= "Recommended Limits:`n"
output .= "  Single File: " limits.recommendations.singleFileLimit "`n"
output .= "  Directory: " limits.recommendations.directoryLimit "`n"
output .= "  Upload: " limits.recommendations.uploadLimit

MsgBox(output, "Dynamic Limits", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
FILE SIZE LIMITS AND VALIDATION:

Common Size Limits:
• Email attachments: 10-25 MB
• Web uploads: 10-100 MB
• API requests: 1-50 MB
• Database BLOBs: varies
• File systems: 4 GB (FAT32), unlimited (NTFS)

Validation Strategies:
1. Pre-operation Checks
   if (FileGetSize(file) > limit)
       reject operation

2. Quota Systems
   Track cumulative usage
   Enforce total limits

3. Categorization
   Different limits per type
   Context-aware validation

4. Dynamic Limits
   Based on available space
   Adjust to conditions

Size Constraint Types:
✓ Minimum size (non-empty)
✓ Maximum size (prevent overload)
✓ Exact size (specific formats)
✓ Range (acceptable sizes)
✓ Quota (total limit)
✓ Percentage (relative limit)

Best Practices:
• Validate before processing
• Provide clear error messages
• Include size in error details
• Allow configuration
• Log size violations
• Implement retry logic
• Consider compression
• Cache size checks

Error Handling:
• Fail gracefully
• Suggest alternatives
• Provide size info
• Allow user override
• Log for analysis
)"

MsgBox(info, "Size Limits Reference", "Icon!")

; Cleanup
FileDelete(testFile1)
FileDelete(testFile2)
DirDelete(testDir, true)
