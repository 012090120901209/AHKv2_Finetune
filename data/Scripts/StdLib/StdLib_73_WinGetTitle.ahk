#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinGetTitle() - Get window title
 * 
 * Returns the title text of a window.
 */

title := WinGetTitle("A")  ; Active window
MsgBox("Active window title: " title)
