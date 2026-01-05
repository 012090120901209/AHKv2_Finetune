#Requires AutoHotkey v2.0
#SingleInstance Force

; Source: Failed_Conversions_GlobalGui_ex1.ah2

; Note: This is a failed conversion example - global keyword in function scope

MyFunc() {
    global
    myGui := Gui()
    myGui.Add("Text", , "Gui")
    myGui.Show("w150")
}

MyFunc()
F1:: myGui.Destroy()
