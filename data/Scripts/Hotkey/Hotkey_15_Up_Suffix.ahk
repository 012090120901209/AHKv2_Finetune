#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Up Suffix - Fires on Key Release
 * Detects when a key is released rather than pressed
 */

; Fires when F1 is PRESSED
F1:: ToolTip("F1 Down")

; Fires when F1 is RELEASED
F1 Up:: {
    ToolTip("F1 Released")
    SetTimer(() => ToolTip(), -2000)
}

; Practical example: Hold Ctrl to show overlay, release to hide
Ctrl:: ToolTip("Holding Ctrl...")
Ctrl Up:: ToolTip()
