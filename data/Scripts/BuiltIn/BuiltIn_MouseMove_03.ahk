#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 MouseMove - Smooth Movement and Animation
* ============================================================================
*
* Demonstrates smooth, animated mouse movements using various easing functions,
* curves, and advanced animation techniques for professional-looking automation.
*
* @module BuiltIn_MouseMove_03
* @author AutoHotkey Community
* @version 2.0.0
*/

; ============================================================================
; Example 1: Easing Functions for Smooth Movement
; ============================================================================

/**
* Linear movement (constant speed).
* Moves at uniform velocity from start to end.
*
* @example
* ; Press F1 for linear movement
*/
F1:: {
    ToolTip("Linear movement (constant speed)...")

    startX := 200
    startY := 300
    endX := 800
    endY := 300
    steps := 50

    Loop steps {
        progress := A_Index / steps

        x := startX + (endX - startX) * progress
        y := startY + (endY - startY) * progress

        MouseMove(x, y, 0)
        Sleep(15)
    }

    ToolTip("Linear movement complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Ease-in movement (slow start, accelerate).
* Starts slowly and speeds up.
*/
F2:: {
    ToolTip("Ease-in movement (accelerating)...")

    startX := 200
    startY := 350
    endX := 800
    endY := 350
    steps := 50

    Loop steps {
        progress := A_Index / steps

        ; Quadratic ease-in
        easedProgress := progress * progress

        x := startX + (endX - startX) * easedProgress
        y := startY + (endY - startY) * easedProgress

        MouseMove(x, y, 0)
        Sleep(15)
    }

    ToolTip("Ease-in complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Ease-out movement (fast start, decelerate).
* Starts fast and slows down at the end.
*/
F3:: {
    ToolTip("Ease-out movement (decelerating)...")

    startX := 200
    startY := 400
    endX := 800
    endY := 400
    steps := 50

    Loop steps {
        progress := A_Index / steps

        ; Quadratic ease-out
        easedProgress := 1 - (1 - progress) * (1 - progress)

        x := startX + (endX - startX) * easedProgress
        y := startY + (endY - startY) * easedProgress

        MouseMove(x, y, 0)
        Sleep(15)
    }

    ToolTip("Ease-out complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Ease-in-out movement (slow-fast-slow).
* Smooth acceleration and deceleration.
*/
F4:: {
    ToolTip("Ease-in-out movement (smooth)...")

    startX := 200
    startY := 450
    endX := 800
    endY := 450
    steps := 50

    Loop steps {
        progress := A_Index / steps

        ; Ease-in-out formula
        easedProgress := progress < 0.5
        ? 2 * progress * progress
        : 1 - (-2 * progress + 2) ** 2 / 2

        x := startX + (endX - startX) * easedProgress
        y := startY + (endY - startY) * easedProgress

        MouseMove(x, y, 0)
        Sleep(15)
    }

    ToolTip("Ease-in-out complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 2: Curved Path Movements
; ============================================================================

/**
* Bezier curve movement.
* Creates smooth curved path between points.
*
* @description
* Uses quadratic Bezier curve for natural movement
*/
^F1:: {
    ToolTip("Quadratic Bezier curve movement...")

    ; Define curve points
    p0X := 200, p0Y := 200  ; Start point
    p1X := 500, p1Y := 100  ; Control point
    p2X := 800, p2Y := 200  ; End point

    steps := 60

    Loop steps {
        t := A_Index / steps

        ; Quadratic Bezier formula
        x := (1-t)**2 * p0X + 2*(1-t)*t * p1X + t**2 * p2X
        y := (1-t)**2 * p0Y + 2*(1-t)*t * p1Y + t**2 * p2Y

        MouseMove(x, y, 0)
        Sleep(20)
    }

    ToolTip("Bezier curve complete!")
    Sleep(1000)
    ToolTip()
}

/**
* S-curve movement.
* Creates smooth S-shaped path.
*/
^F2:: {
    ToolTip("S-curve movement...")

    startX := 200
    endX := 800
    centerY := A_ScreenHeight // 2
    amplitude := 150
    steps := 80

    Loop steps {
        progress := A_Index / steps

        x := startX + (endX - startX) * progress

        ; Smooth S-curve using sine
        y := centerY + amplitude * Sin((progress - 0.5) * 3.14159)

        MouseMove(x, y, 0)
        Sleep(15)
    }

    ToolTip("S-curve complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Wave pattern movement.
* Moves in sine wave pattern.
*/
^F3:: {
    ToolTip("Wave pattern movement...")

    startX := 150
    endX := A_ScreenWidth - 150
    centerY := A_ScreenHeight // 2
    amplitude := 100
    frequency := 3  ; Number of waves
    steps := 100

    Loop steps {
        progress := A_Index / steps

        x := startX + (endX - startX) * progress
        y := centerY + amplitude * Sin(progress * frequency * 2 * 3.14159)

        MouseMove(x, y, 0)
        Sleep(12)
    }

    ToolTip("Wave complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 3: Circular and Spiral Animations
; ============================================================================

/**
* Perfect circle animation.
* Moves cursor in smooth circular motion.
*
* @description
* Uses parametric circle equations
*/
^F4:: {
    ToolTip("Circular animation...")

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    radius := 200
    steps := 120

    Loop steps {
        angle := (A_Index / steps) * 2 * 3.14159

        x := centerX + radius * Cos(angle)
        y := centerY + radius * Sin(angle)

        MouseMove(x, y, 0)
        Sleep(15)
    }

    ToolTip("Circle complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Expanding spiral animation.
* Creates outward spiral motion.
*/
^F5:: {
    ToolTip("Expanding spiral...")

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    maxRadius := 250
    revolutions := 4
    steps := 150

    Loop steps {
        progress := A_Index / steps
        angle := progress * revolutions * 2 * 3.14159
        radius := maxRadius * progress

        x := centerX + radius * Cos(angle)
        y := centerY + radius * Sin(angle)

        MouseMove(x, y, 0)
        Sleep(12)
    }

    ToolTip("Spiral complete!")
    Sleep(1000)
    ToolTip()
}

/**
* Lissajous curve animation.
* Creates complex figure-8 and similar patterns.
*/
^F6:: {
    ToolTip("Lissajous curve (figure-8)...")

    centerX := A_ScreenWidth // 2
    centerY := A_ScreenHeight // 2
    radiusX := 300
    radiusY := 150
    steps := 120

    Loop steps {
        t := (A_Index / steps) * 2 * 3.14159

        ; Lissajous curve: different frequencies create figure-8
        x := centerX + radiusX * Sin(t)
        y := centerY + radiusY * Sin(2 * t)

        MouseMove(x, y, 0)
        Sleep(18)
    }

    ToolTip("Lissajous complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Complex Animation Sequences
; ============================================================================

/**
* Multi-point tour with smooth transitions.
* Visits multiple points with smooth easing between each.
*
* @description
* Demonstrates chaining smooth movements
*/
^F7:: {
    ToolTip("Multi-point tour with smooth transitions...")

    ; Define tour points
    points := [
    {
        x: 200, y: 200},
        {
            x: 800, y: 200},
            {
                x: 800, y: 600},
                {
                    x: 200, y: 600},
                    {
                        x: A_ScreenWidth // 2, y: A_ScreenHeight // 2
                    }
                    ]

                    ; Visit each point with smooth movement
                    for index, point in points {
                        MouseGetPos(&currentX, &currentY)

                        ToolTip("Moving to point " index " of " points.Length "...")

                        ; Smooth movement to point
                        steps := 40
                        Loop steps {
                            progress := A_Index / steps

                            ; Ease-in-out
                            easedProgress := progress < 0.5
                            ? 2 * progress * progress
                            : 1 - (-2 * progress + 2) ** 2 / 2

                            x := currentX + (point.x - currentX) * easedProgress
                            y := currentY + (point.y - currentY) * easedProgress

                            MouseMove(x, y, 0)
                            Sleep(12)
                        }

                        Sleep(500)
                    }

                    ToolTip("Tour complete!")
                    Sleep(1000)
                    ToolTip()
                }

                /**
                * Star pattern animation.
                * Draws star shape with smooth movements.
                */
                ^F8:: {
                    ToolTip("Star pattern animation...")

                    centerX := A_ScreenWidth // 2
                    centerY := A_ScreenHeight // 2
                    outerRadius := 200
                    innerRadius := 80
                    points := 5

                    starPoints := []

                    ; Calculate star points
                    Loop points * 2 {
                        angle := (A_Index - 1) / (points * 2) * 2 * 3.14159 - 3.14159 / 2
                        radius := Mod(A_Index, 2) = 1 ? outerRadius : innerRadius

                        starPoints.Push({
                            x: centerX + radius * Cos(angle),
                            y: centerY + radius * Sin(angle)
                        })
                    }

                    ; Move through star points
                    for index, point in starPoints {
                        ToolTip("Drawing star point " index "...")

                        MouseGetPos(&currentX, &currentY)

                        steps := 25
                        Loop steps {
                            progress := A_Index / steps

                            x := currentX + (point.x - currentX) * progress
                            y := currentY + (point.y - currentY) * progress

                            MouseMove(x, y, 0)
                            Sleep(10)
                        }
                    }

                    ; Close the star
                    MouseGetPos(&currentX, &currentY)
                    steps := 25
                    Loop steps {
                        progress := A_Index / steps
                        x := currentX + (starPoints[1].x - currentX) * progress
                        y := currentY + (starPoints[1].y - currentY) * progress
                        MouseMove(x, y, 0)
                        Sleep(10)
                    }

                    ToolTip("Star complete!")
                    Sleep(1000)
                    ToolTip()
                }

                ; ============================================================================
                ; Example 5: Spring and Elastic Animations
                ; ============================================================================

                /**
                * Elastic bounce animation.
                * Overshoots target and bounces back.
                *
                * @description
                * Creates natural-feeling bounce effect
                */
                ^F9:: {
                    ToolTip("Elastic bounce animation...")

                    startX := 200
                    startY := A_ScreenHeight // 2
                    endX := 800
                    endY := A_ScreenHeight // 2
                    steps := 80

                    Loop steps {
                        progress := A_Index / steps

                        ; Elastic ease-out formula
                        if (progress = 0 || progress = 1) {
                            easedProgress := progress
                        } else {
                            c4 := (2 * 3.14159) / 3
                            easedProgress := 2 ** (-10 * progress) * Sin((progress * 10 - 0.75) * c4) + 1
                        }

                        x := startX + (endX - startX) * easedProgress
                        y := startY

                        MouseMove(x, y, 0)
                        Sleep(20)
                    }

                    ToolTip("Elastic bounce complete!")
                    Sleep(1000)
                    ToolTip()
                }

                /**
                * Back easing animation.
                * Pulls back before moving forward.
                */
                ^F10:: {
                    ToolTip("Back easing animation...")

                    startX := 200
                    startY := A_ScreenHeight // 2
                    endX := 800
                    endY := A_ScreenHeight // 2
                    steps := 60

                    Loop steps {
                        progress := A_Index / steps

                        ; Back ease-in-out
                        c1 := 1.70158
                        c2 := c1 * 1.525

                        easedProgress := progress < 0.5
                        ? ((2 * progress) ** 2 * ((c2 + 1) * 2 * progress - c2)) / 2
                        : ((2 * progress - 2) ** 2 * ((c2 + 1) * (progress * 2 - 2) + c2) + 2) / 2

                        x := startX + (endX - startX) * easedProgress
                        y := startY

                        MouseMove(x, y, 0)
                        Sleep(18)
                    }

                    ToolTip("Back easing complete!")
                    Sleep(1000)
                    ToolTip()
                }

                ; ============================================================================
                ; Example 6: Natural Movement Simulation
                ; ============================================================================

                /**
                * Human-like movement with micro-adjustments.
                * Adds slight randomness to appear more natural.
                *
                * @description
                * Simulates imperfect human mouse movement
                */
                ^F11:: {
                    ToolTip("Human-like natural movement...")

                    startX := 200
                    startY := 300
                    endX := 700
                    endY := 400
                    steps := 60

                    Loop steps {
                        progress := A_Index / steps

                        ; Ease-in-out base movement
                        easedProgress := progress < 0.5
                        ? 2 * progress * progress
                        : 1 - (-2 * progress + 2) ** 2 / 2

                        ; Add small random variations
                        jitterX := Random(-3, 3)
                        jitterY := Random(-3, 3)

                        x := startX + (endX - startX) * easedProgress + jitterX
                        y := startY + (endY - startY) * easedProgress + jitterY

                        MouseMove(x, y, 0)
                        Sleep(Random(15, 25))  ; Variable timing
                    }

                    ; Ensure we end at exact target
                    MouseMove(endX, endY, 0)

                    ToolTip("Natural movement complete!")
                    Sleep(1000)
                    ToolTip()
                }

                /**
                * Curved approach with overshoot correction.
                * Moves in arc and makes final correction.
                */
                ^F12:: {
                    ToolTip("Curved approach with correction...")

                    startX := 200
                    startY := 200
                    endX := 700
                    endY := 500
                    steps := 50

                    ; Phase 1: Curved approach
                    Loop steps {
                        progress := A_Index / steps

                        ; Arc movement
                        x := startX + (endX - startX) * progress
                        y := startY + (endY - startY) * progress

                        ; Add curve
                        curve := 100 * Sin(progress * 3.14159)
                        y += curve

                        MouseMove(x, y, 0)
                        Sleep(15)
                    }

                    Sleep(200)

                    ; Phase 2: Final correction to exact target
                    ToolTip("Final correction...")
                    MouseGetPos(&currentX, &currentY)

                    correctionSteps := 20
                    Loop correctionSteps {
                        progress := A_Index / correctionSteps

                        x := currentX + (endX - currentX) * progress
                        y := currentY + (endY - currentY) * progress

                        MouseMove(x, y, 0)
                        Sleep(10)
                    }

                    ToolTip("Curved approach complete!")
                    Sleep(1000)
                    ToolTip()
                }

                ; ============================================================================
                ; Utility Functions
                ; ============================================================================

                /**
                * Smooth move with custom easing
                *
                * @param {Number} targetX - Target X coordinate
                * @param {Number} targetY - Target Y coordinate
                * @param {String} easing - Easing type: "linear", "ease-in", "ease-out", "ease-in-out"
                * @param {Number} duration - Duration in milliseconds
                */
                SmoothMove(targetX, targetY, easing := "ease-in-out", duration := 500) {
                    MouseGetPos(&startX, &startY)

                    steps := duration // 10
                    Loop steps {
                        progress := A_Index / steps

                        ; Apply easing
                        switch easing {
                            case "linear":
                            easedProgress := progress
                            case "ease-in":
                            easedProgress := progress * progress
                            case "ease-out":
                            easedProgress := 1 - (1 - progress) * (1 - progress)
                            case "ease-in-out":
                            easedProgress := progress < 0.5
                            ? 2 * progress * progress
                            : 1 - (-2 * progress + 2) ** 2 / 2
                            default:
                            easedProgress := progress
                        }

                        x := startX + (targetX - startX) * easedProgress
                        y := startY + (targetY - startY) * easedProgress

                        MouseMove(x, y, 0)
                        Sleep(10)
                    }

                    MouseMove(targetX, targetY, 0)
                }

                ; Test utility
                !F1:: {
                    SmoothMove(A_ScreenWidth // 2, A_ScreenHeight // 2, "ease-in-out", 800)
                }

                ; ============================================================================
                ; Exit and Help
                ; ============================================================================

                Esc::ExitApp()

                F12:: {
                    helpText := "
                    (
                    MouseMove - Smooth Movement & Animation
                    ========================================

                    F1 - Linear movement
                    F2 - Ease-in (accelerate)
                    F3 - Ease-out (decelerate)
                    F4 - Ease-in-out (smooth)

                    Ctrl+F1  - Bezier curve
                    Ctrl+F2  - S-curve
                    Ctrl+F3  - Wave pattern
                    Ctrl+F4  - Circle animation
                    Ctrl+F5  - Expanding spiral
                    Ctrl+F6  - Lissajous (figure-8)
                    Ctrl+F7  - Multi-point tour
                    Ctrl+F8  - Star pattern
                    Ctrl+F9  - Elastic bounce
                    Ctrl+F10 - Back easing
                    Ctrl+F11 - Human-like movement
                    Ctrl+F12 - Curved approach

                    Alt+F1 - SmoothMove test

                    F12 - Show this help
                    ESC - Exit script
                    )"

                    MsgBox(helpText, "Smooth Movement Help")
                }
