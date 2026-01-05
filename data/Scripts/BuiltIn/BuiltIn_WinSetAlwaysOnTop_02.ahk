#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinSetAlwaysOnTop_02.ahk
 * @description Advanced always-on-top features, smart pinning, and context-aware pin management using WinSetAlwaysOnTop in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Smart pin based on window state
 * Example 2: Conditional auto-pinning
 * Example 3: Pin profiles
 * Example 4: Multi-monitor pin management
 * Example 5: Pin with visual feedback
 * Example 6: Pin scheduler
 * 
 * @section FEATURES
 * - Smart state-based pinning
 * - Conditional pinning
 * - Profile management
 * - Multi-monitor support
 * - Visual feedback
 * - Scheduling
 */

#Requires AutoHotkey v2.0

; Global pin state
global PinState := Map()

; ========================================
; Example 1: Smart Pin Based on Window State
; ========================================

class SmartPin {
    static PinIfSmall(threshold := 30) {
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        workWidth := right - left
        workHeight := bottom - top

        WinGetPos(&x, &y, &width, &height, "A")

        widthPercent := (width / workWidth) * 100
        heightPercent := (height / workHeight) * 100

        if widthPercent < threshold || heightPercent < threshold {
            WinSetAlwaysOnTop(1, "A")
            TrayTip("Auto-pinned (small window)", "Smart Pin", "Icon!")
            return true
        }

        return false
    }

    static PinFloatingWindows() {
        windowList := WinGetList()

        for winId in windowList {
            try {
                ; Check if window is floating (no parent)
                parent := DllCall("GetParent", "Ptr", winId, "Ptr")

                if !parent {
                    WinGetPos(&x, &y, &width, &height, "ahk_id " winId)

                    if width < 600 && height < 400 {
                        WinSetAlwaysOnTop(1, "ahk_id " winId)
                    }
                }
            }
        }

        TrayTip("Floating windows pinned", "Smart Pin", "Icon!")
    }
}

^+1:: SmartPin.PinIfSmall(30)
^+2:: SmartPin.PinFloatingWindows()

; ========================================
; Example 2: Conditional Auto-Pinning
; ========================================

class ConditionalPin {
    static conditions := []

    static AddCondition(checkFunc, actionFunc) {
        this.conditions.Push({
            Check: checkFunc,
            Action: actionFunc
        })

        SetTimer(() => this.EvaluateConditions(), 3000)
    }

    static EvaluateConditions() {
        for condition in this.conditions {
            try {
                if condition.Check() {
                    condition.Action()
                }
            }
        }
    }
}

; Example: Pin Calculator when it appears
ConditionalPin.AddCondition(
    () => WinExist("Calculator"),
    () => {
        if !(WinGetExStyle("Calculator") & 0x8) {
        WinSetAlwaysOnTop(1, "Calculator")
        TrayTip("Calculator auto-pinned", "Conditional Pin", "Icon!")
    }
    }
)

; ========================================
; Example 3: Pin Profiles
; ========================================

class PinProfiles {
    static profiles := Map()
    static currentProfile := ""

    static CreateProfile(name) {
        windowList := WinGetList()
        pinnedWindows := []

        for winId in windowList {
            try {
                exStyle := WinGetExStyle("ahk_id " winId)
                if exStyle & 0x8 {  ; Is pinned
                    pinnedWindows.Push({
                        Title: WinGetTitle("ahk_id " winId),
                        Class: WinGetClass("ahk_id " winId),
                        Process: WinGetProcessName("ahk_id " winId)
                    })
                }
            }
        }

        this.profiles[name] := pinnedWindows
        TrayTip("Profile created: " name, pinnedWindows.Length " windows", "Icon!")
    }

    static LoadProfile(name) {
        if !this.profiles.Has(name) {
            MsgBox("Profile not found: " name, "Error", "IconX")
            return
        }

        ; First, unpin all
        windowList := WinGetList()
        for winId in windowList {
            try {
                WinSetAlwaysOnTop(0, "ahk_id " winId)
            }
        }

        ; Then apply profile
        profile := this.profiles[name]
        pinned := 0

        for winData in profile {
            windowList := WinGetList()

            for winId in windowList {
                try {
                    if WinGetClass("ahk_id " winId) = winData.Class && WinGetProcessName("ahk_id " winId) = winData.Process {
                        WinSetAlwaysOnTop(1, "ahk_id " winId)
                        pinned++
                        break
                    }
                }
            }
        }

        this.currentProfile := name
        TrayTip("Profile loaded: " name, "Pinned " pinned " windows", "Icon!")
    }
}

^+3:: {
    name := InputBox("Enter profile name:", "Create Profile").Value
    if name != ""
        PinProfiles.CreateProfile(name)
}

^+4:: {
    name := InputBox("Enter profile name to load:", "Load Profile").Value
    if name != ""
        PinProfiles.LoadProfile(name)
}

; ========================================
; Example 4-6: Additional Advanced Features
; ========================================

class MultiMonitorPin {
    static PinOnMonitor(monitorNum) {
        windowList := WinGetList()

        for winId in windowList {
            try {
                WinGetPos(&x, &y, &width, &height, "ahk_id " winId)
                MonitorGet(monitorNum, &mLeft, &mTop, &mRight, &mBottom)

                centerX := x + (width // 2)
                centerY := y + (height // 2)

                if centerX >= mLeft && centerX < mRight && centerY >= mTop && centerY < mBottom {
                    WinSetAlwaysOnTop(1, "ahk_id " winId)
                }
            }
        }

        TrayTip("Pinned windows on monitor " monitorNum, "Multi-Monitor", "Icon!")
    }
}

class VisualPinFeedback {
    static ShowPinStatus(WinTitle := "A") {
        exStyle := WinGetExStyle(WinTitle)
        isPinned := exStyle & 0x8

        ; Flash window border
        if isPinned {
            ; Could implement border highlight here
            TrayTip("Window is PINNED", WinGetTitle(WinTitle), "Icon!")
        } else {
            TrayTip("Window is NOT pinned", WinGetTitle(WinTitle), "Icon!")
        }
    }
}

class PinScheduler {
    static schedule := []

    static SchedulePin(WinTitle, time) {
        this.schedule.Push({
            WinTitle: WinTitle,
            Time: time,
            Executed: false
        })

        SetTimer(() => this.CheckSchedule(), 10000)
    }

    static CheckSchedule() {
        currentTime := A_Now

        for task in this.schedule {
            if !task.Executed && currentTime >= task.Time {
                try {
                    WinSetAlwaysOnTop(1, task.WinTitle)
                    TrayTip("Scheduled pin executed", task.WinTitle, "Icon!")
                    task.Executed := true
                }
            }
        }
    }
}

^+5:: MultiMonitorPin.PinOnMonitor(1)
^+6:: VisualPinFeedback.ShowPinStatus("A")

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinSetAlwaysOnTop Advanced Examples Ready", "Smart pinning active", "Icon!")
}
