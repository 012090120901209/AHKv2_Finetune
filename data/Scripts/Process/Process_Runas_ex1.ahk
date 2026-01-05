#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_Runas_ex1.ah2

RunAs("Administrator", "MyPassword")
Run("RegEdit.exe")
RunAs() ; Reset to normal behavior.
