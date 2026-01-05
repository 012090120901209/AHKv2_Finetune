#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_FileGetAttrib_14.ahk
 * 
 * DESCRIPTION:
 * Advanced attribute filtering and file categorization
 * 
 * FEATURES:
 * - Filter files by attributes
 * - Attribute-based categorization
 * - Complex attribute queries
 * - Attribute combinations
 * - File classification
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/FileGetAttrib.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileGetAttrib() with filtering
 * - Attribute pattern matching
 * - Multi-criteria filtering
 * - File classification systems
 * - Attribute-based organization
 * 
 * LEARNING POINTS:
 * 1. Filter files by specific attributes
 * 2. Combine multiple attribute criteria
 * 3. Categorize files by attributes
 * 4. Create complex attribute queries
 * 5. Organize files by characteristics
 * 6. Implement attribute-based rules
 */

; ============================================================
; Example 1: Filter Files by Attribute
; ============================================================

/**
 * Filter files by required attributes
 * 
 * @param {String} dirPath - Directory to search
 * @param {String} requiredAttribs - Required attributes (e.g., "R", "RH")
 * @returns {Array} - Matching files
 */
FilterByAttributes(dirPath, requiredAttribs) {
    matches := []

    if (!DirExist(dirPath))
        return matches

    Loop Files, dirPath "\*.*", "FH" {
        attrs := FileGetAttrib(A_LoopFilePath)
        hasAll := true

        ; Check each required attribute
        Loop Parse, requiredAttribs {
            if (!InStr(attrs, A_LoopField)) {
                hasAll := false
                break
            }
        }

        if (hasAll) {
            matches.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                attributes: attrs
            })
        }
    }

    return matches
}

; Create test directory
testDir := A_ScriptDir "\AttribFilter"
DirCreate(testDir)

; Create files with different attributes
FileAppend("Normal file", testDir "\normal.txt")
FileAppend("ReadOnly file", testDir "\readonly.txt")
FileSetAttrib("+R", testDir "\readonly.txt")
FileAppend("Hidden file", testDir "\hidden.txt")
FileSetAttrib("+H", testDir "\hidden.txt")
FileAppend("ReadOnly+Hidden", testDir "\both.txt")
FileSetAttrib("+RH", testDir "\both.txt")

; Filter read-only files
readOnlyFiles := FilterByAttributes(testDir, "R")

output := "FILES WITH READ-ONLY ATTRIBUTE:`n`n"
output .= "Found: " readOnlyFiles.Length " files`n`n"
for file in readOnlyFiles
    output .= "• " file.name " (" file.attributes ")`n"

MsgBox(output, "Attribute Filter", "Icon!")

; ============================================================
; Example 2: Exclude Files by Attribute
; ============================================================

/**
 * Get files that DON'T have specific attributes
 * 
 * @param {String} dirPath - Directory to search
 * @param {String} excludeAttribs - Attributes to exclude
 * @returns {Array} - Non-matching files
 */
ExcludeByAttributes(dirPath, excludeAttribs) {
    matches := []

    if (!DirExist(dirPath))
        return matches

    Loop Files, dirPath "\*.*", "FH" {
        attrs := FileGetAttrib(A_LoopFilePath)
        hasAny := false

        ; Check if has any excluded attribute
        Loop Parse, excludeAttribs {
            if (InStr(attrs, A_LoopField)) {
                hasAny := true
                break
            }
        }

        if (!hasAny) {
            matches.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                attributes: attrs
            })
        }
    }

    return matches
}

; Exclude hidden and read-only files
normalFiles := ExcludeByAttributes(testDir, "HR")

output := "FILES WITHOUT H OR R ATTRIBUTES:`n`n"
output .= "Found: " normalFiles.Length " files`n`n"
for file in normalFiles
    output .= "• " file.name " (" file.attributes ")`n"

MsgBox(output, "Exclude Filter", "Icon!")

; ============================================================
; Example 3: Categorize by Attribute Combinations
; ============================================================

/**
 * Categorize files by attribute patterns
 * 
 * @param {String} dirPath - Directory to analyze
 * @returns {Object} - Categorized files
 */
