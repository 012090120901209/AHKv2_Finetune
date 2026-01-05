#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Screen_ImageSearch_ex1.ah2

ErrorLevel := !ImageSearch(&FoundX, &FoundY, 40, 40, 300, 300, "C:\My Images\test.bmp")
