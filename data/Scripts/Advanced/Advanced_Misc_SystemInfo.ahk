#Requires AutoHotkey v2.0
#SingleInstance Force
; System Information Display
infoGui := Gui()
infoGui.Title := "System Information"

info := "SYSTEM INFORMATION`n"
info .= "==================`n`n"

info .= "Computer Name: " A_ComputerName "`n"
info .= "User Name: " A_UserName "`n"
info .= "OS Version: " A_OSVersion "`n"
info .= "AHK Version: " A_AhkVersion "`n`n"

info .= "SCREEN`n"
info .= "------`n"
info .= "Resolution: " A_ScreenWidth " x " A_ScreenHeight "`n"
info .= "DPI: " A_ScreenDPI "`n"
info .= "Monitors: " MonitorGetCount() "`n`n"

info .= "PATHS`n"
info .= "-----`n"
info .= "Working Dir: " A_WorkingDir "`n"
info .= "Temp: " A_Temp "`n"
info .= "Program Files: " A_ProgramFiles "`n`n"

info .= "MEMORY`n"
info .= "------`n"
for proc in ComObjGet("winmgmts:").ExecQuery("SELECT * FROM Win32_OperatingSystem") {
    totalMem := Round(proc.TotalVisibleMemorySize / 1024)
    freeMem := Round(proc.FreePhysicalMemory / 1024)
    info .= "Total RAM: " totalMem " MB`n"
    info .= "Free RAM: " freeMem " MB`n"
}

infoGui.Add("Edit", "x10 y10 w500 h400 ReadOnly Multi", info)
infoGui.Add("Button", "x10 y420 w150", "Copy to Clipboard").OnEvent("Click", (*) => (A_Clipboard := info, MsgBox("Copied!", "Info")))
infoGui.Show("w520 h460")
