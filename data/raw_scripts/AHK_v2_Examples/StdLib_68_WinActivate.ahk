#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinActivate() - Activate window
 *
 * Brings a window to the foreground.
 */

if WinExist("ahk_class Notepad")
    WinActivate()
else
    MsgBox("Notepad not found. Please open Notepad first.")
