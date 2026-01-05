#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 SendInput Function - Fast Input
 * ============================================================================
 * 
 * SendInput is the fastest and most reliable send mode. It buffers keystrokes
 * and plays them back at maximum speed, making it ideal for high-performance
 * automation, gaming macros, and rapid data entry.
 * 
 * Syntax: SendInput(Keys)
 * 
 * @module BuiltIn_SendInput_01
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Speed Comparison
; ============================================================================

/**
 * Compares SendInput speed vs Send.
 * Demonstrates performance difference.
 * 
 * @example
 * ; Press F1 to test Send speed
 */
F1:: {
    ToolTip("Testing Send (normal) in 2 seconds...")
    Sleep(2000)
    ToolTip()

    startTime := A_TickCount

    Send("The quick brown fox jumps over the lazy dog. ")
    Send("The quick brown fox jumps over the lazy dog. ")
    Send("The quick brown fox jumps over the lazy dog.")

    elapsed := A_TickCount - startTime

    ToolTip("Send elapsed time: " elapsed "ms")
    Sleep(3000)
    ToolTip()
}

/**
 * SendInput performance test
 * Shows faster execution speed
 */
F2:: {
    ToolTip("Testing SendInput (fast) in 2 seconds...")
    Sleep(2000)
    ToolTip()

    startTime := A_TickCount

    SendInput("The quick brown fox jumps over the lazy dog. ")
    SendInput("The quick brown fox jumps over the lazy dog. ")
    SendInput("The quick brown fox jumps over the lazy dog.")

    elapsed := A_TickCount - startTime

    ToolTip("SendInput elapsed time: " elapsed "ms")
    Sleep(3000)
    ToolTip()
}

/**
 * Buffered keystroke demonstration
 * SendInput buffers all keystrokes before sending
 */
