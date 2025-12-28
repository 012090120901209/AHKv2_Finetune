#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 SendInput Function - Automation
 * ============================================================================
 * 
 * Enterprise automation, application testing, batch processing, and
 * workflow automation using SendInput for maximum reliability.
 * 
 * @module BuiltIn_SendInput_03
 * @author AutoHotkey Community
 * @version 2.0.0
 */

; ============================================================================
; Example 1: Application Workflow Automation
; ============================================================================

/**
 * Automates complete application workflow.
 * Opens app, performs tasks, saves and closes.
 * 
 * @example
 * ; Press F1 for Notepad workflow
 */
F1:: {
    ToolTip("Notepad workflow automation starting...")
    Sleep(1000)

    ; Open Notepad
    Run("notepad.exe")
    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(500)

        ; Create document
        ToolTip("Creating document...")
        SendInput("AUTOMATION REPORT{Enter}{Enter}")
        SendInput("Date: ")
        SendInput(FormatTime(, "yyyy-MM-dd HH:mm:ss"))
        SendInput("{Enter}{Enter}")
        SendInput("This document was created automatically.{Enter}")
        SendInput("It demonstrates workflow automation.{Enter}{Enter}")
        SendInput("End of automated report.")
        Sleep(1000)

        ; Save file
        ToolTip("Saving file...")
        SendInput("^s")  ; Ctrl+S
        Sleep(500)

        ; Enter filename
        SendInput("AutomatedReport.txt")
        SendInput("{Enter}")
        Sleep(500)

        ToolTip("Workflow complete!")
        Sleep(1500)
        ToolTip()

        ; Close Notepad
        WinClose("Notepad")
    }
}

/**
 * Multi-application workflow
 * Orchestrates multiple applications
 */
F2:: {
    ToolTip("Multi-app workflow starting...")
    Sleep(1000)

    ; Part 1: Create text in Notepad
    Run("notepad.exe")
    if WinWait("Notepad", , 5) {
        WinActivate("Notepad")
        Sleep(300)

        SendInput("Sample data for transfer")
        SendInput("^a")  ; Select all
        Sleep(100)
        SendInput("^c")  ; Copy
        Sleep(100)

        WinClose("Notepad")
        Sleep(200)
        if WinWait("Notepad", , 2)
            SendInput("n")  ; Don't save
        Sleep(500)
    }

    ; Part 2: Open Calculator and paste
    Run("calc.exe")
    if WinWait("Calculator", , 5) {
        WinActivate("Calculator")
        Sleep(500)

        ToolTip("Multi-app workflow complete!")
        Sleep(2000)
        ToolTip()

        WinClose("Calculator")
    }
}

; ============================================================================
; Example 2: Data Entry Automation
; ============================================================================

/**
 * CSV data processing.
 * Reads and enters CSV data.
 * 
 * @description
 * Batch data entry simulation
 */
