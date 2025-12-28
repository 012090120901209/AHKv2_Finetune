#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk
#Include <adash>

/**
 * _.unzip() - Unzip grouped elements
 * 
 * The inverse of _.zip; accepts an array of grouped elements and creates
 * an array regrouping the elements to their pre-zip configuration.
 */

zipped := _.zip(["a", "b"], [1, 2], [true, false])
; => [["a", 1, true], ["b", 2, false]]

result := _.unzip(zipped)
; => [["a", "b"], [1, 2], [true, false]]

MsgBox("Zipped:`n" JSON.stringify(zipped) "`n`n"
    . "Unzipped:`n" JSON.stringify(result))
