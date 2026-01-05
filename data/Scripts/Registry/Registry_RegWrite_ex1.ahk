#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Registry_RegWrite_ex1.ah2

RegWrite("Test Value", "REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\TestKey", "MyValueName")
