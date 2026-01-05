#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Wildcard Modifier (*)
 * Fires the hotkey even if extra modifiers are held down
 */

; This fires whether you press just 'a' or Ctrl+A or Shift+A, etc.
*a:: {
    modifiers := ""
    if GetKeyState("Ctrl")
        modifiers .= "Ctrl+"
    if GetKeyState("Shift")
        modifiers .= "Shift+"
    if GetKeyState("Alt")
        modifiers .= "Alt+"

    MsgBox("You pressed: " modifiers "A`n`nWildcard (*) captures all combinations")
}
