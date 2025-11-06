#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ProcessClose() - Close process
 *
 * Terminates a process by PID or name.
 */

Run("notepad.exe")
WinWait("ahk_class Notepad", , 2)

pid := WinGetPID("ahk_class Notepad")
MsgBox("Closing Notepad (PID: " pid ")")

ProcessClose(pid)
MsgBox("Process closed")
