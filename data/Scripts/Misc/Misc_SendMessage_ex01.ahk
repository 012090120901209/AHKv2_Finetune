#Requires AutoHotkey v2.0
#SingleInstance Force

WM_SETTINGCHANGE := 0x001A
HWND_BROADCAST := 0xFFFF
SendMessage(WM_SETTINGCHANGE, 0, StrPtr("Environment"), , "ahk_id " . HWND_BROADCAST)
