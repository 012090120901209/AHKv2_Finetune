#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: #Usage_and_Syntax/A_AhkVersion.ah2

MsgBox(Format("You are using AutoHotkey v{1} {2}-bit.", A_AhkVersion, A_PtrSize * 8))
if (VerCompare(A_AhkVersion, "1.0.25.07") >= 0) MsgBox(A_AhkVersion)
