#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: Misc_func_A_ThisFunc.ah2

MyFunc() { fn := %A_ThisFunc% MsgBox(fn.Name "() is " (fn.IsBuiltIn ? "built-in." : "user-defined."))
} MyFunc()
