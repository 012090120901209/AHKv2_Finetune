#Requires AutoHotkey v2.0

/**
* Local Script Research Scanner
*
* Scans local AHK scripts from a source directory and extracts
* AutoHotkey v2 examples for training purposes.
*
* SOURCE: C:\Users\uphol\Documents\Design\Coding\AHK\!Running\
* OUTPUT: C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\
*
* FEATURES:
* - Recursively scans source directory for .ahk files
* - Detects v1 vs v2 syntax automatically
* - Analyzes code quality and size
* - Generates comprehensive research report
* - Creates organized inventory of all scripts
*
* USAGE:
* 1. Update SOURCE_DIR and OUTPUT_DIR if needed
* 2. Run this script
* 3. Review generated RESEARCH_REPORT.md
* 4. Manually extract valuable examples to Training folder
*/

#SingleInstance Force

; ============================================================
; Configuration
; ============================================================

SOURCE_DIR := "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\"
OUTPUT_DIR := "C:\Users\uphol\Documents\Design\Coding\AHK\!Running\Training\"

; Ensure output directory exists
if !DirExist(OUTPUT_DIR) {
    try {
        DirCreate(OUTPUT_DIR)
    } catch as err {
        MsgBox("Error creating output directory:`n" OUTPUT_DIR "`n`nError: " err.Message, "Error", "Icon!")
        ExitApp
    }
}

; ============================================================
; Main Execution
; ============================================================

; Show initial message
result := MsgBox("Local AutoHotkey Script Scanner`n`n"
. "Source: " SOURCE_DIR "`n"
. "Output: " OUTPUT_DIR "`n`n"
. "This will scan all .ahk files recursively.`n"
. "Continue?",
"Script Scanner", "YesNo Icon?")

if result = "No"
ExitApp

; Create progress GUI
progressGui := Gui("+AlwaysOnTop", "Scanning Scripts...")
progressGui.AddText("w400", "Scanning directory: " SOURCE_DIR)
statusText := progressGui.AddText("w400", "Initializing...")
progressBar := progressGui.AddProgress("w400 h30", 0)
progressGui.Show()

; Results tracking
global totalFiles := 0
global v2Files := 0
global v1Files := 0
global unknownFiles := 0
global results := []
global categories := Map()

; Scan directory
statusText.Value := "Counting files..."
fileList := []

Loop Files, SOURCE_DIR "*.ahk", "R"
 {
    fileList.Push({
        path: A_LoopFileFullPath,
        name: A_LoopFileName,
        dir: A_LoopFileDir,
        size: A_LoopFileSize
    })
}

totalToScan := fileList.Length
statusText.Value := "Found " totalToScan " files. Analyzing..."

; Analyze each file
for index, file in fileList {
    totalFiles++

    ; Update progress
    progress := Round((index / totalToScan) * 100)
    progressBar.Value := progress
    statusText.Value := "Analyzing (" index "/" totalToScan "): " file.name

    ; Read file
    try {
        content := FileRead(file.path)
    } catch {
        results.Push({
            path: file.path,
            filename: file.name,
            size: 0,
            version: "error",
            quality: 0,
            features: [],
            error: "Could not read file"
        })
        continue
    }

    ; Analyze file
    analysis := AnalyzeScript(content, file.path)
    results.Push(analysis)

    ; Track version counts
    if analysis.version = "v2"
    v2Files++
    else if analysis.version = "v1"
    v1Files++
    else
    unknownFiles++

    ; Track categories
    for feature in analysis.features {
        if !categories.Has(feature)
        categories[feature] := 0
        categories[feature] := categories[feature] + 1
    }
}

; Generate report
statusText.Value := "Generating report..."
progressBar.Value := 100

report := GenerateReport()

; Save report
reportPath := OUTPUT_DIR "RESEARCH_REPORT.md"
try {
    if FileExist(reportPath)
    FileDelete(reportPath)
    FileAppend(report, reportPath)
} catch as err {
    MsgBox("Error saving report:`n" err.Message, "Error", "Icon!")
}

; Close progress window
progressGui.Destroy()

; Show results
MsgBox("Scan Complete!`n`n"
. "Total files: " totalFiles "`n"
. "V2 scripts: " v2Files "`n"
. "V1 scripts: " v1Files "`n"
. "Unknown: " unknownFiles "`n`n"
. "Report saved to:`n" reportPath,
"Scan Results", "Icon!")

; Ask if user wants to open report
result := MsgBox("Open research report now?", "Open Report", "YesNo Icon?")
if result = "Yes" {
    try {
        Run(reportPath)
    } catch {
        MsgBox("Could not open report. Please open manually:`n" reportPath, "Error", "Icon!")
    }
}

ExitApp

; ============================================================
; Functions
; ============================================================

