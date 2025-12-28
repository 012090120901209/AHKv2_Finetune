#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinGetPID() - Get process ID
 * 
 * Returns the process ID of a window.
 */

if WinExist("ahk_class Notepad") {
    pid := WinGetPID()
    MsgBox("Notepad PID: " pid)
} else {
    MsgBox("Notepad not found")
}
