/**
 * @file BuiltIn_WinWait_03.ahk
 * @description Window waiting patterns for complex scenarios, state machines, and event-driven waiting using WinWait in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 *
 * @section EXAMPLES
 * Example 1: State machine waiter
 * Example 2: Event-driven waiting
 * Example 3: Composite window waiter
 * Example 4: Wait scheduling system
 * Example 5: Dependent window waiter
 * Example 6: Pattern-based waiter
 * Example 7: Wait profiler
 *
 * @section FEATURES
 * - State machines
 * - Event-driven patterns
 * - Composite waiting
 * - Scheduling
 * - Dependencies
 * - Pattern matching
 * - Profiling
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: State Machine Waiter
; ========================================

class StateMachineWaiter {
    static currentState := "Idle"
    static states := Map()

    static DefineState(name, winTitle, transitions, onEnter := "", onExit := "") {
        this.states[name] := {
            Name: name,
            WinTitle: winTitle,
            Transitions: transitions,
            OnEnter: onEnter,
            OnExit: onExit
        }
    }

    static Execute(startState, maxTime := 60) {
        this.currentState := startState
        startTime := A_TickCount

        Loop {
            if !this.states.Has(this.currentState) {
                TrayTip("Invalid state: " this.currentState, "State Machine", "IconX")
                return false
            }

            state := this.states[this.currentState]

            ; Enter state
            if state.OnEnter != "" && IsObject(state.OnEnter)
                state.OnEnter()

            TrayTip("State: " this.currentState, "Waiting for window", "Icon!")

            ; Wait for window
            if WinWait(state.WinTitle, , 10) {
                TrayTip("Window found in state: " this.currentState, "State Machine", "Icon!")

                ; Check transitions
                nextState := this.CheckTransitions(state.Transitions)

                if nextState = "Complete" {
                    if state.OnExit != "" && IsObject(state.OnExit)
                        state.OnExit()
                    return true
                }

                if state.OnExit != "" && IsObject(state.OnExit)
                    state.OnExit()

                this.currentState := nextState
            } else {
                TrayTip("Timeout in state: " this.currentState, "State Machine", "IconX")
                return false
            }

            ; Check overall timeout
            if (A_TickCount - startTime) > (maxTime * 1000) {
                TrayTip("Overall timeout", "State Machine", "IconX")
                return false
            }

            Sleep(500)
        }
    }

    static CheckTransitions(transitions) {
        for transition in transitions {
            if transition.HasOwnProp("Condition") {
                if transition.Condition() {
                    return transition.NextState
                }
            } else {
                return transition.NextState
            }
        }

        return "Complete"
    }
}

^+1:: {
    ; Define states
    StateMachineWaiter.DefineState("Start", "ahk_class Notepad", [
        {NextState: "Process", Condition: () => WinExist("ahk_class Notepad")}
    ], () => TrayTip("Entering Start state", "State", "Icon!"))

    StateMachineWaiter.DefineState("Process", "ahk_class Notepad", [
        {NextState: "Complete"}
    ], () => TrayTip("Processing...", "State", "Icon!"))

    ; Execute state machine
    if StateMachineWaiter.Execute("Start", 30) {
        MsgBox("State machine completed!", "Success", "Icon!")
    } else {
        MsgBox("State machine failed", "Failed", "IconX")
    }
}

; ========================================
; Example 2: Event-Driven Waiting
; ========================================

class EventDrivenWaiter {
    static events := []
    static handlers := Map()

    static On(eventName, handler) {
        if !this.handlers.Has(eventName)
            this.handlers[eventName] := []

        this.handlers[eventName].Push(handler)
    }

    static Emit(eventName, data := "") {
        if this.handlers.Has(eventName) {
            for handler in this.handlers[eventName] {
                handler(data)
            }
        }
    }

    static WaitForEvent(eventName, timeout := 30) {
        this.events.Push({Name: eventName, Triggered: false, Data: ""})
        eventIndex := this.events.Length

        startTime := A_TickCount

        Loop {
            if this.events[eventIndex].Triggered {
                return this.events[eventIndex].Data
            }

            if (A_TickCount - startTime) > (timeout * 1000) {
                return ""
            }

            Sleep(100)
        }
    }

    static TriggerEvent(eventName, data := "") {
        for event in this.events {
            if event.Name = eventName && !event.Triggered {
                event.Triggered := true
                event.Data := data
            }
        }

        this.Emit(eventName, data)
    }
}

; Register event handlers
EventDrivenWaiter.On("WindowAppeared", (data) => TrayTip("Event: Window appeared", data, "Icon!"))

^+2:: {
    ; Start async wait that will trigger event
    AsyncWaiter.WaitAsync("Notepad", (success, winTitle) => {
        if success
            EventDrivenWaiter.TriggerEvent("WindowAppeared", winTitle)
    }, 30)

    ; Wait for the event
    result := EventDrivenWaiter.WaitForEvent("WindowAppeared", 35)

    if result != "" {
        MsgBox("Event received: " result, "Success", "Icon!")
    } else {
        MsgBox("Event timeout", "Failed", "IconX")
    }
}

; ========================================
; Example 3: Composite Window Waiter
; ========================================

class CompositeWaiter {
    static WaitForComposite(components, logic := "AND", timeout := 30) {
        ; logic can be "AND" or "OR"
        startTime := A_TickCount
        found := Map()

        for component in components {
            found[component.Title] := false
        }

        Loop {
            for component in components {
                if !found[component.Title] && WinExist(component.Title) {
                    found[component.Title] := true

                    TrayTip("Component found: " component.Title, "Composite Wait", "Icon!")

                    if component.HasOwnProp("Action")
                        component.Action()
                }
            }

            ; Check completion based on logic
            if logic = "OR" {
                for title, isFound in found {
                    if isFound
                        return {Success: true, Logic: "OR"}
                }
            } else {  ; AND logic
                allFound := true
                for title, isFound in found {
                    if !isFound {
                        allFound := false
                        break
                    }
                }

                if allFound
                    return {Success: true, Logic: "AND"}
            }

            if (A_TickCount - startTime) > (timeout * 1000)
                break

            Sleep(200)
        }

        return {Success: false}
    }
}

^+3:: {
    components := [
        {Title: "Notepad", Action: () => TrayTip("Notepad ready", "Component", "Icon!")},
        {Title: "Calculator", Action: () => TrayTip("Calculator ready", "Component", "Icon!")}
    ]

    result := CompositeWaiter.WaitForComposite(components, "OR", 20)

    if result.Success {
        MsgBox("Composite wait succeeded (" result.Logic " logic)", "Success", "Icon!")
    } else {
        MsgBox("Composite wait failed", "Failed", "IconX")
    }
}

; ========================================
; Example 4: Wait Scheduling System
; ========================================

class WaitScheduler {
    static schedule := []
    static running := false

    static ScheduleWait(winTitle, startDelay, priority := 5, action := "") {
        this.schedule.Push({
            WinTitle: winTitle,
            StartTime: A_TickCount + startDelay,
            Priority: priority,
            Action: action,
            Status: "Scheduled"
        })

        this.SortSchedule()

        if !this.running {
            this.StartScheduler()
        }
    }

    static SortSchedule() {
        ; Sort by start time, then priority
        n := this.schedule.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if this.schedule[j].StartTime > this.schedule[j + 1].StartTime {
                    temp := this.schedule[j]
                    this.schedule[j] := this.schedule[j + 1]
                    this.schedule[j + 1] := temp
                }
            }
        }
    }

    static StartScheduler() {
        this.running := true
        SetTimer(() => this.ProcessSchedule(), 500)
    }

    static ProcessSchedule() {
        if this.schedule.Length = 0 {
            this.running := false
            SetTimer(() => this.ProcessSchedule(), 0)
            return
        }

        currentTime := A_TickCount

        for index, task in this.schedule {
            if task.Status = "Scheduled" && currentTime >= task.StartTime {
                task.Status := "Running"

                TrayTip("Starting scheduled wait: " task.WinTitle, "Scheduler", "Icon!")

                ; Start async wait
                AsyncWaiter.WaitAsync(task.WinTitle, (success, title) => {
                    if success && task.Action != "" && IsObject(task.Action) {
                        task.Action()
                    }
                    task.Status := success ? "Complete" : "Failed"
                }, 10)
            }
        }

        ; Remove completed tasks
        newSchedule := []
        for task in this.schedule {
            if task.Status = "Scheduled" || task.Status = "Running" {
                newSchedule.Push(task)
            }
        }
        this.schedule := newSchedule
    }
}

^+4:: {
    WaitScheduler.ScheduleWait("Notepad", 2000, 1, () => TrayTip("Notepad action", "Scheduled"))
    WaitScheduler.ScheduleWait("Calculator", 5000, 2, () => TrayTip("Calc action", "Scheduled"))

    TrayTip("Scheduled 2 waits", "Scheduler", "Icon!")
}

; ========================================
; Example 5: Dependent Window Waiter
; ========================================

class DependentWaiter {
    static WaitWithDependencies(rootWindow, dependencies, timeout := 30) {
        ; Wait for root window first
        if !WinWait(rootWindow.Title, , timeout) {
            return {Success: false, Stage: "Root"}
        }

        TrayTip("Root window appeared: " rootWindow.Title, "Dependent Wait", "Icon!")

        if rootWindow.HasOwnProp("Action")
            rootWindow.Action()

        ; Wait for dependencies
        for index, dep in dependencies {
            if !WinWait(dep.Title, , dep.HasOwnProp("Timeout") ? dep.Timeout : 10) {
                return {Success: false, Stage: "Dependency " index}
            }

            TrayTip("Dependency met: " dep.Title, "Dependent Wait", "Icon!")

            if dep.HasOwnProp("Action")
                dep.Action()

            if dep.HasOwnProp("Delay")
                Sleep(dep.Delay)
        }

        return {Success: true, Stage: "Complete"}
    }
}

^+5:: {
    root := {
        Title: "ahk_class Notepad",
        Action: () => Send("Hello from dependency system")
    }

    deps := [
        {Title: "ahk_class Notepad", Timeout: 5, Delay: 500}
    ]

    result := DependentWaiter.WaitWithDependencies(root, deps, 30)

    if result.Success {
        MsgBox("All dependencies met!", "Success", "Icon!")
    } else {
        MsgBox("Failed at: " result.Stage, "Failed", "IconX")
    }
}

; ========================================
; Example 6: Pattern-Based Waiter
; ========================================

class PatternWaiter {
    static WaitForPattern(pattern, timeout := 30) {
        startTime := A_TickCount
        allWindows := []

        Loop {
            currentWindows := WinGetList()

            for winId in currentWindows {
                try {
                    title := WinGetTitle("ahk_id " winId)
                    className := WinGetClass("ahk_id " winId)

                    if this.MatchesPattern(title, className, pattern) {
                        return {
                            Found: true,
                            WinID: winId,
                            Title: title,
                            Class: className
                        }
                    }
                }
            }

            if (A_TickCount - startTime) > (timeout * 1000)
                break

            Sleep(200)
        }

        return {Found: false}
    }

    static MatchesPattern(title, className, pattern) {
        if pattern.HasOwnProp("TitleRegex") && !(title ~= pattern.TitleRegex)
            return false

        if pattern.HasOwnProp("ClassRegex") && !(className ~= pattern.ClassRegex)
            return false

        if pattern.HasOwnProp("TitleContains") && !InStr(title, pattern.TitleContains)
            return false

        if pattern.HasOwnProp("ClassContains") && !InStr(className, pattern.ClassContains)
            return false

        return true
    }
}

^+6:: {
    pattern := {
        ClassContains: "Notepad",
        TitleRegex: ".*\.txt"
    }

    result := PatternWaiter.WaitForPattern(pattern, 20)

    if result.Found {
        MsgBox("Pattern matched:`n" result.Title "`n" result.Class, "Success", "Icon!")
    } else {
        MsgBox("No window matched pattern", "Failed", "IconX")
    }
}

; ========================================
; Example 7: Wait Profiler
; ========================================

class WaitProfiler {
    static profiles := []

    static ProfiledWait(name, winTitle, timeout := 30) {
        profile := {
            Name: name,
            WinTitle: winTitle,
            StartTime: A_TickCount,
            EndTime: 0,
            Duration: 0,
            Success: false,
            Checks: 0
        }

        startTime := A_TickCount
        endTime := startTime + (timeout * 1000)

        Loop {
            profile.Checks++

            if WinExist(winTitle) {
                profile.Success := true
                profile.EndTime := A_TickCount
                profile.Duration := profile.EndTime - profile.StartTime
                this.profiles.Push(profile)
                return true
            }

            if A_TickCount >= endTime
                break

            Sleep(100)
        }

        profile.EndTime := A_TickCount
        profile.Duration := profile.EndTime - profile.StartTime
        this.profiles.Push(profile)

        return false
    }

    static GetStats() {
        if this.profiles.Length = 0
            return "No profiles collected"

        totalDuration := 0
        successful := 0
        totalChecks := 0

        for profile in this.profiles {
            totalDuration += profile.Duration
            if profile.Success
                successful++
            totalChecks += profile.Checks
        }

        avgDuration := totalDuration / this.profiles.Length
        successRate := (successful / this.profiles.Length) * 100

        return {
            TotalProfiles: this.profiles.Length,
            Successful: successful,
            SuccessRate: Round(successRate, 1),
            AvgDuration: Round(avgDuration, 0),
            TotalChecks: totalChecks
        }
    }

    static ExportProfiles() {
        output := "Wait Profiling Results:`n`n"

        for profile in this.profiles {
            output .= profile.Name ": "
            output .= profile.Success ? "Success" : "Failed"
            output .= " (" profile.Duration "ms, " profile.Checks " checks)`n"
        }

        stats := this.GetStats()
        output .= "`nStatistics:`n"
        output .= "Total: " stats.TotalProfiles "`n"
        output .= "Success Rate: " stats.SuccessRate "%`n"
        output .= "Avg Duration: " stats.AvgDuration "ms`n"
        output .= "Total Checks: " stats.TotalChecks

        return output
    }
}

^+7:: {
    WaitProfiler.ProfiledWait("Test1", "Notepad", 10)
    WaitProfiler.ProfiledWait("Test2", "Calculator", 10)

    output := WaitProfiler.ExportProfiles()
    MsgBox(output, "Wait Profile", "Icon!")
}

; Helper for async waiter (minimal version)
class AsyncWaiter {
    static WaitAsync(winTitle, callback, timeout) {
        SetTimer(() => {
            if WinExist(winTitle) {
                callback(true, winTitle)
            }
        }, -timeout * 1000)
    }
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinWait Complex Patterns Ready", "Advanced scenarios available", "Icon!")
}
