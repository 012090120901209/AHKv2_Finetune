/**
* @file BuiltIn_WinGetClass_03.ahk
* @description Window class pattern matching, detection, and filtering examples using WinGetClass in AutoHotkey v2
* @author AutoHotkey Foundation
* @version 2.0
* @date 2024-01-15
*
* @section EXAMPLES
* Example 1: Advanced class pattern matching
* Example 2: Class-based window picker
* Example 3: Class history tracker
* Example 4: Cross-application class mapper
* Example 5: Class-based window rules engine
* Example 6: Window class validator
*
* @section FEATURES
* - Pattern matching
* - Window selection
* - History tracking
* - Cross-app mapping
* - Rules engine
* - Validation
*/

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Advanced Class Pattern Matching
; ========================================

/**
* @class PatternMatcher
* @description Advanced pattern matching for window classes
*/
class PatternMatcher {
    /**
    * @method Match
    * @description Match window class against pattern
    * @param className Class name to test
    * @param pattern Pattern to match (supports wildcards and regex)
    * @param mode Match mode (wildcard, regex, exact)
    * @returns {Boolean} True if matches
    */
    static Match(className, pattern, mode := "wildcard") {
        switch mode {
            case "exact":
            return className = pattern

            case "wildcard":
            ; Convert wildcard to regex
            regexPattern := "^" RegExReplace(RegExReplace(pattern, "\.", "\."), "\*", ".*") "$"
            return className ~= regexPattern

            case "regex":
            return className ~= pattern

            case "contains":
            return InStr(className, pattern) > 0

            case "starts":
            return SubStr(className, 1, StrLen(pattern)) = pattern

            case "ends":
            return SubStr(className, -StrLen(pattern) + 1) = pattern
        }

        return false
    }

    /**
    * @method FindByPattern
    * @description Find all windows matching a class pattern
    * @param pattern Pattern to match
    * @param mode Match mode
    * @returns {Array} Matching windows
    */
    static FindByPattern(pattern, mode := "wildcard") {
        matches := []
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                className := WinGetClass("ahk_id " winId)

                if this.Match(className, pattern, mode) {
                    matches.Push({
                        ID: winId,
                        Class: className,
                        Title: WinGetTitle("ahk_id " winId),
                        Process: WinGetProcessName("ahk_id " winId)
                    })
                }
            }
        }

        return matches
    }

    /**
    * @method MatchMultiple
    * @description Match against multiple patterns
    * @param className Class to test
    * @param patterns Array of patterns
    * @param matchAll Require all patterns to match (AND logic)
    * @returns {Boolean} True if matches
    */
    static MatchMultiple(className, patterns, matchAll := false) {
        matchCount := 0

        for pattern in patterns {
            if this.Match(className, pattern, "wildcard") {
                matchCount++

                if !matchAll {
                    return true
                }
            }
        }

        if matchAll {
            return matchCount = patterns.Length
        }

        return matchCount > 0
    }

    /**
    * @method CreateSmartFilter
    * @description Create a smart filter from multiple criteria
    * @param criteria Filter criteria object
    * @returns {Func} Filter function
    */
    static CreateSmartFilter(criteria) {
        Filter(className) {
            ; Include patterns
            if criteria.HasOwnProp("Include") {
                matched := false
                for pattern in criteria.Include {
                    if this.Match(className, pattern, "wildcard") {
                        matched := true
                        break
                    }
                }
                if !matched
                return false
            }

            ; Exclude patterns
            if criteria.HasOwnProp("Exclude") {
                for pattern in criteria.Exclude {
                    if this.Match(className, pattern, "wildcard") {
                        return false
                    }
                }
            }

            ; Length constraints
            if criteria.HasOwnProp("MinLength") && StrLen(className) < criteria.MinLength {
                return false
            }

            if criteria.HasOwnProp("MaxLength") && StrLen(className) > criteria.MaxLength {
                return false
            }

            ; Prefix requirement
            if criteria.HasOwnProp("RequirePrefix") {
                hasPrefix := false
                for prefix in criteria.RequirePrefix {
                    if SubStr(className, 1, StrLen(prefix)) = prefix {
                        hasPrefix := true
                        break
                    }
                }
                if !hasPrefix
                return false
            }

            return true
        }
        return Filter
    }
}

