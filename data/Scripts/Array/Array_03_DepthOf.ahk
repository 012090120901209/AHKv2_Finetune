#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.depthOf() - Get array depth
 * 
 * Explores the array and returns the maximum depth.
 */

depth1 := _.depthOf([1])
; => 1

depth2 := _.depthOf([1, [2]])
; => 2

depth3 := _.depthOf([1, [[2]]])
; => 3

depth4 := _.depthOf([1, [2, [3, [4]], 5]])
; => 4

MsgBox("Depth of [1]: " depth1 "`n"
    . "Depth of [1, [2]]: " depth2 "`n"
    . "Depth of [1, [[2]]]: " depth3 "`n"
    . "Depth of [1, [2, [3, [4]], 5]]: " depth4)
