#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_DllCall_User32_03_Input.ahk
 * 
 * DESCRIPTION:
 * Demonstrates keyboard and mouse input simulation using DllCall to Windows API.
 * Shows how to send keystrokes, mouse movements, and clicks using SendInput,
 * mouse_event, and keybd_event functions.
 * 
 * FEATURES:
 * - Keyboard input simulation using SendInput API
 * - Mouse input simulation (movement, clicks, wheel)
 * - Virtual key codes and scan codes
 * - Input blocking and hooks
 * - Getting keyboard and mouse state
 * - Hardware vs virtual input simulation
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft SendInput API
 * https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-sendinput
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with complex structures (INPUT)
 * - Buffer object for structure creation
 * - NumPut/NumGet for structure field access
 * - Array of structures for batch input
 * - Virtual key code handling
 * 
 * LEARNING POINTS:
 * 1. How to create INPUT structures for SendInput
 * 2. Difference between keyboard and mouse input structures
 * 3. Using virtual key codes and scan codes
 * 4. Simulating extended keys and modifier combinations
 * 5. Hardware vs virtual input methods
 * 6. Getting async key state
 * 7. Mouse coordinate systems and normalization
 */

;==============================================================================
; EXAMPLE 1: Basic Keyboard Input with SendInput
;==============================================================================
; Demonstrates sending keyboard input using SendInput API

Example1_BasicKeyboardInput() {
    MsgBox("This example will type text into Notepad.`n`nNotepad will open and receive input.", "Info")

    ; Open Notepad
    Run("notepad.exe")
    Sleep(1000)

    ; INPUT structure constants
    INPUT_KEYBOARD := 1
    KEYEVENTF_KEYUP := 0x0002
    KEYEVENTF_UNICODE := 0x0004

    ; Virtual key codes
    VK_H := 0x48  ; 'H' key
    VK_E := 0x45  ; 'E' key
    VK_L := 0x4C  ; 'L' key
    VK_O := 0x4F  ; 'O' key

    ; Function to send a single key
    SendKey := (vkCode, isKeyUp := false) {
        ; INPUT structure size:
        ; - type: 4 bytes (DWORD)
        ; - union: 24 bytes (largest of MOUSEINPUT, KEYBDINPUT, HARDWAREINPUT)
        ; Total: 28 bytes (with padding)
        inputStruct := Buffer(28, 0)

        NumPut("UInt", INPUT_KEYBOARD, inputStruct, 0)      ; type
        NumPut("UShort", vkCode, inputStruct, 8)            ; wVk (virtual key)
        NumPut("UShort", 0, inputStruct, 10)                ; wScan
        NumPut("UInt", isKeyUp ? KEYEVENTF_KEYUP : 0, inputStruct, 12)  ; dwFlags
        NumPut("UInt", 0, inputStruct, 16)                  ; time
        NumPut("UPtr", 0, inputStruct, 20)                  ; dwExtraInfo

        DllCall("User32.dll\SendInput"
            , "UInt", 1                 ; nInputs - number of inputs
            , "Ptr", inputStruct.Ptr    ; pInputs - array of INPUT structures
            , "Int", 28                 ; cbSize - size of INPUT structure
            , "UInt")                   ; Return: number of events inserted
    }

    ; Send "HELLO" letter by letter
    keys := [VK_H, VK_E, VK_L, VK_L, VK_O]

    for vk in keys {
        SendKey(vk, false)  ; Key down
        SendKey(vk, true)   ; Key up
        Sleep(100)
    }

    MsgBox("Basic keyboard input complete!", "Success")
}

;==============================================================================
; EXAMPLE 2: Advanced Keyboard Input with Modifiers
;==============================================================================
; Shows how to send key combinations with Shift, Ctrl, Alt

