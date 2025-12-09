/**
* @file BuiltIn_Sleep_01.ahk
* @description Comprehensive examples of Sleep function for delays in AutoHotkey v2
* @author AutoHotkey v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*
* Sleep pauses the script for a specified amount of time. Essential for adding
* delays between actions, preventing race conditions, and creating timed sequences.
*
* @syntax Sleep Delay
* @param {Integer} Delay - Time to pause in milliseconds (1000ms = 1 second)
*
* @see https://www.autohotkey.com/docs/v2/lib/Sleep.htm
* @requires AutoHotkey v2.0+
*/

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Basic Sleep Delays
; ============================================================================
/**
* Demonstrates basic Sleep usage with different delay durations
* Shows how Sleep pauses script execution
*/
Example1_BasicSleep() {
    myGui := Gui("+AlwaysOnTop", "Example 1: Basic Sleep Delays")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Basic Sleep Delay Demonstration")

    ; Status display
    statusText := myGui.Add("Text", "w500 Center vStatus", "Ready")
    progressBar := myGui.Add("Progress", "w500 h30 vProgress", 0)

    ; Log display
    myGui.Add("Text", "xm", "Execution Log:")
    logBox := myGui.Add("Edit", "w500 h250 ReadOnly vLog")

    ; Delay buttons
    myGui.Add("Text", "xm", "`nTry Different Delays:")
    btn100ms := myGui.Add("Button", "w120", "100ms Delay")
    btn500ms := myGui.Add("Button", "w120 x+10", "500ms Delay")
    btn1s := myGui.Add("Button", "w120 x+10", "1s Delay")
    btn3s := myGui.Add("Button", "w120 x+10", "3s Delay")

    ; Sequence button
    sequenceBtn := myGui.Add("Button", "xm w500", "Run Timed Sequence")
    clearBtn := myGui.Add("Button", "w500", "Clear Log")

    ; Log helper
    LogMsg(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(String(A_TickCount), -2)
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"
    }

    ; 100ms delay
    btn100ms.OnEvent("Click", (*) => Test100ms())
    Test100ms() {
        statusText.Value := "Executing 100ms delay..."
        LogMsg("Starting 100ms delay")

        startTime := A_TickCount
        Sleep(100)
        elapsed := A_TickCount - startTime

        LogMsg("100ms delay completed (actual: " elapsed "ms)")
        statusText.Value := "Ready"
    }

    ; 500ms delay
    btn500ms.OnEvent("Click", (*) => Test500ms())
    Test500ms() {
        statusText.Value := "Executing 500ms delay..."
        LogMsg("Starting 500ms delay")

        startTime := A_TickCount
        Sleep(500)
        elapsed := A_TickCount - startTime

        LogMsg("500ms delay completed (actual: " elapsed "ms)")
        statusText.Value := "Ready"
    }

    ; 1 second delay
    btn1s.OnEvent("Click", (*) => Test1s())
    Test1s() {
        statusText.Value := "Executing 1 second delay..."
        LogMsg("Starting 1000ms delay")

        startTime := A_TickCount
        Sleep(1000)
        elapsed := A_TickCount - startTime

        LogMsg("1000ms delay completed (actual: " elapsed "ms)")
        statusText.Value := "Ready"
    }

    ; 3 second delay
    btn3s.OnEvent("Click", (*) => Test3s())
    Test3s() {
        statusText.Value := "Executing 3 second delay..."
        LogMsg("Starting 3000ms delay")

        startTime := A_TickCount
        Sleep(3000)
        elapsed := A_TickCount - startTime

        LogMsg("3000ms delay completed (actual: " elapsed "ms)")
        statusText.Value := "Ready"
    }

    ; Timed sequence
    sequenceBtn.OnEvent("Click", (*) => RunSequence())
    RunSequence() {
        LogMsg("=== Starting Timed Sequence ===")

        steps := [
        {
            delay: 500, msg: "Step 1: Initializing..."},
            {
                delay: 1000, msg: "Step 2: Loading data..."},
                {
                    delay: 750, msg: "Step 3: Processing..."},
                    {
                        delay: 500, msg: "Step 4: Validating..."},
                        {
                            delay: 250, msg: "Step 5: Finalizing..."
                        }
                        ]

                        totalSteps := steps.Length
                        for index, step in steps {
                            statusText.Value := step.msg
                            progressBar.Value := (index / totalSteps) * 100
                            LogMsg(step.msg)

                            Sleep(step.delay)
                        }

                        progressBar.Value := 100
                        statusText.Value := "Sequence complete!"
                        LogMsg("=== Sequence Complete ===")

                        Sleep(1000)
                        progressBar.Value := 0
                        statusText.Value := "Ready"
                    }

                    ; Clear log
                    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

                    myGui.OnEvent("Close", (*) => myGui.Destroy())
                    myGui.Show()

                    LogMsg("Basic Sleep demonstration ready")
                }

                ; ============================================================================
                ; EXAMPLE 2: Progressive Delays
                ; ============================================================================
                /**
                * Demonstrates progressive/incremental delays
                * Useful for retry logic with backoff
                */
                Example2_ProgressiveDelays() {
                    myGui := Gui("+AlwaysOnTop", "Example 2: Progressive Delays")
                    myGui.SetFont("s10")
                    myGui.Add("Text", "w550 Center", "Progressive Delay Patterns")

                    ; Status
                    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
                    progressBar := myGui.Add("Progress", "w550 h30 vProgress", 0)

                    ; Configuration
                    myGui.Add("Text", "xm Section", "Delay Pattern:")
                    patternCombo := myGui.Add("DropDownList", "w250", [
                    "Linear (100, 200, 300, 400, 500)",
                    "Exponential (100, 200, 400, 800, 1600)",
                    "Fibonacci (100, 100, 200, 300, 500)",
                    "Fixed (500, 500, 500, 500, 500)"
                    ])
                    patternCombo.Choose(1)

                    ; Log
                    myGui.Add("Text", "xm", "`nExecution Timeline:")
                    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

                    ; Controls
                    runBtn := myGui.Add("Button", "xm w270", "Run Delay Pattern")
                    clearBtn := myGui.Add("Button", "w270 x+10", "Clear Log")

                    ; Log helper
                    LogMsg(msg) {
                        timestamp := A_TickCount
                        currentLog := logBox.Value
                        logBox.Value := currentLog . Format("{:06d}ms", timestamp) . " - " . msg . "`r`n"
                    }

                    ; Generate delay sequence
                    GetDelaySequence(pattern) {
                        switch pattern {
                            case 1: return [100, 200, 300, 400, 500]           ; Linear
                            case 2: return [100, 200, 400, 800, 1600]          ; Exponential
                            case 3: return [100, 100, 200, 300, 500]           ; Fibonacci
                            case 4: return [500, 500, 500, 500, 500]           ; Fixed
                        }
                    }

                    ; Run pattern
                    runBtn.OnEvent("Click", (*) => RunPattern())
                    RunPattern() {
                        pattern := patternCombo.Value
                        delays := GetDelaySequence(pattern)

                        LogMsg("=== Starting Delay Pattern " pattern " ===")
                        statusText.Value := "Running delay pattern..."

                        totalSteps := delays.Length
                        for index, delayMs in delays {
                            progressBar.Value := ((index - 1) / totalSteps) * 100

                            LogMsg("Iteration " index ": Waiting " delayMs "ms...")
                            statusText.Value := "Iteration " index "/" totalSteps " - Delay: " delayMs "ms"

                            startTime := A_TickCount
                            Sleep(delayMs)
                            actualDelay := A_TickCount - startTime

                            LogMsg("Iteration " index ": Completed (actual: " actualDelay "ms)")
                        }

                        progressBar.Value := 100
                        LogMsg("=== Pattern Complete ===")
                        statusText.Value := "Pattern complete!"

                        Sleep(1000)
                        progressBar.Value := 0
                        statusText.Value := "Ready"
                    }

                    ; Clear log
                    clearBtn.OnEvent("Click", (*) => ClearLog())
                    ClearLog() {
                        logBox.Value := ""
                        progressBar.Value := 0
                        statusText.Value := "Ready"
                    }

                    myGui.OnEvent("Close", (*) => myGui.Destroy())
                    myGui.Show()

                    LogMsg("Progressive delay system ready")
                }

                ; ============================================================================
                ; EXAMPLE 3: Sleep in Loops
                ; ============================================================================
                /**
                * Demonstrates using Sleep within loops
                * Important for preventing CPU overuse and creating timed iterations
                */
                Example3_SleepInLoops() {
                    myGui := Gui("+AlwaysOnTop", "Example 3: Sleep in Loops")
                    myGui.SetFont("s10")
                    myGui.Add("Text", "w500 Center", "Using Sleep in Loop Iterations")

                    ; Status
                    statusText := myGui.Add("Text", "w500 Center vStatus", "Ready")
                    iterationText := myGui.Add("Text", "w500 Center vIteration", "Iteration: 0/0")
                    progressBar := myGui.Add("Progress", "w500 h30 vProgress", 0)

                    ; Configuration
                    myGui.Add("Text", "xm Section", "Loop Configuration:")
                    myGui.Add("Text", "xs", "Number of iterations:")
                    iterEdit := myGui.Add("Edit", "w100 Number", "10")
                    myGui.Add("UpDown", "Range1-100", 10)

                    myGui.Add("Text", "xs", "Delay between iterations (ms):")
                    delayEdit := myGui.Add("Edit", "w100 Number", "200")
                    myGui.Add("UpDown", "Range10-5000", 200)

                    ; Visual feedback
                    myGui.Add("Text", "xm", "`nLoop Activity:")
                    activityBox := myGui.Add("Edit", "w500 h250 ReadOnly vActivity")

                    ; Controls
                    startBtn := myGui.Add("Button", "xm w160", "Start Loop")
                    fastLoopBtn := myGui.Add("Button", "w160 x+10", "Fast Loop (No Sleep)")
                    slowLoopBtn := myGui.Add("Button", "w160 x+10", "Slow Loop (1s)")

                    static isRunning := false

                    ; Log activity
                    LogActivity(msg) {
                        timestamp := FormatTime(, "HH:mm:ss")
                        currentLog := activityBox.Value
                        activityBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

                        ; Keep last 20 lines
                        if (StrLen(activityBox.Value) > 5000)
                        activityBox.Value := SubStr(activityBox.Value, -4000)
                    }

                    ; Custom loop
                    startBtn.OnEvent("Click", (*) => RunCustomLoop())
                    RunCustomLoop() {
                        if (isRunning)
                        return

                        isRunning := true
                        iterations := Integer(iterEdit.Value)
                        delayMs := Integer(delayEdit.Value)

                        LogActivity("Starting custom loop: " iterations " iterations, " delayMs "ms delay")
                        statusText.Value := "Running custom loop..."

                        Loop iterations {
                            iterationText.Value := "Iteration: " A_Index "/" iterations
                            progressBar.Value := (A_Index / iterations) * 100

                            LogActivity("Iteration " A_Index " executing...")

                            ; Simulate work
                            Sleep(delayMs)

                            LogActivity("Iteration " A_Index " completed")
                        }

                        statusText.Value := "Loop complete!"
                        LogActivity("Custom loop finished")

                        Sleep(1000)
                        statusText.Value := "Ready"
                        progressBar.Value := 0
                        isRunning := false
                    }

                    ; Fast loop (no sleep) - demonstrates CPU impact
                    fastLoopBtn.OnEvent("Click", (*) => RunFastLoop())
                    RunFastLoop() {
                        if (isRunning)
                        return

                        isRunning := true
                        iterations := 50

                        LogActivity("Starting FAST loop (no Sleep) - may freeze UI briefly")
                        statusText.Value := "Running fast loop (no delays)..."

                        startTime := A_TickCount

                        Loop iterations {
                            iterationText.Value := "Iteration: " A_Index "/" iterations
                            progressBar.Value := (A_Index / iterations) * 100

                            ; No Sleep - immediate execution
                            ; This will complete very quickly but may freeze UI
                        }

                        elapsed := A_TickCount - startTime

                        statusText.Value := "Fast loop complete!"
                        LogActivity("Fast loop completed in " elapsed "ms (avg: " Round(elapsed/iterations, 2) "ms per iteration)")

                        Sleep(1000)
                        statusText.Value := "Ready"
                        progressBar.Value := 0
                        isRunning := false
                    }

                    ; Slow loop (1 second delays)
                    slowLoopBtn.OnEvent("Click", (*) => RunSlowLoop())
                    RunSlowLoop() {
                        if (isRunning)
                        return

                        isRunning := true
                        iterations := 10

                        LogActivity("Starting SLOW loop (1000ms delays)")
                        statusText.Value := "Running slow loop..."

                        startTime := A_TickCount

                        Loop iterations {
                            iterationText.Value := "Iteration: " A_Index "/" iterations
                            progressBar.Value := (A_Index / iterations) * 100

                            LogActivity("Iteration " A_Index " - waiting 1 second...")
                            Sleep(1000)
                        }

                        elapsed := A_TickCount - startTime

                        statusText.Value := "Slow loop complete!"
                        LogActivity("Slow loop completed in " elapsed "ms")

                        Sleep(1000)
                        statusText.Value := "Ready"
                        progressBar.Value := 0
                        isRunning := false
                    }

                    myGui.OnEvent("Close", (*) => myGui.Destroy())
                    myGui.Show()

                    LogActivity("Sleep in Loops demonstration ready")
                }

                ; ============================================================================
                ; EXAMPLE 4: Simulated Loading Screen
                ; ============================================================================
                /**
                * Creates a simulated loading screen with Sleep delays
                * Demonstrates practical use in UI feedback
                */
                Example4_LoadingScreen() {
                    myGui := Gui("+AlwaysOnTop", "Example 4: Simulated Loading")
                    myGui.SetFont("s10")
                    myGui.Add("Text", "w450 Center", "Loading Screen Simulation")

                    ; Loading animation
                    myGui.SetFont("s14 Bold")
                    loadingText := myGui.Add("Text", "w450 Center vLoading", "Ready to Load")

                    myGui.SetFont("s10 Norm")
                    progressBar := myGui.Add("Progress", "w450 h30 vProgress", 0)
                    percentText := myGui.Add("Text", "w450 Center vPercent", "0%")

                    ; Status messages
                    statusText := myGui.Add("Text", "w450 Center h40 vStatus", "Click 'Start Loading' to begin")

                    ; Controls
                    startBtn := myGui.Add("Button", "xm w140", "Start Loading")
                    fastBtn := myGui.Add("Button", "w140 x+10", "Fast Load")
                    slowBtn := myGui.Add("Button", "w140 x+10", "Slow Load")

                    ; Loading phases with delays
                    static loadingPhases := [
                    {
                        name: "Initializing system...", delay: 300},
                        {
                            name: "Loading resources...", delay: 500},
                            {
                                name: "Connecting to services...", delay: 700},
                                {
                                    name: "Validating data...", delay: 400},
                                    {
                                        name: "Building interface...", delay: 600},
                                        {
                                            name: "Applying settings...", delay: 350},
                                            {
                                                name: "Finalizing...", delay: 450
                                            }
                                            ]

                                            ; Animated dots for loading
                                            AnimateLoading(phase, duration) {
                                                steps := duration // 100  ; Update every 100ms
                                                Loop steps {
                                                    dots := Mod(A_Index, 4)
                                                    dotStr := ""
                                                    Loop dots
                                                    dotStr .= "."

                                                    loadingText.Value := phase . dotStr
                                                    Sleep(100)
                                                }
                                            }

                                            ; Simulate loading
                                            SimulateLoading(speedMultiplier := 1.0) {
                                                progressBar.Value := 0
                                                totalPhases := loadingPhases.Length

                                                Loop totalPhases {
                                                    phase := loadingPhases[A_Index]
                                                    adjustedDelay := Round(phase.delay * speedMultiplier)

                                                    ; Update progress
                                                    progress := (A_Index / totalPhases) * 100
                                                    progressBar.Value := progress
                                                    percentText.Value := Round(progress) "%"

                                                    statusText.Value := phase.name

                                                    ; Animated loading text
                                                    AnimateLoading(phase.name, adjustedDelay)
                                                }

                                                ; Complete
                                                progressBar.Value := 100
                                                percentText.Value := "100%"
                                                loadingText.Value := "Loading Complete!"
                                                statusText.Value := "All systems ready"

                                                SoundBeep(800, 200)
                                            }

                                            ; Normal loading
                                            startBtn.OnEvent("Click", (*) => StartNormal())
                                            StartNormal() {
                                                loadingText.Value := "Starting..."
                                                Sleep(200)
                                                SimulateLoading(1.0)

                                                Sleep(1500)
                                                loadingText.Value := "Ready to Load"
                                                statusText.Value := "Click 'Start Loading' to begin"
                                                progressBar.Value := 0
                                                percentText.Value := "0%"
                                            }

                                            ; Fast loading
                                            fastBtn.OnEvent("Click", (*) => StartFast())
                                            StartFast() {
                                                loadingText.Value := "Starting (Fast Mode)..."
                                                Sleep(100)
                                                SimulateLoading(0.3)  ; 30% of normal time

                                                Sleep(1500)
                                                loadingText.Value := "Ready to Load"
                                                statusText.Value := "Click 'Start Loading' to begin"
                                                progressBar.Value := 0
                                                percentText.Value := "0%"
                                            }

                                            ; Slow loading
                                            slowBtn.OnEvent("Click", (*) => StartSlow())
                                            StartSlow() {
                                                loadingText.Value := "Starting (Slow Mode)..."
                                                Sleep(300)
                                                SimulateLoading(2.0)  ; 200% of normal time

                                                Sleep(1500)
                                                loadingText.Value := "Ready to Load"
                                                statusText.Value := "Click 'Start Loading' to begin"
                                                progressBar.Value := 0
                                                percentText.Value := "0%"
                                            }

                                            myGui.OnEvent("Close", (*) => myGui.Destroy())
                                            myGui.Show()
                                        }

                                        ; ============================================================================
                                        ; EXAMPLE 5: Typing Simulation with Sleep
                                        ; ============================================================================
                                        /**
                                        * Simulates human typing with realistic delays
                                        * Demonstrates Sleep for creating natural timing
                                        */
                                        Example5_TypingSimulation() {
                                            myGui := Gui("+AlwaysOnTop", "Example 5: Typing Simulation")
                                            myGui.SetFont("s10")
                                            myGui.Add("Text", "w500 Center", "Realistic Typing Simulation")

                                            ; Input area
                                            myGui.Add("Text", "xm", "Text to Type:")
                                            inputBox := myGui.Add("Edit", "w500 h100 vInput",
                                            "The quick brown fox jumps over the lazy dog. "
                                            "This demonstrates realistic typing simulation with variable delays.")

                                            ; Output area
                                            myGui.Add("Text", "xm", "`nSimulated Output:")
                                            outputBox := myGui.Add("Edit", "w500 h100 ReadOnly vOutput")

                                            ; Speed control
                                            myGui.Add("Text", "xm", "`nTyping Speed:")
                                            speedCombo := myGui.Add("DropDownList", "w200", [
                                            "Very Fast (50ms avg)",
                                            "Fast (100ms avg)",
                                            "Normal (150ms avg)",
                                            "Slow (250ms avg)",
                                            "Very Slow (400ms avg)"
                                            ])
                                            speedCombo.Choose(3)

                                            ; Statistics
                                            statsText := myGui.Add("Text", "w500 vStats", "Characters: 0 | Time: 0ms | Speed: 0 CPM")

                                            ; Controls
                                            typeBtn := myGui.Add("Button", "xm w160", "Start Typing")
                                            stopBtn := myGui.Add("Button", "w160 x+10", "Stop")
                                            clearBtn := myGui.Add("Button", "w160 x+10", "Clear Output")

                                            static isTyping := false

                                            ; Get delay based on speed setting
                                            GetTypingDelay(speed) {
                                                baseDelay := 0
                                                switch speed {
                                                    case 1: baseDelay := 50   ; Very Fast
                                                    case 2: baseDelay := 100  ; Fast
                                                    case 3: baseDelay := 150  ; Normal
                                                    case 4: baseDelay := 250  ; Slow
                                                    case 5: baseDelay := 400  ; Very Slow
                                                }

                                                ; Add randomness for realism (±30%)
                                                variation := baseDelay * 0.3
                                                return baseDelay + Random(-variation, variation)
                                            }

                                            ; Simulate typing
                                            typeBtn.OnEvent("Click", (*) => StartTyping())
                                            StartTyping() {
                                                if (isTyping)
                                                return

                                                text := inputBox.Value
                                                if (text = "")
                                                return

                                                isTyping := true
                                                outputBox.Value := ""

                                                speed := speedCombo.Value
                                                startTime := A_TickCount
                                                charCount := StrLen(text)

                                                Loop Parse text {
                                                    if (!isTyping)
                                                    break

                                                    ; Add character
                                                    outputBox.Value .= A_LoopField

                                                    ; Calculate statistics
                                                    elapsed := A_TickCount - startTime
                                                    avgDelay := (A_Index > 0) ? Round(elapsed / A_Index) : 0
                                                    cpm := (elapsed > 0) ? Round((A_Index / elapsed) * 60000) : 0

                                                    statsText.Value := "Characters: " A_Index "/" charCount
                                                    . " | Time: " elapsed "ms"
                                                    . " | Speed: " cpm " CPM"

                                                    ; Delay before next character
                                                    delay := GetTypingDelay(speed)
                                                    Sleep(delay)
                                                }

                                                isTyping := false

                                                if (outputBox.Value = text) {
                                                    MsgBox("Typing simulation complete!", "Done", "Icon!")
                                                }
                                            }

                                            ; Stop typing
                                            stopBtn.OnEvent("Click", (*) => isTyping := false)

                                            ; Clear output
                                            clearBtn.OnEvent("Click", (*) => ClearOutput())
                                            ClearOutput() {
                                                outputBox.Value := ""
                                                statsText.Value := "Characters: 0 | Time: 0ms | Speed: 0 CPM"
                                            }

                                            myGui.OnEvent("Close", (*) => Cleanup())
                                            Cleanup() {
                                                isTyping := false
                                                myGui.Destroy()
                                            }

                                            myGui.Show()
                                        }

                                        ; ============================================================================
                                        ; EXAMPLE 6: Retry Logic with Exponential Backoff
                                        ; ============================================================================
                                        /**
                                        * Implements retry logic with exponential backoff delays
                                        * Common pattern for handling transient failures
                                        */
                                        Example6_RetryLogic() {
                                            myGui := Gui("+AlwaysOnTop", "Example 6: Retry Logic")
                                            myGui.SetFont("s10")
                                            myGui.Add("Text", "w550 Center", "Retry with Exponential Backoff")

                                            ; Configuration
                                            myGui.Add("Text", "xm Section", "Retry Configuration:")
                                            myGui.Add("Text", "xs", "Max Retries:")
                                            retriesEdit := myGui.Add("Edit", "w100 Number", "5")
                                            myGui.Add("UpDown", "Range1-10", 5)

                                            myGui.Add("Text", "xs", "Initial Delay (ms):")
                                            delayEdit := myGui.Add("Edit", "w100 Number", "100")
                                            myGui.Add("UpDown", "Range50-1000", 100)

                                            myGui.Add("Text", "xs", "Success Rate (%):")
                                            successEdit := myGui.Add("Edit", "w100 Number", "30")
                                            myGui.Add("UpDown", "Range0-100", 30)

                                            ; Status
                                            statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
                                            attemptText := myGui.Add("Text", "w550 Center vAttempt", "Attempt: 0/0")

                                            ; Log
                                            myGui.Add("Text", "xm", "Retry Log:")
                                            logBox := myGui.Add("Edit", "w550 h250 ReadOnly vLog")

                                            ; Log helper
                                            LogRetry(msg) {
                                                timestamp := FormatTime(, "HH:mm:ss")
                                                currentLog := logBox.Value
                                                logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"
                                            }

                                            ; Simulate operation with possible failure
                                            AttemptOperation(successRate) {
                                                return (Random(0, 100) <= successRate)
                                            }

                                            ; Execute with retry
                                            executeBtn := myGui.Add("Button", "xm w270", "Execute with Retry")
                                            clearBtn := myGui.Add("Button", "w270 x+10", "Clear Log")

                                            executeBtn.OnEvent("Click", (*) => ExecuteWithRetry())
                                            ExecuteWithRetry() {
                                                maxRetries := Integer(retriesEdit.Value)
                                                initialDelay := Integer(delayEdit.Value)
                                                successRate := Integer(successEdit.Value)

                                                LogRetry("=== Starting operation (success rate: " successRate "%) ===")
                                                statusText.Value := "Attempting operation..."

                                                currentDelay := initialDelay
                                                attempt := 0

                                                Loop maxRetries {
                                                    attempt := A_Index
                                                    attemptText.Value := "Attempt: " attempt "/" maxRetries

                                                    LogRetry("Attempt " attempt " starting...")
                                                    statusText.Value := "Attempt " attempt "/" maxRetries " in progress..."

                                                    ; Attempt operation
                                                    success := AttemptOperation(successRate)

                                                    if (success) {
                                                        LogRetry("SUCCESS on attempt " attempt "!")
                                                        statusText.Value := "Operation succeeded!"
                                                        MsgBox("Operation completed successfully on attempt " attempt "!", "Success", "Icon!")
                                                        return
                                                    } else {
                                                        LogRetry("FAILED - Attempt " attempt " unsuccessful")

                                                        if (attempt < maxRetries) {
                                                            LogRetry("Waiting " currentDelay "ms before retry...")
                                                            statusText.Value := "Waiting " currentDelay "ms before retry..."

                                                            Sleep(currentDelay)

                                                            ; Exponential backoff
                                                            currentDelay := currentDelay * 2
                                                        } else {
                                                            LogRetry("Max retries reached - Operation FAILED")
                                                            statusText.Value := "Operation failed after " maxRetries " attempts"
                                                            MsgBox("Operation failed after " maxRetries " attempts.", "Failed", "Icon!")
                                                        }
                                                    }
                                                }
                                            }

                                            clearBtn.OnEvent("Click", (*) => logBox.Value := "")

                                            myGui.OnEvent("Close", (*) => myGui.Destroy())
                                            myGui.Show()

                                            LogRetry("Retry logic system ready")
                                        }

                                        ; ============================================================================
                                        ; MAIN MENU
                                        ; ============================================================================
                                        MainMenu := Gui(, "Sleep Examples - Delays")
                                        MainMenu.SetFont("s10")
                                        MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Sleep Delay Examples")
                                        MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

                                        MainMenu.Add("Button", "w450", "Example 1: Basic Sleep Delays").OnEvent("Click", (*) => Example1_BasicSleep())
                                        MainMenu.Add("Button", "w450", "Example 2: Progressive Delays").OnEvent("Click", (*) => Example2_ProgressiveDelays())
                                        MainMenu.Add("Button", "w450", "Example 3: Sleep in Loops").OnEvent("Click", (*) => Example3_SleepInLoops())
                                        MainMenu.Add("Button", "w450", "Example 4: Loading Screen").OnEvent("Click", (*) => Example4_LoadingScreen())
                                        MainMenu.Add("Button", "w450", "Example 5: Typing Simulation").OnEvent("Click", (*) => Example5_TypingSimulation())
                                        MainMenu.Add("Button", "w450", "Example 6: Retry Logic").OnEvent("Click", (*) => Example6_RetryLogic())

                                        MainMenu.Add("Text", "w450 Center", "`n")
                                        MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

                                        MainMenu.Show()
