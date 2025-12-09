#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Registry_RegRead_ex1.ah2

OutputVar := RegRead("HKEY_LOCAL_MACHINE\Software\SomeApplication", "TestValue")
