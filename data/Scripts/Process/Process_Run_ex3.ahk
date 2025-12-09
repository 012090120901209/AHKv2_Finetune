#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Process_Run_ex3.ah2

{
    ErrorLevel := "ERROR" Try ErrorLevel := Run("ReadMe.doc", , "Max", )
}
if (ErrorLevel = "ERROR") MsgBox("The document could not be launched.")
