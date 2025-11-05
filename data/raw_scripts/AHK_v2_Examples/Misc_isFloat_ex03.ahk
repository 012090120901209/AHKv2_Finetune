#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := 3.1415
if ! isFloat(var) FileAppend(var " is not float", "*")
else if ! isInteger(var) FileAppend(var " is not int", "*")
