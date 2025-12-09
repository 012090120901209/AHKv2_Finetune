#Requires AutoHotkey v2.0
#SingleInstance Force

Basic AHK v2 example demonstrating variable assignment and control flow half_second := 500
start := A_TickCount
Sleep(half_second*2)
stop := A_TickCount
MsgBox(stop - start)
