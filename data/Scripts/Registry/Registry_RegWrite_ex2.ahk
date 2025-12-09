#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Registry_RegWrite_ex2.ah2

RegWrite("01A9FF77", "REG_BINARY", "HKEY_CURRENT_USER\Software\TEST_APP", "TEST_NAME")
