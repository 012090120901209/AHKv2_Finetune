#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_Sleep_02.ahk
 * @description Rate limiting and throttling with Sleep in AutoHotkey v2
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2024-01-15
 * 
 * Advanced Sleep examples focusing on rate limiting, request throttling,
 * API call management, and preventing system overload through controlled delays.
 * 
 * @syntax Sleep Delay
 * @see https://www.autohotkey.com/docs/v2/lib/Sleep.htm
 * @requires AutoHotkey v2.0+
 */

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: API Rate Limiter
; ============================================================================
/**
 * Implements rate limiting for API calls
 * Prevents exceeding API quota by controlling request frequency
 */
Example1_APIRateLimiter() {
    myGui := Gui("+AlwaysOnTop", "Example 1: API Rate Limiter")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "API Request Rate Limiter")

    ; Configuration
    myGui.Add("Text", "xm Section", "Rate Limit Configuration:")
    myGui.Add("Text", "xs", "Max Requests per Minute:")
    rateEdit := myGui.Add("Edit", "w100 Number", "10")
    myGui.Add("UpDown", "Range1-100", 10)

    myGui.Add("Text", "xs", "Total Requests to Send:")
    totalEdit := myGui.Add("Edit", "w100 Number", "25")
    myGui.Add("UpDown", "Range1-100", 25)

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
    progressBar := myGui.Add("Progress", "w550 h30 vProgress", 0)
    statsText := myGui.Add("Text", "w550 Center vStats", "Sent: 0/0 | Rate: 0 req/min | Remaining: 0")

    ; Request log
    myGui.Add("Text", "xm", "Request Log:")
    logBox := myGui.Add("Edit", "w550 h250 ReadOnly vLog")

    static requestCount := 0
    static startTime := 0

    ; Log helper
    LogRequest(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Simulate API request
    MakeAPIRequest(requestNum) {
        ; Simulate request processing time
        processingTime := Random(50, 150)
        Sleep(processingTime)

        ; Simulate success/failure (95% success rate)
        success := (Random(0, 100) <= 95)

        return {
            success: success,
            processingTime: processingTime,
            statusCode: success ? 200 : 500
        }
    }

    ; Execute rate-limited requests
    executeBtn := myGui.Add("Button", "xm w270", "Execute Requests")
    clearBtn := myGui.Add("Button", "w270 x+10", "Clear Log")

    executeBtn.OnEvent("Click", (*) => ExecuteRequests())
    ExecuteRequests() {
        maxPerMinute := Integer(rateEdit.Value)
        totalRequests := Integer(totalEdit.Value)

        ; Calculate delay between requests to maintain rate
        delayBetweenRequests := Round(60000 / maxPerMinute)  ; milliseconds

        LogRequest("=== Starting " totalRequests " requests (max " maxPerMinute "/min) ===")
        LogRequest("Delay between requests: " delayBetweenRequests "ms")

        statusText.Value := "Processing requests..."
        requestCount := 0
        startTime := A_TickCount
        successCount := 0
        failCount := 0

        Loop totalRequests {
            requestNum := A_Index

            ; Make request
            LogRequest("Request #" requestNum " - Sending...")
            result := MakeAPIRequest(requestNum)

            requestCount++

            if (result.success) {
                successCount++
                LogRequest("Request #" requestNum " - SUCCESS (200 OK) - " result.processingTime "ms")
            } else {
                failCount++
                LogRequest("Request #" requestNum " - FAILED (500 Error) - " result.processingTime "ms")
            }

            ; Update stats
            elapsed := A_TickCount - startTime
            currentRate := (elapsed > 0) ? Round((requestCount / elapsed) * 60000) : 0
            remaining := totalRequests - requestCount

            progressBar.Value := (requestCount / totalRequests) * 100
            statsText.Value := "Sent: " requestCount "/" totalRequests
                . " | Rate: " currentRate " req/min"
                . " | Remaining: " remaining

            ; Rate limiting delay (except after last request)
            if (requestNum < totalRequests) {
                LogRequest("Rate limit: Waiting " delayBetweenRequests "ms...")
                Sleep(delayBetweenRequests)
            }
        }

        ; Final statistics
        totalTime := A_TickCount - startTime
        avgRate := Round((requestCount / totalTime) * 60000)

        LogRequest("=== Batch Complete ===")
        LogRequest("Total: " requestCount " | Success: " successCount " | Failed: " failCount)
        LogRequest("Time: " totalTime "ms | Avg Rate: " avgRate " req/min")

        statusText.Value := "Complete! Success: " successCount ", Failed: " failCount
        MsgBox("Requests complete!`n`nTotal: " requestCount "`nSuccess: " successCount "`nFailed: " failCount,
            "Done", "Icon!")
    }

    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogRequest("API Rate Limiter ready")
}

