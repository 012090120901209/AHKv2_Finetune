#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_Critical_01.ahk
 * @description Thread safety and interruption control with Critical in AutoHotkey v2
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Critical prevents the current thread from being interrupted by other threads.
 * Essential for ensuring atomic operations, data consistency, and preventing
 * race conditions in multi-threaded automation scenarios.
 * 
 * @syntax Critical [OnOffNumeric]
 * @param OnOffNumeric - "On", "Off", or period in milliseconds (default: On)
 * 
 * @see https://www.autohotkey.com/docs/v2/lib/Critical.htm
 * @requires AutoHotkey v2.0+
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Basic Critical Protection
; ============================================================================
/**
 * Demonstrates basic Critical usage to prevent interruptions
 * Shows difference between protected and unprotected code
 */
Example1_BasicCritical() {
    myGui := Gui("+AlwaysOnTop", "Example 1: Basic Critical Protection")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Thread Interruption Protection")

    ; Status displays
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
    counterText := myGui.Add("Text", "w550 Center vCounter", "Operation Counter: 0")

    ; Log
    myGui.Add("Text", "xm", "Execution Log:")
    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

    static operationCounter := 0

    ; Log helper
    LogMsg(msg) {
        timestamp := A_TickCount
        currentLog := logBox.Value
        logBox.Value := currentLog . Format("{:06d}ms", timestamp) . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 10000)
            logBox.Value := SubStr(logBox.Value, -9000)
    }

    ; Unprotected operation (can be interrupted)
    UnprotectedOperation() {
        LogMsg("UNPROTECTED: Starting operation...")
        statusText.Value := "Running unprotected operation"

        ; Simulate multi-step operation
        Loop 5 {
            LogMsg("UNPROTECTED: Step " A_Index "/5")
            Sleep(100)
        }

        operationCounter++
        counterText.Value := "Operation Counter: " operationCounter

        LogMsg("UNPROTECTED: Operation complete")
        statusText.Value := "Unprotected operation complete"
    }

    ; Protected operation (cannot be interrupted)
    ProtectedOperation() {
        Critical  ; Enable Critical mode

        LogMsg("PROTECTED: Starting critical operation...")
        statusText.Value := "Running protected operation (Critical ON)"

        ; Simulate multi-step operation
        Loop 5 {
            LogMsg("PROTECTED: Step " A_Index "/5")
            Sleep(100)
        }

        operationCounter++
        counterText.Value := "Operation Counter: " operationCounter

        LogMsg("PROTECTED: Critical operation complete")
        statusText.Value := "Protected operation complete"

        Critical("Off")  ; Disable Critical mode
    }

    ; Interrupter hotkey simulation
    InterruptAttempt() {
        LogMsg(">>> INTERRUPT ATTEMPT! <<<")
        statusText.Value := "Attempted interruption!"
    }

    ; Control buttons
    unprotectedBtn := myGui.Add("Button", "xm w170", "Unprotected Operation")
    protectedBtn := myGui.Add("Button", "w170 x+10", "Protected Operation")
    interruptBtn := myGui.Add("Button", "w170 x+10", "Try Interrupt")

    myGui.Add("Text", "xm", "`nTest Scenarios:")
    test1Btn := myGui.Add("Button", "w270", "Test: Unprotected + Interrupt")
    test2Btn := myGui.Add("Button", "w270 x+10", "Test: Protected + Interrupt")

    clearBtn := myGui.Add("Button", "xm w550", "Clear Log")

    ; Button handlers
    unprotectedBtn.OnEvent("Click", (*) => UnprotectedOperation())
    protectedBtn.OnEvent("Click", (*) => ProtectedOperation())
    interruptBtn.OnEvent("Click", (*) => InterruptAttempt())

    ; Test scenarios
    test1Btn.OnEvent("Click", (*) => TestUnprotected())
    TestUnprotected() {
        LogMsg("=== TEST: Unprotected Operation with Interrupts ===")

        ; Start unprotected operation
        UnprotectedOperation()

        ; Try interrupting during execution
        SetTimer(() => InterruptAttempt(), -50)
        SetTimer(() => InterruptAttempt(), -150)
        SetTimer(() => InterruptAttempt(), -250)
    }

    test2Btn.OnEvent("Click", (*) => TestProtected())
    TestProtected() {
        LogMsg("=== TEST: Protected Operation with Interrupts ===")

        ; Schedule interrupt attempts
        SetTimer(() => InterruptAttempt(), -50)
        SetTimer(() => InterruptAttempt(), -150)
        SetTimer(() => InterruptAttempt(), -250)

        ; Start protected operation (interrupts will be blocked)
        ProtectedOperation()

        LogMsg("Note: Interrupts were blocked during Critical section")
    }

    clearBtn.OnEvent("Click", (*) => ClearLog())
    ClearLog() {
        logBox.Value := ""
        operationCounter := 0
        counterText.Value := "Operation Counter: 0"
        statusText.Value := "Ready"
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogMsg("Critical Protection demonstration ready")
    LogMsg("Try running operations and attempting to interrupt them")
}

