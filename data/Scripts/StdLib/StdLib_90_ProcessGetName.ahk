#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* ProcessGetName() - Get process name from PID
*
* Returns the executable name of a process.
*/

pid := ProcessExist("explorer.exe")
if (pid) {
    name := ProcessGetName(pid)
    MsgBox("PID " pid " = " name)
}
