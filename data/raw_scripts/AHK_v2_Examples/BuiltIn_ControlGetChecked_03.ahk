#Requires AutoHotkey v2.0

/**
 * ControlGetChecked - Real-World Applications
 * 
 * Comprehensive examples for AutoHotkey v2.0
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 */


;==============================================================================
; Example 1: Form Preferences
;==============================================================================

Example1() {
    MyGui := Gui("+Resize", "Example 1: Form Preferences")
    MyGui.Add("Text", "w500", "Track user preferences:")
    
    prefs := Map()
    prefs["Notifications"] := MyGui.Add("Checkbox", "xm y+20", "Enable notifications")
    prefs["AutoSave"] := MyGui.Add("Checkbox", "xm y+10", "Auto-save")
    prefs["DarkMode"] := MyGui.Add("Checkbox", "xm y+10", "Dark mode")
    prefs["Analytics"] := MyGui.Add("Checkbox", "xm y+10", "Send analytics")
    BtnSave := MyGui.Add("Button", "xm y+20 w200", "Save Preferences")
    BtnSave.OnEvent("Click", SavePrefs)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    SavePrefs(*) {
        result := "=== SAVED PREFERENCES ===\n\n"
        for name, ctrl in prefs {
            state := ControlGetChecked(ctrl)
            result .= name . ": " . (state ? "Enabled" : "Disabled") . "\n"
        }
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 2: Feature Selection
;==============================================================================

Example2() {
    MyGui := Gui("+Resize", "Example 2: Feature Selection")
    MyGui.Add("Text", "w500", "Feature toggle system:")
    
    features := Map()
    features["Basic"] := MyGui.Add("Checkbox", "xm y+20 Checked", "Basic (required)")
    features["Basic"].Enabled := false
    features["Advanced"] := MyGui.Add("Checkbox", "xm y+10", "Advanced features")
    features["Experimental"] := MyGui.Add("Checkbox", "xm y+10", "Experimental")
    features["Debug"] := MyGui.Add("Checkbox", "xm y+10", "Debug mode")
    BtnApply := MyGui.Add("Button", "xm y+20 w200", "Apply Selection")
    BtnApply.OnEvent("Click", ApplyFeatures)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    ApplyFeatures(*) {
        result := "=== ACTIVE FEATURES ===\n\n"
        activeCount := 0
        for name, ctrl in features {
            if (ControlGetChecked(ctrl)) {
                result .= "✓ " . name . "\n"
                activeCount++
            }
        }
        result .= "\nTotal: " . activeCount . " features enabled\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 3: Survey Response
;==============================================================================

Example3() {
    MyGui := Gui("+Resize", "Example 3: Survey Response")
    MyGui.Add("Text", "w500", "Collect survey responses:")
    
    questions := Map()
    questions["Q1"] := MyGui.Add("Checkbox", "xm y+20", "Satisfied with service?")
    questions["Q2"] := MyGui.Add("Checkbox", "xm y+10", "Recommend to others?")
    questions["Q3"] := MyGui.Add("Checkbox", "xm y+10", "Use again?")
    questions["Q4"] := MyGui.Add("Checkbox", "xm y+10", "Good value?")
    BtnSubmit := MyGui.Add("Button", "xm y+20 w200", "Submit Survey")
    BtnSubmit.OnEvent("Click", SubmitSurvey)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    SubmitSurvey(*) {
        result := "=== SURVEY RESULTS ===\n\n"
        yesCount := 0
        for question, ctrl in questions {
            answer := ControlGetChecked(ctrl) ? "Yes" : "No"
            result .= question . ": " . answer . "\n"
            if (ControlGetChecked(ctrl))
                yesCount++
        }
        score := Round((yesCount / questions.Count) * 100)
        result .= "\nSatisfaction Score: " . score . "%\n"
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 4: Permission System
;==============================================================================

Example4() {
    MyGui := Gui("+Resize", "Example 4: Permission System")
    MyGui.Add("Text", "w500", "Check user permissions:")
    
    perms := Map()
    perms["Read"] := MyGui.Add("Checkbox", "xm y+20 Checked", "Read")
    perms["Write"] := MyGui.Add("Checkbox", "xm y+10", "Write")
    perms["Delete"] := MyGui.Add("Checkbox", "xm y+10", "Delete")
    perms["Admin"] := MyGui.Add("Checkbox", "xm y+10", "Admin")
    BtnCheck := MyGui.Add("Button", "xm y+20 w200", "Check Permissions")
    BtnCheck.OnEvent("Click", CheckPerms)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    CheckPerms(*) {
        result := "=== USER PERMISSIONS ===\n\n"
        grantedPerms := []
        for perm, ctrl in perms {
            if (ControlGetChecked(ctrl))
                grantedPerms.Push(perm)
        }
        if (grantedPerms.Length > 0) {
            result .= "Granted:\n"
            for perm in grantedPerms
                result .= "  ✓ " . perm . "\n"
        } else {
            result .= "No permissions granted\n"
        }
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 5: Filter Selection
;==============================================================================

Example5() {
    MyGui := Gui("+Resize", "Example 5: Filter Selection")
    MyGui.Add("Text", "w500", "Apply data filters:")
    
    filters := Map()
    filters["Active"] := MyGui.Add("Checkbox", "xm y+20 Checked", "Active items")
    filters["Archived"] := MyGui.Add("Checkbox", "xm y+10", "Archived items")
    filters["Draft"] := MyGui.Add("Checkbox", "xm y+10", "Draft items")
    filters["Deleted"] := MyGui.Add("Checkbox", "xm y+10", "Deleted items")
    BtnApply := MyGui.Add("Button", "xm y+20 w200", "Apply Filters")
    BtnApply.OnEvent("Click", ApplyFilters)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    ApplyFilters(*) {
        result := "=== ACTIVE FILTERS ===\n\n"
        activeFilters := []
        for filter, ctrl in filters {
            if (ControlGetChecked(ctrl))
                activeFilters.Push(filter)
        }
        if (activeFilters.Length > 0) {
            result .= "Showing:\n"
            for filter in activeFilters
                result .= "  • " . filter . "\n"
        } else {
            result .= "No filters active - showing nothing\n"
        }
        ResultsEdit.Value := result
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 6: Terms Agreement
;==============================================================================

Example6() {
    MyGui := Gui("+Resize", "Example 6: Terms Agreement")
    MyGui.Add("Text", "w500", "Validate agreements:")
    
    agreements := Map()
    agreements["Terms"] := MyGui.Add("Checkbox", "xm y+20", "I agree to Terms of Service")
    agreements["Privacy"] := MyGui.Add("Checkbox", "xm y+10", "I agree to Privacy Policy")
    agreements["Marketing"] := MyGui.Add("Checkbox", "xm y+10", "I agree to receive marketing emails")
    BtnContinue := MyGui.Add("Button", "xm y+20 w200", "Continue")
    BtnContinue.OnEvent("Click", ValidateAgreements)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    ValidateAgreements(*) {
        termsOk := ControlGetChecked(agreements["Terms"])
        privacyOk := ControlGetChecked(agreements["Privacy"])
        if (termsOk && privacyOk) {
            marketing := ControlGetChecked(agreements["Marketing"])
            result := "✓ Registration complete!\n"
            result .= "Marketing emails: " . (marketing ? "Enabled" : "Disabled") . "\n"
            ResultsEdit.Value := result
        } else {
            result := "✗ Please agree to required terms:\n"
            if (!termsOk)
                result .= "  • Terms of Service\n"
            if (!privacyOk)
                result .= "  • Privacy Policy\n"
            ResultsEdit.Value := result
        }
    }
    
    MyGui.Show()
}

;==============================================================================
; Example 7: Settings Export
;==============================================================================

Example7() {
    MyGui := Gui("+Resize", "Example 7: Settings Export")
    MyGui.Add("Text", "w500", "Export checked settings:")
    
    settings := Map()
    settings["AutoBackup"] := MyGui.Add("Checkbox", "xm y+20", "Auto backup")
    settings["Compression"] := MyGui.Add("Checkbox", "xm y+10", "Compression")
    settings["Encryption"] := MyGui.Add("Checkbox", "xm y+10", "Encryption")
    settings["Versioning"] := MyGui.Add("Checkbox", "xm y+10", "Version control")
    BtnExport := MyGui.Add("Button", "xm y+20 w200", "Export Settings")
    BtnExport.OnEvent("Click", ExportSettings)
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")
    ExportSettings(*) {
        config := "# Settings Export\n"
        config .= "# Generated: " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "\n\n"
        for name, ctrl in settings {
            state := ControlGetChecked(ctrl)
            config .= name . "=" . (state ? "true" : "false") . "\n"
        }
        ResultsEdit.Value := config
    }
    
    MyGui.Show()
}


;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "Examples Menu")
MainGui.Add("Text", "w400", "Select an example:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Form Preferences",
    "Example 2: Feature Selection",
    "Example 3: Survey Response",
    "Example 4: Permission System",
    "Example 5: Filter Selection",
    "Example 6: Terms Agreement",
    "Example 7: Settings Export",
])

btnRun := MainGui.Add("Button", "w200 y+20", "Run Example")
btnRun.OnEvent("Click", RunSelected)
btnExit := MainGui.Add("Button", "x+10 w200", "Exit")
btnExit.OnEvent("Click", (*) => ExitApp())

MainGui.Show()

RunSelected(*) {
    selected := examplesList.Value
    if (selected = 0) {
        MsgBox("Please select an example", "Info", "Iconi")
        return
    }
    switch selected {
        case 1: Example1()
        case 2: Example2()
        case 3: Example3()
        case 4: Example4()
        case 5: Example5()
        case 6: Example6()
        case 7: Example7()
    }
}

return
