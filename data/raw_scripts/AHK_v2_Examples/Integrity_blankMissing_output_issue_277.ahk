#Requires AutoHotkey v2.1-alpha.16 ; Source: Code Integrity/blankMissing_output_issue_277.ah2 #Requires Autohotkey v2.0
#SingleInstance Force esc:: ExitApp()
F11::
F12::
{ ; Added opening brace for [F12]
global ; Made function global MouseGetPos(&mX, &mY) ((A_ThisHotkey = "F11") ? announce("x := " mx) : announce("y := " my))
} ; Added closing brace for [F12] announce(msg) { ToolTip(msg)
}