; Hotkey: Ctrl+Shift+F - Find by pattern
^+f:: {
    pattern := InputBox("Enter class pattern (* for wildcard):", "Pattern Match", "w300").Value
    if pattern = ""
    return

    matches := PatternMatcher.FindByPattern(pattern, "wildcard")

    if matches.Length = 0 {
        MsgBox("No windows match pattern: " pattern, "No Matches", "Icon!")
        return
    }

    output := "Found " matches.Length " matching window(s):`n`n"

    for i, win in matches {
        if i > 10
        break

        output .= win.Class "`n"
        if win.Title != ""
        output .= "  " win.Title "`n"
        output .= "  " win.Process "`n`n"
    }

    MsgBox(output, "Pattern Matches", "Icon!")
}

; ========================================
; Example 2: Class-Based Window Picker
; ========================================

/**
* @class WindowPicker
* @description Interactive window picker by class
*/
class WindowPicker {
    static pickerGui := ""
    static selectedWindow := 0

    /**
    * @method ShowPicker
    * @description Show window picker GUI
    * @param filterClass Optional class filter
    */
    static ShowPicker(filterClass := "") {
        this.selectedWindow := 0

        ; Create GUI
        this.pickerGui := Gui("+AlwaysOnTop", "Select Window")
        this.pickerGui.SetFont("s10")

        this.pickerGui.Add("Text", "w400", "Select a window by class:")

        ; Add list view
        lv := this.pickerGui.Add("ListView", "w600 h400 vWindowList", ["Class", "Title", "Process"])

        ; Populate list
        allWindows := WinGetList()

        for winId in allWindows {
            try {
                className := WinGetClass("ahk_id " winId)
                title := WinGetTitle("ahk_id " winId)
                process := WinGetProcessName("ahk_id " winId)

                ; Apply filter
                if filterClass != "" && !InStr(className, filterClass) {
                    continue
                }

                lv.Add(, className, title, process)
                lv.Modify(lv.GetCount(), "Ptr", winId)  ; Store window ID
            }
        }

        ; Auto-size columns
        lv.ModifyCol()

        ; Add buttons
        this.pickerGui.Add("Button", "w120 Default", "Select").OnEvent("Click", (*) => this.OnSelect())
        this.pickerGui.Add("Button", "x+10 w120", "Cancel").OnEvent("Click", (*) => this.pickerGui.Destroy())

        ; Show GUI
        this.pickerGui.Show()
    }

    /**
    * @method OnSelect
    * @description Handle window selection
    */
    static OnSelect() {
        lv := this.pickerGui["WindowList"]
        selected := lv.GetNext()

        if selected {
            this.selectedWindow := lv.GetNext(0, "Ptr")
            this.pickerGui.Destroy()

            ; Activate selected window
            try {
                WinActivate("ahk_id " this.selectedWindow)
            }
        }
    }

    /**
    * @method PickByClassGroup
    * @description Pick window from a specific class group
    * @param classGroup Group of related classes
    * @returns {Integer} Selected window ID
    */
    static PickByClassGroup(classGroup) {
        this.selectedWindow := 0

        gui := Gui("+AlwaysOnTop", "Select from Group")
        lv := gui.Add("ListView", "w500 h300", ["Window", "Class"])

        allWindows := WinGetList()

        for winId in allWindows {
            try {
                className := WinGetClass("ahk_id " winId)

                for groupClass in classGroup {
                    if InStr(className, groupClass) {
                        title := WinGetTitle("ahk_id " winId)
                        lv.Add(, title, className)
                        lv.Modify(lv.GetCount(), "Ptr", winId)
                        break
                    }
                }
            }
        }

        lv.ModifyCol()

        gui.Add("Button", "Default", "OK").OnEvent("Click", (*) => gui.Destroy())
        gui.Show()

        return this.selectedWindow
    }
}

