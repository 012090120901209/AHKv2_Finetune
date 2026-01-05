#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Function Keys (F1-F24)
 * Many keyboards support F1 through F12, some up to F24
 */

F3:: MsgBox("F3 - Search")
F5:: MsgBox("F5 - Refresh")
F11:: MsgBox("F11 - Fullscreen Toggle")
F12:: MsgBox("F12 - Developer Tools")

; Higher function keys if your keyboard supports them
F13:: MsgBox("F13 pressed - Extended function key")
