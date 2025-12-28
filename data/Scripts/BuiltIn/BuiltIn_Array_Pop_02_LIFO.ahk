#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Pop() - LIFO (Last-In-First-Out) Processing
 * ============================================================================
 * 
 * This file demonstrates LIFO processing patterns using Pop(). LIFO is
 * fundamental to stack-based operations where the most recently added
 * item is processed first.
 * 
 * @description LIFO processing techniques using Array.Pop()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Basic LIFO Task Processing
; ============================================================================
; Process tasks in reverse order of addition
Example1_BasicLIFOTasks() {
    OutputDebug("=== Example 1: Basic LIFO Task Processing ===`n")

    ; Task queue
    taskQueue := []

    ; Add tasks
    taskQueue.Push({ id: 1, name: "Initialize system", priority: "low" })
    taskQueue.Push({ id: 2, name: "Load configuration", priority: "medium" })
    taskQueue.Push({ id: 3, name: "Connect to database", priority: "high" })
    taskQueue.Push({ id: 4, name: "Start services", priority: "critical" })

    OutputDebug("Tasks added (LIFO order): " taskQueue.Length "`n`n")

    ; Process tasks (most recent first)
    processedCount := 0
    while (taskQueue.Length > 0) {
        task := taskQueue.Pop()
        processedCount++

        OutputDebug("Processing Task #" processedCount ":`n")
        OutputDebug("  ID: " task.id "`n")
        OutputDebug("  Name: " task.name "`n")
        OutputDebug("  Priority: " task.priority "`n")
        OutputDebug("  Remaining tasks: " taskQueue.Length "`n`n")
    }

    OutputDebug("All tasks processed!`n`n")
}

; ============================================================================
; Example 2: Command History Navigation
; ============================================================================
; Navigate through command history like a terminal
Example2_CommandHistory() {
    OutputDebug("=== Example 2: Command History Navigation ===`n")

    history := []
    currentPosition := 0

    ; Execute commands (add to history)
    ExecuteCommand(history, "ls -la")
    ExecuteCommand(history, "cd /home/user")
    ExecuteCommand(history, "git status")
    ExecuteCommand(history, "npm install")
    ExecuteCommand(history, "git commit -m 'Update'")

    OutputDebug("Command history size: " history.Length "`n`n")

    ; Navigate up through history (LIFO)
    OutputDebug("Navigating up through history (most recent first):`n")
    tempHistory := history.Clone()

    Loop Min(3, tempHistory.Length) {
        cmd := tempHistory.Pop()
        OutputDebug("  Previous command: " cmd "`n")
    }

    ; Show remaining history
    OutputDebug("`nRemaining history entries: " tempHistory.Length "`n`n")
}

; ============================================================================
; Example 3: Browser Back Stack
; ============================================================================
; Implement browser-like navigation
Example3_BrowserNavigation() {
    OutputDebug("=== Example 3: Browser Navigation ===`n")

    visitedPages := []
    currentPage := "Home"

    ; Navigate to pages
    OutputDebug("Navigation sequence:`n")

    VisitPage(visitedPages, currentPage, "Products")
    currentPage := "Products"

    VisitPage(visitedPages, currentPage, "Product Details")
    currentPage := "Product Details"

    VisitPage(visitedPages, currentPage, "Shopping Cart")
    currentPage := "Shopping Cart"

    VisitPage(visitedPages, currentPage, "Checkout")
    currentPage := "Checkout"

    OutputDebug("`nCurrent page: " currentPage "`n")
    OutputDebug("Pages in history: " visitedPages.Length "`n`n")

    ; Go back (LIFO)
    OutputDebug("Going back through pages:`n")
    backCount := 0

    while (visitedPages.Length > 0 && backCount < 2) {
        previousPage := visitedPages.Pop()
        OutputDebug("  Back to: " previousPage "`n")
        currentPage := previousPage
        backCount++
    }

    OutputDebug("`nNow on page: " currentPage "`n")
    OutputDebug("Can go back: " (visitedPages.Length > 0 ? "Yes" : "No") "`n`n")
}

