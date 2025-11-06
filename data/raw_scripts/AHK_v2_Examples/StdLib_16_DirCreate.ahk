#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DirCreate() - Create directory
 *
 * Creates a folder.
 */

newDir := A_ScriptDir "\newfolder"

if DirExist(newDir)
    DirDelete(newDir)

DirCreate(newDir)
MsgBox("Directory created: " newDir)

DirDelete(newDir)
