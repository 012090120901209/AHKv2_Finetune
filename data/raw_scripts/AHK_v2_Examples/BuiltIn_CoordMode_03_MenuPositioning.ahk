#Requires AutoHotkey v2.0
/**
 * BuiltIn_CoordMode_03_MenuPositioning.ahk
 *
 * DESCRIPTION:
 * Demonstrates CoordMode effects on menu and caret positioning,
 * essential for context menus and text editing automation.
 *
 * FEATURES:
 * - Menu positioning with different coordinate modes
 * - Caret position tracking and automation
 * - Context menu creation and placement
 * - Dynamic menu positioning based on mouse/window
 * - Tooltip coordinate handling
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - CoordMode for Menu positioning
 * - CoordMode for Caret detection
 * - Menu.Show() coordinate parameters
 * - CaretGetPos() function
 * - Tooltip positioning with CoordMode
 *
 * LEARNING POINTS:
 * 1. Menu coordinates default to Screen mode
 * 2. Caret position depends on active edit control
 * 3. CoordMode affects where menus appear
 * 4. Tooltips also respect coordinate mode
 * 5. Window vs Client important for menu placement
 * 6. Context menus benefit from cursor-relative positioning
 * 7. Coordinate mode should match usage context
 */

;===============================================================================
; EXAMPLE 1: Basic Menu Positioning Modes
;===============================================================================

Example1_BasicMenuPositioning() {
    ; Create main window
    mainGui := Gui(, "Menu Positioning Demo")
    mainGui.Add("Text", "x10 y10 w380",
                "Right-click anywhere in this window to see menu")

    canvas := mainGui.Add("Edit", "x10 y40 w380 h250 Multi", "")

    mainGui.Show("w400 h310")

    ; Create context menu
    contextMenu := Menu()
    contextMenu.Add("Screen Mode", (*) => ShowMenuAt("Screen"))
    contextMenu.Add("Window Mode", (*) => ShowMenuAt("Window"))
    contextMenu.Add("Client Mode", (*) => ShowMenuAt("Client"))
    contextMenu.Add()
    contextMenu.Add("About", (*) => MsgBox("Menu Positioning Demo", "About"))

    ShowMenuAt(mode) {
        MsgBox("Menu was shown using " mode " coordinate mode`n`n"
             . "Each mode positions the menu differently:", mode)
    }

    ; Right-click handler with SCREEN coordinates
    mainGui.OnEvent("ContextMenu", (guiObj, ctrl, item, isRightClick, x, y) {
        if isRightClick {
            ; Save current mode
            savedMode := CoordMode("Menu")

            ; Show menu in SCREEN mode (default)
            CoordMode("Menu", "Screen")
            contextMenu.Show(x, y)

            ; Restore mode
            CoordMode("Menu", savedMode)
        }
    })

    MsgBox("Right-click in the window to see the context menu.`n`n"
         . "The menu appears at cursor position using Screen coordinates.",
         "Instructions")
}

;===============================================================================
; EXAMPLE 2: Dynamic Menu Positioning
;===============================================================================

Example2_DynamicMenus() {
    ; Create application window
    appGui := Gui(, "Dynamic Menu System")

    ; Top menu bar
    menuBar := Menu()
    fileMenu := Menu()
    fileMenu.Add("New`tCtrl+N", (*) => MsgBox("New file"))
    fileMenu.Add("Open`tCtrl+O", (*) => MsgBox("Open file"))
    fileMenu.Add("Save`tCtrl+S", (*) => MsgBox("Save file"))
    menuBar.Add("&File", fileMenu)

    ; Editor area
    appGui.Add("Text", "x10 y10", "Editor:")
    editor := appGui.Add("Edit", "x10 y30 w480 h300 Multi", "Sample text`nRight-click for context menu")

    ; Status bar
    statusBar := appGui.Add("Text", "x10 y340 w480", "Ready")

    appGui.Show("w500 h370")

    ; Create dynamic context menu
    editorMenu := Menu()
    editorMenu.Add("Cut", (*) => EditCommand("Cut"))
    editorMenu.Add("Copy", (*) => EditCommand("Copy"))
    editorMenu.Add("Paste", (*) => EditCommand("Paste"))
    editorMenu.Add()
    editorMenu.Add("Select All", (*) => EditCommand("SelectAll"))
    editorMenu.Add()
    editorMenu.Add("Insert Date", (*) => InsertText(FormatTime(, "yyyy-MM-dd")))
    editorMenu.Add("Insert Time", (*) => InsertText(FormatTime(, "HH:mm:ss")))

    EditCommand(cmd) {
        statusBar.Value := "Executed: " cmd
        switch cmd {
            case "Cut":
                Send("^x")
            case "Copy":
                Send("^c")
            case "Paste":
                Send("^v")
            case "SelectAll":
                Send("^a")
        }
    }

    InsertText(text) {
        SendText(text)
        statusBar.Value := "Inserted: " text
    }

    ; Context menu handler
    editor.OnEvent("ContextMenu", (ctrl, item, isRightClick, x, y) {
        if isRightClick {
            ; Use Client coordinates for menu relative to editor
            CoordMode("Menu", "Client")

            ; Get caret position if available
            try {
                CaretGetPos(&caretX, &caretY)
                ; Show menu near caret if visible
                editorMenu.Show(caretX + 10, caretY + 10)
            } catch {
                ; Fall back to mouse position
                CoordMode("Menu", "Screen")
                editorMenu.Show(x, y)
            }
        }
    })

    MsgBox("Right-click in the editor to see dynamic context menu.`n`n"
         . "Menu appears near text cursor when possible.", "Instructions")
}

