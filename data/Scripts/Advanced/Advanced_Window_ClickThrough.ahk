#Requires AutoHotkey v2.0
#SingleInstance Force
; Click-through transparent overlay window
^!t:: ToggleClickThrough()

ToggleClickThrough() {
    static overlay := ""

    if (overlay = "") {
        overlay := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x20")
        overlay.BackColor := "00FF00"
        overlay.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight)
        WinSetTransparent(128, overlay.Hwnd)
        WinSetExStyle("+0x80000 +0x20", overlay.Hwnd)  ; WS_EX_LAYERED + WS_EX_TRANSPARENT
        TrayTip("Click-through overlay ON", "Press Ctrl+Alt+T to toggle")
    } else {
        overlay.Destroy()
        overlay := ""
        TrayTip("Click-through overlay OFF")
    }
}
