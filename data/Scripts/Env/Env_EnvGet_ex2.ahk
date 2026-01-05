#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_EnvGet_ex2.ah2

OutputVar := EnvGet(A_Is64bitOS ? "ProgramW6432" : "ProgramFiles")
MsgBox("Program files are in: " OutputVar)
