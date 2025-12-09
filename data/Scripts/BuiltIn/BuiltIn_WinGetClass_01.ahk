/**
* @file BuiltIn_WinGetClass_01.ahk
* @description Comprehensive examples demonstrating WinGetClass function for retrieving window class names in AutoHotkey v2
* @author AutoHotkey Foundation
* @version 2.0
* @date 2024-01-15
*
* @section EXAMPLES
* Example 1: Basic window class retrieval
* Example 2: Window class analyzer
* Example 3: Class-based window identification
* Example 4: Window class database
* Example 5: Class filtering system
* Example 6: Multi-window class comparison
* Example 7: Application identification by class
*
* @section FEATURES
* - Get window class names
* - Identify applications by class
* - Filter windows by class
* - Build class databases
* - Compare window classes
* - Pattern matching
* - Application detection
*/

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Window Class Retrieval
; ========================================

/**
* @function GetWindowClass
* @description Get the class name of a window
* @param WinTitle Window identifier
* @returns {String} Window class name
*/
GetWindowClass(WinTitle := "A") {
    try {
        className := WinGetClass(WinTitle)
        return className
    } catch as err {
        return ""
    }
}

/**
* @function ShowWindowClassInfo
* @description Display comprehensive class information for a window
* @param WinTitle Window identifier
*/
ShowWindowClassInfo(WinTitle := "A") {
    try {
        className := WinGetClass(WinTitle)
        winTitle := WinGetTitle(WinTitle)
        processName := WinGetProcessName(WinTitle)
        pid := WinGetPID(WinTitle)

        info := "Window Class Information:`n`n"
        info .= "Title: " winTitle "`n"
        info .= "Class: " className "`n"
        info .= "Process: " processName "`n"
        info .= "PID: " pid "`n`n"
        info .= "Full Identifier: ahk_class " className

        MsgBox(info, "Window Class Info", "Icon!")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", "IconX")
    }
}

; Hotkey: Ctrl+Shift+C - Show window class info
^+c:: ShowWindowClassInfo("A")

; ========================================
; Example 2: Window Class Analyzer
; ========================================

/**
* @class WindowClassAnalyzer
* @description Advanced analysis of window classes
*/
class WindowClassAnalyzer {
    /**
    * @method AnalyzeClass
    * @description Analyze window class and provide detailed information
    * @param WinTitle Window identifier
    * @returns {Object} Analysis data
    */
    static AnalyzeClass(WinTitle := "A") {
        try {
            className := WinGetClass(WinTitle)

            analysis := {
                ClassName: className,
                Length: StrLen(className),
                Type: this.DetermineClassType(className),
                IsStandard: this.IsStandardClass(className),
                IsDialog: this.IsDialogClass(className),
                IsCommon: this.IsCommonControlClass(className),
                Framework: this.DetectFramework(className),
                Prefix: this.ExtractPrefix(className),
                IsCustom: !this.IsStandardClass(className)
            }

            return analysis

        } catch as err {
            return {Error: err.Message}
        }
    }

    /**
    * @method DetermineClassType
    * @description Determine the type of window class
    * @param className Class name
    * @returns {String} Class type
    */
    static DetermineClassType(className) {
        if InStr(className, "WindowsForms") || InStr(className, "HwndWrapper")
        return ".NET WinForms"
        if InStr(className, "WPF") || InStr(className, "Xaml")
        return "WPF"
        if InStr(className, "Qt")
        return "Qt Framework"
        if InStr(className, "Chrome") || InStr(className, "Electron")
        return "Electron/Chrome"
        if InStr(className, "MozillaWindow")
        return "Firefox/Mozilla"
        if InStr(className, "SunAwt")
        return "Java AWT"
        if className = "#32770"
        return "Dialog"
        if SubStr(className, 1, 1) = "#"
        return "System Control"

        return "Custom/Unknown"
    }

    /**
    * @method IsStandardClass
    * @description Check if class is a standard Windows class
    * @param className Class name
    * @returns {Boolean} True if standard
    */
    static IsStandardClass(className) {
        standardClasses := [
        "#32770",  ; Dialog
        "Button", "Edit", "Static", "ListBox", "ComboBox",
        "ScrollBar", "SysListView32", "SysTreeView32",
        "SysTabControl32", "SysHeader32", "ToolbarWindow32",
        "msctls_statusbar32", "msctls_progress32",
        "Progman", "Shell_TrayWnd", "WorkerW"
        ]

        for stdClass in standardClasses {
            if className = stdClass
            return true
        }

        return false
    }

