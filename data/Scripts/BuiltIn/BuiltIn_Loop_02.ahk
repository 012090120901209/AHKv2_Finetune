#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Control Flow - Infinite Loop with Break
* ============================================================================
*
* @file BuiltIn_Loop_02.ahk
* @author AHK v2 Examples Collection
* @version 2.0.0
* @date 2024-01-15
*
* @description
* Examples included:
* 1. Infinite loop basics
* 2. Breaking out of infinite loops
* 3. Loop with exit conditions
* 4. Sentinel value patterns
* 5. User input simulation
* 6. Event loop patterns
* 7. State machine implementations
*
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Infinite Loop Basics
; ============================================================================

Example1_InfiniteLoopBasics() {
    OutputDebug("=== Example 1: Infinite Loop Basics ===`n")

    counter := 0
    Loop {
        counter++
        OutputDebug("  Iteration: " counter "`n")
        if (counter >= 5) {
            OutputDebug("  Breaking at count 5`n")
            break
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Loop with Exit Conditions
; ============================================================================

Example2_ExitConditions() {
    OutputDebug("=== Example 2: Exit Conditions ===`n")

    ; Find first number divisible by 7
    number := 1
    Loop {
        if (Mod(number, 7) = 0) {
            OutputDebug("  Found: " number " is divisible by 7`n")
            break
        }
        number++
        if (number > 100) {
            OutputDebug("  Reached limit`n")
            break
        }
    }

    ; Search in array
    values := [5, 12, 8, 23, 15, 7, 19]
    target := 23
    index := 1
    found := false

    Loop {
        if (index > values.Length) {
            break
        }
        if (values[index] = target) {
            OutputDebug("  Found " target " at index " index "`n")
            found := true
            break
        }
        index++
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Sentinel Value Patterns
; ============================================================================

Example3_SentinelValues() {
    OutputDebug("=== Example 3: Sentinel Value Patterns ===`n")

    ; Process until empty string
    items := ["apple", "banana", "cherry", "", "date"]
    index := 1

    Loop {
        if (index > items.Length) {
            break
        }

        item := items[index]
        if (item = "") {
            OutputDebug("  Encountered sentinel value (empty string)`n")
            break
        }

        OutputDebug("  Processing: " item "`n")
        index++
    }

    ; Process until negative number
    numbers := [10, 20, 30, -1, 40, 50]
    idx := 1

    Loop {
        if (idx > numbers.Length) {
            break
        }

        num := numbers[idx]
        if (num < 0) {
            OutputDebug("  Encountered sentinel: " num "`n")
            break
        }

        OutputDebug("  Number: " num "`n")
        idx++
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: User Input Simulation
; ============================================================================

Example4_UserInputSimulation() {
    OutputDebug("=== Example 4: User Input Simulation ===`n")

    ; Simulate menu system
    commands := ["help", "status", "info", "quit"]
    cmdIndex := 1

    Loop {
        if (cmdIndex > commands.Length) {
            break
        }

        command := commands[cmdIndex]
        OutputDebug("  Command: " command "`n")

        switch command {
            case "help":
            OutputDebug("    Available: help, status, info, quit`n")
            case "status":
            OutputDebug("    Status: Running`n")
            case "info":
            OutputDebug("    Info: Version 1.0`n")
            case "quit":
            OutputDebug("    Exiting...`n")
            break
            default:
            OutputDebug("    Unknown command`n")
        }

        cmdIndex++
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Event Loop Pattern
; ============================================================================

Example5_EventLoopPattern() {
    OutputDebug("=== Example 5: Event Loop Pattern ===`n")

    events := [
    Map("type", "click", "x", 100),
    Map("type", "keypress", "key", "A"),
    Map("type", "move", "x", 200),
    Map("type", "quit", "x", 0)
    ]

    eventIndex := 1
    Loop {
        if (eventIndex > events.Length) {
            break
        }

        event := events[eventIndex]
        eventType := event["type"]

        OutputDebug("  Event: " eventType "`n")

        if (eventType = "quit") {
            OutputDebug("  Quit event received`n")
            break
        }

        switch eventType {
            case "click":
            OutputDebug("    Click at x=" event["x"] "`n")
            case "keypress":
            OutputDebug("    Key: " event["key"] "`n")
            case "move":
            OutputDebug("    Move to x=" event["x"] "`n")
        }

        eventIndex++
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: State Machine Implementation
; ============================================================================

Example6_StateMachine() {
    OutputDebug("=== Example 6: State Machine ===`n")

    state := "start"
    transitions := ["process", "validate", "complete", "end"]
    stepIndex := 1

    Loop {
        OutputDebug("  State: " state "`n")

        if (state = "end") {
            OutputDebug("  Reached end state`n")
            break
        }

        if (stepIndex > transitions.Length) {
            break
        }

        action := transitions[stepIndex]

        switch state {
            case "start":
            state := (action = "process") ? "processing" : state
            case "processing":
            state := (action = "validate") ? "validating" : state
            case "validating":
            state := (action = "complete") ? "completed" : state
            case "completed":
            state := (action = "end") ? "end" : state
        }

        stepIndex++
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Real-World Applications
; ============================================================================

Example7_RealWorldApplications() {
    OutputDebug("=== Example 7: Real-World Applications ===`n")

    ; Connection retry logic
    maxRetries := 5
    retryCount := 0
    connected := false

    Loop {
        retryCount++
        OutputDebug("  Attempt " retryCount "`n")

        ; Simulate connection (succeeds on attempt 3)
        if (retryCount >= 3) {
            connected := true
            OutputDebug("  Connected!`n")
            break
        }

        if (retryCount >= maxRetries) {
            OutputDebug("  Max retries reached`n")
            break
        }

        OutputDebug("  Failed, retrying...`n")
    }

    ; Data validation loop
    attempts := 0
    maxAttempts := 3
    testValues := ["abc", "12x", "456"]
    valueIndex := 1

    Loop {
        if (valueIndex > testValues.Length or attempts >= maxAttempts) {
            break
        }

        value := testValues[valueIndex]
        attempts++

        if (IsNumber(value)) {
            OutputDebug("  Valid number: " value "`n")
            break
        } else {
            OutputDebug("  Invalid: " value " (attempt " attempts ")`n")
        }

        valueIndex++
    }

    OutputDebug("`n")
}

; Helper function
IsNumber(str) {
    return RegExMatch(str, "^\d+$")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Infinite Loop with Break`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_InfiniteLoopBasics()
    Example2_ExitConditions()
    Example3_SentinelValues()
    Example4_UserInputSimulation()
    Example5_EventLoopPattern()
    Example6_StateMachine()
    Example7_RealWorldApplications()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