^F1:: {
    ToolTip("CSV data entry in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Simulate CSV data
    csvData := [
        ["ID001", "Product A", "100", "$29.99"],
        ["ID002", "Product B", "250", "$19.99"],
        ["ID003", "Product C", "75", "$39.99"],
        ["ID004", "Product D", "150", "$24.99"],
        ["ID005", "Product E", "200", "$34.99"]
    ]

    for rowIndex, row in csvData {
        ToolTip("Entering row " rowIndex " of " csvData.Length "...")

        for colIndex, value in row {
            SendInput(value)

            ; Tab between columns, Enter for new row
            if (colIndex < row.Length)
                SendInput("{Tab}")
            else
                SendInput("{Enter}")

            Sleep(50)
        }
    }

    ToolTip("Data entry complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * Database form filling
 * Automated database record entry
 */
^F2:: {
    ToolTip("Database form entry in 2 seconds...")
    Sleep(2000)
    ToolTip()

    records := [{
        name: "John Smith", email: "john@example.com", phone: "555-0101" }, {
            name: "Jane Doe", email: "jane@example.com", phone: "555-0102" }, {
                name: "Bob Johnson", email: "bob@example.com", phone: "555-0103"
            }
    ]

    for index, record in records {
        ToolTip("Record " index " of " records.Length "...")

        ; Name field
        SendInput(record.name)
        SendInput("{Tab}")
        Sleep(100)

        ; Email field
        SendInput(record.email)
        SendInput("{Tab}")
        Sleep(100)

        ; Phone field
        SendInput(record.phone)
        SendInput("{Enter}")  ; Submit
        Sleep(300)
    }

    ToolTip("Database entry complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 3: Testing Automation
; ============================================================================

/**
 * UI testing script.
 * Automated application testing.
 * 
 * @description
 * Simulates QA testing workflow
 */
^F3:: {
    ToolTip("UI test automation starting...")
    Sleep(1000)

    testResults := []

    ; Test 1: Application launch
    ToolTip("Test 1: Application launch...")
    Run("notepad.exe")
    if WinWait("Notepad", , 5) {
        testResults.Push("Application Launch: PASS")
    } else {
        testResults.Push("Application Launch: FAIL")
    }
    Sleep(500)

    ; Test 2: Text input
    ToolTip("Test 2: Text input...")
    SendInput("Test input text")
    Sleep(300)
    testResults.Push("Text Input: PASS")

    ; Test 3: Save functionality
    ToolTip("Test 3: Save dialog...")
    SendInput("^s")
    Sleep(500)
    if WinWait("Save As", , 3) {
        testResults.Push("Save Dialog: PASS")
        SendInput("{Escape}")
    } else {
        testResults.Push("Save Dialog: FAIL")
    }
    Sleep(300)

    ; Test 4: Close application
    ToolTip("Test 4: Close application...")
    WinClose("Notepad")
    Sleep(200)
    if WinWait("Notepad", , 2)
        SendInput("n")
    testResults.Push("Close Application: PASS")

    ; Display results
    resultText := "Test Results:`n`n"
    for index, result in testResults {
        resultText .= index ". " result "`n"
    }

    ToolTip()
    MsgBox(resultText, "Test Automation Results")
}

/**
 * Regression test suite
 * Multiple test scenarios
 */
^F4:: {
    ToolTip("Regression test suite starting...")
    Sleep(1000)

    tests := [{
        name: "Navigation Test", key: "^{Home}" }, {
            name: "Selection Test", key: "^a" }, {
                name: "Copy Test", key: "^c" }, {
                    name: "Paste Test", key: "^v"
                }
    ]

    results := []

    ; Run all tests
    for index, test in tests {
        ToolTip("Running: " test.name " (" index "/" tests.Length ")")

        SendInput(test.key)
        Sleep(300)

        results.Push(test.name ": PASS")
    }

    ; Report results
    report := "Regression Test Results:`n`n"
    for result in results {
        report .= result "`n"
    }
    report .= "`nAll tests completed successfully!"

    ToolTip()
    MsgBox(report, "Regression Tests")
}

; ============================================================================
; Example 4: Batch Processing
; ============================================================================

/**
 * Batch file processing.
 * Processes multiple files automatically.
 * 
 * @description
 * File operation automation
 */
^F5:: {
    ToolTip("Batch processing simulation...")
    Sleep(1000)

    fileCount := 10
    processed := 0

    Loop fileCount {
        ToolTip("Processing file " A_Index " of " fileCount "...")

        ; Simulate file operation
        SendInput("^o")  ; Open
        Sleep(200)

        SendInput("file" A_Index ".txt")
        Sleep(100)

        SendInput("{Enter}")
        Sleep(300)

        ; Process (simulate)
        SendInput("Processed")
        Sleep(100)

        ; Save
        SendInput("^s")
        Sleep(200)

        processed++

        if (Mod(A_Index, 3) = 0) {
            ToolTip("Progress: " Round((processed / fileCount) * 100) "%")
            Sleep(200)
        }
    }

    ToolTip("Batch processing complete!`n" processed " files processed")
    Sleep(2500)
    ToolTip()
}

/**
 * Report generation automation
 * Creates formatted reports
 */
^F6:: {
    ToolTip("Report generation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    ; Report header
    SendInput("=== AUTOMATED REPORT ==={Enter}{Enter}")

    ; Report sections
    sections := [{
        title: "Executive Summary", content: "Overview of automated processes." }, {
            title: "Data Analysis", content: "Statistical analysis results." }, {
                title: "Recommendations", content: "Suggested improvements." }, {
                    title: "Conclusion", content: "Summary and next steps."
                }
    ]

    for index, section in sections {
        ToolTip("Section " index ": " section.title)

        SendInput(section.title . "{Enter}")
        SendInput(StrRepeat("-", StrLen(section.title)) . "{Enter}")
        SendInput(section.content . "{Enter}{Enter}")

        Sleep(300)
    }

    ; Report footer
    SendInput("Report generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") . "{Enter}")
    SendInput("=== END OF REPORT ==={Enter}")

    ToolTip("Report generated!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 5: Email Automation
; ============================================================================

/**
 * Bulk email composition.
 * Automates email writing.
 * 
 * @description
 * Email template automation
 */
^F7:: {
    ToolTip("Email automation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    recipients := ["alice@example.com", "bob@example.com", "carol@example.com"]

    for index, recipient in recipients {
        ToolTip("Composing email " index " of " recipients.Length "...")

        ; To field
        SendInput(recipient)
        SendInput("{Tab}")
        Sleep(100)

        ; Subject
        SendInput("Automated Notification - " FormatTime(, "yyyy-MM-dd"))
        SendInput("{Tab}")
        Sleep(100)

        ; Body
        SendInput("Dear User,{Enter}{Enter}")
        SendInput("This is an automated notification.{Enter}{Enter}")
        SendInput("Best regards,{Enter}")
        SendInput("Automation System")

        Sleep(500)

        ; Next email
        SendInput("^n")  ; New message
        Sleep(300)
    }

    ToolTip("Email automation complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 6: Configuration Setup
; ============================================================================

/**
 * Automated application configuration.
 * Sets up application settings.
 * 
 * @description
 * Configuration wizard automation
 */
^F8:: {
    ToolTip("Configuration automation starting...")
    Sleep(1000)

    configSteps := [{
        step: "Language Selection", action: "{Down 2}{Enter}" }, {
            step: "Theme Selection", action: "{Tab}{Down}{Enter}" }, {
                step: "Default Settings", action: "{Tab 3}{Space}" }, {
                    step: "Confirmation", action: "{Enter}"
                }
    ]

    for index, config in configSteps {
        ToolTip("Config Step " index ": " config.step)

        SendInput(config.action)
        Sleep(500)
    }

    ToolTip("Configuration complete!")
    Sleep(2000)
    ToolTip()
}

/**
 * User account creation automation
 * Bulk user setup
 */
^F9:: {
    ToolTip("User creation automation in 2 seconds...")
    Sleep(2000)
    ToolTip()

    users := [{
        username: "user001", email: "user001@company.com", role: "User" }, {
            username: "user002", email: "user002@company.com", role: "Admin" }, {
                username: "user003", email: "user003@company.com", role: "User"
            }
    ]

    for index, user in users {
        ToolTip("Creating user " index " of " users.Length "...")

        ; Username
        SendInput(user.username)
        SendInput("{Tab}")
        Sleep(100)

        ; Email
        SendInput(user.email)
        SendInput("{Tab}")
        Sleep(100)

        ; Role
        SendInput(user.role)
        SendInput("{Enter}")
        Sleep(300)
    }

    ToolTip("User creation complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Example 7: Monitoring and Logging
; ============================================================================

/**
 * Automated status logging.
 * Creates timestamped log entries.
 * 
 * @description
 * System monitoring automation
 */
^F10:: {
    ToolTip("Status logging automation...")
    Sleep(1000)

    logEntries := [
        "System startup completed",
        "Services initialized",
        "Database connection established",
        "API endpoints activated",
        "System ready for operation"
    ]

    for index, entry in logEntries {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

        logLine := "[" timestamp "] " entry

        SendInput(logLine)
        SendInput("{Enter}")

        ToolTip("Log entry " index " of " logEntries.Length)
        Sleep(400)
    }

    ToolTip("Logging complete!")
    Sleep(2000)
    ToolTip()
}

; ============================================================================
; Utility Functions
; ============================================================================

/**
 * Processes array of form data
 * 
 * @param {Array} formData - Array of field values
 * @param {String} separator - Field separator (Tab/Enter)
 */
ProcessFormData(formData, separator := "{Tab}") {
    for index, field in formData {
        SendInput(field)
        if (index < formData.Length)
            SendInput(separator)
    }
}

/**
 * Creates timestamped entry
 * 
 * @param {String} text - Entry text
 * @param {String} format - Time format
 */
LogTimestamped(text, format := "yyyy-MM-dd HH:mm:ss") {
    timestamp := FormatTime(, format)
    SendInput("[" timestamp "] " text)
}

; ============================================================================
; Exit and Help
; ============================================================================

Esc:: ExitApp()

F12:: {
    helpText := "
                                                        (
                                                        SendInput - Automation
                                                        ======================

                                                        F1 - Notepad workflow
                                                        F2 - Multi-app workflow

                                                        Ctrl+F1  - CSV data entry
                                                        Ctrl+F2  - Database forms
                                                        Ctrl+F3  - UI testing
                                                        Ctrl+F4  - Regression tests
                                                        Ctrl+F5  - Batch processing
                                                        Ctrl+F6  - Report generation
                                                        Ctrl+F7  - Email automation
                                                        Ctrl+F8  - Configuration setup
                                                        Ctrl+F9  - User creation
                                                        Ctrl+F10 - Status logging

                                                        F12 - Show this help
                                                        ESC - Exit script

                                                        NOTE: Activate target window before automation!
                                                        )"

    MsgBox(helpText, "Automation Examples Help")
}
