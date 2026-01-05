#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinWaitClose_02.ahk
 * @description Advanced window close monitoring, cleanup sequences, and termination handling using WinWaitClose in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Cascade close monitor
 * Example 2: Process termination waiter
 * Example 3: Close confirmation system
 * Example 4: Resource cleanup orchestrator
 * Example 5: Session end handler
 * Example 6: Auto-save on close
 * 
 * @section FEATURES
 * - Cascade monitoring
 * - Process termination
 * - Close confirmation
 * - Resource cleanup
 * - Session handling
 * - Auto-save
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Cascade Close Monitor
; ========================================

class CascadeMonitor {
    static MonitorCascade(windowChain) {
        for index, win in windowChain {
            TrayTip("Waiting for: " win.Title, "Cascade Monitor", "Icon!")

            timeout := win.HasOwnProp("Timeout") ? win.Timeout : 30

            if WinWaitClose(win.Title, , timeout) {
                TrayTip("Closed: " win.Title, "Cascade", "Icon!")

                if win.HasOwnProp("OnClose")
                    win.OnClose()

                if win.HasOwnProp("Delay")
                    Sleep(win.Delay)
            } else {
                TrayTip("Timeout in cascade", win.Title, "IconX")
                return false
            }
        }

        TrayTip("Cascade complete!", "Success", "Icon!")
        return true
    }
}

^+1:: {
    chain := [{
        Title: "ahk_class Notepad", Timeout: 10, OnClose: () => TrayTip("Step 1 done", "Cascade") }, {
            Title: "Calculator", Timeout: 10, OnClose: () => TrayTip("Step 2 done", "Cascade"), Delay: 500
        }
    ]

    CascadeMonitor.MonitorCascade(chain)
}

; ========================================
; Example 2: Process Termination Waiter
; ========================================

class ProcessTerminationWaiter {
    static WaitForProcessEnd(pid, timeout := 30) {
        startTime := A_TickCount

        Loop {
            ; Check if process still exists
            if !ProcessExist(pid) {
                TrayTip("Process terminated: " pid, "Process Monitor", "Icon!")
                return true
            }

            if (A_TickCount - startTime) > (timeout * 1000) {
                TrayTip("Process still running: " pid, "Timeout", "Icon!")
                return false
            }

            Sleep(200)
        }
    }

    static TerminateAndWait(WinTitle, timeout := 10) {
        try {
            pid := WinGetPID(WinTitle)
            WinClose(WinTitle)

            if this.WaitForProcessEnd(pid, timeout) {
                return { Success: true, Method: "Graceful" }
            }

            ; Force terminate
            ProcessClose(pid)

            if this.WaitForProcessEnd(pid, 5) {
                return { Success: true, Method: "Forced" }
            }

            return { Success: false }

        } catch as err {
            return { Success: false, Error: err.Message }
        }
    }
}

^+2:: {
    result := ProcessTerminationWaiter.TerminateAndWait("ahk_class Notepad", 10)
    MsgBox("Termination: " (result.Success ? result.Method : "Failed"), "Result", "Icon!")
}

; ========================================
; Example 3: Close Confirmation System
; ========================================

class CloseConfirmation {
    static ConfirmAndWaitClose(WinTitle, confirmMsg := "") {
        if !WinExist(WinTitle)
            return { Closed: false, Reason: "Not Found" }

        if confirmMsg != "" {
            result := MsgBox(confirmMsg, "Confirm Close", "YesNo Icon?")
            if result = "No"
                return { Closed: false, Reason: "User Cancelled" }
        }

        WinClose(WinTitle)

        if WinWaitClose(WinTitle, , 10) {
            return { Closed: true, Reason: "Success" }
        }

        return { Closed: false, Reason: "Timeout" }
    }

    static BatchCloseWithConfirm(windowList) {
        result := MsgBox("Close " windowList.Length " windows?", "Batch Close", "YesNo Icon?")
        if result = "No"
            return

        closed := 0
        for win in windowList {
            WinClose(win.Title)
            if WinWaitClose(win.Title, , 5)
                closed++
        }

        TrayTip("Closed " closed " of " windowList.Length " windows", "Batch Close", "Icon!")
    }
}

