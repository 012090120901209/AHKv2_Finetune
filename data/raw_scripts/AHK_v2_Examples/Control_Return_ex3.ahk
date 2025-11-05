#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: Flow of Control/Return_ex3.ah2 MyFunc() { Return (AHKv1v2_Temp := a := 1, b := a + 1, AHKv1v2_Temp) ; Wrapped Multi-statement return with parentheses
}
MyFunc()
MsgBox(a " " b) MyFunc2() { global d Return (AHKv1v2_Temp := c := 1, d := c + 1, AHKv1v2_Temp) ; Wrapped Multi-statement return with parentheses
}
MyFunc2()
MsgBox(MyFunc2() " " d) ; 1 2
