#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Screen_PixelGetColor_ex1.ah2

MouseGetPos(&MouseX, &MouseY)
color := PixelGetColor(MouseX, MouseY) ; Now returns RGB instead of BGR
MsgBox("The color at the current cursor position is " color ".") color := PixelGetColor(MouseX, MouseY)
MsgBox("The color at the current cursor position is " color ".") color := PixelGetColor(MouseX, MouseY, "Alt ")
MsgBox("The color at the current cursor position is " color ".")
