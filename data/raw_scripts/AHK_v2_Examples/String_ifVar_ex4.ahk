#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_ifVar_ex4.ah2 var := "exe"
MyItemList := "bat, exe, com" if (var ~ = "^(?i:" RegExReplace(RegExReplace(MyItemList, "[\\\.\*\?\+\[\{\|\(\)\^\$]", "\$0"), "\h*, \h*", "|") ")$") MsgBox(var " is in the list.")
