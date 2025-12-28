#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * DirSelect() - Folder picker dialog
 * 
 * Displays a standard dialog for selecting a folder.
 */

selectedDir := DirSelect(, 0, "Select a folder")

if selectedDir
    MsgBox("You selected: " selectedDir)
else
    MsgBox("No folder selected")
