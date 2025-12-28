#Requires AutoHotkey v2.0

/**
 * BuiltIn_DllCall_Kernel32_05_Console.ahk
 * 
 * DESCRIPTION:
 * Demonstrates console operations using Windows API through DllCall.
 * Shows how to allocate console, read/write console, manipulate console
 * properties, and work with console buffers.
 * 
 * FEATURES:
 * - Allocating and freeing console
 * - Reading and writing console output
 * - Console screen buffer manipulation
 * - Setting console title and properties
 * - Console cursor control
 * - Console color and attributes
 * - Console input modes
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Console Functions
 * https://docs.microsoft.com/en-us/windows/console/console-functions
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with console functions
 * - Console handle management
 * - CONSOLE_SCREEN_BUFFER_INFO structure
 * - COORD and SMALL_RECT structures
 * - Character attributes
 * 
 * LEARNING POINTS:
 * 1. Creating and managing console windows
 * 2. Writing colored text to console
 * 3. Reading console input
 * 4. Manipulating cursor position
 * 5. Changing console buffer size
 * 6. Setting console window properties
 * 7. Working with console attributes
 */

;==============================================================================
; EXAMPLE 1: Console Allocation and Basic Output
;==============================================================================
Example1_ConsoleBasics() {
    ; Allocate a console
    success := DllCall("Kernel32.dll\AllocConsole", "Int")

    if (!success) {
        ; Console might already exist
        MsgBox("Console may already exist", "Info")
    }

    ; Get standard output handle
    STD_OUTPUT_HANDLE := -11

    hConsole := DllCall("Kernel32.dll\GetStdHandle"
        , "Int", STD_OUTPUT_HANDLE
        , "Ptr")

    if (hConsole != -1 && hConsole != 0) {
        ; Write text to console
        text := "Hello from Windows Console API!`r`n"
        textBuffer := Buffer(StrPut(text, "CP0"), 0)
        StrPut(text, textBuffer.Ptr, "CP0")

        written := Buffer(4, 0)
        DllCall("Kernel32.dll\WriteConsoleA"
            , "Ptr", hConsole
            , "Ptr", textBuffer.Ptr
            , "UInt", StrLen(text)
            , "Ptr", written.Ptr
            , "Ptr", 0
            , "Int")

        charsWritten := NumGet(written, 0, "UInt")

        ; Write more lines
        Loop 5 {
            line := Format("Line {}`r`n", A_Index)
            lineBuffer := Buffer(StrPut(line, "CP0"), 0)
            StrPut(line, lineBuffer.Ptr, "CP0")

            DllCall("Kernel32.dll\WriteConsoleA"
                , "Ptr", hConsole
                , "Ptr", lineBuffer.Ptr
                , "UInt", StrLen(line)
                , "Ptr", written.Ptr
                , "Ptr", 0
                , "Int")
        }

        MsgBox(Format("Wrote {} characters to console.`n`nCheck the console window!", charsWritten), "Success")
    }

    ; Wait before cleanup
    if MsgBox("Keep console open?", "Question", "YesNo") = "No" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

;==============================================================================
; EXAMPLE 2: Console Colors and Attributes
;==============================================================================
Example2_ConsoleColors() {
    DllCall("Kernel32.dll\AllocConsole", "Int")

    STD_OUTPUT_HANDLE := -11
    hConsole := DllCall("Kernel32.dll\GetStdHandle", "Int", STD_OUTPUT_HANDLE, "Ptr")

    ; Color constants (foreground)
    FOREGROUND_BLUE := 0x0001
    FOREGROUND_GREEN := 0x0002
    FOREGROUND_RED := 0x0004
    FOREGROUND_INTENSITY := 0x0008

    ; Color constants (background)
    BACKGROUND_BLUE := 0x0010
    BACKGROUND_GREEN := 0x0020
    BACKGROUND_RED := 0x0040
    BACKGROUND_INTENSITY := 0x0080

    ; Define colors
    colors := [{
        name: "Red", attr: FOREGROUND_RED | FOREGROUND_INTENSITY }, {
            name: "Green", attr: FOREGROUND_GREEN | FOREGROUND_INTENSITY }, {
                name: "Blue", attr: FOREGROUND_BLUE | FOREGROUND_INTENSITY }, {
                    name: "Yellow", attr: FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY }, {
                        name: "Cyan", attr: FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY }, {
                            name: "Magenta", attr: FOREGROUND_RED | FOREGROUND_BLUE | FOREGROUND_INTENSITY }, {
                                name: "White", attr: FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE | FOREGROUND_INTENSITY
                            }
    ]

    written := Buffer(4, 0)

    for color in colors {
        ; Set console color
        DllCall("Kernel32.dll\SetConsoleTextAttribute"
            , "Ptr", hConsole
            , "UShort", color.attr
            , "Int")

        ; Write colored text
        text := color.name . " Text`r`n"
        textBuffer := Buffer(StrPut(text, "CP0"), 0)
        StrPut(text, textBuffer.Ptr, "CP0")

        DllCall("Kernel32.dll\WriteConsoleA"
            , "Ptr", hConsole
            , "Ptr", textBuffer.Ptr
            , "UInt", StrLen(text)
            , "Ptr", written.Ptr
            , "Ptr", 0
            , "Int")
    }

    ; Reset to default (white on black)
    DllCall("Kernel32.dll\SetConsoleTextAttribute"
        , "Ptr", hConsole
        , "UShort", FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE
        , "Int")

    MsgBox("Check the console for colored text!", "Success")

    if MsgBox("Close console?", "Question", "YesNo") = "Yes" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

;==============================================================================
; EXAMPLE 3: Console Cursor Control
;==============================================================================
Example3_ConsoleCursor() {
    DllCall("Kernel32.dll\AllocConsole", "Int")

    STD_OUTPUT_HANDLE := -11
    hConsole := DllCall("Kernel32.dll\GetStdHandle", "Int", STD_OUTPUT_HANDLE, "Ptr")

    ; COORD structure (4 bytes: X (short), Y (short))
    positions := [{
        x: 0, y: 0 }, {
            x: 10, y: 5 }, {
                x: 20, y: 10 }, {
                    x: 30, y: 3 }, {
                        x: 5, y: 15
                    }
    ]

    written := Buffer(4, 0)

    for pos in positions {
        ; Create COORD structure
        coord := Buffer(4, 0)
        NumPut("Short", pos.x, coord, 0)
        NumPut("Short", pos.y, coord, 2)

        ; Set cursor position
        DllCall("Kernel32.dll\SetConsoleCursorPosition"
            , "Ptr", hConsole
            , "UInt", NumGet(coord, 0, "UInt")  ; Pass COORD as UInt
            , "Int")

        ; Write at this position
        text := Format("*At ({}, {})", pos.x, pos.y)
        textBuffer := Buffer(StrPut(text, "CP0"), 0)
        StrPut(text, textBuffer.Ptr, "CP0")

        DllCall("Kernel32.dll\WriteConsoleA"
            , "Ptr", hConsole
            , "Ptr", textBuffer.Ptr
            , "UInt", StrLen(text)
            , "Ptr", written.Ptr
            , "Ptr", 0
            , "Int")

        Sleep(300)
    }

    ; Get cursor info
    cursorInfo := Buffer(8, 0)  ; CONSOLE_CURSOR_INFO: size (4) + visible (4)
    DllCall("Kernel32.dll\GetConsoleCursorInfo"
        , "Ptr", hConsole
        , "Ptr", cursorInfo.Ptr
        , "Int")

    size := NumGet(cursorInfo, 0, "UInt")
    visible := NumGet(cursorInfo, 4, "Int")

    ; Move to bottom and show info
    coord := Buffer(4, 0)
    NumPut("Short", 0, coord, 0)
    NumPut("Short", 20, coord, 2)
    DllCall("Kernel32.dll\SetConsoleCursorPosition", "Ptr", hConsole, "UInt", NumGet(coord, 0, "UInt"), "Int")

    info := Format("Cursor Size: {}%, Visible: {}", size, visible ? "Yes" : "No")
    infoBuf := Buffer(StrPut(info, "CP0"), 0)
    StrPut(info, infoBuf.Ptr, "CP0")
    DllCall("Kernel32.dll\WriteConsoleA", "Ptr", hConsole, "Ptr", infoBuf.Ptr, "UInt", StrLen(info), "Ptr", written.Ptr, "Ptr", 0, "Int")

    MsgBox("Cursor positioning complete!", "Success")

    if MsgBox("Close console?", "Question", "YesNo") = "Yes" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

;==============================================================================
; EXAMPLE 4: Console Screen Buffer Info
;==============================================================================
Example4_ScreenBufferInfo() {
    DllCall("Kernel32.dll\AllocConsole", "Int")

    STD_OUTPUT_HANDLE := -11
    hConsole := DllCall("Kernel32.dll\GetStdHandle", "Int", STD_OUTPUT_HANDLE, "Ptr")

    ; CONSOLE_SCREEN_BUFFER_INFO structure (22 bytes)
    bufferInfo := Buffer(22, 0)

    success := DllCall("Kernel32.dll\GetConsoleScreenBufferInfo"
        , "Ptr", hConsole
        , "Ptr", bufferInfo.Ptr
        , "Int")

    if (success) {
        ; Extract fields
        sizeX := NumGet(bufferInfo, 0, "Short")        ; dwSize.X
        sizeY := NumGet(bufferInfo, 2, "Short")        ; dwSize.Y
        cursorX := NumGet(bufferInfo, 4, "Short")      ; dwCursorPosition.X
        cursorY := NumGet(bufferInfo, 6, "Short")      ; dwCursorPosition.Y
        attributes := NumGet(bufferInfo, 8, "UShort")  ; wAttributes
        windowLeft := NumGet(bufferInfo, 10, "Short")  ; srWindow.Left
        windowTop := NumGet(bufferInfo, 12, "Short")   ; srWindow.Top
        windowRight := NumGet(bufferInfo, 14, "Short") ; srWindow.Right
        windowBottom := NumGet(bufferInfo, 16, "Short"); srWindow.Bottom
        maxX := NumGet(bufferInfo, 18, "Short")        ; dwMaximumWindowSize.X
        maxY := NumGet(bufferInfo, 20, "Short")        ; dwMaximumWindowSize.Y

        info := Format("
                                                (
                                                Console Screen Buffer Info:

                                                Buffer Size: {} x {}
                                                Cursor Position: ({}, {})
                                                Attributes: 0x{:X}
                                                Window: ({}, {}) to ({}, {})
                                                Max Window Size: {} x {}
                                                )", sizeX, sizeY, cursorX, cursorY, attributes,
            windowLeft, windowTop, windowRight, windowBottom,
            maxX, maxY)

        MsgBox(info, "Buffer Info")
    }

    if MsgBox("Close console?", "Question", "YesNo") = "Yes" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

;==============================================================================
; EXAMPLE 5: Console Title and Mode
;==============================================================================
Example5_ConsoleTitleMode() {
    DllCall("Kernel32.dll\AllocConsole", "Int")

    ; Set console title
    newTitle := "My Custom Console Window - " . A_Now
    DllCall("Kernel32.dll\SetConsoleTitleW"
        , "Str", newTitle
        , "Int")

    MsgBox("Console title set!`n`n" . newTitle, "Success", "T2")

    ; Get console title back
    titleBuf := Buffer(520, 0)
    DllCall("Kernel32.dll\GetConsoleTitleW"
        , "Ptr", titleBuf.Ptr
        , "UInt", 260
        , "UInt")

    retrievedTitle := StrGet(titleBuf.Ptr, "UTF-16")

    MsgBox("Retrieved title: " . retrievedTitle, "Title")

    ; Get console mode
    STD_INPUT_HANDLE := -10
    hInput := DllCall("Kernel32.dll\GetStdHandle", "Int", STD_INPUT_HANDLE, "Ptr")

    mode := Buffer(4, 0)
    DllCall("Kernel32.dll\GetConsoleMode"
        , "Ptr", hInput
        , "Ptr", mode.Ptr
        , "Int")

    currentMode := NumGet(mode, 0, "UInt")

    ; Console input mode flags
    ENABLE_ECHO_INPUT := 0x0004
    ENABLE_LINE_INPUT := 0x0002
    ENABLE_MOUSE_INPUT := 0x0010
    ENABLE_WINDOW_INPUT := 0x0008

    modeDesc := []
    if (currentMode & ENABLE_ECHO_INPUT)
        modeDesc.Push("Echo")
    if (currentMode & ENABLE_LINE_INPUT)
        modeDesc.Push("Line Input")
    if (currentMode & ENABLE_MOUSE_INPUT)
        modeDesc.Push("Mouse")
    if (currentMode & ENABLE_WINDOW_INPUT)
        modeDesc.Push("Window Events")

    MsgBox(Format("Console Mode: 0x{:X}`n`n{}", currentMode, StrJoin(modeDesc, ", ")), "Mode")

    if MsgBox("Close console?", "Question", "YesNo") = "Yes" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

; Helper function
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
; EXAMPLE 6: Console Clearing and Filling
;==============================================================================
Example6_ConsoleClear() {
    DllCall("Kernel32.dll\AllocConsole", "Int")

    STD_OUTPUT_HANDLE := -11
    hConsole := DllCall("Kernel32.dll\GetStdHandle", "Int", STD_OUTPUT_HANDLE, "Ptr")

    ; Write some text first
    written := Buffer(4, 0)
    Loop 20 {
        text := Format("Line {} - This will be cleared`r`n", A_Index)
        textBuffer := Buffer(StrPut(text, "CP0"), 0)
        StrPut(text, textBuffer.Ptr, "CP0")

        DllCall("Kernel32.dll\WriteConsoleA"
            , "Ptr", hConsole
            , "Ptr", textBuffer.Ptr
            , "UInt", StrLen(text)
            , "Ptr", written.Ptr
            , "Ptr", 0
            , "Int")
    }

    MsgBox("Text written. Now clearing...", "Info", "T2")

    ; Get buffer size
    bufferInfo := Buffer(22, 0)
    DllCall("Kernel32.dll\GetConsoleScreenBufferInfo", "Ptr", hConsole, "Ptr", bufferInfo.Ptr, "Int")

    sizeX := NumGet(bufferInfo, 0, "Short")
    sizeY := NumGet(bufferInfo, 2, "Short")
    cellCount := sizeX * sizeY

    ; Fill console with spaces
    coord := Buffer(4, 0)  ; COORD {0, 0}
    NumPut("Short", 0, coord, 0)
    NumPut("Short", 0, coord, 2)

    charsWrittenBuf := Buffer(4, 0)
    DllCall("Kernel32.dll\FillConsoleOutputCharacterW"
        , "Ptr", hConsole
        , "UShort", 32          ; Space character
        , "UInt", cellCount
        , "UInt", NumGet(coord, 0, "UInt")
        , "Ptr", charsWrittenBuf.Ptr
        , "Int")

    ; Reset cursor to 0,0
    DllCall("Kernel32.dll\SetConsoleCursorPosition", "Ptr", hConsole, "UInt", NumGet(coord, 0, "UInt"), "Int")

    ; Write new text
    text := "Console cleared and reset!`r`n"
    textBuffer := Buffer(StrPut(text, "CP0"), 0)
    StrPut(text, textBuffer.Ptr, "CP0")
    DllCall("Kernel32.dll\WriteConsoleA", "Ptr", hConsole, "Ptr", textBuffer.Ptr, "UInt", StrLen(text), "Ptr", written.Ptr, "Ptr", 0, "Int")

    MsgBox("Console cleared!", "Success")

    if MsgBox("Close console?", "Question", "YesNo") = "Yes" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

;==============================================================================
; EXAMPLE 7: Advanced Console Operations
;==============================================================================
Example7_AdvancedConsole() {
    DllCall("Kernel32.dll\AllocConsole", "Int")

    STD_OUTPUT_HANDLE := -11
    hConsole := DllCall("Kernel32.dll\GetStdHandle", "Int", STD_OUTPUT_HANDLE, "Ptr")

    ; Set console buffer size larger than window
    newSize := Buffer(4, 0)
    NumPut("Short", 120, newSize, 0)  ; X
    NumPut("Short", 300, newSize, 2)  ; Y

    success := DllCall("Kernel32.dll\SetConsoleScreenBufferSize"
        , "Ptr", hConsole
        , "UInt", NumGet(newSize, 0, "UInt")
        , "Int")

    if (success)
        MsgBox("Console buffer size set to 120x300", "Success")

    ; Set console window size
    ; SMALL_RECT structure: left, top, right, bottom
    windowRect := Buffer(8, 0)
    NumPut("Short", 0, windowRect, 0)    ; left
    NumPut("Short", 0, windowRect, 2)    ; top
    NumPut("Short", 79, windowRect, 4)   ; right (80 columns - 1)
    NumPut("Short", 24, windowRect, 6)   ; bottom (25 rows - 1)

    success := DllCall("Kernel32.dll\SetConsoleWindowInfo"
        , "Ptr", hConsole
        , "Int", 1              ; bAbsolute (TRUE)
        , "Ptr", windowRect.Ptr
        , "Int")

    if (success)
        MsgBox("Console window size set to 80x25", "Success")

    ; Write a pattern
    written := Buffer(4, 0)
    FOREGROUND_GREEN := 0x0002
    FOREGROUND_INTENSITY := 0x0008

    DllCall("Kernel32.dll\SetConsoleTextAttribute"
        , "Ptr", hConsole
        , "UShort", FOREGROUND_GREEN | FOREGROUND_INTENSITY
        , "Int")

    Loop 50 {
        text := Format("Row {} - Sample text with scrolling`r`n", A_Index)
        textBuffer := Buffer(StrPut(text, "CP0"), 0)
        StrPut(text, textBuffer.Ptr, "CP0")

        DllCall("Kernel32.dll\WriteConsoleA"
            , "Ptr", hConsole
            , "Ptr", textBuffer.Ptr
            , "UInt", StrLen(text)
            , "Ptr", written.Ptr
            , "Ptr", 0
            , "Int")
    }

    MsgBox("Advanced console operations complete!`n`nBuffer is larger than window, allowing scrolling.", "Success")

    if MsgBox("Close console?", "Question", "YesNo") = "Yes" {
        DllCall("Kernel32.dll\FreeConsole", "Int")
    }
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
                                            (
                                            Console Operations DllCall Examples
                                            ====================================

                                            1. Console Basics
                                            2. Console Colors
                                            3. Cursor Control
                                            4. Screen Buffer Info
                                            5. Console Title and Mode
                                            6. Console Clear/Fill
                                            7. Advanced Console Operations

                                            Enter choice (1-7) or 0 to exit:
                                            )"

    Loop {
        choice := InputBox(menu, "Console Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_ConsoleBasics()
            case "2": Example2_ConsoleColors()
            case "3": Example3_ConsoleCursor()
            case "4": Example4_ScreenBufferInfo()
            case "5": Example5_ConsoleTitleMode()
            case "6": Example6_ConsoleClear()
            case "7": Example7_AdvancedConsole()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
