#Requires AutoHotkey v2.0
#SingleInstance Force

/*
AHK v2 System Settings Functions - Corrected

Note: Many v1 commands have been removed or changed in v2.
These are the v2-compatible versions.
*/

; ============================================================================
; BLOCK INPUT
; ============================================================================
; BlockInput prevents user input (keyboard/mouse)
BlockInputExample() {
    ; Block all input
    BlockInput(true)
    MsgBox("Input is blocked for 3 seconds")
    Sleep(3000)
    BlockInput(false)
    MsgBox("Input is now unblocked")
}

; Wrapper function for BlockInput
blockInput(option) {
    ; In v2, BlockInput takes true/false or "Send"/"Mouse"/"SendAndMouse"/"Default"
    try {
        if (option = "On" || option = 1)
            BlockInput(true)
        else if (option = "Off" || option = 0)
            BlockInput(false)
        else
            BlockInput(option)  ; "Send", "Mouse", etc.
        return true
    } catch Error as e {
        MsgBox("BlockInput error: " e.Message)
        return false
    }
}

; ============================================================================
; COORD MODE
; ============================================================================
; CoordMode sets coordinate system for various commands
CoordModeExample() {
    ; Set mouse coordinates relative to screen
    CoordMode("Mouse", "Screen")
    MouseGetPos(&x, &y)
    MsgBox("Mouse position (Screen): " x ", " y)

    ; Set mouse coordinates relative to active window
    CoordMode("Mouse", "Window")
    MouseGetPos(&x, &y)
    MsgBox("Mouse position (Window): " x ", " y)

    ; Other valid modes: "Pixel", "Caret", "Menu", "ToolTip"
}

; Wrapper function
coordMode(targetType, relativeTo := "Screen") {
    ; targetType: "Mouse", "Pixel", "Caret", "Menu", "ToolTip"
    ; relativeTo: "Screen", "Window", "Client"
    try {
        CoordMode(targetType, relativeTo)
        return true
    } catch Error as e {
        MsgBox("CoordMode error: " e.Message)
        return false
    }
}

; ============================================================================
; CRITICAL
; ============================================================================
; Critical prevents current thread from being interrupted
CriticalExample() {
    Critical()  ; Enable critical
    MsgBox("This thread cannot be interrupted")

    ; Do some critical work
    loop 5 {
        ToolTip("Critical work " A_Index)
        Sleep(500)
    }

    Critical(false)  ; Disable critical
    ToolTip()
    MsgBox("Critical section ended")
}

; Wrapper function
critical(onOffNumeric := true) {
    ; In v2: Critical() or Critical(false) or Critical("Off")
    ; Can also use numeric timeout: Critical(1000) for 1 second
    try {
        if (onOffNumeric = "" || onOffNumeric = true || onOffNumeric = "On")
            Critical()
        else if (onOffNumeric = false || onOffNumeric = "Off")
            Critical(false)
        else if (IsNumber(onOffNumeric))
            Critical(onOffNumeric)  ; Numeric timeout in ms
        return true
    } catch Error as e {
        MsgBox("Critical error: " e.Message)
        return false
    }
}

; ============================================================================
; DETECT HIDDEN WINDOWS/TEXT
; ============================================================================
; Control whether hidden windows/text are detected
DetectHiddenExample() {
    ; Show current settings
    MsgBox("DetectHiddenWindows: " A_DetectHiddenWindows "`nDetectHiddenText: " A_DetectHiddenText)

    ; Enable detection of hidden windows
    DetectHiddenWindows(true)
    MsgBox("Hidden windows now detected")

    ; Disable
    DetectHiddenWindows(false)
    MsgBox("Hidden windows now ignored")
}

; Wrapper functions
detectHiddenWindows(onOff) {
    try {
        if (onOff = "On" || onOff = 1 || onOff = true)
            DetectHiddenWindows(true)
        else
            DetectHiddenWindows(false)
        return true
    } catch Error as e {
        MsgBox("DetectHiddenWindows error: " e.Message)
        return false
    }
}

detectHiddenText(onOff) {
    try {
        if (onOff = "On" || onOff = 1 || onOff = true)
            DetectHiddenText(true)
        else
            DetectHiddenText(false)
        return true
    } catch Error as e {
        MsgBox("DetectHiddenText error: " e.Message)
        return false
    }
}

; ============================================================================
; SEND MODE (replaces SendMode command)
; ============================================================================
; SendMode sets the default send method
SendModeExample() {
    ; In v2, use SendMode function
    SendMode("Event")   ; Default - fastest but may not work in all apps
    Send("Hello")

    SendMode("Input")   ; Uses SendInput - faster and more reliable
    Send("World")

    SendMode("Play")    ; Uses SendPlay - for games
    Send("!")
}

; ============================================================================
; SET BATCH LINES (removed in v2)
; ============================================================================
; Note: SetBatchLines doesn't exist in v2 (always runs at max speed)
; Use Sleep() if you need to slow down execution

; ============================================================================
; SET WIN DELAY / SET CONTROL DELAY
; ============================================================================
SetDelayExample() {
    ; Set delay between window commands (in milliseconds)
    SetWinDelay(100)

    ; Set delay between control commands
    SetControlDelay(50)

    ; Set to -1 for no delay (fastest)
    SetWinDelay(-1)
    SetControlDelay(-1)
}

; ============================================================================
; DEMONSTRATION
; ============================================================================

; Uncomment to test:
; BlockInputExample()
; CoordModeExample()
; CriticalExample()
; DetectHiddenExample()
; SendModeExample()
; SetDelayExample()

MsgBox("System Settings Functions Loaded`n`nUncomment examples at the bottom to test each function.")
