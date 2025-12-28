#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Examples - RunWait Function (Part 2: Exit Codes)
 * ============================================================================
 * 
 * Understanding and handling exit codes from RunWait.
 * 
 * @description Examples demonstrating exit code handling and interpretation
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * EXIT CODES:
 *   Programs return exit codes (also called return codes or error levels)
 *   - 0: Typically indicates success
 *   - Non-zero: Indicates error or specific status
 *   - Different programs use different exit code conventions
 * 
 * USAGE:
 *   exitCode := RunWait("program.exe")
 *   if exitCode = 0
 *       MsgBox("Success!")
 *   else
 *       MsgBox("Failed with code: " . exitCode)
 */

; ============================================================================
; Example 1: Basic Exit Code Handling
; ============================================================================
; Demonstrates reading and interpreting exit codes

Example1_BasicExitCodes() {
    MsgBox("Example 1: Basic Exit Code Handling`n`n" .
        "Learn how to read and interpret exit codes:",
        "RunWait - Example 1", "Icon!")

    testDir := A_Temp . "\ahk_exitcode_test"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create batch files with different exit codes
        successBat := testDir . "\success.bat"
        FileAppend("
        (
        @echo off
        echo This program will exit successfully
        echo Exit code will be 0
        timeout /t 1 /nobreak >nul
        exit /b 0
        )", successBat)

        errorBat := testDir . "\error.bat"
        FileAppend("
        (
        @echo off
        echo This program will exit with error
        echo Exit code will be 1
        timeout /t 1 /nobreak >nul
        exit /b 1
        )", errorBat)

        customBat := testDir . "\custom.bat"
        FileAppend("
        (
        @echo off
        echo This program will exit with custom code
        echo Exit code will be 42
        timeout /t 1 /nobreak >nul
        exit /b 42
        )", customBat)

        MsgBox("Created test programs with different exit codes:`n`n" .
            "• success.bat (exit 0)`n" .
            "• error.bat (exit 1)`n" .
            "• custom.bat (exit 42)",
            "Programs Created", "T3")

        ; Test success case
        MsgBox("Running success.bat...`n" .
            "Expected exit code: 0", "Test 1", "T2")

        exitCode := RunWait('"' . successBat . '"', testDir)

        MsgBox("Program completed!`n`n" .
            "Exit Code: " . exitCode . "`n" .
            "Status: " . (exitCode = 0 ? "SUCCESS ✓" : "FAILED ✗"),
            "Result 1", "T3")

        Sleep(1000)

        ; Test error case
        MsgBox("Running error.bat...`n" .
            "Expected exit code: 1", "Test 2", "T2")

        exitCode := RunWait('"' . errorBat . '"', testDir)

        MsgBox("Program completed!`n`n" .
            "Exit Code: " . exitCode . "`n" .
            "Status: " . (exitCode = 0 ? "SUCCESS ✓" : "FAILED ✗"),
            "Result 2", "T3")

        Sleep(1000)

        ; Test custom case
        MsgBox("Running custom.bat...`n" .
            "Expected exit code: 42", "Test 3", "T2")

        exitCode := RunWait('"' . customBat . '"', testDir)

        MsgBox("Program completed!`n`n" .
            "Exit Code: " . exitCode . "`n" .
            "Interpretation: Custom status code for special handling",
            "Result 3", "T3")

        MsgBox("Exit code demonstration complete!`n`n" .
            "Remember: Always check exit codes to detect errors!",
            "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: Exit Code Decision Making
; ============================================================================
; Using exit codes to make decisions in your script

Example2_ExitCodeDecisions() {
    MsgBox("Example 2: Exit Code Decision Making`n`n" .
        "Use exit codes to control script flow:",
        "RunWait - Example 2", "Icon!")

    testDir := A_Temp . "\ahk_decision_test"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create a validation script
        validatorBat := testDir . "\validator.bat"
        FileAppend("
        (
        @echo off
        echo Validating system...

        REM Check if a file exists
        if exist test_data.txt (
        echo Validation PASSED
        exit /b 0
        ) else (
            echo Validation FAILED: test_data.txt not found
            exit / b 1
        )
    ) ", validatorBat)

    ; Create main process
    processBat := testDir . "\process.bat"
    FileAppend("
        (
        @echo off
        echo Processing data from test_data.txt...
        type test_data.txt
        echo.
        echo Processing complete!
        timeout /t 1 /nobreak >nul
        exit /b 0
        )", processBat)

    MsgBox("Created validation system:`n`n" .
        "validator.bat - Checks if data file exists`n" .
        "process.bat - Processes the data file`n`n" .
        "We'll use exit codes to decide whether to proceed.",
        "System Created", "T4")

    ; First run without data file
    result := MsgBox("Test 1: Run WITHOUT data file`n`n" .
        "Validator should fail, processing should be skipped.",
        "Test 1", "YesNo Icon?")

    if result = "Yes" {
        MsgBox("Running validator...", "Validating", "T1")

        exitCode := RunWait('"' . validatorBat . '"', testDir)

        if exitCode = 0 {
            MsgBox("Validation successful! Proceeding with processing...", "Valid", "T2")
            RunWait('"' . processBat . '"', testDir)
            MsgBox("Processing complete!", "Done", "T2")
        } else {
            MsgBox("Validation FAILED (Exit code: " . exitCode . ")`n`n" .
                "Processing will be SKIPPED for safety.",
                "Validation Failed", "Icon!")
        }
    }

    Sleep(1500)

    ; Now create data file and run again
    result := MsgBox("Test 2: Run WITH data file`n`n" .
        "Validator should succeed, processing should run.",
        "Test 2", "YesNo Icon?")

    if result = "Yes" {
        ; Create data file
        FileAppend("Sample data for processing`nLine 2`nLine 3",
            testDir . "\test_data.txt")

        MsgBox("Created test_data.txt`n" .
            "Running validator...", "Validating", "T2")

        exitCode := RunWait('"' . validatorBat . '"', testDir)

        if exitCode = 0 {
            MsgBox("Validation successful! (Exit code: " . exitCode . ")`n`n" .
                "Proceeding with processing...", "Valid", "T2")
            RunWait('"' . processBat . '"', testDir)
            MsgBox("Processing complete!", "Done", "T2")
        } else {
            MsgBox("Validation FAILED (Exit code: " . exitCode . ")`n`n" .
                "Processing will be SKIPPED.",
                "Validation Failed", "Icon!")
        }
    }

    MsgBox("Decision making demonstration complete!`n`n" .
        "Exit codes allowed the script to make intelligent decisions.`n" .
        "Files remain in: " . testDir,
        "Complete", "Icon!")

} catch Error as err {
    MsgBox("Error: " . err.Message, "Error")
}
}

; ============================================================================
; Example 3: Multi-Exit-Code Handling
; ============================================================================
; Programs with multiple exit codes for different scenarios

Example3_MultiExitCodes() {
    MsgBox("Example 3: Multiple Exit Code Scenarios`n`n" .
        "Handle programs that return different exit codes for different situations:",
        "RunWait - Example 3", "Icon!")

    testDir := A_Temp . "\ahk_multi_exit"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create program with multiple exit codes
        multiBat := testDir . "\multi_exit.bat"
        FileAppend("
        (
        @echo off
        echo Multi-Exit-Code Program
        echo =======================
        echo.

        if `"%1`"==`"`" (
        echo ERROR: No parameter provided
        exit /b 1
        )
            if` "%1`"==`"success`" (
                echo Operation completed successfully
                exit / b 0
            )
                if` "%1`"==`"warning`" (
                    echo Operation completed with warnings
                        exit / b 2
        )

        if` "%1`"==`"error`" (
            echo Operation failed
        exit / b 1
    )

    if` "%1`"==`"critical`" (
        echo Critical error occurred
    exit / b 255
)

echo ERROR: Unknown parameter
exit / b 1
) ", multiBat)

MsgBox("Created program with multiple exit codes:`n`n" .
    "• 0 = Success`n" .
    "• 1 = Error`n" .
    "• 2 = Warning`n" .
    "• 255 = Critical Error`n`n" .
    "We'll test each scenario...",
    "Program Created", "T4")

CreateExitCodeTester(testDir, multiBat)

} catch Error as err {
    MsgBox("Error: " . err.Message, "Error")
}
}

CreateExitCodeTester(testDir, multiBat) {
    tester := Gui(, "Exit Code Tester")
    tester.SetFont("s10")

    tester.Add("Text", "w450", "Exit Code Testing Interface")
    tester.Add("Text", "w450", "Select a scenario and run the program:")

    tester.Add("Text", "w450 0x10")

    ; Scenario selection
    tester.Add("Text", "xm", "Scenario:")
    scenarioDD := tester.Add("DropDownList", "w450", [
        "success - Should return 0",
        "warning - Should return 2",
        "error - Should return 1",
        "critical - Should return 255",
        "(no parameter) - Should return 1"
    ])
    scenarioDD.Choose(1)

    ; Result display
    resultText := tester.Add("Edit", "w450 h150 +ReadOnly +Multi",
        "Select scenario and click 'Run Test'")

    ; Buttons
    tester.Add("Button", "w220 h35", "Run Test").OnEvent("Click", RunTest)
    tester.Add("Button", "x+10 yp w220 h35", "Run All Tests").OnEvent("Click", RunAllTests)

    tester.Add("Button", "xm w450 h30", "Close").OnEvent("Click", (*) => tester.Destroy())

    RunTest(*) {
        scenarios := ["success", "warning", "error", "critical", ""]
        selected := scenarios[scenarioDD.Value]

        resultText.Value := "Running scenario: " . (selected = "" ? "(no parameter)" : selected) . "`n`n"

        cmd := '"' . multiBat . '"'
        if selected != ""
            cmd .= ' "' . selected . '"'

        exitCode := RunWait(cmd, testDir, "Hide")

        interpretation := GetExitCodeInterpretation(exitCode)

        resultText.Value .= "Exit Code: " . exitCode . "`n" .
            "Status: " . interpretation . "`n`n" .
            GetRecommendedAction(exitCode)
    }

    RunAllTests(*) {
        resultText.Value := "Running all scenarios...`n`n"

        tests := [{
            name: "success", param: "success" }, {
                name: "warning", param: "warning" }, {
                    name: "error", param: "error" }, {
                        name: "critical", param: "critical" }, {
                            name: "no parameter", param: ""
                        }
        ]

        for test in tests {
            cmd := '"' . multiBat . '"'
            if test.param != ""
                cmd .= ' "' . test.param . '"'

            exitCode := RunWait(cmd, testDir, "Hide")
            interpretation := GetExitCodeInterpretation(exitCode)

            resultText.Value .= "[" . test.name . "]`n" .
                "  Exit Code: " . exitCode . "`n" .
                "  Status: " . interpretation . "`n`n"
        }

        resultText.Value .= "All tests complete!"
    }

    GetExitCodeInterpretation(code) {
        switch code {
            case 0: return "✓ SUCCESS"
            case 1: return "✗ ERROR"
            case 2: return "⚠ WARNING"
            case 255: return "🔴 CRITICAL ERROR"
            default: return "? UNKNOWN CODE"
        }
    }

    GetRecommendedAction(code) {
        switch code {
            case 0: return "Recommended Action: Continue normally"
            case 1: return "Recommended Action: Handle error and stop"
            case 2: return "Recommended Action: Log warning, continue with caution"
            case 255: return "Recommended Action: STOP ALL OPERATIONS, investigate"
            default: return "Recommended Action: Review program documentation"
        }
    }

    tester.Show()

    MsgBox("Exit Code Tester Created!`n`n" .
        "Test different scenarios to see how exit codes change.`n" .
        "Use exit codes to make informed decisions in your scripts!",
        "Tester Ready", "Icon!")
}

; ============================================================================
; Example 4: Compiler/Build System Exit Codes
; ============================================================================
; Realistic build system with proper exit code handling

Example4_BuildSystemExitCodes() {
    MsgBox("Example 4: Build System Exit Codes`n`n" .
        "Realistic build system that handles various exit codes:",
        "RunWait - Example 4", "Icon!")

    buildDir := A_Temp . "\ahk_build_system"

    try {
        if !DirExist(buildDir)
            DirCreate(buildDir)

        CreateBuildSystem(buildDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateBuildSystem(buildDir) {
    ; Create build tools with realistic exit codes
    compilerBat := buildDir . "\compiler.bat"
    FileAppend("
                    (
                    @echo off
                    echo Compiler v1.0
                    echo =============
                    echo.

                    if not exist source.txt (
                    echo ERROR: source.txt not found
                    exit /b 1
                    )
        echo Compiling source.txt...
        findstr / i` "error`" source.txt >nul
        if %errorlevel% == 0 (
            echo ERROR: Syntax error found in source
            exit / b 2
        )
            echo Compilation successful
            echo Compiled output > output.o
            exit / b 0
        )
            ", compilerBat)
            linkerBat := buildDir . "\linker.bat"
                FileAppend("
                    (
                    @echo off
                    echo Linker v1.0
                    echo ===========
                    echo.

                    if not exist output.o (
                    echo ERROR: output.o not found
                    exit /b 1
                    )
                    echo Linking...
                    echo Executable > program.exe
                    echo Link successful
                    exit / b 0
                ) ", linkerBat)
                buildGUI := Gui(, "Build System with Exit Code Handling")
                buildGUI.SetFont("s10")
                buildGUI.Add("Text", "w500", "Realistic Build System")
                buildGUI.Add("Text", "w500", "The compiler and linker return different exit codes based on results:")
                buildGUI.Add("Text", "w500 0x10")
                logText := buildGUI.Add("Edit", "w500 h200 +ReadOnly +Multi", "Ready to build...")
                buildGUI.Add("Button", "w240 h35", "Build (With Errors)").OnEvent("Click", (*) => BuildWithErrors())
                buildGUI.Add("Button", "x+20 yp w240 h35", "Build (Success)").OnEvent("Click", (*) => BuildSuccess())
                buildGUI.Add("Button", "xm w500 h30", "Close").OnEvent("Click", (*) => buildGUI.Destroy())
        BuildWithErrors() {
            logText.Value := "=== BUILD STARTED (with errors in source) ===`n`n"

            ; Create source with error
            FileAppend("This source contains an error keyword", buildDir . "\source.txt")

            logText.Value .= "[1/2] Running compiler...`n"
            exitCode := RunWait('"' . compilerBat . '"', buildDir, "Hide")

            if exitCode = 0 {
                logText.Value .= "  ✓ Compiler successful (Exit: 0)`n`n"

                logText.Value .= "[2/2] Running linker...`n"
                exitCode := RunWait('"' . linkerBat . '"', buildDir, "Hide")

                if exitCode = 0 {
                    logText.Value .= "  ✓ Linker successful (Exit: 0)`n`n"
                    logText.Value .= "========================================`n"
                    logText.Value .= "BUILD SUCCESSFUL!`n"
                    logText.Value .= "========================================`n"
                } else {
                    logText.Value .= "  ✗ Linker FAILED (Exit: " . exitCode . ")`n`n"
                    logText.Value .= "========================================`n"
                    logText.Value .= "BUILD FAILED - Linker error`n"
                    logText.Value .= "========================================`n"
                }
            } else {
                logText.Value .= "  ✗ Compiler FAILED (Exit: " . exitCode . ")`n`n"
                logText.Value .= "========================================`n"
                logText.Value .= "BUILD FAILED - Compiler error`n"
                logText.Value .= "========================================`n"
                logText.Value .= "Linker step SKIPPED due to compilation failure`n"
            }

            ; Cleanup
            if FileExist(buildDir . "\source.txt")
                FileDelete(buildDir . "\source.txt")
            if FileExist(buildDir . "\output.o")
                FileDelete(buildDir . "\output.o")
        }
        BuildSuccess() {
            logText.Value := "=== BUILD STARTED (clean source) ===`n`n"

            ; Create clean source
            FileAppend("This is clean source code", buildDir . "\source.txt")

            logText.Value .= "[1/2] Running compiler...`n"
            exitCode := RunWait('"' . compilerBat . '"', buildDir, "Hide")

            if exitCode = 0 {
                logText.Value .= "  ✓ Compiler successful (Exit: 0)`n`n"

                logText.Value .= "[2/2] Running linker...`n"
                exitCode := RunWait('"' . linkerBat . '"', buildDir, "Hide")

                if exitCode = 0 {
                    logText.Value .= "  ✓ Linker successful (Exit: 0)`n`n"
                    logText.Value .= "========================================`n"
                    logText.Value .= "BUILD SUCCESSFUL!`n"
                    logText.Value .= "========================================`n"
                    logText.Value .= "Output: " . buildDir . "\program.exe`n"
                } else {
                    logText.Value .= "  ✗ Linker FAILED (Exit: " . exitCode . ")`n`n"
                    logText.Value .= "========================================`n"
                    logText.Value .= "BUILD FAILED - Linker error`n"
                    logText.Value .= "========================================`n"
                }
            } else {
                logText.Value .= "  ✗ Compiler FAILED (Exit: " . exitCode . ")`n`n"
                logText.Value .= "========================================`n"
                logText.Value .= "BUILD FAILED - Compiler error`n"
                logText.Value .= "========================================`n"
                logText.Value .= "Linker step SKIPPED due to compilation failure`n"
            }
        }
        buildGUI.Show()
        MsgBox("Build System Created!`n`n" .
            "This demonstrates proper exit code handling in build systems:`n" .
            "• Check exit code after each step`n" .
            "• Stop on errors (don't continue to linker if compile fails)`n" .
            "• Provide meaningful feedback based on exit codes",
            "Build System Ready", "Icon!")
    }

    ; ============================================================================
    ; Example 5: Exit Code Logging and Reporting
    ; ============================================================================
    ; Create comprehensive logs of exit codes

    Example5_ExitCodeLogging() {
        MsgBox("Example 5: Exit Code Logging and Reporting`n`n" .
            "Create detailed logs of all operations and their exit codes:",
            "RunWait - Example 5", "Icon!")

        logDir := A_Temp . "\ahk_exit_log"

        try {
            if !DirExist(logDir)
                DirCreate(logDir)

            ; Create test operations
            CreateTestOperations(logDir)

            ; Run operations with logging
            RunOperationsWithLogging(logDir)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error")
        }
    }

    CreateTestOperations(logDir) {
        operations := [{
            name: "op1", exitCode: 0 }, {
                name: "op2", exitCode: 0 }, {
                    name: "op3", exitCode: 1 }, {
                        name: "op4", exitCode: 0 }, {
                            name: "op5", exitCode: 2
                        }
        ]

        for op in operations {
            batFile := logDir . "\" . op.name . ".bat"
            FileAppend("
                                        (
                                        @echo off
                                        echo Running " . op.name . "...
                                        timeout /t 1 /nobreak >nul
                                        exit /b " . op.exitCode . "
                                        )", batFile)
        }
    }

    RunOperationsWithLogging(logDir) {
        logFile := logDir . "\execution_log.txt"
        reportFile := logDir . "\exit_code_report.txt"

        ; Clear old logs
        if FileExist(logFile)
            FileDelete(logFile)
        if FileExist(reportFile)
            FileDelete(reportFile)

        operations := ["op1", "op2", "op3", "op4", "op5"]
        results := []

        MsgBox("Running 5 operations with exit code logging...`n`n" .
            "Logs will be created in:`n" . logDir,
            "Starting Operations", "T3")

        for index, opName in operations {
            batFile := logDir . "\" . opName . ".bat"

            ; Log start
            FileAppend(FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . " - Starting " . opName . "`n", logFile)

            startTime := A_TickCount
            exitCode := RunWait('"' . batFile . '"', logDir, "Hide")
            elapsed := (A_TickCount - startTime) / 1000

            ; Log result
            FileAppend(FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . " - Finished " . opName .
                " (Exit: " . exitCode . ", Duration: " . Format("{:.1f}s", elapsed) . ")`n", logFile)

            results.Push({ name: opName, exitCode: exitCode, duration: elapsed })
        }

        ; Generate report
        reportContent := "EXIT CODE REPORT`n"
        reportContent .= "================`n`n"
        reportContent .= "Generated: " . FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss") . "`n`n"

        successCount := 0
        failureCount := 0

        for result in results {
            status := result.exitCode = 0 ? "SUCCESS" : "FAILED"
            if result.exitCode = 0
                successCount++
            else
                failureCount++

            reportContent .= result.name . ": " . status . " (Exit: " . result.exitCode .
                ", " . Format("{:.1f}s", result.duration) . ")`n"
        }

        reportContent .= "`n"
        reportContent .= "Summary:`n"
        reportContent .= "--------`n"
        reportContent .= "Total Operations: " . results.Length . "`n"
        reportContent .= "Successful: " . successCount . "`n"
        reportContent .= "Failed: " . failureCount . "`n"
        reportContent .= "Success Rate: " . Format("{:.1f}%", (successCount / results.Length) * 100) . "`n"

        FileAppend(reportContent, reportFile)

        ; Show results
        MsgBox("All operations complete!`n`n" .
            "Results:`n" .
            "• Total: " . results.Length . "`n" .
            "• Successful: " . successCount . "`n" .
            "• Failed: " . failureCount . "`n`n" .
            "Logs created:`n" .
            "• " . logFile . "`n" .
            "• " . reportFile,
            "Complete", "Icon!")

        ; Offer to show report
        result := MsgBox("View exit code report?", "View Report?", "YesNo")
        if result = "Yes" {
            Run("notepad.exe `"" . reportFile . "`"")
        }
    }

    ; ============================================================================
    ; Main Menu
    ; ============================================================================

    ShowMainMenu() {
        menu := Gui(, "RunWait Function Examples (Part 2) - Main Menu")
        menu.SetFont("s10")

        menu.Add("Text", "w500", "AutoHotkey v2 - RunWait Function (Exit Codes)")
        menu.SetFont("s9")
        menu.Add("Text", "w500", "Select an example to run:")

        menu.Add("Button", "w500 h35", "Example 1: Basic Exit Code Handling").OnEvent("Click", (*) => (menu.Hide(), Example1_BasicExitCodes(), menu.Show()))
        menu.Add("Button", "w500 h35", "Example 2: Exit Code Decision Making").OnEvent("Click", (*) => (menu.Hide(), Example2_ExitCodeDecisions(), menu.Show()))
        menu.Add("Button", "w500 h35", "Example 3: Multiple Exit Code Scenarios").OnEvent("Click", (*) => (menu.Hide(), Example3_MultiExitCodes(), menu.Show()))
        menu.Add("Button", "w500 h35", "Example 4: Compiler/Build System Exit Codes").OnEvent("Click", (*) => (menu.Hide(), Example4_BuildSystemExitCodes(), menu.Show()))
        menu.Add("Button", "w500 h35", "Example 5: Exit Code Logging and Reporting").OnEvent("Click", (*) => (menu.Hide(), Example5_ExitCodeLogging(), menu.Show()))

        menu.Add("Text", "w500 0x10")
        menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

        menu.Show()
    }

    ShowMainMenu()
