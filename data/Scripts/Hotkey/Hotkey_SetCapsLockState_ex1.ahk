#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Mouse and Keyboard/SetCapsLockState_ex1.ah2

SetCapsLockState(!GetKeyState("CapsLock", "T"))
