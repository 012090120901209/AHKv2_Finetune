#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: External Libraries/DllCall_ex5.ah2 DllCall("QueryPerformanceFrequency", "Int64*", &freq)
DllCall("QueryPerformanceCounter", "Int64*", &CounterBefore)
Sleep(1000)
DllCall("QueryPerformanceCounter", "Int64*", &CounterAfter)
MsgBox("Elapsed QPC time is " . (CounterAfter - CounterBefore) / freq * 1000 " ms")
