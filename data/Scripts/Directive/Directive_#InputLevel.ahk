#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: _Directives/#InputLevel.ah2
#InputLevel 1

Numpad0:: LButton
#InputLevel 0
; This hotkey can be triggered by both Numpad0 and LButton:
~LButton:: MsgBox("Clicked")
