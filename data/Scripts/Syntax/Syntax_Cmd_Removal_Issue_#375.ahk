#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: #Usage_and_Syntax/Cmd_Removal_Issue_#375.ah2
; https://github.com/mmikeww/AHK-v2-script-converter/issues/375 ; the following line should have removal
; Removed AutoTrim, On ; NONE of the following should be removed
VarEndingWithAutoTrim := true
VarContainingAutoTrimInTheMiddle := false if (VarEndingWithAutoTrim != "") MsgBox()
