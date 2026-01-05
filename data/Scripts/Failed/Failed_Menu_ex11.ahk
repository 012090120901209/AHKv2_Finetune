#Requires AutoHotkey v2.0
#SingleInstance Force

; Source: Failed_Conversions_Menu_ex11.ah2

; Note: This is a failed conversion example - tray menu setup

Tray := A_TrayMenu
Tray.Delete()
Tray.Add("&Show", Show)
Tray.Add()
Tray.Add("&About...", About)
Tray.Add("E&xit", Exit)

A_IconTip := "Application"
Tray.Default := "&Show"
