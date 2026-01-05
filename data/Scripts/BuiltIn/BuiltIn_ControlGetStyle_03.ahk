#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * ControlGetStyle - Real-World Detection and Diagnostic Applications
 * ============================================================================
 * 
 * This script demonstrates practical applications of ControlGetStyle for
 * diagnostics, accessibility checking, and automated UI testing.
 * 
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 * 
 * Practical Applications:
 * - Accessibility auditing
 * - UI testing automation
 * - Control state diagnostics
 * - Form validation
 * - Theme detection
 */

;==============================================================================
; Example 1: Accessibility Checker
;==============================================================================

/**
 * Checks controls for accessibility compliance
 * 
 * @example
 * Audits GUI controls for common accessibility issues
 */
Example1_AccessibilityChecker() {

    MyGui := Gui("+Resize", "Example 1: Accessibility Checker")

    MyGui.Add("Text", "w500", "Accessibility audit of GUI controls:")

    ; Create test controls with various accessibility issues
    controls := []
    controls.Push({
        ctrl: MyGui.Add("Edit", "w300 y+20 -TabStop", "No TabStop"),
        name: "Edit without TabStop"
    })
    controls.Push({
        ctrl: MyGui.Add("Button", "w300 y+10 -TabStop", "Button No TabStop"),
        name: "Button without TabStop"
    })
    controls.Push({
        ctrl: MyGui.Add("Edit", "w300 y+10", "Good Edit"),
        name: "Accessible Edit"
    })
    controls.Push({
        ctrl: MyGui.Add("Edit", "w300 y+10 Password Multi", ""),
        name: "Multiline Password (Bad)"
    })

    ; Disable one control
    disabledEdit := MyGui.Add("Edit", "w300 y+10", "Disabled Visible")
    disabledEdit.Enabled := false
    controls.Push({ ctrl: disabledEdit, name: "Disabled Visible Edit" })

    BtnAudit := MyGui.Add("Button", "w200 y+20", "Run Accessibility Audit")
    BtnAudit.OnEvent("Click", RunAudit)

    ResultsEdit := MyGui.Add("Edit", "w600 h400 y+10 ReadOnly Multi")

    MyGui.Show()

    RunAudit(*) {
        results := "=== ACCESSIBILITY AUDIT REPORT ===`n`n"
        totalIssues := 0
        totalWarnings := 0

        for item in controls {
            audit := AccessibilityAuditor.Audit(item.ctrl)

            results .= item.name . ":`n"
            results .= "  Style: 0x" . Format("{:08X}", audit.style) . "`n"
            results .= "  Status: " . (audit.isAccessible ? "✓ PASS" : "✗ FAIL") . "`n"

            if (audit.issues.Length > 0) {
                results .= "  ISSUES:`n"
                for issue in audit.issues {
                    results .= "    ✗ " . issue . "`n"
                    totalIssues++
                }
            }

            if (audit.warnings.Length > 0) {
                results .= "  WARNINGS:`n"
                for warning in audit.warnings {
                    results .= "    ⚠ " . warning . "`n"
                    totalWarnings++
                }
            }

            results .= "`n"
        }

        results .= "=== AUDIT SUMMARY ===`n"
        results .= "Controls Checked: " . controls.Length . "`n"
        results .= "Total Issues: " . totalIssues . "`n"
        results .= "Total Warnings: " . totalWarnings . "`n"
        results .= "`n"

        if (totalIssues = 0 && totalWarnings = 0)
            results .= "Result: All controls pass accessibility checks ✓`n"
        else if (totalIssues = 0)
            results .= "Result: No critical issues, but warnings present ⚠`n"
        else
            results .= "Result: Critical accessibility issues found ✗`n"

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 2: Form Validation Diagnostic
;==============================================================================

/**
 * Diagnoses form controls for data entry issues
 * 
 * @example
 * Validates form setup for proper data collection
 */
Example2_FormValidationDiagnostic() {

    MyGui := Gui("+Resize", "Example 2: Form Validation Diagnostic")

    MyGui.Add("Text", "w500", "Diagnose form controls for data entry:")

    ; Create a sample form
    MyGui.Add("Text", "xm y+20", "Username:")
    controls := []
    controls.Push({
        ctrl: MyGui.Add("Edit", "x+10 w200"),
        name: "Username"
    })

    MyGui.Add("Text", "xm y+10", "Password:")
    controls.Push({
        ctrl: MyGui.Add("Edit", "x+10 w200 Password"),
        name: "Password"
    })

    MyGui.Add("Text", "xm y+10", "Age:")
    controls.Push({
        ctrl: MyGui.Add("Edit", "x+10 w200 Number"),
        name: "Age"
    })

    MyGui.Add("Text", "xm y+10", "Email:")
    controls.Push({
        ctrl: MyGui.Add("Edit", "x+10 w200"),
        name: "Email"
    })

    MyGui.Add("Text", "xm y+10", "User ID:")
    readOnlyCtrl := MyGui.Add("Edit", "x+10 w200 ReadOnly", "AUTO-GENERATED")
    controls.Push({
        ctrl: readOnlyCtrl,
        name: "UserID (ReadOnly)"
    })

    MyGui.Add("Text", "xm y+10", "Notes:")
    controls.Push({
        ctrl: MyGui.Add("Edit", "x+10 w200 h60 Multi"),
        name: "Notes"
    })

    BtnDiagnose := MyGui.Add("Button", "xm y+20 w200", "Diagnose Form")
    BtnDiagnose.OnEvent("Click", DiagnoseForm)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h300 ReadOnly Multi")

    MyGui.Show()

    DiagnoseForm(*) {
        report := FormDiagnostic.CheckForm(controls)

        results := "=== FORM DIAGNOSTIC REPORT ===`n`n"

        results .= "FORM STATISTICS:`n"
        results .= "  Total Fields: " . controls.Length . "`n"
        results .= "  Editable Fields: " . report.editableCount . "`n"
        results .= "  Read-Only Fields: " . report.readOnlyCount . "`n"
        results .= "  Disabled Fields: " . report.disabledCount . "`n"
        results .= "  Password Fields: " . report.passwordCount . "`n"
        results .= "  Numeric Fields: " . report.numericCount . "`n`n"

        results .= "FIELD DETAILS:`n"
        results .= Format("{:-<70}", "") . "`n"

        for item in report.controls {
            results .= item.name . ":`n"
            results .= "  Style: 0x" . Format("{:08X}", item.style) . "`n"

            if (item.issues.Length > 0) {
                for issue in item.issues {
                    results .= "  [" . issue.severity . "] " . issue.message . "`n"
                }
            } else {
                results .= "  [OK] No issues detected`n"
            }

            results .= "`n"
        }

        results .= "=== DIAGNOSTIC COMPLETE ===`n"

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 3: UI Testing Helper
;==============================================================================

/**
 * Creates a testing utility for automated UI tests
 * 
 * @example
 * Verifies control states match expected configurations
 */
Example3_UITestingHelper() {

    MyGui := Gui("+Resize", "Example 3: UI Testing Helper")

    MyGui.Add("Text", "w500", "Automated UI testing with style verification:")

    ; Create test controls
    EditNormal := MyGui.Add("Edit", "w300 y+20", "Normal Edit")
    EditReadOnly := MyGui.Add("Edit", "w300 y+10 ReadOnly", "Read-Only Edit")
    EditPassword := MyGui.Add("Edit", "w300 y+10 Password", "")
    EditDisabled := MyGui.Add("Edit", "w300 y+10", "Disabled")
    EditDisabled.Enabled := false

    BtnRunTests := MyGui.Add("Button", "w200 y+20", "Run UI Tests")
    BtnRunTests.OnEvent("Click", RunTests)

    ResultsEdit := MyGui.Add("Edit", "w600 h400 y+10 ReadOnly Multi")

    MyGui.Show()

    RunTests(*) {
        results := "=== UI TEST RESULTS ===`n`n"
        passed := 0
        failed := 0

        ; Test 1: Normal edit should be editable
        test1 := UITester.ExpectEditable(EditNormal, "Normal Edit is Editable")
        results .= FormatTestResult(test1, passed, failed)

        ; Test 2: Read-only edit should be read-only
        test2 := UITester.ExpectReadOnly(EditReadOnly, "ReadOnly Edit is ReadOnly")
        results .= FormatTestResult(test2, passed, failed)

        ; Test 3: Password field should have password style
        test3 := UITester.ExpectStyle(EditPassword, [0x0020], "Password Edit has ES_PASSWORD")
        results .= FormatTestResult(test3, passed, failed)

        ; Test 4: Disabled edit should not be editable
        test4 := UITester.ExpectStyle(EditDisabled, [0x08000000], "Disabled Edit has WS_DISABLED")
        results .= FormatTestResult(test4, passed, failed)

        ; Test 5: Normal edit should not be password
        test5 := UITester.ExpectNotStyle(EditNormal, [0x0020], "Normal Edit is not Password")
        results .= FormatTestResult(test5, passed, failed)

        ; Test 6: Password should not be multiline
        test6 := UITester.ExpectNotStyle(EditPassword, [0x0004], "Password is not Multiline")
        results .= FormatTestResult(test6, passed, failed)

        results .= "`n=== TEST SUMMARY ===`n"
        results .= "Total Tests: " . (passed + failed) . "`n"
        results .= "Passed: " . passed . " ✓`n"
        results .= "Failed: " . failed . " ✗`n"
        results .= "Success Rate: " . Round((passed / (passed + failed)) * 100, 1) . "%`n"

        ResultsEdit.Value := results
    }

    FormatTestResult(test, &passed, &failed) {
        result := test.testName . ": "

        if (test.passed) {
            result .= "✓ PASS`n"
            passed++
        } else {
            result .= "✗ FAIL`n"
            failed++

            if (test.HasOwnProp("missing") && test.missing.Length > 0)
                result .= "  Missing flags: " . Join(test.missing, ", ") . "`n"
            if (test.HasOwnProp("found") && test.found.Length > 0)
                result .= "  Forbidden flags present: " . Join(test.found, ", ") . "`n"
            if (test.HasOwnProp("isReadOnly"))
                result .= "  IsReadOnly: " . test.isReadOnly . "`n"
            if (test.HasOwnProp("isDisabled"))
                result .= "  IsDisabled: " . test.isDisabled . "`n"
        }

        result .= "  Style: 0x" . Format("{:08X}", test.style) . "`n`n"
        return result
    }

    Join(arr, delimiter) {
        if (!arr || arr.Length = 0)
            return ""
        result := ""
        for item in arr
            result .= item . delimiter
        return SubStr(result, 1, -StrLen(delimiter))
    }
}

;==============================================================================
; Example 4: Control State Diagnostic Tool
;==============================================================================

/**
 * Comprehensive diagnostic tool for control state analysis
 * 
 * @example
 * Complete diagnostic report for any control
 */
Example4_StateDiagnostic() {

    MyGui := Gui("+Resize", "Example 4: State Diagnostic Tool")

    MyGui.Add("Text", "w500", "Comprehensive control state diagnostics:")

    ; Create test controls
    controls := []
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 y+20"), name: "Normal Edit" })
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 y+10 ReadOnly"), name: "ReadOnly Edit" })
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 y+10 Password"), name: "Password Edit" })
    controls.Push({ ctrl: MyGui.Add("Edit", "w300 h60 y+10 Multi"), name: "Multiline Edit" })

    ControlSelect := MyGui.Add("DropDownList", "w300 y+20", ["Normal Edit", "ReadOnly Edit", "Password Edit", "Multiline Edit"])
    ControlSelect.Choose(1)

    BtnDiagnose := MyGui.Add("Button", "w200 y+10", "Run Diagnostic")
    BtnDiagnose.OnEvent("Click", RunDiagnostic)

    ResultsEdit := MyGui.Add("Edit", "w600 h400 y+10 ReadOnly Multi")

    MyGui.Show()

    RunDiagnostic(*) {
        selectedIndex := ControlSelect.Value
        if (selectedIndex = 0 || selectedIndex > controls.Length) {
            MsgBox("Please select a control", "Error", "IconX")
            return
        }

        ctrl := controls[selectedIndex].ctrl
        ctrlName := controls[selectedIndex].name

        report := StateDiagnostic.GenerateReport(ctrl)

        results := "=== STATE DIAGNOSTIC REPORT ===`n`n"
        results .= "Control: " . ctrlName . "`n"
        results .= "ClassNN: " . report.className . "`n`n"

        results .= "STYLE INFORMATION:`n"
        results .= "  Style: 0x" . Format("{:08X}", report.style) . "`n"
        results .= "  ExStyle: 0x" . Format("{:08X}", report.exStyle) . "`n`n"

        results .= "ACTIVE FLAGS:`n"
        if (report.flags.Length > 0) {
            for flag in report.flags
                results .= "  ✓ " . flag . "`n"
        } else {
            results .= "  (None)`n"
        }
        results .= "`n"

        results .= "CAPABILITIES:`n"
        if (report.capabilities.Length > 0) {
            for cap in report.capabilities
                results .= "  • " . cap . "`n"
        } else {
            results .= "  (None detected)`n"
        }
        results .= "`n"

        results .= "RESTRICTIONS:`n"
        if (report.restrictions.Length > 0) {
            for rest in report.restrictions
                results .= "  ⚠ " . rest . "`n"
        } else {
            results .= "  (None detected)`n"
        }
        results .= "`n"

        results .= "RECOMMENDATIONS:`n"
        if (report.recommendations.Length > 0) {
            for rec in report.recommendations
                results .= "  💡 " . rec . "`n"
        } else {
            results .= "  No recommendations`n"
        }

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 5: Theme and Visual Style Detector
;==============================================================================

/**
 * Detects visual styling patterns from control styles
 * 
 * @example
 * Identifies common UI themes and visual patterns
 */
Example5_ThemeDetector() {

    MyGui := Gui("+Resize", "Example 5: Theme Detector")

    MyGui.Add("Text", "w500", "Detect UI theme from control styles:")

    ; Create a themed form
    controls := []
    MyGui.Add("Text", "xm y+20", "Name:")
    controls.Push({ ctrl: MyGui.Add("Edit", "x+10 w200") })

    MyGui.Add("Text", "xm y+10", "Email:")
    controls.Push({ ctrl: MyGui.Add("Edit", "x+10 w200") })

    MyGui.Add("Text", "xm y+10", "Password:")
    controls.Push({ ctrl: MyGui.Add("Edit", "x+10 w200 Password") })

    MyGui.Add("Text", "xm y+10", "Bio:")
    controls.Push({ ctrl: MyGui.Add("Edit", "x+10 w200 h60 Multi") })

    MyGui.Add("Text", "xm y+10", "User ID:")
    controls.Push({ ctrl: MyGui.Add("Edit", "x+10 w200 ReadOnly", "12345") })

    BtnDetect := MyGui.Add("Button", "xm y+20 w200", "Detect Theme")
    BtnDetect.OnEvent("Click", DetectTheme)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    MyGui.Show()

    DetectTheme(*) {
        theme := ThemeDetector.DetectTheme(controls)

        results := "=== THEME DETECTION REPORT ===`n`n"
        results .= "Detected Theme: " . theme.name . "`n`n"

        results .= "THEME CHARACTERISTICS:`n"
        if (theme.characteristics.Length > 0) {
            for char in theme.characteristics
                results .= "  • " . char . "`n"
        }
        results .= "`n"

        results .= "STYLE METRICS:`n"
        results .= "  Border Usage: " . theme.borderPercent . "%`n"
        results .= "  Total Controls: " . controls.Length . "`n"

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 6: Performance Diagnostic
;==============================================================================

/**
 * Benchmarks ControlGetStyle performance
 * 
 * @example
 * Tests performance characteristics of style reading operations
 */
Example6_PerformanceDiagnostic() {
    MyGui := Gui("+Resize", "Example 6: Performance Diagnostic")

    MyGui.Add("Text", "w500", "Benchmark ControlGetStyle performance:")

    ; Create many controls for testing
    controls := []
    loop 50 {
        ctrl := MyGui.Add("Edit", "xm y" . (A_Index = 1 ? "+20" : "+5") . " w200 h0", "Edit" . A_Index)
        controls.Push(ctrl)
    }

    BtnBenchmark := MyGui.Add("Button", "xm y+20 w200", "Run Benchmark")
    BtnBenchmark.OnEvent("Click", RunBenchmark)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h400 ReadOnly Multi")

    MyGui.Show()

    RunBenchmark(*) {
        results := "=== PERFORMANCE BENCHMARK ===`n`n"

        ; Test 1: Single read
        startTime := A_TickCount
        style := ControlGetStyle(controls[1])
        endTime := A_TickCount
        results .= "Single Read: " . (endTime - startTime) . " ms`n"

        ; Test 2: 100 sequential reads
        startTime := A_TickCount
        loop 100 {
            style := ControlGetStyle(controls[1])
        }
        endTime := A_TickCount
        avgTime := (endTime - startTime) / 100
        results .= "100 Sequential Reads: " . (endTime - startTime) . " ms`n"
        results .= "  Average: " . Round(avgTime, 3) . " ms per read`n`n"

        ; Test 3: Read all 50 controls
        startTime := A_TickCount
        for ctrl in controls {
            style := ControlGetStyle(ctrl)
        }
        endTime := A_TickCount
        results .= "50 Different Controls: " . (endTime - startTime) . " ms`n"
        results .= "  Average: " . Round((endTime - startTime) / 50, 3) . " ms per control`n`n"

        ; Test 4: Cache effectiveness (read same control twice)
        startTime := A_TickCount
        loop 1000 {
            style := ControlGetStyle(controls[1])
        }
        time1000 := A_TickCount - startTime
        results .= "1000 Reads (Same Control): " . time1000 . " ms`n"
        results .= "  Average: " . Round(time1000 / 1000, 3) . " ms per read`n`n"

        results .= "=== ANALYSIS ===`n"
        results .= "Operations per second: " . Round(1000 / avgTime, 0) . "`n"

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 7: External Window Analyzer
;==============================================================================

/**
 * Analyzes controls in external windows
 * 
 * @example
 * Real-world application testing tool
 */
Example7_ExternalAnalyzer() {
    MyGui := Gui("+AlwaysOnTop +Resize", "Example 7: External Window Analyzer")

    MyGui.Add("Text", "w500", "Analyze controls in external windows:")

    MyGui.Add("Text", "xm y+20", "Window Title:")
    WinTitle := MyGui.Add("Edit", "x+10 w300")

    MyGui.Add("Text", "xm y+10", "Control ClassNN:")
    CtrlClass := MyGui.Add("Edit", "x+10 w300")

    BtnGetWindow := MyGui.Add("Button", "xm y+10 w200", "Get Active Window")
    BtnGetWindow.OnEvent("Click", GetActiveWin)

    BtnAnalyze := MyGui.Add("Button", "x+10 w200", "Analyze Control")
    BtnAnalyze.OnEvent("Click", AnalyzeExternal)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h400 ReadOnly Multi")

    MyGui.Show()

    GetActiveWin(*) {
        ToolTip("Activate target window...`n3 seconds")
        Sleep(3000)
        ToolTip()

        try {
            title := WinGetTitle("A")
            WinTitle.Value := title

            ; Try to get focused control
            try {
                ctrl := ControlGetClassNN(ControlGetFocus("A"), "A")
                CtrlClass.Value := ctrl
            }
        }
    }

    AnalyzeExternal(*) {
        if (WinTitle.Value = "" || CtrlClass.Value = "") {
            MsgBox("Please enter window title and control ClassNN", "Error", "IconX")
            return
        }

        try {
            style := ControlGetStyle(CtrlClass.Value, WinTitle.Value)
            exStyle := ControlGetExStyle(CtrlClass.Value, WinTitle.Value)

            results := "=== EXTERNAL CONTROL ANALYSIS ===`n`n"
            results .= "Window: " . WinTitle.Value . "`n"
            results .= "Control: " . CtrlClass.Value . "`n`n"

            results .= "STYLE: 0x" . Format("{:08X}", style) . "`n"
            results .= "EXSTYLE: 0x" . Format("{:08X}", exStyle) . "`n`n"

            results .= "FLAGS:`n"
            results .= "  Visible: " . (style & 0x10000000 ? "Yes" : "No") . "`n"
            results .= "  Disabled: " . (style & 0x08000000 ? "Yes" : "No") . "`n"
            results .= "  TabStop: " . (style & 0x00010000 ? "Yes" : "No") . "`n"
            results .= "  Border: " . (style & 0x00800000 ? "Yes" : "No") . "`n`n"

            ; Edit-specific
            if (InStr(CtrlClass.Value, "Edit")) {
                results .= "EDIT CONTROL FLAGS:`n"
                results .= "  ReadOnly: " . (style & 0x0800 ? "Yes" : "No") . "`n"
                results .= "  Password: " . (style & 0x0020 ? "Yes" : "No") . "`n"
                results .= "  Multiline: " . (style & 0x0004 ? "Yes" : "No") . "`n"
                results .= "  Number: " . (style & 0x2000 ? "Yes" : "No") . "`n"
            }

            ResultsEdit.Value := results

        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }
}

;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "ControlGetStyle Practical Examples")
MainGui.Add("Text", "w400", "Select an example to run:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Accessibility Checker",
    "Example 2: Form Validation Diagnostic",
    "Example 3: UI Testing Helper",
    "Example 4: State Diagnostic Tool",
    "Example 5: Theme Detector",
    "Example 6: Performance Diagnostic",
    "Example 7: External Window Analyzer"
])

btnRun := MainGui.Add("Button", "w200 y+20", "Run Example")
btnRun.OnEvent("Click", RunSelected)

btnExit := MainGui.Add("Button", "x+10 w200", "Exit")
btnExit.OnEvent("Click", (*) => ExitApp())

MainGui.Show()

RunSelected(*) {
    selected := examplesList.Value
    if (selected = 0) {
        MsgBox("Please select an example first", "Info", "Iconi")
        return
    }

    switch selected {
        case 1: Example1_AccessibilityChecker()
        case 2: Example2_FormValidationDiagnostic()
        case 3: Example3_UITestingHelper()
        case 4: Example4_StateDiagnostic()
        case 5: Example5_ThemeDetector()
        case 6: Example6_PerformanceDiagnostic()
        case 7: Example7_ExternalAnalyzer()
    }
}

return

; Moved class AccessibilityAuditor from nested scope
class AccessibilityAuditor {
    static Audit(ctrl) {
        issues := []
        warnings := []
        style := ControlGetStyle(ctrl)
        className := ctrl.ClassNN

        ; Check if control is visible but disabled without indication
        if ((style & 0x10000000) && (style & 0x08000000)) {
            warnings.Push("Control is visible but disabled - ensure visual indication")
        }

        ; Check if interactive control lacks tab stop
        if (!(style & 0x08000000) && !(style & 0x00010000)) {
            if (InStr(className, "Edit") || InStr(className, "Button")) {
                issues.Push("Interactive control lacks WS_TABSTOP - not keyboard accessible")
            }
        }

        ; Check for password fields that might be multiline
        if (InStr(className, "Edit") && (style & 0x0020) && (style & 0x0004)) {
            issues.Push("Password field is multiline - security concern")
        }

        ; Check for edit controls without autoscroll
        if (InStr(className, "Edit")) {
            if (!(style & 0x0004) && !(style & 0x0080)) {  ; Single-line without autohscroll
                warnings.Push("Single-line edit lacks ES_AUTOHSCROLL")
            }
            if ((style & 0x0004) && !(style & 0x0040)) {  ; Multiline without autovscroll
                warnings.Push("Multiline edit lacks ES_AUTOVSCROLL")
            }
        }

        return {
            issues: issues,
            warnings: warnings,
            style: style,
            isAccessible: issues.Length = 0
        }
    }
}

; Moved class FormDiagnostic from nested scope
class FormDiagnostic {
    static CheckEditControl(ctrl) {
        issues := []
        style := ControlGetStyle(ctrl)

        ; Check if editable fields are actually editable
        if (style & 0x0800) {  ; ES_READONLY
            issues.Push({
                severity: "INFO",
                message: "Field is read-only"
            })
        }

        if (style & 0x08000000) {  ; WS_DISABLED
            issues.Push({
                severity: "WARNING",
                message: "Field is disabled - cannot collect input"
            })
        }

        ; Check for password fields
        if (style & 0x0020) {  ; ES_PASSWORD
            if (!(style & 0x0080)) {  ; No ES_AUTOHSCROLL
                issues.Push({
                    severity: "WARNING",
                    message: "Password field without auto-scroll"
                })
            }
        }

        ; Check numeric fields
        if (style & 0x2000) {  ; ES_NUMBER
            issues.Push({
                severity: "INFO",
                message: "Numeric input only"
            })
        }

        return issues
    }

    static CheckForm(controls) {
        report := {
            controls: [],
            editableCount: 0,
            readOnlyCount: 0,
            disabledCount: 0,
            passwordCount: 0,
            numericCount: 0
        }

        for item in controls {
            issues := this.CheckEditControl(item.ctrl)
            style := ControlGetStyle(item.ctrl)

            ; Count control types
            if (!(style & 0x0800) && !(style & 0x08000000))
                report.editableCount++
            if (style & 0x0800)
                report.readOnlyCount++
            if (style & 0x08000000)
                report.disabledCount++
            if (style & 0x0020)
                report.passwordCount++
            if (style & 0x2000)
                report.numericCount++

            report.controls.Push({
                name: item.name,
                style: style,
                issues: issues
            })
        }

        return report
    }
}

; Moved class UITester from nested scope
class UITester {
    static ExpectStyle(ctrl, expectedFlags, testName := "") {
        style := ControlGetStyle(ctrl)
        allPresent := true
        missing := []

        for flag in expectedFlags {
            if (!(style & flag)) {
                allPresent := false
                missing.Push("0x" . Format("{:X}", flag))
            }
        }

        return {
            passed: allPresent,
            testName: testName,
            style: style,
            missing: missing
        }
    }

    static ExpectNotStyle(ctrl, forbiddenFlags, testName := "") {
        style := ControlGetStyle(ctrl)
        nonePresent := true
        found := []

        for flag in forbiddenFlags {
            if (style & flag) {
                nonePresent := false
                found.Push("0x" . Format("{:X}", flag))
            }
        }

        return {
            passed: nonePresent,
            testName: testName,
            style: style,
            found: found
        }
    }

    static ExpectEditable(ctrl, testName := "") {
        style := ControlGetStyle(ctrl)
        ES_READONLY := 0x0800
        WS_DISABLED := 0x08000000

        isEditable := !(style & ES_READONLY) && !(style & WS_DISABLED)

        return {
            passed: isEditable,
            testName: testName,
            style: style,
            isReadOnly: !!(style & ES_READONLY),
            isDisabled: !!(style & WS_DISABLED)
        }
    }

    static ExpectReadOnly(ctrl, testName := "") {
        style := ControlGetStyle(ctrl)
        ES_READONLY := 0x0800

        return {
            passed: !!(style & ES_READONLY),
            testName: testName,
            style: style
        }
    }
}

; Moved class StateDiagnostic from nested scope
class StateDiagnostic {
    static GenerateReport(ctrl) {
        style := ControlGetStyle(ctrl)
        exStyle := ControlGetExStyle(ctrl)
        className := ctrl.ClassNN

        report := {
            className: className,
            style: style,
            exStyle: exStyle,
            flags: [],
            capabilities: [],
            restrictions: [],
            recommendations: []
        }

        ; Analyze flags
        this.AnalyzeFlags(style, report)

        ; Analyze capabilities
        this.AnalyzeCapabilities(style, className, report)

        ; Analyze restrictions
        this.AnalyzeRestrictions(style, report)

        ; Generate recommendations
        this.GenerateRecommendations(style, className, report)

        return report
    }

    static AnalyzeFlags(style, &report) {
        flags := Map(
            "WS_VISIBLE", 0x10000000,
            "WS_DISABLED", 0x08000000,
            "WS_TABSTOP", 0x00010000,
            "WS_GROUP", 0x00020000,
            "WS_BORDER", 0x00800000,
            "ES_READONLY", 0x0800,
            "ES_PASSWORD", 0x0020,
            "ES_MULTILINE", 0x0004,
            "ES_NUMBER", 0x2000
        )

        for name, value in flags {
            if (style & value)
                report.flags.Push(name)
        }
    }

    static AnalyzeCapabilities(style, className, &report) {
        if (!(style & 0x08000000))
            report.capabilities.Push("Can receive user input")

        if (style & 0x00010000)
            report.capabilities.Push("Can receive keyboard focus via Tab")

        if (InStr(className, "Edit")) {
            if (!(style & 0x0800))
                report.capabilities.Push("User can edit text")

            if (style & 0x0004)
                report.capabilities.Push("Supports multiple lines")

            if (style & 0x2000)
                report.capabilities.Push("Accepts only numeric input")
        }
    }

    static AnalyzeRestrictions(style, &report) {
        if (style & 0x08000000)
            report.restrictions.Push("Control is disabled")

        if (style & 0x0800)
            report.restrictions.Push("Text cannot be edited")

        if (!(style & 0x00010000))
            report.restrictions.Push("Cannot receive focus via Tab key")

        if (style & 0x0020)
            report.restrictions.Push("Text is masked (password)")
    }

    static GenerateRecommendations(style, className, &report) {
        if (InStr(className, "Edit")) {
            if ((style & 0x0004) && !(style & 0x0040))
                report.recommendations.Push("Add ES_AUTOVSCROLL for better multiline editing")

            if (!(style & 0x0004) && !(style & 0x0080))
                report.recommendations.Push("Add ES_AUTOHSCROLL for single-line editing")

            if ((style & 0x10000000) && (style & 0x08000000))
                report.recommendations.Push("Consider hiding disabled controls")
        }

        if ((style & 0x08000000) && (style & 0x00010000))
            report.recommendations.Push("Remove WS_TABSTOP from disabled control")
    }
}

; Moved class ThemeDetector from nested scope
class ThemeDetector {
    static DetectTheme(controls) {
        hasReadOnly := false
        hasPasswords := false
        hasMultiline := false
        hasBorders := 0
        totalControls := controls.Length

        for item in controls {
            style := ControlGetStyle(item.ctrl)

            if (style & 0x0800)  ; ES_READONLY
                hasReadOnly := true
            if (style & 0x0020)  ; ES_PASSWORD
                hasPasswords := true
            if (style & 0x0004)  ; ES_MULTILINE
                hasMultiline := true
            if (style & 0x00800000)  ; WS_BORDER
                hasBorders++
        }

        theme := {
            name: "Unknown",
            characteristics: [],
            borderPercent: Round((hasBorders / totalControls) * 100, 1)
        }

        ; Detect theme type
        if (hasReadOnly && !hasPasswords && hasBorders / totalControls > 0.5)
            theme.name := "Information Display"
        else if (hasPasswords && hasMultiline)
            theme.name := "Comprehensive Form"
        else if (hasPasswords)
            theme.name := "Secure Input Form"
        else if (hasMultiline && hasBorders / totalControls > 0.7)
            theme.name := "Document Editor"
        else
            theme.name := "Standard Form"

        ; Add characteristics
        if (hasReadOnly)
            theme.characteristics.Push("Contains read-only fields")
        if (hasPasswords)
            theme.characteristics.Push("Includes secure input")
        if (hasMultiline)
            theme.characteristics.Push("Supports long-form text")
        if (theme.borderPercent > 80)
            theme.characteristics.Push("Heavily bordered (classic style)")
        else if (theme.borderPercent < 20)
            theme.characteristics.Push("Minimal borders (modern style)")

        return theme
    }
}
