#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.uniq() - Remove duplicates
 *
 * Creates a duplicate-free version of an array, in which only the first
 * occurrence of each element is kept. The order of result values is
 * determined by the order they occur in the array.
 */

result := _.uniq([2, 1, 2])
; => [2, 1]

MsgBox("Uniq of [2,1,2]:`n" JSON.stringify(result))
