#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/if_issue25.ah2 var := 3
if (var = 3) if (var > 1) if (var < 5) MsgBox(var)
