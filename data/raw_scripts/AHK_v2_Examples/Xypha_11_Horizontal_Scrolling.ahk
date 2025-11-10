#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Horizontal Scrolling Methods
 *
 * Demonstrates five different methods to simulate horizontal scrolling
 * for mice without tilt-wheel functionality.
 *
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Horizontal Scrolling Demo`n`n"
     . "Five methods to scroll horizontally:`n`n"
     . "Method 1: Shift+Wheel`n"
     . "Method 2: Ctrl+Wheel`n"
     . "Method 3: Alt+Wheel`n"
     . "Method 4: RButton+Wheel`n"
     . "Method 5: Custom (Win+Wheel)`n`n"
     . "Try them in a wide document or webpage!", , "T7")

; Open Notepad with wide text for testing
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")
Sleep(500)

; Type wide text
Send("This is a very long line of text that extends beyond the normal width of the window. ")
Send("Scroll horizontally to see the entire line. ")
Send("Use Shift+Wheel, Ctrl+Wheel, Alt+Wheel, RButton+Wheel, or Win+Wheel to scroll left/right.")

MsgBox("Now try the different scroll methods!", , "T3")

; Method 1: Shift+Wheel
+WheelUp::SendHorizontalScroll("left", 3)
+WheelDown::SendHorizontalScroll("right", 3)

; Method 2: Ctrl+Wheel (may conflict with zoom)
; ^WheelUp::SendHorizontalScroll("left", 3)
; ^WheelDown::SendHorizontalScroll("right", 3)

; Method 3: Alt+Wheel
!WheelUp::SendHorizontalScroll("left", 3)
!WheelDown::SendHorizontalScroll("right", 3)

; Method 4: RButton+Wheel (hold right button and scroll)
#HotIf GetKeyState("RButton", "P")
WheelUp::SendHorizontalScroll("left", 3)
WheelDown::SendHorizontalScroll("right", 3)
#HotIf

; Method 5: Win+Wheel
#WheelUp::SendHorizontalScroll("left", 3)
#WheelDown::SendHorizontalScroll("right", 3)

/**
 * Send horizontal scroll message
 * @param {string} direction - "left" or "right"
 * @param {int} amount - Scroll amount (1-10)
 */
SendHorizontalScroll(direction, amount := 3) {
    ; Get window under mouse
    MouseGetPos(, , &hwnd, &ctrl)

    ; Calculate scroll value
    scrollAmount := amount * 40  ; 40 units per notch

    if (direction == "left")
        scrollAmount := -scrollAmount

    ; Send WM_MOUSEHWHEEL message (0x20E)
    ; wParam = scroll amount << 16
    wParam := scrollAmount << 16

    ; Try control first, then window
    if (ctrl) {
        PostMessage(0x20E, wParam, 0, ctrl, "ahk_id " hwnd)
    } else if (hwnd) {
        PostMessage(0x20E, wParam, 0, , "ahk_id " hwnd)
    }
}

/*
 * Key Concepts:
 *
 * 1. Horizontal Scrolling:
 *    WM_MOUSEHWHEEL message (0x20E)
 *    Alternative to tilt-wheel
 *    Not all apps support it
 *
 * 2. Scroll Methods:
 *    Shift+Wheel - Most common
 *    Ctrl+Wheel - May conflict with zoom
 *    Alt+Wheel - Safe alternative
 *    RButton+Wheel - Gesture-based
 *    Custom combination
 *
 * 3. WM_MOUSEHWHEEL:
 *    Message code: 0x20E
 *    wParam: scroll amount << 16
 *    Positive = scroll right
 *    Negative = scroll left
 *
 * 4. Scroll Amount:
 *    WHEEL_DELTA = 120 units
 *    40 units = small scroll
 *    120 units = standard notch
 *    Adjustable sensitivity
 *
 * 5. Target Selection:
 *    MouseGetPos() - Get window/control
 *    Send to control first
 *    Fallback to window
 *    Some apps need specific target
 *
 * 6. Context-Sensitive:
 *    #HotIf for conditional hotkeys
 *    GetKeyState("RButton", "P")
 *    Only when holding button
 *
 * 7. Use Cases:
 *    ✅ Wide spreadsheets
 *    ✅ Code editors
 *    ✅ Image viewers
 *    ✅ Web pages
 *    ✅ Timeline editors
 *
 * 8. Application Support:
 *    Excel: ✅ Full support
 *    Chrome: ✅ Works well
 *    Notepad: ⚠ Limited
 *    VS Code: ✅ Full support
 *    Old apps: ❌ May not work
 *
 * 9. Best Practices:
 *    ✅ Multiple methods
 *    ✅ Adjustable speed
 *    ✅ Test in target apps
 *    ✅ Non-conflicting combos
 *
 * 10. PostMessage vs SendMessage:
 *     PostMessage - Non-blocking, queued
 *     SendMessage - Blocking, immediate
 *     PostMessage better for scrolling
 *
 * 11. Alternative Approaches:
 *     - Send arrow keys (← →)
 *     - Send Home/End
 *     - Drag scrollbar
 *     - Inject tilt-wheel events
 *
 * 12. Enhancements:
 *     - Configurable speed
 *     - Per-app settings
 *     - Smooth scrolling
 *     - Visual feedback
 *     - Inertial scrolling
 *     - Two-finger gesture simulation
 */
