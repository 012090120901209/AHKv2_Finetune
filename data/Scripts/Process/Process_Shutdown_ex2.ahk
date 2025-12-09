#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_Shutdown_ex2.ah2

DllCall("PowrProf\SetSuspendState", "Int", 0, "Int", 0, "Int", 0)
