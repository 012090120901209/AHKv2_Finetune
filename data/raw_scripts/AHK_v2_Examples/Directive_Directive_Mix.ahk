#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force ; Source: _Directives_Directive_Mix.ah2 ; Removed #CommentFlag NewString
; Removed #EscapeChar _
; Removed #DerefChar #
; Removed #Delimiter / Var := "String" MsgBox("This is a test") ; should be omitted
MsgBox("This is a `nnewline")
MsgBox(Var)
