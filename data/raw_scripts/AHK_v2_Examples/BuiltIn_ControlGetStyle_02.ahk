#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * ControlGetStyle - Advanced Style Analysis and Pattern Detection
 * ============================================================================
 *
 * This script demonstrates advanced techniques for analyzing control styles,
 * detecting patterns, and identifying control behaviors based on style flags.
 *
 * @author AutoHotkey Community
 * @date 2025-01-16
 * @version 1.0.0
 *
 * Advanced Topics Covered:
 * - Style pattern detection
 * - Control type identification
 * - Style inheritance analysis
 * - Custom style validators
 * - Style-based control classification
 */

;==============================================================================
; Example 1: Control Type Detection from Styles
;==============================================================================

/**
 * Detects control types and subtypes from their style values
 *
 * @example
 * Identifies specific control types using style analysis
 */
Example1_ControlTypeDetection() {
    MyGui := Gui("+Resize", "Example 1: Control Type Detection")

    MyGui.Add("Text", "w500", "This example identifies control types from their styles:")

    ; Create various controls
    controls := []
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+20"), desc: "Normal Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+10 Password"), desc: "Password Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+10 Number"), desc: "Number Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 h100 y+10 Multi"), desc: "Multiline Edit"})
    controls.Push({ctrl: MyGui.Add("Button", "w200 y+10"), desc: "Push Button"})
    controls.Push({ctrl: MyGui.Add("Button", "w200 y+10 Default"), desc: "Default Button"})
    controls.Push({ctrl: MyGui.Add("Checkbox", "w200 y+10", "Check"), desc: "Checkbox"})
    controls.Push({ctrl: MyGui.Add("Radio", "w200 y+10", "Radio"), desc: "Radio Button"})

    BtnDetect := MyGui.Add("Button", "w200 y+20", "Detect Control Types")
    BtnDetect.OnEvent("Click", DetectTypes)

    ResultsEdit := MyGui.Add("Edit", "w600 h400 y+10 ReadOnly Multi")

    MyGui.Show()

    DetectTypes(*) {
        results := "=== CONTROL TYPE DETECTION ===`n`n"

        for index, item in controls {
            try {
                style := ControlGetStyle(item.ctrl)
                ctrlClass := item.ctrl.ClassNN

                results .= item.desc . " (ClassNN: " . ctrlClass . "):`n"
                results .= "  Style: 0x" . Format("{:08X}", style) . "`n"

                ; Detect Edit control types
                if (InStr(ctrlClass, "Edit")) {
                    editType := DetectEditType(style)
                    results .= "  Edit Type: " . editType . "`n"

                    ; Check edit-specific flags
                    ES_PASSWORD := 0x0020
                    ES_MULTILINE := 0x0004
                    ES_NUMBER := 0x2000
                    ES_READONLY := 0x0800
                    ES_UPPERCASE := 0x0008
                    ES_LOWERCASE := 0x0010

                    flags := []
                    if (style & ES_PASSWORD)
                        flags.Push("Password")
                    if (style & ES_MULTILINE)
                        flags.Push("Multiline")
                    if (style & ES_NUMBER)
                        flags.Push("Number Only")
                    if (style & ES_READONLY)
                        flags.Push("Read-Only")
                    if (style & ES_UPPERCASE)
                        flags.Push("Uppercase")
                    if (style & ES_LOWERCASE)
                        flags.Push("Lowercase")

                    if (flags.Length > 0)
                        results .= "  Features: " . ArrayJoin(flags, ", ") . "`n"
                }

                ; Detect Button control types
                if (InStr(ctrlClass, "Button")) {
                    buttonType := DetectButtonType(style)
                    results .= "  Button Type: " . buttonType . "`n"
                }

                results .= "`n"

            } catch as err {
                results .= "  Error: " . err.Message . "`n`n"
            }
        }

        ResultsEdit.Value := results
    }

    DetectEditType(style) {
        ES_PASSWORD := 0x0020
        ES_MULTILINE := 0x0004
        ES_NUMBER := 0x2000

        types := []
        if (style & ES_PASSWORD)
            return "Password Field"
        if (style & ES_NUMBER)
            return "Numeric Input"
        if (style & ES_MULTILINE)
            return "Multiline Text Area"
        return "Single-Line Text"
    }

    DetectButtonType(style) {
        buttonStyle := style & 0xF

        switch buttonStyle {
            case 0: return "Push Button (BS_PUSHBUTTON)"
            case 1: return "Default Push Button (BS_DEFPUSHBUTTON)"
            case 2: return "Checkbox (BS_CHECKBOX)"
            case 3: return "Auto Checkbox (BS_AUTOCHECKBOX)"
            case 4: return "Radio Button (BS_RADIOBUTTON)"
            case 5: return "3-State Checkbox (BS_3STATE)"
            case 6: return "Auto 3-State (BS_AUTO3STATE)"
            case 7: return "Group Box (BS_GROUPBOX)"
            case 8: return "Auto Radio Button (BS_AUTORADIOBUTTON)"
            default: return "Unknown (" . buttonStyle . ")"
        }
    }

    ArrayJoin(arr, delimiter) {
        result := ""
        for item in arr
            result .= item . delimiter
        return SubStr(result, 1, -(StrLen(delimiter)))
    }
}

