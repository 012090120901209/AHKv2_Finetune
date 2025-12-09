#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Edge-Triggered Window - Mouse Proximity Window Activation
*
* Demonstrates window activation based on mouse position proximity
* to screen edges. Move mouse to left edge to show browser, top
* edge for terminal, etc.
*
* Source: replete/productivity-ahk - LeftBrowser.ahk
* Inspired by: https://github.com/replete/productivity-ahk
*/

; Configuration
global EDGE_THRESHOLD := 5        ; Pixels from edge to trigger
global TRIGGER_DELAY := 500       ; Milliseconds at edge before trigger
global WINDOW_WIDTH_PERCENT := 30  ; Percentage of screen width

; Edge states
global leftEdgeTime := 0
global rightEdgeTime := 0
global topEdgeTime := 0
global bottomEdgeTime := 0

; Windows to manage
global leftWindow := ""   ; Browser
global rightWindow := ""  ; File Explorer
global topWindow := ""    ; Terminal
global bottomWindow := "" ; Notes

MsgBox("Edge-Triggered Windows`n`n"
. "Move mouse to screen edges to trigger windows:`n`n"
. "LEFT edge (~500ms) - Browser (Chrome)`n"
. "RIGHT edge (~500ms) - File Explorer`n"
. "TOP edge (~500ms) - Command Prompt`n"
. "BOTTOM edge (~500ms) - Notepad`n`n"
. "Win+E - Toggle edge detection ON/OFF`n`n"
. "Perfect for:`n"
. "- Quick access panels`n"
. "- Side browsers`n"
. "- Terminal drawers`n"
. "- Reference windows", , "T8")

; Start edge detection
SetTimer(CheckEdges, 100)

; ===============================================
; EDGE DETECTION
; ===============================================

/**
* Check if mouse is near screen edges
*/
CheckEdges() {
    global leftEdgeTime, rightEdgeTime, topEdgeTime, bottomEdgeTime
    global EDGE_THRESHOLD, TRIGGER_DELAY

    MouseGetPos(&x, &y)
    currentTime := A_TickCount

    ; Left edge
    if (x <= EDGE_THRESHOLD) {
        if (leftEdgeTime == 0)
        leftEdgeTime := currentTime
        else if (currentTime - leftEdgeTime >= TRIGGER_DELAY)
        TriggerLeftWindow()
    } else {
        leftEdgeTime := 0
    }

    ; Right edge
    if (x >= A_ScreenWidth - EDGE_THRESHOLD) {
        if (rightEdgeTime == 0)
        rightEdgeTime := currentTime
        else if (currentTime - rightEdgeTime >= TRIGGER_DELAY)
        TriggerRightWindow()
    } else {
        rightEdgeTime := 0
    }

    ; Top edge
    if (y <= EDGE_THRESHOLD) {
        if (topEdgeTime == 0)
        topEdgeTime := currentTime
        else if (currentTime - topEdgeTime >= TRIGGER_DELAY)
        TriggerTopWindow()
    } else {
        topEdgeTime := 0
    }

    ; Bottom edge
    if (y >= A_ScreenHeight - EDGE_THRESHOLD) {
        if (bottomEdgeTime == 0)
        bottomEdgeTime := currentTime
        else if (currentTime - bottomEdgeTime >= TRIGGER_DELAY)
        TriggerBottomWindow()
    } else {
        bottomEdgeTime := 0
    }
}

; ===============================================
; WINDOW TRIGGERS
; ===============================================

/**
* Trigger left edge window (Browser)
*/
TriggerLeftWindow() {
    global leftWindow, leftEdgeTime

    ; Reset timer to prevent re-trigger
    leftEdgeTime := 0

    ; Check if window exists
    if (WinExist("ahk_exe chrome.exe")) {
        if (WinActive("ahk_exe chrome.exe")) {
            ; Already active, hide it
            WinHide("ahk_exe chrome.exe")
            ToolTip("Browser hidden")
        } else {
            ; Show and position
            WinShow("ahk_exe chrome.exe")
            WinActivate("ahk_exe chrome.exe")
            PositionWindow("left")
            ToolTip("Browser shown")
        }
    } else {
        ; Launch new browser
        Run("chrome.exe")
        WinWait("ahk_exe chrome.exe", , 5)
        PositionWindow("left")
        ToolTip("Browser launched")
    }

    SetTimer(() => ToolTip(), -1500)
}

/**
* Trigger right edge window (File Explorer)
*/
TriggerRightWindow() {
    global rightEdgeTime

    rightEdgeTime := 0

    if (WinExist("ahk_class CabinetWClass")) {
        if (WinActive("ahk_class CabinetWClass")) {
            WinHide("ahk_class CabinetWClass")
            ToolTip("Explorer hidden")
        } else {
            WinShow("ahk_class CabinetWClass")
            WinActivate("ahk_class CabinetWClass")
            PositionWindow("right")
            ToolTip("Explorer shown")
        }
    } else {
        Run("explorer.exe")
        WinWait("ahk_class CabinetWClass", , 5)
        PositionWindow("right")
        ToolTip("Explorer launched")
    }

    SetTimer(() => ToolTip(), -1500)
}

