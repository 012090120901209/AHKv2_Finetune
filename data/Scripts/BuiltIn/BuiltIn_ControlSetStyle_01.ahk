#Requires AutoHotkey v2.0

/**
* ============================================================================
* ControlSetStyle - Basic Style Modification
* ============================================================================
*
* This script demonstrates how to modify control styles using ControlSetStyle
* in AutoHotkey v2.
*
* ControlSetStyle allows dynamic modification of window styles after control
* creation, enabling runtime UI customization.
*
* @author AutoHotkey Community
* @date 2025-01-16
* @version 1.0.0
*
* Related Functions:
* - ControlGetStyle() - Reads current styles
* - ControlSetExStyle() - Modifies extended styles
* - WinSetStyle() - Modifies window styles
*
* Common Style Modifications:
* - Adding/Removing WS_BORDER (0x00800000)
* - Adding/Removing WS_DISABLED (0x08000000)
* - Toggling ES_READONLY (0x0800)
* - Changing ES_MULTILINE (0x0004)
*/

;==============================================================================
; Example 1: Adding and Removing Basic Styles
;==============================================================================

/**
* Demonstrates adding and removing common control styles
*
* @example
* Shows how to add and remove styles like borders and read-only
*/
Example1_BasicStyleModification() {
    MyGui := Gui("+Resize", "Example 1: Basic Style Modification")

    MyGui.Add("Text", "w500", "Add and remove control styles dynamically:")

    TestEdit := MyGui.Add("Edit", "w300 y+20", "Editable Text")

    ; Style modification buttons
    MyGui.Add("Text", "xm y+20", "Edit Control Styles:")

    BtnAddBorder := MyGui.Add("Button", "w140 y+10", "Add Border")
    BtnAddBorder.OnEvent("Click", (*) => AddStyle(TestEdit, 0x00800000, "WS_BORDER"))

    BtnRemoveBorder := MyGui.Add("Button", "x+10 w140", "Remove Border")
    BtnRemoveBorder.OnEvent("Click", (*) => RemoveStyle(TestEdit, 0x00800000, "WS_BORDER"))

    BtnAddReadOnly := MyGui.Add("Button", "xm y+10 w140", "Make ReadOnly")
    BtnAddReadOnly.OnEvent("Click", (*) => AddStyle(TestEdit, 0x0800, "ES_READONLY"))

    BtnRemoveReadOnly := MyGui.Add("Button", "x+10 w140", "Make Editable")
    BtnRemoveReadOnly.OnEvent("Click", (*) => RemoveStyle(TestEdit, 0x0800, "ES_READONLY"))

    BtnDisable := MyGui.Add("Button", "xm y+10 w140", "Disable")
    BtnDisable.OnEvent("Click", (*) => AddStyle(TestEdit, 0x08000000, "WS_DISABLED"))

    BtnEnable := MyGui.Add("Button", "x+10 w140", "Enable")
    BtnEnable.OnEvent("Click", (*) => RemoveStyle(TestEdit, 0x08000000, "WS_DISABLED"))

    ; Current style display
    StyleText := MyGui.Add("Text", "xm y+20 w400", "")
    UpdateStyleDisplay()

    ; Results log
    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    MyGui.Show()

    AddStyle(ctrl, styleFlag, styleName) {
        oldStyle := ControlGetStyle(ctrl)

        try {
            ControlSetStyle("+" . styleFlag, ctrl)
            newStyle := ControlGetStyle(ctrl)

            result := "Added " . styleName . " (0x" . Format("{:X}", styleFlag) . "):`n"
            result .= "  Before: 0x" . Format("{:08X}", oldStyle) . "`n"
            result .= "  After:  0x" . Format("{:08X}", newStyle) . "`n"
            result .= "  Success: " . ((newStyle & styleFlag) ? "Yes" : "No") . "`n`n"

            ResultsEdit.Value := result . ResultsEdit.Value
            UpdateStyleDisplay()
        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }

    RemoveStyle(ctrl, styleFlag, styleName) {
        oldStyle := ControlGetStyle(ctrl)

        try {
            ControlSetStyle("-" . styleFlag, ctrl)
            newStyle := ControlGetStyle(ctrl)

            result := "Removed " . styleName . " (0x" . Format("{:X}", styleFlag) . "):`n"
            result .= "  Before: 0x" . Format("{:08X}", oldStyle) . "`n"
            result .= "  After:  0x" . Format("{:08X}", newStyle) . "`n"
            result .= "  Success: " . (!(newStyle & styleFlag) ? "Yes" : "No") . "`n`n"

            ResultsEdit.Value := result . ResultsEdit.Value
            UpdateStyleDisplay()
        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }

    UpdateStyleDisplay() {
        style := ControlGetStyle(TestEdit)
        text := "Current Style: 0x" . Format("{:08X}", style) . " | "
        text .= "Border: " . (style & 0x00800000 ? "Yes" : "No") . " | "
        text .= "ReadOnly: " . (style & 0x0800 ? "Yes" : "No") . " | "
        text .= "Disabled: " . (style & 0x08000000 ? "Yes" : "No")
        StyleText.Value := text
    }
}

;==============================================================================
; Example 2: Toggle Style Flags
;==============================================================================

/**
* Demonstrates toggling styles on and off
*
* @example
* Shows how to toggle common style flags
*/
Example2_ToggleStyles() {
    MyGui := Gui("+Resize", "Example 2: Toggle Styles")

    MyGui.Add("Text", "w500", "Toggle control styles on/off:")

    TestEdit := MyGui.Add("Edit", "w400 y+20", "Test Edit Control")

    ; Toggle buttons
    BtnToggleBorder := MyGui.Add("Button", "xm y+20 w180", "Toggle Border")
    BtnToggleBorder.OnEvent("Click", (*) => ToggleStyle(TestEdit, 0x00800000, "WS_BORDER"))

    BtnToggleReadOnly := MyGui.Add("Button", "x+10 w180", "Toggle ReadOnly")
    BtnToggleReadOnly.OnEvent("Click", (*) => ToggleStyle(TestEdit, 0x0800, "ES_READONLY"))

    BtnToggleDisabled := MyGui.Add("Button", "xm y+10 w180", "Toggle Enabled/Disabled")
    BtnToggleDisabled.OnEvent("Click", (*) => ToggleStyle(TestEdit, 0x08000000, "WS_DISABLED"))

    ; Status display
    StatusText := MyGui.Add("Text", "xm y+20 w500 h60", "")
    UpdateStatus()

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

    MyGui.Show()

    ToggleStyle(ctrl, styleFlag, styleName) {
        oldStyle := ControlGetStyle(ctrl)
        hasFlag := !!(oldStyle & styleFlag)

        try {
            ; Toggle: add if not present, remove if present
            ControlSetStyle((hasFlag ? "-" : "+") . styleFlag, ctrl)
            newStyle := ControlGetStyle(ctrl)
            newHasFlag := !!(newStyle & styleFlag)

            result := "Toggled " . styleName . ":`n"
            result .= "  Was: " . (hasFlag ? "ON" : "OFF") . "`n"
            result .= "  Now: " . (newHasFlag ? "ON" : "OFF") . "`n"
            result .= "  Style: 0x" . Format("{:08X}", oldStyle) . " -> 0x" . Format("{:08X}", newStyle) . "`n`n"

            ResultsEdit.Value := result . ResultsEdit.Value
            UpdateStatus()
        } catch as err {
            MsgBox("Error: " . err.Message, "Error", "IconX")
        }
    }

    UpdateStatus() {
        style := ControlGetStyle(TestEdit)

        status := "=== CURRENT STYLE STATUS ===`n`n"
        status .= "Style Value: 0x" . Format("{:08X}", style) . "`n`n"
        status .= "WS_BORDER:    " . (style & 0x00800000 ? "✓ ON" : "✗ OFF") . "`n"
        status .= "ES_READONLY:  " . (style & 0x0800 ? "✓ ON" : "✗ OFF") . "`n"
        status .= "WS_DISABLED:  " . (style & 0x08000000 ? "✓ ON" : "✗ OFF") . "`n"

        StatusText.Value := status
    }
}

;==============================================================================
; Example 3: Multiple Style Changes
;==============================================================================

/**
* Demonstrates changing multiple styles at once
*
* @example
* Shows how to apply multiple style modifications simultaneously
*/
Example3_MultipleStyleChanges() {
    MyGui := Gui("+Resize", "Example 3: Multiple Style Changes")

    MyGui.Add("Text", "w500", "Apply multiple style changes at once:")

    TestEdit := MyGui.Add("Edit", "w400 y+20", "Test Control")

    ; Preset style configurations
    BtnStandard := MyGui.Add("Button", "xm y+20 w180", "Standard Input")
    BtnStandard.OnEvent("Click", ApplyStandard)

    BtnReadOnly := MyGui.Add("Button", "x+10 w180", "Display Only")
    BtnReadOnly.OnEvent("Click", ApplyDisplayOnly)

    BtnDisabled := MyGui.Add("Button", "xm y+10 w180", "Disabled Input")
    BtnDisabled.OnEvent("Click", ApplyDisabled)

    BtnBordered := MyGui.Add("Button", "x+10 w180", "Bordered Editable")
    BtnBordered.OnEvent("Click", ApplyBordered)

    ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h350 ReadOnly Multi")

    MyGui.Show()

    ApplyStandard(*) {
        ApplyPreset("Standard Input", [
        {
            action: "-", flag: 0x0800, name: "ES_READONLY"},
            {
                action: "-", flag: 0x08000000, name: "WS_DISABLED"},
                {
                    action: "-", flag: 0x00800000, name: "WS_BORDER"
                }
                ])
            }

            ApplyDisplayOnly(*) {
                ApplyPreset("Display Only", [
                {
                    action: "+", flag: 0x0800, name: "ES_READONLY"},
                    {
                        action: "-", flag: 0x08000000, name: "WS_DISABLED"},
                        {
                            action: "+", flag: 0x00800000, name: "WS_BORDER"
                        }
                        ])
                    }

                    ApplyDisabled(*) {
                        ApplyPreset("Disabled Input", [
                        {
                            action: "+", flag: 0x08000000, name: "WS_DISABLED"},
                            {
                                action: "+", flag: 0x00800000, name: "WS_BORDER"
                            }
                            ])
                        }

                        ApplyBordered(*) {
                            ApplyPreset("Bordered Editable", [
                            {
                                action: "-", flag: 0x0800, name: "ES_READONLY"},
                                {
                                    action: "-", flag: 0x08000000, name: "WS_DISABLED"},
                                    {
                                        action: "+", flag: 0x00800000, name: "WS_BORDER"
                                    }
                                    ])
                                }

                                ApplyPreset(presetName, changes) {
                                    oldStyle := ControlGetStyle(TestEdit)

                                    result := "=== Applying Preset: " . presetName . " ===`n`n"
                                    result .= "Before: 0x" . Format("{:08X}", oldStyle) . "`n`n"
                                    result .= "Changes:`n"

                                    ; Apply each change
                                    for change in changes {
                                        try {
                                            ControlSetStyle(change.action . change.flag, TestEdit)
                                            result .= "  " . change.action . " " . change.name . "`n"
                                        } catch as err {
                                            result .= "  ERROR: " . change.name . " - " . err.Message . "`n"
                                        }
                                    }

                                    newStyle := ControlGetStyle(TestEdit)
                                    result .= "`nAfter: 0x" . Format("{:08X}", newStyle) . "`n"
                                    result .= "`n" . Format("{:-<50}", "") . "`n`n"

                                    ResultsEdit.Value := result . ResultsEdit.Value
                                }
                            }

                            ;==============================================================================
                            ; Example 4: Style Validation After Modification
                            ;==============================================================================

                            /**
                            * Validates that style changes were applied correctly
                            *
                            * @example
                            * Shows how to verify style modifications
                            */
                            Example4_StyleValidation() {
                                MyGui := Gui("+Resize", "Example 4: Style Validation")

                                MyGui.Add("Text", "w500", "Validate style changes:")

                                TestEdit := MyGui.Add("Edit", "w400 y+20", "Test Edit")

                                BtnTest := MyGui.Add("Button", "xm y+20 w200", "Run Validation Test")
                                BtnTest.OnEvent("Click", RunTest)

                                ResultsEdit := MyGui.Add("Edit", "xm y+10 w600 h400 ReadOnly Multi")

                                MyGui.Show()

                                RunTest(*) {
                                    results := "=== STYLE VALIDATION TEST ===`n`n"

                                    ; Test 1: Add WS_BORDER
                                    results .= "Test 1: Adding WS_BORDER`n"
                                    oldStyle := ControlGetStyle(TestEdit)
                                    ControlSetStyle("+0x00800000", TestEdit)
                                    newStyle := ControlGetStyle(TestEdit)
                                    success := !!(newStyle & 0x00800000)
                                    results .= "  Expected: Flag present`n"
                                    results .= "  Result: " . (success ? "✓ PASS" : "✗ FAIL") . "`n"
                                    results .= "  Style: 0x" . Format("{:08X}", oldStyle) . " -> 0x" . Format("{:08X}", newStyle) . "`n`n"

                                    ; Test 2: Remove WS_BORDER
                                    results .= "Test 2: Removing WS_BORDER`n"
                                    oldStyle := ControlGetStyle(TestEdit)
                                    ControlSetStyle("-0x00800000", TestEdit)
                                    newStyle := ControlGetStyle(TestEdit)
                                    success := !(newStyle & 0x00800000)
                                    results .= "  Expected: Flag removed`n"
                                    results .= "  Result: " . (success ? "✓ PASS" : "✗ FAIL") . "`n"
                                    results .= "  Style: 0x" . Format("{:08X}", oldStyle) . " -> 0x" . Format("{:08X}", newStyle) . "`n`n"

                                    ; Test 3: Add ES_READONLY
                                    results .= "Test 3: Adding ES_READONLY`n"
                                    oldStyle := ControlGetStyle(TestEdit)
                                    ControlSetStyle("+0x0800", TestEdit)
                                    newStyle := ControlGetStyle(TestEdit)
                                    success := !!(newStyle & 0x0800)
                                    results .= "  Expected: Flag present`n"
                                    results .= "  Result: " . (success ? "✓ PASS" : "✗ FAIL") . "`n"

                                    ; Verify read-only behavior
                                    oldText := TestEdit.Value
                                    TestEdit.Value := "New Text"
                                    actuallyReadOnly := (TestEdit.Value = oldText)
                                    results .= "  Behavioral Check: " . (actuallyReadOnly ? "✓ Truly ReadOnly" : "⚠ Still Editable") . "`n"
                                    results .= "  Style: 0x" . Format("{:08X}", oldStyle) . " -> 0x" . Format("{:08X}", newStyle) . "`n`n"

                                    ; Test 4: Multiple changes
                                    results .= "Test 4: Multiple Style Changes`n"
                                    ControlSetStyle("-0x0800", TestEdit)  ; Remove readonly
                                    ControlSetStyle("+0x00800000", TestEdit)  ; Add border
                                    finalStyle := ControlGetStyle(TestEdit)
                                    hasReadOnly := !!(finalStyle & 0x0800)
                                    hasBorder := !!(finalStyle & 0x00800000)
                                    results .= "  ES_READONLY removed: " . (!hasReadOnly ? "✓ PASS" : "✗ FAIL") . "`n"
                                    results .= "  WS_BORDER added: " . (hasBorder ? "✓ PASS" : "✗ FAIL") . "`n"
                                    results .= "  Final Style: 0x" . Format("{:08X}", finalStyle) . "`n`n"

                                    results .= "=== ALL TESTS COMPLETE ===`n"

                                    ResultsEdit.Value := results
                                }
                            }

                            ;==============================================================================
                            ; Example 5: Conditional Style Modification
                            ;==============================================================================

                            /**
                            * Modifies styles based on conditions
                            *
                            * @example
                            * Shows conditional style application
                            */
                            Example5_ConditionalModification() {
                                MyGui := Gui("+Resize", "Example 5: Conditional Modification")

                                MyGui.Add("Text", "w500", "Apply styles based on conditions:")

                                TestEdit := MyGui.Add("Edit", "w400 y+20", "Enter text here")
                                CheckReadOnly := MyGui.Add("Checkbox", "xm y+10", "Make ReadOnly when checked")
                                CheckBorder := MyGui.Add("Checkbox", "xm y+10", "Show Border")
                                CheckDisable := MyGui.Add("Checkbox", "xm y+10", "Disable when checked")

                                BtnApply := MyGui.Add("Button", "xm y+20 w200", "Apply Conditions")
                                BtnApply.OnEvent("Click", ApplyConditions)

                                ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h300 ReadOnly Multi")

                                MyGui.Show()

                                ApplyConditions(*) {
                                    results := "=== Applying Conditional Styles ===`n`n"
                                    oldStyle := ControlGetStyle(TestEdit)

                                    ; Apply ReadOnly based on checkbox
                                    if (CheckReadOnly.Value) {
                                        ControlSetStyle("+0x0800", TestEdit)
                                        results .= "✓ Added ES_READONLY (checkbox checked)`n"
                                    } else {
                                        ControlSetStyle("-0x0800", TestEdit)
                                        results .= "✓ Removed ES_READONLY (checkbox unchecked)`n"
                                    }

                                    ; Apply Border based on checkbox
                                    if (CheckBorder.Value) {
                                        ControlSetStyle("+0x00800000", TestEdit)
                                        results .= "✓ Added WS_BORDER (checkbox checked)`n"
                                    } else {
                                        ControlSetStyle("-0x00800000", TestEdit)
                                        results .= "✓ Removed WS_BORDER (checkbox unchecked)`n"
                                    }

                                    ; Apply Disabled based on checkbox
                                    if (CheckDisable.Value) {
                                        ControlSetStyle("+0x08000000", TestEdit)
                                        results .= "✓ Added WS_DISABLED (checkbox checked)`n"
                                    } else {
                                        ControlSetStyle("-0x08000000", TestEdit)
                                        results .= "✓ Removed WS_DISABLED (checkbox unchecked)`n"
                                    }

                                    newStyle := ControlGetStyle(TestEdit)
                                    results .= "`nStyle: 0x" . Format("{:08X}", oldStyle) . " -> 0x" . Format("{:08X}", newStyle) . "`n"
                                    results .= "`n" . Format("{:-<50}", "") . "`n`n"

                                    ResultsEdit.Value := result . ResultsEdit.Value
                                }
                            }

                            ;==============================================================================
                            ; Example 6: Style Restore and Undo
                            ;==============================================================================

                            /**
                            * Implements style change history and undo functionality
                            *
                            * @example
                            * Shows how to save and restore previous styles
                            */
                            Example6_StyleHistory() {
                                styleHistory := []
                                currentIndex := 0

                                MyGui := Gui("+Resize", "Example 6: Style History & Undo")

                                MyGui.Add("Text", "w500", "Style history with undo/redo:")

                                TestEdit := MyGui.Add("Edit", "w400 y+20", "Test Edit")

                                ; Save initial style
                                SaveCurrentStyle()

                                ; Modification buttons
                                BtnToggleBorder := MyGui.Add("Button", "xm y+20 w130", "Toggle Border")
                                BtnToggleBorder.OnEvent("Click", (*) => ModifyAndSave(0x00800000))

                                BtnToggleReadOnly := MyGui.Add("Button", "x+5 w130", "Toggle ReadOnly")
                                BtnToggleReadOnly.OnEvent("Click", (*) => ModifyAndSave(0x0800))

                                BtnToggleDisable := MyGui.Add("Button", "x+5 w130", "Toggle Disable")
                                BtnToggleDisable.OnEvent("Click", (*) => ModifyAndSave(0x08000000))

                                ; History buttons
                                BtnUndo := MyGui.Add("Button", "xm y+20 w130", "⟲ Undo")
                                BtnUndo.OnEvent("Click", Undo)

                                BtnRedo := MyGui.Add("Button", "x+5 w130", "⟳ Redo")
                                BtnRedo.OnEvent("Click", Redo)

                                BtnReset := MyGui.Add("Button", "x+5 w130", "↺ Reset to Initial")
                                BtnReset.OnEvent("Click", ResetToInitial)

                                StatusText := MyGui.Add("Text", "xm y+20 w500", "")
                                UpdateStatus()

                                ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")

                                MyGui.Show()

                                SaveCurrentStyle() {
                                    style := ControlGetStyle(TestEdit)

                                    ; Remove any redo history when making new change
                                    if (currentIndex < styleHistory.Length)
                                    styleHistory.RemoveAt(currentIndex + 1, styleHistory.Length - currentIndex)

                                    styleHistory.Push(style)
                                    currentIndex := styleHistory.Length
                                }

                                ModifyAndSave(flag) {
                                    oldStyle := ControlGetStyle(TestEdit)
                                    hasFlag := !!(oldStyle & flag)

                                    ControlSetStyle((hasFlag ? "-" : "+") . flag, TestEdit)
                                    newStyle := ControlGetStyle(TestEdit)

                                    SaveCurrentStyle()

                                    result := "Toggled 0x" . Format("{:X}", flag) . ": "
                                    result .= (hasFlag ? "OFF" : "ON") . " -> " . (!hasFlag ? "ON" : "OFF") . "`n"
                                    result .= "Style: 0x" . Format("{:08X}", oldStyle) . " -> 0x" . Format("{:08X}", newStyle) . "`n`n"

                                    ResultsEdit.Value := result . ResultsEdit.Value
                                    UpdateStatus()
                                }

                                Undo(*) {
                                    if (currentIndex <= 1) {
                                        MsgBox("Nothing to undo", "Info", "Iconi")
                                        return
                                    }

                                    currentIndex--
                                    style := styleHistory[currentIndex]

                                    ; Set the style directly
                                    ControlSetStyle(style, TestEdit)

                                    ResultsEdit.Value := "⟲ Undone - Restored to: 0x" . Format("{:08X}", style) . "`n`n" . ResultsEdit.Value
                                    UpdateStatus()
                                }

                                Redo(*) {
                                    if (currentIndex >= styleHistory.Length) {
                                        MsgBox("Nothing to redo", "Info", "Iconi")
                                        return
                                    }

                                    currentIndex++
                                    style := styleHistory[currentIndex]

                                    ControlSetStyle(style, TestEdit)

                                    ResultsEdit.Value := "⟳ Redone - Restored to: 0x" . Format("{:08X}", style) . "`n`n" . ResultsEdit.Value
                                    UpdateStatus()
                                }

                                ResetToInitial(*) {
                                    if (styleHistory.Length = 0)
                                    return

                                    initialStyle := styleHistory[1]
                                    ControlSetStyle(initialStyle, TestEdit)

                                    ; Clear history and start fresh
                                    styleHistory := [initialStyle]
                                    currentIndex := 1

                                    ResultsEdit.Value := "↺ Reset to initial: 0x" . Format("{:08X}", initialStyle) . "`n`n" . ResultsEdit.Value
                                    UpdateStatus()
                                }

                                UpdateStatus() {
                                    style := ControlGetStyle(TestEdit)

                                    status := "Current: 0x" . Format("{:08X}", style) . " | "
                                    status .= "History: " . currentIndex . "/" . styleHistory.Length . " | "
                                    status .= "Undo: " . (currentIndex > 1 ? "Available" : "N/A") . " | "
                                    status .= "Redo: " . (currentIndex < styleHistory.Length ? "Available" : "N/A")

                                    StatusText.Value := status
                                }
                            }

                            ;==============================================================================
                            ; Example 7: Batch Style Modifications
                            ;==============================================================================

                            /**
                            * Modifies styles for multiple controls at once
                            *
                            * @example
                            * Shows how to apply style changes to multiple controls
                            */
                            Example7_BatchModifications() {
                                MyGui := Gui("+Resize", "Example 7: Batch Modifications")

                                MyGui.Add("Text", "w500", "Apply styles to multiple controls:")

                                ; Create multiple controls
                                controls := []
                                controls.Push(MyGui.Add("Edit", "xm y+20 w150", "Edit 1"))
                                controls.Push(MyGui.Add("Edit", "x+10 w150", "Edit 2"))
                                controls.Push(MyGui.Add("Edit", "x+10 w150", "Edit 3"))
                                controls.Push(MyGui.Add("Edit", "xm y+10 w150", "Edit 4"))
                                controls.Push(MyGui.Add("Edit", "x+10 w150", "Edit 5"))
                                controls.Push(MyGui.Add("Edit", "x+10 w150", "Edit 6"))

                                ; Batch operations
                                BtnAddBorders := MyGui.Add("Button", "xm y+20 w150", "Add Borders to All")
                                BtnAddBorders.OnEvent("Click", (*) => BatchModify("+0x00800000", "WS_BORDER"))

                                BtnRemoveBorders := MyGui.Add("Button", "x+10 w150", "Remove All Borders")
                                BtnRemoveBorders.OnEvent("Click", (*) => BatchModify("-0x00800000", "WS_BORDER"))

                                BtnMakeReadOnly := MyGui.Add("Button", "xm y+10 w150", "Make All ReadOnly")
                                BtnMakeReadOnly.OnEvent("Click", (*) => BatchModify("+0x0800", "ES_READONLY"))

                                BtnMakeEditable := MyGui.Add("Button", "x+10 w150", "Make All Editable")
                                BtnMakeEditable.OnEvent("Click", (*) => BatchModify("-0x0800", "ES_READONLY"))

                                BtnAlternate := MyGui.Add("Button", "xm y+10 w310", "Alternate Styles (1,3,5 vs 2,4,6)")
                                BtnAlternate.OnEvent("Click", AlternateStyles)

                                ResultsEdit := MyGui.Add("Edit", "xm y+10 w500 h250 ReadOnly Multi")

                                MyGui.Show()

                                BatchModify(styleChange, styleName) {
                                    results := "=== Batch: " . styleName . " ===`n\n"
                                    successCount := 0

                                    for index, ctrl in controls {
                                        try {
                                            oldStyle := ControlGetStyle(ctrl)
                                            ControlSetStyle(styleChange, ctrl)
                                            newStyle := ControlGetStyle(ctrl)

                                            results .= "Control " . index . ": 0x" . Format("{:08X}", oldStyle)
                                            results .= " -> 0x" . Format("{:08X}", newStyle) . "`n"
                                            successCount++
                                        } catch as err {
                                            results .= "Control " . index . ": ERROR - " . err.Message . "`n"
                                        }
                                    }

                                    results .= "`nSuccess: " . successCount . "/" . controls.Length . "`n"
                                    results .= Format("{:-<50}", "") . "`n`n"

                                    ResultsEdit.Value := results . ResultsEdit.Value
                                }

                                AlternateStyles(*) {
                                    results := "=== Alternating Styles ===`n`n"

                                    for index, ctrl in controls {
                                        try {
                                            if (Mod(index, 2) = 1) {
                                                ; Odd: Add border, make readonly
                                                ControlSetStyle("+0x00800000", ctrl)
                                                ControlSetStyle("+0x0800", ctrl)
                                                results .= "Control " . index . ": Border + ReadOnly`n"
                                            } else {
                                                ; Even: Remove border, make editable
                                                ControlSetStyle("-0x00800000", ctrl)
                                                ControlSetStyle("-0x0800", ctrl)
                                                results .= "Control " . index . ": No Border + Editable`n"
                                            }
                                        } catch as err {
                                            results .= "Control " . index . ": ERROR`n"
                                        }
                                    }

                                    results .= "`n" . Format("{:-<50}", "") . "`n`n"
                                    ResultsEdit.Value := results . ResultsEdit.Value
                                }
                            }

                            ;==============================================================================
                            ; Main Menu
                            ;==============================================================================

                            MainGui := Gui("+Resize", "ControlSetStyle Examples - Main Menu")
                            MainGui.Add("Text", "w400", "Select an example to run:")

                            examplesList := MainGui.Add("ListBox", "w400 h200 y+10", [
                            "Example 1: Basic Style Modification",
                            "Example 2: Toggle Styles",
                            "Example 3: Multiple Style Changes",
                            "Example 4: Style Validation",
                            "Example 5: Conditional Modification",
                            "Example 6: Style History & Undo",
                            "Example 7: Batch Modifications"
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
                                    case 1: Example1_BasicStyleModification()
                                    case 2: Example2_ToggleStyles()
                                    case 3: Example3_MultipleStyleChanges()
                                    case 4: Example4_StyleValidation()
                                    case 5: Example5_ConditionalModification()
                                    case 6: Example6_StyleHistory()
                                    case 7: Example7_BatchModifications()
                                }
                            }

                            return
