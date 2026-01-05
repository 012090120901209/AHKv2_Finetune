#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Mouse Control with Numpad
 * 
 * Demonstrates pixel-precise mouse movement using the numpad,
 * useful for accessibility and precision work.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

; Configuration
global MouseSpeed := 20  ; Pixels per movement
global MouseSpeedFast := 100  ; Shift for faster movement
global MouseSpeedSlow := 5  ; Ctrl for slower movement

MsgBox("Mouse Numpad Control Demo`n`n"
    . "Controls:`n"
    . "Win+Numpad1-9 - Move mouse`n"
    . "Win+Numpad5 - Click`n`n"
    . "Layout (like numpad):`n"
    . "7  8  9  (↖ ↑ ↗)`n"
    . "4  5  6  (← Click →)`n"
    . "1  2  3  (↙ ↓ ↘)`n`n"
    . "Modifiers:`n"
    . "Add Shift - Fast movement`n"
    . "Add Ctrl - Slow movement", , "T7")

; Numpad movement (Win+Numpad)
#Numpad1:: MoveMouse(-1, 1)   ; Bottom-left
#Numpad2:: MoveMouse(0, 1)    ; Down
#Numpad3:: MoveMouse(1, 1)    ; Bottom-right
#Numpad4:: MoveMouse(-1, 0)   ; Left
#Numpad5:: Click()            ; Click
#Numpad6:: MoveMouse(1, 0)    ; Right
#Numpad7:: MoveMouse(-1, -1)  ; Top-left
#Numpad8:: MoveMouse(0, -1)   ; Up
#Numpad9:: MoveMouse(1, -1)   ; Top-right

; Fast movement (Win+Shift+Numpad)
#+Numpad1:: MoveMouse(-1, 1, "fast")
#+Numpad2:: MoveMouse(0, 1, "fast")
#+Numpad3:: MoveMouse(1, 1, "fast")
#+Numpad4:: MoveMouse(-1, 0, "fast")
#+Numpad6:: MoveMouse(1, 0, "fast")
#+Numpad7:: MoveMouse(-1, -1, "fast")
#+Numpad8:: MoveMouse(0, -1, "fast")
#+Numpad9:: MoveMouse(1, -1, "fast")

; Slow movement (Win+Ctrl+Numpad)
#^Numpad1:: MoveMouse(-1, 1, "slow")
#^Numpad2:: MoveMouse(0, 1, "slow")
#^Numpad3:: MoveMouse(1, 1, "slow")
#^Numpad4:: MoveMouse(-1, 0, "slow")
#^Numpad6:: MoveMouse(1, 0, "slow")
#^Numpad7:: MoveMouse(-1, -1, "slow")
#^Numpad8:: MoveMouse(0, -1, "slow")
#^Numpad9:: MoveMouse(1, -1, "slow")

/**
 * Move mouse by direction
 * @param {int} x - X direction (-1, 0, 1)
 * @param {int} y - Y direction (-1, 0, 1)
 * @param {string} speed - "normal", "fast", or "slow"
 */
MoveMouse(x, y, speed := "normal") {
    global MouseSpeed, MouseSpeedFast, MouseSpeedSlow

    ; Determine movement distance
    switch speed {
        case "fast":
            distance := MouseSpeedFast
        case "slow":
            distance := MouseSpeedSlow
        default:
            distance := MouseSpeed
    }

    ; Calculate movement
    moveX := x * distance
    moveY := y * distance

    ; Move mouse relative to current position
    MouseMove(moveX, moveY, 0, "R")
}

/*
* Key Concepts:
*
* 1. Numpad Layout:
*    Mirrors directional layout
*    7 8 9 = NW N NE
*    4 5 6 = W Center E
*    1 2 3 = SW S SE
*
* 2. Relative Movement:
*    MouseMove(x, y, speed, "R")
*    "R" = Relative to current position
*    Speed 0 = Instant
*
* 3. Direction Vectors:
*    (-1, -1) = Up-Left
*    (0, -1) = Up
*    (1, 0) = Right
*    Normalize for diagonals
*
* 4. Speed Modifiers:
*    Normal = 20 pixels
*    Fast (Shift) = 100 pixels
*    Slow (Ctrl) = 5 pixels
*
* 5. Use Cases:
*    ✅ Accessibility
*    ✅ Broken mouse
*    ✅ Pixel-precise selection
*    ✅ Remote desktop
*    ✅ Presentation control
*
* 6. Hotkey Pattern:
*    Win+Numpad - Non-conflicting
*    Easy to remember layout
*    One hand operation
*
* 7. Configuration:
*    Adjustable speeds
*    Global variables
*    Easy customization
*
* 8. Mouse Operations:
*    MouseMove - Move cursor
*    Click - Left click
*    MouseClick("Right") - Right click
*    MouseGetPos - Get position
*
* 9. Best Practices:
*    ✅ Speed 0 for instant
*    ✅ Relative movement
*    ✅ Multiple speed options
*    ✅ Logical layout
*
* 10. Enhancements:
*     - Variable acceleration
*     - Click-and-drag
*     - Right/middle click
*     - Scroll wheel control
*     - Position presets
*     - GUI overlay
*
* 11. Related Features:
*     Numpad0 - Double-click
*     NumpadDot - Right-click
*     NumpadEnter - Middle-click
*     NumpadAdd/Sub - Scroll
*
* 12. Accessibility:
*     Essential for:
*     - Motor impairments
*     - Touchpad users
*     - Laptop users
*     - Broken hardware
*     - Ergonomic setups
*/

