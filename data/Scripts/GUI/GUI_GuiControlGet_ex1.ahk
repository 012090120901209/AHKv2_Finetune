#Requires AutoHotkey v2.0
#SingleInstance Force
; Source: Graphical User Interfaces/GuiControlGet_ex1.ah2

myGui := Gui()
ogcRadio_Type := myGui.Add("Radio", "v_Type", "Option 1")
myGui.Add("Radio", , "Option 2")
ogcButtonCheckResponse := myGui.Add("Button", , "Check Response")
ogcButtonCheckResponse.OnEvent("Click", CheckResponse.Bind("Normal"))
myGui.Show()

CheckResponse(A_GuiEvent := "", A_GuiControl := "", Info := "", *) {
    _Type := ogcRadio_Type.Value
    if (_Type = 1) {
        MsgBox("You Selected Option 1")
    } else {
        MsgBox("You Selected Option 2")
    }
}
