#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Window Close Operations
 *
 * Demonstrates different ways to close windows: gentle close,
 * force close, and terminate process - with increasing urgency.
 *
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Window Close Operations Demo`n`n"
     . "Three close methods:`n"
     . "1. Alt+RightClick - Gentle close (WM_CLOSE)`n"
     . "2. Ctrl+Alt+F4 - Force close window`n"
     . "3. Ctrl+Alt+Shift+F4 - Terminate process`n`n"
     . "We'll open Notepad to demonstrate.", , "T5")

; Open Notepad for demo
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")

MsgBox("Try Alt+RightClick on the window to close it gently.", , "T3")

; Gentle close - right-click with Alt
!RButton::GentleClose()

; Force close window
^!F4::ForceCloseWindow()

; Terminate entire process
^!+F4::TerminateProcess()

/**
 * Gentle close - Send WM_CLOSE message
 */
GentleClose() {
    ; Get window under mouse
    MouseGetPos(, , &hwnd)
    if (!hwnd)
        return

    title := WinGetTitle("ahk_id " hwnd)

    ; Send WM_CLOSE (allows save prompts)
    PostMessage(0x10, 0, 0, , "ahk_id " hwnd)  ; 0x10 = WM_CLOSE

    ToolTip("Gentle close sent to:`n" title)
    SetTimer(() => ToolTip(), -2000)
}

/**
 * Force close - Immediate window closure
 */
ForceCloseWindow() {
    hwnd := WinExist("A")
    if (!hwnd)
        return

    title := WinGetTitle("ahk_id " hwnd)

    result := MsgBox("Force close window?`n`n" title, "Confirm", "YesNo Icon!")
    if (result == "No")
        return

    ; Close window forcefully
    WinClose("ahk_id " hwnd)

    ToolTip("Force closed:`n" title)
    SetTimer(() => ToolTip(), -2000)
}

/**
 * Terminate process - Kill entire application
 */
TerminateProcess() {
    hwnd := WinExist("A")
    if (!hwnd)
        return

    title := WinGetTitle("ahk_id " hwnd)
    processName := WinGetProcessName("ahk_id " hwnd)
    pid := WinGetPID("ahk_id " hwnd)

    result := MsgBox("TERMINATE PROCESS?`n`n"
                   . "Window: " title "`n"
                   . "Process: " processName "`n"
                   . "PID: " pid "`n`n"
                   . "⚠ This will kill the entire application!`n"
                   . "⚠ Unsaved work will be lost!",
                   "Warning", "YesNo Icon! Default2")

    if (result == "No")
        return

    ; Kill process
    ProcessClose(pid)

    ToolTip("Process terminated: " processName)
    SetTimer(() => ToolTip(), -2000)
}

/*
 * Key Concepts:
 *
 * 1. Close Methods:
 *    WM_CLOSE - Polite request (save prompts)
 *    WinClose - Force close window
 *    ProcessClose - Kill process
 *
 * 2. WM_CLOSE Message:
 *    PostMessage(0x10) - Send close message
 *    Allows app to handle closure
 *    Save prompts appear
 *    Can be cancelled by app
 *
 * 3. WinClose vs ProcessClose:
 *    WinClose - Close specific window
 *    ProcessClose - Kill entire process
 *    Multi-window apps differ
 *
 * 4. Safety Considerations:
 *    Gentle → Force → Kill
 *    Increasing urgency
 *    Confirm before killing
 *
 * 5. Use Cases:
 *    Gentle: Normal closing
 *    Force: Frozen dialogs
 *    Kill: Completely hung apps
 *
 * 6. Window Messages:
 *    0x10 = WM_CLOSE
 *    0x12 = WM_QUIT
 *    0x16 = WM_ENDSESSION
 *    PostMessage vs SendMessage
 *
 * 7. Mouse-Based Close:
 *    MouseGetPos(, , &hwnd) - Get window under cursor
 *    Alt+RightClick pattern
 *    Close any window
 *
 * 8. Process Information:
 *    WinGetProcessName() - Executable name
 *    WinGetPID() - Process ID
 *    Useful for logging
 *
 * 9. Best Practices:
 *    ✅ Always confirm kills
 *    ✅ Show what you're closing
 *    ✅ Try gentle first
 *    ✅ Warn about data loss
 *
 * 10. Related Functions:
 *     WinKill() - Force close (wrapper)
 *     ProcessWait() - Wait for start
 *     ProcessWaitClose() - Wait for exit
 *
 * 11. Error Handling:
 *     try/catch for ProcessClose
 *     Check if window exists
 *     Verify process ID
 *
 * 12. Advanced Techniques:
 *     - Close all windows of process
 *     - Close windows by class
 *     - Timer-based forced close
 *     - Log closed windows
 *     - Blacklist protection
 */
