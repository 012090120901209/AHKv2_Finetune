#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinEventHook - Window Creation/Destruction Tracking
 * 
 * Demonstrates using WinEventHook to track window lifecycle.
 * Maintains a map of all open windows and detects specific applications.
 * 
 * Source: AHK_Notes/Snippets/WinEventHook.md
 */

; Initialize global window tracking map
global gOpenWindows := Map()

; Populate with currently existing windows
for hwnd in WinGetList()
    try gOpenWindows[hwnd] := {
        title: WinGetTitle(hwnd),
        class: WinGetClass(hwnd),
        processName: WinGetProcessName(hwnd)
    }

; Event constants
global EVENT_OBJECT_CREATE := 0x8000
global EVENT_OBJECT_DESTROY := 0x8001
global OBJID_WINDOW := 0
global INDEXID_CONTAINER := 0

; Create hook for window creation and destruction
hook := WinEventHook(HandleWinEvent, EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY)

MsgBox("Window tracking active!`n`n"
    . "Currently tracking " gOpenWindows.Count " windows.`n`n"
    . "Try opening/closing Notepad to see detection.", , "T5")

Persistent()

/**
 * Window Event Handler
 * Tracks window creation and destruction
 */
HandleWinEvent(hWinEventHook, event, hwnd, idObject, idChild, idEventThread, dwmsEventTime) {
    ; Use Critical to prevent interruptions
    Critical -1

    global gOpenWindows, EVENT_OBJECT_CREATE, EVENT_OBJECT_DESTROY
    global OBJID_WINDOW, INDEXID_CONTAINER

    ; Only process window-level events
    if (idObject = OBJID_WINDOW && idChild = INDEXID_CONTAINER) {

        ; Window Created
        if (event = EVENT_OBJECT_CREATE && DllCall("IsTopLevelWindow", "Ptr", hwnd)) {
            try {
                ; Store window information
                gOpenWindows[hwnd] := {
                    title: WinGetTitle(hwnd),
                    class: WinGetClass(hwnd),
                    processName: WinGetProcessName(hwnd)
                }

                ; Special notification for Notepad
                if (gOpenWindows[hwnd].processName = "notepad.exe") {
                    ToolTip("Notepad window created!`n"
                        . "Title: " gOpenWindows[hwnd].title "`n"
                        . "Total windows: " gOpenWindows.Count)
                    SetTimer(() => ToolTip(), -3000)
                }
            }
        }

        ; Window Destroyed
        else if (event = EVENT_OBJECT_DESTROY && gOpenWindows.Has(hwnd)) {
            ; Get info before removing
            windowInfo := gOpenWindows[hwnd]

            ; Special notification for Notepad
            if (windowInfo.processName = "notepad.exe") {
                ToolTip("Notepad window destroyed!`n"
                    . "Title: " windowInfo.title "`n"
                    . "Remaining windows: " (gOpenWindows.Count - 1))
                SetTimer(() => ToolTip(), -3000)
            }

            ; Remove from tracking map
            gOpenWindows.Delete(hwnd)
        }
    }
}

/**
 * WinEventHook Class Implementation
 */
class WinEventHook {
    __New(callback, eventMin?, eventMax?, winTitle := 0, PID := 0, skipOwnProcess := false) {
        if !HasMethod(callback)
            throw ValueError("The callback argument must be a function", -1)
        if !IsSet(eventMin)
            eventMin := 0x00000001, eventMax := IsSet(eventMax) ? eventMax : 0x7fffffff
        else if !IsSet(eventMax)
            eventMax := eventMin
        this.callback := callback, this.winTitle := winTitle, this.flags := skipOwnProcess ? 2 : 0
        this.eventMin := eventMin, this.eventMax := eventMax, this.threadId := 0
        if winTitle != 0 {
            if !(this.winTitle := WinExist(winTitle))
                throw TargetError("Window not found", -1)
            this.threadId := DllCall("GetWindowThreadProcessId", "Ptr", this.winTitle, "UInt*", &PID)
        }
        this.pCallback := CallbackCreate(callback, "C", 7)
        this.hHook := DllCall("SetWinEventHook", "UInt", eventMin, "UInt", eventMax, "Ptr", 0,
            "Ptr", this.pCallback, "UInt", this.PID := PID,
            "UInt", this.threadId, "UInt", this.flags)
    }
    Stop() => this.__Delete()
    __Delete() {
        if (this.pCallback)
            DllCall("UnhookWinEvent", "Ptr", this.hHook), CallbackFree(this.pCallback),
                this.hHook := 0, this.pCallback := 0
    }
}

/*
* Key Concepts:
*
* 1. Window Lifecycle Tracking:
*    - EVENT_OBJECT_CREATE: New window appears
*    - EVENT_OBJECT_DESTROY: Window closes
*    - Maintains real-time list of all windows
*
* 2. Object/Child IDs:
*    - OBJID_WINDOW (0): Window-level events
*    - INDEXID_CONTAINER (0): Container object
*    - Filters out non-window events
*
* 3. Top-Level Window Check:
*    - DllCall("IsTopLevelWindow"): Filters popups/children
*    - Only tracks main application windows
*
* 4. Critical Considerations:
*    ⚠️  Window destroyed → properties no longer queryable
*    ⚠️  Must cache info BEFORE destruction
*    ⚠️  Use try/catch for window property access
*    ⚠️  Callback must be fast (avoid MsgBox in production)
*
* 5. Practical Applications:
*    - Application monitoring
*    - Window lifecycle logging
*    - Automation triggers
*    - Resource cleanup on window close
*    - Multi-window coordination
*
* 6. Performance Notes:
*    - Event-driven (no polling)
*    - Efficient for system-wide monitoring
*    - Low CPU usage
*    - Scales well with many windows
*/

