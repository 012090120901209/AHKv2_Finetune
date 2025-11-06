#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * AHK v2 Standard Library Examples - Part 4: Windows & System
 *
 * Window management, process control, and system functions
 * Documentation: https://www.autohotkey.com/docs/v2/
 */

; ═══════════════════════════════════════════════════════════════════════════
; WINDOW MANAGEMENT (Examples 1-20)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 1: WinExist() - Check if window exists
 */
WinExistExample() {
    exists := WinExist("ahk_class Notepad")

    MsgBox(exists ? "Notepad window found (ID: " exists ")" : "Notepad not found")
}

/**
 * Example 2: WinActive() - Check if window is active
 */
WinActiveExample() {
    active := WinActive("A")  ; Get active window ID
    title := WinGetTitle("A")

    MsgBox("Active window ID: " active "`nTitle: " title)
}

/**
 * Example 3: WinActivate() - Activate window
 */
WinActivateExample() {
    if WinExist("ahk_class Notepad")
        WinActivate()
    else
        MsgBox("Notepad not found. Please open Notepad first.")
}

/**
 * Example 4: WinClose() - Close window
 */
WinCloseExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    MsgBox("Notepad opened. Click OK to close it.")

    WinClose("ahk_class Notepad")
    MsgBox("Notepad closed")
}

/**
 * Example 5: WinMinimize() and WinMaximize() - Window state
 */
WinStateExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    MsgBox("Notepad opened. Click OK to minimize it.")
    WinMinimize("ahk_class Notepad")
    Sleep(1000)

    MsgBox("Click OK to maximize it.")
    WinMaximize("ahk_class Notepad")
    Sleep(1000)

    WinClose("ahk_class Notepad")
}

/**
 * Example 6: WinMove() - Move and resize window
 */
WinMoveExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    MsgBox("Moving window to (100, 100) with size 600x400")
    WinMove(100, 100, 600, 400, "ahk_class Notepad")
    Sleep(2000)

    WinClose("ahk_class Notepad")
}

/**
 * Example 7: WinGetPos() - Get window position
 */
WinGetPosExample() {
    if WinExist("ahk_class Notepad") {
        WinGetPos(&x, &y, &w, &h)
        MsgBox("Notepad position:`nX: " x "`nY: " y "`nWidth: " w "`nHeight: " h)
    } else {
        MsgBox("Notepad not found")
    }
}

/**
 * Example 8: WinGetTitle() - Get window title
 */
WinGetTitleExample() {
    title := WinGetTitle("A")  ; Active window
    MsgBox("Active window title: " title)
}

/**
 * Example 9: WinSetTitle() - Set window title
 */
WinSetTitleExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    WinSetTitle("My Custom Notepad Title", "ahk_class Notepad")
    MsgBox("Window title changed")
    Sleep(2000)

    WinClose("ahk_class Notepad")
}

/**
 * Example 10: WinGetClass() - Get window class
 */
WinGetClassExample() {
    class := WinGetClass("A")
    MsgBox("Active window class: " class)
}

/**
 * Example 11: WinGetPID() - Get process ID
 */
WinGetPIDExample() {
    if WinExist("ahk_class Notepad") {
        pid := WinGetPID()
        MsgBox("Notepad PID: " pid)
    } else {
        MsgBox("Notepad not found")
    }
}

/**
 * Example 12: WinGetList() - List all windows
 */
WinGetListExample() {
    windows := WinGetList(, , "Program Manager")

    output := "Total windows: " windows.Length "`n`n"
    count := 0

    for id in windows {
        if (count >= 10)
            break

        title := WinGetTitle(id)
        if (title) {
            output .= title "`n"
            count++
        }
    }

    MsgBox(output)
}

/**
 * Example 13: WinWait() - Wait for window
 */
WinWaitExample() {
    MsgBox("Open Notepad within 5 seconds...")

    if WinWait("ahk_class Notepad", , 5)
        MsgBox("Notepad found!")
    else
        MsgBox("Timeout - Notepad not found")
}

/**
 * Example 14: WinHide() and WinShow() - Hide/show window
 */
WinHideShowExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    MsgBox("Click OK to hide Notepad")
    WinHide("ahk_class Notepad")
    Sleep(2000)

    MsgBox("Click OK to show Notepad")
    WinShow("ahk_class Notepad")
    Sleep(2000)

    WinClose("ahk_class Notepad")
}

/**
 * Example 15: WinSetAlwaysOnTop() - Set always on top
 */
WinAlwaysOnTopExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    WinSetAlwaysOnTop(true, "ahk_class Notepad")
    MsgBox("Notepad set to always on top")
    Sleep(2000)

    WinSetAlwaysOnTop(false, "ahk_class Notepad")
    MsgBox("Always on top removed")

    WinClose("ahk_class Notepad")
}

/**
 * Example 16: WinSetTransparent() - Set transparency
 */
WinTransparentExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    WinSetTransparent(150, "ahk_class Notepad")  ; 0-255
    MsgBox("Notepad transparency set to 150")
    Sleep(2000)

    WinSetTransparent("Off", "ahk_class Notepad")
    WinClose("ahk_class Notepad")
}

/**
 * Example 17: ControlSend() - Send text to control
 */
ControlSendExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    ControlSend("Hello from AHK!{Enter}Line 2{Enter}Line 3", "Edit1", "ahk_class Notepad")
    MsgBox("Text sent to Notepad")
    Sleep(2000)

    WinClose("ahk_class Notepad")
    Sleep(500)
    Send("{Tab}{Enter}")  ; Don't save
}

