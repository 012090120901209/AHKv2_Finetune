#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: String_Quotes_Issue_253.ah2 var2 := "failing"
var := "MyTest = `"" var2 "`""
var3 := "MyTest = `"" var2 "`" > " MsgBox(var)
MsgBox(var3)
