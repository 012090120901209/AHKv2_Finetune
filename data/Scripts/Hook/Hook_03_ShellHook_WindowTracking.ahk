#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ShellHook - Window Event Tracking
 * 
 * Demonstrates using Windows ShellHook to detect window creation,
 * destruction, and activation events without polling.
 * 
 * Source: AHK_Notes/Snippets/ShellHook.md
 */

; Window tracking storage
windowData := Map()

; Register shell hook
DllCall("RegisterShellHookWindow", "UInt", A_ScriptHwnd)
msgNumber := DllCall("RegisterWindowMessage", "Str", "SHELLHOOK")
OnMessage(msgNumber, ShellMessageHandler)

; Cleanup on exit
OnExit((*) => DllCall("DeregisterShellHookWindow", "UInt", A_ScriptHwnd))

MsgBox("ShellHook started!`n`nOpen/close windows to see events.`nRun for 15 seconds...", , "T3")

Sleep(15000)

; Show summary
summary := "Window Events Summary:`n`n"
summary .= "Total windows tracked: " windowData.Count "`n`n"

if (windowData.Count > 0) {
    summary .= "Sample windows:`n"
    count := 0
    for hwnd, info in windowData {
        summary .= "• " info.title " (" info.class ")`n"
        if (++count >= 5)
            break
    }
}

MsgBox(summary, , "T5")
ExitApp()

/**
 * ShellHook Message Handler
 * @param {int} wParam - Event type code
 * @param {ptr} lParam - Window handle
 */
ShellMessageHandler(wParam, lParam, *) {
    static HSHELL_WINDOWCREATED := 1
    static HSHELL_WINDOWDESTROYED := 2
    static HSHELL_WINDOWACTIVATED := 4
    static HSHELL_WINDOWACTIVATED_TOPMOST := 32772

    hwnd := lParam

    switch wParam {
        case HSHELL_WINDOWCREATED:
            HandleWindowCreated(hwnd)

        case HSHELL_WINDOWDESTROYED:
            HandleWindowDestroyed(hwnd)

        case HSHELL_WINDOWACTIVATED, HSHELL_WINDOWACTIVATED_TOPMOST:
            HandleWindowActivated(hwnd)
    }
}

/**
 * Handle window creation event
 */
HandleWindowCreated(hwnd) {
    try {
        title := WinGetTitle("ahk_id " hwnd)
        class := WinGetClass("ahk_id " hwnd)
        process := WinGetProcessName("ahk_id " hwnd)

        ; Store window data
        windowData[hwnd] := {
            title: title,
            class: class,
            process: process,
            created: A_TickCount
        }

        ; Show notification for specific processes
        if (process ~= "i)notepad|code|chrome") {
            ToolTip("Window Created: " title)
            SetTimer(() => ToolTip(), -2000)
        }
    }
}

/**
 * Handle window destruction event
 */
HandleWindowDestroyed(hwnd) {
    ; Use stored data since window is gone
    if (windowData.Has(hwnd)) {
        info := windowData[hwnd]

        if (info.process ~= "i)notepad|code|chrome") {
            ToolTip("Window Closed: " info.title)
            SetTimer(() => ToolTip(), -2000)
        }

        windowData.Delete(hwnd)
    }
}

/**
 * Handle window activation event
 */
HandleWindowActivated(hwnd) {
    try {
        title := WinGetTitle("ahk_id " hwnd)
        ; Could track active window history here
    }
}

/*
* Key Concepts:
*
* 1. ShellHook Registration:
*    RegisterShellHookWindow(A_ScriptHwnd)
*    RegisterWindowMessage("SHELLHOOK")
*    OnMessage(msgNumber, Handler)
*
* 2. Event Types:
*    1 = WINDOWCREATED
*    2 = WINDOWDESTROYED
*    4 = WINDOWACTIVATED
*    32772 = WINDOWACTIVATED_TOPMOST
*
* 3. Window Data Caching:
*    Store info when created (title, class, process)
*    Use cached data when destroyed
*    Window inaccessible after destruction
*
* 4. Advantages:
*    ✅ Event-driven (no polling)
*    ✅ Efficient system resource usage
*    ✅ Real-time notifications
*    ✅ Low CPU overhead
*
* 5. Cleanup:
*    OnExit() deregisters hook
*    Prevents resource leaks
*/

