#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Multiple Modifiers Combined
 * Combine Ctrl, Alt, Shift, Win in any combination
 */

; Ctrl+Alt+Delete equivalent (custom action)
^!d:: MsgBox("Ctrl+Alt+D pressed`n`nMultiple modifiers work together")

; Ctrl+Shift+Esc for custom task manager
^+Esc:: MsgBox("Ctrl+Shift+Esc`n`nCould launch custom task manager")

; Win+Ctrl+Arrow for custom window management
#^Left:: MsgBox("Win+Ctrl+Left`n`nCustom window snap left")
