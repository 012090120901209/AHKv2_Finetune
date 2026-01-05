#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../Lib/adash.ahk

/**
 * _.head() - Get first element
 * 
 * Gets the first element of array.
 * Alias: _.first()
 */

result1 := _.head([1, 2, 3])
; => 1

result2 := _.head({ a: 1, b: 2, c: 3 })
; => 1

result3 := _.head("Neo")
; => "N"

MsgBox("Head of [1, 2, 3]: " result1 "`n"
    . "Head of {a:1, b:2, c:3}: " result2 "`n"
    . "Head of 'Neo': " result3)
