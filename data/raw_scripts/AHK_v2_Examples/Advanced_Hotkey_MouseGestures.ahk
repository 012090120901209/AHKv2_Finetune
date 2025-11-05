#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Hotkey Example: Mouse Gestures
; Demonstrates: Mouse tracking, gesture recognition, visual feedback

CoordMode("Mouse", "Screen")
global gesturePath := ""
global gestureStartX := 0
global gestureStartY := 0
global isGesturing := false

; Right button + movement = gesture
RButton::
{
    global gesturePath, gestureStartX, gestureStartY, isGesturing

    MouseGetPos(&startX, &startY)
    gestureStartX := startX
    gestureStartY := startY
    gesturePath := ""
    isGesturing := true

    ; Show gesture indicator
    ToolTip("Gesture started...", startX + 20, startY + 20)

    ; Monitor mouse movement
    SetTimer(TrackGesture, 50)

    ; Wait for button release
    KeyWait("RButton")

    isGesturing := false
    SetTimer(TrackGesture, 0)
    ToolTip()

    ; Process gesture
    ProcessGesture(gesturePath)

    gesturePath := ""
}

TrackGesture() {
    global gesturePath, gestureStartX, gestureStartY

    if (!isGesturing)
        return

    MouseGetPos(&currentX, &currentY)

    deltaX := currentX - gestureStartX
    deltaY := currentY - gestureStartY

    threshold := 50

    ; Determine direction
    direction := ""

    if (Abs(deltaX) > threshold || Abs(deltaY) > threshold) {
        if (Abs(deltaX) > Abs(deltaY)) {
            ; Horizontal movement
            direction := (deltaX > 0) ? "R" : "L"
        } else {
            ; Vertical movement
            direction := (deltaY > 0) ? "D" : "U"
        }

        ; Avoid duplicate directions
        if (SubStr(gesturePath, -1) != direction) {
            gesturePath .= direction

            ; Update tooltip
            gestureDesc := TranslateGesture(gesturePath)
            ToolTip("Gesture: " gesturePath "`n" gestureDesc, currentX + 20, currentY + 20)
        }

        ; Reset start position
        gestureStartX := currentX
        gestureStartY := currentY
    }
}

ProcessGesture(path) {
    if (path = "")
        return

    Switch path {
        case "L":
            ; Left = Back (browser/file explorer)
            Send("!{Left}")
            ShowGestureResult("◄ Back")

        case "R":
            ; Right = Forward
            Send("!{Right}")
            ShowGestureResult("► Forward")

        case "U":
            ; Up = Maximize window
            WinMaximize("A")
            ShowGestureResult("⬆ Maximize")

        case "D":
            ; Down = Minimize window
            WinMinimize("A")
            ShowGestureResult("⬇ Minimize")

        case "DU":
            ; Down then Up = Close window
            WinClose("A")
            ShowGestureResult("✖ Close Window")

        case "RL":
            ; Right then Left = Reload page (browser)
            Send("^r")
            ShowGestureResult("↻ Reload")

        case "LR":
            ; Left then Right = Open new tab
            Send("^t")
            ShowGestureResult("➕ New Tab")

        case "UD":
            ; Up then Down = Scroll to top
            Send("{Home}")
            ShowGestureResult("⇈ Scroll Top")

        case "DUD":
            ; Down-Up-Down = Scroll to bottom
            Send("^{End}")
            ShowGestureResult("⇊ Scroll Bottom")

        case "RD":
            ; Right then Down = Next window
            Send("!{Esc}")
            ShowGestureResult("⊞ Next Window")

        case "RU":
            ; Right then Up = Previous window
            Send("+!{Esc}")
            ShowGestureResult("⊟ Previous Window")

        default:
            ShowGestureResult("Unknown: " path)
    }
}

TranslateGesture(path) {
    Switch path {
        case "L": return "← Back"
        case "R": return "→ Forward"
        case "U": return "↑ Maximize"
        case "D": return "↓ Minimize"
        case "DU": return "↓↑ Close"
        case "RL": return "→← Reload"
        case "LR": return "←→ New Tab"
        case "UD": return "↑↓ Top"
        case "DUD": return "↓↑↓ Bottom"
        case "RD": return "→↓ Next Win"
        case "RU": return "→↑ Prev Win"
        default: return "..."
    }
}

ShowGestureResult(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -1500)
}

; Help overlay
^!h::
{
    help := "
    (
    Mouse Gesture Commands
    ======================

    Hold RIGHT BUTTON and move mouse:

    ← Left          = Back
    → Right         = Forward
    ↑ Up            = Maximize Window
    ↓ Down          = Minimize Window

    ↓↑ Down-Up      = Close Window
    →← Right-Left   = Reload Page
    ←→ Left-Right   = New Tab
    ↑↓ Up-Down      = Scroll to Top
    ↓↑↓ Down-Up-Down = Scroll to Bottom
    →↓ Right-Down   = Next Window
    →↑ Right-Up     = Previous Window

    Press Ctrl+Alt+H for this help.
    )"

    MsgBox(help, "Mouse Gestures Help")
}
