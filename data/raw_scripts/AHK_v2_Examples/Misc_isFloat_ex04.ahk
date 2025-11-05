#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow var := 3.1415
if ! isFloat(var) MsgBox(var " is not float")
else if ! isInteger(var) MsgBox(var " is not int")
