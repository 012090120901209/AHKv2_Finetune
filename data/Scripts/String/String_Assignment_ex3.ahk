#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Assignment_ex3.ah2

the := "The "
quick := "quick "
fox := "fox "
over := "over "
lazy := "lazy " str := the quick "`"brown`" " fox "`"jumped`" " over "`"the`" " lazy "dog"
MsgBox(str)
