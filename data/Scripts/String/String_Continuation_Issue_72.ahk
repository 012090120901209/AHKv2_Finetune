#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_Continuation_Issue_72.ah2
; fix for issue #72 (missing linefeeds on continuation section)
None() { ; Removes all events. return this .OnEvent("LeftMouseDown") .OnEvent("MiddleMouseDown") .OnEvent("RightMouseDown")
}