; ============================================================================
; EXAMPLE 2: Burst Throttling
; ============================================================================
/**
 * Implements burst throttling with cooldown periods
 * Allows bursts of activity followed by mandatory rest
 */
Example2_BurstThrottling() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Burst Throttling")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Burst Throttling with Cooldown")

    ; Configuration
    myGui.Add("Text", "xm Section", "Burst Configuration:")
    myGui.Add("Text", "xs", "Burst Size (operations per burst):")
    burstEdit := myGui.Add("Edit", "w100 Number", "5")
    myGui.Add("UpDown", "Range1-20", 5)

    myGui.Add("Text", "xs", "Cooldown Between Bursts (ms):")
    cooldownEdit := myGui.Add("Edit", "w100 Number", "2000")
    myGui.Add("UpDown", "Range500-10000", 2000)

    myGui.Add("Text", "xs", "Total Operations:")
    totalEdit := myGui.Add("Edit", "w100 Number", "20")
    myGui.Add("UpDown", "Range1-100", 20)

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
    burstText := myGui.Add("Text", "w550 Center vBurst", "Current Burst: 0/0")
    progressBar := myGui.Add("Progress", "w550 h30 vProgress", 0)

    ; Visual timeline
    myGui.Add("Text", "xm", "Activity Timeline:")
    timelineBox := myGui.Add("Edit", "w550 h200 ReadOnly vTimeline")

    ; Log helper
    LogTimeline(msg) {
        timestamp := FormatTime(, "HH:mm:ss.") SubStr(String(A_TickCount), -2)
        currentLog := timelineBox.Value
        timelineBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(timelineBox.Value) > 8000)
            timelineBox.Value := SubStr(timelineBox.Value, -7000)
    }

    ; Execute with burst throttling
    executeBtn := myGui.Add("Button", "xm w270", "Execute Operations")
    clearBtn := myGui.Add("Button", "w270 x+10", "Clear Timeline")

    executeBtn.OnEvent("Click", (*) => ExecuteBursts())
    ExecuteBursts() {
        burstSize := Integer(burstEdit.Value)
        cooldownMs := Integer(cooldownEdit.Value)
        totalOps := Integer(totalEdit.Value)

        LogTimeline("=== Starting " totalOps " operations in bursts of " burstSize " ===")

        opsCompleted := 0
        burstNum := 0

        while (opsCompleted < totalOps) {
            burstNum++
            currentBurstSize := Min(burstSize, totalOps - opsCompleted)

            LogTimeline(">>> BURST " burstNum " START <<<")
            statusText.Value := "Executing burst " burstNum "..."

            ; Execute burst
            Loop currentBurstSize {
                opsCompleted++
                opNum := A_Index

                burstText.Value := "Current Burst: " opNum "/" currentBurstSize
                progressBar.Value := (opsCompleted / totalOps) * 100

                LogTimeline("  Operation " opsCompleted " (burst " opNum "/" currentBurstSize ") executing...")

                ; Simulate quick operation
                Sleep(100)
            }

            LogTimeline(">>> BURST " burstNum " COMPLETE <<<")

            ; Cooldown if more operations remain
            if (opsCompleted < totalOps) {
                statusText.Value := "Cooldown period..."
                LogTimeline("Cooldown: Waiting " cooldownMs "ms before next burst...")

                ; Show cooldown countdown
                remainingCooldown := cooldownMs
                while (remainingCooldown > 0) {
                    burstText.Value := "Cooldown: " remainingCooldown "ms remaining"
                    Sleep(100)
                    remainingCooldown -= 100
                }

                LogTimeline("Cooldown complete")
            }
        }

        LogTimeline("=== All Operations Complete ===")
        statusText.Value := "Complete! " opsCompleted " operations in " burstNum " bursts"
        burstText.Value := "Finished"

        MsgBox("Operations complete!`n`nTotal: " opsCompleted "`nBursts: " burstNum, "Done", "Icon!")
    }

    clearBtn.OnEvent("Click", (*) => timelineBox.Value := "")

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogTimeline("Burst Throttling system ready")
}

