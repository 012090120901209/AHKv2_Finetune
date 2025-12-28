#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Inputbox_CBE.ah2

Timeout := 3 IB := InputBox("Prompt", "Title", "Password w" A_ScreenWidth // 2 " h" A_ScreenHeight // 2 " x100 y100 t" Timeout "", "DefaultText"), Variable := IB.Value IB := InputBox("Prompt", "Title", "Password w" A_ScreenWidth // 2 " h" A_ScreenHeight // 2 " x100 y100 t" Timeout "", "DefaultText"), Variable := IB.Value
