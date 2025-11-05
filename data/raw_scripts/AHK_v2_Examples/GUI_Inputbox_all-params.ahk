#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Graphical User Interfaces/Inputbox_all-params.ah2 IB := InputBox("Prompt", "Title", "Password w200 h100 x600 y400 t5", "DefaultText"), Variable := IB.Value IB := InputBox("Prompt", "Title", "Password w" W " h" H " x" X " y" Y " t" Timeout "", "Default"), OutputVar := IB.Value
