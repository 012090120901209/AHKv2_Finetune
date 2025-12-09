#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_ObjRaw_ex1.ah2

MyObj := {Key: "Hello World"} MyObj.Key := "Value" MyValue := MyObj.Key MsgBox(MyValue)
