#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Misc_func_ex1.ah2 fn := StrLen
MsgBox(fn.Name "() is " (fn.IsBuiltIn ? "built-in." : "user-defined."))