Example2_ModifierKeys() {
    MsgBox("This example will demonstrate modifier keys.`n`nNotepad will receive: Ctrl+A, Ctrl+C, Ctrl+V", "Info")

    ; Ensure Notepad is open with some text
    Run("notepad.exe")
    Sleep(1000)

    INPUT_KEYBOARD := 1
    KEYEVENTF_KEYUP := 0x0002

    ; Virtual key codes
    VK_CONTROL := 0x11
    VK_SHIFT := 0x10
    VK_MENU := 0x12      ; Alt key
    VK_A := 0x41
    VK_C := 0x43
    VK_V := 0x56
    VK_RETURN := 0x0D

    ; Function to send key with modifiers
    SendKeyCombo := (vkCode, useCtrl := false, useShift := false, useAlt := false) {
        inputs := []

        ; Press modifiers
        if (useCtrl)
            inputs.Push({ vk: VK_CONTROL, up: false })
        if (useShift)
            inputs.Push({ vk: VK_SHIFT, up: false })
        if (useAlt)
            inputs.Push({ vk: VK_MENU, up: false })

        ; Press main key
        inputs.Push({ vk: vkCode, up: false })
        inputs.Push({ vk: vkCode, up: true })

        ; Release modifiers (in reverse order)
        if (useAlt)
            inputs.Push({ vk: VK_MENU, up: true })
        if (useShift)
            inputs.Push({ vk: VK_SHIFT, up: true })
        if (useCtrl)
            inputs.Push({ vk: VK_CONTROL, up: true })

        ; Create array of INPUT structures
        inputArray := Buffer(28 * inputs.Length, 0)

        for index, input in inputs {
            offset := (index - 1) * 28
            NumPut("UInt", INPUT_KEYBOARD, inputArray, offset + 0)
            NumPut("UShort", input.vk, inputArray, offset + 8)
            NumPut("UShort", 0, inputArray, offset + 10)
            NumPut("UInt", input.up ? KEYEVENTF_KEYUP : 0, inputArray, offset + 12)
            NumPut("UInt", 0, inputArray, offset + 16)
            NumPut("UPtr", 0, inputArray, offset + 20)
        }

        DllCall("User32.dll\SendInput"
            , "UInt", inputs.Length
            , "Ptr", inputArray.Ptr
            , "Int", 28
            , "UInt")
    }

    ; Type some text first using Unicode
    SendUnicodeString("Hello World!")
    Sleep(500)

    ; Select all (Ctrl+A)
    SendKeyCombo(VK_A, true)
    Sleep(300)

    ; Copy (Ctrl+C)
    SendKeyCombo(VK_C, true)
    Sleep(300)

    ; Move to end
    SendKeyCombo(VK_RETURN)
    Sleep(200)

    ; Paste (Ctrl+V)
    SendKeyCombo(VK_V, true)

    MsgBox("Modifier key demonstration complete!", "Success")
}

; Helper function to send Unicode strings
SendUnicodeString(text) {
    INPUT_KEYBOARD := 1
    KEYEVENTF_UNICODE := 0x0004
    KEYEVENTF_KEYUP := 0x0002

    Loop Parse text {
        charCode := Ord(A_LoopField)

        ; Key down
        inputDown := Buffer(28, 0)
        NumPut("UInt", INPUT_KEYBOARD, inputDown, 0)
        NumPut("UShort", 0, inputDown, 8)
        NumPut("UShort", charCode, inputDown, 10)
        NumPut("UInt", KEYEVENTF_UNICODE, inputDown, 12)

        ; Key up
        inputUp := Buffer(28, 0)
        NumPut("UInt", INPUT_KEYBOARD, inputUp, 0)
        NumPut("UShort", 0, inputUp, 8)
        NumPut("UShort", charCode, inputUp, 10)
        NumPut("UInt", KEYEVENTF_UNICODE | KEYEVENTF_KEYUP, inputUp, 12)

        ; Create array with both inputs
        inputArray := Buffer(56, 0)
        DllMemMove(inputArray.Ptr, inputDown.Ptr, 28)
        DllMemMove(inputArray.Ptr + 28, inputUp.Ptr, 28)

        DllCall("User32.dll\SendInput", "UInt", 2, "Ptr", inputArray.Ptr, "Int", 28, "UInt")
        Sleep(10)
    }
}

