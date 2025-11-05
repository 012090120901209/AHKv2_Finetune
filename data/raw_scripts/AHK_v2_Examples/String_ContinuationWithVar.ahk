#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_ContinuationWithVar.ah2 user := "defaultuser0"
script := ( "document.querySelector('#userId').value = '" user "'"
)
MsgBox(script)