/**
 * Example 18: ControlClick() - Click control
 */
ControlClickExample() {
    MsgBox("This demonstrates ControlClick.`n`nIn practice, you'd click buttons in other windows.")
}

/**
 * Example 19: ControlGetText() - Get control text
 */
ControlGetTextExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    ControlSend("Sample text", "Edit1", "ahk_class Notepad")
    Sleep(500)

    text := ControlGetText("Edit1", "ahk_class Notepad")
    MsgBox("Text in Notepad: '" text "'")

    WinClose("ahk_class Notepad")
    Sleep(500)
    Send("{Tab}{Enter}")
}

/**
 * Example 20: ControlGetPos() - Get control position
 */
ControlGetPosExample() {
    if WinExist("ahk_class Notepad") {
        ControlGetPos(&x, &y, &w, &h, "Edit1")
        MsgBox("Notepad Edit control:`nX: " x "`nY: " y "`nWidth: " w "`nHeight: " h)
    } else {
        MsgBox("Notepad not found. Open Notepad first.")
    }
}

; ═══════════════════════════════════════════════════════════════════════════
; PROCESS & SYSTEM (Examples 21-30)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 21: Run() - Run program
 */
RunExample() {
    Run("notepad.exe")
    MsgBox("Notepad launched")
    Sleep(2000)
    WinClose("ahk_class Notepad")
}

/**
 * Example 22: RunWait() - Run and wait
 */
RunWaitExample() {
    MsgBox("Running cmd to ping localhost...")
    RunWait('cmd.exe /c ping 127.0.0.1 -n 3', , "Hide")
    MsgBox("Ping completed!")
}

/**
 * Example 23: ProcessExist() - Check if process running
 */
ProcessExistExample() {
    pid := ProcessExist("explorer.exe")
    MsgBox(pid ? "Explorer.exe is running (PID: " pid ")" : "Explorer.exe not found")
}

/**
 * Example 24: ProcessClose() - Close process
 */
ProcessCloseExample() {
    Run("notepad.exe")
    WinWait("ahk_class Notepad", , 2)

    pid := WinGetPID("ahk_class Notepad")
    MsgBox("Closing Notepad (PID: " pid ")")

    ProcessClose(pid)
    MsgBox("Process closed")
}

/**
 * Example 25: ProcessGetName() - Get process name from PID
 */
ProcessGetNameExample() {
    pid := ProcessExist("explorer.exe")
    if (pid) {
        name := ProcessGetName(pid)
        MsgBox("PID " pid " = " name)
    }
}

/**
 * Example 26: ProcessGetPath() - Get process path
 */
ProcessGetPathExample() {
    pid := ProcessExist("explorer.exe")
    if (pid) {
        path := ProcessGetPath(pid)
        MsgBox("Explorer path: " path)
    }
}

/**
 * Example 27: A_ScriptDir and A_ScriptName - Script info
 */
ScriptInfoExample() {
    MsgBox("Script directory: " A_ScriptDir
        . "`nScript name: " A_ScriptName
        . "`nScript full path: " A_ScriptFullPath
        . "`nWorking directory: " A_WorkingDir)
}

/**
 * Example 28: A_ComputerName and A_UserName - System info
 */
SystemInfoExample() {
    MsgBox("Computer name: " A_ComputerName
        . "`nUser name: " A_UserName
        . "`nOS Version: " A_OSVersion
        . "`nIs Admin: " A_IsAdmin
        . "`n64-bit OS: " A_Is64bitOS)
}

/**
 * Example 29: A_ScreenWidth and A_ScreenHeight - Screen info
 */
ScreenInfoExample() {
    MsgBox("Screen width: " A_ScreenWidth
        . "`nScreen height: " A_ScreenHeight
        . "`nScreen DPI: " A_ScreenDPI)
}

/**
 * Example 30: Clipboard operations
 */
ClipboardExample() {
    ; Save current clipboard
    oldClip := ClipboardAll()

    ; Set text
    A_Clipboard := "Hello from AHK!"
    MsgBox("Clipboard set to: " A_Clipboard)

    ; Restore clipboard
    A_Clipboard := oldClip
    MsgBox("Clipboard restored")
}

; Menu
MsgBox("AHK v2 Standard Library - Windows & System (Part 4)`n`n"
    . "WINDOW MANAGEMENT (1-20):`n"
    . "1. WinExist   2. WinActive   3. WinActivate   4. WinClose   5. WinMin/Max`n"
    . "6. WinMove   7. WinGetPos   8. WinGetTitle   9. WinSetTitle   10. WinGetClass`n"
    . "11. WinGetPID   12. WinGetList   13. WinWait   14. WinHide/Show   15. AlwaysOnTop`n"
    . "16. Transparent   17. ControlSend   18. ControlClick   19. ControlGetText   20. ControlGetPos`n`n"
    . "PROCESS & SYSTEM (21-30):`n"
    . "21. Run   22. RunWait   23. ProcessExist   24. ProcessClose   25. ProcessGetName`n"
    . "26. ProcessGetPath   27. ScriptInfo   28. SystemInfo   29. ScreenInfo   30. Clipboard`n`n"
    . "Call any example function to run!")

; Uncomment to test:
; WinGetTitleExample()
; SystemInfoExample()
; ScreenInfoExample()
; ClipboardExample()
