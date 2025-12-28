#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Logical operators
 * 
 * Boolean logic operations (AND, OR, NOT).
 */

x := true
y := false

MsgBox("x = " x ", y = " y "`n`n"
    . "x AND y: " (x && y) "`n"
    . "x OR y: " (x || y) "`n"
    . "NOT x: " (!x) "`n"
    . "NOT y: " (!y))
