#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Registry_RegWrite_ex1_oldSyntax.ah2

RegWrite("Test Value", "REG_SZ", "HKEY_LOCAL_MACHINE\SOFTWARE\TestKey", "MyValueName")
