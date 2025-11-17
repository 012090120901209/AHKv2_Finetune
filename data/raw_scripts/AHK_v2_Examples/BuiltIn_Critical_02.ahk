/**
 * @file BuiltIn_Critical_02.ahk
 * @description Atomic operations and data consistency with Critical in AutoHotkey v2
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 *
 * Advanced Critical examples focusing on atomic operations, ensuring data
 * consistency, transaction safety, and complex multi-step operations that
 * must complete without interruption.
 *
 * @syntax Critical [OnOffNumeric]
 * @see https://www.autohotkey.com/docs/v2/lib/Critical.htm
 * @requires AutoHotkey v2.0+
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Atomic File Operations
; ============================================================================
/**
 * Demonstrates atomic file operations using Critical
 * Ensures file read-modify-write operations complete without interruption
 */
Example1_AtomicFileOps() {
    myGui := Gui("+AlwaysOnTop", "Example 1: Atomic File Operations")
    myGui.SetFont("s10")
    myGui.Add("Text", "w600 Center", "Atomic File Read-Modify-Write Operations")

    ; File data display
    myGui.Add("Text", "xm", "Simulated File Data:")
    fileDataBox := myGui.Add("Edit", "w600 h100 ReadOnly vFileData")

    ; Statistics
    myGui.Add("Text", "xm", "Operation Statistics:")
    statsText := myGui.Add("Text", "w600 vStats",
        "Total Operations: 0 | Successful: 0 | Conflicts: 0")

    ; Log
    myGui.Add("Text", "xm", "Operation Log:")
    logBox := myGui.Add("Edit", "w600 h250 ReadOnly vLog")

    ; Simulated file data
    static fileData := Map(
        "counter", 0,
        "lastModified", "",
        "checksum", 0
    )

    static totalOps := 0
    static successOps := 0
    static conflicts := 0

    ; Log helper
    LogOp(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(String(A_TickCount), -2)
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Update file display
    UpdateFileDisplay() {
        display := "Counter: " fileData["counter"]
                 . "`nLast Modified: " fileData["lastModified"]
                 . "`nChecksum: " fileData["checksum"]

        fileDataBox.Value := display
    }

    ; Calculate checksum (simple simulation)
    CalculateChecksum() {
        return fileData["counter"] * 37 + StrLen(fileData["lastModified"])
    }

    ; Non-atomic file update (unsafe)
    UnsafeFileUpdate(value) {
        LogOp("UNSAFE: Reading file data...")

        ; Read current data
        currentCounter := fileData["counter"]
        Sleep(50)  ; Simulate I/O delay

        ; Modify data
        LogOp("UNSAFE: Modifying data (counter + " value ")...")
        newCounter := currentCounter + value
        Sleep(50)  ; Simulate processing

        ; Write back
        LogOp("UNSAFE: Writing file data...")
        fileData["counter"] := newCounter
        fileData["lastModified"] := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        fileData["checksum"] := CalculateChecksum()

        totalOps++
        successOps++

        UpdateFileDisplay()
        UpdateStats()

        LogOp("UNSAFE: File update complete")
    }

    ; Atomic file update (safe)
    AtomicFileUpdate(value) {
        Critical  ; Begin atomic operation

        LogOp("ATOMIC: Reading file data (Critical ON)...")

        ; Read current data
        currentCounter := fileData["counter"]
        Sleep(50)  ; Simulate I/O delay

        ; Modify data
        LogOp("ATOMIC: Modifying data (counter + " value ")...")
        newCounter := currentCounter + value
        Sleep(50)  ; Simulate processing

        ; Write back
        LogOp("ATOMIC: Writing file data...")
        fileData["counter"] := newCounter
        fileData["lastModified"] := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        fileData["checksum"] := CalculateChecksum()

        totalOps++
        successOps++

        UpdateFileDisplay()
        UpdateStats()

        LogOp("ATOMIC: File update complete (Critical OFF)")

        Critical("Off")  ; End atomic operation
    }

    ; Update statistics
    UpdateStats() {
        statsText.Value := "Total Operations: " totalOps
                         . " | Successful: " successOps
                         . " | Conflicts: " conflicts
    }

    ; Test buttons
    myGui.Add("Text", "xm", "`nTest Operations:")
    unsafeTestBtn := myGui.Add("Button", "w290", "Test Unsafe (10 concurrent)")
    safeTestBtn := myGui.Add("Button", "w290 x+10", "Test Atomic (10 concurrent)")

    singleUnsafeBtn := myGui.Add("Button", "xm w290", "Single Unsafe Update (+1)")
    singleSafeBtn := myGui.Add("Button", "w290 x+10", "Single Atomic Update (+1)")

    resetBtn := myGui.Add("Button", "xm w600", "Reset File Data")

    unsafeTestBtn.OnEvent("Click", (*) => TestUnsafe())
    TestUnsafe() {
        LogOp("=== UNSAFE TEST: 10 concurrent file updates ===")
        LogOp("Expected final counter: +" (10 * 5) " = " (fileData["counter"] + 50))

        ; Simulate concurrent file operations
        Loop 10 {
            SetTimer(() => UnsafeFileUpdate(5), -1)
        }
    }

    safeTestBtn.OnEvent("Click", (*) => TestSafe())
    TestSafe() {
        LogOp("=== ATOMIC TEST: 10 concurrent file updates ===")
        LogOp("Expected final counter: +" (10 * 5) " = " (fileData["counter"] + 50))

        ; Simulate concurrent file operations with atomic protection
        Loop 10 {
            SetTimer(() => AtomicFileUpdate(5), -1)
        }
    }

    singleUnsafeBtn.OnEvent("Click", (*) => UnsafeFileUpdate(1))
    singleSafeBtn.OnEvent("Click", (*) => AtomicFileUpdate(1))

    resetBtn.OnEvent("Click", (*) => ResetFileData())
    ResetFileData() {
        fileData["counter"] := 0
        fileData["lastModified"] := ""
        fileData["checksum"] := 0

        totalOps := 0
        successOps := 0
        conflicts := 0

        UpdateFileDisplay()
        UpdateStats()

        logBox.Value := ""
        LogOp("File data reset")
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    UpdateFileDisplay()
    LogOp("Atomic File Operations demonstration ready")
}

; ============================================================================
; EXAMPLE 2: Transaction Processing
; ============================================================================
/**
 * Implements transaction-like operations with rollback capability
 * Demonstrates all-or-nothing operation semantics
 */
Example2_Transactions() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Transaction Processing")
    myGui.SetFont("s10")
    myGui.Add("Text", "w600 Center", "Atomic Transaction with Rollback")

    ; Account displays
    myGui.Add("Text", "xm", "Account Balances:")
    account1Text := myGui.Add("Text", "w290 Border vAccount1", "Account A: $1000")
    account2Text := myGui.Add("Text", "w290 x+10 Border vAccount2", "Account B: $500")

    ; Transaction status
    statusText := myGui.Add("Text", "w600 Center vStatus", "Ready")

    ; Log
    myGui.Add("Text", "xm", "Transaction Log:")
    logBox := myGui.Add("Edit", "w600 h300 ReadOnly vLog")

    static accounts := Map(
        "A", 1000,
        "B", 500
    )

    static transactionCount := 0

    ; Log helper
    LogTx(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Update account display
    UpdateAccounts() {
        account1Text.Value := "Account A: $" accounts["A"]
        account2Text.Value := "Account B: $" accounts["B"]
    }

    ; Transfer money between accounts (atomic transaction)
    AtomicTransfer(fromAccount, toAccount, amount) {
        Critical  ; Begin atomic transaction

        transactionCount++
        txId := transactionCount

        LogTx("TX #" txId ": Starting transfer $" amount " from " fromAccount " to " toAccount)

        ; Save current state for potential rollback
        savedFrom := accounts[fromAccount]
        savedTo := accounts[toAccount]

        try {
            ; Step 1: Validate balance
            if (accounts[fromAccount] < amount) {
                throw Error("Insufficient funds in account " fromAccount)
            }

            LogTx("TX #" txId ": Validation passed")
            Sleep(100)  ; Simulate processing

            ; Step 2: Debit from source
            accounts[fromAccount] -= amount
            LogTx("TX #" txId ": Debited $" amount " from " fromAccount " (new: $" accounts[fromAccount] ")")
            UpdateAccounts()
            Sleep(100)

            ; Step 3: Simulate random failure (10% chance)
            if (Random(0, 100) < 10) {
                throw Error("Network error during transfer")
            }

            ; Step 4: Credit to destination
            accounts[toAccount] += amount
            LogTx("TX #" txId ": Credited $" amount " to " toAccount " (new: $" accounts[toAccount] ")")
            UpdateAccounts()
            Sleep(100)

            ; Step 5: Commit
            LogTx("TX #" txId ": COMMITTED successfully")
            statusText.Value := "Transaction #" txId " successful"

        } catch Error as err {
            ; Rollback on error
            LogTx("TX #" txId ": ERROR - " err.Message)
            LogTx("TX #" txId ": ROLLING BACK...")

            accounts[fromAccount] := savedFrom
            accounts[toAccount] := savedTo

            UpdateAccounts()

            LogTx("TX #" txId ": ROLLBACK complete")
            statusText.Value := "Transaction #" txId " failed and rolled back"
        }

        Critical("Off")  ; End atomic transaction
    }

    ; Test controls
    myGui.Add("Text", "xm", "`nTransfer Controls:")

    myGui.Add("Text", "xs", "Amount:")
    amountEdit := myGui.Add("Edit", "w100 Number", "50")

    myGui.Add("Text", "xs", "Direction:")
    dirCombo := myGui.Add("DropDownList", "w200", ["A → B", "B → A"])
    dirCombo.Choose(1)

    transferBtn := myGui.Add("Button", "xs w200", "Execute Transfer")

    myGui.Add("Text", "xs", "`nBatch Operations:")
    batch5Btn := myGui.Add("Button", "w290", "Execute 5 Transfers")
    batch10Btn := myGui.Add("Button", "w290 x+10", "Execute 10 Transfers")

    resetBtn := myGui.Add("Button", "xs w600", "Reset Accounts")

    transferBtn.OnEvent("Click", (*) => ExecuteTransfer())
    ExecuteTransfer() {
        amount := Integer(amountEdit.Value)
        direction := dirCombo.Value

        if (direction = 1) {
            AtomicTransfer("A", "B", amount)
        } else {
            AtomicTransfer("B", "A", amount)
        }
    }

    batch5Btn.OnEvent("Click", (*) => ExecuteBatch(5))
    batch10Btn.OnEvent("Click", (*) => ExecuteBatch(10))

    ExecuteBatch(count) {
        LogTx("=== Starting batch of " count " transfers ===")

        Loop count {
            amount := Random(10, 100)
            direction := Random(0, 1)

            if (direction = 0) {
                SetTimer(() => AtomicTransfer("A", "B", amount), -(A_Index * 200))
            } else {
                SetTimer(() => AtomicTransfer("B", "A", amount), -(A_Index * 200))
            }
        }
    }

    resetBtn.OnEvent("Click", (*) => ResetAccounts())
    ResetAccounts() {
        accounts["A"] := 1000
        accounts["B"] := 500
        transactionCount := 0

        UpdateAccounts()
        logBox.Value := ""
        statusText.Value := "Accounts reset"

        LogTx("Accounts reset to initial state")
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    UpdateAccounts()
    LogTx("Transaction Processing system ready")
    LogTx("Note: ~10% of transactions will fail randomly to demonstrate rollback")
}

; ============================================================================
; EXAMPLE 3: Shared Resource Management
; ============================================================================
/**
 * Manages access to shared resources using Critical
 * Prevents concurrent access conflicts
 */
Example3_SharedResources() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Shared Resource Management")
    myGui.SetFont("s10")
    myGui.Add("Text", "w600 Center", "Atomic Shared Resource Access")

    ; Resource status
    myGui.Add("Text", "xm", "Shared Resources:")
    resource1Text := myGui.Add("Text", "w290 Border vResource1", "Resource 1: Available")
    resource2Text := myGui.Add("Text", "w290 x+10 Border vResource2", "Resource 2: Available")

    ; Statistics
    statsText := myGui.Add("Text", "w600 vStats",
        "Successful Acquisitions: 0 | Conflicts Prevented: 0")

    ; Log
    myGui.Add("Text", "xm", "Access Log:")
    logBox := myGui.Add("Edit", "w600 h300 ReadOnly vLog")

    static resources := Map(
        "R1", {locked: false, owner: "", lockTime: 0},
        "R2", {locked: false, owner: "", lockTime: 0}
    )

    static successCount := 0
    static conflictCount := 0

    ; Log helper
    LogAccess(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(String(A_TickCount), -2)
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Update resource display
    UpdateResourceDisplay() {
        r1 := resources["R1"]
        r2 := resources["R2"]

        if (r1.locked)
            resource1Text.Value := "Resource 1: LOCKED by " r1.owner
        else
            resource1Text.Value := "Resource 1: Available"

        if (r2.locked)
            resource2Text.Value := "Resource 2: LOCKED by " r2.owner
        else
            resource2Text.Value := "Resource 2: Available"

        statsText.Value := "Successful Acquisitions: " successCount
                         . " | Conflicts Prevented: " conflictCount
    }

    ; Acquire resource (atomic operation)
    AcquireResource(resourceId, ownerId) {
        Critical  ; Atomic acquisition

        resource := resources[resourceId]

        LogAccess(ownerId " attempting to acquire " resourceId "...")

        if (resource.locked) {
            conflictCount++
            LogAccess(ownerId " BLOCKED - " resourceId " locked by " resource.owner)
            UpdateResourceDisplay()
            Critical("Off")
            return false
        }

        ; Acquire lock
        resource.locked := true
        resource.owner := ownerId
        resource.lockTime := A_TickCount

        successCount++

        LogAccess(ownerId " ACQUIRED " resourceId)
        UpdateResourceDisplay()

        Critical("Off")
        return true
    }

    ; Release resource (atomic operation)
    ReleaseResource(resourceId, ownerId) {
        Critical  ; Atomic release

        resource := resources[resourceId]

        if (!resource.locked) {
            LogAccess(ownerId " tried to release unlocked " resourceId)
            Critical("Off")
            return false
        }

        if (resource.owner != ownerId) {
            LogAccess(ownerId " tried to release " resourceId " owned by " resource.owner)
            Critical("Off")
            return false
        }

        ; Release lock
        holdTime := A_TickCount - resource.lockTime
        resource.locked := false
        resource.owner := ""
        resource.lockTime := 0

        LogAccess(ownerId " RELEASED " resourceId " (held for " holdTime "ms)")
        UpdateResourceDisplay()

        Critical("Off")
        return true
    }

    ; Use resource (acquire, work, release)
    UseResource(resourceId, userId, workDuration) {
        LogAccess("=== " userId " starting resource usage ===")

        if (AcquireResource(resourceId, userId)) {
            LogAccess(userId " using " resourceId " for " workDuration "ms...")
            Sleep(workDuration)
            ReleaseResource(resourceId, userId)
        } else {
            LogAccess(userId " could not acquire " resourceId)
        }
    }

    ; Test controls
    myGui.Add("Text", "xm", "`nManual Controls:")
    acq1Btn := myGui.Add("Button", "w140", "Acquire R1")
    rel1Btn := myGui.Add("Button", "w140 x+10", "Release R1")
    acq2Btn := myGui.Add("Button", "w140 x+10", "Acquire R2")
    rel2Btn := myGui.Add("Button", "w140 x+10", "Release R2")

    myGui.Add("Text", "xm", "`nSimulation Tests:")
    test1Btn := myGui.Add("Button", "w290", "Test: Concurrent Access R1")
    test2Btn := myGui.Add("Button", "w290 x+10", "Test: Concurrent Access R2")

    resetBtn := myGui.Add("Button", "xm w600", "Reset Resources")

    static manualOwner := "Manual"

    acq1Btn.OnEvent("Click", (*) => AcquireResource("R1", manualOwner))
    rel1Btn.OnEvent("Click", (*) => ReleaseResource("R1", manualOwner))
    acq2Btn.OnEvent("Click", (*) => AcquireResource("R2", manualOwner))
    rel2Btn.OnEvent("Click", (*) => ReleaseResource("R2", manualOwner))

    test1Btn.OnEvent("Click", (*) => TestConcurrentR1())
    TestConcurrentR1() {
        LogAccess("=== CONCURRENT ACCESS TEST: Resource 1 ===")

        ; Simulate multiple processes trying to use resource simultaneously
        Loop 5 {
            userId := "Process" A_Index
            SetTimer(() => UseResource("R1", userId, 500), -(A_Index * 100))
        }
    }

    test2Btn.OnEvent("Click", (*) => TestConcurrentR2())
    TestConcurrentR2() {
        LogAccess("=== CONCURRENT ACCESS TEST: Resource 2 ===")

        ; Simulate multiple processes trying to use resource simultaneously
        Loop 5 {
            userId := "Process" A_Index
            SetTimer(() => UseResource("R2", userId, 500), -(A_Index * 100))
        }
    }

    resetBtn.OnEvent("Click", (*) => ResetResources())
    ResetResources() {
        resources["R1"].locked := false
        resources["R1"].owner := ""
        resources["R1"].lockTime := 0

        resources["R2"].locked := false
        resources["R2"].owner := ""
        resources["R2"].lockTime := 0

        successCount := 0
        conflictCount := 0

        UpdateResourceDisplay()
        logBox.Value := ""

        LogAccess("Resources reset")
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    UpdateResourceDisplay()
    LogAccess("Shared Resource Management system ready")
}

; ============================================================================
; EXAMPLE 4: State Machine with Atomic Transitions
; ============================================================================
/**
 * Implements a state machine with atomic state transitions
 * Ensures state changes are consistent and complete
 */
Example4_StateMachine() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Atomic State Machine")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "State Machine with Atomic Transitions")

    ; Current state display
    myGui.SetFont("s16 Bold")
    stateText := myGui.Add("Text", "w550 Center Border vState", "State: IDLE")
    myGui.SetFont("s10 Norm")

    ; State history
    myGui.Add("Text", "xm", "State History:")
    historyBox := myGui.Add("ListBox", "w550 h200 vHistory")

    ; Log
    myGui.Add("Text", "xm", "Transition Log:")
    logBox := myGui.Add("Edit", "w550 h150 ReadOnly vLog")

    ; State machine states
    static validStates := ["IDLE", "STARTING", "RUNNING", "PAUSED", "STOPPING", "ERROR"]

    ; Valid transitions
    static validTransitions := Map(
        "IDLE", ["STARTING"],
        "STARTING", ["RUNNING", "ERROR"],
        "RUNNING", ["PAUSED", "STOPPING", "ERROR"],
        "PAUSED", ["RUNNING", "STOPPING"],
        "STOPPING", ["IDLE", "ERROR"],
        "ERROR", ["IDLE"]
    )

    static currentState := "IDLE"
    static transitionCount := 0

    ; Log helper
    LogTransition(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 5000)
            logBox.Value := SubStr(logBox.Value, -4500)
    }

    ; Update state display
    UpdateStateDisplay() {
        stateText.Value := "State: " currentState

        ; Color-code based on state
        switch currentState {
            case "IDLE":
                stateText.SetFont("cBlue")
            case "STARTING", "STOPPING":
                stateText.SetFont("cOrange")
            case "RUNNING":
                stateText.SetFont("cGreen")
            case "PAUSED":
                stateText.SetFont("cGray")
            case "ERROR":
                stateText.SetFont("cRed")
        }
    }

    ; Atomic state transition
    AtomicTransition(newState) {
        Critical  ; Atomic state change

        transitionCount++
        LogTransition("Transition #" transitionCount " - Attempting: " currentState " → " newState)

        ; Validate transition
        validNext := validTransitions[currentState]
        isValid := false

        for state in validNext {
            if (state = newState) {
                isValid := true
                break
            }
        }

        if (!isValid) {
            LogTransition("REJECTED: Invalid transition " currentState " → " newState)
            MsgBox("Invalid transition!`n`n" currentState " → " newState " is not allowed.",
                   "Invalid Transition", "Icon!")
            Critical("Off")
            return false
        }

        ; Perform transition
        oldState := currentState
        currentState := newState

        ; Add to history
        historyBox.Add(Format("#{:03d}: {} → {}", transitionCount, oldState, newState))

        ; Auto-scroll to latest
        historyBox.Choose(historyBox.GetCount())

        UpdateStateDisplay()

        LogTransition("SUCCESS: " oldState " → " newState)

        Critical("Off")
        return true
    }

    ; Transition buttons
    myGui.Add("Text", "xm", "`nState Transitions:")
    idleBtn := myGui.Add("Button", "w90", "IDLE")
    startingBtn := myGui.Add("Button", "w90 x+5", "STARTING")
    runningBtn := myGui.Add("Button", "w90 x+5", "RUNNING")
    pausedBtn := myGui.Add("Button", "w90 x+5", "PAUSED")
    stoppingBtn := myGui.Add("Button", "w90 x+5", "STOPPING")
    errorBtn := myGui.Add("Button", "w90 x+5", "ERROR")

    ; Wire up buttons
    idleBtn.OnEvent("Click", (*) => AtomicTransition("IDLE"))
    startingBtn.OnEvent("Click", (*) => AtomicTransition("STARTING"))
    runningBtn.OnEvent("Click", (*) => AtomicTransition("RUNNING"))
    pausedBtn.OnEvent("Click", (*) => AtomicTransition("PAUSED"))
    stoppingBtn.OnEvent("Click", (*) => AtomicTransition("STOPPING"))
    errorBtn.OnEvent("Click", (*) => AtomicTransition("ERROR"))

    ; Workflow buttons
    myGui.Add("Text", "xm", "`nWorkflows:")
    normalFlowBtn := myGui.Add("Button", "w270", "Normal Flow (Start→Run→Stop)")
    errorFlowBtn := myGui.Add("Button", "w270 x+10", "Error Flow (Start→Error→Idle)")

    resetBtn := myGui.Add("Button", "xm w550", "Reset to IDLE")

    normalFlowBtn.OnEvent("Click", (*) => NormalFlow())
    NormalFlow() {
        LogTransition("=== Executing Normal Workflow ===")

        SetTimer(() => AtomicTransition("STARTING"), -500)
        SetTimer(() => AtomicTransition("RUNNING"), -1000)
        SetTimer(() => AtomicTransition("PAUSED"), -2000)
        SetTimer(() => AtomicTransition("RUNNING"), -3000)
        SetTimer(() => AtomicTransition("STOPPING"), -4000)
        SetTimer(() => AtomicTransition("IDLE"), -5000)
    }

    errorFlowBtn.OnEvent("Click", (*) => ErrorFlow())
    ErrorFlow() {
        LogTransition("=== Executing Error Workflow ===")

        SetTimer(() => AtomicTransition("STARTING"), -500)
        SetTimer(() => AtomicTransition("ERROR"), -1000)
        SetTimer(() => AtomicTransition("IDLE"), -2000)
    }

    resetBtn.OnEvent("Click", (*) => ResetStateMachine())
    ResetStateMachine() {
        currentState := "IDLE"
        transitionCount := 0
        historyBox.Delete()
        logBox.Value := ""
        UpdateStateDisplay()
        LogTransition("State machine reset to IDLE")
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    UpdateStateDisplay()
    LogTransition("Atomic State Machine initialized in IDLE state")
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "Critical Examples - Atomic Operations")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Atomic Operations")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Atomic File Operations").OnEvent("Click", (*) => Example1_AtomicFileOps())
MainMenu.Add("Button", "w450", "Example 2: Transaction Processing").OnEvent("Click", (*) => Example2_Transactions())
MainMenu.Add("Button", "w450", "Example 3: Shared Resource Management").OnEvent("Click", (*) => Example3_SharedResources())
MainMenu.Add("Button", "w450", "Example 4: Atomic State Machine").OnEvent("Click", (*) => Example4_StateMachine())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
