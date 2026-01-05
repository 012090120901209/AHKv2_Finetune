#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinWait_02.ahk
 * @description Advanced window waiting patterns, retry logic, and async waiting using WinWait in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Retry-based window waiter
 * Example 2: Async window waiting
 * Example 3: Priority-based multi-wait
 * Example 4: Window wait chains
 * Example 5: Smart wait with fallback
 * Example 6: Wait orchestrator
 * 
 * @section FEATURES
 * - Retry logic
 * - Async waiting
 * - Priority handling
 * - Wait chains
 * - Fallback strategies
 * - Orchestration
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Retry-Based Window Waiter
; ========================================

class RetryWaiter {
    static WaitWithRetry(WinTitle, maxRetries := 3, retryDelay := 2000) {
        Loop maxRetries {
            TrayTip("Attempt " A_Index " of " maxRetries, "Retry Wait", "Icon!")

            if WinWait(WinTitle, , 5) {
                TrayTip("Window found on attempt " A_Index, "Success", "Icon!")
                return true
            }

            if A_Index < maxRetries {
                TrayTip("Retry in " (retryDelay / 1000) " seconds...", "Waiting", "Icon!")
                Sleep(retryDelay)
            }
        }

        return false
    }

    static WaitWithBackoff(WinTitle, maxRetries := 5) {
        delay := 1000

        Loop maxRetries {
            if WinWait(WinTitle, , 3) {
                return true
            }

            if A_Index < maxRetries {
                TrayTip("Retry in " (delay / 1000) "s (exponential backoff)", "Waiting", "Icon!")
                Sleep(delay)
                delay *= 2  ; Exponential backoff
            }
        }

        return false
    }
}

^+r:: {
    if RetryWaiter.WaitWithRetry("Notepad", 5, 2000) {
        MsgBox("Notepad found!", "Success", "Icon!")
        WinActivate("Notepad")
    } else {
        MsgBox("Notepad did not appear after retries", "Failed", "IconX")
    }
}

; ========================================
; Example 2: Async Window Waiting
; ========================================

class AsyncWaiter {
    static waiters := Map()

    static WaitAsync(WinTitle, callback, timeout := 30) {
        id := Random()

        this.waiters[id] := {
            WinTitle: WinTitle,
            Callback: callback,
            Timeout: timeout,
            StartTime: A_TickCount,
            Active: true
        }

        ; Start async check
        SetTimer(() => this.CheckWaiter(id), 500)

        return id
    }

    static CheckWaiter(id) {
        if !this.waiters.Has(id)
            return

        waiter := this.waiters[id]

        if !waiter.Active {
            SetTimer(() => this.CheckWaiter(id), 0)
            this.waiters.Delete(id)
            return
        }

        ; Check if window exists
        if WinExist(waiter.WinTitle) {
            waiter.Callback(true, waiter.WinTitle)
            SetTimer(() => this.CheckWaiter(id), 0)
            this.waiters.Delete(id)
            return
        }

        ; Check timeout
        elapsed := (A_TickCount - waiter.StartTime) / 1000
        if elapsed >= waiter.Timeout {
            waiter.Callback(false, waiter.WinTitle)
            SetTimer(() => this.CheckWaiter(id), 0)
            this.waiters.Delete(id)
        }
    }

    static CancelWait(id) {
        if this.waiters.Has(id) {
            this.waiters[id].Active := false
        }
    }
}

; Example async callback
AsyncCallback(success, winTitle) {
    if success {
        TrayTip("Async: Window appeared - " winTitle, "Success", "Icon!")
        WinActivate(winTitle)
    } else {
        TrayTip("Async: Timeout waiting for - " winTitle, "Failed", "Icon!")
    }
}

^+y:: {
    AsyncWaiter.WaitAsync("Notepad", AsyncCallback, 20)
    TrayTip("Async wait started for Notepad", "Background Wait", "Icon!")
}

; ========================================
; Example 3: Priority-Based Multi-Wait
; ========================================

