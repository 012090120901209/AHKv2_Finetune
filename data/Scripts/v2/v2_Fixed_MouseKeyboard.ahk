#Requires AutoHotkey v2.0
#SingleInstance Force

/*
AHK v2 Mouse & Keyboard Functions - Corrected

Fixed versions of click and input functions
*/

; ============================================================================
; CLICK FUNCTION
; ============================================================================
; The original had syntax errors - v2 doesn't use % for expressions
ClickExample() {
    ; Simple click at current position
    Click()

    ; Click at specific coordinates
    Click(100, 200)

    ; Right click
    Click("Right")

    ; Double click
    Click(2)

    ; Click and drag
    Click(100, 100, "Down")
    Sleep(100)
    Click(200, 200, "Up")

    ; Middle click
    Click("Middle")

    ; Wheel up/down
    Click("WheelUp", 3)   ; Scroll up 3 notches
    Click("WheelDown", 2) ; Scroll down 2 notches
}

; Corrected click wrapper - v2 compatible
click(params*) {
    try {
        ; Build parameters for Click function
        if (params.Length = 0) {
            Click()
        } else if (params.Length = 1) {
            Click(params[1])
        } else if (params.Length = 2) {
            Click(params[1], params[2])
        } else if (params.Length = 3) {
            Click(params[1], params[2], params[3])
        } else {
            ; More than 3 parameters - concatenate as string
            paramStr := ""
            for index, param in params
            paramStr .= (index = 1 ? param : " " param)
            Click(paramStr)
        }
        return true
    } catch Error as e {
        MsgBox("Click error: " e.Message)
        return false
    }
}

; ============================================================================
; MOUSE MOVE
; ============================================================================
MouseMoveExample() {
    ; Move mouse instantly to coordinates
    MouseMove(500, 500)

    ; Move mouse slowly (speed 50)
    MouseMove(600, 600, 50)

    ; Move relative to current position
    MouseGetPos(&x, &y)
    MouseMove(x + 100, y + 50)
}

; ============================================================================
; MOUSE GET POS
; ============================================================================
MouseGetPosExample() {
    ; Get mouse position
    MouseGetPos(&xPos, &yPos)
    MsgBox("Mouse is at: " xPos ", " yPos)

    ; Get mouse position and window under cursor
    MouseGetPos(&xPos, &yPos, &winId)
    MsgBox("Mouse at: " xPos ", " yPos "`nWindow ID: " winId)

    ; Get control under cursor too
    MouseGetPos(&xPos, &yPos, &winId, &ctrlId)
    MsgBox("Mouse at: " xPos ", " yPos "`nWindow: " winId "`nControl: " ctrlId)
}

; ============================================================================
; SEND (Keyboard Input)
; ============================================================================
SendExample() {
    ; Send simple text
    Send("Hello World")

    ; Send with modifiers
    Send("^c")      ; Ctrl+C
    Send("!{Tab}")  ; Alt+Tab
    Send("+a")      ; Shift+A

    ; Send raw text (literal)
    SendText("This {will} not ^interpret !special +characters")

    ; Send with delays
    SetKeyDelay(100)  ; 100ms between keystrokes
    Send("Slow typing")
    SetKeyDelay(-1)   ; Back to instant
}

; ============================================================================
; SEND INPUT (Faster alternative)
; ============================================================================
SendInputExample() {
    ; SendInput is faster and more reliable than Send
    SendInput("Fast typing!")

    ; Cannot be interrupted by user
    SendInput("This will complete even if you press keys")
}

; ============================================================================
; SEND PLAY (For games)
; ============================================================================
SendPlayExample() {
    ; SendPlay works in some games where Send doesn't
    SendPlay("{w down}")
    Sleep(1000)
    SendPlay("{w up}")
}

; ============================================================================
; CLIP WAIT
; ============================================================================
; Wait for clipboard to contain data
ClipWaitExample() {
    ; Clear clipboard
    A_Clipboard := ""

    ; Copy something
    Send("^c")

    ; Wait up to 1 second for clipboard data
    result := ClipWait(1)

    if (result)
    MsgBox("Clipboard contains: " A_Clipboard)
    else
    MsgBox("Clipboard wait timed out")
}

; Corrected clipWait wrapper
clipWait(timeout := 1, mode := 0) {
    ; In v2, ClipWait returns true/false instead of setting ErrorLevel
    ; mode: 0 = wait for any data, 1 = wait for non-text data
    try {
        if (mode = 1)
        return ClipWait(timeout, true)
        else
        return ClipWait(timeout)
    } catch Error as e {
        return false
    }
}

; ============================================================================
; KEY WAIT
; ============================================================================
KeyWaitExample() {
    MsgBox("Press Space within 5 seconds...")

    ; Wait for Space key to be pressed
    result := KeyWait("Space", "D T5")  ; D=Down, T5=5 second timeout

    if (result)
    MsgBox("Space was pressed!")
    else
    MsgBox("Timed out waiting for Space")

    ; Wait for key to be released
    MsgBox("Hold down Space, then release it...")
    KeyWait("Space", "D")  ; Wait for press
    MsgBox("Space is down, now release it")
    KeyWait("Space")       ; Wait for release
    MsgBox("Space released!")
}

; ============================================================================
; GET KEY STATE
; ============================================================================
GetKeyStateExample() {
    ; Check if key is physically pressed
    if (GetKeyState("Shift", "P"))
    MsgBox("Shift is physically pressed")

    ; Check logical state (toggled)
    if (GetKeyState("CapsLock", "T"))
    MsgBox("CapsLock is ON")

    ; Check mouse button
    if (GetKeyState("LButton", "P"))
    MsgBox("Left mouse button is pressed")

    ; Get joystick position
    xPos := GetKeyState("JoyX")
    MsgBox("Joystick X position: " xPos)
}

; ============================================================================
; MOUSE CLICK DRAG
; ============================================================================
MouseClickDragExample() {
    ; Click and drag from (100,100) to (300,300)
    MouseClickDrag("Left", 100, 100, 300, 300)

    ; Slower drag (speed 50)
    MouseClickDrag("Left", 100, 100, 300, 300, 50)
}

; ============================================================================
; DEMONSTRATION
; ============================================================================

; Uncomment to test:
; ClickExample()
; MouseMoveExample()
; MouseGetPosExample()
; SendExample()
; ClipWaitExample()
; KeyWaitExample()
; GetKeyStateExample()
; MouseClickDragExample()

MsgBox("Mouse & Keyboard Functions Loaded`n`nUncomment examples at the bottom to test each function.")
