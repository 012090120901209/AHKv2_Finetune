#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Mouse and Keyboard/BlockInput_ex1.ah2 BlockInput("On")
Run("notepad")
WinWaitActive("Untitled - Notepad")
Send("{F5}") ; pastes time and date
BlockInput("Off")
