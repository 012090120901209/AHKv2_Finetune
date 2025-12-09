#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/ListOfKeys_ex1.ah2
; Requires AutoHotkey v1.1.26+, and the keyboard hook must be installed.
InstallKeybdHook()
SendSuppressedKeyUp(key) { DllCall("keybd_event" , "char", GetKeyVK(key) , "char", GetKeySC(key) , "uint", KEYEVENTF_KEYUP := 0x2 , "uptr", KEY_BLOCK_THIS := 0xFFC3D450)
} ; Disable Alt+key shortcuts for the IME.
~LAlt:: SendSuppressedKeyUp("LAlt") ; Test hotkey: ! CapsLock:: MsgBox(A_ThisHotkey) ; Remap CapsLock to LCtrl in a way compatible with IME.
*CapsLock::
{
    ; Added opening brace for [*CapsLock]
    global ; Made function global Send("{Blind}{LCtrl DownR}") SendSuppressedKeyUp("LCtrl")
} ; Added closing brace for [*CapsLock]
*CapsLock up::
{
    ; Added opening brace for [*CapsLock up]
    global ; Made function global Send("{Blind}{LCtrl Up}")
} ; Added closing brace for [*CapsLock up]
