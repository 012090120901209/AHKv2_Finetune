#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_Clipboard_ex1.ah2

ThisStringShouldNotChange := "clipboard" if (ThisStringShouldNotChange = Chr(99) "lipboard") MsgBox("Conversion success :D")
    else MsgBox(Chr(99) "lipboard has been incorrectly translated to A_Clipboard")