    /**
    * @method IsDialogClass
    * @description Check if class is a dialog
    * @param className Class name
    * @returns {Boolean} True if dialog
    */
    static IsDialogClass(className) {
        return (className = "#32770" || InStr(className, "Dialog"))
    }

    /**
    * @method IsCommonControlClass
    * @description Check if class is a common control
    * @param className Class name
    * @returns {Boolean} True if common control
    */
    static IsCommonControlClass(className) {
        commonControls := [
        "Button", "Edit", "Static", "ListBox", "ComboBox",
        "ScrollBar", "SysListView32", "SysTreeView32",
        "SysTabControl32", "SysHeader32"
        ]

        for control in commonControls {
            if InStr(className, control)
            return true
        }

        return false
    }

    /**
    * @method DetectFramework
    * @description Detect UI framework from class name
    * @param className Class name
    * @returns {String} Framework name
    */
    static DetectFramework(className) {
        if InStr(className, "WindowsForms")
        return ".NET Windows Forms"
        if InStr(className, "HwndWrapper")
        return ".NET WPF"
        if InStr(className, "Qt")
        return "Qt"
        if InStr(className, "Electron")
        return "Electron"
        if InStr(className, "Chrome")
        return "Chromium"
        if InStr(className, "Mozilla")
        return "Gecko/Mozilla"
        if InStr(className, "SunAwt")
        return "Java Swing/AWT"
        if InStr(className, "GLFW")
        return "GLFW"

        return "Win32/Native"
    }

    /**
    * @method ExtractPrefix
    * @description Extract prefix from class name
    * @param className Class name
    * @returns {String} Prefix
    */
    static ExtractPrefix(className) {
        if SubStr(className, 1, 1) = "#"
        return "#"

        ; Find first capital letter sequence
        Loop Parse className {
            if A_LoopField ~= "[A-Z]" {
                continue
            } else {
                return SubStr(className, 1, A_Index - 1)
            }
        }

        return className
    }
}

; Hotkey: Ctrl+Shift+A - Analyze window class
^+a:: {
    analysis := WindowClassAnalyzer.AnalyzeClass("A")

    if analysis.HasOwnProp("Error") {
        MsgBox(analysis.Error, "Error", "IconX")
        return
    }

    output := "=== Window Class Analysis ===`n`n"
    output .= "Class Name: " analysis.ClassName "`n"
    output .= "Length: " analysis.Length " characters`n"
    output .= "Type: " analysis.Type "`n"
    output .= "Framework: " analysis.Framework "`n"
    output .= "Standard Class: " (analysis.IsStandard ? "Yes" : "No") "`n"
    output .= "Dialog: " (analysis.IsDialog ? "Yes" : "No") "`n"
    output .= "Common Control: " (analysis.IsCommon ? "Yes" : "No") "`n"
    output .= "Custom: " (analysis.IsCustom ? "Yes" : "No")

    if analysis.Prefix != ""
    output .= "`nPrefix: " analysis.Prefix

    MsgBox(output, "Class Analysis", "Icon!")
}

; ========================================
; Example 3: Class-Based Window Identification
; ========================================

/**
* @class WindowIdentifier
* @description Identify and categorize windows by their class
*/
class WindowIdentifier {
    /**
    * @method IdentifyByClass
    * @description Identify application/window type by class
    * @param className Window class name
    * @returns {Object} Identification data
    */
    static IdentifyByClass(className) {
        identification := {
            ClassName: className,
            Application: "Unknown",
            Category: "Unknown",
            Description: "",
            IsSystem: false,
            IsApplication: false
        }

        ; Check for known applications
        if InStr(className, "Chrome_WidgetWin") {
            identification.Application := "Google Chrome"
            identification.Category := "Web Browser"
            identification.Description := "Chrome-based browser window"
            identification.IsApplication := true
        }
        else if InStr(className, "MozillaWindowClass") {
            identification.Application := "Firefox"
            identification.Category := "Web Browser"
            identification.Description := "Firefox browser window"
            identification.IsApplication := true
        }
        else if InStr(className, "ApplicationFrameWindow") {
            identification.Application := "UWP Application"
            identification.Category := "Universal Windows Platform"
            identification.Description := "Modern Windows 10/11 app"
            identification.IsApplication := true
        }
        else if InStr(className, "Notepad") {
            identification.Application := "Notepad"
            identification.Category := "Text Editor"
            identification.Description := "Windows Notepad"
            identification.IsApplication := true
        }
        else if InStr(className, "CabinetWClass") {
            identification.Application := "File Explorer"
            identification.Category := "File Manager"
            identification.Description := "Windows File Explorer"
            identification.IsSystem := true
        }
        else if InStr(className, "Shell_TrayWnd") {
            identification.Application := "Taskbar"
            identification.Category := "System UI"
            identification.Description := "Windows Taskbar"
            identification.IsSystem := true
        }
        else if InStr(className, "Progman") {
            identification.Application := "Program Manager"
            identification.Category := "Desktop"
            identification.Description := "Windows Desktop"
            identification.IsSystem := true
        }
        else if className = "#32770" {
            identification.Application := "Dialog Box"
            identification.Category := "Dialog"
            identification.Description := "Standard Windows dialog"
            identification.IsApplication := true
        }

        return identification
    }

