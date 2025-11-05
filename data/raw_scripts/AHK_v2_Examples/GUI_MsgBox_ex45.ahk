#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow var := 3.1415
if ! (var >= 0.0 && var <= 1.0) MsgBox(var " not between 0.0 and 1.0")
else if ! (var >= 1 && var <= 4) MsgBox(var " not between 1 and 4")
