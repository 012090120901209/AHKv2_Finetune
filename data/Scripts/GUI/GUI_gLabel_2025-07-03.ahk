#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/gLabel_2025-07-03.ah2
; 2025-07-03 - prevent this from being mistaken as label
; which caused it to be conv to func by mistake
Mute := 1	; mistaken for Mute: after conv to Mute := 1 myGui := Gui()
ogcCheckboxMute := myGui.Add("Checkbox", "0x8000 vMute checked" . mute . " xp+140 yp w50", "&Mute")
ogcCheckboxMute.OnEvent("Click", Mute.Bind("Normal")) If (Mute = 0)	; no confusion here SoundPlay("c:\WINDOWS\Media\chimes.wav") Mute()
    Mute(A_GuiEvent := "", A_GuiControl := "", Info := "", *) {
    oSaved := myGui.Submit(0) Mute := oSaved.Mute ControlFocus("Edit1", AppWindow)
}