F3:: {
    ToolTip("Buffered SendInput in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; All keystrokes sent as single atomic operation
    SendInput("This entire message is buffered and sent at once for maximum speed and reliability!")

    ToolTip("Buffered send complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 2: High-Speed Data Entry
; ============================================================================

/**
 * Rapid form filling with SendInput.
 * Demonstrates fast, reliable form automation.
 * 
 * @description
 * Uses SendInput for maximum speed
 */
^F1:: {
    ToolTip("Fast form filling in 2 seconds...")
    Sleep(2000)
    ToolTip()

    formData := [
        "John Doe",
        "john.doe@example.com",
        "555-1234",
        "123 Main Street",
        "Anytown",
        "CA",
        "12345"
    ]

    for index, data in formData {
        ToolTip("Field " index " of " formData.Length)

        SendInput(data)
        SendInput("{Tab}")

        Sleep(100)  ; Small delay between fields
    }

    ToolTip("Fast form filling complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Rapid spreadsheet data entry
 * Fills multiple cells quickly
 */
^F2:: {
    ToolTip("Spreadsheet automation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Sample data rows
    data := [
        ["Product A", "100", "29.99"],
        ["Product B", "250", "19.99"],
        ["Product C", "75", "39.99"],
        ["Product D", "150", "24.99"],
        ["Product E", "200", "34.99"]
    ]

    for rowIndex, row in data {
        ToolTip("Row " rowIndex " of " data.Length)

        for colIndex, value in row {
            SendInput(value)

            ; Tab to next cell or Enter for new row
            if (colIndex < row.Length)
                SendInput("{Tab}")
            else
                SendInput("{Enter}")

            Sleep(50)
        }
    }

    ToolTip("Spreadsheet complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 3: Uninterruptible Input
; ============================================================================

/**
 * SendInput cannot be interrupted by user input.
 * Demonstrates guaranteed execution.
 * 
 * @description
 * Keystrokes execute atomically without interruption
 */
^F3:: {
    ToolTip("Uninterruptible input in 2 seconds...`n`nTry moving the mouse or pressing keys!")
    Sleep(2000)
    ToolTip()

    ; This will complete regardless of user input
    SendInput("This text will be typed completely without interruption even if you try to interfere! ")
    SendInput("All keystrokes are buffered and sent atomically. ")
    SendInput("The end.")

    ToolTip("Uninterruptible input complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Critical operation protection
 * Ensures important sequences complete
 */
^F4:: {
    ToolTip("Critical operation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Save operation that must complete
    SendInput("^s")  ; Ctrl+S
    Sleep(200)

    ; Confirmation dialog response
    SendInput("{Enter}")
    Sleep(200)

    ToolTip("Critical operation complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Example 4: Bulk Text Processing
; ============================================================================

/**
 * Processes large amounts of text quickly.
 * Ideal for batch text operations.
 * 
 * @description
 * Demonstrates high-volume text input
 */
^F5:: {
    ToolTip("Bulk text processing in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Generate and send 50 lines of text
    Loop 50 {
        SendInput("Line " A_Index ": This is sample text for bulk processing.")
        SendInput("{Enter}")

        if (Mod(A_Index, 10) = 0)
            ToolTip("Processing line " A_Index "...")
    }

    ToolTip("Bulk processing complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Code template insertion
 * Quickly inserts code snippets
 */
^F6:: {
    ToolTip("Code template insertion in 2 seconds...")
    Sleep(2000)
    ToolTip()

    codeTemplate := "
    (
    function ExampleFunction(param1, param2) {
        if (param1 && param2) {
            return param1 + param2;
        }
        return null;
    }
    )"

    ; Remove leading indentation and send
    SendInput(StrReplace(codeTemplate, "`n    ", "`n"))

    ToolTip("Template inserted!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 5: Gaming Macros
; ============================================================================

/**
 * Fast ability combo for gaming.
 * Executes skill sequence rapidly.
 * 
 * @description
 * Gaming macro with precise timing
 */
^F7:: {
    ToolTip("Gaming combo macro activating in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Ability combo (1-2-3-4 sequence)
    ToolTip("Executing combo...")

    SendInput("1")  ; Skill 1
    Sleep(100)

    SendInput("2")  ; Skill 2
    Sleep(100)

    SendInput("3")  ; Skill 3
    Sleep(100)

    SendInput("4")  ; Skill 4

    ToolTip("Combo complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Rapid item usage macro
 * Uses consumables quickly
 */
^F8:: {
    ToolTip("Item usage macro in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Use items from quickbar (Q, E, R, F keys)
    items := ["q", "e", "r", "f"]

    for index, item in items {
        ToolTip("Using item: " StrUpper(item))
        SendInput(item)
        Sleep(150)
    }

    ToolTip("Item usage complete!")
    Sleep(1000)
    ToolTip()
}

/**
 * Build order macro for strategy games
 * Executes building sequence
 */
^F9:: {
    ToolTip("Build order macro in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Building hotkeys (example: B for barracks, A for armory, etc.)
    buildOrder := ["b", "a", "f", "s", "t"]

    for index, building in buildOrder {
        ToolTip("Building " index " of " buildOrder.Length "...")

        SendInput(building)
        Sleep(200)

        ; Confirm build
        SendInput("{Enter}")
        Sleep(100)
    }

    ToolTip("Build order complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 6: Reliable Command Sequences
; ============================================================================

/**
 * Multi-step command execution.
 * Ensures all steps execute in order.
 * 
 * @description
 * Complex multi-command automation
 */
^F10:: {
    ToolTip("Command sequence in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Open Run dialog
    SendInput("#r")
    Sleep(500)

    ; Type command
    SendInput("notepad")
    Sleep(200)

    ; Execute
    SendInput("{Enter}")
    Sleep(1000)

    ; Wait for Notepad
    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        ; Type content
        SendInput("This is automated content.{Enter}")
        SendInput("Created with SendInput for maximum reliability.{Enter}")
        SendInput("All commands executed in perfect sequence.")

        ToolTip("Command sequence complete!")
        Sleep(2000)
        ToolTip()

        ; Close without saving
        WinClose("Notepad")
        Sleep(200)
        if WinWait("Notepad", , 2)
            SendInput("n")
    }
}

; ============================================================================
; Example 7: Performance Benchmarks
; ============================================================================

/**
 * Benchmarks SendInput performance.
 * Measures keystrokes per second.
 * 
 * @description
 * Performance analysis
 */
^F11:: {
    ToolTip("Benchmark test starting in 2 seconds...")
    Sleep(2000)
    ToolTip()

    testText := "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    iterations := 100

    startTime := A_TickCount

    Loop iterations {
        SendInput(testText)

        if (Mod(A_Index, 20) = 0)
            ToolTip("Progress: " A_Index "/" iterations)
    }

    elapsed := A_TickCount - startTime

    totalChars := StrLen(testText) * iterations
    charsPerSecond := Round((totalChars / elapsed) * 1000, 0)

    results := "SendInput Benchmark Results:`n`n"
    results .= "Characters: " totalChars "`n"
    results .= "Time: " elapsed "ms`n"
    results .= "Speed: " charsPerSecond " chars/second"

    ToolTip()
    MsgBox(results, "Benchmark Results")
}

/**
 * Comparison benchmark
 * Compares all send modes
 */
^F12:: {
    ToolTip("Full comparison benchmark starting in 2 seconds...")
    Sleep(2000)
    ToolTip()

    testText := "Test"
    iterations := 50

    results := "Send Mode Comparison:`n`n"

    ; Test Send
    startTime := A_TickCount
    Loop iterations {
        Send(testText)
        if (Mod(A_Index, 10) = 0)
            ToolTip("Testing Send: " A_Index "/" iterations)
    }
    sendTime := A_TickCount - startTime
    results .= "Send:      " sendTime "ms`n"

    Sleep(500)

    ; Test SendInput
    startTime := A_TickCount
    Loop iterations {
        SendInput(testText)
        if (Mod(A_Index, 10) = 0)
            ToolTip("Testing SendInput: " A_Index "/" iterations)
    }
    sendInputTime := A_TickCount - startTime
    results .= "SendInput: " sendInputTime "ms`n`n"

    improvement := Round(((sendTime - sendInputTime) / sendTime) * 100, 1)
    results .= "SendInput is " improvement "% faster"

    ToolTip()
    MsgBox(results, "Comparison Results")
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Fast multi-line sender
 * 
 * @param {Array} lines - Array of text lines
 */
FastSendLines(lines) {
    for index, line in lines {
        SendInput(line)
        SendInput("{Enter}")
    }
}

/**
 * Batch data sender with progress
 * 
 * @param {Array} data - Array of data items
 * @param {String} separator - Separator between items
 */
BatchSend(data, separator := "{Tab}") {
    for index, item in data {
        SendInput(item)
        if (index < data.Length)
            SendInput(separator)
    }
}

; Test utilities
!F1:: {
    ToolTip("FastSendLines test in 2 seconds...")
    Sleep(2000)
    ToolTip()

    lines := ["Line 1", "Line 2", "Line 3", "Line 4", "Line 5"]
    FastSendLines(lines)

    ToolTip("FastSendLines complete!")
    Sleep(1000)
    ToolTip()
}

!F2:: {
    ToolTip("BatchSend test in 2 seconds...")
    Sleep(2000)
    ToolTip()

    data := ["Item1", "Item2", "Item3", "Item4"]
    BatchSend(data, " | ")

    ToolTip("BatchSend complete!")
    Sleep(1000)
    ToolTip()
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc:: ExitApp()

F12:: {
    helpText := "
    (
    SendInput - Fast Input
    ======================

    F1 - Send speed test
    F2 - SendInput speed test
    F3 - Buffered input

    Ctrl+F1  - Fast form filling
    Ctrl+F2  - Spreadsheet automation
    Ctrl+F3  - Uninterruptible input
    Ctrl+F4  - Critical operation
    Ctrl+F5  - Bulk text processing
    Ctrl+F6  - Code template
    Ctrl+F7  - Gaming combo
    Ctrl+F8  - Item usage macro
    Ctrl+F9  - Build order macro
    Ctrl+F10 - Command sequence
    Ctrl+F11 - Benchmark test
    Ctrl+F12 - Comparison benchmark

    Alt+F1 - FastSendLines test
    Alt+F2 - BatchSend test

    F12 - Show this help
    ESC - Exit script
    )"

    MsgBox(helpText, "SendInput Examples Help")
}
