#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Send Function - Special Keys
* ============================================================================
*
* Advanced special key handling, multimedia keys, numpad keys, and
* application-specific key combinations for comprehensive automation.
*
* @module BuiltIn_Send_03
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Function Keys (F1-F12)
; ============================================================================

/**
* Demonstrates all function keys.
* F1-F12 with various applications.
*
* @example
* ; Press F1 to cycle through function keys
*/
F1:: {
    ToolTip("Function keys demonstration in 2 seconds...")
    Sleep(2000)
    ToolTip()

    functionKeys := ["{F1}", "{F2}", "{F3}", "{F4}", "{F5}", "{F6}",
    "{F7}", "{F8}", "{F9}", "{F10}", "{F11}", "{F12}"]

    for index, fkey in functionKeys {
        ToolTip("Pressing " SubStr(fkey, 2, -1) "...")
        Send(fkey)
        Sleep(600)
    }

    ToolTip("Function keys complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Function keys with modifiers
* Demonstrates Shift/Ctrl/Alt + Function keys
*/
F2:: {
    ToolTip("Modified function keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Shift+F10 (Context menu in many apps)
    ToolTip("Shift+F10 (Context menu)...")
    Send("+{F10}")
    Sleep(1000)
    Send("{Escape}")
    Sleep(500)

    ; Ctrl+F4 (Close tab/document)
    ToolTip("Ctrl+F4 (Close document)...")
    Send("^{F4}")
    Sleep(1000)

    ; Alt+F4 (Close window) - be careful!
    ; ToolTip("Alt+F4 (Close window)...")
    ; Send("!{F4}")

    ToolTip("Modified function keys complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Navigation Keys
; ============================================================================

/**
* Demonstrates Page Up/Down, Home/End keys.
* Essential for document navigation.
*
* @description
* Shows page and line navigation
*/
^F1:: {
    ToolTip("Navigation keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Home - Start of line
    ToolTip("Home (Line start)...")
    Send("{Home}")
    Sleep(800)

    ; End - End of line
    ToolTip("End (Line end)...")
    Send("{End}")
    Sleep(800)

    ; Page Down
    ToolTip("Page Down...")
    Send("{PgDn}")
    Sleep(800)

    ; Page Up
    ToolTip("Page Up...")
    Send("{PgUp}")
    Sleep(800)

    ; Ctrl+Home - Document start
    ToolTip("Ctrl+Home (Document start)...")
    Send("^{Home}")
    Sleep(800)

    ; Ctrl+End - Document end
    ToolTip("Ctrl+End (Document end)...")
    Send("^{End}")
    Sleep(800)

    ToolTip("Navigation complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Insert/Delete keys
* Toggle insert mode and delete operations
*/
^F2:: {
    ToolTip("Insert/Delete keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Insert key (toggle insert mode in some editors)
    ToolTip("Insert (Toggle insert mode)...")
    Send("{Insert}")
    Sleep(1000)

    ; Delete key
    ToolTip("Delete...")
    Send("{Delete}")
    Sleep(800)

    ; Shift+Delete (Cut in many apps)
    ToolTip("Shift+Delete (Cut)...")
    Send("+{Delete}")
    Sleep(800)

    ; Shift+Insert (Paste in many apps)
    ToolTip("Shift+Insert (Paste)...")
    Send("+{Insert}")
    Sleep(800)

    ToolTip("Insert/Delete complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: Numpad Keys
; ============================================================================

/**
* Sends numpad-specific keys.
* Differentiates between numpad and top row numbers.
*
* @description
* Demonstrates NumpadX key syntax
*/
^F3:: {
    ToolTip("Numpad keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Numpad numbers
    ToolTip("Numpad 1-9...")
    Loop 9 {
        Send("{Numpad" A_Index "}")
        Sleep(200)
    }

    ; Numpad 0
    Send("{Numpad0}")
    Sleep(500)

    ; Numpad operators
    ToolTip("Numpad operators...")
    Send("{NumpadAdd}")      ; +
    Sleep(300)
    Send("{NumpadSub}")      ; -
    Sleep(300)
    Send("{NumpadMult}")     ; *
    Sleep(300)
    Send("{NumpadDiv}")      ; /
    Sleep(300)
    Send("{NumpadDot}")      ; .
    Sleep(300)

    ; Numpad Enter
    ToolTip("Numpad Enter...")
    Send("{NumpadEnter}")

    ToolTip("Numpad keys complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Calculator automation with numpad
* Demonstrates numpad for calculations
*/
^F4:: {
    ToolTip("Opening Calculator...")

    Run("calc.exe")
    Sleep(1500)

    if WinWait("Calculator", , 5) {
        WinActivate("Calculator")
        Sleep(500)

        ToolTip("Calculating 123 + 456...")

        ; Type calculation using numpad
        Send("{Numpad1}{Numpad2}{Numpad3}")
        Sleep(300)
        Send("{NumpadAdd}")
        Sleep(300)
        Send("{Numpad4}{Numpad5}{Numpad6}")
        Sleep(300)
        Send("{NumpadEnter}")
        Sleep(2000)

        ToolTip("Calculation complete!")
        Sleep(1000)
        ToolTip()

        ; Close calculator
        WinClose("Calculator")
    }
}

; ============================================================================
; Example 4: Multimedia Keys
; ============================================================================

/**
* Sends multimedia control keys.
* Volume, playback, and media controls.
*
* @description
* Demonstrates media key simulation
*/
^F5:: {
    ToolTip("Multimedia keys demo...")

    ; Volume Down
    ToolTip("Volume Down...")
    Send("{Volume_Down 3}")
    Sleep(800)

    ; Volume Up
    ToolTip("Volume Up...")
    Send("{Volume_Up 3}")
    Sleep(800)

    ; Mute
    ToolTip("Mute Toggle...")
    Send("{Volume_Mute}")
    Sleep(800)

    ; Unmute
    Send("{Volume_Mute}")
    Sleep(500)

    ToolTip("Multimedia keys complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Media playback controls
* Play, pause, next, previous
*/
^F6:: {
    ToolTip("Media playback controls...")

    ; Play/Pause
    ToolTip("Play/Pause...")
    Send("{Media_Play_Pause}")
    Sleep(1000)

    ; Next track
    ToolTip("Next Track...")
    Send("{Media_Next}")
    Sleep(1000)

    ; Previous track
    ToolTip("Previous Track...")
    Send("{Media_Prev}")
    Sleep(1000)

    ; Stop
    ToolTip("Stop...")
    Send("{Media_Stop}")
    Sleep(500)

    ToolTip("Media controls complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 5: Browser Keys
; ============================================================================

/**
* Browser-specific special keys.
* Back, forward, refresh, search.
*
* @description
* Demonstrates browser navigation keys
*/
^F7:: {
    ToolTip("Browser keys in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Browser Back
    ToolTip("Browser Back...")
    Send("{Browser_Back}")
    Sleep(1000)

    ; Browser Forward
    ToolTip("Browser Forward...")
    Send("{Browser_Forward}")
    Sleep(1000)

    ; Browser Refresh
    ToolTip("Browser Refresh...")
    Send("{Browser_Refresh}")
    Sleep(1000)

    ; Browser Home
    ToolTip("Browser Home...")
    Send("{Browser_Home}")
    Sleep(1000)

    ; Browser Search
    ToolTip("Browser Search...")
    Send("{Browser_Search}")
    Sleep(1000)

    ToolTip("Browser keys complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 6: Application Launch Keys
; ============================================================================

/**
* Application launcher keys.
* Quick launch media, mail, etc.
*
* @description
* Demonstrates launch key simulation
*/
^F8:: {
    ToolTip("Launch keys demo...")

    ; Launch Mail
    ToolTip("Launch Mail...")
    Send("{Launch_Mail}")
    Sleep(2000)

    ; Launch Media
    ToolTip("Launch Media...")
    Send("{Launch_Media}")
    Sleep(2000)

    ; Launch App1
    ToolTip("Launch App1...")
    Send("{Launch_App1}")
    Sleep(2000)

    ToolTip("Launch keys complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 7: Special Character Input
; ============================================================================

/**
* Sends special characters using Alt codes.
* Numeric keypad method for special characters.
*
* @description
* Demonstrates Alt+NumCode input
*/
^F9:: {
    ToolTip("Special characters in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; © symbol (Alt+0169)
    ToolTip("Sending © symbol...")
    Send("{Alt down}{Numpad0}{Numpad1}{Numpad6}{Numpad9}{Alt up}")
    Sleep(1000)

    Send(" ")  ; Space
    Sleep(300)

    ; ® symbol (Alt+0174)
    ToolTip("Sending ® symbol...")
    Send("{Alt down}{Numpad0}{Numpad1}{Numpad7}{Numpad4}{Alt up}")
    Sleep(1000)

    Send(" ")
    Sleep(300)

    ; ™ symbol (Alt+0153)
    ToolTip("Sending ™ symbol...")
    Send("{Alt down}{Numpad0}{Numpad1}{Numpad5}{Numpad3}{Alt up}")
    Sleep(1000)

    ToolTip("Special characters complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Unicode character input
* Sends Unicode characters
*/
^F10:: {
    ToolTip("Unicode characters in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Various Unicode characters
    Send("☺ ")  ; Smiley
    Sleep(300)
    Send("★ ")  ; Star
    Sleep(300)
    Send("♥ ")  ; Heart
    Sleep(300)
    Send("→ ")  ; Arrow
    Sleep(300)
    Send("✓ ")  ; Checkmark

    ToolTip("Unicode complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 8: Lock Keys
; ============================================================================

/**
* Toggles lock keys.
* CapsLock, NumLock, ScrollLock.
*
* @description
* Demonstrates lock key control
*/
^F11:: {
    ToolTip("Lock keys demo...")

    ; Toggle CapsLock
    ToolTip("Toggle CapsLock...")
    Send("{CapsLock}")
    Sleep(1000)

    ; Check state
    capsState := GetKeyState("CapsLock", "T")
    ToolTip("CapsLock: " (capsState ? "ON" : "OFF"))
    Sleep(1000)

    ; Toggle back
    Send("{CapsLock}")
    Sleep(500)

    ; Toggle NumLock
    ToolTip("Toggle NumLock...")
    Send("{NumLock}")
    Sleep(1000)

    ; Toggle back
    Send("{NumLock}")
    Sleep(500)

    ; Toggle ScrollLock
    ToolTip("Toggle ScrollLock...")
    Send("{ScrollLock}")
    Sleep(1000)

    ; Toggle back
    Send("{ScrollLock}")

    ToolTip("Lock keys complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 9: PrintScreen and System Keys
; ============================================================================

/**
* System-level special keys.
* PrintScreen, Pause, Apps.
*
* @description
* Demonstrates system key simulation
*/
^F12:: {
    ToolTip("System keys demo...")

    ; PrintScreen (takes screenshot)
    ToolTip("PrintScreen...")
    Send("{PrintScreen}")
    Sleep(1500)

    ; Apps key (context menu)
    ToolTip("Apps key (Context menu)...")
    Send("{AppsKey}")
    Sleep(1000)
    Send("{Escape}")
    Sleep(500)

    ; Pause/Break key
    ToolTip("Pause/Break...")
    Send("{Pause}")
    Sleep(1000)

    ToolTip("System keys complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
* Sends numpad sequence
*
* @param {String} numbers - String of digits
*/
SendNumpadSequence(numbers) {
    Loop Parse numbers {
        Send("{Numpad" A_LoopField "}")
        Sleep(50)
    }
}

/**
* Types special character by Alt code
*
* @param {String} code - Alt code (e.g., "0169" for ©)
*/
TypeAltCode(code) {
    Send("{Alt down}")
    Loop Parse code {
        Send("{Numpad" A_LoopField "}")
        Sleep(30)
    }
    Send("{Alt up}")
}

; Test utilities
!F1:: {
    ToolTip("SendNumpadSequence test in 2 seconds...")
    Sleep(2000)
    ToolTip()

    SendNumpadSequence("1234567890")

    ToolTip("Numpad sequence complete!")
    Sleep(1000)
    ToolTip()
}

!F2:: {
    ToolTip("TypeAltCode test in 2 seconds...")
    Sleep(2000)
    ToolTip()

    TypeAltCode("0169")  ; © symbol

    ToolTip("Alt code sent!")
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
    Send - Special Keys
    ===================

    F1 - Function keys (F1-F12)
    F2 - Modified function keys

    Ctrl+F1  - Navigation keys
    Ctrl+F2  - Insert/Delete keys
    Ctrl+F3  - Numpad keys
    Ctrl+F4  - Calculator automation
    Ctrl+F5  - Multimedia keys
    Ctrl+F6  - Media playback controls
    Ctrl+F7  - Browser keys
    Ctrl+F8  - Launch keys
    Ctrl+F9  - Alt code characters
    Ctrl+F10 - Unicode characters
    Ctrl+F11 - Lock keys
    Ctrl+F12 - System keys

    Alt+F1 - SendNumpadSequence test
    Alt+F2 - TypeAltCode test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "Special Keys Help")
}
