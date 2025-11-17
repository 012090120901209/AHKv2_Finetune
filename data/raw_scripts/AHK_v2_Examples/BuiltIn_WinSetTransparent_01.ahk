/**
 * @file BuiltIn_WinSetTransparent_01.ahk
 * @description Comprehensive examples demonstrating WinSetTransparent function for window transparency in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 *
 * @section EXAMPLES
 * Example 1: Basic transparency control
 * Example 2: Gradual fade effects
 * Example 3: Transparency presets
 * Example 4: Mouse-hover transparency
 * Example 5: Conditional transparency
 * Example 6: Transparency profiles
 * Example 7: Visual transparency indicator
 *
 * @section FEATURES
 * - Set window transparency
 * - Fade animations
 * - Preset levels
 * - Hover effects
 * - Conditional transparency
 * - Profile management
 * - Visual indicators
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Transparency Control
; ========================================

SetWindowTransparency(level := 128, WinTitle := "A") {
    try {
        WinSetTransparent(level, WinTitle)
        TrayTip("Transparency set to " level, WinGetTitle(WinTitle), "Icon!")
        return true
    } catch as err {
        MsgBox("Error: " err.Message, "Error", "IconX")
        return false
    }
}

; Hotkeys for quick transparency levels
^+1:: SetWindowTransparency(255, "A")  ; Opaque
^+2:: SetWindowTransparency(192, "A")  ; 75%
^+3:: SetWindowTransparency(128, "A")  ; 50%
^+4:: SetWindowTransparency(64, "A")   ; 25%
^+5:: SetWindowTransparency(32, "A")   ; 12.5%

; ========================================
; Example 2: Gradual Fade Effects
; ========================================

class FadeEffects {
    static FadeIn(WinTitle := "A", duration := 500) {
        steps := 20
        delay := duration // steps
        increment := 255 // steps

        Loop steps {
            level := A_Index * increment
            WinSetTransparent(Min(level, 255), WinTitle)
            Sleep(delay)
        }

        WinSetTransparent(255, WinTitle)
    }

    static FadeOut(WinTitle := "A", duration := 500) {
        steps := 20
        delay := duration // steps
        increment := 255 // steps

        Loop steps {
            level := 255 - (A_Index * increment)
            WinSetTransparent(Max(level, 0), WinTitle)
            Sleep(delay)
        }

        WinSetTransparent(0, WinTitle)
    }

    static Pulse(WinTitle := "A", cycles := 3) {
        Loop cycles {
            this.FadeOut(WinTitle, 300)
            this.FadeIn(WinTitle, 300)
        }
    }

    static SmoothTransition(WinTitle, fromLevel, toLevel, duration := 500) {
        steps := 20
        delay := duration // steps
        increment := (toLevel - fromLevel) / steps

        Loop steps {
            level := fromLevel + (A_Index * increment)
            WinSetTransparent(Integer(level), WinTitle)
            Sleep(delay)
        }

        WinSetTransparent(toLevel, WinTitle)
    }
}

^+f:: FadeEffects.FadeOut("A", 500)
^+g:: FadeEffects.FadeIn("A", 500)
^+h:: FadeEffects.Pulse("A", 2)

; ========================================
; Example 3: Transparency Presets
; ========================================

class TransparencyPresets {
    static presets := Map(
        "Opaque", 255,
        "Slightly Transparent", 220,
        "Semi-Transparent", 180,
        "Half Transparent", 128,
        "Very Transparent", 80,
        "Almost Invisible", 30
    )

    static ApplyPreset(presetName, WinTitle := "A") {
        if !this.presets.Has(presetName) {
            MsgBox("Preset not found: " presetName, "Error", "IconX")
            return false
        }

        level := this.presets[presetName]
        WinSetTransparent(level, WinTitle)
        TrayTip("Applied preset: " presetName, "Level: " level, "Icon!")
        return true
    }

    static ShowPresets() {
        output := "Available Transparency Presets:`n`n"

        for name, level in this.presets {
            output .= name ": " level " (" Round((level/255)*100, 1) "%)`n"
        }

        MsgBox(output, "Transparency Presets", "Icon!")
    }
}

^+p:: {
    TransparencyPresets.ShowPresets()
    preset := InputBox("Enter preset name:", "Apply Preset").Value
    if preset != ""
        TransparencyPresets.ApplyPreset(preset, "A")
}

; ========================================
; Example 4: Mouse-Hover Transparency
; ========================================

class HoverTransparency {
    static monitoring := false
    static targetWindow := 0
    static normalLevel := 128
    static hoverLevel := 255

    static Enable(WinTitle := "A", normalTransp := 128, hoverTransp := 255) {
        this.targetWindow := WinExist(WinTitle)
        if !this.targetWindow
            return false

        this.normalLevel := normalTransp
        this.hoverLevel := hoverTransp
        this.monitoring := true

        WinSetTransparent(normalTransp, "ahk_id " this.targetWindow)

        SetTimer(() => this.CheckHover(), 100)

        TrayTip("Hover transparency enabled", WinGetTitle("ahk_id " this.targetWindow), "Icon!")
        return true
    }

    static Disable() {
        this.monitoring := false
        SetTimer(() => this.CheckHover(), 0)

        if this.targetWindow {
            WinSetTransparent(255, "ahk_id " this.targetWindow)
        }

        TrayTip("Hover transparency disabled", "Transparency", "Icon!")
    }

    static CheckHover() {
        if !this.monitoring || !this.targetWindow
            return

        if !WinExist("ahk_id " this.targetWindow) {
            this.Disable()
            return
        }

        MouseGetPos(, , &winUnderMouse)

        if winUnderMouse = this.targetWindow {
            WinSetTransparent(this.hoverLevel, "ahk_id " this.targetWindow)
        } else {
            WinSetTransparent(this.normalLevel, "ahk_id " this.targetWindow)
        }
    }
}

^+m:: HoverTransparency.Enable("A", 100, 255)
^+n:: HoverTransparency.Disable()

; ========================================
; Example 5-7: Additional Features
; ========================================

class ConditionalTransparency {
    static ApplyBySize() {
        windowList := WinGetList()

        for winId in windowList {
            try {
                WinGetPos(&x, &y, &width, &height, "ahk_id " winId)

                if width < 400 || height < 300 {
                    WinSetTransparent(180, "ahk_id " winId)
                }
            }
        }

        TrayTip("Small windows made transparent", "Conditional", "Icon!")
    }
}

class TransparencyProfiles {
    static profiles := Map()

    static SaveProfile(name) {
        windowList := WinGetList()
        windows := []

        for winId in windowList {
            try {
                ; Get current transparency
                trans := WinGetTransparent("ahk_id " winId)

                if trans != "" {
                    windows.Push({
                        Class: WinGetClass("ahk_id " winId),
                        Process: WinGetProcessName("ahk_id " winId),
                        Transparency: trans
                    })
                }
            }
        }

        this.profiles[name] := windows
        TrayTip("Profile saved: " name, windows.Length " windows", "Icon!")
    }
}

class TransparencyIndicator {
    static Show(WinTitle := "A") {
        trans := WinGetTransparent(WinTitle)

        output := "Window Transparency:`n`n"

        if trans = "" {
            output .= "Transparency: Not set (100% opaque)"
        } else {
            percent := Round((trans/255)*100, 1)
            output .= "Level: " trans " / 255`n"
            output .= "Percent: " percent "%"
        }

        MsgBox(output, "Transparency Info", "Icon!")
    }
}

^+i:: TransparencyIndicator.Show("A")

; ========================================
; Script Initialization
; ========================================

if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinSetTransparent Examples - Hotkeys:

    Ctrl+Shift+1-5  - Quick transparency levels
    Ctrl+Shift+F    - Fade out
    Ctrl+Shift+G    - Fade in
    Ctrl+Shift+H    - Pulse effect
    Ctrl+Shift+P    - Apply preset
    Ctrl+Shift+M    - Enable hover transparency
    Ctrl+Shift+I    - Show transparency info
    )"

    TrayTip(help, "WinSetTransparent Examples Ready", "Icon!")
}
