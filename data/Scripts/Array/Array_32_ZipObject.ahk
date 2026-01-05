#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk
#Include ../Lib/adash.ahk

/**
 * _.zipObject() - Create object from arrays
 * 
 * Like _.fromPairs except that it accepts two arrays, one of property
 * identifiers and one of corresponding values.
 */

result := _.zipObject(["a", "b"], [1, 2])
; => {a: 1, b: 2}

MsgBox("ZipObject result:`n" JSON.stringify(result))
