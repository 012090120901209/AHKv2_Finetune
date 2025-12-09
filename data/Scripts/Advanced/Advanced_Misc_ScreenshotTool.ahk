#Requires AutoHotkey v2.0 AutoHotkey v2.0
#SingleInstance Force
; Screenshot Tool with Region Selection
^+s::TakeScreenshot()

TakeScreenshot() {
    timestamp := FormatTime(, "yyyyMMdd_HHmmss")
    filename := "screenshot_" timestamp ".png"

    result := MsgBox("
    (
    Screenshot Options:

    Yes = Full Screen
    No = Active Window
    Cancel = Cancel
    )", "Screenshot", "YesNoCancel")

    Switch result {
        case "Yes":
        ; Full screen
        try {
            Run(
            'powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms; [System.Windows.Forms.SendKeys]::SendWait(' '%{PRTSC}' ')"', ,
            "Hide")
            Sleep(500)
            if ClipWait(2) {
                savedClip := ClipboardAll()
                Run("mspaint.exe")
                WinWait("ahk_exe mspaint.exe", , 3)
                Send("^v")
                Send("^s")
            }
        }
        case "No":
        ; Active window
        WinGetPos(&x, &y, &w, &h, "A")
        MsgBox("Window screenshot at: " x ", " y " size: " w "x" h)
    }
}
