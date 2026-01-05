#Requires AutoHotkey v2.0
#SingleInstance Force

; Source: Failed_Conversions_Menu_ex10.ah2

; Note: This is a failed conversion example - menu callback handling

Tray := A_TrayMenu
Tray.Add("Test", Test)

Test(A_ThisMenuItem := "", A_ThisMenuItemPos := "", A_ThisMenu := "") {
    Tray.Add("Test", Test)
}
