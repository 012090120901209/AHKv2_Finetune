#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Registry_Loop_regestry_ex1.ah2

Loop Reg, "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\TypedURLs" RegDelete()