; ============================================================================
; Example 4: Function Call Stack Trace
; ============================================================================
; Simulate function call stack unwinding
Example4_StackTrace() {
    OutputDebug("=== Example 4: Function Call Stack Trace ===`n")

    callStack := []

    ; Simulate nested function calls
    OutputDebug("Building call stack:`n")

    callStack.Push({ function: "main", file: "app.ahk", line: 1 })
    OutputDebug("  CALL: main() at app.ahk:1`n")

    callStack.Push({ function: "processRequest", file: "app.ahk", line: 45 })
    OutputDebug("  CALL: processRequest() at app.ahk:45`n")

    callStack.Push({ function: "validateData", file: "validator.ahk", line: 12 })
    OutputDebug("  CALL: validateData() at validator.ahk:12`n")

    callStack.Push({ function: "checkSchema", file: "validator.ahk", line: 78 })
    OutputDebug("  CALL: checkSchema() at validator.ahk:78`n")

    callStack.Push({ function: "parseJSON", file: "parser.ahk", line: 23 })
    OutputDebug("  CALL: parseJSON() at parser.ahk:23`n")

    ; Simulate error and stack unwinding
    OutputDebug("`nError occurred! Unwinding stack (LIFO):`n")

    while (callStack.Length > 0) {
        frame := callStack.Pop()
        OutputDebug("  RETURN from: " frame.function "() at "
            frame.file ":" frame.line "`n")
    }

    OutputDebug("`nStack unwound completely.`n`n")
}

; ============================================================================
; Example 5: Nested Transaction Rollback
; ============================================================================
; Rollback nested transactions in reverse order
Example5_TransactionRollback() {
    OutputDebug("=== Example 5: Nested Transaction Rollback ===`n")

    transactions := []

    ; Begin nested transactions
    OutputDebug("Beginning transactions:`n")

    BeginTransaction(transactions, "UPDATE users SET active=1")
    BeginTransaction(transactions, "INSERT INTO logs VALUES ('action1')")
    BeginTransaction(transactions, "UPDATE settings SET theme='dark'")
    BeginTransaction(transactions, "DELETE FROM cache")

    OutputDebug("`nActive transactions: " transactions.Length "`n`n")

    ; Rollback all (LIFO - most recent first)
    OutputDebug("Rolling back transactions (LIFO):`n")

    rolledBack := 0
    while (transactions.Length > 0) {
        transaction := transactions.Pop()
        rolledBack++

        OutputDebug("  Rollback #" rolledBack ":`n")
        OutputDebug("    SQL: " transaction.sql "`n")
        OutputDebug("    Started: " transaction.timestamp "`n")
        OutputDebug("    Remaining: " transactions.Length "`n`n")
    }

    OutputDebug("All transactions rolled back!`n`n")
}

