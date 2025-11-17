#Requires AutoHotkey v2.0
/**
 * BuiltIn_DllCall_User32_01_MessageBox.ahk
 *
 * DESCRIPTION:
 * Demonstrates various MessageBox implementations using DllCall to the Windows API.
 * Shows how to create custom message boxes with different button combinations,
 * icons, default buttons, and modality options.
 *
 * FEATURES:
 * - Custom MessageBox variants using direct API calls
 * - Different button combinations (OK, Yes/No, Retry/Cancel, etc.)
 * - Icon types (Error, Warning, Information, Question)
 * - Modal and non-modal message boxes
 * - Return value handling for button clicks
 * - Unicode text support
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft MessageBoxW API Documentation
 * https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-messageboxw
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() function for Windows API integration
 * - Pointer handling with "Ptr" type
 * - String parameter passing with "Str" type
 * - Return value handling with "Int"
 * - Bitwise OR operations for combining flags
 *
 * LEARNING POINTS:
 * 1. How to call MessageBoxW API directly using DllCall
 * 2. Understanding Windows API parameter types and calling conventions
 * 3. Working with message box constants and flags
 * 4. Handling return values from Windows API calls
 * 5. Combining multiple flags using bitwise operations
 * 6. Unicode string handling in Windows API calls
 * 7. Creating custom message box behaviors not available in AHK's built-in MsgBox
 */

;==============================================================================
; EXAMPLE 1: Basic MessageBox with DllCall
;==============================================================================
; Demonstrates the simplest form of MessageBoxW API call

Example1_BasicMessageBox() {
    ; MessageBox button types
    MB_OK := 0x0
    MB_OKCANCEL := 0x1
    MB_YESNO := 0x4

    ; MessageBox icon types
    MB_ICONINFORMATION := 0x40

    ; Call MessageBoxW API
    ; Parameters:
    ; 1. hWnd (Ptr) - Handle to owner window (0 = no owner)
    ; 2. lpText (Str) - Message text
    ; 3. lpCaption (Str) - Title text
    ; 4. uType (UInt) - Button and icon type
    result := DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0                              ; hWnd
        , "Str", "This is a basic message box`nCalled directly via DllCall!"
        , "Str", "Basic MessageBox Example"
        , "UInt", MB_OK | MB_ICONINFORMATION    ; uType
        , "Int")                                 ; Return type

    ; Return values:
    ; IDOK = 1, IDCANCEL = 2, IDABORT = 3, IDRETRY = 4,
    ; IDIGNORE = 5, IDYES = 6, IDNO = 7
    MsgBox("User clicked: " . GetButtonName(result))
}

;==============================================================================
; EXAMPLE 2: MessageBox with Different Button Combinations
;==============================================================================
; Shows various button combinations available through the API

Example2_ButtonCombinations() {
    ; Button type constants
    MB_OK := 0x0
    MB_OKCANCEL := 0x1
    MB_ABORTRETRYIGNORE := 0x2
    MB_YESNOCANCEL := 0x3
    MB_YESNO := 0x4
    MB_RETRYCANCEL := 0x5
    MB_CANCELTRYCONTINUE := 0x6

    ; Icon constants
    MB_ICONWARNING := 0x30

    ; Test different button combinations
    buttonTypes := Map(
        "OK Only", MB_OK,
        "OK/Cancel", MB_OKCANCEL,
        "Abort/Retry/Ignore", MB_ABORTRETRYIGNORE,
        "Yes/No/Cancel", MB_YESNOCANCEL,
        "Yes/No", MB_YESNO,
        "Retry/Cancel", MB_RETRYCANCEL,
        "Cancel/Try Again/Continue", MB_CANCELTRYCONTINUE
    )

    results := []
    for typeName, typeValue in buttonTypes {
        result := DllCall("User32.dll\MessageBoxW"
            , "Ptr", 0
            , "Str", "Click any button to continue testing.`n`nTesting: " . typeName
            , "Str", "Button Type: " . typeName
            , "UInt", typeValue | MB_ICONWARNING
            , "Int")

        results.Push(Format("Type: {1}, Clicked: {2}", typeName, GetButtonName(result)))
    }

    ; Display summary
    summary := "Button Testing Results:`n`n"
    for item in results
        summary .= item . "`n"

    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", summary
        , "Str", "Test Results"
        , "UInt", 0x40  ; MB_ICONINFORMATION
        , "Int")
}

;==============================================================================
; EXAMPLE 3: MessageBox with Different Icons
;==============================================================================
; Demonstrates all available icon types

