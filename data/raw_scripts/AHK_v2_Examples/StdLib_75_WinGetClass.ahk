#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinGetClass() - Get window class
 *
 * Returns the window class name.
 */

class := WinGetClass("A")
MsgBox("Active window class: " class)