; ============================================================================
; EXAMPLE 2: Race Condition Prevention
; ============================================================================
/**
 * Demonstrates how Critical prevents race conditions
 * Shows data corruption without Critical and safety with it
 */
Example2_RaceConditions() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Race Condition Prevention")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Preventing Race Conditions")

    ; Shared data display
    myGui.Add("Text", "xm", "Shared Data State:")
    dataText := myGui.Add("Text", "w550 h60 Border vData", "Account Balance: $0`nTransactions: 0`nErrors: 0")

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")

    ; Log
    myGui.Add("Text", "xm", "Transaction Log:")
    logBox := myGui.Add("Edit", "w550 h250 ReadOnly vLog")

    static accountBalance := 0
    static transactionCount := 0
    static errorCount := 0

    ; Log helper
    LogTransaction(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(String(A_TickCount), -2)
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Update display
    UpdateDisplay() {
        dataText.Value := "Account Balance: $" accountBalance
            . "`nTransactions: " transactionCount
            . "`nErrors: " errorCount
    }

    ; Unsafe deposit (no Critical)
    UnsafeDeposit(amount) {
        LogTransaction("UNSAFE DEPOSIT: Reading balance...")
        currentBalance := accountBalance

        ; Simulate processing delay
        Sleep(10)

        LogTransaction("UNSAFE DEPOSIT: Adding $" amount "...")
        newBalance := currentBalance + amount

        ; More processing delay
        Sleep(10)

        accountBalance := newBalance
        transactionCount++

        LogTransaction("UNSAFE DEPOSIT: Complete. New balance: $" accountBalance)
        UpdateDisplay()
    }

    ; Safe deposit (with Critical)
    SafeDeposit(amount) {
        Critical  ; Start atomic operation

        LogTransaction("SAFE DEPOSIT: Reading balance (Critical ON)...")
        currentBalance := accountBalance

        ; Simulate processing delay
        Sleep(10)

        LogTransaction("SAFE DEPOSIT: Adding $" amount "...")
        newBalance := currentBalance + amount

        ; More processing delay
        Sleep(10)

        accountBalance := newBalance
        transactionCount++

        LogTransaction("SAFE DEPOSIT: Complete. New balance: $" accountBalance)
        UpdateDisplay()

        Critical("Off")
    }

    ; Test concurrent unsafe operations
    testUnsafeBtn := myGui.Add("Button", "xm w270", "Test Unsafe (Race Condition)")
    testSafeBtn := myGui.Add("Button", "w270 x+10", "Test Safe (Critical)")

    resetBtn := myGui.Add("Button", "xm w550", "Reset Account")

    testUnsafeBtn.OnEvent("Click", (*) => TestUnsafe())
    TestUnsafe() {
        LogTransaction("=== UNSAFE TEST: Multiple concurrent deposits ===")
        LogTransaction("Starting 5 deposits of $100 each (expected: $500)")

        statusText.Value := "Running unsafe concurrent operations..."

        ; Simulate concurrent transactions (race condition likely)
        Loop 5 {
            SetTimer(() => UnsafeDeposit(100), -1)
        }

        ; Check result after all complete
        SetTimer(() => CheckUnsafeResult(), -200)
    }

    CheckUnsafeResult() {
        expected := 500
        actual := accountBalance

        if (actual != expected) {
            errorCount++
            LogTransaction("ERROR: Expected $" expected ", got $" actual " (lost $" (expected - actual) ")")
            statusText.Value := "Race condition detected! Data corrupted."
        } else {
            LogTransaction("SUCCESS: Balance correct at $" actual)
            statusText.Value := "No race condition this time (got lucky!)"
        }

        UpdateDisplay()
    }

    testSafeBtn.OnEvent("Click", (*) => TestSafe())
    TestSafe() {
        LogTransaction("=== SAFE TEST: Multiple concurrent deposits with Critical ===")
        LogTransaction("Starting 5 deposits of $100 each (expected: $500)")

        statusText.Value := "Running safe concurrent operations..."

        ; Simulate concurrent transactions (protected by Critical)
        Loop 5 {
            SetTimer(() => SafeDeposit(100), -1)
        }

        ; Check result after all complete
        SetTimer(() => CheckSafeResult(), -200)
    }

    CheckSafeResult() {
        expected := 500
        actual := accountBalance

        if (actual != expected) {
            errorCount++
            LogTransaction("ERROR: Expected $" expected ", got $" actual)
            statusText.Value := "Unexpected error!"
        } else {
            LogTransaction("SUCCESS: Balance correct at $" actual)
            statusText.Value := "Critical protection worked! Data safe."
        }

        UpdateDisplay()
    }

    resetBtn.OnEvent("Click", (*) => ResetAccount())
    ResetAccount() {
        accountBalance := 0
        transactionCount := 0
        errorCount := 0
        UpdateDisplay()
        logBox.Value := ""
        statusText.Value := "Account reset"
        LogTransaction("Account reset to $0")
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    UpdateDisplay()
    LogTransaction("Race Condition demonstration ready")
}

; ============================================================================
; EXAMPLE 3: Critical with Timeout
; ============================================================================
/**
 * Demonstrates Critical with timeout values
 * Shows how to limit critical section duration
 */
Example3_CriticalTimeout() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Critical with Timeout")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Critical Section with Timeout Control")

    ; Configuration
    myGui.Add("Text", "xm", "Critical Timeout (milliseconds):")
    timeoutEdit := myGui.Add("Edit", "w100 Number", "1000")
    myGui.Add("UpDown", "Range0-10000", 1000)
    myGui.Add("Text", "x+10", "(0 = infinite, >0 = timeout after N ms)")

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")

    ; Log
    myGui.Add("Text", "xm", "Execution Log:")
    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

    ; Log helper
    LogMsg(msg) {
        timestamp := A_TickCount
        currentLog := logBox.Value
        logBox.Value := currentLog . Format("{:06d}ms", timestamp) . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Long operation with Critical timeout
    LongOperationWithTimeout(timeoutMs) {
        if (timeoutMs = 0) {
            Critical  ; Infinite
            LogMsg("Critical enabled: INFINITE timeout")
        } else {
            Critical(timeoutMs)
            LogMsg("Critical enabled: " timeoutMs "ms timeout")
        }

        statusText.Value := "Running long operation..."
        LogMsg("Starting 3-second operation...")

        ; Long operation (3 seconds)
        Loop 30 {
            LogMsg("Working... step " A_Index "/30")
            Sleep(100)
        }

        LogMsg("Long operation complete")
        statusText.Value := "Operation complete"

        Critical("Off")
        LogMsg("Critical disabled")
    }

    ; Interrupt attempt
    InterruptCheck() {
        LogMsg(">>> Interrupt check executed <<<")
    }

    ; Test buttons
    myGui.Add("Text", "xm", "`nTest Scenarios:")
    testNoTimeoutBtn := myGui.Add("Button", "w270", "Test: No Timeout")
    testShortTimeoutBtn := myGui.Add("Button", "w270 x+10", "Test: Short Timeout (500ms)")
    testLongTimeoutBtn := myGui.Add("Button", "w270 xm", "Test: Long Timeout (5000ms)")
    testCustomBtn := myGui.Add("Button", "w270 x+10", "Test: Custom Timeout")

    clearBtn := myGui.Add("Button", "xm w550", "Clear Log")

    ; No timeout test
    testNoTimeoutBtn.OnEvent("Click", (*) => TestNoTimeout())
    TestNoTimeout() {
        LogMsg("=== TEST: Critical with No Timeout (Infinite) ===")

        ; Schedule interrupt attempts
        Loop 10 {
            delay := A_Index * 300
            SetTimer(() => InterruptCheck(), -delay)
        }

        LongOperationWithTimeout(0)
        LogMsg("Note: All interrupts were blocked for entire duration")
    }

    ; Short timeout test
    testShortTimeoutBtn.OnEvent("Click", (*) => TestShortTimeout())
    TestShortTimeout() {
        LogMsg("=== TEST: Critical with 500ms Timeout ===")

        ; Schedule interrupt attempts
        Loop 10 {
            delay := A_Index * 300
            SetTimer(() => InterruptCheck(), -delay)
        }

        LongOperationWithTimeout(500)
        LogMsg("Note: Interrupts blocked for first 500ms, then allowed")
    }

    ; Long timeout test
    testLongTimeoutBtn.OnEvent("Click", (*) => TestLongTimeout())
    TestLongTimeout() {
        LogMsg("=== TEST: Critical with 5000ms Timeout ===")

        ; Schedule interrupt attempts
        Loop 10 {
            delay := A_Index * 300
            SetTimer(() => InterruptCheck(), -delay)
        }

        LongOperationWithTimeout(5000)
        LogMsg("Note: All interrupts blocked (operation < timeout)")
    }

    ; Custom timeout test
    testCustomBtn.OnEvent("Click", (*) => TestCustom())
    TestCustom() {
        timeout := Integer(timeoutEdit.Value)

        LogMsg("=== TEST: Critical with " timeout "ms Timeout ===")

        ; Schedule interrupt attempts
        Loop 10 {
            delay := A_Index * 300
            SetTimer(() => InterruptCheck(), -delay)
        }

        LongOperationWithTimeout(timeout)
    }

    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogMsg("Critical Timeout demonstration ready")
}

