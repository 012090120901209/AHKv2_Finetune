#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * FileSelect() - File picker dialog
 *
 * Displays a standard dialog for selecting file(s).
 */

selectedFile := FileSelect(3, , "Select a file", "Text Files (*.txt)")

if selectedFile
    MsgBox("You selected: " selectedFile)
else
    MsgBox("No file selected")