;===============================================================================
; EXAMPLE 3: Caret Position Tracking
;===============================================================================

Example3_CaretTracking() {
    ; Create text editor with caret tracking
    editorGui := Gui(, "Caret Position Tracker")

    editorGui.Add("Text", "x10 y10", "Type in the text boxes below:")

    ; Text input 1
    editorGui.Add("Text", "x10 y40", "Input 1:")
    input1 := editorGui.Add("Edit", "x70 y35 w300", "")

    ; Text input 2
    editorGui.Add("Text", "x10 y70", "Input 2:")
    input2 := editorGui.Add("Edit", "x70 y65 w300 Multi", "Multi-line text`nSecond line")

    ; Caret info display
    editorGui.Add("Text", "x10 y140", "Caret Information:")
    caretInfo := editorGui.Add("Edit", "x10 y160 w360 h120 ReadOnly Multi", "")

    btnTrack := editorGui.Add("Button", "x10 y290 w175 h30", "Start Tracking")
    btnStop := editorGui.Add("Button", "x195 y290 w175 h30", "Stop Tracking")

    editorGui.Show("w385 h340")

    isTracking := false

    StartTracking(*) {
        isTracking := true
        SetTimer(UpdateCaretInfo, 100)
        btnTrack.Enabled := false
        btnStop.Enabled := true
    }

    StopTracking(*) {
        isTracking := false
        SetTimer(UpdateCaretInfo, 0)
        btnTrack.Enabled := true
        btnStop.Enabled := false
    }

    UpdateCaretInfo() {
        if !isTracking
            return

        info := "Caret Status:`n"

        try {
            ; Get caret position (always in screen coordinates)
            if CaretGetPos(&x, &y) {
                info .= "Position Found!`n"
                info .= "Screen X: " x "`n"
                info .= "Screen Y: " y "`n`n"

                ; Convert to window coordinates
                WinGetPos(&winX, &winY, , , "A")
                info .= "Window-Relative:`n"
                info .= "X: " (x - winX) "`n"
                info .= "Y: " (y - winY) "`n`n"

                ; Show which input has focus
                focused := ControlGetFocus("A")
                info .= "Focused: " focused
            } else {
                info .= "No caret detected`n"
                info .= "(Click in a text box)"
            }
        } catch Error as err {
            info .= "Error: " err.Message
        }

        caretInfo.Value := info
    }

    btnTrack.OnEvent("Click", StartTracking)
    btnStop.OnEvent("Click", StopTracking)
    btnStop.Enabled := false

    editorGui.OnEvent("Close", (*) => (StopTracking(), editorGui.Destroy()))

    MsgBox("Click 'Start Tracking' and then type in the text boxes.`n`n"
         . "Watch the caret position update in real-time!", "Instructions")
}

;===============================================================================
; EXAMPLE 4: Smart Tooltip Positioning
;===============================================================================