; Hotkey: Ctrl+Shift+P - Show window picker
^+p:: WindowPicker.ShowPicker()

; ========================================
; Example 3: Class History Tracker
; ========================================

/**
* @class ClassHistory
* @description Track window class activation history
*/
class ClassHistory {
    static history := []
    static maxHistory := 100
    static tracking := false
    static trackTimer := 0

    /**
    * @method StartTracking
    * @description Begin tracking window class history
    */
    static StartTracking() {
        this.tracking := true
        this.trackTimer := SetTimer(() => this.RecordActive(), 1000)
        TrayTip("Class history tracking started", "Class History", "Icon!")
    }

    /**
    * @method StopTracking
    * @description Stop tracking
    */
    static StopTracking() {
        this.tracking := false
        if this.trackTimer {
            SetTimer(this.trackTimer, 0)
            this.trackTimer := 0
        }
        TrayTip("Class history tracking stopped", "Class History", "Icon!")
    }

    /**
    * @method RecordActive
    * @description Record currently active window class
    */
    static RecordActive() {
        try {
            className := WinGetClass("A")
            title := WinGetTitle("A")

            ; Don't record if same as last entry
            if this.history.Length > 0 {
                last := this.history[-1]
                if last.Class = className && last.Title = title {
                    return
                }
            }

            this.history.Push({
                Class: className,
                Title: title,
                Time: A_Now,
                Duration: 0
            })

            ; Update duration of previous entry
            if this.history.Length > 1 {
                prev := this.history[-2]
                prev.Duration := DateDiff(A_Now, prev.Time, "Seconds")
            }

            ; Trim history
            if this.history.Length > this.maxHistory {
                this.history.RemoveAt(1)
            }

        } catch {
            ; Ignore errors
        }
    }

    /**
    * @method GetStatistics
    * @description Get usage statistics
    * @returns {Object} Statistics
    */
    static GetStatistics() {
        if this.history.Length = 0 {
            return {Error: "No history data"}
        }

        classTime := Map()

        for entry in this.history {
            if !classTime.Has(entry.Class) {
                classTime[entry.Class] := 0
            }
            classTime[entry.Class] += entry.Duration
        }

        ; Find most used class
        mostUsedClass := ""
        mostUsedTime := 0

        for className, time in classTime {
            if time > mostUsedTime {
                mostUsedTime := time
                mostUsedClass := className
            }
        }

        return {
            TotalEntries: this.history.Length,
            UniqueClasses: classTime.Count,
            MostUsed: {
                Class: mostUsedClass,
                Time: mostUsedTime
            },
            ClassBreakdown: classTime
        }
    }

    /**
    * @method ExportHistory
    * @description Export history to text
    * @returns {String} Formatted history
    */
    static ExportHistory() {
        output := "=== Window Class History ===`n`n"

        for i, entry in this.history {
            output .= FormatTime(entry.Time, "HH:mm:ss") " - " entry.Class
            if entry.Title != ""
            output .= " (" entry.Title ")"
            if entry.Duration > 0
            output .= " [" entry.Duration "s]"
            output .= "`n"
        }

        return output
    }
}

; Hotkey: Ctrl+Shift+T - Toggle history tracking
^+t:: {
    if !ClassHistory.tracking {
        ClassHistory.StartTracking()
    } else {
        ClassHistory.StopTracking()

        ; Show statistics
        stats := ClassHistory.GetStatistics()
        if !stats.HasOwnProp("Error") {
            output := "History Statistics:`n`n"
            output .= "Total Entries: " stats.TotalEntries "`n"
            output .= "Unique Classes: " stats.UniqueClasses "`n"
            output .= "Most Used: " stats.MostUsed.Class "`n"
            output .= "Time: " stats.MostUsed.Time " seconds"

            MsgBox(output, "Class History", "Icon!")
        }
    }
}

