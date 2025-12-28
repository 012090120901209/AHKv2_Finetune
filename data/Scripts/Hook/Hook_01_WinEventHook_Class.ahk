#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinEventHook Class - Windows Event Hook Wrapper
 * 
 * Provides an OOP wrapper for Windows SetWinEventHook API.
 * Monitors window events without polling.
 * 
 * Source: AHK_Notes/Snippets/WinEventHook.md
 */

/**
 * WinEventHook Class
 * 
 * Wraps Windows SetWinEventHook API for monitoring window events.
 * 
 * Parameters:
 *   callback - Function to call when event occurs (7 parameters)
 *   eventMin - Minimum event constant to monitor
 *   eventMax - Maximum event constant to monitor (optional)
 *   winTitle - Specific window to monitor (0 = all windows)
 *   PID - Process ID to monitor (0 = all processes)
 *   skipOwnProcess - Skip events from this script's process
 */
class WinEventHook {
    __New(callback, eventMin?, eventMax?, winTitle := 0, PID := 0, skipOwnProcess := false) {
        ; Validate callback
        if !HasMethod(callback)
            throw ValueError("The callback argument must be a function", -1)

        ; Set event range
        if !IsSet(eventMin)
            eventMin := 0x00000001, eventMax := IsSet(eventMax) ? eventMax : 0x7fffffff
        else if !IsSet(eventMax)
            eventMax := eventMin

        ; Store parameters
        this.callback := callback
        this.winTitle := winTitle
        this.flags := skipOwnProcess ? 2 : 0
        this.eventMin := eventMin
        this.eventMax := eventMax
        this.threadId := 0

        ; Get window handle if title specified
        if winTitle != 0 {
            if !(this.winTitle := WinExist(winTitle))
                throw TargetError("Window not found", -1)
            this.threadId := DllCall("GetWindowThreadProcessId", "Ptr", this.winTitle, "UInt*", &PID)
        }

        ; Create callback and set hook
        this.pCallback := CallbackCreate(callback, "C", 7)
        this.hHook := DllCall("SetWinEventHook",
            "UInt", eventMin,
            "UInt", eventMax,
            "Ptr", 0,
            "Ptr", this.pCallback,
            "UInt", this.PID := PID,
            "UInt", this.threadId,
            "UInt", this.flags)
    }

    /**
     * Stop monitoring and clean up resources
     */
    Stop() => this.__Delete()

    /**
     * Destructor - automatically called when object is destroyed
     * Unhooks the event and frees the callback
     */
    __Delete() {
        if (this.pCallback) {
            DllCall("UnhookWinEvent", "Ptr", this.hHook)
            CallbackFree(this.pCallback)
            this.hHook := 0
            this.pCallback := 0
        }
    }
}

; Example: Monitor window minimize/restore events
MsgBox("This script monitors window minimize/restore events.`n`n"
    . "Try minimizing and restoring windows!`n`n"
    . "Press OK to start monitoring.", , "T5")

; Event constants
global EVENT_SYSTEM_MINIMIZESTART := 0x0016
global EVENT_SYSTEM_MINIMIZEEND := 0x0017

; Create hook
minimizeHook := WinEventHook(MinimizeHandler, EVENT_SYSTEM_MINIMIZESTART, EVENT_SYSTEM_MINIMIZEEND)

; Keep script running
Persistent()

/**
 * Callback function for minimize/restore events
 * 
 * Parameters (from Windows API):
 *   hWinEventHook - Hook handle
 *   event - Event code
 *   hwnd - Window handle
 *   idObject - Object ID
 *   idChild - Child ID
 *   idEventThread - Thread ID
 *   dwmsEventTime - Timestamp
 */
MinimizeHandler(hWinEventHook, event, hwnd, idObject, idChild, idEventThread, dwmsEventTime) {
    global EVENT_SYSTEM_MINIMIZESTART, EVENT_SYSTEM_MINIMIZEEND

    try {
        title := WinGetTitle(hwnd)
        if (event = EVENT_SYSTEM_MINIMIZESTART)
            ToolTip("Window minimizing: " title)
        else if (event = EVENT_SYSTEM_MINIMIZEEND)
            ToolTip("Window restored: " title)

        SetTimer(() => ToolTip(), -2000)
    }
}

/*
* Key Concepts:
*
* 1. Windows Event Hook:
*    - Low-level Windows API for monitoring window events
*    - No polling required (event-driven)
*    - System-wide or process-specific monitoring
*
* 2. Event Constants (examples):
*    0x0003 = EVENT_SYSTEM_FOREGROUND (window activated)
*    0x000B = EVENT_SYSTEM_MOVESIZEEND (window moved/resized)
*    0x0016 = EVENT_SYSTEM_MINIMIZESTART
*    0x0017 = EVENT_SYSTEM_MINIMIZEEND
*    0x8000 = EVENT_OBJECT_CREATE (window created)
*    0x8001 = EVENT_OBJECT_DESTROY (window destroyed)
*
* 3. Callback Parameters:
*    - hWinEventHook: Handle to the hook
*    - event: Event code (what happened)
*    - hwnd: Window handle (which window)
*    - idObject: Object identifier
*    - idChild: Child object identifier
*    - idEventThread: Thread that triggered event
*    - dwmsEventTime: Timestamp in milliseconds
*
* 4. Use Cases:
*    - Window lifecycle tracking
*    - Focus management
*    - Window state monitoring
*    - Activity logging
*    - Window automation triggers
*
* 5. Important Notes:
*    ⚠️  Callback runs in separate thread
*    ⚠️  Keep callback processing lightweight
*    ⚠️  Use Critical to prevent interruptions if needed
*    ⚠️  Clean up resources in destructor
*/

