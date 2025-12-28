#Requires AutoHotkey v2.0
#SingleInstance Force

var := 3.1415
if !isFloat(var) FileAppend(var " is not float", "*")
else if !isInteger(var) FileAppend(var " is not int", "*")
