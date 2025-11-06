#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Clipboard operations
 *
 * Access and manipulate the system clipboard.
 */

; Save current clipboard
oldClip := ClipboardAll()

; Set text
A_Clipboard := "Hello from AHK!"
MsgBox("Clipboard set to: " A_Clipboard)

; Restore clipboard
A_Clipboard := oldClip
MsgBox("Clipboard restored")