; Helper for memory copy
DllMemMove(dest, source, size) {
    DllCall("msvcrt.dll\memcpy", "Ptr", dest, "Ptr", source, "UInt", size, "Ptr")
}

;==============================================================================
; EXAMPLE 3: Mouse Input Simulation
;==============================================================================
; Demonstrates mouse movement and clicks using SendInput

Example3_MouseInput() {
    MsgBox("This example will demonstrate mouse input.`n`nThe mouse will move and click automatically.", "Info")

    INPUT_MOUSE := 0

    ; Mouse event flags
    MOUSEEVENTF_MOVE := 0x0001
    MOUSEEVENTF_LEFTDOWN := 0x0002
    MOUSEEVENTF_LEFTUP := 0x0004
    MOUSEEVENTF_RIGHTDOWN := 0x0008
    MOUSEEVENTF_RIGHTUP := 0x0010
    MOUSEEVENTF_ABSOLUTE := 0x8000

    ; Function to move mouse to absolute position
    MoveMouse := (x, y) {
        ; Convert screen coordinates to normalized absolute coordinates
        ; (0-65535 range)
        screenWidth := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")
        screenHeight := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")

        normalizedX := Integer((x * 65535) / screenWidth)
        normalizedY := Integer((y * 65535) / screenHeight)

        ; Create MOUSEINPUT structure within INPUT
        inputStruct := Buffer(28, 0)
        NumPut("UInt", INPUT_MOUSE, inputStruct, 0)         ; type
        NumPut("Int", normalizedX, inputStruct, 8)          ; dx
        NumPut("Int", normalizedY, inputStruct, 12)         ; dy
        NumPut("UInt", 0, inputStruct, 16)                  ; mouseData
        NumPut("UInt", MOUSEEVENTF_MOVE | MOUSEEVENTF_ABSOLUTE, inputStruct, 20)  ; dwFlags
        NumPut("UInt", 0, inputStruct, 24)                  ; time

        DllCall("User32.dll\SendInput", "UInt", 1, "Ptr", inputStruct.Ptr, "Int", 28, "UInt")
    }

    ; Function to click mouse
    ClickMouse := (button := "left") {
        downFlag := (button = "left") ? MOUSEEVENTF_LEFTDOWN : MOUSEEVENTF_RIGHTDOWN
        upFlag := (button = "left") ? MOUSEEVENTF_LEFTUP : MOUSEEVENTF_RIGHTUP

        ; Mouse down
        inputDown := Buffer(28, 0)
        NumPut("UInt", INPUT_MOUSE, inputDown, 0)
        NumPut("UInt", downFlag, inputDown, 20)

        ; Mouse up
        inputUp := Buffer(28, 0)
        NumPut("UInt", INPUT_MOUSE, inputUp, 0)
        NumPut("UInt", upFlag, inputUp, 20)

        ; Send both events
        inputArray := Buffer(56, 0)
        DllMemMove(inputArray.Ptr, inputDown.Ptr, 28)
        DllMemMove(inputArray.Ptr + 28, inputUp.Ptr, 28)

        DllCall("User32.dll\SendInput", "UInt", 2, "Ptr", inputArray.Ptr, "Int", 28, "UInt")
    }

    ; Draw a square with the mouse
    screenWidth := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")
    screenHeight := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")

    centerX := screenWidth // 2
    centerY := screenHeight // 2
    size := 100

    positions := [{
        x: centerX - size, y: centerY - size },  ; Top-left
        {
            x: centerX + size, y: centerY - size },  ; Top-right
        {
            x: centerX + size, y: centerY + size },  ; Bottom-right
        {
            x: centerX - size, y: centerY + size },  ; Bottom-left
        {
            x: centerX - size, y: centerY - size }   ; Back to start
    ]

    for pos in positions {
        MoveMouse(pos.x, pos.y)
        Sleep(500)
    }

    ; Click at center
    MoveMouse(centerX, centerY)
    Sleep(300)
    ClickMouse("left")

    MsgBox("Mouse input demonstration complete!", "Success")
}

