#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/SetCapsLockState_examples.ah2 SetNumLockState("On")
SetScrollLockState("AlwaysOff")
SetCapsLockState( ! GetKeyState("CapsLock", "T"))
