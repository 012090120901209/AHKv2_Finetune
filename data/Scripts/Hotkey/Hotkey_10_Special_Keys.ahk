#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Special Keys - Navigation and Editing
* Home, End, PgUp, PgDn, Insert, Delete, etc.
*/

; Ctrl+Home to go to start of document
^Home::MsgBox("Ctrl+Home - Go to start")

; Ctrl+End to go to end of document
^End::MsgBox("Ctrl+End - Go to end")

; Pause/Break key
Pause::MsgBox("Pause key pressed")

; PrintScreen
PrintScreen::MsgBox("PrintScreen captured")

; ScrollLock
ScrollLock::MsgBox("ScrollLock toggled")
