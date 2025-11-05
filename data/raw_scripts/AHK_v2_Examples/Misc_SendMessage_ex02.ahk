#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow SendMessage, % WM_SETTINGCHANGE := 0x001A, 0, Environment, , % "ahk_id " . HWND_BROADCAST := "0xFFFF"
