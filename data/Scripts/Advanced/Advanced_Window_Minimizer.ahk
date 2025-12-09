#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced Window Minimizer to System Tray
Persistent
global hiddenWindows := Map()

; Win+H to hide active window to tray
#h::HideWindow()

; Win+Shift+H to show hidden windows menu
#+h::ShowHiddenMenu()

HideWindow() {
    winId := WinExist("A")
    if (!winId)
    return

    title := WinGetTitle("ahk_id " winId)

    if (title = "")
    return

    WinHide("ahk_id " winId)
    hiddenWindows[winId] := title

    TrayTip("Window Hidden", title, "Iconi")
}

ShowHiddenMenu() {
    if (hiddenWindows.Count = 0)
    return MsgBox("No hidden windows", "Info")

    hideMenu := Menu()

    for id, title in hiddenWindows {
        hideMenu.Add(title, RestoreWindow)
    }

    hideMenu.Show()
}

RestoreWindow(ItemName, ItemPos, MyMenu) {
    for id, title in hiddenWindows {
        if (title = ItemName) {
            WinShow("ahk_id " id)
            WinActivate("ahk_id " id)
            hiddenWindows.Delete(id)
            break
        }
    }
}
