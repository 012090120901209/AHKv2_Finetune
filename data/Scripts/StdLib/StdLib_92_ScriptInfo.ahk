#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * A_ScriptDir and A_ScriptName - Script info
 * 
 * Built-in variables with script location information.
 */

MsgBox("Script directory: " A_ScriptDir
    . "`nScript name: " A_ScriptName
    . "`nScript full path: " A_ScriptFullPath
    . "`nWorking directory: " A_WorkingDir)
