#Requires AutoHotkey v2.0

/**
 * BuiltIn_DllCall_User32_02_Windows.ahk
 * 
 * DESCRIPTION:
 * Demonstrates window manipulation using DllCall to Windows API functions.
 * Shows how to find, move, resize, show, hide, and modify windows using
 * direct API calls.
 * 
 * FEATURES:
 * - Finding windows by title or class name
 * - Getting and setting window positions
 * - Showing and hiding windows
 * - Window state manipulation (minimize, maximize, restore)
 * - Getting window information (title, class, process)
 * - Z-order manipulation (always on top, bring to front)
 * - Window style modification
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Windows API Documentation
 * https://docs.microsoft.com/en-us/windows/win32/api/winuser/
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() function with User32.dll
 * - Window handle (HWND) management with Ptr type
 * - Structure passing using Buffer objects
 * - String buffer handling for output parameters
 * - Multiple return value handling
 * 
 * LEARNING POINTS:
 * 1. How to find windows using FindWindowW and FindWindowExW
 * 2. Getting window dimensions with GetWindowRect
 * 3. Moving and resizing windows with MoveWindow and SetWindowPos
 * 4. Changing window visibility with ShowWindow
 * 5. Working with window styles using GetWindowLong and SetWindowLong
 * 6. Z-order manipulation and always-on-top functionality
 * 7. Retrieving window text and class names
 */

;==============================================================================
; EXAMPLE 1: Finding Windows
;==============================================================================
; Demonstrates different methods to find windows

Example1_FindingWindows() {
    ; Find Notepad window by class name
    hwndNotepad := DllCall("User32.dll\FindWindowW"
        , "Str", "Notepad"    ; lpClassName - window class name
        , "Ptr", 0            ; lpWindowName - window title (0 = any)
        , "Ptr")              ; Return type: window handle

    if (hwndNotepad = 0) {
        MsgBox("Notepad not found. Opening Notepad...", "Info")
        Run("notepad.exe")
        Sleep(1000)
        hwndNotepad := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")
    }

    if (hwndNotepad) {
        MsgBox(Format("Found Notepad!`nWindow Handle: 0x{:X}", hwndNotepad), "Success")

        ; Get window title
        titleBuf := Buffer(512, 0)
        DllCall("User32.dll\GetWindowTextW"
            , "Ptr", hwndNotepad       ; hWnd
            , "Ptr", titleBuf.Ptr      ; lpString - buffer for title
            , "Int", 256               ; nMaxCount
            , "Int")                   ; Return value: length

        title := StrGet(titleBuf.Ptr, "UTF-16")
        MsgBox("Window Title: " . title, "Window Info")
    }

    ; Find window by exact title
    hwndByTitle := DllCall("User32.dll\FindWindowW"
        , "Ptr", 0                    ; lpClassName (0 = any class)
        , "Str", title                ; lpWindowName - exact title
        , "Ptr")

    if (hwndByTitle)
        MsgBox(Format("Found by title: 0x{:X}", hwndByTitle), "Success")

    ; Demonstrate EnumWindows to list all top-level windows
    windowList := []
    EnumWindowsProc := (hwnd, lParam) => {
        ; Get window title
        titleBuffer := Buffer(512, 0)
        length := DllCall("User32.dll\GetWindowTextW"
            , "Ptr", hwnd
            , "Ptr", titleBuffer.Ptr
            , "Int", 256
            , "Int")
        if (length > 0) {
            title := StrGet(titleBuffer.Ptr, "UTF-16")
            ; Check if window is visible
            isVisible := DllCall("User32.dll\IsWindowVisible", "Ptr", hwnd, "Int")
            if (isVisible)
                windowList.Push(Format("0x{:X} - {}", hwnd, title))
        }
        return 1  ; Continue enumeration
    }

    ; Create callback for EnumWindows
    callback := CallbackCreate(EnumWindowsProc, "F", 2)
    DllCall("User32.dll\EnumWindows", "Ptr", callback, "Ptr", 0)
    CallbackFree(callback)

    ; Show first 10 windows
    result := "Visible Windows (first 10):`n`n"
    Loop Min(10, windowList.Length)
        result .= windowList[A_Index] . "`n"

    MsgBox(result, "Window Enumeration")
}

;==============================================================================
; EXAMPLE 2: Getting Window Position and Size
;==============================================================================
; Shows how to retrieve window dimensions using GetWindowRect

