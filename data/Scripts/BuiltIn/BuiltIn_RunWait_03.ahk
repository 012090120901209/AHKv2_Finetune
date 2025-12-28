#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Examples - RunWait Function (Part 3: Timeouts)
 * ============================================================================
 * 
 * Handling timeouts and long-running processes with RunWait.
 * 
 * @description Examples for timeout handling and monitoring long processes
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * TIMEOUT CHALLENGES:
 *   RunWait blocks indefinitely - there's no built-in timeout
 *   Solutions:
 *   - Use SetTimer to monitor duration
 *   - Run process separately and monitor with ProcessExist
 *   - Create wrapper scripts with timeout logic
 * 
 * IMPORTANT NOTE:
 *   Since RunWait blocks, you cannot check A_TickCount during execution.
 *   You must use alternative strategies for timeout handling.
 */

; ============================================================================
; Example 1: The Timeout Problem
; ============================================================================
; Demonstrates why RunWait needs timeout handling

Example1_TimeoutProblem() {
    MsgBox("Example 1: The Timeout Problem`n`n" .
        "Understand why timeout handling is important with RunWait:",
        "RunWait - Example 1", "Icon!")

    testDir := A_Temp . "\ahk_timeout_demo"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create long-running process
        longBat := testDir . "\long_process.bat"
        FileAppend("
        (
        @echo off
        echo This process will run for 30 seconds...
        echo.
        echo Without timeout handling, your script would be blocked!
        echo.
        timeout /t 30 /nobreak
        echo Process complete!
        pause
        )", longBat)

        result := MsgBox("Demonstrate the blocking problem?`n`n" .
            "WARNING: This will launch a 30-second process.`n" .
            "You can close it early by closing the CMD window.`n`n" .
            "Run demonstration?",
            "Timeout Demo", "YesNo Icon?")

        if result = "Yes" {
            MsgBox("Launching 30-second process...`n`n" .
                "The script is now BLOCKED.`n" .
                "You can close the CMD window to continue early.`n`n" .
                "This demonstrates why timeout handling is important!",
                "Running", "T3")

            startTime := A_TickCount

            ; This will block for the entire duration!
            exitCode := RunWait('"' . longBat . '"', testDir)

            elapsed := (A_TickCount - startTime) / 1000

            MsgBox("Process finished!`n`n" .
                "Time elapsed: " . Format("{:.1f}", elapsed) . " seconds`n" .
                "Exit Code: " . exitCode . "`n`n" .
                "The script was blocked this entire time!",
                "Complete", "Icon!")
        }

        MsgBox("Problem demonstrated!`n`n" .
            "RunWait has no built-in timeout - it waits indefinitely.`n" .
            "This can freeze your script if a process hangs!`n`n" .
            "Next examples show solutions...",
            "Problem", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: Timeout with Run + ProcessWait
; ============================================================================
; Alternative approach using Run and ProcessWait with timeout

Example2_RunWithTimeout() {
    MsgBox("Example 2: Timeout with Run + ProcessWaitClose`n`n" .
        "Use Run instead of RunWait, then wait with timeout:",
        "RunWait - Example 2", "Icon!")

    testDir := A_Temp . "\ahk_run_timeout"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create test process
        testBat := testDir . "\test_process.bat"
        FileAppend("
        (
        @echo off
        echo Running process...
        echo This will take 10 seconds
        timeout /t 10 /nobreak
        echo Done!
        exit /b 0
        )", testBat)

        result := MsgBox("Run a process with 5-second timeout?`n`n" .
            "The process takes 10 seconds, but timeout is 5 seconds.`n" .
            "Process will be killed after timeout.",
            "Run Test", "YesNo Icon?")

        if result = "Yes" {
            MsgBox("Starting process with 5-second timeout...", "Starting", "T2")

            ; Use Run (non-blocking) and capture PID
            Run('"' . testBat . '"', testDir, , &pid)

            startTime := A_TickCount
            timeoutSeconds := 5

            ; Wait for process with timeout (using ProcessWaitClose)
            ; Note: ProcessWaitClose returns PID if timeout occurs, 0 if process closed
            timedOut := ProcessWaitClose(pid, timeoutSeconds)

            elapsed := (A_TickCount - startTime) / 1000

            if timedOut {
                ; Process still running - timeout occurred
                MsgBox("TIMEOUT after " . Format("{:.1f}", elapsed) . " seconds!`n`n" .
                    "Process (PID: " . pid . ") is still running.`n" .
                    "Killing process...",
                    "Timeout", "Icon!")

                ProcessClose(pid)

                MsgBox("Process killed due to timeout.`n`n" .
                    "This prevents indefinite blocking!",
                    "Killed", "T3")
            } else {
                ; Process completed before timeout
                MsgBox("Process completed in " . Format("{:.1f}", elapsed) . " seconds.`n`n" .
                    "No timeout needed!",
                    "Complete", "T3")
            }
        }

        MsgBox("Timeout handling demonstrated!`n`n" .
            "Strategy: Use Run + ProcessWaitClose with timeout parameter.`n" .
            "This prevents indefinite blocking.",
            "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 3: RunWait with Progress Monitoring
; ============================================================================
; Monitor long-running RunWait processes

Example3_ProgressMonitoring() {
    MsgBox("Example 3: RunWait with Progress Monitoring`n`n" .
        "Monitor progress of long-running processes:",
        "RunWait - Example 3", "Icon!")

    testDir := A_Temp . "\ahk_progress"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create process that outputs progress
        progressBat := testDir . "\progress_process.bat"
        FileAppend("
        (
        @echo off
        echo Starting process...
        echo.

        for /L %%i in (1,1,10) do (
        echo Progress: %%i/10
        echo %%i > progress.txt
        timeout /t 1 /nobreak >nul
        )
            echo.
            echo Process complete !
            del progress.txt
            exit / b 0
        ) ", progressBat)

        CreateProgressMonitor(testDir, progressBat)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateProgressMonitor(testDir, progressBat) {
    monitorGUI := Gui(, "Process Progress Monitor")
    monitorGUI.SetFont("s10")

    monitorGUI.Add("Text", "w400", "Long-Running Process Monitor")
    monitorGUI.Add("Text", "w400", "Monitor a process that takes 10 seconds to complete:")

    progressBar := monitorGUI.Add("Progress", "w400 h30", 0)
    statusText := monitorGUI.Add("Text", "w400", "Ready to start...")

    runBtn := monitorGUI.Add("Button", "w400 h35", "Start Process")
    runBtn.OnEvent("Click", RunProcess)

    monitorGUI.Add("Button", "w400 h30", "Close").OnEvent("Click", (*) => monitorGUI.Destroy())

    RunProcess(*) {
        runBtn.Enabled := false
        progressBar.Value := 0
        statusText.Text := "Starting process..."

        ; Start process in separate thread
        Run('"' . progressBat . '"', testDir, "Hide", &pid)

        ; Monitor progress file
        monitorTimer := SetTimer(MonitorProgress, 500)

        progressFile := testDir . "\progress.txt"

        MonitorProgress() {
            if !ProcessExist(pid) {
                ; Process finished
                SetTimer(monitorTimer, 0)  ; Stop timer
                progressBar.Value := 100
                statusText.Text := "Process complete!"
                runBtn.Enabled := true
                return
            }

            ; Read progress
            if FileExist(progressFile) {
                try {
                    progressValue := Integer(FileRead(progressFile))
                    progressBar.Value := progressValue * 10
                    statusText.Text := "Processing... " . progressValue . "/10"
                } catch {
                    ; File might be locked, skip this update
                }
            }
        }
    }

    monitorGUI.Show()

    MsgBox("Progress Monitor Created!`n`n" .
        "This monitors a long-running process using Run + SetTimer.`n" .
        "Progress is tracked by reading a file the process updates.`n`n" .
        "Click 'Start Process' to see it in action!",
        "Monitor Ready", "Icon!")
}

; ============================================================================
; Example 4: Batch Processing with Timeout
; ============================================================================
; Process multiple items with per-item timeout

Example4_BatchWithTimeout() {
    MsgBox("Example 4: Batch Processing with Timeout`n`n" .
        "Process multiple items, each with its own timeout:",
        "RunWait - Example 4", "Icon!")

    batchDir := A_Temp . "\ahk_batch_timeout"

    try {
        if !DirExist(batchDir)
            DirCreate(batchDir)

        ; Create processor script
        processorBat := batchDir . "\processor.bat"
        FileAppend("
        (
        @echo off
        echo Processing: %1
        set /a duration=%RANDOM% %% 8 + 1
        echo Duration: %duration% seconds
        timeout /t %duration% /nobreak >nul
        echo Complete: %1
        exit /b 0
        )", processorBat)

        CreateBatchProcessor(batchDir, processorBat)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateBatchProcessor(batchDir, processorBat) {
    batchGUI := Gui(, "Batch Processor with Timeout")
    batchGUI.SetFont("s10")

    batchGUI.Add("Text", "w500", "Batch Processor with Per-Item Timeout")
    batchGUI.Add("Text", "w500", "Process 5 items, each with 5-second timeout:")

    logText := batchGUI.Add("Edit", "w500 h200 +ReadOnly +Multi",
        "Click 'Start Batch' to process 5 items...`n" .
        "Each item has random processing time (1-8 seconds).`n" .
        "Timeout for each item: 5 seconds.")

    startBtn := batchGUI.Add("Button", "w500 h35", "Start Batch Processing")
    startBtn.OnEvent("Click", StartBatch)

    batchGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => batchGUI.Destroy())

    StartBatch(*) {
        startBtn.Enabled := false
        logText.Value := "Starting batch processing...`n`n"

        items := ["Item1", "Item2", "Item3", "Item4", "Item5"]
        timeoutSeconds := 5

        processed := 0
        timedOut := 0

        for index, item in items {
            logText.Value .= "[" . index . "/5] Processing: " . item . "...`n"

            ; Start process
            Run('"' . processorBat . '" "' . item . '"', batchDir, "Hide", &pid)

            startTime := A_TickCount

            ; Wait with timeout
            stillRunning := ProcessWaitClose(pid, timeoutSeconds)

            elapsed := (A_TickCount - startTime) / 1000

            if stillRunning {
                ; Timeout occurred
                logText.Value .= "    ✗ TIMEOUT (" . Format("{:.1f}s", elapsed) . ") - Killing process`n`n"
                ProcessClose(pid)
                timedOut++
            } else {
                ; Completed successfully
                logText.Value .= "    ✓ Complete (" . Format("{:.1f}s", elapsed) . ")`n`n"
                processed++
            }
        }

        logText.Value .= "========================================`n"
        logText.Value .= "BATCH COMPLETE`n"
        logText.Value .= "========================================`n"
        logText.Value .= "Processed: " . processed . "`n"
        logText.Value .= "Timed Out: " . timedOut . "`n"
        logText.Value .= "Total: " . items.Length . "`n"

        startBtn.Enabled := true
    }

    batchGUI.Show()

    MsgBox("Batch Processor Created!`n`n" .
        "This demonstrates batch processing with timeouts.`n" .
        "Each item gets a 5-second timeout.`n`n" .
        "Items taking longer than 5 seconds will be killed.",
        "Processor Ready", "Icon!")
}

; ============================================================================
; Example 5: Smart Timeout with Retry
; ============================================================================
; Implement timeout with automatic retry logic

Example5_TimeoutWithRetry() {
    MsgBox("Example 5: Smart Timeout with Retry`n`n" .
        "Implement timeout handling with automatic retry:",
        "RunWait - Example 5", "Icon!")

    retryDir := A_Temp . "\ahk_retry"

    try {
        if !DirExist(retryDir)
            DirCreate(retryDir)

        ; Create unreliable process
        unreliableBat := retryDir . "\unreliable.bat"
        FileAppend("
        (
        @echo off
        echo Attempt: %1

        REM Random delay (1-10 seconds)
        set /a delay=%RANDOM% %% 10 + 1
        echo Delay: %delay% seconds

        if %delay% GTR 7 (
        echo This will timeout...
        )
            timeout / t %delay% / nobreak > nul
            echo Success !
            exit / b 0
        ) ", unreliableBat)

        CreateRetrySystem(retryDir, unreliableBat)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateRetrySystem(retryDir, unreliableBat) {
    retryGUI := Gui(, "Timeout with Retry System")
    retryGUI.SetFont("s10")

    retryGUI.Add("Text", "w500", "Smart Timeout with Automatic Retry")
    retryGUI.Add("Text", "w500", "Process has random execution time (1-10 seconds).")
    retryGUI.Add("Text", "w500", "Timeout: 6 seconds, Max Retries: 3")

    logText := retryGUI.Add("Edit", "w500 h200 +ReadOnly +Multi",
        "The process will be retried if it times out.`n" .
        "Maximum 3 attempts will be made.`n`n" .
        "Click 'Start' to begin...")

    startBtn := retryGUI.Add("Button", "w500 h35", "Start Process (with retry)")
    startBtn.OnEvent("Click", StartWithRetry)

    retryGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => retryGUI.Destroy())

    StartWithRetry(*) {
        startBtn.Enabled := false

        maxAttempts := 3
        timeoutSeconds := 6
        attempt := 0
        success := false

        logText.Value := "Starting process with retry logic...`n"
        logText.Value .= "Timeout: " . timeoutSeconds . " seconds, Max Attempts: " . maxAttempts . "`n`n"

        while attempt < maxAttempts && !success {
            attempt++
            logText.Value .= "Attempt " . attempt . "/" . maxAttempts . ":`n"

            ; Start process
            Run('"' . unreliableBat . '" "' . attempt . '"', retryDir, "Hide", &pid)

            startTime := A_TickCount

            ; Wait with timeout
            stillRunning := ProcessWaitClose(pid, timeoutSeconds)

            elapsed := (A_TickCount - startTime) / 1000

            if stillRunning {
                ; Timeout
                logText.Value .= "  ✗ TIMEOUT after " . Format("{:.1f}s", elapsed) . " - Killing process`n"
                ProcessClose(pid)

                if attempt < maxAttempts {
                    logText.Value .= "  ↻ Retrying...`n`n"
                    Sleep(1000)
                }
            } else {
                ; Success
                logText.Value .= "  ✓ SUCCESS after " . Format("{:.1f}s", elapsed) . "`n"
                success := true
            }
        }

        logText.Value .= "`n========================================`n"

        if success {
            logText.Value .= "PROCESS COMPLETED SUCCESSFULLY`n"
            logText.Value .= "========================================`n"
            logText.Value .= "Attempts needed: " . attempt . "`n"
        } else {
            logText.Value .= "PROCESS FAILED`n"
            logText.Value .= "========================================`n"
            logText.Value .= "All " . maxAttempts . " attempts timed out`n"
        }

        startBtn.Enabled := true
    }

    retryGUI.Show()

    MsgBox("Retry System Created!`n`n" .
        "This demonstrates timeout handling with automatic retry.`n" .
        "If a process times out, it's automatically retried.`n`n" .
        "Useful for unreliable operations or network processes!",
        "Retry System Ready", "Icon!")
}

; ============================================================================
; Example 6: Parallel Processing with Timeout
; ============================================================================
; Run multiple processes in parallel with timeout monitoring

Example6_ParallelWithTimeout() {
    MsgBox("Example 6: Parallel Processing with Timeout`n`n" .
        "Run multiple processes in parallel, each with timeout:",
        "RunWait - Example 6", "Icon!")

    parallelDir := A_Temp . "\ahk_parallel"

    try {
        if !DirExist(parallelDir)
            DirCreate(parallelDir)

        ; Create worker process
        workerBat := parallelDir . "\worker.bat"
        FileAppend("
        (
        @echo off
        echo Worker %1 started
        set /a duration=%RANDOM% %% 12 + 1
        timeout /t %duration% /nobreak >nul
        echo Worker %1 complete
        exit /b 0
        )", workerBat)

        CreateParallelProcessor(parallelDir, workerBat)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateParallelProcessor(parallelDir, workerBat) {
    parallelGUI := Gui(, "Parallel Processing with Timeout")
    parallelGUI.SetFont("s10")

    parallelGUI.Add("Text", "w500", "Parallel Process Execution with Timeouts")
    parallelGUI.Add("Text", "w500", "Launch 4 workers in parallel, monitor with 8-second timeout:")

    logText := parallelGUI.Add("Edit", "w500 h200 +ReadOnly +Multi",
        "Click 'Start Parallel Processing' to launch 4 workers.`n" .
        "Each worker has random duration (1-12 seconds).`n" .
        "Timeout for each: 8 seconds.")

    startBtn := parallelGUI.Add("Button", "w500 h35", "Start Parallel Processing")
    startBtn.OnEvent("Click", StartParallel)

    parallelGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => parallelGUI.Destroy())

    StartParallel(*) {
        startBtn.Enabled := false

        workerCount := 4
        timeoutSeconds := 8
        workers := []

        logText.Value := "Launching " . workerCount . " workers in parallel...`n`n"

        ; Launch all workers
        Loop workerCount {
            workerID := A_Index
            Run('"' . workerBat . '" "' . workerID . '"', parallelDir, "Hide", &pid)
            workers.Push({ id: workerID, pid: pid, startTime: A_TickCount })
            logText.Value .= "Worker " . workerID . " launched (PID: " . pid . ")`n"
        }

        logText.Value .= "`nMonitoring workers (timeout: " . timeoutSeconds . "s)...`n`n"

        ; Monitor all workers
        completed := 0
        timedOut := 0

        for worker in workers {
            ; Wait for this worker with timeout
            stillRunning := ProcessWaitClose(worker.pid, timeoutSeconds)

            elapsed := (A_TickCount - worker.startTime) / 1000

            if stillRunning {
                logText.Value .= "Worker " . worker.id . ": ✗ TIMEOUT (" . Format("{:.1f}s", elapsed) . ") - Killed`n"
                ProcessClose(worker.pid)
                timedOut++
            } else {
                logText.Value .= "Worker " . worker.id . ": ✓ Complete (" . Format("{:.1f}s", elapsed) . ")`n"
                completed++
            }
        }

        logText.Value .= "`n========================================`n"
        logText.Value .= "ALL WORKERS FINISHED`n"
        logText.Value .= "========================================`n"
        logText.Value .= "Completed: " . completed . "`n"
        logText.Value .= "Timed Out: " . timedOut . "`n"
        logText.Value .= "Total: " . workerCount . "`n"

        startBtn.Enabled := true
    }

    parallelGUI.Show()

    MsgBox("Parallel Processor Created!`n`n" .
        "This launches multiple workers in parallel.`n" .
        "Each worker is monitored independently with timeout.`n`n" .
        "Useful for batch operations with concurrent execution!",
        "Processor Ready", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "RunWait Function Examples (Part 3) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w550", "AutoHotkey v2 - RunWait Function (Timeouts)")
    menu.SetFont("s9")
    menu.Add("Text", "w550", "Select an example to run:")

    menu.Add("Button", "w550 h35", "Example 1: The Timeout Problem").OnEvent("Click", (*) => (menu.Hide(), Example1_TimeoutProblem(), menu.Show()))
    menu.Add("Button", "w550 h35", "Example 2: Timeout with Run + ProcessWaitClose").OnEvent("Click", (*) => (menu.Hide(), Example2_RunWithTimeout(), menu.Show()))
    menu.Add("Button", "w550 h35", "Example 3: RunWait with Progress Monitoring").OnEvent("Click", (*) => (menu.Hide(), Example3_ProgressMonitoring(), menu.Show()))
    menu.Add("Button", "w550 h35", "Example 4: Batch Processing with Timeout").OnEvent("Click", (*) => (menu.Hide(), Example4_BatchWithTimeout(), menu.Show()))
    menu.Add("Button", "w550 h35", "Example 5: Smart Timeout with Retry").OnEvent("Click", (*) => (menu.Hide(), Example5_TimeoutWithRetry(), menu.Show()))
    menu.Add("Button", "w550 h35", "Example 6: Parallel Processing with Timeout").OnEvent("Click", (*) => (menu.Hide(), Example6_ParallelWithTimeout(), menu.Show()))

    menu.Add("Text", "w550 0x10")
    menu.Add("Button", "w550 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
