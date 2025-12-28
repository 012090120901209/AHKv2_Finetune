#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Win Modifier (#)
 * # represents the Windows key
 */

; Win+E is already used by Windows, so let's use Win+D for demo
; Win+N for a custom notepad launcher
#n:: {

    Run("notepad.exe")
    MsgBox("Win+N pressed - Launched Notepad", , "T1")
}
