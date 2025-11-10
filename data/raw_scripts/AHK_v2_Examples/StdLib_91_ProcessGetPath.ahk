#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ProcessGetPath() - Get process path
 *
 * Returns the full path to a process executable.
 */

pid := ProcessExist("explorer.exe")
if (pid) {
    path := ProcessGetPath(pid)
    MsgBox("Explorer path: " path)
}
