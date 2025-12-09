#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* ProcessExist() - Check if process running
*
* Returns PID if process exists, 0 otherwise.
*/

pid := ProcessExist("explorer.exe")
MsgBox(pid ? "Explorer.exe is running (PID: " pid ")" : "Explorer.exe not found")