;==============================================================================
; Example 2: Style Pattern Matching
;==============================================================================

/**
 * Demonstrates pattern matching for common style combinations
 *
 * @example
 * Identifies common UI patterns from style combinations
 */
Example2_StylePatternMatching() {
    ; Define common style patterns
    class StylePatterns {
        static READONLY_DISPLAY := 0x50800800  ; Common for display-only fields
        static STANDARD_INPUT := 0x50010080    ; Typical input field
        static MULTILINE_EDITOR := 0x50210044  ; Text editor configuration

        static Patterns := Map(
            "Read-Only Display", {
                required: [0x0800],  ; ES_READONLY
                description: "Display-only text field"
            },
            "Password Input", {
                required: [0x0020],  ; ES_PASSWORD
                forbidden: [0x0004], ; Not multiline
                description: "Secure password entry"
            },
            "Text Editor", {
                required: [0x0004, 0x0040],  ; ES_MULTILINE, ES_AUTOVSCROLL
                description: "Multiline text editor"
            },
            "Numeric Input", {
                required: [0x2000],  ; ES_NUMBER
                description: "Number-only input field"
            },
            "Form Input", {
                required: [0x0080],  ; ES_AUTOHSCROLL
                forbidden: [0x0800], ; Not readonly
                description: "Standard form input field"
            }
        )

        static MatchPattern(style) {
            matches := []

            for patternName, pattern in this.Patterns {
                isMatch := true

                ; Check required flags
                if (pattern.HasOwnProp("required")) {
                    for flag in pattern.required {
                        if (!(style & flag)) {
                            isMatch := false
                            break
                        }
                    }
                }

                ; Check forbidden flags
                if (isMatch && pattern.HasOwnProp("forbidden")) {
                    for flag in pattern.forbidden {
                        if (style & flag) {
                            isMatch := false
                            break
                        }
                    }
                }

                if (isMatch)
                    matches.Push({name: patternName, desc: pattern.description})
            }

            return matches
        }
    }

    MyGui := Gui("+Resize", "Example 2: Style Pattern Matching")

    MyGui.Add("Text", "w500", "Match controls against common style patterns:")

    ; Create test controls
    controls := []
    controls.Push({ctrl: MyGui.Add("Edit", "w300 y+20 ReadOnly", "Display Field"), name: "Read-Only"})
    controls.Push({ctrl: MyGui.Add("Edit", "w300 y+10 Password"), name: "Password"})
    controls.Push({ctrl: MyGui.Add("Edit", "w300 h100 y+10 Multi"), name: "Text Editor"})
    controls.Push({ctrl: MyGui.Add("Edit", "w300 y+10 Number"), name: "Numeric"})
    controls.Push({ctrl: MyGui.Add("Edit", "w300 y+10"), name: "Standard Input"})

    BtnMatch := MyGui.Add("Button", "w200 y+20", "Match Patterns")
    BtnMatch.OnEvent("Click", MatchPatterns)

    ResultsEdit := MyGui.Add("Edit", "w600 h400 y+10 ReadOnly Multi")

    MyGui.Show()

    MatchPatterns(*) {
        results := "=== STYLE PATTERN MATCHING ===`n`n"

        for item in controls {
            try {
                style := ControlGetStyle(item.ctrl)
                matches := StylePatterns.MatchPattern(style)

                results .= item.name . ":`n"
                results .= "  Style: 0x" . Format("{:08X}", style) . "`n"

                if (matches.Length > 0) {
                    results .= "  Matched Patterns:`n"
                    for match in matches {
                        results .= "    - " . match.name . ": " . match.desc . "`n"
                    }
                } else {
                    results .= "  No standard patterns matched`n"
                }

                results .= "`n"

            } catch as err {
                results .= item.name . ": Error - " . err.Message . "`n`n"
            }
        }

        ResultsEdit.Value := results
    }
}

