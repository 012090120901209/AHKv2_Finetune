#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Keyboard Cursor Control - Vim-Inspired Mouse Navigation
 * 
 * Demonstrates keyboard-driven cursor control with quadrant bisection
 * algorithm for precise positioning. Essential for accessibility and
 * keyboard-centric workflows.
 * 
 * Source: jotnguyen/autohotkey-productivity-scripts - Vimium.ahk
 * Inspired by: https://github.com/jotnguyen/autohotkey-productivity-scripts
 */

; Global state
global cursorMode := false
global cursorX := 0
global cursorY := 0
global cursorStep := 50

MsgBox("Keyboard Cursor Control`n`n"
    . "CapsLock-based Vim navigation:`n`n"
    . "CapsLock + H/J/K/L - Move cursor (Vim style)`n"
    . "CapsLock + U/I/O/P - Quadrant jump`n"
    . "CapsLock + Space - Left click`n"
    . "CapsLock + Enter - Right click`n"
    . "CapsLock + [ / ] - Decrease/Increase speed`n`n"
    . "Perfect for:`n"
    . "- Keyboard-only navigation`n"
    . "- Accessibility`n"
    . "- Precision work`n"
    . "- Vim users", , "T8")

; Disable CapsLock default behavior
SetCapsLockState("AlwaysOff")

; ===============================================
; VIM-STYLE MOVEMENT (H/J/K/L)
; ===============================================

/**
 * Move cursor left (H)
 */
CapsLock & h:: MoveCursor(-1, 0)

/**
 * Move cursor down (J)
 */
CapsLock & j:: MoveCursor(0, 1)

/**
 * Move cursor up (K)
 */
CapsLock & k:: MoveCursor(0, -1)

/**
 * Move cursor right (L)
 */
CapsLock & l:: MoveCursor(1, 0)

/**
 * Move cursor by direction
 */
MoveCursor(dx, dy) {
    global cursorStep

    ; Get current position
    MouseGetPos(&x, &y)

    ; Calculate new position
    newX := x + (dx * cursorStep)
    newY := y + (dy * cursorStep)

    ; Clamp to screen bounds
    newX := Max(0, Min(newX, A_ScreenWidth - 1))
    newY := Max(0, Min(newY, A_ScreenHeight - 1))

    ; Move mouse
    MouseMove(newX, newY, 0)

    ; Show crosshair
    ShowCrosshair(newX, newY)
}

; ===============================================
; QUADRANT JUMP (U/I/O/P)
; ===============================================

/**
 * Jump to top-left quadrant (U)
 */
CapsLock & u:: JumpToQuadrant(0.25, 0.25)

/**
 * Jump to top-right quadrant (I)
 */
CapsLock & i:: JumpToQuadrant(0.75, 0.25)

/**
 * Jump to bottom-left quadrant (O)
 */
CapsLock & o:: JumpToQuadrant(0.25, 0.75)

/**
 * Jump to bottom-right quadrant (P)
 */
CapsLock & p:: JumpToQuadrant(0.75, 0.75)

/**
 * Jump to screen position by percentage
 */
JumpToQuadrant(xPercent, yPercent) {
    newX := Round(A_ScreenWidth * xPercent)
    newY := Round(A_ScreenHeight * yPercent)

    MouseMove(newX, newY, 10)  ; Smooth movement
    ShowCrosshair(newX, newY)

    ToolTip("Jumped to quadrant")
    SetTimer(() => ToolTip(), -800)
}

; ===============================================
; BISECTING ALGORITHM (Advanced Navigation)
; ===============================================

/**
 * Bisect screen horizontally - Left half (,)
 */
CapsLock & ,:: BisectScreen("left")

/**
 * Bisect screen horizontally - Right half (.)
 */
CapsLock & .:: BisectScreen("right")

/**
 * Bisect screen vertically - Top half (;)
 */