    /**
    * @method FindWindowsByClass
    * @description Find all windows with a specific class
    * @param className Class name to search for
    * @param exactMatch Require exact match (default: true)
    * @returns {Array} Array of window IDs
    */
    static FindWindowsByClass(className, exactMatch := true) {
        matchingWindows := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                winClass := WinGetClass("ahk_id " winId)

                if exactMatch {
                    if winClass = className {
                        matchingWindows.Push(winId)
                    }
                } else {
                    if InStr(winClass, className) {
                        matchingWindows.Push(winId)
                    }
                }
            }
        }

        return matchingWindows
    }

    /**
    * @method GetApplicationWindows
    * @description Get all windows belonging to an application
    * @param appIdentifier Application identifier (class pattern)
    * @returns {Array} Window data
    */
    static GetApplicationWindows(appIdentifier) {
        windows := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                winClass := WinGetClass("ahk_id " winId)

                if InStr(winClass, appIdentifier) {
                    windows.Push({
                        ID: winId,
                        Title: WinGetTitle("ahk_id " winId),
                        Class: winClass,
                        Process: WinGetProcessName("ahk_id " winId)
                    })
                }
            }
        }

        return windows
    }
}

; Hotkey: Ctrl+Shift+I - Identify window by class
^+i:: {
    className := WinGetClass("A")
    identification := WindowIdentifier.IdentifyByClass(className)

    output := "=== Window Identification ===`n`n"
    output .= "Class: " identification.ClassName "`n"
    output .= "Application: " identification.Application "`n"
    output .= "Category: " identification.Category "`n"
    output .= "Description: " identification.Description "`n"
    output .= "System Window: " (identification.IsSystem ? "Yes" : "No") "`n"
    output .= "Application Window: " (identification.IsApplication ? "Yes" : "No")

    MsgBox(output, "Window Identification", "Icon!")
}

; ========================================
; Example 4: Window Class Database
; ========================================

/**
* @class ClassDatabase
* @description Build and maintain a database of window classes
*/
class ClassDatabase {
    static database := Map()
    static scanCount := 0