/**
* Analyze script content and detect features
*/
AnalyzeScript(content, filepath) {
    analysis := {
        path: filepath,
        filename: "",
        size: CountLines(content),
        version: "unknown",
        quality: 0,
        features: [],
        hasComments: false,
        hasClasses: false,
        hasGUI: false,
        hasHotkeys: false
    }

    SplitPath(filepath, &filename)
    analysis.filename := filename

    ; Detect version
    analysis.version := DetectVersion(content)

    ; Detect features
    analysis.features := DetectFeatures(content)

    ; Assess quality
    analysis.quality := AssessQuality(content, analysis)

    ; Additional flags
    analysis.hasComments := InStr(content, "/**") || InStr(content, ";")
    analysis.hasClasses := InStr(content, "class ")
    analysis.hasGUI := InStr(content, "Gui(") || InStr(content, "Gui,")
    analysis.hasHotkeys := InStr(content, "::")

    return analysis
}

/**
* Detect AutoHotkey version
*/
DetectVersion(content) {
    ; Strong v2 indicators
    if InStr(content, "#Requires AutoHotkey v2")
    return "v2"

    ; Check for v2 syntax patterns
    v2Score := 0
    v1Score := 0

    ; V2 indicators
    if RegExMatch(content, "i)\bGui\(")
    v2Score += 2
    if RegExMatch(content, "i)\bMap\(")
    v2Score += 2
    if RegExMatch(content, "i)\bMsgBox\(")
    v2Score += 1
    if InStr(content, "#HotIf")
    v2Score += 2
    if InStr(content, "=>")
    v2Score += 1

    ; V1 indicators
    if RegExMatch(content, "i)\bGui,\s*Add,")
    v1Score += 2
    if RegExMatch(content, "i)\bMsgBox,")
    v1Score += 1
    if RegExMatch(content, "i)\bStringSplit,")
    v1Score += 2
    if InStr(content, "#If ")
    v1Score += 2
    if RegExMatch(content, "i)\b(IfEqual|IfNotEqual|SetEnv)\b")
    v1Score += 2

    ; Determine version based on scores
    if v2Score > v1Score && v2Score >= 2
    return "v2"
    if v1Score > v2Score && v1Score >= 2
    return "v1"

    return "unknown"
}

/**
* Detect features used in script
*/
DetectFeatures(content) {
    features := []

    ; GUI
    if RegExMatch(content, "i)\bGui\(|Gui,\s*Add,")
    features.Push("GUI")

    ; Hotkeys
    if InStr(content, "::")
    features.Push("Hotkeys")

    ; Hotstrings
    if RegExMatch(content, "i)^::.*::", "m")
    features.Push("Hotstrings")

    ; File operations
    if RegExMatch(content, "i)\b(FileRead|FileAppend|FileOpen|DirCreate|Loop\s+Files)\b")
    features.Push("Files")

    ; Window management
    if RegExMatch(content, "i)\b(WinActivate|WinWait|WinMove|WinGetPos)\b")
    features.Push("Windows")

    ; COM
    if RegExMatch(content, "i)\bComObject\(|ComObjCreate\(")
    features.Push("COM")

    ; DllCall
    if InStr(content, "DllCall(")
    features.Push("DllCall")

    ; Classes
    if RegExMatch(content, "i)^\s*class\s+\w+", "m")
    features.Push("OOP")

    ; HTTP/Web
    if RegExMatch(content, "i)\b(WinHttpRequest|Download|UrlDownloadToFile)\b")
    features.Push("HTTP")

    ; Clipboard
    if RegExMatch(content, "i)\bA_Clipboard\b|ClipboardAll")
    features.Push("Clipboard")

    ; RegEx
    if RegExMatch(content, "i)\bRegExMatch\(|RegExReplace\(")
    features.Push("RegEx")

    ; Module system
    if RegExMatch(content, "i)^#Module\b|^Import\b|^Export\b", "m")
    features.Push("Modules")

    return features
}

/**
* Assess code quality (1-5 stars)
*/
AssessQuality(content, analysis) {
    quality := 3  ; Start at average

    ; Positive factors
    if analysis.hasComments
    quality += 1
    if RegExMatch(content, "/\*\*")  ; JSDoc comments
    quality += 1
    if analysis.size >= 50 && analysis.size <= 300  ; Good size
    quality += 1
    if analysis.hasClasses
    quality += 0.5

    ; Negative factors
    if analysis.size < 10
    quality -= 1
    if analysis.size > 1000
    quality -= 1
    if !analysis.hasComments
    quality -= 1

    ; Clamp to 1-5
    if quality > 5
    quality := 5
    if quality < 1
    quality := 1

    return Round(quality)
}

/**
* Count lines in text
*/
CountLines(text) {
    count := 1
    Loop Parse, text, "`n", "`r"
    count++
    return count
}