; ============================================================================
; EXAMPLE 3: Sliding Window Rate Limiter
; ============================================================================
/**
 * Implements sliding window rate limiting algorithm
 * More sophisticated than fixed window, prevents burst at window boundaries
 */
Example3_SlidingWindow() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Sliding Window Rate Limiter")
    myGui.SetFont("s10")
    myGui.Add("Text", "w600 Center", "Sliding Window Rate Limiting")

    ; Configuration
    myGui.Add("Text", "xm Section", "Rate Limit Settings:")
    myGui.Add("Text", "xs", "Window Size (seconds):")
    windowEdit := myGui.Add("Edit", "w100 Number", "10")
    myGui.Add("UpDown", "Range1-60", 10)

    myGui.Add("Text", "xs", "Max Operations per Window:")
    maxOpsEdit := myGui.Add("Edit", "w100 Number", "5")
    myGui.Add("UpDown", "Range1-50", 5)

    ; Status
    statusText := myGui.Add("Text", "w600 Center vStatus", "Ready")
    windowText := myGui.Add("Text", "w600 Center vWindow", "Window: 0/5 operations")

    ; Recent operations list
    myGui.Add("Text", "xm", "Recent Operations (within window):")
    opsListBox := myGui.Add("ListBox", "w600 h150 vOpsList")

    ; Log
    myGui.Add("Text", "xm", "Activity Log:")
    logBox := myGui.Add("Edit", "w600 h150 ReadOnly vLog")

    static operationTimes := []
    static attemptCount := 0

    ; Log helper
    LogActivity(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 5000)
            logBox.Value := SubStr(logBox.Value, -4500)
    }

    ; Check if operation allowed
    IsOperationAllowed(windowSizeMs, maxOps) {
        currentTime := A_TickCount
        cutoffTime := currentTime - windowSizeMs

        ; Remove old operations outside window
        newTimes := []
        for opTime in operationTimes {
            if (opTime > cutoffTime)
                newTimes.Push(opTime)
        }
        operationTimes := newTimes

        ; Update display
        UpdateOperationsList()

        return (operationTimes.Length < maxOps)
    }

    ; Record operation
    RecordOperation() {
        operationTimes.Push(A_TickCount)
        UpdateOperationsList()
    }

    ; Update operations list display
    UpdateOperationsList() {
        opsListBox.Delete()

        currentTime := A_TickCount
        for opTime in operationTimes {
            ageMs := currentTime - opTime
            ageSec := Round(ageMs / 1000, 1)
            opsListBox.Add("Operation - " ageSec "s ago")
        }

        windowText.Value := "Window: " operationTimes.Length "/" maxOpsEdit.Value " operations"
    }

    ; Attempt operation
    attemptBtn := myGui.Add("Button", "xm w190", "Attempt Operation")
    autoBtn := myGui.Add("Button", "w190 x+10", "Auto-Attempt (20 ops)")
    clearBtn := myGui.Add("Button", "w190 x+10", "Clear Log")

    attemptBtn.OnEvent("Click", (*) => AttemptOperation())
    AttemptOperation() {
        windowSizeMs := Integer(windowEdit.Value) * 1000
        maxOps := Integer(maxOpsEdit.Value)

        attemptCount++

        if (IsOperationAllowed(windowSizeMs, maxOps)) {
            RecordOperation()
            LogActivity("Attempt #" attemptCount " - ALLOWED")
            statusText.Value := "Operation ALLOWED"
            SoundBeep(600, 100)
        } else {
            LogActivity("Attempt #" attemptCount " - REJECTED (rate limit exceeded)")
            statusText.Value := "Operation REJECTED - Rate limit exceeded!"
            SoundBeep(300, 100)

            ; Calculate wait time
            if (operationTimes.Length > 0) {
                oldestOp := operationTimes[1]
                waitMs := windowSizeMs - (A_TickCount - oldestOp)
                if (waitMs > 0) {
                    waitSec := Round(waitMs / 1000, 1)
                    LogActivity("  Wait " waitSec "s for window to slide")
                }
            }
        }
    }

    ; Auto-attempt multiple operations
    autoBtn.OnEvent("Click", (*) => AutoAttempt())
    AutoAttempt() {
        windowSizeMs := Integer(windowEdit.Value) * 1000
        maxOps := Integer(maxOpsEdit.Value)
        totalAttempts := 20

        LogActivity("=== Auto-attempting " totalAttempts " operations ===")

        allowed := 0
        rejected := 0

        Loop totalAttempts {
            attemptCount++

            if (IsOperationAllowed(windowSizeMs, maxOps)) {
                RecordOperation()
                allowed++
                LogActivity("Auto-attempt " A_Index "/" totalAttempts " - ALLOWED")
            } else {
                rejected++
                LogActivity("Auto-attempt " A_Index "/" totalAttempts " - REJECTED")

                ; Wait a bit before next attempt
                Sleep(500)
            }

            ; Small delay between attempts
            Sleep(200)
        }

        LogActivity("=== Auto-attempt complete: " allowed " allowed, " rejected " rejected ===")
        statusText.Value := "Auto-attempt complete: " allowed " allowed, " rejected " rejected"
    }

    clearBtn.OnEvent("Click", (*) => logBox.Value := "")

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    LogActivity("Sliding Window Rate Limiter ready")
}

