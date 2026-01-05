#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: External Libraries/ComObjMissing_ex1.ah2
; Modified from https://github.com/PayloadSecurity/VxCommunity/blob/master/poc/sandbox_bypass_wmi/notepad.ahk strCommand := "notepad.exe"
objWMIService := ComObjGet("winmgmts:{impersonationLevel = impersonate} ! \\" . A_ComputerName . "\root\cimv2")
objProcess := objWMIService.Get("Win32_Process")
; Removed Null := ComObjMissing()
processID := Buffer(4, 0) ; if 'processID' is a UTF-16 string, use 'VarSetStrCapacity(&processID, 4)' and replace all instances of 'processID.Ptr' with 'StrPtr(processID)'
processIDRef := ComValue(0x4 | 0x4000, processID.Ptr)
errReturn := objProcess.Create(strCommand, , , processIDRef) ; Removed ComObjMissing() ; Removed ComObjMissing() variable Null
MsgBox(errReturn . "`n" . NumGet(processID, "UPtr"))
