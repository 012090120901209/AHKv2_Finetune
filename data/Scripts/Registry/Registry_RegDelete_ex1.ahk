#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Registry_RegDelete_ex1.ah2

RegDelete("HKEY_LOCAL_MACHINE\Software\SomeApplication", "TestValue")
