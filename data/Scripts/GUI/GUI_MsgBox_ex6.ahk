#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Graphical User Interfaces/MsgBox_ex6.ah2

SplashTextGui := Gui("ToolWindow -Sysmenu Disabled", "A message box is about to appear."), SplashTextGui.Add("Text", ,), SplashTextGui.Show("w200 h0")
Sleep(3000)
SplashTextGui.Destroy
MsgBox("The backup process has completed.")
