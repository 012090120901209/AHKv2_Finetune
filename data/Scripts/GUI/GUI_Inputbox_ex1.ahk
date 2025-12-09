#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/Inputbox_ex1.ah2

IB := InputBox("(your input will be hidden)", "Enter Password", "Password"), password := IB.Value