;==============================================================================
; Example 3: Style Validation System
;==============================================================================

/**
 * Creates a validation system based on control styles
 *
 * @example
 * Validates controls meet specific style requirements
 */
Example3_StyleValidation() {
    /**
     * Style validation class
     */
    class StyleValidator {
        /**
         * Validates that control has required styles
         */
        static ValidateRequired(ctrl, requiredFlags, flagNames := "") {
            style := ControlGetStyle(ctrl)
            missing := []

            for index, flag in requiredFlags {
                if (!(style & flag)) {
                    name := (flagNames && flagNames.Has(index)) ? flagNames[index] : Format("0x{:X}", flag)
                    missing.Push(name)
                }
            }

            return {
                valid: missing.Length = 0,
                missing: missing,
                style: style
            }
        }

        /**
         * Validates that control doesn't have forbidden styles
         */
        static ValidateForbidden(ctrl, forbiddenFlags, flagNames := "") {
            style := ControlGetStyle(ctrl)
            present := []

            for index, flag in forbiddenFlags {
                if (style & flag) {
                    name := (flagNames && flagNames.Has(index)) ? flagNames[index] : Format("0x{:X}", flag)
                    present.Push(name)
                }
            }

            return {
                valid: present.Length = 0,
                forbidden: present,
                style: style
            }
        }

        /**
         * Complete validation check
         */
        static Validate(ctrl, required := [], forbidden := [], requiredNames := "", forbiddenNames := "") {
            reqResult := this.ValidateRequired(ctrl, required, requiredNames)
            forbResult := this.ValidateForbidden(ctrl, forbidden, forbiddenNames)

            return {
                valid: reqResult.valid && forbResult.valid,
                required: reqResult,
                forbidden: forbResult
            }
        }
    }

    MyGui := Gui("+Resize", "Example 3: Style Validation")

    MyGui.Add("Text", "w500", "Validate controls against style requirements:")

    ; Create test controls
    Edit1 := MyGui.Add("Edit", "w300 y+20", "Standard Edit")
    Edit2 := MyGui.Add("Edit", "w300 y+10 ReadOnly", "Read-Only Edit")
    Edit3 := MyGui.Add("Edit", "w300 y+10 Password", "Password Edit")
    Edit4 := MyGui.Add("Edit", "w300 h100 y+10 Multi", "Multiline Edit")

    BtnValidate := MyGui.Add("Button", "w200 y+20", "Validate Controls")
    BtnValidate.OnEvent("Click", ValidateControls)

    ResultsEdit := MyGui.Add("Edit", "w600 h400 y+10 ReadOnly Multi")

    MyGui.Show()

    ValidateControls(*) {
        results := "=== STYLE VALIDATION RESULTS ===`n`n"

        ; Test 1: Ensure Edit1 is editable (not readonly, not disabled)
        results .= "Test 1: Edit1 Should Be Editable`n"
        validation := StyleValidator.Validate(
            Edit1,
            [],  ; No required flags
            [0x0800, 0x08000000],  ; Forbidden: ES_READONLY, WS_DISABLED
            "",
            Map(1, "ES_READONLY", 2, "WS_DISABLED")
        )
        results .= "  Result: " . (validation.valid ? "PASS" : "FAIL") . "`n"
        if (!validation.forbidden.valid) {
            results .= "  Forbidden flags present: " . Join(validation.forbidden.forbidden, ", ") . "`n"
        }
        results .= "`n"

        ; Test 2: Ensure Edit2 is read-only
        results .= "Test 2: Edit2 Should Be Read-Only`n"
        validation := StyleValidator.Validate(
            Edit2,
            [0x0800],  ; Required: ES_READONLY
            [],
            Map(1, "ES_READONLY"),
            ""
        )
        results .= "  Result: " . (validation.valid ? "PASS" : "FAIL") . "`n"
        if (!validation.required.valid) {
            results .= "  Missing required flags: " . Join(validation.required.missing, ", ") . "`n"
        }
        results .= "`n"

        ; Test 3: Ensure Edit3 is password field (not multiline)
        results .= "Test 3: Edit3 Should Be Password Field (Single-Line)`n"
        validation := StyleValidator.Validate(
            Edit3,
            [0x0020],  ; Required: ES_PASSWORD
            [0x0004],  ; Forbidden: ES_MULTILINE
            Map(1, "ES_PASSWORD"),
            Map(1, "ES_MULTILINE")
        )
        results .= "  Result: " . (validation.valid ? "PASS" : "FAIL") . "`n"
        if (!validation.required.valid) {
            results .= "  Missing: " . Join(validation.required.missing, ", ") . "`n"
        }
        if (!validation.forbidden.valid) {
            results .= "  Forbidden present: " . Join(validation.forbidden.forbidden, ", ") . "`n"
        }
        results .= "`n"

        ; Test 4: Ensure Edit4 is multiline
        results .= "Test 4: Edit4 Should Be Multiline`n"
        validation := StyleValidator.Validate(
            Edit4,
            [0x0004],  ; Required: ES_MULTILINE
            [],
            Map(1, "ES_MULTILINE"),
            ""
        )
        results .= "  Result: " . (validation.valid ? "PASS" : "FAIL") . "`n"
        if (!validation.required.valid) {
            results .= "  Missing: " . Join(validation.required.missing, ", ") . "`n"
        }
        results .= "`n"

        ; Summary
        results .= "=== VALIDATION COMPLETE ===`n"

        ResultsEdit.Value := results
    }

    Join(arr, delimiter) {
        if (!arr || arr.Length = 0)
            return "None"
        result := ""
        for item in arr
            result .= item . delimiter
        return SubStr(result, 1, -StrLen(delimiter))
    }
}

