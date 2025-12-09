; Title: Gui.Create - Simple GUI Application
; Category: GUI
; Source: https://www.autohotkey.com/docs/v2/lib/GuiCreate.htm
; Description: Creating a simple GUI window with text, edit box, and buttons including event handling.

#Requires AutoHotkey v2.0

; Create a simple GUI
MyGui := Gui()
MyGui.Title := "My Application"

; Add controls
MyGui.Add("Text", , "Enter your name:")
NameEdit := MyGui.Add("Edit", "w200")
MyGui.Add("Button", "Default w80", "OK").OnEvent("Click", ProcessInput)
MyGui.Add("Button", "x+10 w80", "Cancel").OnEvent("Click", (*) => MyGui.Destroy())

; Show the GUI
MyGui.Show()

ProcessInput(*) {
    Saved := MyGui.Submit()
    name := NameEdit.Value
    MsgBox "Hello, " name "!"
    MyGui.Destroy()
}