CategorizeByAttributes(dirPath) {
    categories := Map(
        "Normal", [],
        "ReadOnly", [],
        "Hidden", [],
        "System", [],
        "Protected", [],  ; R+H
        "Special", []     ; Has S or R+H+S
    )

    if (!DirExist(dirPath))
        return categories

    Loop Files, dirPath "\*.*", "FH" {
        attrs := FileGetAttrib(A_LoopFilePath)
        fileInfo := {
            name: A_LoopFileName,
            attributes: attrs
        }

        ; Categorize based on attribute combination
        if (InStr(attrs, "S")) {
            categories["Special"].Push(fileInfo)
        } else if (InStr(attrs, "R") && InStr(attrs, "H")) {
            categories["Protected"].Push(fileInfo)
        } else if (InStr(attrs, "R")) {
            categories["ReadOnly"].Push(fileInfo)
        } else if (InStr(attrs, "H")) {
            categories["Hidden"].Push(fileInfo)
        } else {
            categories["Normal"].Push(fileInfo)
        }
    }

    return categories
}

; Categorize files
categories := CategorizeByAttributes(testDir)

output := "FILE CATEGORIZATION:`n`n"
for categoryName, files in categories {
    if (files.Length > 0) {
        output .= categoryName " (" files.Length "):`n"
        for file in files
            output .= "  • " file.name "`n"
        output .= "`n"
    }
}

MsgBox(output, "Categorization", "Icon!")

; ============================================================
; Example 4: Complex Attribute Query
; ============================================================

/**
 * Execute complex attribute query
 * 
 * @param {String} dirPath - Directory to search
 * @param {Object} query - Query criteria
 * @returns {Array} - Query results
 */
QueryByAttributes(dirPath, query) {
    results := []

    if (!DirExist(dirPath))
        return results

    Loop Files, dirPath "\*.*", "FH" {
        attrs := FileGetAttrib(A_LoopFilePath)
        matches := true

        ; Check required attributes
        if (query.HasOwnProp("required")) {
            Loop Parse, query.required {
                if (!InStr(attrs, A_LoopField)) {
                    matches := false
                    break
                }
            }
        }

        ; Check excluded attributes
        if (matches && query.HasOwnProp("excluded")) {
            Loop Parse, query.excluded {
                if (InStr(attrs, A_LoopField)) {
                    matches := false
                    break
                }
            }
        }

        if (matches) {
            results.Push({
                name: A_LoopFileName,
                path: A_LoopFilePath,
                attributes: attrs
            })
        }
    }

    return results
}

; Complex query: ReadOnly but not Hidden
query := {
    required: "R",
    excluded: "H"
}

queryResults := QueryByAttributes(testDir, query)

output := "COMPLEX QUERY RESULTS:`n`n"
output .= "Query: ReadOnly=Yes, Hidden=No`n"
output .= "Found: " queryResults.Length " files`n`n"
for file in queryResults
    output .= "• " file.name " (" file.attributes ")`n"

MsgBox(output, "Query Results", "Icon!")

; ============================================================
; Example 5: Attribute-Based File Classification
; ============================================================

/**
 * Classify file security level based on attributes
 * 
 * @param {String} filePath - File to classify
 * @returns {Object} - Classification result
 */
ClassifyFileSecurity(filePath) {
    classification := {
        level: "Unknown",
        score: 0,
        details: []
    }

    if (!FileExist(filePath))
        return classification

    attrs := FileGetAttrib(filePath)

    ; Calculate security score
    if (InStr(attrs, "S")) {
        classification.score += 10
        classification.details.Push("System file")
    }

    if (InStr(attrs, "R")) {
        classification.score += 5
        classification.details.Push("Read-only protection")
    }

    if (InStr(attrs, "H")) {
        classification.score += 3
        classification.details.Push("Hidden from view")
    }

    ; Determine level
    if (classification.score >= 10)
        classification.level := "Critical"
    else if (classification.score >= 5)
        classification.level := "Protected"
    else if (classification.score > 0)
        classification.level := "Restricted"
    else
        classification.level := "Normal"

    return classification
}

; Classify files
output := "SECURITY CLASSIFICATION:`n`n"

testFiles := [
    testDir "\normal.txt",
    testDir "\readonly.txt",
    testDir "\hidden.txt",
    testDir "\both.txt"
]

