#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Basic AHK v2 example demonstrating variable assignment and control flow var := 3.1415
varLow := 2
varHigh := 4
if (var >= VarLow && var <= VarHigh) MsgBox(var " between " VarLow " and " VarHigh)