; ============================================================================
; Example 6: Plate Stacking Simulation
; ============================================================================
; Simulate physical plate stacking (LIFO)
Example6_PlateStacking() {
    OutputDebug("=== Example 6: Plate Stacking Simulation ===`n")

    plateStack := []

    ; Stack plates
    OutputDebug("Stacking plates:`n")

    plates := ["Blue Plate", "Red Plate", "Green Plate", "Yellow Plate", "White Plate"]

    for plate in plates {
        plateStack.Push(plate)
        OutputDebug("  Stacked: " plate " (Total: " plateStack.Length ")`n")
    }

    ; Remove plates (take from top - LIFO)
    OutputDebug("`nRemoving plates from top:`n")

    removeCount := 3
    Loop removeCount {
        if (plateStack.Length = 0) {
            break
        }

        plate := plateStack.Pop()
        OutputDebug("  Removed: " plate " (Remaining: " plateStack.Length ")`n")
    }

    OutputDebug("`nPlates still stacked: " plateStack.Length "`n")

    ; Show bottom plate (first added)
    if (plateStack.Length > 0) {
        OutputDebug("Bottom plate: " plateStack[1] "`n")
        OutputDebug("Top plate: " plateStack[plateStack.Length] "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Recursive Operation Unwinding
; ============================================================================
; Simulate recursive operation results processed in reverse
Example7_RecursiveUnwinding() {
    OutputDebug("=== Example 7: Recursive Operation Unwinding ===`n")

    ; Simulate factorial calculation with explicit stack
    resultStack := []
    number := 5

    ; Build up the multiplications
    OutputDebug("Building factorial(" number ") stack:`n")

    current := number
    while (current > 0) {
        resultStack.Push(current)
        OutputDebug("  Push: " current " (Stack size: " resultStack.Length ")`n")
        current--
    }

    ; Calculate result by popping (LIFO)
    OutputDebug("`nCalculating result (LIFO):`n")

    result := 1
    step := 0

    while (resultStack.Length > 0) {
        value := resultStack.Pop()
        result *= value
        step++

        OutputDebug("  Step " step ": " result " (multiplied by " value ")`n")
    }

    OutputDebug("`nFinal result: " number "! = " result "`n`n")

    ; Simulate directory traversal unwinding
    OutputDebug("Directory traversal unwinding:`n")

    pathStack := []
    pathStack.Push("C:")
    pathStack.Push("Users")
    pathStack.Push("Documents")
    pathStack.Push("Projects")
    pathStack.Push("MyApp")

    OutputDebug("Full path: " Join(pathStack, "\") "`n`n")

    OutputDebug("Navigating up (LIFO):`n")

    while (pathStack.Length > 1) {  ; Keep root
        folder := pathStack.Pop()
        OutputDebug("  Left: " folder "`n")
        OutputDebug("  Now at: " Join(pathStack, "\") "`n`n")
    }
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Execute a command and add to history
 * @param {Array} history - Command history array
 * @param {String} command - Command to execute
 */
ExecuteCommand(history, command) {
    history.Push(command)
    OutputDebug("Executed: " command "`n")
}

/**
 * Visit a new page
 * @param {Array} history - Page history
 * @param {String} from - Current page
 * @param {String} to - New page
 */
VisitPage(history, from, to) {
    history.Push(from)
    OutputDebug("  " from " -> " to "`n")
}

/**
 * Begin a transaction
 * @param {Array} transactions - Transaction stack
 * @param {String} sql - SQL statement
 */
BeginTransaction(transactions, sql) {
    transaction := {
        sql: sql,
        timestamp: A_Now,
        id: transactions.Length + 1
    }

    transactions.Push(transaction)
    OutputDebug("  Transaction " transaction.id ": " sql "`n")
}

/**
 * Join array elements with delimiter
 * @param {Array} arr - Array to join
 * @param {String} delimiter - Delimiter
 * @returns {String} Joined string
 */
Join(arr, delimiter) {
    result := ""

    for index, value in arr {
        if (index > 1) {
            result .= delimiter
        }
        result .= value
    }

    return result
}

/**
 * Formats an array for display
 */
FormatArray(arr) {
    if (arr.Length = 0) {
        return "[]"
    }

    result := "["
    for index, value in arr {
        if (index > 1) {
            result .= ", "
        }
        result .= '"' value '"'
    }
    result .= "]"

    return result
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    ; Clear debug output
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.Pop() - LIFO Processing Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_BasicLIFOTasks()
    Example2_CommandHistory()
    Example3_BrowserNavigation()
    Example4_StackTrace()
    Example5_TransactionRollback()
    Example6_PlateStacking()
    Example7_RecursiveUnwinding()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Pop() LIFO processing examples completed!`nCheck DebugView for output.",
        "Examples Complete", "Icon!")
}

; Run the examples
Main()
