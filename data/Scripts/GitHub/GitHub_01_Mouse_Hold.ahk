#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Mouse Hold - Accessibility Mouse Button Lock
 * 
 * Demonstrates holding down mouse buttons without physical pressure,
 * useful for accessibility, drag operations, and gaming.
 * 
 * Source: JWCow/AHK-Collection - mouse_hold.ahk
 * Inspired by: https://github.com/JWCow/AHK-Collection
 */

; Global state tracking
global leftHeld := false
global rightHeld := false
global middleHeld := false

MsgBox("Mouse Hold Demo`n`n"
    . "Hotkeys:`n"
    . "Ctrl+Alt+Shift+1 - Toggle LEFT button hold`n"
    . "Ctrl+Alt+Shift+2 - Toggle RIGHT button hold`n"
    . "Ctrl+Alt+Shift+3 - Toggle MIDDLE button hold`n`n"
    . "Useful for:`n"
    . "- Long drag operations`n"
    . "- Accessibility needs`n"
    . "- Gaming macros`n"
    . "- Hands-free operations", , "T7")

; ===============================================
; MOUSE HOLD HOTKEYS
; ===============================================

/**
 * Toggle left mouse button hold
 */
^!+1:: ToggleMouseHold("Left")

/**
 * Toggle right mouse button hold
 */
^!+2:: ToggleMouseHold("Right")

/**
 * Toggle middle mouse button hold
 */
^!+3:: ToggleMouseHold("Middle")

; ===============================================
; TOGGLE FUNCTION
; ===============================================

/**
 * Toggle mouse button hold state
 * @param {string} button - "Left", "Right", or "Middle"
 */
ToggleMouseHold(button) {
    global leftHeld, rightHeld, middleHeld

    switch button {
        case "Left":
            leftHeld := !leftHeld
            if (leftHeld) {
                Click("Down")
                ToolTip("LEFT button HELD`nPress Ctrl+Alt+Shift+1 to release")
            } else {
                Click("Up")
                ToolTip("LEFT button RELEASED")
                SetTimer(() => ToolTip(), -1500)
            }

        case "Right":
            rightHeld := !rightHeld
            if (rightHeld) {
                Click("Right Down")
                ToolTip("RIGHT button HELD`nPress Ctrl+Alt+Shift+2 to release")
            } else {
                Click("Right Up")
                ToolTip("RIGHT button RELEASED")
                SetTimer(() => ToolTip(), -1500)
            }

        case "Middle":
            middleHeld := !middleHeld
            if (middleHeld) {
                Click("Middle Down")
                ToolTip("MIDDLE button HELD`nPress Ctrl+Alt+Shift+3 to release")
            } else {
                Click("Middle Up")
                ToolTip("MIDDLE button RELEASED")
                SetTimer(() => ToolTip(), -1500)
            }
    }
}

; ===============================================
; STATUS DISPLAY (Win+M)
; ===============================================

/**
 * Show current hold status
 */
#m:: ShowStatus()

ShowStatus() {
    global leftHeld, rightHeld, middleHeld

    status := "Mouse Hold Status:`n`n"
        . "LEFT:   " (leftHeld ? "HELD ✓" : "Released") "`n"
        . "RIGHT:  " (rightHeld ? "HELD ✓" : "Released") "`n"
        . "MIDDLE: " (middleHeld ? "HELD ✓" : "Released") "`n`n"
        . "Win+M to check status anytime"

    MsgBox(status, "Mouse Hold Status", "T3")
}

; ===============================================
; SAFETY: RELEASE ALL ON ESC
; ===============================================

/**
 * Emergency release all held buttons
 */
~Esc::
{
    global leftHeld, rightHeld, middleHeld

    ; Only act if any button is held
    if (leftHeld || rightHeld || middleHeld) {
        if (leftHeld) {
            Click("Up")
            leftHeld := false
        }
        if (rightHeld) {
            Click("Right Up")
            rightHeld := false
        }
        if (middleHeld) {
            Click("Middle Up")
            middleHeld := false
        }

        ToolTip("All mouse buttons RELEASED")
        SetTimer(() => ToolTip(), -2000)
    }
}

; Clean up on exit
OnExit((*) => ReleaseAll())

ReleaseAll() {
    global leftHeld, rightHeld, middleHeld

    if (leftHeld)
        Click("Up")
    if (rightHeld)
        Click("Right Up")
    if (middleHeld)
        Click("Middle Up")
}

/*
* Key Concepts:
*
* 1. Mouse Button States:
*    Click("Down") - Press and hold left button
*    Click("Up") - Release left button
*    Click("Right Down/Up") - Right button
*    Click("Middle Down/Up") - Middle button
*
* 2. State Management:
*    Global variables track hold state
*    Toggle between held/released
*    Persistent across operations
*
* 3. Use Cases:
*    ✅ Accessibility - Users with limited grip strength
*    ✅ Long drag operations - File selection, drawing
*    ✅ Gaming - Auto-fire, continuous actions
*    ✅ CAD/Design - Precision work without fatigue
*    ✅ Presentations - Laser pointer mode
*
* 4. Safety Features:
*    ESC key releases all buttons
*    OnExit cleanup
*    Visual feedback via ToolTip
*    Status check with Win+M
*
* 5. Modifier Stack:
*    Ctrl+Alt+Shift = Triple modifier
*    Unlikely to conflict
*    Easy to remember (same base, different number)
*
* 6. Click Command:
*    Click() - Left button
*    Click("Right") - Right button
*    Click("Middle") - Middle button
*    Click("X1"/"X2") - Extra buttons
*
* 7. Hold vs Click:
*    Down - Start holding
*    Up - Stop holding
*    Without modifier - Single click
*    Duration between Down/Up = hold time
*
* 8. Practical Examples:
*    - Drag large file selections
*    - Paint/draw without hand strain
*    - Gaming: hold to aim/block
*    - CAD: rotate/pan view
*    - Photo editing: brush operations
*
* 9. Advanced Patterns:
*    - Auto-release after timeout
*    - Hold duration tracking
*    - Combination holds (Left+Right)
*    - Position-locked holds
*
* 10. Accessibility:
*     Essential for:
*     - Tremor conditions
*     - Arthritis
*     - Carpal tunnel
*     - Limited dexterity
*     - One-hand usage
*
* 11. Best Practices:
*     ✅ Always provide release hotkey
*     ✅ Show visual feedback
*     ✅ Clean up on exit
*     ✅ Emergency release (ESC)
*     ✅ Status indicator
*
* 12. Common Workflows:
*     1. Activate hold
*     2. Perform operation
*     3. Deactivate hold
*     4. Check status if unsure
*
* 13. Gaming Applications:
*     - Auto-fire weapons
*     - Continuous mining
*     - Hold to sprint
*     - Aim down sights
*     - Block/shield hold
*
* 14. Limitations:
*     ⚠ Some games may detect as cheating
*     ⚠ Won't work in anti-cheat environments
*     ⚠ Some apps may not recognize synthetic holds
*     ⚠ Always respect ToS
*/