; ============================================================================
; EXAMPLE 4: Token Bucket Algorithm
; ============================================================================
/**
 * Implements token bucket rate limiting
 * Allows bursts while maintaining average rate
 */
Example4_TokenBucket() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Token Bucket Rate Limiter")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Token Bucket Algorithm")

    ; Configuration
    myGui.Add("Text", "xm Section", "Token Bucket Configuration:")
    myGui.Add("Text", "xs", "Bucket Capacity:")
    capacityEdit := myGui.Add("Edit", "w100 Number", "10")
    myGui.Add("UpDown", "Range1-50", 10)

    myGui.Add("Text", "xs", "Refill Rate (tokens/second):")
    refillEdit := myGui.Add("Edit", "w100 Number", "2")
    myGui.Add("UpDown", "Range1-20", 2)

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")

    ; Token visualization
    myGui.SetFont("s14 Bold")
    tokenDisplay := myGui.Add("Text", "w550 Center vTokens", "Tokens: 10/10")
    myGui.SetFont("s10 Norm")

    tokenBar := myGui.Add("Progress", "w550 h30 vTokenBar BackgroundGreen", 100)

    ; Log
    myGui.Add("Text", "xm", "Token Activity Log:")
    logBox := myGui.Add("Edit", "w550 h250 ReadOnly vLog")

    static tokens := 10
    static lastRefillTime := A_TickCount
    static isRefilling := false

    ; Log helper
    LogToken(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 8000)
            logBox.Value := SubStr(logBox.Value, -7000)
    }

    ; Update token display
    UpdateTokenDisplay() {
        capacity := Integer(capacityEdit.Value)
        percentage := (tokens / capacity) * 100

        tokenDisplay.Value := "Tokens: " Round(tokens, 2) "/" capacity
        tokenBar.Value := percentage

        ; Change color based on token level
        if (percentage > 60)
            tokenBar.Opt("BackgroundGreen")
        else if (percentage > 30)
            tokenBar.Opt("BackgroundYellow")
        else
            tokenBar.Opt("BackgroundRed")
    }

    ; Refill tokens
    RefillTokens() {
        if (!isRefilling)
            return

        capacity := Integer(capacityEdit.Value)
        refillRate := Integer(refillEdit.Value)

        currentTime := A_TickCount
        elapsed := currentTime - lastRefillTime
        lastRefillTime := currentTime

        ; Calculate tokens to add
        tokensToAdd := (elapsed / 1000) * refillRate

        if (tokensToAdd > 0) {
            oldTokens := tokens
            tokens := Min(tokens + tokensToAdd, capacity)

            if (tokens > oldTokens) {
                added := Round(tokens - oldTokens, 2)
                LogToken("Refilled " added " tokens (now: " Round(tokens, 2) "/" capacity ")")
            }
        }

        UpdateTokenDisplay()
    }

    ; Attempt operation
    AttemptOperation(cost := 1) {
        if (tokens >= cost) {
            tokens -= cost
            LogToken("Operation consumed " cost " token(s) - SUCCESS")
            UpdateTokenDisplay()
            return true
        } else {
            LogToken("Operation needs " cost " token(s) but only " Round(tokens, 2) " available - REJECTED")
            return false
        }
    }

    ; Controls
    op1Btn := myGui.Add("Button", "xm w130", "Operation (1 token)")
    op3Btn := myGui.Add("Button", "w130 x+10", "Operation (3 tokens)")
    op5Btn := myGui.Add("Button", "w130 x+10", "Operation (5 tokens)")
    burstBtn := myGui.Add("Button", "w130 x+10", "Burst (10 ops)")

    startRefillBtn := myGui.Add("Button", "xm w270", "Start Auto-Refill")
    stopRefillBtn := myGui.Add("Button", "w270 x+10", "Stop Auto-Refill")

    ; Operation buttons
    op1Btn.OnEvent("Click", (*) => Op1())
    Op1() {
        if (AttemptOperation(1)) {
            statusText.Value := "Operation successful!"
            SoundBeep(700, 100)
        } else {
            statusText.Value := "Insufficient tokens!"
            SoundBeep(300, 100)
        }
    }

    op3Btn.OnEvent("Click", (*) => Op3())
    Op3() {
        if (AttemptOperation(3)) {
            statusText.Value := "Large operation successful!"
            SoundBeep(700, 100)
        } else {
            statusText.Value := "Insufficient tokens!"
            SoundBeep(300, 100)
        }
    }

    op5Btn.OnEvent("Click", (*) => Op5())
    Op5() {
        if (AttemptOperation(5)) {
            statusText.Value := "Very large operation successful!"
            SoundBeep(700, 100)
        } else {
            statusText.Value := "Insufficient tokens!"
            SoundBeep(300, 100)
        }
    }

    ; Burst test
    burstBtn.OnEvent("Click", (*) => BurstTest())
    BurstTest() {
        LogToken("=== Burst Test: 10 operations ===")
        success := 0
        failed := 0

        Loop 10 {
            if (AttemptOperation(1)) {
                success++
            } else {
                failed++
            }
            Sleep(100)
        }

        LogToken("=== Burst complete: " success " success, " failed " failed ===")
        statusText.Value := "Burst: " success " success, " failed " failed"
    }

    ; Auto-refill control
    startRefillBtn.OnEvent("Click", (*) => StartRefill())
    StartRefill() {
        if (!isRefilling) {
            isRefilling := true
            lastRefillTime := A_TickCount
            SetTimer(RefillTokens, 100)  ; Refill every 100ms

            LogToken("Auto-refill started")
            statusText.Value := "Auto-refill active"

            startRefillBtn.Enabled := false
            stopRefillBtn.Enabled := true
        }
    }

    stopRefillBtn.OnEvent("Click", (*) => StopRefill())
    StopRefill() {
        if (isRefilling) {
            isRefilling := false
            SetTimer(RefillTokens, 0)

            LogToken("Auto-refill stopped")
            statusText.Value := "Auto-refill stopped"

            startRefillBtn.Enabled := true
            stopRefillBtn.Enabled := false
        }
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(RefillTokens, 0)
        myGui.Destroy()
    }

    stopRefillBtn.Enabled := false
    UpdateTokenDisplay()
    myGui.Show()

    LogToken("Token Bucket Rate Limiter ready")
    LogToken("Capacity: " capacityEdit.Value " tokens, Refill: " refillEdit.Value " tokens/second")
}

