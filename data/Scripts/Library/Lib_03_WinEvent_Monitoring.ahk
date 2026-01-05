#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <WinEvent>

/**
 * Window Event Monitoring with WinEvent
 * 
 * Demonstrates monitoring window events using the WinEvent library
 * including creation, closing, activation, minimizing, and more.
 * 
 * Source: nperovic-AHK-v2-Libraries/Lib/WinEvent.ahk
 * Inspired by: https://github.com/nperovic/AHK-v2-Libraries
 */


; GUI for displaying events
global eventLog := Gui()
eventLog.Title := "Window Event Monitor"
eventLog.Add("Text", "w600", "Monitoring window events. Try opening/closing windows!")
global logCtrl := eventLog.Add("Edit", "w600 h400 ReadOnly vLog")
global logText := ""

; Status bar
global statusCtrl := eventLog.Add("Text", "w600", "Ready - Monitoring...")

eventLog.Show()

MsgBox("Window Event Monitor`n`n"
    . "This script will monitor window events:`n"
    . "- Window created`n"
    . "- Window closed`n"
    . "- Window activated`n"
    . "- Window minimized/maximized`n`n"
    . "Try opening Notepad to see events!", , "T5")

; Run Notepad as demo
Run("notepad.exe")

; ===============================================
; WINDOW CREATE EVENT
; ===============================================

/**
 * Monitor when new windows are created
 */
WinEvent.Create(WindowCreated, , 5)  ; Monitor last 5 events

WindowCreated(event, hWnd, time) {
    global logText, logCtrl, statusCtrl

    try {
        title := WinGetTitle("ahk_id " hWnd)
        processName := WinGetProcessName("ahk_id " hWnd)
        class := WinGetClass("ahk_id " hWnd)

        ; Skip certain system windows
        if (title == "" || InStr(class, "Shell_TrayWnd"))
            return

        msg := FormatTime(time, "HH:mm:ss")
            . " | CREATED | " processName
            . " | " title "`n"

        LogEvent(msg)
        statusCtrl.Value := "Window created: " title
    }
}

; ===============================================
; WINDOW CLOSE EVENT
; ===============================================

/**
 * Monitor when windows are closed
 */
WinEvent.Close(WindowClosed)

WindowClosed(event, hWnd, time) {
    global statusCtrl

    msg := FormatTime(time, "HH:mm:ss")
        . " | CLOSED | Window closed (hwnd: " hWnd ")`n"

    LogEvent(msg)
    statusCtrl.Value := "Window closed"
}

; ===============================================
; WINDOW ACTIVATION EVENT
; ===============================================

/**
 * Monitor when windows are activated (focused)
 */
WinEvent.Active(WindowActivated)

WindowActivated(event, hWnd, time) {
    global statusCtrl

    try {
        title := WinGetTitle("ahk_id " hWnd)
        processName := WinGetProcessName("ahk_id " hWnd)

        if (title == "" || processName == "explorer.exe")
            return

        msg := FormatTime(time, "HH:mm:ss")
            . " | ACTIVE | " processName
            . " | " title "`n"

        LogEvent(msg)
        statusCtrl.Value := "Activated: " title
    }
}

; ===============================================
; WINDOW MINIMIZE EVENT
; ===============================================

/**
 * Monitor when windows are minimized
 */
WinEvent.Minimize(WindowMinimized)

WindowMinimized(event, hWnd, time) {
    global statusCtrl

    try {
        title := WinGetTitle("ahk_id " hWnd)

        msg := FormatTime(time, "HH:mm:ss")
            . " | MINIMIZE | " title "`n"

        LogEvent(msg)
        statusCtrl.Value := "Minimized: " title
    }
}

; ===============================================
; WINDOW MAXIMIZE EVENT
; ===============================================

/**
 * Monitor when windows are maximized
 */
WinEvent.Maximize(WindowMaximized)

