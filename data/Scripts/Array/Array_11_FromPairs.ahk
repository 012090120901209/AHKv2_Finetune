#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
 * _.fromPairs() - Create object from pairs
 * 
 * The inverse of _.toPairs; returns an object composed from key-value pairs.
 */

result := _.fromPairs([["a", 1], ["b", 2]])
; => {a: 1, b: 2}

MsgBox("FromPairs result:`n" JSON.stringify(result))
