#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow var := 3.1415
if (var >= 5 && var <= 10) MsgBox(var " between 5 and 10")
else if (var >= 1 && var <= 4) MsgBox(var " between 1 and 4")
