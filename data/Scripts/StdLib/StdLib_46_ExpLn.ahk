#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Exp() and Ln() - Exponential and natural log
*
* Exp() raises e to a power, Ln() returns natural logarithm.
*/

x := 2

exp_result := Exp(x)  ; e^x
ln_result := Ln(exp_result)  ; ln(e^x) = x

MsgBox("x = " x "`n`n"
. "e^x = " exp_result "`n"
. "ln(e^x) = " ln_result)
