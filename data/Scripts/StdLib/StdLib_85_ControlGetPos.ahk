#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ControlGetPos() - Get control position
 * 
 * Retrieves control coordinates and size.
 */

if WinExist("ahk_class Notepad") {
    ControlGetPos(&x, &y, &w, &h, "Edit1")
    MsgBox("Notepad Edit control:`nX: " x "`nY: " y "`nWidth: " w "`nHeight: " h)
} else {
    MsgBox("Notepad not found. Open Notepad first.")
}
