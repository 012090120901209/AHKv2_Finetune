#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/KeyWait_ex5.ah2 ~CapsLock::
{ ; Added opening brace for [~CapsLock]
global ; Made function global
KeyWait("CapsLock") ; Wait for user to physically release it.
MsgBox("You pressed and released the CapsLock key.")
} ; Added closing brace for [~CapsLock]
