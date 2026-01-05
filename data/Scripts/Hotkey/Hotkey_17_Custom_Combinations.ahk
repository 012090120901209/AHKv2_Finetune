#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Custom Key Combinations (& operator)
 * Create custom modifier keys - any key can modify another
 */

; Use 'a' as a modifier for other keys
; Press and hold 'a', then press 'b'
a & b:: MsgBox("You pressed A+B`n`nCustom combination!")

; CapsLock as a custom modifier
CapsLock & j:: Send("{Down}")
CapsLock & k:: Send("{Up}")
CapsLock & h:: Send("{Left}")
CapsLock & l:: Send("{Right}")

; Space as a modifier (Vim-like navigation)
Space & w:: Send("^{Right}")  ; Next word
Space & b:: Send("^{Left}")   ; Previous word

