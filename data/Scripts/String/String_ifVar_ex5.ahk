#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_ifVar_ex5.ah2

IB := InputBox("", "Enter YES or NO"), UserInput := IB.Value
if !(UserInput~ = "^(?i:yes|no)$") MsgBox("Your input is not valid.")