; ========================================
; Example 4: Cross-Application Class Mapper
; ========================================

/**
* @class ClassMapper
* @description Map similar functions across different application classes
*/
class ClassMapper {
    static mappings := Map()

    /**
    * @method MapAction
    * @description Map an action to multiple application classes
    * @param actionName Name of the action
    * @param classActions Map of class to action function
    */
    static MapAction(actionName, classActions) {
        this.mappings[actionName] := classActions
    }

    /**
    * @method ExecuteAction
    * @description Execute mapped action for current window class
    * @param actionName Action to execute
    */
    static ExecuteAction(actionName) {
        if !this.mappings.Has(actionName) {
            MsgBox("Action not mapped: " actionName, "Error", "IconX")
            return
        }

        try {
            className := WinGetClass("A")
            actions := this.mappings[actionName]

            ; Find matching class
            for mappedClass, action in actions {
                if InStr(className, mappedClass) {
                    action()
                    return
                }
            }

            MsgBox("No mapping for class: " className, "Info", "Icon!")

        } catch as err {
            MsgBox("Action failed: " err.Message, "Error", "IconX")
        }
    }

    /**
    * @method CreateCommonMappings
    * @description Create mappings for common actions
    */
    static CreateCommonMappings() {
        ; New Tab action
        newTabActions := Map()
        newTabActions["Chrome"] := () => Send("^t")
        newTabActions["Mozilla"] := () => Send("^t")
        newTabActions["Notepad"] := () => Send("^n")
        newTabActions["CabinetW"] := () => Send("^n")  ; Explorer

        this.MapAction("NewTab", newTabActions)

        ; Close action
        closeActions := Map()
        closeActions["Chrome"] := () => Send("^w")
        closeActions["Mozilla"] := () => Send("^w")
        closeActions["Notepad"] := () => Send("^w")

        this.MapAction("Close", closeActions)

        TrayTip("Common mappings created", "Class Mapper", "Icon!")
    }
}

; Initialize mappings
ClassMapper.CreateCommonMappings()

; Hotkey: Ctrl+Alt+N - New tab/window (mapped)
^!n:: ClassMapper.ExecuteAction("NewTab")

; ========================================
; Example 5: Class-Based Window Rules Engine
; ========================================

/**
* @class RulesEngine
* @description Apply rules to windows based on their class
*/
class RulesEngine {
    static rules := []

    /**
    * @method AddRule
    * @description Add a window rule
    * @param classPattern Class pattern to match
    * @param conditions Additional conditions
    * @param actions Actions to apply
    */
    static AddRule(classPattern, conditions, actions) {
        this.rules.Push({
            ClassPattern: classPattern,
            Conditions: conditions,
            Actions: actions,
            Created: A_Now,
            ApplyCount: 0
        })
    }

    /**
    * @method EvaluateWindow
    * @description Evaluate and apply rules to a window
    * @param WinTitle Window identifier
    */
    static EvaluateWindow(WinTitle := "A") {
        try {
            className := WinGetClass(WinTitle)
            winTitle := WinGetTitle(WinTitle)

            for rule in this.rules {
                ; Check class pattern
                if !PatternMatcher.Match(className, rule.ClassPattern, "wildcard") {
                    continue
                }

                ; Check conditions
                if !this.CheckConditions(WinTitle, rule.Conditions) {
                    continue
                }

                ; Apply actions
                this.ApplyActions(WinTitle, rule.Actions)
                rule.ApplyCount++
            }

        } catch as err {
            MsgBox("Rule evaluation failed: " err.Message, "Error", "IconX")
        }
    }

