#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Send Function - Send Keys
 * ============================================================================
 *
 * The Send function simulates keystrokes and key combinations. It's one of
 * the most fundamental functions for automation, supporting special keys,
 * modifiers, and various sending modes.
 *
 * Syntax: Send(Keys)
 *
 * @module BuiltIn_Send_01
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Basic Text Sending
; ============================================================================

/**
 * Sends plain text to active window.
 * Simulates typing text character by character.
 *
 * @example
 * ; Press F1 to type "Hello World"
 */
F1:: {
    ToolTip("Sending text in 2 seconds...`nActivate target window!")
    Sleep(2000)
    ToolTip()

    Send("Hello World")

    ToolTip("Text sent!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends text with line breaks
 * Demonstrates multi-line text sending
 */
F2:: {
    ToolTip("Sending multi-line text in 2 seconds...")
    Sleep(2000)
    ToolTip()

    Send("Line 1{Enter}")
    Send("Line 2{Enter}")
    Send("Line 3")

    ToolTip("Multi-line text sent!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends formatted text
 * Includes paragraphs and spacing
 */
F3:: {
    ToolTip("Sending formatted text in 2 seconds...")
    Sleep(2000)
    ToolTip()

    text := "
    (
    This is the first paragraph.
    It contains multiple lines.

    This is the second paragraph.
    )"

    ; Remove indentation and send
    Send(StrReplace(text, "`n    ", "`n"))

    ToolTip("Formatted text sent!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Special Keys
; ============================================================================

/**
 * Demonstrates sending special keys.
 * Uses curly braces {} for special key names.
 *
 * @description
 * Shows various special key syntax
 */
^F1:: {
    ToolTip("Special keys demonstration in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Enter key
    ToolTip("Pressing Enter...")
    Send("{Enter}")
    Sleep(500)

    ; Tab key
    ToolTip("Pressing Tab...")
    Send("{Tab}")
    Sleep(500)

    ; Backspace
    ToolTip("Pressing Backspace...")
    Send("{Backspace}")
    Sleep(500)

    ; Delete
    ToolTip("Pressing Delete...")
    Send("{Delete}")
    Sleep(500)

    ToolTip("Special keys demonstration complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Arrow keys demonstration
 * Sends directional navigation keys
 */
^F2:: {
    ToolTip("Arrow keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Right arrow (3 times)
    ToolTip("Right arrow x3...")
    Send("{Right 3}")
    Sleep(500)

    ; Down arrow (2 times)
    ToolTip("Down arrow x2...")
    Send("{Down 2}")
    Sleep(500)

    ; Left arrow
    ToolTip("Left arrow...")
    Send("{Left}")
    Sleep(500)

    ; Up arrow
    ToolTip("Up arrow...")
    Send("{Up}")
    Sleep(500)

    ToolTip("Arrow keys complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Function keys and special combinations
 * Demonstrates F1-F12 and other special keys
 */
^F3:: {
    ToolTip("Function keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; F5 (refresh in browsers)
    ToolTip("Pressing F5...")
    Send("{F5}")
    Sleep(1000)

    ; Escape
    ToolTip("Pressing Escape...")
    Send("{Escape}")
    Sleep(500)

    ; Home
    ToolTip("Pressing Home...")
    Send("{Home}")
    Sleep(500)

    ; End
    ToolTip("Pressing End...")
    Send("{End}")
    Sleep(500)

    ToolTip("Function keys complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: Modifier Keys
; ============================================================================

/**
 * Sends keys with Ctrl modifier.
 * Uses ^ symbol for Ctrl.
 *
 * @description
 * Demonstrates Ctrl+Key combinations
 */
^F4:: {
    ToolTip("Ctrl combinations in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Ctrl+A (Select All)
    ToolTip("Ctrl+A (Select All)...")
    Send("^a")
    Sleep(1000)

    ; Ctrl+C (Copy)
    ToolTip("Ctrl+C (Copy)...")
    Send("^c")
    Sleep(1000)

    ; Type some text
    ToolTip("Typing new text...")
    Send("New text here")
    Sleep(1000)

    ; Ctrl+V (Paste)
    ToolTip("Ctrl+V (Paste)...")
    Send("^v")
    Sleep(1000)

    ToolTip("Ctrl combinations complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends keys with Shift modifier
 * Uses + symbol for Shift
 */
^F5:: {
    ToolTip("Shift combinations in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Shift+Home (Select to start of line)
    ToolTip("Shift+Home (Select to start)...")
    Send("+{Home}")
    Sleep(1000)

    ; Shift+End (Select to end of line)
    Send("{End}")  ; Move to end first
    Sleep(300)
    ToolTip("Shift+End (Select to end)...")
    Send("+{End}")
    Sleep(1000)

    ; Shift+Arrow for selection
    ToolTip("Shift+Right Arrow x5...")
    Send("+{Right 5}")
    Sleep(1000)

    ToolTip("Shift combinations complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends keys with Alt modifier
 * Uses ! symbol for Alt
 */
^F6:: {
    ToolTip("Alt combinations in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Alt+F4 would close window, so we demonstrate Alt+Tab
    ToolTip("Alt+Tab (Switch window)...")
    Send("!{Tab}")
    Sleep(1000)

    ; Alt+F (File menu - may not work in all apps)
    ToolTip("Alt+F (File menu)...")
    Send("!f")
    Sleep(1000)

    ; Escape to close any menu
    Send("{Escape}")

    ToolTip("Alt combinations complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Combined Modifiers
; ============================================================================

/**
 * Sends keys with multiple modifiers.
 * Combines Ctrl, Shift, Alt.
 *
 * @description
 * Shows complex key combinations
 */
^F7:: {
    ToolTip("Combined modifiers in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Ctrl+Shift+End (Select to end of document)
    ToolTip("Ctrl+Shift+End...")
    Send("^+{End}")
    Sleep(1000)

    ; Ctrl+Shift+Home (Select to start of document)
    ToolTip("Ctrl+Shift+Home...")
    Send("^+{Home}")
    Sleep(1000)

    ; Ctrl+Alt+Delete is blocked for safety, but we can show other combos
    ; Ctrl+Shift+N (New folder in many apps)
    ToolTip("Ctrl+Shift+N...")
    Send("^+n")
    Sleep(1000)

    ToolTip("Combined modifiers complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 5: Timed and Repeated Keys
; ============================================================================

/**
 * Sends repeated keystrokes.
 * Uses {Key N} syntax for repetition.
 *
 * @description
 * Demonstrates key repetition
 */
^F8:: {
    ToolTip("Repeated keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Send "A" 10 times
    ToolTip("Sending A x10...")
    Send("{A 10}")
    Sleep(1000)

    ; Send Space 5 times
    ToolTip("Sending Space x5...")
    Send("{Space 5}")
    Sleep(1000)

    ; Send Backspace 15 times
    ToolTip("Sending Backspace x15...")
    Send("{Backspace 15}")
    Sleep(1000)

    ToolTip("Repeated keys complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Sends keys with delays
 * Introduces pauses between keystrokes
 */
^F9:: {
    ToolTip("Timed sending in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Send text with delays between words
    ToolTip("Sending with delays...")

    Send("Slow")
    Sleep(500)

    Send(" typing")
    Sleep(500)

    Send(" demonstration")
    Sleep(500)

    Send("...")

    ToolTip("Timed sending complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 6: Form Filling Automation
; ============================================================================

/**
 * Automates filling a form with Tab navigation.
 * Demonstrates practical data entry automation.
 *
 * @description
 * Simulates completing a multi-field form
 */
^F10:: {
    ToolTip("Form filling in 2 seconds...`nActivate form window!")
    Sleep(2000)
    ToolTip()

    ToolTip("Filling form...")

    ; Name field
    Send("John Doe")
    Send("{Tab}")
    Sleep(300)

    ; Email field
    Send("john.doe@example.com")
    Send("{Tab}")
    Sleep(300)

    ; Phone field
    Send("555-1234")
    Send("{Tab}")
    Sleep(300)

    ; Address field
    Send("123 Main Street")
    Send("{Tab}")
    Sleep(300)

    ; City field
    Send("Anytown")
    Send("{Tab}")
    Sleep(300)

    ; ZIP field
    Send("12345")

    ToolTip("Form filling complete!")
    Sleep(1500)
    ToolTip()
}

/**
 * Login automation example
 * Fills username and password fields
 */
^F11:: {
    ToolTip("Login automation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Username field
    ToolTip("Entering username...")
    Send("myusername")
    Sleep(300)

    ; Tab to password field
    Send("{Tab}")
    Sleep(300)

    ; Password field
    ToolTip("Entering password...")
    Send("mypassword")
    Sleep(300)

    ; Submit (Enter or Tab to button and Space)
    ToolTip("Submitting...")
    Send("{Enter}")

    ToolTip("Login automation complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 7: Advanced Send Techniques
; ============================================================================

/**
 * Send keys with raw mode.
 * Uses {Raw} for literal text.
 *
 * @description
 * Shows how to send special characters literally
 */
^F12:: {
    ToolTip("Raw send mode in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Send text that contains special characters
    ToolTip("Sending special characters...")

    ; This sends the literal characters {}, ^, +, etc.
    Send("{Raw}Special chars: ^+!#{}[]")

    Sleep(1000)

    Send("{Enter}")

    ; Send file path with backslashes
    Send("{Raw}C:\Windows\System32\")

    ToolTip("Raw send complete!")
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Types text character by character with delay
 *
 * @param {String} text - Text to type
 * @param {Number} delayMs - Delay between characters
 */
TypeSlowly(text, delayMs := 50) {
    Loop Parse text {
        Send(A_LoopField)
        Sleep(delayMs)
    }
}

/**
 * Sends key combination safely
 *
 * @param {String} keys - Keys to send
 * @returns {Boolean} Success status
 */
SafeSend(keys) {
    try {
        Send(keys)
        return true
    } catch as err {
        MsgBox("Send failed: " err.Message)
        return false
    }
}

; Test utilities
!F1:: {
    ToolTip("Testing TypeSlowly in 2 seconds...")
    Sleep(2000)
    ToolTip()

    TypeSlowly("This text appears slowly...", 100)

    ToolTip("TypeSlowly complete!")
    Sleep(1000)
    ToolTip()
}

!F2:: {
    result := SafeSend("This is a test")
    ToolTip("SafeSend result: " (result ? "Success" : "Failed"))
    Sleep(1500)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc::ExitApp()

F12:: {
    helpText := "
    (
    Send Function - Send Keys
    ==========================

    F1 - Basic text sending
    F2 - Multi-line text
    F3 - Formatted text

    Ctrl+F1  - Special keys demo
    Ctrl+F2  - Arrow keys
    Ctrl+F3  - Function keys
    Ctrl+F4  - Ctrl combinations
    Ctrl+F5  - Shift combinations
    Ctrl+F6  - Alt combinations
    Ctrl+F7  - Combined modifiers
    Ctrl+F8  - Repeated keys
    Ctrl+F9  - Timed sending
    Ctrl+F10 - Form filling
    Ctrl+F11 - Login automation
    Ctrl+F12 - Raw send mode

    Alt+F1 - TypeSlowly test
    Alt+F2 - SafeSend test

    F12 - Show this help
    ESC - Exit script

    NOTE: Activate target window before timer expires!
    )"

    MsgBox(helpText, "Send Examples Help")
}
