#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinGetPos() - Get window position
 *
 * Retrieves window coordinates and dimensions.
 */

if WinExist("ahk_class Notepad") {
    WinGetPos(&x, &y, &w, &h)
    MsgBox("Notepad position:`nX: " x "`nY: " y "`nWidth: " w "`nHeight: " h)
} else {
    MsgBox("Notepad not found")
}
