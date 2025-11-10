#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ObjBindMethod - Timer with Bound Method
 *
 * Demonstrates ObjBindMethod for preserving class context in callbacks.
 * Essential for GUI events, timers, and asynchronous operations.
 *
 * Source: AHK_Notes/Methods/objbindmethod.md
 */

; Create counter and start
counter := Counter()
boundFunc := counter.StartCounting()

MsgBox("Counter started.`nWill run for 5 seconds...", , "T2")

Sleep(5000)
counter.StopCounting(boundFunc)

MsgBox("Counter stopped.`nFinal count: " counter.count, , "T3")

/**
 * Counter Class
 * Demonstrates method binding with SetTimer
 */
class Counter {
    count := 0

    /**
     * Increment count (requires 'this' context)
     */
    Increment() {
        this.count++
        ToolTip("Count: " this.count)
    }

    /**
     * Start counting with timer
     * ObjBindMethod preserves 'this' context
     */
    StartCounting() {
        boundIncrement := ObjBindMethod(this, "Increment")
        SetTimer(boundIncrement, 1000)
        return boundIncrement  ; Return to stop later
    }

    /**
     * Stop counting
     */
    StopCounting(timerFunc) {
        SetTimer(timerFunc, 0)
        ToolTip()  ; Clear tooltip
    }
}

/*
 * Key Concepts:
 *
 * 1. Method Binding Problem:
 *    SetTimer(this.Increment, 1000)  ; ✗ Loses 'this' context
 *    SetTimer(ObjBindMethod(this, "Increment"), 1000)  ; ✓ Works
 *
 * 2. ObjBindMethod:
 *    - Creates a bound function object
 *    - Preserves 'this' reference
 *    - Can pre-fill parameters
 *
 * 3. Common Use Cases:
 *    - SetTimer with class methods
 *    - GUI event handlers
 *    - Callbacks with context
 *
 * 4. Syntax:
 *    ObjBindMethod(obj, "MethodName", param1, param2, ...)
 *    Pre-filled params come before callback params
 */
