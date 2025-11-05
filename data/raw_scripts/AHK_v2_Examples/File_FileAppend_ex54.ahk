#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; var := 3.1415
mytype := "float"
if is%Mytype%(var) FileAppend(var " is float", "*")
