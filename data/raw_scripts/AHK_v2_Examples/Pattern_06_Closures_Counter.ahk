#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Closures Pattern - Counter Factory
 *
 * Demonstrates closures with a counter factory that creates
 * independent counter objects with private state.
 *
 * Source: AHK_Notes/Patterns/closures-in-ahk-v2.md
 */

; Create two independent counters
MsgBox("Creating two independent counters...`n`n"
     . "Counter A starts at 10`n"
     . "Counter B starts at 100", , "T3")

counterA := CreateCounter(10)
counterB := CreateCounter(100)

; Test Counter A
counterA.Increment()
counterA.Increment()
valueA := counterA.GetValue()

MsgBox("Counter A:`n"
     . "Incremented twice`n"
     . "Current value: " valueA, , "T3")

; Test Counter B
counterB.Increment()
valueB := counterB.GetValue()

MsgBox("Counter B:`n"
     . "Incremented once`n"
     . "Current value: " valueB, , "T3")

; Demonstrate independent state
counterA.Increment()
counterB.Decrement()
counterB.Decrement()

MsgBox("After more operations:`n`n"
     . "Counter A: " counterA.GetValue() "`n"
     . "Counter B: " counterB.GetValue(), , "T3")

/**
 * CreateCounter - Function Factory
 *
 * Creates a counter object with private state.
 * Each counter maintains independent state via closure.
 *
 * @param startValue - Initial counter value
 * @return Object with increment/decrement/get/reset methods
 */
CreateCounter(startValue := 0) {
    ; Private variable (captured in closure)
    currentValue := startValue

    ; Return object with methods that close over currentValue
    counter := {
        Increment: () => ++currentValue,
        Decrement: () => --currentValue,
        GetValue: () => currentValue,
        Reset: (newStart := 0) => (currentValue := newStart)
    }

    return counter
}

/*
 * Key Concepts:
 *
 * 1. Closure Fundamentals:
 *    - Inner functions capture outer scope variables
 *    - Captured variables persist after outer function returns
 *    - Each function call creates independent closure
 *
 * 2. Private State:
 *    currentValue is private to each counter
 *    - Not directly accessible from outside
 *    - Only accessible via methods
 *    - Each counter has its own currentValue
 *
 * 3. Function Factory Pattern:
 *    CreateCounter() returns a new object each time
 *    Each object has independent state
 *    Each object shares the same method implementations
 *
 * 4. Closure Scope Chain:
 *
 *    CreateCounter(10) called:
 *    ┌──────────────────────────┐
 *    │ currentValue = 10        │  ← Outer scope
 *    │ ┌──────────────────────┐ │
 *    │ │ Increment: () =>     │ │  ← Inner scope
 *    │ │   ++currentValue     │ │     (closes over currentValue)
 *    │ └──────────────────────┘ │
 *    └──────────────────────────┘
 *
 * 5. Variable Capture by Reference:
 *    - Closures capture by REFERENCE, not value
 *    - All methods share same currentValue variable
 *    - Changes persist across method calls
 *
 * 6. Use Cases:
 *
 *    Private Variables:
 *    - Encapsulation without classes
 *    - Data hiding
 *    - Implementation privacy
 *
 *    State Management:
 *    - Independent counters, timers
 *    - Configuration objects
 *    - UI state management
 *
 *    Event Handlers:
 *    - Preserve context in callbacks
 *    - Button-specific data
 *    - Connection pooling
 *
 * 7. Memory Lifecycle:
 *    - currentValue exists as long as counter exists
 *    - Garbage collected when counter is destroyed
 *    - Each counter maintains separate memory
 *
 * 8. Comparison with Classes:
 *
 *    Class Approach:
 *    class Counter {
 *        Value := 0
 *        __New(start) => this.Value := start
 *        Increment() => ++this.Value
 *    }
 *
 *    Closure Approach:
 *    CreateCounter(start) {
 *        value := start
 *        return {Increment: () => ++value}
 *    }
 *
 * 9. Benefits of Closure Approach:
 *    ✅ True privacy (no property access)
 *    ✅ Lightweight (no class overhead)
 *    ✅ Flexible (dynamic method generation)
 *    ✅ Functional programming style
 *
 * 10. Limitations:
 *     ⚠️  No inheritance
 *     ⚠️  No instanceof checks
 *     ⚠️  Slightly more memory per instance
 *     ⚠️  Harder to debug (hidden state)
 */
