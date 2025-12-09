#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/ComObjError_ex1.ah2

Enabled := ("true string" ? true : false) ; Wrap Com functions in try
MsgBox(Enabled)
ComObject("invalid clsid")
