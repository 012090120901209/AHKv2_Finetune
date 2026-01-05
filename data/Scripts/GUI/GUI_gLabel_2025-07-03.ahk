#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/gLabel_2025-07-03.ah2
; 2025-07-03 - prevent this from being mistaken as label
; which caused it to be conv to func by mistake

MuteVar := 1
myGui := Gui()

ogcCheckboxMute := myGui.Add("Checkbox", "0x8000 vMute checked" . MuteVar . " xp+140 yp w50", "&Mute")
ogcCheckboxMute.OnEvent("Click", MuteHandler.Bind("Normal"))

if (MuteVar = 0)
{
    SoundPlay("c:\WINDOWS\Media\chimes.wav")
}

MuteHandler(A_GuiEvent := "", A_GuiControl := "", Info := "", *)
{
    oSaved := myGui.Submit(0)
    MuteVar := oSaved.Mute
    ControlFocus("Edit1", AppWindow)
}