;==============================================================================
; Example 4: Style Inheritance Detection
;==============================================================================

/**
 * Detects style inheritance patterns in GUI controls
 *
 * @example
 * Shows which styles are inherited from parent windows
 */
Example4_StyleInheritance() {
    MyGui := Gui("+Resize", "Example 4: Style Inheritance Detection")

    MyGui.Add("Text", "w500", "Analyze style inheritance in nested controls:")

    ; Create group boxes with nested controls
    GroupBox1 := MyGui.Add("GroupBox", "w250 h150 y+20", "Group 1")
    Edit1 := MyGui.Add("Edit", "xp+10 yp+25 w230", "Edit in Group 1")
    Btn1 := MyGui.Add("Button", "xp yp+30 w230", "Button in Group 1")

    GroupBox2 := MyGui.Add("GroupBox", "x+20 yp-55 w250 h150", "Group 2 (Disabled)")
    GroupBox2.Enabled := false
    Edit2 := MyGui.Add("Edit", "xp+10 yp+25 w230", "Edit in Group 2")
    Btn2 := MyGui.Add("Button", "xp yp+30 w230", "Button in Group 2")

    BtnAnalyze := MyGui.Add("Button", "xm y+20 w200", "Analyze Inheritance")
    BtnAnalyze.OnEvent("Click", AnalyzeInheritance)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h300 ReadOnly Multi")

    MyGui.Show()

    AnalyzeInheritance(*) {
        results := "=== STYLE INHERITANCE ANALYSIS ===`n`n"

        ; Analyze Group 1 (enabled)
        results .= "GROUP 1 (Enabled):`n"
        results .= AnalyzeControl(GroupBox1, "  GroupBox 1")
        results .= AnalyzeControl(Edit1, "  Edit in Group 1")
        results .= AnalyzeControl(Btn1, "  Button in Group 1")
        results .= "`n"

        ; Analyze Group 2 (disabled)
        results .= "GROUP 2 (Disabled Parent):`n"
        results .= AnalyzeControl(GroupBox2, "  GroupBox 2")
        results .= AnalyzeControl(Edit2, "  Edit in Group 2")
        results .= AnalyzeControl(Btn2, "  Button in Group 2")
        results .= "`n"

        ; Compare inheritance
        results .= "INHERITANCE COMPARISON:`n"
        results .= CompareStyles(Edit1, Edit2, "Edit Controls")
        results .= CompareStyles(Btn1, Btn2, "Button Controls")

        ResultsEdit.Value := results
    }

    AnalyzeControl(ctrl, label) {
        style := ControlGetStyle(ctrl)
        result := label . ":`n"
        result .= "    Style: 0x" . Format("{:08X}", style) . "`n"
        result .= "    Visible: " . (style & 0x10000000 ? "Yes" : "No") . "`n"
        result .= "    Disabled: " . (style & 0x08000000 ? "Yes" : "No") . "`n"
        result .= "    Child: " . (style & 0x40000000 ? "Yes" : "No") . "`n"
        return result
    }

    CompareStyles(ctrl1, ctrl2, label) {
        style1 := ControlGetStyle(ctrl1)
        style2 := ControlGetStyle(ctrl2)

        result := "  " . label . ":`n"
        result .= "    Style difference: 0x" . Format("{:08X}", style1 ^ style2) . "`n"

        ; Check specific differences
        if ((style1 & 0x08000000) != (style2 & 0x08000000))
            result .= "    Disabled state differs`n"
        if ((style1 & 0x10000000) != (style2 & 0x10000000))
            result .= "    Visibility differs`n"

        return result
    }
}

