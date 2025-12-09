#Requires AutoHotkey v2.0
#SingleInstance Force

outputvar := DirSelect()
outputvar := DirSelect("C:\")
outputvar := DirSelect(, 3)