Example3_IconTypes() {
    ; Icon type constants
    MB_ICONERROR := 0x10        ; Stop-sign icon (red X)
    MB_ICONQUESTION := 0x20     ; Question-mark icon (deprecated)
    MB_ICONWARNING := 0x30      ; Exclamation-point icon
    MB_ICONINFORMATION := 0x40  ; Information icon (blue i)

    ; Button type
    MB_OK := 0x0

    ; Test each icon type
    icons := Map(
        "Error/Stop", MB_ICONERROR,
        "Question", MB_ICONQUESTION,
        "Warning/Exclamation", MB_ICONWARNING,
        "Information", MB_ICONINFORMATION
    )

    for iconName, iconValue in icons {
        DllCall("User32.dll\MessageBoxW"
            , "Ptr", 0
            , "Str", Format("This is the {} icon.`n`nIcon value: 0x{:X}", iconName, iconValue)
            , "Str", "Icon Type: " . iconName
            , "UInt", MB_OK | iconValue
            , "Int")
    }

    MsgBox("Icon demonstration complete!")
}

;==============================================================================
; EXAMPLE 4: MessageBox with Default Button Selection
;==============================================================================
; Shows how to set which button has focus by default

Example4_DefaultButton() {
    ; Button types
    MB_YESNOCANCEL := 0x3

    ; Icon
    MB_ICONQUESTION := 0x20

    ; Default button constants
    MB_DEFBUTTON1 := 0x0    ; First button is default
    MB_DEFBUTTON2 := 0x100  ; Second button is default
    MB_DEFBUTTON3 := 0x200  ; Third button is default
    MB_DEFBUTTON4 := 0x300  ; Fourth button is default

    ; Test with different default buttons
    defaults := Map(
        "First (Yes)", MB_DEFBUTTON1,
        "Second (No)", MB_DEFBUTTON2,
        "Third (Cancel)", MB_DEFBUTTON3
    )

    for defaultName, defaultValue in defaults {
        result := DllCall("User32.dll\MessageBoxW"
            , "Ptr", 0
            , "Str", Format("The {} button should be highlighted.`n`nTry pressing Enter to click the default button.", defaultName)
            , "Str", "Default Button: " . defaultName
            , "UInt", MB_YESNOCANCEL | MB_ICONQUESTION | defaultValue
            , "Int")

        MsgBox(Format("Default was '{}', you clicked: {}", defaultName, GetButtonName(result)))
    }
}

;==============================================================================
; EXAMPLE 5: MessageBox Modality Options
;==============================================================================
; Demonstrates system modal and task modal message boxes

Example5_ModalityOptions() {
    ; Button type
    MB_OK := 0x0

    ; Icon
    MB_ICONWARNING := 0x30

    ; Modality constants
    MB_APPLMODAL := 0x0      ; User must respond before continuing (default)
    MB_SYSTEMMODAL := 0x1000 ; System modal - all applications suspended
    MB_TASKMODAL := 0x2000   ; Task modal - similar to application modal

    ; Application Modal (default behavior)
    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This is an APPLICATION MODAL message box.`n`nYou must respond to this before continuing with this application,`nbut you can switch to other applications."
        , "Str", "Application Modal"
        , "UInt", MB_OK | MB_ICONWARNING | MB_APPLMODAL
        , "Int")

    ; Task Modal
    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This is a TASK MODAL message box.`n`nSimilar to application modal, but disables all top-level windows`nbelonging to the calling thread."
        , "Str", "Task Modal"
        , "UInt", MB_OK | MB_ICONWARNING | MB_TASKMODAL
        , "Int")

    ; System Modal (use with caution!)
    ; Note: Modern Windows may not fully honor system modal
    if MsgBox("Do you want to test SYSTEM MODAL?`n`nThis will attempt to block all applications!`n`n(Not recommended on modern Windows)", "Warning", "YesNo") = "Yes" {
        DllCall("User32.dll\MessageBoxW"
            , "Ptr", 0
            , "Str", "This is a SYSTEM MODAL message box.`n`nOn older Windows versions, this would suspend all applications.`nModern Windows may not fully honor this flag."
            , "Str", "System Modal (Deprecated)"
            , "UInt", MB_OK | MB_ICONWARNING | MB_SYSTEMMODAL
            , "Int")
    }
}

;==============================================================================
; EXAMPLE 6: MessageBox with Additional Options
;==============================================================================
; Shows advanced options like right-aligned text, RTL reading, foreground, etc.

