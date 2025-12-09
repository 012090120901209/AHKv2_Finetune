#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Sound_SoundGet_ex1.ah2

master_volume := SoundGetVolume()
MsgBox("Master volume is " master_volume " percent.")