; ============================================================================
; EXAMPLE 4: Message Queue Buffering
; ============================================================================
/**
 * Demonstrates how Critical affects message queue
 * Shows message buffering during critical sections
 */
Example4_MessageQueue() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Message Queue Buffering")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Critical and Message Queue Behavior")

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
    queueText := myGui.Add("Text", "w550 Center vQueue", "Buffered Messages: 0")

    ; Log
    myGui.Add("Text", "xm", "Message Log:")
    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

    static messageCount := 0

    ; Log helper
    LogMsg(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(String(A_TickCount), -2)
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Simulated message handler
    HandleMessage(msgNum) {
        messageCount++
        queueText.Value := "Processed Messages: " messageCount
        LogMsg("Message #" msgNum " processed")
    }

    ; Critical operation that buffers messages
    CriticalWithBuffering() {
        Critical

        LogMsg("=== Critical section started ===")
        LogMsg("Messages will be buffered during this time")
        statusText.Value := "Critical section active - buffering messages"

        ; Long operation
        Loop 5 {
            LogMsg("Critical operation step " A_Index "/5")
            Sleep(500)
        }

        LogMsg("=== Critical section ending ===")
        statusText.Value := "Critical section complete - processing buffered messages"

        Critical("Off")

        LogMsg("Critical disabled - buffered messages now processing")
    }

    ; Send test messages
    SendTestMessages() {
        LogMsg("Sending 10 test messages...")

        Loop 10 {
            msgNum := A_Index
            SetTimer(() => HandleMessage(msgNum), -1)
            Sleep(100)
        }

        LogMsg("All 10 messages sent")
    }

    ; Test buttons
    testBtn := myGui.Add("Button", "xm w270", "Test Message Buffering")
    messagesBtn := myGui.Add("Button", "w270 x+10", "Send Test Messages")
    resetBtn := myGui.Add("Button", "xm w270", "Reset Counter")
    clearBtn := myGui.Add("Button", "w270 x+10", "Clear Log")

    testBtn.OnEvent("Click", (*) => TestBuffering())
    TestBuffering() {
        LogMsg("=== Starting Message Buffering Test ===")

        ; Start sending messages
        SetTimer(() => SendTestMessages(), -100)

        ; Start critical operation (will buffer messages)
        Sleep(50)  ; Small delay to ensure messages start
        CriticalWithBuffering()
    }

    messagesBtn.OnEvent("Click", (*) => SendTestMessages())

    resetBtn.OnEvent("Click", (*) => ResetCounter())
    ResetCounter() {
        messageCount := 0
        queueText.Value := "Processed Messages: 0"
        LogMsg("Counter reset")
    }

    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogMsg("Message Queue Buffering demonstration ready")
}