;==============================================================================
; EXAMPLE 4: Getting Keyboard State
;==============================================================================
; Shows how to check if keys are pressed using GetAsyncKeyState

Example4_GetKeyboardState() {
    MsgBox("Press and hold various keys.`n`nThe script will detect which keys are pressed.`n`nPress ESC to stop.", "Info")

    ; Virtual key codes to monitor
    monitorKeys := Map(
        "Shift", 0x10,
        "Ctrl", 0x11,
        "Alt", 0x12,
        "Space", 0x20,
        "A", 0x41,
        "ESC", 0x1B
    )

    previousStates := Map()
    for name, vk in monitorKeys
        previousStates[name] := false

    Loop {
        changed := []

        for name, vk in monitorKeys {
            ; GetAsyncKeyState returns:
            ; - Bit 15: 1 if key is currently down
            ; - Bit 0: 1 if key was pressed since last call
            state := DllCall("User32.dll\GetAsyncKeyState", "Int", vk, "Short")
            isPressed := (state & 0x8000) != 0

            if (isPressed != previousStates[name]) {
                changed.Push(name . ": " . (isPressed ? "DOWN" : "UP"))
                previousStates[name] := isPressed
            }

            ; Exit on ESC
            if (name = "ESC" && isPressed)
                return
        }

        if (changed.Length > 0) {
            ToolTip(StrJoin(changed, "`n"))
        }

        Sleep(50)
    }
}

; Helper to join array elements
StrJoin(arr, delimiter) {
    result := ""
    for item in arr {
        if (result != "")
            result .= delimiter
        result .= item
    }
    return result
}

;==============================================================================
; EXAMPLE 5: Mouse Wheel Simulation
;==============================================================================
; Demonstrates mouse wheel scrolling

Example5_MouseWheel() {
    MsgBox("This example will scroll the mouse wheel.`n`nOpen a scrollable window (like Notepad with lots of text).", "Info")

    Run("notepad.exe")
    Sleep(1000)

    ; Add some text to scroll
    SendUnicodeString("Line 1`n")
    Loop 50
        SendUnicodeString("This is line " . A_Index . "`n")

    Sleep(500)

    INPUT_MOUSE := 0
    MOUSEEVENTF_WHEEL := 0x0800
    WHEEL_DELTA := 120  ; Standard wheel delta

    ; Function to scroll wheel
    ScrollWheel := (amount) {
        inputStruct := Buffer(28, 0)
        NumPut("UInt", INPUT_MOUSE, inputStruct, 0)
        NumPut("UInt", amount, inputStruct, 16)             ; mouseData (scroll amount)
        NumPut("UInt", MOUSEEVENTF_WHEEL, inputStruct, 20)  ; dwFlags

        DllCall("User32.dll\SendInput", "UInt", 1, "Ptr", inputStruct.Ptr, "Int", 28, "UInt")
    }

    MsgBox("Scrolling down...", "Info", "T2")
    Loop 5 {
        ScrollWheel(-WHEEL_DELTA)  ; Negative for down
        Sleep(300)
    }

    Sleep(1000)

    MsgBox("Scrolling up...", "Info", "T2")
    Loop 5 {
        ScrollWheel(WHEEL_DELTA)   ; Positive for up
        Sleep(300)
    }

    MsgBox("Mouse wheel demonstration complete!", "Success")
}

;==============================================================================
; EXAMPLE 6: Extended Keys and Scan Codes
;==============================================================================
; Shows how to use scan codes and extended keys

