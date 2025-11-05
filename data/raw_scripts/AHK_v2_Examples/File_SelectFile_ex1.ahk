#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: File, Directory and Disk/FileSelectFile_ex1.ah2 outputvar := FileSelect()
SelectedFile := FileSelect(3, "", "Open a file", "Text Documents (*.txt; *.doc)")