; ============================================================================
; EXAMPLE 5: Adaptive Rate Limiting
; ============================================================================
/**
 * Implements adaptive rate limiting that adjusts based on success/failure rates
 * Automatically slows down on errors, speeds up on success
 */
Example5_AdaptiveRateLimiting() {
    myGui := Gui("+AlwaysOnTop", "Example 5: Adaptive Rate Limiting")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Adaptive Rate Limiting System")

    ; Status
    statusText := myGui.Add("Text", "w550 Center vStatus", "Ready")
    rateText := myGui.Add("Text", "w550 Center vRate", "Current Rate: 100ms delay")
    healthText := myGui.Add("Text", "w550 Center vHealth", "System Health: 100%")

    ; Statistics
    myGui.Add("Text", "xm", "Statistics:")
    statsText := myGui.Add("Text", "w550 vStats",
        "Requests: 0 | Success: 0 | Errors: 0 | Success Rate: 0%")

    ; Log
    myGui.Add("Text", "xm", "Activity Log:")
    logBox := myGui.Add("Edit", "w550 h300 ReadOnly vLog")

    static currentDelay := 100          ; Start at 100ms
    static minDelay := 50               ; Fastest rate
    static maxDelay := 5000             ; Slowest rate
    static totalRequests := 0
    static successCount := 0
    static errorCount := 0
    static consecutiveErrors := 0

    ; Log helper
    LogAdaptive(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := logBox.Value
        logBox.Value := currentLog . timestamp . " - " . msg . "`r`n"

        if (StrLen(logBox.Value) > 10000)
            logBox.Value := SubStr(logBox.Value, -9000)
    }

    ; Simulate request (varying success rate based on current load)
    SimulateRequest() {
        ; Lower delay = higher load = more likely to fail
        failProbability := Max(0, Min(50, (minDelay / currentDelay) * 25))

        success := (Random(0, 100) > failProbability)

        Sleep(Random(50, 150))  ; Simulate processing

        return success
    }

    ; Adjust rate based on result
    AdjustRate(success) {
        if (success) {
            consecutiveErrors := 0

            ; Gradually speed up on success (decrease delay by 10%)
            currentDelay := Max(minDelay, Round(currentDelay * 0.9))

            LogAdaptive("SUCCESS - Decreasing delay to " currentDelay "ms")
        } else {
            consecutiveErrors++

            ; Slow down on error
            if (consecutiveErrors >= 3) {
                ; Significant slowdown after multiple errors
                currentDelay := Min(maxDelay, Round(currentDelay * 2))
                LogAdaptive("ERROR - Multiple failures! Increasing delay to " currentDelay "ms")
            } else {
                ; Moderate slowdown
                currentDelay := Min(maxDelay, Round(currentDelay * 1.5))
                LogAdaptive("ERROR - Increasing delay to " currentDelay "ms")
            }
        }

        UpdateDisplay()
    }

    ; Update display
    UpdateDisplay() {
        rateText.Value := "Current Rate: " currentDelay "ms delay"

        successRate := (totalRequests > 0) ? Round((successCount / totalRequests) * 100) : 0
        statsText.Value := "Requests: " totalRequests
            . " | Success: " successCount
            . " | Errors: " errorCount
            . " | Success Rate: " successRate "%"

        ; Calculate "health" based on current delay
        health := Round(((maxDelay - currentDelay) / (maxDelay - minDelay)) * 100)
        healthText.Value := "System Health: " health "%"
    }

    ; Execute adaptive requests
    executeBtn := myGui.Add("Button", "xm w270", "Execute 50 Requests")
    resetBtn := myGui.Add("Button", "w270 x+10", "Reset Statistics")

    executeBtn.OnEvent("Click", (*) => ExecuteAdaptive())
    ExecuteAdaptive() {
        numRequests := 50

        LogAdaptive("=== Starting " numRequests " adaptive requests ===")
        statusText.Value := "Processing adaptive requests..."

        Loop numRequests {
            requestNum := A_Index
            totalRequests++

            LogAdaptive("Request #" requestNum " - Delay: " currentDelay "ms")

            ; Make request
            success := SimulateRequest()

            ; Update statistics
            if (success) {
                successCount++
            } else {
                errorCount++
            }

            UpdateDisplay()

            ; Adjust rate based on result
            AdjustRate(success)

            ; Apply current delay before next request
            if (requestNum < numRequests) {
                Sleep(currentDelay)
            }
        }

        successRate := Round((successCount / totalRequests) * 100)

        LogAdaptive("=== Batch complete ===")
        LogAdaptive("Final rate: " currentDelay "ms | Success rate: " successRate "%")

        statusText.Value := "Complete! Success rate: " successRate "%"
        MsgBox("Adaptive requests complete!`n`nSuccess rate: " successRate "%`nFinal delay: " currentDelay "ms",
            "Done", "Icon!")
    }

    resetBtn.OnEvent("Click", (*) => ResetStats())
    ResetStats() {
        currentDelay := 100
        totalRequests := 0
        successCount := 0
        errorCount := 0
        consecutiveErrors := 0

        UpdateDisplay()
        LogAdaptive("Statistics reset")
        statusText.Value := "Ready"
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()

    UpdateDisplay()
    LogAdaptive("Adaptive Rate Limiting system ready")
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "Sleep Examples - Rate Limiting")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Rate Limiting Examples")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: API Rate Limiter").OnEvent("Click", (*) => Example1_APIRateLimiter())
MainMenu.Add("Button", "w450", "Example 2: Burst Throttling").OnEvent("Click", (*) => Example2_BurstThrottling())
MainMenu.Add("Button", "w450", "Example 3: Sliding Window").OnEvent("Click", (*) => Example3_SlidingWindow())
MainMenu.Add("Button", "w450", "Example 4: Token Bucket").OnEvent("Click", (*) => Example4_TokenBucket())
MainMenu.Add("Button", "w450", "Example 5: Adaptive Rate Limiting").OnEvent("Click", (*) => Example5_AdaptiveRateLimiting())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
