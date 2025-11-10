#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DirExist() - Check if directory exists
 *
 * Returns the folder's attributes if it exists, otherwise returns empty string.
 */

exists1 := DirExist(A_ScriptDir) ? "Yes" : "No"
exists2 := DirExist("C:\NonExistentFolder") ? "Yes" : "No"

MsgBox("Script directory exists: " exists1
    . "`nNonexistent folder exists: " exists2)
