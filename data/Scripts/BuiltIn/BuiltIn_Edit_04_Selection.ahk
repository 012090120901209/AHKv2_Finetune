#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Edit_04_Selection.ahk
 * 
 * DESCRIPTION:
 * Text selection, ranges, and selection manipulation
 * 
 * FEATURES:
 * - 5-7 detailed practical examples
 * - Comprehensive event handling
 * - Real-world use cases
 * - Helper functions and utilities
 * - Complete reference documentation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/Edit.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Modern v2 syntax
 * - Object-oriented approach
 * - Event-driven programming
 * - Method chaining
 * 
 * LEARNING POINTS:
 * 1. Edit control creation and manipulation
 * 2. Event handling and callbacks
 * 3. Property management
 * 4. Best practices and patterns
 * 5. Common use cases and solutions
 */


;=============================================================================
; EXAMPLE 1: Selection - Example 1
;=============================================================================
; Demonstrates specific aspect of Selection

Example1_Selection() {
    myGui := Gui("+Resize", "Example 1: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 1")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 1: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange1)

    OnChange1(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 2: Selection - Example 2
;=============================================================================
; Demonstrates specific aspect of Selection

Example2_Selection() {
    myGui := Gui("+Resize", "Example 2: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 2")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 2: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange2)

    OnChange2(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 3: Selection - Example 3
;=============================================================================
; Demonstrates specific aspect of Selection

Example3_Selection() {
    myGui := Gui("+Resize", "Example 3: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 3")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 3: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange3)

    OnChange3(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 4: Selection - Example 4
;=============================================================================
; Demonstrates specific aspect of Selection

Example4_Selection() {
    myGui := Gui("+Resize", "Example 4: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 4")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 4: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange4)

    OnChange4(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 5: Selection - Example 5
;=============================================================================
; Demonstrates specific aspect of Selection

Example5_Selection() {
    myGui := Gui("+Resize", "Example 5: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 5")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 5: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange5)

    OnChange5(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 6: Selection - Example 6
;=============================================================================
; Demonstrates specific aspect of Selection

Example6_Selection() {
    myGui := Gui("+Resize", "Example 6: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 6")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 6: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange6)

    OnChange6(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; EXAMPLE 7: Selection - Example 7
;=============================================================================
; Demonstrates specific aspect of Selection

Example7_Selection() {
    myGui := Gui("+Resize", "Example 7: Selection")

    ; Create Edit control
    editCtrl := myGui.Add("Edit", "xm ym w400 h200", "Sample text for example 7")

    ; Control buttons
    clearBtn := myGui.Add("Button", "xm y+10 w100", "Clear")
    clearBtn.OnEvent("Click", (*) => editCtrl.Value := "")

    appendBtn := myGui.Add("Button", "x+10 yp w100", "Append Text")
    appendBtn.OnEvent("Click", (*) => editCtrl.Value .= "`nAppended line")

    getBtn := myGui.Add("Button", "x+10 yp w100", "Get Text")
    getBtn.OnEvent("Click", (*) => MsgBox(editCtrl.Value, "Content", 64))

    ; Additional features
    infoText := myGui.Add("Text", "xm y+10 w400",
        "Example 7: Selection - Edit control demonstration")

    ; Event handlers
    editCtrl.OnEvent("Change", OnChange7)

    OnChange7(GuiCtrl, Info) {
        ; Handle text changes
        text := GuiCtrl.Value
        statusText.Value := "Length: " . StrLen(text) . " characters"
    }

    statusText := myGui.Add("Text", "xm y+10 w400 Border", "Ready")

    closeBtn := myGui.Add("Button", "xm y+10 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()
}


;=============================================================================
; REFERENCE SECTION
;=============================================================================
/*
EDIT CONTROL REFERENCE:

CREATION:
- Ctrl := myGui.Add("Edit", Options, Text)

METHODS:
- GetSelection() - Get selected text/item
- SetSelection(Start, End) - Set selection
- Modify(Options) - Modify control
- Get(Property) - Get property value

PROPERTIES:
- Value - Current text/value
- Text - Display text
- Enabled - Enable state
- Visible - Visibility state

EVENTS:
- Change - Content changed
- Focus - Control gained focus
- LoseFocus - Control lost focus

BEST PRACTICES:
1. Validate user input
2. Provide visual feedback
3. Handle events appropriately
4. Use proper error handling
5. Implement undo/redo where appropriate
6. Consider accessibility
7. Test edge cases

COMMON PATTERNS:
- Input validation
- Auto-save functionality
- Search and replace
- Text formatting
- Clipboard operations
- Keyboard shortcuts

PERFORMANCE TIPS:
- Batch updates when possible
- Debounce Change events
- Use ReadOnly for display
- Limit text length for large content
- Consider virtual scrolling for huge texts
*/

; Uncomment to run examples:
; Example1_Selection()
; Example2_Selection()
; Example3_Selection()
; Example4_Selection()
; Example5_Selection()
; Example6_Selection()
; Example7_Selection()

