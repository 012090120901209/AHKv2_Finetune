#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

var := "test"
if (var != "") {
    FileAppend("var is not empty", "*")
} else {
    FileAppend("var is empty", "*")
}

