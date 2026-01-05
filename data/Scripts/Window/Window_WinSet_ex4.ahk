#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Window_WinSet_ex4.ah2
#t:: ; Press Win+T to make the color under the mouse cursor invisible.

{
    ; Added opening brace for [#t]
    global ; Made function global
    MouseGetPos(&MouseX, &MouseY, &MouseWin)
    MouseRGB := PixelGetColor(MouseX, MouseY)
    ; It seems necessary to turn off any existing transparency first:
    WinSetTransColor("Off", "ahk_id " MouseWin)
    WinSetTransColor(MouseRGB " 220", "ahk_id " MouseWin)
} ; Added closing brace for [#t] #o:: ; Press Win+O to turn off transparency for the window under the mouse.
{
    ; Added opening brace for [#o]
    global ; Made function global
    MouseGetPos(, , &MouseWin)
    WinSetTransColor("Off", "ahk_id " MouseWin)
} ; Added closing brace for [#o] #g:: ; Press Win+G to show the current settings of the window under the mouse.
{
    ; Added opening brace for [#g]
    global ; Made function global
    MouseGetPos(, , &MouseWin)
    Transparent := WinGetTransparent("ahk_id " MouseWin)
    TransColor := WinGetTransColor("ahk_id " MouseWin)
    ToolTip("Translucency:`t" Transparent "`nTransColor:`t" TransColor)
} ; Added closing brace for [#g]
