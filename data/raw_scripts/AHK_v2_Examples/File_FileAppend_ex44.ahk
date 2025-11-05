#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := 3.1415

var := 5
VarLow := 3
VarHigh := 10

varLow := 2
varHigh := 4
if (var >= VarLow && var <= VarHigh) FileAppend(var " between " VarLow " and " VarHigh, "*")