CapsLock & `;:: BisectScreen("top")

/**
 * Bisect screen vertically - Bottom half (')
 */
CapsLock & ':: BisectScreen("bottom")

global bisectLeft := 0
global bisectTop := 0
global bisectRight := A_ScreenWidth
global bisectBottom := A_ScreenHeight
global bisectActive := false

/**
 * Bisect current area and jump to half
 */
BisectScreen(direction) {
    global bisectLeft, bisectTop, bisectRight, bisectBottom, bisectActive

    ; Initialize bisect area on first use
    if (!bisectActive) {
        bisectLeft := 0
        bisectTop := 0
        bisectRight := A_ScreenWidth
        bisectBottom := A_ScreenHeight
        bisectActive := true
    }

    width := bisectRight - bisectLeft
    height := bisectBottom - bisectTop
    centerX := bisectLeft + (width / 2)
    centerY := bisectTop + (height / 2)

    ; Bisect based on direction
    switch direction {
        case "left":
            bisectRight := centerX
            newX := bisectLeft + (width / 4)
            newY := centerY

        case "right":
            bisectLeft := centerX
            newX := bisectLeft + (width / 4)
            newY := centerY

        case "top":
            bisectBottom := centerY
            newX := centerX
            newY := bisectTop + (height / 4)

        case "bottom":
            bisectTop := centerY
            newX := centerX
            newY := bisectTop + (height / 4)
    }

    ; Move to new center
    MouseMove(newX, newY, 5)
    ShowCrosshair(newX, newY)

    ; Show bisect area
    ShowBisectArea()
}

/**
 * Reset bisection
 */
CapsLock & r:: ResetBisect()

ResetBisect() {
    global bisectActive
    bisectActive := false
    ToolTip("Bisection reset")
    SetTimer(() => ToolTip(), -1000)
}

; ===============================================
; MOUSE CLICKS
; ===============================================

/**
 * Left click (Space)
 */
CapsLock & Space:: Click()

/**
 * Right click (Enter)
 */
CapsLock & Enter:: Click("Right")

/**
 * Middle click (M)
 */
CapsLock & m:: Click("Middle")

/**
 * Double click (D)
 */
CapsLock & d:: Click(2)

; ===============================================
; SPEED CONTROL
; ===============================================

/**
 * Decrease cursor speed ([)
 */
CapsLock & [:: AdjustSpeed(-10)

/**
 * Increase cursor speed (])
 */
CapsLock & ]:: AdjustSpeed(10)

AdjustSpeed(delta) {
    global cursorStep

    cursorStep := Max(5, Min(200, cursorStep + delta))

    ToolTip("Cursor speed: " cursorStep)
    SetTimer(() => ToolTip(), -1000)
}

; ===============================================
; VISUAL FEEDBACK
; ===============================================

/**
 * Show crosshair at cursor position
 */
ShowCrosshair(x, y) {
    size := 20
    color := "Red"

    ; Create crosshair GUI (temporary)
    crosshair := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")  ; E0x20 = transparent
    crosshair.BackColor := color

    ; Horizontal line
    crosshair.Show("x" (x - size) " y" y " w" (size * 2) " h2 NoActivate")

    ; Vertical line (separate GUI)
    crosshairV := Gui("+AlwaysOnTop -Caption +ToolWindow +E0x20")
    crosshairV.BackColor := color
    crosshairV.Show("x" x " y" (y - size) " w2 h" (size * 2) " NoActivate")

    ; Auto-hide after 500ms
    SetTimer(() => (crosshair.Destroy(), crosshairV.Destroy()), -500)
}

/**
 * Show bisect area outline
 */
ShowBisectArea() {
    global bisectLeft, bisectTop, bisectRight, bisectBottom

    width := bisectRight - bisectLeft
    height := bisectBottom - bisectTop

    ToolTip("Bisect area: " width "x" height, bisectLeft, bisectTop)
    SetTimer(() => ToolTip(), -1500)
}

; ===============================================
; CENTER CURSOR (Win+C)
; ===============================================

/**
 * Jump to screen center
 */
#c:: CenterCursor()

CenterCursor() {
    centerX := A_ScreenWidth / 2
    centerY := A_ScreenHeight / 2

    MouseMove(centerX, centerY, 10)
    ShowCrosshair(centerX, centerY)
}

/*
* Key Concepts:
*
* 1. Vim Navigation:
*    H - Left
*    J - Down
*    K - Up
*    L - Right
*    Familiar for Vim users
*
* 2. CapsLock as Modifier:
*    Easily accessible
*    SetCapsLockState("AlwaysOff")
*    Perfect for frequent use
*    No conflicts
*
* 3. Bisecting Algorithm:
*    Divide screen in half
*    Repeat to narrow down
*    Precise positioning
*    Like binary search
*
* 4. Quadrant Jumping:
*    Quick position changes
*    Screen quarters
*    U/I/O/P layout matches positions
*    Efficient navigation
*
* 5. Use Cases:
*    ✅ Accessibility - No mouse needed
*    ✅ RSI prevention - Reduce mouse usage
*    ✅ Vim enthusiasts - Familiar keys
*    ✅ Precision work - Pixel-perfect
*    ✅ Laptop touchpads - Alternative control
*
* 6. Speed Control:
*    Adjustable step size
*    5-200 pixel range
*    [ ] keys for control
*    Find your preference
*
* 7. Visual Feedback:
*    Crosshair display
*    Bisect area tooltip
*    Speed indicator
*    Temporary GUIs
*
* 8. Click Operations:
*    Space - Left click
*    Enter - Right click
*    M - Middle click
*    D - Double click
*
* 9. Bisection Pattern:
*    Start with full screen
*    , or . - Split horizontally
*    ; or ' - Split vertically
*    Narrows down position
*    R to reset
*
* 10. Accessibility Benefits:
*     Essential for:
*     - Motor impairments
*     - Tremor conditions
*     - One-hand usage
*     - Touchpad issues
*     - Precision requirements
*
* 11. Best Practices:
*     ✅ Visual crosshair feedback
*     ✅ Adjustable speed
*     ✅ Multiple navigation modes
*     ✅ Easy reset (R)
*     ✅ Screen-aware bounds
*
* 12. Advanced Techniques:
*     - Multi-monitor support
*     - Position memory (marks)
*     - Custom speed profiles
*     - Diagonal movement
*     - Grid snapping
*
* 13. Performance:
*     Speed 0 = Instant
*     No mouse lag
*     Lightweight operation
*     Minimal CPU usage
*
* 14. Enhancements:
*     - Grid overlay mode
*     - Position history
*     - Named positions
*     - Mouse gestures
*     - Acceleration curves
*/

