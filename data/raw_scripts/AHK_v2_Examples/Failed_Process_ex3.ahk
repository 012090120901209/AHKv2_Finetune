#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force

; Source: Failed_Conversions_Process_ex3.ah2

; Note: This is a failed conversion example - complex GUI with process priority

HK1_z() {
  active_pid := WinGetPID("A")
  active_title := WinGetTitle("A")

  oGui5 := Gui()
  oGui5.OnEvent("Close", GuiEscape)
  oGui5.OnEvent("Escape", GuiEscape)
  oGui5.Add("Text", , "Press ESCAPE to cancel, or double-click a new priority level for:`n" . active_title)

  MyListBox := oGui5.Add("ListBox", "r5", ["Normal", "High", "Low", "BelowNormal", "AboveNormal"])
  MyListBox.OnEvent("DoubleClick", HandleListBox.Bind("DoubleClick"))

  ButtonOK := oGui5.Add("Button", "default", "OK")
  ButtonOK.OnEvent("Click", ButtonOKClick)

  oGui5.Title := "Set Priority"
  oGui5.Show()
}

GuiEscape(GuiObj) {
  GuiObj.Destroy()
}

HandleListBox(GuiObj, A_GuiEvent := "", Info := "") {
  if (A_GuiEvent != "DoubleClick")
  ButtonOKClick()
}

ButtonOKClick() {
  priority := MyListBox.Text
  oGui5.Destroy()
  ErrorLevel := ProcessSetPriority(priority, active_pid)
  if (ErrorLevel)
  MsgBox("Success: Priority was changed to " priority)
  else
  MsgBox("Error: Priority could not be changed")
}
