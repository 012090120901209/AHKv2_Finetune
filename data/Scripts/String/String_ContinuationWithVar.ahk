#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_ContinuationWithVar.ah2

user := "defaultuser0"
script := ( "document.querySelector('#userId').value = '" user "'"
)
MsgBox(script)
