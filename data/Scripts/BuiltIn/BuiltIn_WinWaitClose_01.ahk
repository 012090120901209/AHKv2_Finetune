/**
* @file BuiltIn_WinWaitClose_01.ahk
* @description Comprehensive examples demonstrating WinWaitClose function for waiting on window closure in AutoHotkey v2
* @author AutoHotkey Foundation
* @version 2.0
* @date 2024-01-15
*
* @section EXAMPLES
* Example 1: Basic window close waiting
* Example 2: Close with cleanup actions
* Example 3: Multi-window close monitor
* Example 4: Application shutdown sequencer
* Example 5: Close timeout handler
* Example 6: Graceful shutdown orchestrator
* Example 7: Close event listener
*
* @section FEATURES
* - Wait for window closure
* - Cleanup automation
* - Multi-window monitoring
* - Shutdown sequences
* - Timeout handling
* - Graceful shutdowns
* - Event listening
*/

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Window Close Waiting
; ========================================

WaitForClose(WinTitle, timeout := 30) {
    try {
        if WinWaitClose(WinTitle, , timeout) {
            TrayTip("Window closed: " WinTitle, "Close Detected", "Icon!")
            return true
        } else {
            TrayTip("Timeout waiting for close: " WinTitle, "Timeout", "Icon!")
            return false
        }
    } catch as err {
        MsgBox("Error: " err.Message, "Error", "IconX")
        return false
    }
}

^+q:: {
    winTitle := WinGetTitle("A")

    TrayTip("Waiting for window to close...", winTitle, "Icon!")

    if WaitForClose("ahk_id " WinExist("A"), 30) {
        MsgBox("Window was closed!", "Success", "Icon!")
    } else {
        MsgBox("Window still open after 30 seconds", "Timeout", "Icon!")
    }
}

; ========================================
; Example 2: Close with Cleanup Actions
; ========================================

class CloseWithCleanup {
    static WaitAndCleanup(WinTitle, cleanupActions, timeout := 30) {
        winId := WinExist(WinTitle)
        if !winId {
            TrayTip("Window not found", WinTitle, "IconX")
            return false
        }

        TrayTip("Monitoring window for closure...", WinTitle, "Icon!")

        if WinWaitClose("ahk_id " winId, , timeout) {
            TrayTip("Window closed, running cleanup...", "Cleanup", "Icon!")

            for index, action in cleanupActions {
                try {
                    action.Execute()
                    Sleep(action.HasOwnProp("Delay") ? action.Delay : 100)
                } catch as err {
                    TrayTip("Cleanup action " index " failed: " err.Message, "Warning", "Icon!")
                }
            }

            return true
        }

        return false
    }

    static MonitorWithCallback(WinTitle, onClose, timeout := 0) {
        winId := WinExist(WinTitle)
        if !winId
        return false

        SetTimer(() => {
            if !WinExist("ahk_id " winId) {
                onClose(WinTitle)
            }
        }, -timeout * 1000)

        return true
    }
}

