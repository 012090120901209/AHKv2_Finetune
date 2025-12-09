#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Environment_Goto_ex1.ah2

^h:: HK1_h()
Return ; Add Return for Goto Start()
HK1_h() { Start() Return ; Add Return for Goto MsgBox("Skipped")
}
Start() { MsgBox("This MsgBox is under the start label")
}