;==============================================================================
; Example 5: Style-Based Control Classification
;==============================================================================

/**
 * Classifies controls into categories based on their styles
 *
 * @example
 * Groups controls by their functional characteristics
 */
Example5_ControlClassification() {
    class ControlClassifier {
        static Classify(ctrl) {
            style := ControlGetStyle(ctrl)
            className := ctrl.ClassNN

            categories := []

            ; Classify by interaction capability
            if (style & 0x08000000)  ; WS_DISABLED
                categories.Push("Non-Interactive")
            else
                categories.Push("Interactive")

            ; Classify by editability (for edit controls)
            if (InStr(className, "Edit")) {
                if (style & 0x0800)  ; ES_READONLY
                    categories.Push("Display-Only")
                else
                    categories.Push("User-Editable")

                ; Input type
                if (style & 0x0020)  ; ES_PASSWORD
                    categories.Push("Secure-Input")
                else if (style & 0x2000)  ; ES_NUMBER
                    categories.Push("Numeric-Input")
                else if (style & 0x0004)  ; ES_MULTILINE
                    categories.Push("Text-Area")
                else
                    categories.Push("Single-Line-Input")
            }

            ; Classify by visibility
            if (style & 0x10000000)  ; WS_VISIBLE
                categories.Push("Visible")
            else
                categories.Push("Hidden")

            ; Classify by focus capability
            if (style & 0x00010000)  ; WS_TABSTOP
                categories.Push("Focusable")
            else
                categories.Push("Non-Focusable")

            return categories
        }

        static GetCategory(categories, filter) {
            for cat in categories {
                if (cat = filter)
                    return true
            }
            return false
        }
    }

    MyGui := Gui("+Resize", "Example 5: Control Classification")

    MyGui.Add("Text", "w500", "Classify controls by their style characteristics:")

    ; Create diverse set of controls
    controls := []
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+20"), name: "Normal Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+10 ReadOnly"), name: "ReadOnly Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+10 Password"), name: "Password Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 y+10 Number"), name: "Number Edit"})
    controls.Push({ctrl: MyGui.Add("Edit", "w200 h60 y+10 Multi"), name: "Multiline Edit"})
    controls.Push({ctrl: MyGui.Add("Button", "w200 y+10"), name: "Button"})
    controls.Push({ctrl: MyGui.Add("Checkbox", "w200 y+10", "Checkbox"), name: "Checkbox"})

    ; Disable one control for testing
    controls[6].ctrl.Enabled := false

    BtnClassify := MyGui.Add("Button", "w200 y+20", "Classify All Controls")
    BtnClassify.OnEvent("Click", ClassifyAll)

    BtnFilter := MyGui.Add("Button", "x+10 w200", "Filter Interactive")
    BtnFilter.OnEvent("Click", FilterInteractive)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h300 ReadOnly Multi")

    MyGui.Show()

    ClassifyAll(*) {
        results := "=== CONTROL CLASSIFICATION ===`n`n"

        for item in controls {
            categories := ControlClassifier.Classify(item.ctrl)

            results .= item.name . ":`n"
            results .= "  Categories: " . Join(categories, ", ") . "`n"
            results .= "`n"
        }

        ResultsEdit.Value := results
    }

    FilterInteractive(*) {
        results := "=== INTERACTIVE CONTROLS FILTER ===`n`n"
        results .= "Controls that are interactive (not disabled):`n`n"

        for item in controls {
            categories := ControlClassifier.Classify(item.ctrl)

            if (ControlClassifier.GetCategory(categories, "Interactive")) {
                results .= "- " . item.name . "`n"
                results .= "  Categories: " . Join(categories, ", ") . "`n"
                results .= "`n"
            }
        }

        ResultsEdit.Value := results
    }

    Join(arr, delimiter) {
        result := ""
        for item in arr
            result .= item . delimiter
        return SubStr(result, 1, -StrLen(delimiter))
    }
}

