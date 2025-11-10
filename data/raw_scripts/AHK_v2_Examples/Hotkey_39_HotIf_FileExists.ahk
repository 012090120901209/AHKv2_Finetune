#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - File System
 * Hotkeys based on file/folder existence
 */

; Only works if a specific file exists
#HotIf FileExist(A_ScriptDir "\config.txt")
F7::MsgBox("Config file exists!`n`nF7 loaded config")
#HotIf

; Only if config doesn't exist
#HotIf !FileExist(A_ScriptDir "\config.txt")
F7:: {
    FileAppend("# Config file`nSetting1=Value1", A_ScriptDir "\config.txt")
    MsgBox("Created config.txt")
}
#HotIf

; Different behavior based on file attributes
#HotIf FileExist(A_Desktop "\test.txt")
^!o:: {
    Run(A_Desktop "\test.txt")
    MsgBox("Opened test.txt from Desktop")
}
#HotIf

; Check if a directory exists
#HotIf DirExist(A_MyDocuments "\Projects")
F8::MsgBox("Projects folder exists in Documents")
#HotIf

#HotIf  ; Reset