Example6_ExtendedKeys() {
    MsgBox("This example demonstrates extended keys.`n`nNotepad will receive various special keys.", "Info")

    Run("notepad.exe")
    Sleep(1000)

    INPUT_KEYBOARD := 1
    KEYEVENTF_EXTENDEDKEY := 0x0001
    KEYEVENTF_KEYUP := 0x0002
    KEYEVENTF_SCANCODE := 0x0008

    ; Extended key codes
    VK_LEFT := 0x25
    VK_UP := 0x26
    VK_RIGHT := 0x27
    VK_DOWN := 0x28
    VK_HOME := 0x24
    VK_END := 0x23
    VK_PRIOR := 0x21  ; Page Up
    VK_NEXT := 0x22   ; Page Down

    ; Function to send extended key
    SendExtendedKey := (vkCode) {
        ; Key down
        inputDown := Buffer(28, 0)
        NumPut("UInt", INPUT_KEYBOARD, inputDown, 0)
        NumPut("UShort", vkCode, inputDown, 8)
        NumPut("UInt", KEYEVENTF_EXTENDEDKEY, inputDown, 12)

        ; Key up
        inputUp := Buffer(28, 0)
        NumPut("UInt", INPUT_KEYBOARD, inputUp, 0)
        NumPut("UShort", vkCode, inputUp, 8)
        NumPut("UInt", KEYEVENTF_EXTENDEDKEY | KEYEVENTF_KEYUP, inputUp, 12)

        ; Send both
        inputArray := Buffer(56, 0)
        DllMemMove(inputArray.Ptr, inputDown.Ptr, 28)
        DllMemMove(inputArray.Ptr + 28, inputUp.Ptr, 28)

        DllCall("User32.dll\SendInput", "UInt", 2, "Ptr", inputArray.Ptr, "Int", 28, "UInt")
    }

    ; Type some text
    SendUnicodeString("Arrow keys test: ")
    Sleep(300)

    ; Send arrow keys
    keys := [{
        name: "Right", vk: VK_RIGHT }, {
            name: "Down", vk: VK_DOWN }, {
                name: "Left", vk: VK_LEFT }, {
                    name: "Up", vk: VK_UP }, {
                        name: "Home", vk: VK_HOME }, {
                            name: "End", vk: VK_END
                        }
    ]

    for key in keys {
        ToolTip("Pressing: " . key.name)
        SendExtendedKey(key.vk)
        Sleep(500)
    }

    ToolTip()
    MsgBox("Extended keys demonstration complete!", "Success")
}

;==============================================================================
; EXAMPLE 7: Input Blocking and Simulation
;==============================================================================
; Demonstrates BlockInput and comprehensive input simulation

Example7_AdvancedInput() {
    if MsgBox("This example will temporarily block user input.`n`nContinue?", "Warning", "YesNo") = "No"
        return

    MsgBox("Opening Notepad and demonstrating automated input...", "Info")

    Run("notepad.exe")
    Sleep(1000)

    ; Block input (use with caution!)
    ; Note: Admin rights may be required
    try {
        DllCall("User32.dll\BlockInput", "Int", 1, "Int")  ; 1 = Block, 0 = Unblock
    }

    ; Automated typing sequence
    SendUnicodeString("This text is being typed automatically!`n`n")
    Sleep(300)

    SendUnicodeString("The user's input is blocked during this demonstration.`n`n")
    Sleep(300)

    SendUnicodeString("This shows how Windows API can control input.`n")
    Sleep(500)

    ; Unblock input
    try {
        DllCall("User32.dll\BlockInput", "Int", 0, "Int")
    }

    MsgBox("Input unblocked!`n`nDemonstration complete.", "Success")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
                                            (
                                            Input Simulation DllCall Examples
                                            ==================================

                                            1. Basic Keyboard Input
                                            2. Modifier Keys (Ctrl, Shift, Alt)
                                            3. Mouse Input
                                            4. Get Keyboard State
                                            5. Mouse Wheel
                                            6. Extended Keys
                                            7. Advanced Input & Blocking

                                            Enter choice (1-7) or 0 to exit:
                                            )"

    Loop {
        choice := InputBox(menu, "Input Simulation Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_BasicKeyboardInput()
            case "2": Example2_ModifierKeys()
            case "3": Example3_MouseInput()
            case "4": Example4_GetKeyboardState()
            case "5": Example5_MouseWheel()
            case "6": Example6_ExtendedKeys()
            case "7": Example7_AdvancedInput()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
