#Requires AutoHotkey v2.0
#SingleInstance Force

; ByRef with multiple calls to show the same variables being reused.
SwapAndConcat(&left, &right) {
    temp := left
    left := right
    right := temp . right
}

x := "alpha"
y := "beta"
SwapAndConcat(&x, &y)
SwapAndConcat(&x, &y)

MsgBox("x = " x "`ny = " y)
