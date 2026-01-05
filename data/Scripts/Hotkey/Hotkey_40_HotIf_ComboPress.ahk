#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Context-Sensitive - Combination Detection
 * Hotkeys that fire based on recent key presses
 */

global lastKey := ""
global lastKeyTime := 0

; Track all key presses
*~a::
*~b::
*~c:: {
    global lastKey := SubStr(A_ThisHotkey, 3)  ; Remove *~
    global lastKeyTime := A_TickCount
}

; Context: Only if 'a' was pressed recently (within 1 second)
#HotIf (lastKey = "a" and (A_TickCount - lastKeyTime) < 1000)

b:: MsgBox("Pressed 'b' shortly after 'a'!`n`nSequence detected: a→b")
#HotIf

; Context: Only if 'b' was pressed recently
#HotIf (lastKey = "b" and (A_TickCount - lastKeyTime) < 1000)

c:: MsgBox("Pressed 'c' shortly after 'b'!`n`nSequence: b→c")
#HotIf

; Reset context
#HotIf

; Pattern example: Double-tap detection
global spaceTapCount := 0
global lastSpaceTime := 0

Space:: {
    global spaceTapCount, lastSpaceTime

    ; If tapped within 300ms, increment counter
    if (A_TickCount - lastSpaceTime < 300) {
        spaceTapCount++
        if (spaceTapCount = 2) {
            MsgBox("Double-tap Space detected!")
            spaceTapCount := 0
        }
    } else {
        spaceTapCount := 1
    }

    lastSpaceTime := A_TickCount
    Send("{Space}")  ; Still send space
}