class PriorityWaiter {
    static WaitByPriority(windowsArray) {
        ; windowsArray format: [{Title, Priority, Action}, ...]
        ; Sort by priority (higher first)
        sorted := this.SortByPriority(windowsArray)

        startTime := A_TickCount

        Loop {
            for window in sorted {
                if WinExist(window.Title) {
                    TrayTip("Found priority " window.Priority ": " window.Title, "Priority Wait", "Icon!")

                    if window.HasOwnProp("Action")
                        window.Action()

                    return window
                }
            }

            if (A_TickCount - startTime) > 30000  ; 30 second overall timeout
                break

            Sleep(200)
        }

        return { Title: "", Priority: 0 }
    }

    static SortByPriority(arr) {
        sorted := arr.Clone()
        n := sorted.Length

        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if sorted[j].Priority < sorted[j + 1].Priority {
                    temp := sorted[j]
                    sorted[j] := sorted[j + 1]
                    sorted[j + 1] := temp
                }
            }
        }

        return sorted
    }
}

^+p:: {
    windows := [{
        Title: "Notepad", Priority: 1, Action: () => TrayTip("Notepad action", "Action") }, {
            Title: "Calculator", Priority: 3, Action: () => TrayTip("Calculator action", "Action") }, {
                Title: "Paint", Priority: 2, Action: () => TrayTip("Paint action", "Action")
            }
    ]

    result := PriorityWaiter.WaitByPriority(windows)

    if result.Title != "" {
        MsgBox("Activated: " result.Title " (Priority: " result.Priority ")", "Result", "Icon!")
    } else {
        MsgBox("No windows appeared", "Timeout", "Icon!")
    }
}

; ========================================
; Example 4: Window Wait Chains
; ========================================

class WaitChain {
    static ExecuteChain(chain) {
        for index, step in chain {
            TrayTip("Chain step " index ": " step.Description, "Wait Chain", "Icon!")

            ; Pre-action
            if step.HasOwnProp("PreAction")
                step.PreAction()

            ; Wait for window
            timeout := step.HasOwnProp("Timeout") ? step.Timeout : 10

            if !WinWait(step.WaitFor, , timeout) {
                TrayTip("Chain broken at step " index, "Failed", "IconX")

                if step.HasOwnProp("OnFail")
                    step.OnFail()

                return false
            }

            ; Post-action
            if step.HasOwnProp("PostAction")
                step.PostAction()

            ; Delay before next step
            if step.HasOwnProp("Delay")
                Sleep(step.Delay)
        }

        TrayTip("Chain completed successfully!", "Success", "Icon!")
        return true
    }

    static CreateConditionalChain(steps, condition) {
        filteredSteps := []

        for step in steps {
            if !step.HasOwnProp("Condition") || step.Condition() {
                filteredSteps.Push(step)
            }
        }

        return filteredSteps
    }
}

^+c:: {
    chain := [{
        Description: "Launch Notepad",
        PreAction: () => Run("notepad.exe"),
        WaitFor: "ahk_class Notepad",
        Timeout: 5,
        PostAction: () => TrayTip("Notepad opened", "Step 1", "Icon!"),
        Delay: 1000
    }, {
        Description: "Activate Notepad",
        WaitFor: "ahk_class Notepad",
        PostAction: () => WinActivate("ahk_class Notepad"),
        Delay: 500
    }
    ]

    WaitChain.ExecuteChain(chain)
}

; ========================================
; Example 5: Smart Wait with Fallback
; ========================================

class SmartWait {
    static WaitWithFallback(primaryTitle, fallbackTitles, timeout := 10) {
        ; Try primary first
        if WinWait(primaryTitle, , timeout) {
            TrayTip("Primary window found", primaryTitle, "Icon!")
            return { Type: "Primary", Title: primaryTitle }
        }

        ; Try fallbacks
        for fallback in fallbackTitles {
            if WinExist(fallback) {
                TrayTip("Fallback window found", fallback, "Icon!")
                return { Type: "Fallback", Title: fallback }
            }
        }

        return { Type: "None", Title: "" }
    }