WindowMaximized(event, hWnd, time) {
    global statusCtrl

    try {
        title := WinGetTitle("ahk_id " hWnd)

        msg := FormatTime(time, "HH:mm:ss")
            . " | MAXIMIZE | " title "`n"

        LogEvent(msg)
        statusCtrl.Value := "Maximized: " title
    }
}

; ===============================================
; WINDOW MOVE/RESIZE EVENT
; ===============================================

/**
 * Monitor when windows are moved or resized
 */
WinEvent.Move(WindowMoved, "ahk_exe notepad.exe")  ; Only Notepad

WindowMoved(event, hWnd, time) {
    global statusCtrl

    try {
        title := WinGetTitle("ahk_id " hWnd)
        WinGetPos(&x, &y, &w, &h, "ahk_id " hWnd)

        msg := FormatTime(time, "HH:mm:ss")
            . " | MOVE/RESIZE | " title
            . " | Pos: " x "," y " Size: " w "x" h "`n"

        LogEvent(msg)
        statusCtrl.Value := "Moved/Resized: " title
    }
}

; ===============================================
; HELPER FUNCTIONS
; ===============================================

/**
 * Add event to log
 */
LogEvent(msg) {
    global logText, logCtrl

    ; Keep last 50 entries
    lines := StrSplit(logText, "`n")
    if (lines.Length > 50) {
        lines.RemoveAt(1)
        logText := ""
        for line in lines
            logText .= line "`n"
    }

    logText .= msg
    logCtrl.Value := logText

    ; Scroll to bottom
    SendMessage(0x0115, 7, 0, logCtrl.Hwnd)  ; WM_VSCROLL, SB_BOTTOM
}

; Clean up on exit
OnExit((*) => WinEvent.Stop())

/*
* Key Concepts:
*
* 1. WinEvent Library:
*    SetWinEventHook wrapper
*    Event-driven architecture
*    Automatic cleanup
*
* 2. Event Types:
*    Create - New window created
*    Close - Window destroyed
*    Active - Window activated/focused
*    Minimize - Window minimized
*    Maximize - Window maximized
*    Move - Window moved or resized
*    Show - Window shown
*    Hide - Window hidden
*
* 3. Callback Signature:
*    Callback(event, hWnd, time)
*    event - Event type code
*    hWnd - Window handle
*    time - Event timestamp
*
* 4. Filtering:
*    WinEvent.Create(callback, winTitle, count)
*    winTitle - Filter by window title/class
*    count - Max events to monitor
*    Empty winTitle = all windows
*
* 5. Window Information:
*    WinGetTitle() - Get window title
*    WinGetProcessName() - Get process name
*    WinGetClass() - Get window class
*    WinGetPos() - Get position/size
*
* 6. Use Cases:
*    ✅ Window management automation
*    ✅ Application monitoring
*    ✅ Logging window activity
*    ✅ Auto-arrange windows
*    ✅ Workspace management
*    ✅ Security monitoring
*
* 7. Event Filtering:
*    Filter by process name
*    Filter by window class
*    Filter by title pattern
*    Limit event count
*
* 8. Performance:
*    Efficient hook mechanism
*    Minimal CPU usage
*    Automatic cleanup
*    No polling required
*
* 9. Best Practices:
*    ✅ Filter unnecessary events
*    ✅ Validate window handles
*    ✅ Use try/catch for safety
*    ✅ Clean up with WinEvent.Stop()
*
* 10. Error Handling:
*     Windows can close during callback
*     Handle invalid handles
*     Validate data before use
*
* 11. Multiple Monitors:
*     Combine multiple event types
*     Different callbacks per type
*     Share data via global variables
*
* 12. Advanced Usage:
*     - Window layout restoration
*     - Application auto-start
*     - Window rules engine
*     - Activity tracking
*     - Productivity monitoring
*     - Game overlay triggers
*
* 13. Related Functions:
*     WinEvent.Stop() - Stop all monitoring
*     WinEvent.StopCreate() - Stop specific
*     Event codes (see documentation)
*
* 14. Comparison:
*     vs Polling: More efficient
*     vs ShellHook: More events
*     vs WM_ACTIVATE: System-wide
*/

