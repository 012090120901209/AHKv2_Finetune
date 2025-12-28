#Requires AutoHotkey v2.0
#SingleInstance Force ; Source: String_static-trailing-comma.ah2

fn() {
    static var := 0x123 ; Assuming this is v1.0 code static var2 := 0x456 MsgBox(var var2)
} fn()
