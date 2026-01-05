#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.sortedUniq() - Remove duplicates from sorted array
 * 
 * Like _.uniq except that it's optimized for sorted arrays.
 */

result := _.sortedUniq([1, 1, 2])
; => [1, 2]

MsgBox("SortedUniq [1,1,2]:`n" JSON.stringify(result))