Example6_AdvancedOptions() {
    ; Button and icon
    MB_OK := 0x0
    MB_ICONINFORMATION := 0x40

    ; Advanced option constants
    MB_RIGHT := 0x80000           ; Right-justify text
    MB_RTLREADING := 0x100000     ; Right-to-left reading order
    MB_SETFOREGROUND := 0x10000   ; Message box becomes foreground window
    MB_TOPMOST := 0x40000         ; Always on top
    MB_SERVICE_NOTIFICATION := 0x200000  ; Display on desktop (no owner)

    ; Right-aligned text
    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This text should be right-aligned.`n`nNotice how it's justified to the right edge."
        , "Str", "Right-Aligned Text"
        , "UInt", MB_OK | MB_ICONINFORMATION | MB_RIGHT
        , "Int")

    ; Always on top (topmost)
    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This message box is set to be TOPMOST.`n`nIt should stay on top of other windows.`n`n(Try opening other windows to test)"
        , "Str", "Always On Top"
        , "UInt", MB_OK | MB_ICONINFORMATION | MB_TOPMOST
        , "Int")

    ; Set foreground (ensures message box gets focus)
    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This message box uses MB_SETFOREGROUND.`n`nIt ensures the message box window is brought to the foreground."
        , "Str", "Foreground Window"
        , "UInt", MB_OK | MB_ICONINFORMATION | MB_SETFOREGROUND
        , "Int")

    ; Combined options
    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This message box combines multiple options:`n- Right-aligned text`n- Always on top`n- Foreground window"
        , "Str", "Combined Options"
        , "UInt", MB_OK | MB_ICONINFORMATION | MB_RIGHT | MB_TOPMOST | MB_SETFOREGROUND
        , "Int")
}

;==============================================================================
; EXAMPLE 7: Advanced MessageBox with Timeout and Custom Handling
;==============================================================================
; Creates a message box with custom behavior using MessageBoxTimeoutW

Example7_AdvancedMessageBox() {
    ; Standard constants
    MB_YESNO := 0x4
    MB_ICONQUESTION := 0x20
    MB_DEFBUTTON2 := 0x100

    ; Regular MessageBox with all options combined
    result := DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", "This is a comprehensive example combining:`n`n" .
                 "• Yes/No buttons`n" .
                 "• Question icon`n" .
                 "• Second button (No) as default`n" .
                 "• Always on top`n" .
                 "• Foreground window`n`n" .
                 "Click Yes or No to continue."
        , "Str", "Comprehensive MessageBox Example"
        , "UInt", MB_YESNO | MB_ICONQUESTION | MB_DEFBUTTON2 | 0x40000 | 0x10000
        , "Int")

    ; Report the result
    response := (result = 6) ? "Yes (IDYES=6)" : (result = 7) ? "No (IDNO=7)" : "Unknown"

    DllCall("User32.dll\MessageBoxW"
        , "Ptr", 0
        , "Str", Format("You clicked: {}`n`nReturn value: {}", response, result)
        , "Str", "User Response"
        , "UInt", 0x40  ; MB_ICONINFORMATION
        , "Int")

    ; Demonstrate error handling
    try {
        ; Attempt to call with invalid parameters (for demonstration)
        badResult := DllCall("User32.dll\MessageBoxW"
            , "Ptr", 0
            , "Str", "Testing error handling..."
            , "Str", "Error Handling Test"
            , "UInt", 0x0
            , "Int")
    } catch as err {
        MsgBox("Error caught: " . err.Message, "DllCall Error", "IconX")
    }

    MsgBox("Advanced MessageBox demonstrations complete!", "Complete", "Iconi")
}

;==============================================================================
; HELPER FUNCTIONS
;==============================================================================

/**
 * Converts MessageBox return value to button name
 * @param {Integer} value - Return value from MessageBox
 * @returns {String} - Name of the button clicked
 */
GetButtonName(value) {
    static buttons := Map(
        1, "OK (IDOK)",
        2, "Cancel (IDCANCEL)",
        3, "Abort (IDABORT)",
        4, "Retry (IDRETRY)",
        5, "Ignore (IDIGNORE)",
        6, "Yes (IDYES)",
        7, "No (IDNO)",
        10, "Try Again (IDTRYAGAIN)",
        11, "Continue (IDCONTINUE)"
    )

    return buttons.Has(value) ? buttons[value] : "Unknown (" . value . ")"
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    MessageBox DllCall Examples
    ===========================

    1. Basic MessageBox
    2. Button Combinations
    3. Icon Types
    4. Default Button Selection
    5. Modality Options
    6. Advanced Options
    7. Comprehensive Example

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "MessageBox Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_BasicMessageBox()
            case "2": Example2_ButtonCombinations()
            case "3": Example3_IconTypes()
            case "4": Example4_DefaultButton()
            case "5": Example5_ModalityOptions()
            case "6": Example6_AdvancedOptions()
            case "7": Example7_AdvancedMessageBox()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