/**
* Generate research report
*/
GenerateReport() {
    report := ""
    report .= "# Local AutoHotkey Script Research Report`n`n"
    report .= "**Date:** " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"
    report .= "**Source Directory:** " SOURCE_DIR "`n"
    report .= "**Output Directory:** " OUTPUT_DIR "`n`n"
    report .= "---`n`n"

    ; Summary statistics
    report .= "## Summary Statistics`n`n"
    report .= "| Metric | Count |`n"
    report .= "|--------|-------|`n"
    report .= "| Total .ahk files found | " totalFiles " |`n"
    report .= "| AutoHotkey v2 scripts | " v2Files " |`n"
    report .= "| AutoHotkey v1 scripts | " v1Files " |`n"
    report .= "| Unknown version | " unknownFiles " |`n`n"

    ; Version distribution
    if totalFiles > 0 {
        v2Pct := Round((v2Files / totalFiles) * 100, 1)
        v1Pct := Round((v1Files / totalFiles) * 100, 1)
        report .= "**Version Distribution:**`n"
        report .= "- V2: " v2Pct "%`n"
        report .= "- V1: " v1Pct "%`n`n"
    }

    report .= "---`n`n"

    ; Feature coverage
    report .= "## Feature Coverage`n`n"
    report .= "| Feature | Scripts Using |`n"
    report .= "|---------|---------------|`n"

    for feature, count in categories {
        report .= "| " feature " | " count " |`n"
    }
    report .= "`n---`n`n"

    ; Quality distribution
    report .= "## Quality Distribution`n`n"
    qualityCount := Map(1, 0, 2, 0, 3, 0, 4, 0, 5, 0)

    for result in results {
        q := result.quality
        if qualityCount.Has(q)
        qualityCount[q] := qualityCount[q] + 1
    }

    report .= "| Quality Rating | Count | Percentage |`n"
    report .= "|----------------|-------|------------|`n"

    for rating in [5, 4, 3, 2, 1] {
        count := qualityCount[rating]
        pct := totalFiles > 0 ? Round((count / totalFiles) * 100, 1) : 0
        stars := ""
        Loop rating
        stars .= "⭐"
        report .= "| " stars " | " count " | " pct "% |`n"
    }

    report .= "`n---`n`n"

    ; File inventory
    report .= "## File Inventory`n`n"
    report .= "| File Path | Lines | Version | Quality | Features |`n"
    report .= "|-----------|-------|---------|---------|----------|`n"

    for result in results {
        stars := ""
        Loop result.quality
        stars .= "⭐"

        featureStr := result.features.Length > 0 ? result.features[1] : ""
        if result.features.Length > 1
        featureStr .= ", " result.features[2]
        if result.features.Length > 2
        featureStr .= "..."

        ; Truncate long paths
        displayPath := result.path
        if StrLen(displayPath) > 60
        displayPath := "..." SubStr(displayPath, -57)

        report .= "| " displayPath " | " result.size " | " result.version " | " stars " | " featureStr " |`n"
    }

    report .= "`n---`n`n"

    ; Recommendations
    report .= "## Recommendations`n`n"

    ; High-quality v2 scripts
    report .= "### High-Quality V2 Scripts (Good for Training)`n`n"
    goodV2Count := 0
    for result in results {
        if result.version = "v2" && result.quality >= 4 {
            report .= "- **" result.filename "** (" result.size " lines) - "
            report .= "Features: " (result.features.Length > 0 ? result.features.Join(", ") : "none detected") "`n"
            goodV2Count++
            if goodV2Count >= 10
            break
        }
    }
    if goodV2Count = 0
    report .= "*No high-quality v2 scripts found*`n"

    report .= "`n"

    ; V1 scripts worth converting
    report .= "### V1 Scripts Worth Converting`n`n"
    convertCount := 0
    for result in results {
        if result.version = "v1" && result.quality >= 3 && result.size < 500 {
            report .= "- **" result.filename "** (" result.size " lines) - "
            report .= "Features: " (result.features.Length > 0 ? result.features.Join(", ") : "none detected") "`n"
            convertCount++
            if convertCount >= 10
            break
        }
    }
    if convertCount = 0
    report .= "*No good conversion candidates found*`n"

    report .= "`n---`n`n"

    ; Next steps
    report .= "## Next Steps`n`n"
    report .= "1. Review high-quality v2 scripts listed above`n"
    report .= "2. Extract valuable examples to Training folder`n"
    report .= "3. Add proper documentation headers to extracted examples`n"
    report .= "4. Consider converting valuable v1 scripts`n"
    report .= "5. Organize examples by category`n`n"

    report .= "---`n`n"
    report .= "*Report generated by Local Script Research Scanner*`n"

    return report
}