    /**
    * @method ScanAllClasses
    * @description Scan all windows and catalog their classes
    * @returns {Integer} Number of unique classes found
    */
    static ScanAllClasses() {
        this.database := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                className := WinGetClass("ahk_id " winId)
                winTitle := WinGetTitle("ahk_id " winId)
                processName := WinGetProcessName("ahk_id " winId)

                if !this.database.Has(className) {
                    this.database[className] := {
                        ClassName: className,
                        Count: 0,
                        Windows: [],
                        Processes: Map(),
                        FirstSeen: A_Now
                    }
                }

                entry := this.database[className]
                entry.Count++
                entry.Windows.Push({
                    ID: winId,
                    Title: winTitle
                })

                if !entry.Processes.Has(processName) {
                    entry.Processes[processName] := 0
                }
                entry.Processes[processName]++

            }
        }

        this.scanCount++
        return this.database.Count
    }

    /**
    * @method GetClassInfo
    * @description Get information about a specific class
    * @param className Class name
    * @returns {Object} Class information
    */
    static GetClassInfo(className) {
        if !this.database.Has(className) {
            return {Error: "Class not in database"}
        }

        return this.database[className]
    }

    /**
    * @method GetStatistics
    * @description Get database statistics
    * @returns {Object} Statistics
    */
    static GetStatistics() {
        if this.database.Count = 0 {
            return {Error: "Database is empty"}
        }

        totalWindows := 0
        mostCommonClass := ""
        mostCommonCount := 0

        for className, data in this.database {
            totalWindows += data.Count

            if data.Count > mostCommonCount {
                mostCommonCount := data.Count
                mostCommonClass := className
            }
        }

        return {
            UniqueClasses: this.database.Count,
            TotalWindows: totalWindows,
            MostCommon: {
                Class: mostCommonClass,
                Count: mostCommonCount
            },
            AveragePerClass: Round(totalWindows / this.database.Count, 1),
            LastScan: A_Now,
            ScanCount: this.scanCount
        }
    }

    /**
    * @method ExportToText
    * @description Export database to formatted text
    * @returns {String} Formatted database
    */
    static ExportToText() {
        if this.database.Count = 0 {
            return "Database is empty. Run ScanAllClasses() first."
        }

        output := "=== Window Class Database ===`n"
        output .= "Scan Date: " A_Now "`n"
        output .= "Unique Classes: " this.database.Count "`n`n"

        ; Sort classes by count
        sortedClasses := []
        for className, data in this.database {
            sortedClasses.Push(data)
        }

        ; Simple bubble sort
        Loop sortedClasses.Length - 1 {
            i := A_Index
            Loop sortedClasses.Length - i {
                j := A_Index
                if sortedClasses[j].Count < sortedClasses[j + 1].Count {
                    temp := sortedClasses[j]
                    sortedClasses[j] := sortedClasses[j + 1]
                    sortedClasses[j + 1] := temp
                }
            }
        }

        ; Output sorted list
        for data in sortedClasses {
            output .= data.ClassName " (" data.Count " window"
            output .= data.Count > 1 ? "s" : ""
            output .= ")`n"

            ; List processes
            for processName, count in data.Processes {
                output .= "  - " processName " (" count ")`n"
            }
            output .= "`n"
        }

        return output
    }

    /**
    * @method FindSimilarClasses
    * @description Find classes with similar names
    * @param className Reference class name
    * @param threshold Similarity threshold (0-1)
    * @returns {Array} Similar classes
    */
    static FindSimilarClasses(className, threshold := 0.5) {
        similar := []

        for dbClass, data in this.database {
            if dbClass = className
            continue

            ; Calculate similarity (simple approach)
            similarity := this.CalculateSimilarity(className, dbClass)

            if similarity >= threshold {
                similar.Push({
                    ClassName: dbClass,
                    Similarity: similarity,
                    Count: data.Count
                })
            }
        }

        return similar
    }

    /**
    * @method CalculateSimilarity
    * @description Calculate string similarity (0-1)
    * @param str1 First string
    * @param str2 Second string
    * @returns {Float} Similarity score
    */
    static CalculateSimilarity(str1, str2) {
        ; Simple longest common substring approach
        if str1 = str2
        return 1.0

        if str1 = "" || str2 = ""
        return 0.0

        maxLen := Max(StrLen(str1), StrLen(str2))
        commonLength := 0

        ; Check for common prefix
        Loop Min(StrLen(str1), StrLen(str2)) {
            if SubStr(str1, A_Index, 1) = SubStr(str2, A_Index, 1) {
                commonLength++
            } else {
                break
            }
        }

        ; Check for substring containment
        if InStr(str1, str2) || InStr(str2, str1) {
            commonLength := Max(commonLength, Min(StrLen(str1), StrLen(str2)))
        }

        return commonLength / maxLen
    }
}

; Hotkey: Ctrl+Shift+D - Scan and show database
^+d:: {
    count := ClassDatabase.ScanAllClasses()
    stats := ClassDatabase.GetStatistics()

    output := "Database scan complete!`n`n"
    output .= "Unique Classes: " stats.UniqueClasses "`n"
    output .= "Total Windows: " stats.TotalWindows "`n"
    output .= "Most Common: " stats.MostCommon.Class " (" stats.MostCommon.Count ")`n"
    output .= "Average per Class: " stats.AveragePerClass

    MsgBox(output, "Class Database", "Icon!")
}

; Hotkey: Ctrl+Shift+E - Export database
^+e:: {
    export := ClassDatabase.ExportToText()

    ; Save to file
    fileName := A_ScriptDir "\window_classes.txt"
    try {
        FileDelete(fileName)
    }
    FileAppend(export, fileName)

    MsgBox("Database exported to:`n" fileName, "Export Complete", "Icon!")
}

; ========================================
; Example 5: Class Filtering System
; ========================================

/**
* @class ClassFilter
* @description Filter windows based on class criteria
*/
class ClassFilter {
    static filters := []

