#Requires AutoHotkey v2.0
#SingleInstance Force
; Automated Backup Manager
Persistent
backupGui := Gui()
backupGui.Title := "Automatic Backup Manager"
backupGui.Add("Text", "x10 y10", "Source:")
sourceInput := backupGui.Add("Edit", "x80 y7 w300 ReadOnly")
backupGui.Add("Button", "x390 y6 w80", "Browse").OnEvent("Click", BrowseSrc)

backupGui.Add("Text", "x10 y40", "Backup To:")
destInput := backupGui.Add("Edit", "x80 y37 w300 ReadOnly")
backupGui.Add("Button", "x390 y36 w80", "Browse").OnEvent("Click", BrowseDest)

backupGui.Add("Text", "x10 y70", "Interval (min):")
intervalInput := backupGui.Add("Edit", "x100 y67 w80 Number", "60")

backupGui.Add("Button", "x10 y100 w100", "Start Auto Backup").OnEvent("Click", StartBackup)
backupGui.Add("Button", "x120 y100 w100", "Stop").OnEvent("Click", StopBackup)
backupGui.Add("Button", "x230 y100 w100", "Backup Now").OnEvent("Click", BackupNow)

logDisplay := backupGui.Add("Edit", "x10 y140 w460 h150 ReadOnly Multi")
backupGui.Show("w480 h305")

global isRunning := false

BrowseSrc(*) {
    selected := DirSelect(, 3, "Select source folder")
    if (selected)
        sourceInput.Value := selected
}

BrowseDest(*) {
    selected := DirSelect(, 3, "Select backup destination")
    if (selected)
        destInput.Value := selected
}

StartBackup(*) {
    global isRunning
    interval := Integer(intervalInput.Value) * 60000
    isRunning := true
    SetTimer(BackupNow, interval)
    Log("Automatic backup started (every " intervalInput.Value " minutes)")
}

StopBackup(*) {
    global isRunning
    isRunning := false
    SetTimer(BackupNow, 0)
    Log("Automatic backup stopped")
}

BackupNow(*) {
    src := sourceInput.Value
    dest := destInput.Value

    if (!DirExist(src) || !DirExist(dest))
        return Log("Error: Invalid source or destination")

    timestamp := FormatTime(, "yyyyMMdd_HHmmss")
    backupFolder := dest "\Backup_" timestamp

    try {
        DirCopy(src, backupFolder, true)
        Log("Backup created: " backupFolder)
    } catch Error as err {
        Log("Backup failed: " err.Message)
    }
}

Log(msg) {
    logDisplay.Value .= "[" FormatTime(, "HH:mm:ss") "] " msg "`n"
    ControlSend("^{End}", , "ahk_id " logDisplay.Hwnd)
}