;==============================================================================
; Example 6: Advanced Style Comparison
;==============================================================================

/**
 * Advanced comparison of control styles with detailed differences
 *
 * @example
 * Compare multiple controls and show detailed style differences
 */
Example6_AdvancedStyleComparison() {
    MyGui := Gui("+Resize", "Example 6: Advanced Style Comparison")

    MyGui.Add("Text", "w500", "Compare control styles in detail:")

    ; Create controls to compare
    MyGui.Add("Text", "xm y+20", "Control Set 1:")
    Edit1A := MyGui.Add("Edit", "x+10 w200", "Edit 1A")
    Edit1B := MyGui.Add("Edit", "x+10 w200 ReadOnly", "Edit 1B (RO)")

    MyGui.Add("Text", "xm y+10", "Control Set 2:")
    Edit2A := MyGui.Add("Edit", "x+10 w200 Multi", "Edit 2A`nMulti")
    Edit2B := MyGui.Add("Edit", "x+10 w200", "Edit 2B")

    BtnCompare1 := MyGui.Add("Button", "xm y+20 w200", "Compare Set 1")
    BtnCompare1.OnEvent("Click", (*) => CompareControls(Edit1A, Edit1B, "Set 1"))

    BtnCompare2 := MyGui.Add("Button", "x+10 w200", "Compare Set 2")
    BtnCompare2.OnEvent("Click", (*) => CompareControls(Edit2A, Edit2B, "Set 2"))

    BtnCompareAll := MyGui.Add("Button", "xm y+10 w200", "Compare All")
    BtnCompareAll.OnEvent("Click", CompareAll)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h350 ReadOnly Multi")

    MyGui.Show()

    CompareControls(ctrl1, ctrl2, setName) {
        style1 := ControlGetStyle(ctrl1)
        style2 := ControlGetStyle(ctrl2)

        results := "=== COMPARING " . setName . " ===`n`n"

        results .= "Control 1 Style: 0x" . Format("{:08X}", style1) . "`n"
        results .= "Control 2 Style: 0x" . Format("{:08X}", style2) . "`n`n"

        ; XOR to find differences
        diff := style1 ^ style2
        results .= "Difference Mask: 0x" . Format("{:08X}", diff) . "`n`n"

        ; Analyze specific differences
        commonFlags := Map(
            "WS_VISIBLE", 0x10000000,
            "WS_DISABLED", 0x08000000,
            "WS_TABSTOP", 0x00010000,
            "ES_MULTILINE", 0x0004,
            "ES_READONLY", 0x0800,
            "ES_PASSWORD", 0x0020
        )

        results .= "Flag Comparison:`n"
        results .= Format("{:<20} {:<10} {:<10} {:<10}", "Flag", "Ctrl1", "Ctrl2", "Differs") . "`n"
        results .= Format("{:-<60}", "") . "`n"

        for flagName, flagValue in commonFlags {
            has1 := !!(style1 & flagValue)
            has2 := !!(style2 & flagValue)
            differs := has1 != has2

            results .= Format("{:<20} {:<10} {:<10} {:<10}",
                flagName,
                has1 ? "Yes" : "No",
                has2 ? "Yes" : "No",
                differs ? "YES" : "No") . "`n"
        }

        ResultsEdit.Value := results
    }

    CompareAll(*) {
        results := "=== COMPLETE COMPARISON ===`n`n"

        controls := [
            {ctrl: Edit1A, name: "Edit1A"},
            {ctrl: Edit1B, name: "Edit1B"},
            {ctrl: Edit2A, name: "Edit2A"},
            {ctrl: Edit2B, name: "Edit2B"}
        ]

        ; Create comparison matrix
        results .= "Style Matrix:`n"
        results .= Format("{:<10}", "")
        for item in controls
            results .= Format("{:<12}", item.name)
        results .= "`n"

        for i, item1 in controls {
            results .= Format("{:<10}", item1.name)
            for j, item2 in controls {
                if (i = j) {
                    results .= Format("{:<12}", "-")
                } else {
                    style1 := ControlGetStyle(item1.ctrl)
                    style2 := ControlGetStyle(item2.ctrl)
                    diff := style1 ^ style2
                    diffCount := CountSetBits(diff)
                    results .= Format("{:<12}", diffCount . " bits")
                }
            }
            results .= "`n"
        }

        ResultsEdit.Value := results
    }

    CountSetBits(n) {
        count := 0
        while (n > 0) {
            count += n & 1
            n := n >> 1
        }
        return count
    }
}

;==============================================================================
; Main Menu
;==============================================================================

MainGui := Gui("+Resize", "ControlGetStyle Advanced Examples - Main Menu")
MainGui.Add("Text", "w400", "Select an example to run:")

examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
    "Example 1: Control Type Detection",
    "Example 2: Style Pattern Matching",
    "Example 3: Style Validation System",
    "Example 4: Style Inheritance Detection",
    "Example 5: Control Classification",
    "Example 6: Advanced Style Comparison"
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
        case 1: Example1_ControlTypeDetection()
        case 2: Example2_StylePatternMatching()
        case 3: Example3_StyleValidation()
        case 4: Example4_StyleInheritance()
        case 5: Example5_ControlClassification()
        case 6: Example6_AdvancedStyleComparison()
    }
}

return