Example2_GetWindowPosition() {
    ; Find a window (using Notepad as example)
    hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")

    if (!hwnd) {
        MsgBox("Please open Notepad first!", "Error")
        return
    }

    ; RECT structure: left, top, right, bottom (4 Int32 values)
    rectStruct := Buffer(16, 0)  ; 4 * 4 bytes = 16 bytes

    success := DllCall("User32.dll\GetWindowRect"
        , "Ptr", hwnd              ; hWnd
        , "Ptr", rectStruct.Ptr    ; lpRect - pointer to RECT structure
        , "Int")                   ; Return value: success/failure

    if (success) {
        ; Extract values from RECT structure
        left := NumGet(rectStruct, 0, "Int")
        top := NumGet(rectStruct, 4, "Int")
        right := NumGet(rectStruct, 8, "Int")
        bottom := NumGet(rectStruct, 12, "Int")

        width := right - left
        height := bottom - top

        info := Format("
        (
        Window Position and Size:

        Left: {}
        Top: {}
        Right: {}
        Bottom: {}

        Width: {}
        Height: {}
        )", left, top, right, bottom, width, height)

        MsgBox(info, "Window Rect Info")

        ; Also demonstrate GetClientRect (client area only)
        clientRect := Buffer(16, 0)
        DllCall("User32.dll\GetClientRect", "Ptr", hwnd, "Ptr", clientRect.Ptr, "Int")

        clientWidth := NumGet(clientRect, 8, "Int")
        clientHeight := NumGet(clientRect, 12, "Int")

        MsgBox(Format("Client Area: {} x {}`nFull Window: {} x {}`nBorder/Title: {} x {}",
            clientWidth, clientHeight, width, height,
            width - clientWidth, height - clientHeight), "Client vs Window Size")
    }
}

;==============================================================================
; EXAMPLE 3: Moving and Resizing Windows
;==============================================================================
; Demonstrates window positioning using MoveWindow and SetWindowPos

Example3_MoveResizeWindow() {
    hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")

    if (!hwnd) {
        MsgBox("Please open Notepad first!", "Error")
        return
    }

    ; Save original position
    originalRect := Buffer(16, 0)
    DllCall("User32.dll\GetWindowRect", "Ptr", hwnd, "Ptr", originalRect.Ptr, "Int")
    origLeft := NumGet(originalRect, 0, "Int")
    origTop := NumGet(originalRect, 4, "Int")
    origWidth := NumGet(originalRect, 8, "Int") - origLeft
    origHeight := NumGet(originalRect, 12, "Int") - origTop

    ; Method 1: MoveWindow - moves and resizes in one call
    MsgBox("Moving window to top-left (100, 100)...", "Info")

    DllCall("User32.dll\MoveWindow"
        , "Ptr", hwnd          ; hWnd
        , "Int", 100           ; X position
        , "Int", 100           ; Y position
        , "Int", 800           ; Width
        , "Int", 600           ; Height
        , "Int", 1             ; bRepaint - should repaint?
        , "Int")               ; Return value

    Sleep(2000)

    ; Method 2: SetWindowPos - more control over positioning
    SWP_NOSIZE := 0x0001      ; Ignores width and height parameters
    SWP_NOMOVE := 0x0002      ; Ignores X and Y parameters
    SWP_NOZORDER := 0x0004    ; Retains current Z order
    SWP_SHOWWINDOW := 0x0040  ; Displays the window

    MsgBox("Moving to center of screen (position only)...", "Info")

    ; Get screen dimensions
    screenWidth := DllCall("User32.dll\GetSystemMetrics", "Int", 0, "Int")   ; SM_CXSCREEN
    screenHeight := DllCall("User32.dll\GetSystemMetrics", "Int", 1, "Int")  ; SM_CYSCREEN

    centerX := (screenWidth - 800) // 2
    centerY := (screenHeight - 600) // 2

    DllCall("User32.dll\SetWindowPos"
        , "Ptr", hwnd              ; hWnd
        , "Ptr", 0                 ; hWndInsertAfter (0 = HWND_TOP)
        , "Int", centerX           ; X
        , "Int", centerY           ; Y
        , "Int", 0                 ; cx (width) - ignored due to SWP_NOSIZE
        , "Int", 0                 ; cy (height) - ignored due to SWP_NOSIZE
        , "UInt", SWP_NOSIZE       ; uFlags
        , "Int")                   ; Return value

    Sleep(2000)

    ; Restore original position
    if MsgBox("Restore original position?", "Question", "YesNo") = "Yes" {
        DllCall("User32.dll\MoveWindow"
            , "Ptr", hwnd
            , "Int", origLeft
            , "Int", origTop
            , "Int", origWidth
            , "Int", origHeight
            , "Int", 1
            , "Int")
    }
}

;==============================================================================
; EXAMPLE 4: Window Visibility and State
;==============================================================================
; Demonstrates ShowWindow with different commands

Example4_WindowVisibility() {
    hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")

    if (!hwnd) {
        Run("notepad.exe")
        Sleep(1000)
        hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")
    }

    ; ShowWindow constants
    SW_HIDE := 0
    SW_SHOWNORMAL := 1
    SW_SHOWMINIMIZED := 2
    SW_SHOWMAXIMIZED := 3
    SW_SHOWNOACTIVATE := 4
    SW_SHOW := 5
    SW_MINIMIZE := 6
    SW_SHOWMINNOACTIVE := 7
    SW_SHOWNA := 8
    SW_RESTORE := 9

    ; Demonstrate different states
    states := [{
        name: "Hide", cmd: SW_HIDE }, {
            name: "Show (Restored)", cmd: SW_SHOWNORMAL }, {
                name: "Minimize", cmd: SW_SHOWMINIMIZED }, {
                    name: "Restore", cmd: SW_RESTORE }, {
                        name: "Maximize", cmd: SW_SHOWMAXIMIZED }, {
                            name: "Restore", cmd: SW_RESTORE
                        }
    ]

    for state in states {
        MsgBox("Changing window state to: " . state.name, "Info", "T2")

        DllCall("User32.dll\ShowWindow"
            , "Ptr", hwnd          ; hWnd
            , "Int", state.cmd     ; nCmdShow
            , "Int")               ; Return value: previous state

        Sleep(1500)
    }

    ; Check if window is visible, minimized, maximized
    isVisible := DllCall("User32.dll\IsWindowVisible", "Ptr", hwnd, "Int")
    isIconic := DllCall("User32.dll\IsIconic", "Ptr", hwnd, "Int")  ; Minimized
    isZoomed := DllCall("User32.dll\IsZoomed", "Ptr", hwnd, "Int")  ; Maximized

    MsgBox(Format("Window State:`nVisible: {}`nMinimized: {}`nMaximized: {}",
        isVisible ? "Yes" : "No",
        isIconic ? "Yes" : "No",
        isZoomed ? "Yes" : "No"), "Window State Info")
}

;==============================================================================
; EXAMPLE 5: Z-Order Manipulation (Always On Top)
;==============================================================================
; Shows how to set windows always on top using SetWindowPos

Example5_AlwaysOnTop() {
    hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")

    if (!hwnd) {
        Run("notepad.exe")
        Sleep(1000)
        hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")
    }

    ; Z-order constants
    HWND_TOP := 0
    HWND_BOTTOM := 1
    HWND_TOPMOST := -1
    HWND_NOTOPMOST := -2

    ; SetWindowPos flags
    SWP_NOMOVE := 0x0002
    SWP_NOSIZE := 0x0001
    SWP_SHOWWINDOW := 0x0040

    ; Set always on top
    MsgBox("Setting Notepad to Always On Top...`n`nTry opening other windows.", "Info")

    DllCall("User32.dll\SetWindowPos"
        , "Ptr", hwnd
        , "Ptr", HWND_TOPMOST      ; Always on top
        , "Int", 0
        , "Int", 0
        , "Int", 0
        , "Int", 0
        , "UInt", SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW
        , "Int")

    Sleep(3000)

    ; Remove always on top
    MsgBox("Removing Always On Top...", "Info")

    DllCall("User32.dll\SetWindowPos"
        , "Ptr", hwnd
        , "Ptr", HWND_NOTOPMOST    ; Remove always on top
        , "Int", 0
        , "Int", 0
        , "Int", 0
        , "Int", 0
        , "UInt", SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW
        , "Int")

    ; Send to bottom
    if MsgBox("Send window to bottom?", "Question", "YesNo") = "Yes" {
        DllCall("User32.dll\SetWindowPos"
            , "Ptr", hwnd
            , "Ptr", HWND_BOTTOM
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "UInt", SWP_NOMOVE | SWP_NOSIZE | SWP_SHOWWINDOW
            , "Int")
    }
}

;==============================================================================
; EXAMPLE 6: Window Styles and Extended Styles
;==============================================================================
; Demonstrates getting and modifying window styles

Example6_WindowStyles() {
    hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")

    if (!hwnd) {
        Run("notepad.exe")
        Sleep(1000)
        hwnd := DllCall("User32.dll\FindWindowW", "Str", "Notepad", "Ptr", 0, "Ptr")
    }

    ; GetWindowLong constants
    GWL_STYLE := -16
    GWL_EXSTYLE := -20

    ; Window style constants
    WS_CAPTION := 0x00C00000
    WS_THICKFRAME := 0x00040000
    WS_MINIMIZEBOX := 0x00020000
    WS_MAXIMIZEBOX := 0x00010000
    WS_SYSMENU := 0x00080000

    ; Get current style
    currentStyle := DllCall("User32.dll\GetWindowLongPtrW"
        , "Ptr", hwnd
        , "Int", GWL_STYLE
        , "Ptr")

    MsgBox(Format("Current Style: 0x{:X}", currentStyle), "Window Style")

    ; Remove caption (title bar)
    if MsgBox("Remove title bar?", "Question", "YesNo") = "Yes" {
        newStyle := currentStyle & ~WS_CAPTION

        DllCall("User32.dll\SetWindowLongPtrW"
            , "Ptr", hwnd
            , "Int", GWL_STYLE
            , "Ptr", newStyle
            , "Ptr")

        ; Force window to redraw
        SWP_FRAMECHANGED := 0x0020
        SWP_NOMOVE := 0x0002
        SWP_NOSIZE := 0x0001
        SWP_NOZORDER := 0x0004

        DllCall("User32.dll\SetWindowPos"
            , "Ptr", hwnd
            , "Ptr", 0
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "UInt", SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER
            , "Int")

        Sleep(3000)

        ; Restore
        DllCall("User32.dll\SetWindowLongPtrW", "Ptr", hwnd, "Int", GWL_STYLE, "Ptr", currentStyle, "Ptr")
        DllCall("User32.dll\SetWindowPos", "Ptr", hwnd, "Ptr", 0, "Int", 0, "Int", 0, "Int", 0, "Int", 0, "UInt", SWP_FRAMECHANGED | SWP_NOMOVE | SWP_NOSIZE | SWP_NOZORDER, "Int")
    }
}

;==============================================================================
; EXAMPLE 7: Advanced Window Operations
;==============================================================================
; Comprehensive window manipulation combining multiple techniques

Example7_AdvancedOperations() {
    ; Create a GUI for demonstration
    testGui := Gui("+AlwaysOnTop", "Test Window")
    testGui.Add("Text", "w300", "This is a test window for advanced operations.")
    testGui.Add("Button", "w300", "Click Me").OnEvent("Click", (*) => MsgBox("Button clicked!"))
    testGui.Show()

    hwnd := testGui.Hwnd

    ; Store original state
    origRect := Buffer(16, 0)
    DllCall("User32.dll\GetWindowRect", "Ptr", hwnd, "Ptr", origRect.Ptr, "Int")

    ; Flash window to get attention
    MsgBox("Flashing window...", "Info", "T2")

    FLASHW_ALL := 0x00000003
    FLASHW_TIMERNOFG := 0x0000000C

    flashInfo := Buffer(32, 0)
    NumPut("UInt", 32, flashInfo, 0)           ; cbSize
    NumPut("Ptr", hwnd, flashInfo, 8)         ; hwnd
    NumPut("UInt", FLASHW_ALL, flashInfo, 16) ; dwFlags
    NumPut("UInt", 5, flashInfo, 20)          ; uCount
    NumPut("UInt", 0, flashInfo, 24)          ; dwTimeout

    DllCall("User32.dll\FlashWindowEx", "Ptr", flashInfo.Ptr, "Int")

    Sleep(3000)

    ; Animate window
    MsgBox("Animating window...", "Info", "T2")

    AW_BLEND := 0x00080000
    AW_HIDE := 0x00010000
    AW_ACTIVATE := 0x00020000

    ; Fade out
    DllCall("User32.dll\AnimateWindow"
        , "Ptr", hwnd
        , "UInt", 500
        , "UInt", AW_HIDE | AW_BLEND
        , "Int")

    Sleep(1000)

    ; Fade in
    DllCall("User32.dll\AnimateWindow"
        , "Ptr", hwnd
        , "UInt", 500
        , "UInt", AW_ACTIVATE | AW_BLEND
        , "Int")

    ; Get parent/owner information
    parent := DllCall("User32.dll\GetParent", "Ptr", hwnd, "Ptr")
    owner := DllCall("User32.dll\GetWindow", "Ptr", hwnd, "UInt", 4, "Ptr")  ; GW_OWNER = 4

    MsgBox(Format("Parent: 0x{:X}`nOwner: 0x{:X}", parent, owner), "Window Relationships")

    if MsgBox("Close test window?", "Question", "YesNo") = "Yes"
        testGui.Destroy()
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
                        (
                        Window Manipulation DllCall Examples
                        =====================================

                        1. Finding Windows
                        2. Get Window Position/Size
                        3. Move and Resize Windows
                        4. Window Visibility and State
                        5. Z-Order (Always On Top)
                        6. Window Styles
                        7. Advanced Operations

                        Enter choice (1-7) or 0 to exit:
                        )"

    Loop {
        choice := InputBox(menu, "Window Manipulation Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_FindingWindows()
            case "2": Example2_GetWindowPosition()
            case "3": Example3_MoveResizeWindow()
            case "4": Example4_WindowVisibility()
            case "5": Example5_AlwaysOnTop()
            case "6": Example6_WindowStyles()
            case "7": Example7_AdvancedOperations()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
