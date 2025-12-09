#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Flow of Control/if_issue87_ex3.ah2

var := "a" if (var = "a") { try MsgBox("Yes")
}
else
MsgBox("No")