Example4_SmartTooltips() {
    ; Create demo window with hover areas
    tooltipGui := Gui(, "Smart Tooltip Demo")

    tooltipGui.Add("Text", "x10 y10 w380",
                   "Hover over the buttons to see smart tooltips")

    ; Create buttons with tooltips
    btn1 := tooltipGui.Add("Button", "x10 y40 w180 h40", "Hover Me (Top-Left)")
    btn2 := tooltipGui.Add("Button", "x210 y40 w180 h40", "Hover Me (Top-Right)")
    btn3 := tooltipGui.Add("Button", "x10 y100 w180 h40", "Hover Me (Mid-Left)")
    btn4 := tooltipGui.Add("Button", "x210 y100 w180 h40", "Hover Me (Mid-Right)")
    btn5 := tooltipGui.Add("Button", "x10 y160 w180 h40", "Hover Me (Bot-Left)")
    btn6 := tooltipGui.Add("Button", "x210 y160 w180 h40", "Hover Me (Bot-Right)")

    ; Mode selector
    tooltipGui.Add("Text", "x10 y210", "Tooltip Mode:")
    modeSelect := tooltipGui.Add("DropDownList", "x100 y205 w100 Choose1",
                                 ["Screen", "Window", "Client"])

    tooltipGui.Show("w400 h250")

    ; Tooltip data
    tooltipData := Map(
        btn1.Hwnd, "This is the top-left button",
        btn2.Hwnd, "This is the top-right button",
        btn3.Hwnd, "This is the mid-left button",
        btn4.Hwnd, "This is the mid-right button",
        btn5.Hwnd, "This is the bottom-left button",
        btn6.Hwnd, "This is the bottom-right button"
    )

    ; Mouse tracking
    SetTimer(CheckHover, 100)

    lastHovered := 0

    CheckHover() {
        CoordMode("Mouse", "Screen")
        MouseGetPos(, , , &ctrl)

        if tooltipData.Has(ctrl) && ctrl != lastHovered {
            lastHovered := ctrl

            ; Get tooltip mode
            mode := modeSelect.Text

            ; Position tooltip based on mode
            switch mode {
                case "Screen":
                    CoordMode("ToolTip", "Screen")
                    MouseGetPos(&x, &y)
                    ToolTip(tooltipData[ctrl], x + 15, y + 15)

                case "Window":
                    CoordMode("ToolTip", "Window")
                    CoordMode("Mouse", "Window")
                    MouseGetPos(&x, &y)
                    ToolTip(tooltipData[ctrl], x + 15, y + 15)

                case "Client":
                    CoordMode("ToolTip", "Client")
                    CoordMode("Mouse", "Client")
                    MouseGetPos(&x, &y)
                    ToolTip(tooltipData[ctrl], x + 15, y + 15)
            }
        } else if !tooltipData.Has(ctrl) && lastHovered != 0 {
            ToolTip()
            lastHovered := 0
        }
    }

    tooltipGui.OnEvent("Close", (*) => (
        SetTimer(CheckHover, 0),
        ToolTip(),
        tooltipGui.Destroy()
    ))

    MsgBox("Hover over buttons to see tooltips.`n`n"
         . "Change the mode to see different positioning!", "Instructions")
}

;===============================================================================
; EXAMPLE 5: Autocomplete Menu System
;===============================================================================

Example5_AutocompleteMenu() {
    ; Create editor with autocomplete
    acGui := Gui(, "Autocomplete Editor")

    acGui.Add("Text", "x10 y10", "Type 'func', 'var', or 'loop' for suggestions")
    editor := acGui.Add("Edit", "x10 y30 w380 h250 Multi",
                        "; Start typing AutoHotkey code here`n`n")

    acGui.Show("w400 h300")

    ; Autocomplete suggestions
    suggestions := Map(
        "func", ["function()", "func MyFunc()", "MyFunc() {`n    `n}"],
        "var", ["variable := value", "local var", "global var"],
        "loop", ["Loop {`n    `n}", "Loop 10 {`n    `n}", "Loop Files, *.*"]
    )

    ; Create suggestion menu
    suggestionMenu := Menu()

    lastWord := ""

    ; Monitor for trigger words
    editor.OnEvent("Change", CheckForAutocomplete)

    CheckForAutocomplete(*) {
        ; Get current text
        text := editor.Value

        ; Get last word typed
        RegExMatch(text, "(\w+)$", &match)
        if !match
            return

        word := match[1]

        if suggestions.Has(word) && word != lastWord {
            lastWord := word
            ShowSuggestions(word)
        }
    }

    ShowSuggestions(word) {
        ; Clear existing menu items
        Loop {
            try {
                suggestionMenu.Delete("1&")
            } catch {
                break
            }
        }

        ; Add suggestions
        for index, suggestion in suggestions[word] {
            suggestionMenu.Add(suggestion, InsertSuggestion)
        }

        ; Get caret position and show menu
        try {
            if CaretGetPos(&x, &y) {
                CoordMode("Menu", "Screen")
                suggestionMenu.Show(x, y + 20)
            }
        }
    }

    InsertSuggestion(itemName, itemPos, menuObj) {
        ; Replace last word with suggestion
        text := editor.Value
        text := RegExReplace(text, "\w+$", itemName)
        editor.Value := text

        ; Move cursor to end
        editor.Focus()
        Send("^{End}")

        lastWord := ""
    }

    MsgBox("Type 'func', 'var', or 'loop' to see autocomplete suggestions!`n`n"
         . "Menu appears at caret position.", "Instructions")
}

