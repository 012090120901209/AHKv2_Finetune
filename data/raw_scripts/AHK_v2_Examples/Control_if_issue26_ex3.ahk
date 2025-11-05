#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/if_issue26_ex3.ah2 var := 5 if false { MsgBox()
} else if (var = 5) { MsgBox(2)
}
