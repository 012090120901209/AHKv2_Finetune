#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; half_second := 500
start := A_TickCount
Sleep(half_second)
stop := A_TickCount
FileAppend(stop - start, "*")
