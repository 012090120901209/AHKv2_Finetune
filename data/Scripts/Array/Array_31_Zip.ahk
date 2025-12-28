#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
 * _.zip() - Zip arrays together
 * 
 * Creates an array of grouped elements, the first of which contains
 * the first elements of the given arrays, the second of which contains
 * the second elements of the given arrays, and so on.
 */

result := _.zip(["a", "b"], [1, 2], [true, true])
; => [["a", 1, true], ["b", 2, true]]

MsgBox("Zip result:`n" JSON.stringify(result))
