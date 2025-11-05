#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Misc_FuncObj-Call_ex1.ah2 mFunc(msg) { MsgBox(msg)
} fn := mFunc fn.Call("Call")
fn.Call("Legacy Call")