    /**
    * @method AddFilter
    * @description Add a class filter
    * @param pattern Class name pattern
    * @param matchType Match type (exact, contains, starts, ends, regex)
    */
    static AddFilter(pattern, matchType := "contains") {
        this.filters.Push({
            Pattern: pattern,
            MatchType: matchType,
            Created: A_Now
        })
    }

    /**
    * @method ClearFilters
    * @description Clear all filters
    */
    static ClearFilters() {
        this.filters := []
    }

    /**
    * @method TestClass
    * @description Test if a class matches any filter
    * @param className Class name to test
    * @returns {Boolean} True if matches
    */
    static TestClass(className) {
        if this.filters.Length = 0
        return true

        for filter in this.filters {
            if this.MatchPattern(className, filter.Pattern, filter.MatchType) {
                return true
            }
        }

        return false
    }

    /**
    * @method MatchPattern
    * @description Check if class matches pattern
    * @param className Class name
    * @param pattern Pattern to match
    * @param matchType Type of match
    * @returns {Boolean} True if matches
    */
    static MatchPattern(className, pattern, matchType) {
        switch matchType {
            case "exact":
            return className = pattern
            case "contains":
            return InStr(className, pattern) > 0
            case "starts":
            return SubStr(className, 1, StrLen(pattern)) = pattern
            case "ends":
            return SubStr(className, -StrLen(pattern)) = pattern
            case "regex":
            return className ~= pattern
        }
        return false
    }

    /**
    * @method GetFilteredWindows
    * @description Get all windows matching filters
    * @returns {Array} Filtered window list
    */
    static GetFilteredWindows() {
        filtered := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                className := WinGetClass("ahk_id " winId)

                if this.TestClass(className) {
                    filtered.Push({
                        ID: winId,
                        Class: className,
                        Title: WinGetTitle("ahk_id " winId)
                    })
                }
            }
        }

        return filtered
    }

    /**
    * @method CreateBlacklist
    * @description Create a blacklist of classes to ignore
    * @param classList Array of class names
    */
    static CreateBlacklist(classList) {
        this.ClearFilters()

        allClasses := this.GetAllUniqueClasses()

        for className in allClasses {
            isBlacklisted := false

            for blacklisted in classList {
                if className = blacklisted {
                    isBlacklisted := true
                    break
                }
            }

            if !isBlacklisted {
                this.AddFilter(className, "exact")
            }
        }
    }

    /**
    * @method GetAllUniqueClasses
    * @description Get all unique class names
    * @returns {Array} Unique classes
    */
    static GetAllUniqueClasses() {
        classes := Map()
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                className := WinGetClass("ahk_id " winId)
                classes[className] := true
            }
        }

        result := []
        for className, _ in classes {
            result.Push(className)
        }

        return result
    }
}

; Hotkey: Ctrl+Shift+F - Add filter for current class
^+f:: {
    className := WinGetClass("A")
    ClassFilter.AddFilter(className, "exact")
    TrayTip("Filter added: " className, "Class Filter", "Icon!")
}

; ========================================
; Example 6 & 7: Additional helpers
; ========================================

/**
* @function CompareWindowClasses
* @description Compare classes of multiple windows
* @param winTitles Array of window titles
* @returns {Object} Comparison results
*/
CompareWindowClasses(winTitles) {
    classes := []

    for winTitle in winTitles {
        try {
            className := WinGetClass(winTitle)
            classes.Push({
                Window: winTitle,
                Class: className
            })
        }
    }

    ; Check if all same
    allSame := true
    if classes.Length > 1 {
        firstClass := classes[1].Class
        for i, data in classes {
            if i = 1
            continue
            if data.Class != firstClass {
                allSame := false
                break
            }
        }
    }

    return {
        Classes: classes,
        AllSame: allSame,
        UniqueCount: CountUnique(classes)
    }
}

/**
* @function CountUnique
* @description Count unique classes in array
* @param classes Array of class data
* @returns {Integer} Unique count
*/
CountUnique(classes) {
    unique := Map()
    for data in classes {
        unique[data.Class] := true
    }
    return unique.Count
}

; ========================================
; Script Initialization
; ========================================

; Show help on startup
if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetClass Examples - Hotkeys:

    Ctrl+Shift+C  - Show window class info
    Ctrl+Shift+A  - Analyze window class
    Ctrl+Shift+I  - Identify window by class
    Ctrl+Shift+D  - Scan class database
    Ctrl+Shift+E  - Export database
    Ctrl+Shift+F  - Add class filter
    )"

    TrayTip(help, "WinGetClass Examples Ready", "Icon!")
}