; ============================================================================
; EXAMPLE 5: Nested Critical Sections
; ============================================================================
/**
 * Demonstrates nested Critical calls
 * Shows how Critical nesting works
 */
Example5_NestedCritical() {
    myGui := Gui("+AlwaysOnTop", "Example 5: Nested Critical Sections")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Nested Critical Section Behavior")

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
    depthText := myGui.Add("Text", "w550 Center vDepth", "Critical Depth: 0")

    ; Log
    myGui.Add("Text", "xm", "Execution Log:")
    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

    static criticalDepth := 0

    ; Log helper
    LogMsg(msg) {
        indent := ""
        Loop criticalDepth
            indent .= "  "

        timestamp := A_TickCount
        currentLog := logBox.Value
        logBox.Value := currentLog . Format("{:06d}ms", timestamp) . " " . indent . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Nested function level 1
    Level1Critical() {
        Critical
        criticalDepth++
        depthText.Value := "Critical Depth: " criticalDepth

        LogMsg("→ Level 1 Critical START")
        Sleep(100)

        Level2Critical()  ; Call nested critical

        Sleep(100)
        LogMsg("← Level 1 Critical END")

        criticalDepth--
        depthText.Value := "Critical Depth: " criticalDepth
        Critical("Off")
    }

    ; Nested function level 2
    Level2Critical() {
        Critical
        criticalDepth++
        depthText.Value := "Critical Depth: " criticalDepth

        LogMsg("→ Level 2 Critical START")
        Sleep(100)

        Level3Critical()  ; Call deeply nested critical

        Sleep(100)
        LogMsg("← Level 2 Critical END")

        criticalDepth--
        depthText.Value := "Critical Depth: " criticalDepth
        Critical("Off")
    }

    ; Nested function level 3
    Level3Critical() {
        Critical
        criticalDepth++
        depthText.Value := "Critical Depth: " criticalDepth

        LogMsg("→ Level 3 Critical START (deepest level)")
        Sleep(200)
        LogMsg("← Level 3 Critical END")

        criticalDepth--
        depthText.Value := "Critical Depth: " criticalDepth
        Critical("Off")
    }

    ; Test buttons
    testNestedBtn := myGui.Add("Button", "xm w270", "Test Nested Critical")
    interruptBtn := myGui.Add("Button", "w270 x+10", "Try Interrupt")
    clearBtn := myGui.Add("Button", "xm w550", "Clear Log")

    testNestedBtn.OnEvent("Click", (*) => TestNested())
    TestNested() {
        LogMsg("=== Testing Nested Critical Sections ===")
        statusText.Value := "Running nested critical sections..."

        ; Schedule interrupt attempts
        Loop 10 {
            delay := A_Index * 100
            SetTimer(() => AttemptInterrupt(), -delay)
        }

        Level1Critical()

        statusText.Value := "Nested critical sections complete"
        LogMsg("=== All Critical sections exited ===")
    }

    AttemptInterrupt() {
        LogMsg(">>> INTERRUPT ATTEMPT (will be blocked) <<<")
    }

    interruptBtn.OnEvent("Click", (*) => AttemptInterrupt())
    clearBtn.OnEvent("Click", (*) => ClearLog())

    ClearLog() {
        logBox.Value := ""
        criticalDepth := 0
        depthText.Value := "Critical Depth: 0"
        statusText.Value := "Ready"
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogMsg("Nested Critical demonstration ready")
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "Critical Examples - Thread Safety")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Critical Thread Safety")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Basic Critical Protection").OnEvent("Click", (*) => Example1_BasicCritical())
MainMenu.Add("Button", "w450", "Example 2: Race Condition Prevention").OnEvent("Click", (*) => Example2_RaceConditions())
MainMenu.Add("Button", "w450", "Example 3: Critical with Timeout").OnEvent("Click", (*) => Example3_CriticalTimeout())
MainMenu.Add("Button", "w450", "Example 4: Message Queue Buffering").OnEvent("Click", (*) => Example4_MessageQueue())
MainMenu.Add("Button", "w450", "Example 5: Nested Critical Sections").OnEvent("Click", (*) => Example5_NestedCritical())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
