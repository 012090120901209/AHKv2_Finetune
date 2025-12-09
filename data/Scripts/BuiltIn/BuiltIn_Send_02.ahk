#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Send Function - Modifiers
* ============================================================================
*
* Advanced modifier key combinations, multi-modifier sequences, and complex
* keystroke patterns for sophisticated automation tasks.
*
* @module BuiltIn_Send_02
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Ctrl Modifier Combinations
; ============================================================================

/**
* Standard Ctrl shortcuts for text editing.
* Demonstrates common Ctrl+ combinations.
*
* @example
* ; Press F1 for Ctrl text editing demo
*/
F1:: {
    ToolTip("Ctrl text editing demo in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Select all text
    ToolTip("Ctrl+A (Select All)...")
    Send("^a")
    Sleep(800)

    ; Bold text (in word processors)
    ToolTip("Ctrl+B (Bold)...")
    Send("^b")
    Sleep(800)

    ; Italic text
    ToolTip("Ctrl+I (Italic)...")
    Send("^i")
    Sleep(800)

    ; Underline text
    ToolTip("Ctrl+U (Underline)...")
    Send("^u")
    Sleep(800)

    ToolTip("Ctrl editing complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Ctrl+Shift combinations for advanced selection
* Shows selection extension techniques
*/
F2:: {
    ToolTip("Ctrl+Shift selection in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Move to beginning of document
    Send("^{Home}")
    Sleep(500)

    ; Select to end of document
    ToolTip("Ctrl+Shift+End (Select to end)...")
    Send("^+{End}")
    Sleep(1000)

    ; Move to beginning again
    Send("^{Home}")
    Sleep(500)

    ; Select word by word (right)
    ToolTip("Ctrl+Shift+Right (Select word)...")
    Send("^+{Right 3}")
    Sleep(1000)

    ToolTip("Selection complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Ctrl navigation shortcuts
* Quick cursor movement with Ctrl
*/
F3:: {
    ToolTip("Ctrl navigation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Jump to beginning
    ToolTip("Ctrl+Home (Jump to start)...")
    Send("^{Home}")
    Sleep(800)

    ; Jump to end
    ToolTip("Ctrl+End (Jump to end)...")
    Send("^{End}")
    Sleep(800)

    ; Word jump left
    ToolTip("Ctrl+Left (Word left x3)...")
    Send("^{Left 3}")
    Sleep(800)

    ; Word jump right
    ToolTip("Ctrl+Right (Word right x3)...")
    Send("^{Right 3}")
    Sleep(800)

    ToolTip("Navigation complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Shift Modifier Techniques
; ============================================================================

/**
* Shift for text selection.
* Basic selection with Shift+Arrows.
*
* @description
* Demonstrates precise text selection
*/
^F1:: {
    ToolTip("Shift selection in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Select characters to the right
    ToolTip("Shift+Right (5 chars)...")
    Send("+{Right 5}")
    Sleep(800)

    ; Extend selection down
    ToolTip("Shift+Down (2 lines)...")
    Send("+{Down 2}")
    Sleep(800)

    ; Select to end of line
    ToolTip("Shift+End...")
    Send("+{End}")
    Sleep(800)

    ; Select to start of line
    ToolTip("Shift+Home...")
    Send("{Home}")
    Sleep(300)
    Send("+{Home}")
    Sleep(800)

    ToolTip("Shift selection complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Shift+Tab for reverse navigation
* Moves backwards through form fields
*/
^F2:: {
    ToolTip("Reverse Tab navigation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Tab forward a few times
    ToolTip("Tabbing forward...")
    Send("{Tab 3}")
    Sleep(1000)

    ; Tab backward with Shift
    ToolTip("Shift+Tab (Reverse)...")
    Send("+{Tab}")
    Sleep(800)

    Send("+{Tab}")
    Sleep(800)

    Send("+{Tab}")
    Sleep(800)

    ToolTip("Reverse navigation complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: Alt Modifier Operations
; ============================================================================

/**
* Alt for menu access.
* Activates menu bar and menu items.
*
* @description
* Demonstrates menu navigation
*/
^F3:: {
    ToolTip("Alt menu navigation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Open File menu (in many applications)
    ToolTip("Alt+F (File menu)...")
    Send("!f")
    Sleep(1000)

    ; Close menu
    Send("{Escape}")
    Sleep(500)

    ; Open Edit menu
    ToolTip("Alt+E (Edit menu)...")
    Send("!e")
    Sleep(1000)

    ; Close menu
    Send("{Escape}")
    Sleep(500)

    ; Open Help menu
    ToolTip("Alt+H (Help menu)...")
    Send("!h")
    Sleep(1000)

    ; Close menu
    Send("{Escape}")

    ToolTip("Menu navigation complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Alt+Tab window switching
* Cycles through open windows
*/
^F4:: {
    ToolTip("Alt+Tab window switching...")

    ; Switch to next window
    ToolTip("Switching windows...")
    Send("!{Tab}")
    Sleep(1000)

    ; Switch again
    Send("!{Tab}")
    Sleep(1000)

    ; Shift+Alt+Tab for reverse
    ToolTip("Reverse switching...")
    Send("!+{Tab}")
    Sleep(1000)

    ToolTip("Window switching complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Win (Windows) Modifier
; ============================================================================

/**
* Windows key combinations.
* System-level shortcuts.
*
* @description
* Demonstrates Win+Key shortcuts
*/
^F5:: {
    ToolTip("Windows key shortcuts demo...")
    Sleep(1000)

    ; Win+D: Show Desktop
    ToolTip("Win+D (Show Desktop)...")
    Send("#d")
    Sleep(1500)

    ; Win+D again: Restore windows
    ToolTip("Win+D (Restore)...")
    Send("#d")
    Sleep(1500)

    ; Win+E: Open Explorer
    ToolTip("Win+E (Explorer)...")
    Send("#e")
    Sleep(2000)

    ; Close Explorer
    WinClose("ahk_class CabinetWClass")

    ToolTip("Windows shortcuts complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Win+Number taskbar shortcuts
* Activates taskbar programs
*/
^F6:: {
    ToolTip("Win+Number shortcuts demo...")
    Sleep(1000)

    ; Win+1: First taskbar item
    ToolTip("Win+1 (First taskbar item)...")
    Send("#1")
    Sleep(1500)

    ; Win+2: Second taskbar item
    ToolTip("Win+2 (Second taskbar item)...")
    Send("#2")
    Sleep(1500)

    ToolTip("Taskbar shortcuts complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 5: Triple Modifier Combinations
; ============================================================================

/**
* Ctrl+Shift+Alt combinations.
* Maximum complexity shortcuts.
*
* @description
* Shows three-modifier key presses
*/
^F7:: {
    ToolTip("Triple modifier demo in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Ctrl+Shift+Escape: Task Manager
    ToolTip("Ctrl+Shift+Esc (Task Manager)...")
    Send("^+{Escape}")
    Sleep(2000)

    ; Close Task Manager
    if WinExist("Task Manager") {
        WinClose("Task Manager")
    }
    Sleep(500)

    ; Custom triple combo (application-specific)
    ToolTip("Ctrl+Alt+Shift+S...")
    Send("^!+s")
    Sleep(1000)

    ToolTip("Triple modifier complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Sequential modifier presses
* Multiple modifier combinations in sequence
*/
^F8:: {
    ToolTip("Sequential modifiers in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Type, then modify
    Send("This text will be bold")

    ; Select the text
    Sleep(300)
    Send("^a")
    Sleep(300)

    ; Apply bold
    Send("^b")
    Sleep(500)

    ; Deselect
    Send("{Right}")
    Sleep(300)

    ; New line
    Send("{Enter}")
    Sleep(300)

    ; Type and apply italic
    Send("This text will be italic")
    Sleep(300)
    Send("^a")
    Sleep(300)
    Send("^i")
    Sleep(300)

    ToolTip("Sequential modifiers complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 6: Modifier Hold and Release
; ============================================================================

/**
* Holding modifier keys down.
* Uses {ModDown} and {ModUp} syntax.
*
* @description
* Demonstrates manual modifier control
*/
^F9:: {
    ToolTip("Modifier hold/release in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Hold Shift down
    ToolTip("Holding Shift...")
    Send("{Shift down}")
    Sleep(500)

    ; Type with Shift held (produces uppercase)
    Send("hello")
    Sleep(500)

    ; Release Shift
    ToolTip("Releasing Shift...")
    Send("{Shift up}")
    Sleep(500)

    ; Type without Shift
    Send(" world")
    Sleep(500)

    ToolTip("Modifier hold complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Multiple simultaneous modifiers
* Holds down multiple keys at once
*/
^F10:: {
    ToolTip("Multiple modifier hold in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Hold Ctrl+Shift
    ToolTip("Holding Ctrl+Shift...")
    Send("{Ctrl down}{Shift down}")
    Sleep(500)

    ; Press End (Ctrl+Shift+End = Select to end)
    Send("{End}")
    Sleep(500)

    ; Release modifiers
    ToolTip("Releasing modifiers...")
    Send("{Shift up}{Ctrl up}")
    Sleep(500)

    ToolTip("Multiple modifier hold complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 7: Complex Modifier Patterns
; ============================================================================

/**
* IDE/Editor shortcuts simulation.
* Common programming editor shortcuts.
*
* @description
* Demonstrates typical IDE keyboard workflow
*/
^F11:: {
    ToolTip("IDE shortcuts simulation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Ctrl+S: Save
    ToolTip("Ctrl+S (Save)...")
    Send("^s")
    Sleep(800)

    ; Ctrl+F: Find
    ToolTip("Ctrl+F (Find)...")
    Send("^f")
    Sleep(800)
    Send("{Escape}")  ; Close find dialog
    Sleep(300)

    ; Ctrl+H: Replace
    ToolTip("Ctrl+H (Replace)...")
    Send("^h")
    Sleep(800)
    Send("{Escape}")  ; Close replace dialog
    Sleep(300)

    ; Ctrl+/: Comment (in many editors)
    ToolTip("Ctrl+/ (Toggle comment)...")
    Send("^/")
    Sleep(800)

    ; Ctrl+D: Duplicate line (in some editors)
    ToolTip("Ctrl+D (Duplicate line)...")
    Send("^d")
    Sleep(800)

    ToolTip("IDE shortcuts complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Browser navigation shortcuts
* Common web browser shortcuts
*/
^F12:: {
    ToolTip("Browser shortcuts in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Ctrl+T: New tab
    ToolTip("Ctrl+T (New tab)...")
    Send("^t")
    Sleep(1000)

    ; Ctrl+L: Address bar
    ToolTip("Ctrl+L (Address bar)...")
    Send("^l")
    Sleep(800)

    ; Type URL
    Send("example.com")
    Sleep(500)

    ; Ctrl+W: Close tab
    ToolTip("Ctrl+W (Close tab)...")
    Send("^w")
    Sleep(1000)

    ; Ctrl+Shift+T: Reopen closed tab
    ToolTip("Ctrl+Shift+T (Reopen tab)...")
    Send("^+t")
    Sleep(1000)

    ToolTip("Browser shortcuts complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Sends modifier combination safely
*
* @param {String} modifiers - Modifier keys (^, +, !, #)
* @param {String} key - Key to press
*/
SendModified(modifiers, key) {
    Send(modifiers . key)
}

/**
* Holds modifier, sends keys, releases modifier
*
* @param {String} modifier - Modifier to hold (Ctrl, Shift, Alt, Win)
* @param {String} keys - Keys to send while holding
*/
SendWithHold(modifier, keys) {
    Send("{" modifier " down}")
    Sleep(50)
    Send(keys)
    Sleep(50)
    Send("{" modifier " up}")
}

; Test utilities
!F1:: {
    SendModified("^", "s")  ; Ctrl+S
    ToolTip("Sent Ctrl+S")
    Sleep(1000)
    ToolTip()
}

!F2:: {
    ToolTip("Sending with hold in 2 seconds...")
    Sleep(2000)
    ToolTip()

    SendWithHold("Shift", "hello world")

    ToolTip("SendWithHold complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    Send - Modifiers
    ================

    F1 - Ctrl text editing
    F2 - Ctrl+Shift selection
    F3 - Ctrl navigation

    Ctrl+F1  - Shift selection
    Ctrl+F2  - Reverse Tab
    Ctrl+F3  - Alt menu navigation
    Ctrl+F4  - Alt+Tab switching
    Ctrl+F5  - Windows shortcuts
    Ctrl+F6  - Win+Number shortcuts
    Ctrl+F7  - Triple modifiers
    Ctrl+F8  - Sequential modifiers
    Ctrl+F9  - Modifier hold/release
    Ctrl+F10 - Multiple modifier hold
    Ctrl+F11 - IDE shortcuts
    Ctrl+F12 - Browser shortcuts

    Alt+F1 - SendModified test
    Alt+F2 - SendWithHold test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Send Modifiers Help")
}
