#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
 * _.reverse() - Reverse array
 * 
 * Reverses array so that the first element becomes the last,
 * the second element becomes the second to last, and so on.
 */

result1 := _.reverse(["a", "b", "c"])
; => ["c", "b", "a"]

result2 := _.reverse([{ foo: "bar" }, "b", "c"])
; => ["c", "b", {foo: "bar"}]

MsgBox("Reverse ['a','b','c']: " JSON.stringify(result1) "`n`n"
    . "Reverse with object: " JSON.stringify(result2))
