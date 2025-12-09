#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow var := 3.1415
if isFloat(var) MsgBox(var " is float")
else if isInteger(var) MsgBox(var " is int")
