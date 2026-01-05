#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.chunk() - Split array into chunks
 * 
 * Creates an array of elements split into groups the length of size.
 * If array can't be split evenly, the final chunk will be the remaining elements.
 */

; Split into chunks of 2
result1 := _.chunk(["a", "b", "c", "d"], 2)
; => [["a", "b"], ["c", "d"]]

; Split into chunks of 3 (uneven)
result2 := _.chunk(["a", "b", "c", "d"], 3)
; => [["a", "b", "c"], ["d"]]

MsgBox("Chunk by 2: " JSON.stringify(result1) "`n`n"
    . "Chunk by 3: " JSON.stringify(result2))