;===============================================================================
; EXAMPLE 6: Multi-Window Menu Coordinator
;===============================================================================

Example6_MultiWindowMenus() {
    ; Create multiple windows
    win1 := Gui(, "Window 1")
    win1.Add("Text", "x10 y10", "Window 1 - Right click for menu")
    win1Canvas := win1.Add("Edit", "x10 y30 w280 h150 Multi", "Window 1 content")
    win1.Show("x100 y100 w300 h200")

    win2 := Gui(, "Window 2")
    win2.Add("Text", "x10 y10", "Window 2 - Right click for menu")
    win2Canvas := win2.Add("Edit", "x10 y30 w280 h150 Multi", "Window 2 content")
    win2.Show("x450 y100 w300 h200")

    ; Shared menu
    sharedMenu := Menu()
    sharedMenu.Add("Window Info", ShowWindowInfo)
    sharedMenu.Add("Close This Window", CloseWindow)

    ShowWindowInfo(*) {
        WinGetTitle(&title, "A")
        WinGetPos(&x, &y, &w, &h, "A")

        MsgBox("Active Window:`n"
             . "Title: " title "`n"
             . "Position: (" x ", " y ")`n"
             . "Size: " w "x" h, "Window Info")
    }

    CloseWindow(*) {
        WinClose("A")
    }

    ; Context menu handlers for both windows
    win1.OnEvent("ContextMenu", (gui, ctrl, item, isRight, x, y) {
        if isRight {
            CoordMode("Menu", "Screen")
            sharedMenu.Show(x, y)
        }
    })

    win2.OnEvent("ContextMenu", (gui, ctrl, item, isRight, x, y) {
        if isRight {
            CoordMode("Menu", "Screen")
            sharedMenu.Show(x, y)
        }
    })

    MsgBox("Right-click in either window to see the context menu.`n`n"
         . "Notice how the same menu works across multiple windows!", "Instructions")
}

;===============================================================================
; EXAMPLE 7: Advanced Caret-Following Tooltips
;===============================================================================

Example7_CaretTooltips() {
    ; Create writing assistant
    assistGui := Gui(, "Writing Assistant")

    assistGui.Add("Text", "x10 y10", "Start typing to see word count at caret")
    textArea := assistGui.Add("Edit", "x10 y30 w380 h200 Multi",
                              "Type your text here...")

    statsDisplay := assistGui.Add("Edit", "x10 y240 w380 h60 ReadOnly Multi", "")

    btnToggle := assistGui.Add("Button", "x10 y310 w380 h30", "Toggle Caret Tooltip")

    assistGui.Show("w400 h360")

    showCaretTooltip := false

    ToggleCaretTooltip(*) {
        showCaretTooltip := !showCaretTooltip
        if showCaretTooltip {
            SetTimer(UpdateCaretTooltip, 500)
            btnToggle.Text := "Disable Caret Tooltip"
        } else {
            SetTimer(UpdateCaretTooltip, 0)
            ToolTip()
            btnToggle.Text := "Enable Caret Tooltip"
        }
    }

    UpdateCaretTooltip() {
        if !showCaretTooltip
            return

        ; Get text statistics
        text := textArea.Value
        words := StrSplit(text, [" ", "`n", "`r", "`t"])
        wordCount := 0

        for word in words {
            if StrLen(Trim(word)) > 0
                wordCount++
        }

        charCount := StrLen(text)
        lineCount := 1
        Loop Parse, text, "`n"
            lineCount := A_Index

        ; Update stats display
        statsDisplay.Value := "Words: " wordCount " | Characters: " charCount " | Lines: " lineCount

        ; Show tooltip at caret
        try {
            if CaretGetPos(&x, &y) {
                ToolTip("Words: " wordCount "`nChars: " charCount, x + 10, y + 20)
            }
        }
    }

    btnToggle.OnEvent("Click", ToggleCaretTooltip)

    assistGui.OnEvent("Close", (*) => (
        SetTimer(UpdateCaretTooltip, 0),
        ToolTip(),
        assistGui.Destroy()
    ))

    MsgBox("Click 'Toggle Caret Tooltip' to see stats at cursor!`n`n"
         . "The tooltip follows your caret as you type.", "Instructions")
}

;===============================================================================
; Run Examples
;===============================================================================

; Uncomment to run specific examples:
; Example1_BasicMenuPositioning()
; Example2_DynamicMenus()
; Example3_CaretTracking()
; Example4_SmartTooltips()
; Example5_AutocompleteMenu()
; Example6_MultiWindowMenus()
; Example7_CaretTooltips()
