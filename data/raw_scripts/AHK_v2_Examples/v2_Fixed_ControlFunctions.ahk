#Requires AutoHotkey v2.0
#SingleInstance Force

/*
	AHK v2 Control Functions - Corrected

	Major changes from v1:
	- Most Control commands are now methods of control objects
	- ControlGet split into multiple functions (ControlGetText, ControlGetPos, etc.)
	- Use ControlGetHwnd() to get control handle
	- ErrorLevel replaced with exceptions and return values
*/

; ============================================================================
; CONTROL GET HWND
; ============================================================================
ControlGetHwndExample() {
    ; Get handle of Notepad edit control
    if (WinExist("ahk_class Notepad")) {
        try {
            hwnd := ControlGetHwnd("Edit1", "A")
            MsgBox("Edit control handle: " hwnd)
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    } else {
        MsgBox("Please open Notepad first")
    }
}

; ============================================================================
; CONTROL GET TEXT
; ============================================================================
ControlGetTextExample() {
    if (WinExist("ahk_class Notepad")) {
        try {
            ; Get text from Edit control
            text := ControlGetText("Edit1", "A")
            MsgBox("Notepad contains: " text)
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    } else {
        MsgBox("Please open Notepad and type something")
    }
}

; Wrapper with error handling (v2 style)
controlGetText2(winTitle := "A", control := "", winText := "", excludeTitle := "", excludeText := "") {
    try {
        text := ControlGetText(control, winTitle, winText, excludeTitle, excludeText)
        return { out: text, success: true, error: "" }
    } catch Error as e {
        return { out: "", success: false, error: e.Message }
    }
}

; ============================================================================
; CONTROL SET TEXT
; ============================================================================
ControlSetTextExample() {
    ; Open Notepad if not open
    if (!WinExist("ahk_class Notepad"))
        Run("notepad.exe")

    WinWait("ahk_class Notepad", , 3)

    try {
        ; Set text in Edit control
        ControlSetText("Hello from AHK v2!", "Edit1", "A")
        MsgBox("Text set successfully!")
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

; ============================================================================
; CONTROL CLICK
; ============================================================================
ControlClickExample() {
    ; Click a button in Calculator
    if (WinExist("ahk_class ApplicationFrameWindow ahk_exe Calculator.exe")
        || WinExist("ahk_class CalcFrame")) {

        try {
            ; Click the "1" button
            ControlClick("Button1", "A")  ; May vary by Calculator version
            Sleep(500)

            ; Click with coordinates
            ControlClick("X50 Y50", "A")
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    } else {
        MsgBox("Please open Calculator first")
    }
}

; ============================================================================
; CONTROL SEND
; ============================================================================
ControlSendExample() {
    if (!WinExist("ahk_class Notepad"))
        Run("notepad.exe")

    WinWait("ahk_class Notepad", , 3)

    try {
        ; Send text to control without activating window
        ControlSend("Hello from ControlSend!{Enter}", "Edit1", "A")
        Sleep(500)
        ControlSend("This works even if window is not active!", "Edit1", "A")
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }
}

; ============================================================================
; CONTROL FOCUS
; ============================================================================
ControlFocusExample() {
    if (WinExist("ahk_class Notepad")) {
        try {
            ; Focus the Edit control
            ControlFocus("Edit1", "A")
            MsgBox("Edit control now has focus")
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    }
}

; ============================================================================
; CONTROL GET POS
; ============================================================================
ControlGetPosExample() {
    if (WinExist("ahk_class Notepad")) {
        try {
            ; Get position and size of Edit control
            ControlGetPos(&x, &y, &w, &h, "Edit1", "A")
            MsgBox("Edit control:`nX: " x "`nY: " y "`nWidth: " w "`nHeight: " h)
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    }
}

; Wrapper that returns object (v2 style)
controlGetPos2(winTitle := "A", control := "", winText := "", excludeTitle := "", excludeText := "") {
    try {
        ControlGetPos(&x, &y, &width, &height, control, winTitle, winText, excludeTitle, excludeText)
        return { x: x, y: y, width: width, height: height, success: true }
    } catch Error as e {
        return { x: 0, y: 0, width: 0, height: 0, success: false, error: e.Message }
    }
}

; ============================================================================
; CONTROL GET FOCUS
; ============================================================================
ControlGetFocusExample() {
    if (WinExist("ahk_class Notepad")) {
        try {
            ; Get ClassNN of focused control
            focusedControl := ControlGetFocus("A")
            MsgBox("Focused control: " focusedControl)
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    }
}

; ============================================================================
; CONTROL MOVE
; ============================================================================
ControlMoveExample() {
    if (WinExist("ahk_class Notepad")) {
        try {
            ; Get current position
            ControlGetPos(&x, &y, &w, &h, "Edit1", "A")
            MsgBox("Original position: " x ", " y)

            ; Move control
            ControlMove(x + 10, y + 10, , , "Edit1", "A")
            MsgBox("Control moved!")

            ; Move back
            Sleep(1000)
            ControlMove(x, y, , , "Edit1", "A")
        } catch Error as e {
            MsgBox("Error: " e.Message)
        }
    }
}

; ============================================================================
; CONTROL GET ITEMS (for ListBox/ComboBox)
; ============================================================================
ControlGetItemsExample() {
    ; Create a test GUI with ListBox
    testGui := Gui()
    lb := testGui.Add("ListBox", "w200 h100", ["Item 1", "Item 2", "Item 3"])
    testGui.Show()

    Sleep(500)

    try {
        ; Get all items
        items := ControlGetItems("ListBox1", testGui)
        itemText := ""
        for item in items
            itemText .= item "`n"
        MsgBox("ListBox items:`n" itemText)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }

    testGui.Destroy()
}

; ============================================================================
; CONTROL GET CHOICE (selected item in ListBox/ComboBox)
; ============================================================================
ControlGetChoiceExample() {
    testGui := Gui()
    cb := testGui.Add("ComboBox", "w200", ["Apple", "Banana", "Cherry"])
    cb.Choose(2)  ; Select "Banana"
    testGui.Show()

    Sleep(500)

    try {
        ; Get selected item
        choice := ControlGetChoice("ComboBox1", testGui)
        MsgBox("Selected: " choice)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }

    testGui.Destroy()
}

; ============================================================================
; CONTROL CHOOSE STRING (select item by text)
; ============================================================================
ControlChooseStringExample() {
    testGui := Gui()
    cb := testGui.Add("ComboBox", "w200", ["Apple", "Banana", "Cherry"])
    testGui.Show()

    Sleep(500)

    try {
        ; Select by string
        ControlChooseString("Cherry", "ComboBox1", testGui)
        MsgBox("Selected 'Cherry'")

        choice := ControlGetChoice("ComboBox1", testGui)
        MsgBox("Current selection: " choice)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }

    testGui.Destroy()
}

; ============================================================================
; CONTROL CHOOSE INDEX (select item by position)
; ============================================================================
ControlChooseIndexExample() {
    testGui := Gui()
    lb := testGui.Add("ListBox", "w200 h100", ["First", "Second", "Third"])
    testGui.Show()

    Sleep(500)

    try {
        ; Select by index (1-based)
        ControlChooseIndex(2, "ListBox1", testGui)
        MsgBox("Selected item 2")

        choice := ControlGetChoice("ListBox1", testGui)
        MsgBox("Current selection: " choice)
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }

    testGui.Destroy()
}

; ============================================================================
; CONTROL HIDE / SHOW
; ============================================================================
ControlHideShowExample() {
    testGui := Gui()
    btn := testGui.Add("Button", "w200", "Click Me")
    testGui.Show()

    Sleep(1000)

    try {
        ; Hide control
        ControlHide("Button1", testGui)
        MsgBox("Button hidden")

        Sleep(1000)

        ; Show control
        ControlShow("Button1", testGui)
        MsgBox("Button shown")
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }

    testGui.Destroy()
}

; ============================================================================
; CONTROL ENABLE / DISABLE
; ============================================================================
ControlEnableDisableExample() {
    testGui := Gui()
    btn := testGui.Add("Button", "w200", "Click Me")
    testGui.Show()

    Sleep(1000)

    try {
        ; Disable control
        ControlSetEnabled(false, "Button1", testGui)
        MsgBox("Button disabled")

        Sleep(1000)

        ; Enable control
        ControlSetEnabled(true, "Button1", testGui)
        MsgBox("Button enabled")
    } catch Error as e {
        MsgBox("Error: " e.Message)
    }

    testGui.Destroy()
}

; ============================================================================
; DEMONSTRATION
; ============================================================================

MsgBox("Control Functions Loaded`n`nThese examples work with Notepad and other windows.`n`nUncomment individual examples to test.")

; Uncomment to test:
; ControlGetHwndExample()
; ControlGetTextExample()
; ControlSetTextExample()
; ControlSendExample()
; ControlGetPosExample()
; ControlGetFocusExample()
; ControlGetItemsExample()
; ControlGetChoiceExample()
; ControlHideShowExample()
