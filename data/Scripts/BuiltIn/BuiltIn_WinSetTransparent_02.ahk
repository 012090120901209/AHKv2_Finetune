#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinSetTransparent_02.ahk
 * @description Advanced transparency features, animations, and visual effects using WinSetTransparent in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Advanced fade animations
 * Example 2: Transparency scheduler
 * Example 3: Focus-based transparency
 * Example 4: Transparency groups
 * Example 5: Animated transparency effects
 * Example 6: Smart transparency manager
 * 
 * @section FEATURES
 * - Advanced animations
 * - Scheduled transparency
 * - Focus-aware transparency
 * - Group management
 * - Visual effects
 * - Smart management
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Advanced Fade Animations
; ========================================

class AdvancedFade {
    static EaseInOut(WinTitle, fromLevel, toLevel, duration := 1000) {
        steps := 40
        delay := duration // steps

        Loop steps {
            t := A_Index / steps
            easeT := t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t

            level := fromLevel + ((toLevel - fromLevel) * easeT)
            WinSetTransparent(Integer(level), WinTitle)
            Sleep(delay)
        }

        WinSetTransparent(toLevel, WinTitle)
    }

    static Wave(WinTitle, cycles := 3, duration := 2000) {
        steps := 50 * cycles
        delay := duration // steps

        Loop steps {
            t := (A_Index / steps) * cycles * 2 * 3.14159
            level := 128 + (127 * Sin(t))

            WinSetTransparent(Integer(level), WinTitle)
            Sleep(delay)
        }

        WinSetTransparent(255, WinTitle)
    }
}

^+w:: AdvancedFade.Wave("A", 3, 2000)

; ========================================
; Example 2: Transparency Scheduler
; ========================================

class TransparencyScheduler {
    static schedule := []

    static ScheduleTransparency(WinTitle, level, delay) {
        this.schedule.Push({
            WinTitle: WinTitle,
            Level: level,
            ExecuteTime: A_TickCount + delay,
            Executed: false
        })

        SetTimer(() => this.ExecuteSchedule(), 500)
    }

    static ExecuteSchedule() {
        currentTime := A_TickCount

        for task in this.schedule {
            if !task.Executed && currentTime >= task.ExecuteTime {
                try {
                    WinSetTransparent(task.Level, task.WinTitle)
                    TrayTip("Scheduled transparency applied", task.Level, "Icon!")
                    task.Executed := true
                }
            }
        }
    }
}

; ========================================
; Example 3-6: Additional Advanced Features
; ========================================

class FocusTransparency {
    static enabled := false
    static activeLevel := 255
    static inactiveLevel := 150

    static Enable(activeTransp := 255, inactiveTransp := 150) {
        this.activeLevel := activeTransp
        this.inactiveLevel := inactiveTransp
        this.enabled := true

        SetTimer(() => this.ApplyFocusTransparency(), 500)
        TrayTip("Focus transparency enabled", "Transparency", "Icon!")
    }

    static ApplyFocusTransparency() {
        if !this.enabled
            return

        activeWin := WinExist("A")
        windowList := WinGetList()

        for winId in windowList {
            try {
                if winId = activeWin {
                    WinSetTransparent(this.activeLevel, "ahk_id " winId)
                } else {
                    style := WinGetStyle("ahk_id " winId)
                    if style & 0x10000000 {  ; Visible
                        WinSetTransparent(this.inactiveLevel, "ahk_id " winId)
                    }
                }
            }
        }
    }
}

class TransparencyGroups {
    static groups := Map()

    static CreateGroup(name, level) {
        windowList := WinGetList()

        for winId in windowList {
            try {
                WinSetTransparent(level, "ahk_id " winId)
            }
        }

        this.groups[name] := { Name: name, Level: level }
        TrayTip("Group created: " name, "Level: " level, "Icon!")
    }
}

class SmartTransparency {
    static AutoAdjust() {
        windowList := WinGetList()

        for winId in windowList {
            try {
                WinGetPos(&x, &y, &width, &height, "ahk_id " winId)

                ; Make small windows more transparent
                if width < 500 && height < 400 {
                    WinSetTransparent(180, "ahk_id " winId)
                } else {
                    WinSetTransparent(255, "ahk_id " winId)
                }
            }
        }

        TrayTip("Smart transparency applied", "Auto-Adjust", "Icon!")
    }
}

^+z:: FocusTransparency.Enable(255, 120)
^+x:: SmartTransparency.AutoAdjust()

; Helper function
Sin(x) {
    return DllCall("msvcrt\sin", "Double", x, "Double")
}

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    TrayTip("WinSetTransparent Advanced Examples Ready", "Visual effects available", "Icon!")
}