for filePath in testFiles {
    SplitPath(filePath, &name)
    classification := ClassifyFileSecurity(filePath)

    output .= name ":`n"
    output .= "  Level: " classification.level "`n"
    output .= "  Score: " classification.score "`n"
    if (classification.details.Length > 0) {
        output .= "  Features: "
        for detail in classification.details
            output .= detail (A_Index < classification.details.Length ? ", " : "")
    }
    output .= "`n`n"
}

MsgBox(output, "Security Classification", "Icon!")

; ============================================================
; Example 6: Attribute Pattern Matching
; ============================================================

/**
 * Find files matching attribute pattern
 * 
 * @param {String} dirPath - Directory to search
 * @param {String} pattern - Pattern (e.g., "R*H" = R and H, "*" = anything between)
 * @returns {Array} - Matching files
 */
MatchAttributePattern(dirPath, pattern) {
    matches := []

    if (!DirExist(dirPath))
        return matches

    Loop Files, dirPath "\*.*", "FH" {
        attrs := FileGetAttrib(A_LoopFilePath)

        ; Simple pattern matching
        patternMatches := true

        Loop Parse, pattern {
            if (A_LoopField != "*" && !InStr(attrs, A_LoopField)) {
                patternMatches := false
                break
            }
        }

        if (patternMatches) {
            matches.Push({
                name: A_LoopFileName,
                attributes: attrs
            })
        }
    }

    return matches
}

; Match pattern
pattern := "R"  ; Must have R
patternMatches := MatchAttributePattern(testDir, pattern)

output := "ATTRIBUTE PATTERN MATCH:`n`n"
output .= "Pattern: Must have 'R' attribute`n"
output .= "Matches: " patternMatches.Length "`n`n"
for file in patternMatches
    output .= "• " file.name " (" file.attributes ")`n"

MsgBox(output, "Pattern Match", "Icon!")

; ============================================================
; Example 7: Attribute Statistics
; ============================================================

/**
 * Calculate attribute statistics for directory
 * 
 * @param {String} dirPath - Directory to analyze
 * @returns {Object} - Attribute statistics
 */
CalculateAttributeStats(dirPath) {
    stats := Map(
        "R", { count: 0, name: "Read-Only" },
        "A", { count: 0, name: "Archive" },
        "S", { count: 0, name: "System" },
        "H", { count: 0, name: "Hidden" },
        "N", { count: 0, name: "Normal" }
    )

    totalFiles := 0

    if (!DirExist(dirPath))
        return { stats: stats, total: 0 }

    Loop Files, dirPath "\*.*", "FH" {
        totalFiles++
        attrs := FileGetAttrib(A_LoopFilePath)

        for attrib, info in stats {
            if (InStr(attrs, attrib))
                info.count++
        }
    }

    return { stats: stats, total: totalFiles }
}

; Calculate stats
statsResult := CalculateAttributeStats(testDir)

output := "ATTRIBUTE STATISTICS:`n`n"
output .= "Total Files: " statsResult.total "`n`n"
output .= "Attribute Distribution:`n"

for attrib, info in statsResult.stats {
    if (info.count > 0) {
        percent := Round((info.count / statsResult.total) * 100, 1)
        output .= "  " info.name " (" attrib "): " info.count " (" percent "%)`n"
    }
}

MsgBox(output, "Attribute Statistics", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
ATTRIBUTE FILTERING AND CLASSIFICATION:

Filter Patterns:

1. Required Attributes (AND):
Must have ALL specified
if (InStr(attrs, 'R') && InStr(attrs, 'H'))

2. Excluded Attributes (NOT):
Must NOT have any
if (!InStr(attrs, 'R') && !InStr(attrs, 'H'))

3. Optional Attributes (OR):
Must have AT LEAST ONE
if (InStr(attrs, 'R') || InStr(attrs, 'H'))

Classification Strategies:
• Priority-based (system > read-only > hidden)
• Score-based (sum attribute weights)
• Rule-based (complex conditions)
• Pattern-based (attribute combinations)

Common Queries:
✓ Protected files (R+H)
✓ Backup candidates (A set)
✓ System files (S set)
✓ Normal files (no special attrs)
✓ Modifiable files (no R)
✓ Visible files (no H)

Best Practices:
• Cache attribute strings
• Use consistent categorization
• Document classification rules
• Handle edge cases
• Validate filter results
• Consider attribute combinations
)"

MsgBox(info, "Filtering Reference", "Icon!")

; Cleanup
DirDelete(testDir, true)