    /**
    * @method CheckConditions
    * @description Check if conditions are met
    * @param WinTitle Window identifier
    * @param conditions Conditions to check
    * @returns {Boolean} True if all conditions met
    */
    static CheckConditions(WinTitle, conditions) {
        ; Title contains
        if conditions.HasOwnProp("TitleContains") {
            title := WinGetTitle(WinTitle)
            if !InStr(title, conditions.TitleContains) {
                return false
            }
        }

        ; Process name
        if conditions.HasOwnProp("ProcessName") {
            process := WinGetProcessName(WinTitle)
            if process != conditions.ProcessName {
                return false
            }
        }

        ; Window state
        if conditions.HasOwnProp("IsMaximized") {
            ; Check if maximized
            ; This would require additional implementation
        }

        return true
    }

    /**
    * @method ApplyActions
    * @description Apply actions to window
    * @param WinTitle Window identifier
    * @param actions Actions to apply
    */
    static ApplyActions(WinTitle, actions) {
        ; Position
        if actions.HasOwnProp("Position") {
            WinMove(actions.Position.X, actions.Position.Y,
            actions.Position.Width, actions.Position.Height, WinTitle)
        }

        ; Transparency
        if actions.HasOwnProp("Transparency") {
            WinSetTransparent(actions.Transparency, WinTitle)
        }

        ; Always on top
        if actions.HasOwnProp("AlwaysOnTop") {
            WinSetAlwaysOnTop(actions.AlwaysOnTop, WinTitle)
        }

        ; Minimize
        if actions.HasOwnProp("Minimize") && actions.Minimize {
            WinMinimize(WinTitle)
        }

        ; Maximize
        if actions.HasOwnProp("Maximize") && actions.Maximize {
            WinMaximize(WinTitle)
        }
    }

    /**
    * @method CreateExampleRules
    * @description Create example rules
    */
    static CreateExampleRules() {
        ; Rule: Make all dialogs always on top
        this.AddRule("#32770", {}, {AlwaysOnTop: true})

        ; Rule: Position Notepad windows
        this.AddRule("Notepad", {}, {
            Position: {X: 100, Y: 100, Width: 800, Height: 600}
        })

        TrayTip("Example rules created", "Rules Engine", "Icon!")
    }
}

; ========================================
; Example 6: Window Class Validator
; ========================================

/**
* @class ClassValidator
* @description Validate window classes against specifications
*/
class ClassValidator {
    /**
    * @method Validate
    * @description Validate a window class
    * @param className Class to validate
    * @param spec Validation specification
    * @returns {Object} Validation result
    */
    static Validate(className, spec) {
        errors := []
        warnings := []

        ; Length validation
        if spec.HasOwnProp("MinLength") && StrLen(className) < spec.MinLength {
            errors.Push("Class name too short (min: " spec.MinLength ")")
        }

        if spec.HasOwnProp("MaxLength") && StrLen(className) > spec.MaxLength {
            errors.Push("Class name too long (max: " spec.MaxLength ")")
        }

        ; Pattern validation
        if spec.HasOwnProp("MustMatch") && !(className ~= spec.MustMatch) {
            errors.Push("Class doesn't match required pattern")
        }

        ; Forbidden patterns
        if spec.HasOwnProp("MustNotMatch") && (className ~= spec.MustNotMatch) {
            errors.Push("Class matches forbidden pattern")
        }

        ; Character validation
        if spec.HasOwnProp("AllowedChars") {
            Loop Parse className {
                if !InStr(spec.AllowedChars, A_LoopField) {
                    errors.Push("Invalid character: " A_LoopField)
                    break
                }
            }
        }

        ; Warnings for unusual patterns
        if StrLen(className) > 50 {
            warnings.Push("Unusually long class name")
        }

        if InStr(className, " ") {
            warnings.Push("Class contains spaces")
        }

        return {
            ClassName: className,
            Valid: errors.Length = 0,
            Errors: errors,
            Warnings: warnings
        }
    }
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetClass Filtering Examples - Hotkeys:

    Ctrl+Shift+F  - Find by pattern
    Ctrl+Shift+P  - Show window picker
    Ctrl+Shift+T  - Toggle history tracking
    Ctrl+Alt+N    - New tab (mapped action)
    )"

    TrayTip(help, "WinGetClass Filtering Ready", "Icon!")
}