^+a:: {
    cleanupActions := [
    {
        Execute: () => TrayTip("Cleanup 1: Saving data", "Cleanup", "Icon!"), Delay: 500},
        {
            Execute: () => TrayTip("Cleanup 2: Releasing resources", "Cleanup", "Icon!"), Delay: 500},
            {
                Execute: () => TrayTip("Cleanup 3: Complete", "Cleanup", "Icon!")
            }
            ]

            CloseWithCleanup.WaitAndCleanup("ahk_class Notepad", cleanupActions, 30)
        }

        ; ========================================
        ; Example 3: Multi-Window Close Monitor
        ; ========================================

        class MultiCloseMonitor {
            static monitors := Map()
            static monitoring := false

            static MonitorWindows(windowList, callback) {
                for win in windowList {
                    winId := WinExist(win.Title)
                    if winId {
                        this.monitors["ahk_id " winId] := {
                            Title: win.Title,
                            Callback: callback,
                            StartTime: A_TickCount
                        }
                    }
                }

                if !this.monitoring {
                    this.monitoring := true
                    SetTimer(() => this.CheckWindows(), 500)
                }
            }

            static CheckWindows() {
                toRemove := []

                for winId, data in this.monitors {
                    if !WinExist(winId) {
                        TrayTip("Window closed: " data.Title, "Close Monitor", "Icon!")
                        data.Callback(data.Title)
                        toRemove.Push(winId)
                    }
                }

                for winId in toRemove {
                    this.monitors.Delete(winId)
                }

                if this.monitors.Count = 0 {
                    this.monitoring := false
                    SetTimer(() => this.CheckWindows(), 0)
                }
            }

            static WaitForAllClose(windowList, timeout := 30) {
                startTime := A_TickCount
                remaining := []

                for win in windowList {
                    if WinExist(win.Title) {
                        remaining.Push(win)
                    }
                }

                Loop {
                    newRemaining := []

                    for win in remaining {
                        if WinExist(win.Title) {
                            newRemaining.Push(win)
                        }
                    }

                    remaining := newRemaining

                    if remaining.Length = 0 {
                        TrayTip("All windows closed", "Success", "Icon!")
                        return true
                    }

                    if (A_TickCount - startTime) > (timeout * 1000) {
                        TrayTip(remaining.Length " windows still open", "Timeout", "Icon!")
                        return false
                    }

                    Sleep(200)
                }
            }
        }

        OnWindowClosed(title) {
            TrayTip("Callback: " title " was closed", "Event", "Icon!")
        }

        ^+m:: {
            windows := [
            {
                Title: "ahk_class Notepad"},
                {
                    Title: "Calculator"
                }
                ]

                MultiCloseMonitor.MonitorWindows(windows, OnWindowClosed)
                TrayTip("Monitoring " windows.Length " windows", "Close Monitor", "Icon!")
            }

            ; ========================================
            ; Example 4: Application Shutdown Sequencer
            ; ========================================

            class ShutdownSequencer {
                static ExecuteShutdown(sequence) {
                    for index, step in sequence {
                        TrayTip("Shutdown step " index ": " step.Description, "Shutdown", "Icon!")

                        ; Execute pre-close action
                        if step.HasOwnProp("PreClose") {
                            try {
                                step.PreClose()
                            } catch as err {
                                TrayTip("Pre-close action failed: " err.Message, "Warning", "Icon!")
                            }
                        }

                        ; Close window if specified
                        if step.HasOwnProp("CloseWindow") {
                            try {
                                WinClose(step.CloseWindow)
                            } catch {
                                TrayTip("Failed to close: " step.CloseWindow, "Warning", "Icon!")
                            }
                        }

                        ; Wait for close
                        if step.HasOwnProp("WaitForClose") {
                            timeout := step.HasOwnProp("Timeout") ? step.Timeout : 10

                            if !WinWaitClose(step.WaitForClose, , timeout) {
                                TrayTip("Timeout waiting for close", step.WaitForClose, "Icon!")

                                ; Force close if specified
                                if step.HasOwnProp("ForceClose") && step.ForceClose {
                                    try {
                                        WinKill(step.WaitForClose)
                                    }
                                }
                            }
                        }

                        ; Execute post-close action
                        if step.HasOwnProp("PostClose") {
                            try {
                                step.PostClose()
                            } catch as err {
                                TrayTip("Post-close action failed: " err.Message, "Warning", "Icon!")
                            }
                        }

                        ; Delay before next step
                        if step.HasOwnProp("Delay") {
                            Sleep(step.Delay)
                        }
                    }

                    TrayTip("Shutdown sequence complete", "Success", "Icon!")
                    return true
                }
            }

            ^+s:: {
                sequence := [
                {
                    Description: "Close Notepad",
                    CloseWindow: "ahk_class Notepad",
                    WaitForClose: "ahk_class Notepad",
                    Timeout: 5,
                    ForceClose: true,
                    PostClose: () => TrayTip("Notepad closed", "Shutdown", "Icon!"),
                    Delay: 1000
                }
                ]

                ShutdownSequencer.ExecuteShutdown(sequence)
            }

            ; ========================================
            ; Example 5: Close Timeout Handler
            ; ========================================

            class CloseTimeoutHandler {
                static WaitWithActions(WinTitle, timeout, onClose, onTimeout) {
                    if WinWaitClose(WinTitle, , timeout) {
                        if IsObject(onClose) {
                            onClose()
                        }
                        return true
                    } else {
                        if IsObject(onTimeout) {
                            onTimeout()
                        }
                        return false
                    }
                }

                static ProgressiveWait(WinTitle, stages) {
                    for index, stage in stages {
                        TrayTip("Stage " index ": Waiting " stage.Timeout "s", "Close Wait", "Icon!")

                        if WinWaitClose(WinTitle, , stage.Timeout) {
                            if stage.HasOwnProp("OnSuccess") {
                                stage.OnSuccess()
                            }
                            return true
                        }

                        if stage.HasOwnProp("OnStageTimeout") {
                            stage.OnStageTimeout()
                        }
                    }

                    TrayTip("All stages exhausted", "Timeout", "Icon!")
                    return false
                }
            }

            ^+t:: {
                winTitle := "ahk_class Notepad"

                CloseTimeoutHandler.WaitWithActions(
                winTitle,
                10,
                () => MsgBox("Window closed successfully", "Success", "Icon!"),
                () => MsgBox("Timeout - window still open", "Timeout", "Icon!")
                )
            }

            ; ========================================
            ; Example 6: Graceful Shutdown Orchestrator
            ; ========================================

            class GracefulShutdown {
                static ShutdownApplication(appInfo) {
                    TrayTip("Initiating graceful shutdown", appInfo.Name, "Icon!")

                    ; Step 1: Send close signal
                    if appInfo.HasOwnProp("CloseHotkey") {
                        WinActivate(appInfo.WinTitle)
                        Send(appInfo.CloseHotkey)
                    } else {
                        WinClose(appInfo.WinTitle)
                    }

                    ; Step 2: Wait for graceful close
                    if WinWaitClose(appInfo.WinTitle, , appInfo.HasOwnProp("GracefulTimeout") ? appInfo.GracefulTimeout : 10) {
                        TrayTip("Application closed gracefully", appInfo.Name, "Icon!")
                        return {Success: true, Method: "Graceful"}
                    }

                    ; Step 3: Try alternative close method
                    if appInfo.HasOwnProp("AlternativeClose") {
                        TrayTip("Trying alternative close method", appInfo.Name, "Icon!")
                        appInfo.AlternativeClose()

                        if WinWaitClose(appInfo.WinTitle, , 5) {
                            return {Success: true, Method: "Alternative"}
                        }
                    }

                    ; Step 4: Force close as last resort
                    if appInfo.HasOwnProp("AllowForce") && appInfo.AllowForce {
                        TrayTip("Force closing application", appInfo.Name, "Icon!")
                        WinKill(appInfo.WinTitle)

                        if WinWaitClose(appInfo.WinTitle, , 5) {
                            return {Success: true, Method: "Force"}
                        }
                    }

                    return {Success: false, Method: "Failed"}
                }
            }

            ^+g:: {
                appInfo := {
                    Name: "Notepad",
                    WinTitle: "ahk_class Notepad",
                    CloseHotkey: "!{F4}",
                    GracefulTimeout: 5,
                    AllowForce: true
                }

                result := GracefulShutdown.ShutdownApplication(appInfo)

                MsgBox("Shutdown " (result.Success ? "successful" : "failed") "`nMethod: " result.Method, "Result", "Icon!")
            }

            ; ========================================
            ; Example 7: Close Event Listener
            ; ========================================

            class CloseEventListener {
                static listeners := []
                static active := false

                static RegisterListener(WinTitle, callback, once := false) {
                    this.listeners.Push({
                        WinTitle: WinTitle,
                        WinID: WinExist(WinTitle),
                        Callback: callback,
                        Once: once,
                        Active: true
                    })

                    if !this.active {
                        this.active := true
                        SetTimer(() => this.CheckListeners(), 500)
                    }

                    return this.listeners.Length
                }

                static CheckListeners() {
                    activeListeners := []

                    for listener in this.listeners {
                        if !listener.Active {
                            continue
                        }

                        if !WinExist("ahk_id " listener.WinID) {
                            ; Window closed
                            listener.Callback(listener.WinTitle)

                            if listener.Once {
                                listener.Active := false
                            } else {
                                ; Re-register if window appears again
                                newId := WinExist(listener.WinTitle)
                                if newId {
                                    listener.WinID := newId
                                }
                            }
                        }

                        if listener.Active || !listener.Once {
                            activeListeners.Push(listener)
                        }
                    }

                    this.listeners := activeListeners

                    if this.listeners.Length = 0 {
                        this.active := false
                        SetTimer(() => this.CheckListeners(), 0)
                    }
                }

                static RemoveListener(index) {
                    if index > 0 && index <= this.listeners.Length {
                        this.listeners.RemoveAt(index)
                    }
                }
            }

            OnNotepadClose(title) {
                TrayTip("Notepad was closed!", title, "Icon!")
                MsgBox("Close event detected for: " title, "Event Listener", "Icon!")
            }

            ^+e:: {
                CloseEventListener.RegisterListener("ahk_class Notepad", OnNotepadClose, true)
                TrayTip("Listening for Notepad close", "Event Listener", "Icon!")
            }

            ; ========================================
            ; Script Initialization
            ; ========================================

            if A_Args.Length = 0 && !A_IsCompiled {
                help := "
                (
                WinWaitClose Examples - Hotkeys:

                Ctrl+Shift+Q  - Wait for active window to close
                Ctrl+Shift+A  - Wait and cleanup
                Ctrl+Shift+M  - Monitor multiple windows
                Ctrl+Shift+S  - Execute shutdown sequence
                Ctrl+Shift+T  - Timeout handler
                Ctrl+Shift+G  - Graceful shutdown
                Ctrl+Shift+E  - Event listener
                )"

                TrayTip(help, "WinWaitClose Examples Ready", "Icon!")
            }