    static WaitWithAlternatives(alternatives, timeout := 30) {
        ; alternatives: [{Title, Score, Action}, ...]
        endTime := A_TickCount + (timeout * 1000)

        Loop {
            for alt in alternatives {
                if WinExist(alt.Title) {
                    TrayTip("Alternative found: " alt.Title, "Smart Wait", "Icon!")

                    if alt.HasOwnProp("Action")
                        alt.Action()

                    return alt
                }
            }

            if A_TickCount >= endTime
                break

            Sleep(200)
        }

        return { Title: "", Score: 0 }
    }

    static AdaptiveWait(WinTitle, checkFunc, maxWait := 30) {
        interval := 500
        elapsed := 0

        Loop {
            if WinExist(WinTitle) {
                if checkFunc(WinTitle) {
                    return true
                }
            }

            elapsed += interval
            if elapsed >= (maxWait * 1000)
                break

            ; Adaptive interval - slower checks over time
            if elapsed > 5000
                interval := 1000
            if elapsed > 15000
                interval := 2000

            Sleep(interval)
        }

        return false
    }
}

^+f:: {
    result := SmartWait.WaitWithFallback("Notepad", ["Calculator", "Paint"], 10)

    if result.Type != "None" {
        MsgBox("Found: " result.Title " (" result.Type ")", "Result", "Icon!")
        WinActivate(result.Title)
    } else {
        MsgBox("No windows found", "Failed", "IconX")
    }
}

; ========================================
; Example 6: Wait Orchestrator
; ========================================

class WaitOrchestrator {
    static jobs := Map()
    static orchestrating := false

    static AddJob(name, WinTitle, priority := 5, callback := "") {
        this.jobs[name] := {
            Name: name,
            WinTitle: WinTitle,
            Priority: priority,
            Callback: callback,
            Status: "Pending",
            StartTime: A_TickCount,
            Found: false
        }

        if !this.orchestrating {
            this.StartOrchestration()
        }
    }

    static StartOrchestration() {
        this.orchestrating := true
        SetTimer(() => this.ProcessJobs(), 500)
    }

    static ProcessJobs() {
        allComplete := true

        for name, job in this.jobs {
            if job.Found
                continue

            allComplete := false

            if WinExist(job.WinTitle) {
                job.Found := true
                job.Status := "Complete"

                TrayTip("Job complete: " name, "Orchestrator", "Icon!")

                if job.Callback != "" && IsFunc(job.Callback)
                    job.Callback(name, job.WinTitle)
            } else {
                ; Check timeout (30 seconds per job)
                if (A_TickCount - job.StartTime) > 30000 {
                    job.Status := "Timeout"
                    job.Found := true  ; Mark as done
                }
            }
        }

        if allComplete {
            this.orchestrating := false
            SetTimer(() => this.ProcessJobs(), 0)
            this.ShowResults()
        }
    }

    static ShowResults() {
        output := "Orchestration Results:`n`n"

        for name, job in this.jobs {
            output .= name ": " job.Status "`n"
        }

        MsgBox(output, "Wait Orchestrator", "Icon!")
    }
}

; Callback for orchestrated jobs
OrchestratedCallback(name, winTitle) {
    TrayTip("Orchestrated window ready", name " - " winTitle, "Icon!")
    WinActivate(winTitle)
}

^+o:: {
    WaitOrchestrator.AddJob("Notepad", "ahk_class Notepad", 1, OrchestratedCallback)
    WaitOrchestrator.AddJob("Calculator", "Calculator", 2, OrchestratedCallback)
    WaitOrchestrator.AddJob("Paint", "Paint", 3, OrchestratedCallback)

    TrayTip("Orchestration started", "3 jobs queued", "Icon!")
}

; Helper function
IsFunc(f) {
    return Type(f) = "Func"
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinWait Advanced Examples Ready", "Multiple patterns available", "Icon!")
}
