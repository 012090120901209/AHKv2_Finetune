#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - Global Variables
 * Change hotkey behavior by toggling modes/states
 */

global editMode := false
global debugMode := false
global userLevel := 1

; F1 to toggle edit mode
F1:: {
    global editMode := !editMode
    MsgBox("Edit Mode: " (editMode ? "ON" : "OFF"))
}

; F2 to toggle debug mode
F2:: {
    global debugMode := !debugMode
    MsgBox("Debug Mode: " (debugMode ? "ON" : "OFF"))
}

; F3 to cycle user levels
F3:: {
    global userLevel
    userLevel := Mod(userLevel, 3) + 1
    MsgBox("User Level: " userLevel)
}

; Different behavior in edit mode
#HotIf editMode

e:: MsgBox("E in EDIT mode")
d:: Send("{Delete}")
#HotIf

; Debug-only hotkeys
#HotIf debugMode

F10:: MsgBox("Debug: Breakpoint")
F11:: MsgBox("Debug: Step Over")
#HotIf

; User level restricted hotkeys
#HotIf userLevel >= 2

^!d:: MsgBox("Admin command (Level 2+)")
#HotIf

#HotIf userLevel = 3

^!x:: MsgBox("Super admin command (Level 3 only)")
#HotIf

#HotIf  ; Reset

