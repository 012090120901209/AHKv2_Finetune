#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/SetCapsLockState_examples.ah2

SetNumLockState("On")
SetScrollLockState("AlwaysOff")
SetCapsLockState(!GetKeyState("CapsLock", "T"))
