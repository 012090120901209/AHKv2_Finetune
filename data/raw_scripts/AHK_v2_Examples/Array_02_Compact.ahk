#Requires AutoHotkey v2.0
#SingleInstance Force
#Include <adash>

/**
 * _.compact() - Remove falsey values
 *
 * Creates an array with all falsey values removed.
 * The values false, 0, "", and unset are falsey.
 */

original := [0, 1, false, 2, "", 3]
result := _.compact(original)
; => [1, 2, 3]

MsgBox("Original: " JSON.stringify(original) "`n"
    . "Compacted: " JSON.stringify(result))
