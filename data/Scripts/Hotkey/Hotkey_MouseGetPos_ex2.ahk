#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/MouseGetPos_ex2.ah2

Persistent
SetTimer(WatchCursor, 100)
WatchCursor()
WatchCursor() {
    MouseGetPos(, , &id, &control) title := WinGetTitle("ahk_id " id) class := WinGetClass("ahk_id " id) ToolTip("ahk_id " id "`nahk_class " class "`n" title "`nControl: " control)
}
