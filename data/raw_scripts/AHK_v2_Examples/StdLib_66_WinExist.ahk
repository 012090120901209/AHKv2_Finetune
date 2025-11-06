#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinExist() - Check if window exists
 *
 * Returns window ID if found, 0 otherwise.
 */

exists := WinExist("ahk_class Notepad")

MsgBox(exists ? "Notepad window found (ID: " exists ")" : "Notepad not found")