/**
* Trigger top edge window (Terminal)
*/
TriggerTopWindow() {
    global topEdgeTime

    topEdgeTime := 0

    if (WinExist("ahk_exe cmd.exe")) {
        if (WinActive("ahk_exe cmd.exe")) {
            WinHide("ahk_exe cmd.exe")
            ToolTip("Terminal hidden")
        } else {
            WinShow("ahk_exe cmd.exe")
            WinActivate("ahk_exe cmd.exe")
            PositionWindow("top")
            ToolTip("Terminal shown")
        }
    } else {
        Run("cmd.exe")
        WinWait("ahk_exe cmd.exe", , 5)
        PositionWindow("top")
        ToolTip("Terminal launched")
    }

    SetTimer(() => ToolTip(), -1500)
}

/**
* Trigger bottom edge window (Notepad)
*/
TriggerBottomWindow() {
    global bottomEdgeTime

    bottomEdgeTime := 0

    if (WinExist("ahk_exe notepad.exe")) {
        if (WinActive("ahk_exe notepad.exe")) {
            WinHide("ahk_exe notepad.exe")
            ToolTip("Notes hidden")
        } else {
            WinShow("ahk_exe notepad.exe")
            WinActivate("ahk_exe notepad.exe")
            PositionWindow("bottom")
            ToolTip("Notes shown")
        }
    } else {
        Run("notepad.exe")
        WinWait("ahk_exe notepad.exe", , 5)
        PositionWindow("bottom")
        ToolTip("Notes launched")
    }

    SetTimer(() => ToolTip(), -1500)
}

; ===============================================
; WINDOW POSITIONING
; ===============================================

/**
* Position window at screen edge
*/
PositionWindow(edge) {
    global WINDOW_WIDTH_PERCENT

    width := Round(A_ScreenWidth * (WINDOW_WIDTH_PERCENT / 100))
    height := A_ScreenHeight

    switch edge {
        case "left":
        WinMove(0, 0, width, height, "A")

        case "right":
        WinMove(A_ScreenWidth - width, 0, width, height, "A")

        case "top":
        WinMove(0, 0, A_ScreenWidth, Round(height * 0.4), "A")

        case "bottom":
        bottomHeight := Round(height * 0.3)
        WinMove(0, height - bottomHeight, A_ScreenWidth, bottomHeight, "A")
    }
}

; ===============================================
; TOGGLE DETECTION
; ===============================================

global detectionEnabled := true

/**
* Toggle edge detection ON/OFF
*/
#e::ToggleDetection()

ToggleDetection() {
    global detectionEnabled

    detectionEnabled := !detectionEnabled

    if (detectionEnabled) {
        SetTimer(CheckEdges, 100)
        ToolTip("Edge detection ENABLED")
    } else {
        SetTimer(CheckEdges, 0)
        ToolTip("Edge detection DISABLED")
    }

    SetTimer(() => ToolTip(), -1500)
}

/*
* Key Concepts:
*
* 1. Edge Detection:
*    Monitor mouse position
*    Check proximity to edges
*    Time-based triggering
*    Prevent accidental activation
*
* 2. Screen Edges:
*    Left: 0 to THRESHOLD
*    Right: ScreenWidth - THRESHOLD to ScreenWidth
*    Top: 0 to THRESHOLD
*    Bottom: ScreenHeight - THRESHOLD to ScreenHeight
*
* 3. Trigger Delay:
*    Mouse must stay at edge
*    500ms default threshold
*    Prevents accidental triggers
*    User-configurable
*
* 4. Window Management:
*    Show/hide toggle
*    Auto-positioning
*    Launch if not running
*    Maintain state
*
* 5. Use Cases:
*    ✅ Side browser panels
*    ✅ Quick file access
*    ✅ Terminal drawer
*    ✅ Note taking
*    ✅ Reference documentation
*    ✅ Chat applications
*
* 6. Positioning Patterns:
*    Left/Right: Vertical panels (30% width)
*    Top: Horizontal panel (40% height)
*    Bottom: Drawer (30% height)
*    Configurable percentages
*
* 7. State Tracking:
*    Edge time timestamps
*    Window visibility state
*    Detection enabled/disabled
*    Per-edge configuration
*
* 8. Timer-Based Detection:
*    100ms check interval
*    Low CPU overhead
*    Responsive triggering
*    Can be adjusted
*
* 9. Best Practices:
*    ✅ Delay before trigger
*    ✅ Toggle show/hide
*    ✅ Launch if missing
*    ✅ Visual feedback
*    ✅ Easy disable (Win+E)
*
* 10. Window Operations:
*     WinExist() - Check if exists
*     WinActive() - Check if focused
*     WinShow() - Make visible
*     WinHide() - Make invisible
*     WinMove() - Reposition
*
* 11. Multi-Window Support:
*     Each edge triggers different app
*     Left: Browser
*     Right: File Explorer
*     Top: Terminal
*     Bottom: Notes
*
* 12. Advanced Features:
*     - Per-edge delay config
*     - Custom applications
*     - Remember dimensions
*     - Opacity control
*     - Multi-monitor support
*
* 13. Productivity Patterns:
*     - Browser for reference
*     - Terminal for commands
*     - Explorer for files
*     - Notes for quick capture
*     - Chat for communication
*
* 14. Enhancements:
*     - Corner triggers (diagonal)
*     - Configurable sizes
*     - Animation effects
*     - Auto-hide on focus loss
*     - Per-monitor settings
*     - Profile switching
*/
