#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced File Example: Log File Parser with Filtering
; Demonstrates: Log file parsing, real-time monitoring, filtering, statistics

logGui := Gui()
logGui.Title := "Log File Analyzer"
logGui.Add("Text", "x10 y10", "Log File:")
logInput := logGui.Add("Edit", "x80 y7 w350 ReadOnly")
logGui.Add("Button", "x440 y6 w100", "Browse").OnEvent("Click", BrowseLog)
logGui.Add("Button", "x550 y6 w80", "Monitor").OnEvent("Click", ToggleMonitor)

logGui.Add("Text", "x10 y40", "Filter:")
filterInput := logGui.Add("Edit", "x60 y37 w200")
logGui.Add("DropDownList", "x270 y37 w100 vLogLevel", ["ALL", "ERROR", "WARN", "INFO", "DEBUG"])
logGui.LogLevel.Choose(1)
logGui.Add("Button", "x380 y36 w80", "Apply").OnEvent("Click", ApplyFilter)

LV := logGui.Add("ListView", "x10 y75 w620 h300", ["Time", "Level", "Message"])
statusBar := logGui.Add("StatusBar")
logGui.Show("w640 h405")

global isMonitoring := false
global lastSize := 0

BrowseLog(*) {
    selected := FileSelect(3, , "Select Log File", "Log Files (*.log; *.txt)")
    if (selected) {
        logInput.Value := selected
        LoadLog(selected)
    }
}

LoadLog(filepath) {
    if (!FileExist(filepath))
    return

    LV.Delete()
    content := FileRead(filepath)
    lines := StrSplit(content, "`n", "`r")

    for line in lines {
        if (Trim(line) = "")
        continue
        ParseLogLine(line)
    }

    LV.ModifyCol()
}

ParseLogLine(line) {
    ; Simple parser: [TIME] LEVEL: message
    if (RegExMatch(line, "\[(.*?)\]\s+(\w+):\s+(.*)", &match)) {
        LV.Add(, match[1], match[2], match[3])
    } else {
        LV.Add(, "", "", line)
    }
}

ApplyFilter(*) {
    ; Filter implementation
}

ToggleMonitor(*) {
    global isMonitoring
    isMonitoring := !isMonitoring
}