^+3:: {
    result := CloseConfirmation.ConfirmAndWaitClose("ahk_class Notepad", "Close Notepad?")
    MsgBox("Result: " result.Reason, "Close Confirmation", "Icon!")
}

; ========================================
; Example 4: Resource Cleanup Orchestrator
; ========================================

class CleanupOrchestrator {
    static cleanupTasks := []

    static RegisterCleanup(WinTitle, cleanupFunc) {
        this.cleanupTasks.Push({
            WinTitle: WinTitle,
            WinID: WinExist(WinTitle),
            Cleanup: cleanupFunc,
            Executed: false
        })

        SetTimer(() => this.MonitorCleanup(), 1000)
    }

    static MonitorCleanup() {
        for task in this.cleanupTasks {
            if task.Executed
                continue

            if !WinExist("ahk_id " task.WinID) {
                TrayTip("Executing cleanup", task.WinTitle, "Icon!")
                task.Cleanup()
                task.Executed := true
            }
        }

        ; Check if all done
        allDone := true
        for task in this.cleanupTasks {
            if !task.Executed {
                allDone := false
                break
            }
        }

        if allDone {
            SetTimer(() => this.MonitorCleanup(), 0)
            this.cleanupTasks := []
        }
    }
}

^+4:: {
    CleanupOrchestrator.RegisterCleanup("ahk_class Notepad", () => {
        MsgBox("Notepad cleanup executed!", "Cleanup", "Icon!")
    })

    TrayTip("Cleanup registered for Notepad", "Orchestrator", "Icon!")
}

; ========================================
; Example 5: Session End Handler
; ========================================

class SessionEndHandler {
    static EndSession(sessionName, windows, savePath := "") {
        TrayTip("Ending session: " sessionName, "Session End", "Icon!")

        ; Save session state
        if savePath != "" {
            this.SaveSessionState(sessionName, windows, savePath)
        }

        ; Close all windows
        for win in windows {
            WinClose(win.Title)
        }

        ; Wait for all to close
        allClosed := true
        for win in windows {
            if !WinWaitClose(win.Title, , 5) {
                allClosed := false
                TrayTip("Failed to close: " win.Title, "Warning", "Icon!")
            }
        }

        return allClosed
    }

    static SaveSessionState(sessionName, windows, savePath) {
        state := "Session: " sessionName "`n"
        state .= "Date: " A_Now "`n`n"

        for win in windows {
            state .= win.Title "`n"
        }

        try {
            FileDelete(savePath)
        }
        FileAppend(state, savePath)
    }
}

^+5:: {
    windows := [{
        Title: "ahk_class Notepad" }, {
            Title: "Calculator"
        }
    ]

    SessionEndHandler.EndSession("MySession", windows, A_Temp "\session.txt")
}

; ========================================
; Example 6: Auto-Save on Close
; ========================================

class AutoSaveOnClose {
    static monitors := Map()

    static EnableAutoSave(WinTitle, saveFunc) {
        winId := WinExist(WinTitle)
        if !winId
            return false

        this.monitors[winId] := {
            Title: WinTitle,
            SaveFunc: saveFunc,
            Active: true
        }

        SetTimer(() => this.CheckAutoSave(), 500)
        return true
    }

    static CheckAutoSave() {
        toRemove := []

        for winId, data in this.monitors {
            if !data.Active
                continue

            if !WinExist("ahk_id " winId) {
                TrayTip("Auto-saving before close", data.Title, "Icon!")

                try {
                    data.SaveFunc()
                } catch as err {
                    TrayTip("Auto-save failed: " err.Message, "Error", "IconX")
                }

                toRemove.Push(winId)
            }
        }

        for winId in toRemove {
            this.monitors.Delete(winId)
        }

        if this.monitors.Count = 0 {
            SetTimer(() => this.CheckAutoSave(), 0)
        }
    }
}

^+6:: {
    AutoSaveOnClose.EnableAutoSave("ahk_class Notepad", () => {
        MsgBox("Auto-save executed!", "Save", "Icon!")
    })

    TrayTip("Auto-save enabled for Notepad", "Auto-Save", "Icon!")
}

; Helper function
ProcessExist(pid) {
    try {
        Process("Exist", pid)
        return true
    } catch {
        return false
    }
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinWaitClose Advanced Examples Ready", "Close monitoring active", "Icon!")
}
