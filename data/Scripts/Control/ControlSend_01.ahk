#Requires AutoHotkey v2.0

/**
* ============================================================================
* ControlSend_01 - Basic Control Send to Controls
* ============================================================================
*
* Demonstrates basic ControlSend functionality for sending keystrokes
* directly to controls without requiring window focus.
*
* @description
* ControlSend sends keystrokes directly to a control within a window,
* enabling background automation and multi-window operations without
* disrupting user interaction.
*
* Key Features:
* - Send text to controls in background
* - No window activation required
* - Support for special keys and modifiers
* - Control-specific targeting
* - Reliable text input automation
*
* @syntax ControlSend Keys, Control, WinTitle, WinText
*
* @author AutoHotkey Community
* @version 1.0.0
* @since 2024-01-16
*
* @example
* ; Send text to Notepad
* ControlSend "Hello World", "Edit1", "Untitled - Notepad"
*
* @see https://www.autohotkey.com/docs/v2/lib/ControlSend.htm
*/

; ============================================================================
; Example 1: Basic Text Sending
; ============================================================================

/**
* @function Example1_BasicSend
* @description Demonstrates basic ControlSend text input
* Shows how to send simple text to controls
*/
Example1_BasicSend() {
    MsgBox("Example 1: Basic Text Sending`n`n" .
    "Send text to controls using ControlSend.",
    "Basic Send", "OK Icon!")

    ; Launch Notepad
    Run("notepad.exe")
    WinWait("Untitled - Notepad", , 5)

    if !WinExist("Untitled - Notepad") {
        MsgBox("Failed to launch Notepad!", "Error", "OK IconX")
        return
    }

    Sleep(500)

    ; Send basic text
    MsgBox("Sending basic text to Notepad...", "Info", "OK Icon! T2")

    try {
        text := "Hello from ControlSend!`n`n"
        text .= "This text was sent directly to the Edit control.`n"
        text .= "The window doesn't need to be active!`n`n"
        text .= "Current time: " . FormatTime(, "yyyy-MM-dd HH:mm:ss")

        ControlSend(text, "Edit1", "Untitled - Notepad")

        MsgBox("Text sent successfully!", "Success", "OK Icon!")

    } catch Error as err {
        MsgBox("Error sending text: " . err.Message, "Error", "OK IconX")
    }

    ; Ask to close
    result := MsgBox("Close Notepad?", "Cleanup", "YesNo Icon?")
    if (result = "Yes") {
        WinClose("Untitled - Notepad")
        Sleep(200)
        if WinExist("Notepad") {
            ControlClick("Button2", "Notepad")  ; Don't Save
        }
    }
}

; ============================================================================
; Example 2: Background Sending to Multiple Windows
; ============================================================================

/**
* @function Example2_MultiWindow
* @description Send text to multiple windows in background
* Demonstrates ControlSend's ability to work without activation
*/
Example2_MultiWindow() {
    MsgBox("Example 2: Multiple Window Sending`n`n" .
    "Send text to multiple Notepad windows in background.",
    "Multi-Window", "OK Icon!")

    ; Launch multiple Notepad instances
    windows := []
    Loop 3 {
        Run("notepad.exe")
        Sleep(500)

        winTitle := "Untitled - Notepad"
        if WinWait(winTitle, , 5) {
            windows.Push({
                title: winTitle,
                hwnd: WinGetID(winTitle),
                number: A_Index
            })
        }
    }

    if windows.Length = 0 {
        MsgBox("Failed to launch Notepad windows!", "Error", "OK IconX")
        return
    }

    MsgBox("Launched " . windows.Length . " Notepad windows.`n`n" .
    "Now sending different text to each...",
    "Info", "OK Icon! T2")

    ; Send different text to each window
    for win in windows {
        try {
            text := "Window #" . win.number . "`n"
            text .= "================`n`n"
            text .= "HWND: " . win.hwnd . "`n"
            text .= "Time: " . FormatTime(, "HH:mm:ss") . "`n`n"
            text .= "This is unique content for window " . win.number . "!`n"

            ; Send to specific window using ahk_id
            ControlSend(text, "Edit1", "ahk_id " . win.hwnd)

            Sleep(300)

        } catch Error as err {
            MsgBox("Error sending to window " . win.number . ": " . err.Message,
            "Error", "OK IconX")
        }
    }

    MsgBox("Text sent to all " . windows.Length . " windows!", "Complete", "OK Icon!")

    ; Cleanup
    result := MsgBox("Close all Notepad windows?", "Cleanup", "YesNo Icon?")
    if (result = "Yes") {
        for win in windows {
            try {
                WinClose("ahk_id " . win.hwnd)
                Sleep(100)
                if WinExist("ahk_id " . win.hwnd) {
                    ControlClick("Button2", "ahk_id " . win.hwnd)
                }
            }
        }
    }
}

; ============================================================================
; Example 3: Form Filling Automation
; ============================================================================

/**
* @function Example3_FormFilling
* @description Automate form filling using ControlSend
* Shows practical use case for data entry automation
*/
Example3_FormFilling() {
    MsgBox("Example 3: Form Filling Automation`n`n" .
    "Automatically fill forms using ControlSend.",
    "Form Filling", "OK Icon!")

    ; Create a sample form
    formGui := Gui(, "Registration Form")
    formGui.Add("Text", "w400", "User Registration Form")

    formGui.Add("Text", "w400 y+20", "First Name:")
    firstNameEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Last Name:")
    lastNameEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Email:")
    emailEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Phone:")
    phoneEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Address:")
    addressEdit := formGui.Add("Edit", "w400 h60 Multi")

    formGui.Add("Text", "w400 y+10", "Comments:")
    commentsEdit := formGui.Add("Edit", "w400 h80 Multi")

    submitBtn := formGui.Add("Button", "w190 y+20", "Submit")
    submitBtn.OnEvent("Click", (*) => SubmitForm())

    clearBtn := formGui.Add("Button", "w190 x+20", "Clear")
    clearBtn.OnEvent("Click", (*) => ClearForm())

    formGui.Show("x50 y50")

    ; Create control panel
    controlGui := Gui("+AlwaysOnTop", "Auto-Fill Control")
    controlGui.Add("Text", "w350", "Form Auto-Fill Options:")

    ; Sample data sets
    sampleData := [
    {
        firstName: "John",
        lastName: "Doe",
        email: "john.doe@example.com",
        phone: "(555) 123-4567",
        address: "123 Main St`nApt 4B`nNew York, NY 10001",
        comments: "Please contact me via email.`nBest time: 9 AM - 5 PM"
    },
    {
        firstName: "Jane",
        lastName: "Smith",
        email: "jane.smith@example.com",
        phone: "(555) 987-6543",
        address: "456 Oak Avenue`nSuite 200`nLos Angeles, CA 90001",
        comments: "Interested in premium membership.`nRefer to account #12345"
    },
    {
        firstName: "Bob",
        lastName: "Johnson",
        email: "bob.j@example.com",
        phone: "(555) 456-7890",
        address: "789 Pine Road`nChicago, IL 60601",
        comments: "Urgent: Need response within 24 hours."
    }
    ]

    controlGui.Add("Text", "w350 y+20", "Select sample data to auto-fill:")

    sample1Btn := controlGui.Add("Button", "w340 y+10", "Sample 1: John Doe")
    sample1Btn.OnEvent("Click", (*) => FillForm(sampleData[1]))

    sample2Btn := controlGui.Add("Button", "w340 y+10", "Sample 2: Jane Smith")
    sample2Btn.OnEvent("Click", (*) => FillForm(sampleData[2]))

    sample3Btn := controlGui.Add("Button", "w340 y+10", "Sample 3: Bob Johnson")
    sample3Btn.OnEvent("Click", (*) => FillForm(sampleData[3]))

    controlGui.Add("Text", "w350 y+20", "Auto-Fill Log:")
    logEdit := controlGui.Add("Edit", "w340 h200 ReadOnly", "")

    closeBtn := controlGui.Add("Button", "w340 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => CloseDemo())

    controlGui.Show("x470 y50")

    ; Fill form function
    FillForm(data) {
        LogAction("Starting auto-fill...")

        try {
            winTitle := "Registration Form"

            ; Clear existing content first
            LogAction("Clearing fields...")
            ControlSetText("", "Edit1", winTitle)
            ControlSetText("", "Edit2", winTitle)
            ControlSetText("", "Edit3", winTitle)
            ControlSetText("", "Edit4", winTitle)
            ControlSetText("", "Edit5", winTitle)
            ControlSetText("", "Edit6", winTitle)

            Sleep(200)

            ; Fill First Name
            LogAction("Filling first name: " . data.firstName)
            ControlSend(data.firstName, "Edit1", winTitle)
            Sleep(100)

            ; Fill Last Name
            LogAction("Filling last name: " . data.lastName)
            ControlSend(data.lastName, "Edit2", winTitle)
            Sleep(100)

            ; Fill Email
            LogAction("Filling email: " . data.email)
            ControlSend(data.email, "Edit3", winTitle)
            Sleep(100)

            ; Fill Phone
            LogAction("Filling phone: " . data.phone)
            ControlSend(data.phone, "Edit4", winTitle)
            Sleep(100)

            ; Fill Address (multi-line)
            LogAction("Filling address...")
            ControlSend(data.address, "Edit5", winTitle)
            Sleep(100)

            ; Fill Comments (multi-line)
            LogAction("Filling comments...")
            ControlSend(data.comments, "Edit6", winTitle)

            LogAction("✓ Form filled successfully!`n")

        } catch Error as err {
            LogAction("✗ Error: " . err.Message . "`n")
        }
    }

    ; Log action
    LogAction(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        logEdit.Value .= timestamp . " - " . msg . "`n"
        SendMessage(0x115, 7, 0, logEdit.Hwnd)
    }

    ; Submit form handler
    SubmitForm() {
        data := "Form Submitted:`n`n"
        data .= "First Name: " . firstNameEdit.Value . "`n"
        data .= "Last Name: " . lastNameEdit.Value . "`n"
        data .= "Email: " . emailEdit.Value . "`n"
        data .= "Phone: " . phoneEdit.Value . "`n"
        data .= "Address: " . StrReplace(addressEdit.Value, "`n", " ") . "`n"
        data .= "Comments: " . StrReplace(commentsEdit.Value, "`n", " ")

        MsgBox(data, "Form Submitted", "OK Icon!")
    }

    ; Clear form handler
    ClearForm() {
        firstNameEdit.Value := ""
        lastNameEdit.Value := ""
        emailEdit.Value := ""
        phoneEdit.Value := ""
        addressEdit.Value := ""
        commentsEdit.Value := ""
    }

    ; Close demo
    CloseDemo() {
        if WinExist("Registration Form")
        formGui.Destroy()
        if WinExist("Auto-Fill Control")
        controlGui.Destroy()
    }

    MsgBox("Form filling demo started!`n`n" .
    "Use the control panel to auto-fill the registration form.",
    "Info", "OK Icon! T3")
}

; ============================================================================
; Example 4: Typing Simulation with Delays
; ============================================================================

/**
* @function Example4_TypingSimulation
* @description Simulate realistic typing with character delays
* Shows how to send text character-by-character
*/
Example4_TypingSimulation() {
    MsgBox("Example 4: Typing Simulation`n`n" .
    "Simulate realistic typing with delays between characters.",
    "Typing Simulation", "OK Icon!")

    ; Create demo GUI
    myGui := Gui("+AlwaysOnTop", "Typing Simulation Demo")
    myGui.Add("Text", "w450", "Output Area:")

    outputEdit := myGui.Add("Edit", "w450 h300 Multi", "")

    myGui.Add("Text", "w450 y+10", "Typing Speed:")
    speedSlider := myGui.Add("Slider", "w450 Range10-200 TickInterval20", 50)
    speedText := myGui.Add("Text", "w450", "Delay: 50ms per character")

    speedSlider.OnEvent("Change", (*) => UpdateSpeed())

    ; Text samples
    myGui.Add("Text", "w450 y+20", "Sample Texts:")

    sample1Btn := myGui.Add("Button", "w140 y+10", "Quote")
    sample1Btn.OnEvent("Click", (*) => TypeText(
    "To be or not to be, that is the question."))

    sample2Btn := myGui.Add("Button", "w140 x+10", "Lorem Ipsum")
    sample2Btn.OnEvent("Click", (*) => TypeText(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit."))

    sample3Btn := myGui.Add("Button", "w140 x+10", "Multi-Line")
    sample3Btn.OnEvent("Click", (*) => TypeText(
    "First line of text`nSecond line of text`nThird line of text"))

    clearBtn := myGui.Add("Button", "w220 y+20", "Clear Output")
    clearBtn.OnEvent("Click", (*) => outputEdit.Value := "")

    closeBtn := myGui.Add("Button", "w220 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    currentSpeed := 50
    isTyping := false

    ; Update speed display
    UpdateSpeed() {
        currentSpeed := speedSlider.Value
        speedText.Value := "Delay: " . currentSpeed . "ms per character"
    }

    ; Type text character by character
    TypeText(text) {
        if isTyping {
            MsgBox("Already typing! Please wait...", "Busy", "OK IconX T1")
            return
        }

        isTyping := true
        winTitle := "Typing Simulation Demo"

        try {
            ; Add timestamp
            timestamp := "`n[" . FormatTime(, "HH:mm:ss") . "] "
            ControlSend(timestamp, "Edit1", winTitle)
            Sleep(200)

            ; Type each character
            Loop Parse text {
                char := A_LoopField
                ControlSend(char, "Edit1", winTitle)
                Sleep(currentSpeed)
            }

            ; Add newline
            ControlSend("`n", "Edit1", winTitle)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        } finally {
            isTyping := false
        }
    }

    MsgBox("Typing simulation demo started!`n`n" .
    "Adjust speed and watch realistic typing simulation.",
    "Info", "OK Icon! T3")
}

; ============================================================================
; Example 5: Text Input Validation and Error Handling
; ============================================================================

/**
* @function Example5_InputValidation
* @description Demonstrates input validation when using ControlSend
* Shows error handling and verification techniques
*/
Example5_InputValidation() {
    MsgBox("Example 5: Input Validation`n`n" .
    "Validate and verify text sent to controls.",
    "Input Validation", "OK Icon!")

    ; Create form with validation
    formGui := Gui(, "Validated Form")
    formGui.Add("Text", "w400", "Data Entry Form with Validation:")

    formGui.Add("Text", "w400 y+20", "Numeric Only (1-100):")
    numericEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Email Format:")
    emailEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Phone Format (###-###-####):")
    phoneEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Date Format (YYYY-MM-DD):")
    dateEdit := formGui.Add("Edit", "w400")

    formGui.Show("x50 y50")

    ; Create validation control panel
    ctrlGui := Gui("+AlwaysOnTop", "Validation Control")
    ctrlGui.Add("Text", "w400", "Auto-Fill with Validation:")

    ctrlGui.Add("Text", "w400 y+20", "Test Data:")

    ; Valid data tests
    ctrlGui.Add("Text", "w400 y+10 BackgroundGreen cWhite", "Valid Data Tests")

    validBtn := ctrlGui.Add("Button", "w390 y+10", "Test: Valid Data")
    validBtn.OnEvent("Click", (*) => TestValid())

    ; Invalid data tests
    ctrlGui.Add("Text", "w400 y+20 BackgroundRed cWhite", "Invalid Data Tests")

    invalidNumBtn := ctrlGui.Add("Button", "w390 y+10",
    "Test: Invalid Number (150)")
    invalidNumBtn.OnEvent("Click", (*) => TestInvalidNum())

    invalidEmailBtn := ctrlGui.Add("Button", "w390 y+10",
    "Test: Invalid Email (no@)")
    invalidEmailBtn.OnEvent("Click", (*) => TestInvalidEmail())

    invalidPhoneBtn := ctrlGui.Add("Button", "w390 y+10",
    "Test: Invalid Phone (wrong format)")
    invalidPhoneBtn.OnEvent("Click", (*) => TestInvalidPhone())

    ; Results log
    ctrlGui.Add("Text", "w400 y+20", "Validation Results:")
    resultEdit := ctrlGui.Add("Edit", "w390 h150 ReadOnly", "")

    clearBtn := ctrlGui.Add("Button", "w190 y+20", "Clear Results")
    clearBtn.OnEvent("Click", (*) => resultEdit.Value := "")

    closeBtn := ctrlGui.Add("Button", "w190 x+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => CloseAll())

    ctrlGui.Show("x470 y50")

    ; Log result
    LogResult(msg, isError := false) {
        prefix := isError ? "✗" : "✓"
        timestamp := FormatTime(, "HH:mm:ss")
        resultEdit.Value .= timestamp . " " . prefix . " " . msg . "`n"
        SendMessage(0x115, 7, 0, resultEdit.Hwnd)
    }

    ; Validation functions
    ValidateNumber(value) {
        if !IsNumber(value)
        return false
        num := Integer(value)
        return (num >= 1 && num <= 100)
    }

    ValidateEmail(value) {
        return RegExMatch(value, "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
    }

    ValidatePhone(value) {
        return RegExMatch(value, "^\d{3}-\d{3}-\d{4}$")
    }

    ValidateDate(value) {
        return RegExMatch(value, "^\d{4}-\d{2}-\d{2}$")
    }

    ; Send and validate
    SendAndValidate(control, value, validator, fieldName) {
        winTitle := "Validated Form"

        try {
            ; Send the value
            ControlSend(value, control, winTitle)
            Sleep(200)

            ; Get the value back
            sentValue := ControlGetText(control, winTitle)

            ; Validate
            if validator(sentValue) {
                LogResult(fieldName . ": '" . sentValue . "' - Valid")
                return true
            } else {
                LogResult(fieldName . ": '" . sentValue . "' - INVALID", true)
                return false
            }

        } catch Error as err {
            LogResult(fieldName . ": Error - " . err.Message, true)
            return false
        }
    }

    ; Test valid data
    TestValid() {
        LogResult("`n--- Testing Valid Data ---")

        ; Clear fields
        ControlSetText("", "Edit1", "Validated Form")
        ControlSetText("", "Edit2", "Validated Form")
        ControlSetText("", "Edit3", "Validated Form")
        ControlSetText("", "Edit4", "Validated Form")
        Sleep(200)

        ; Send valid data
        allValid := true
        allValid &= SendAndValidate("Edit1", "42", ValidateNumber, "Number")
        Sleep(100)
        allValid &= SendAndValidate("Edit2", "user@example.com", ValidateEmail, "Email")
        Sleep(100)
        allValid &= SendAndValidate("Edit3", "555-123-4567", ValidatePhone, "Phone")
        Sleep(100)
        allValid &= SendAndValidate("Edit4", "2024-01-15", ValidateDate, "Date")

        if allValid
        LogResult("All validations passed!`n")
        else
        LogResult("Some validations failed!`n", true)
    }

    ; Test invalid number
    TestInvalidNum() {
        LogResult("`n--- Testing Invalid Number ---")
        ControlSetText("", "Edit1", "Validated Form")
        Sleep(100)
        SendAndValidate("Edit1", "150", ValidateNumber, "Number")
        LogResult("")
    }

    ; Test invalid email
    TestInvalidEmail() {
        LogResult("`n--- Testing Invalid Email ---")
        ControlSetText("", "Edit2", "Validated Form")
        Sleep(100)
        SendAndValidate("Edit2", "notanemail", ValidateEmail, "Email")
        LogResult("")
    }

    ; Test invalid phone
    TestInvalidPhone() {
        LogResult("`n--- Testing Invalid Phone ---")
        ControlSetText("", "Edit3", "Validated Form")
        Sleep(100)
        SendAndValidate("Edit3", "5551234567", ValidatePhone, "Phone")
        LogResult("")
    }

    ; Close all
    CloseAll() {
        if WinExist("Validated Form")
        formGui.Destroy()
        if WinExist("Validation Control")
        ctrlGui.Destroy()
    }

    MsgBox("Input validation demo started!`n`n" .
    "Test sending and validating different data types.",
    "Info", "OK Icon! T3")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menuText := "
    (
    ControlSend Examples - Basic Usage
    ===================================

    1. Basic Text Sending
    2. Multiple Window Sending
    3. Form Filling Automation
    4. Typing Simulation
    5. Input Validation

    Select an example (1-5) or press Esc to exit
    )"

    choice := InputBox(menuText, "ControlSend Examples", "w400 h280")

    if (choice.Result = "Cancel")
    return

    switch choice.Value {
        case "1": Example1_BasicSend()
        case "2": Example2_MultiWindow()
        case "3": Example3_FormFilling()
        case "4": Example4_TypingSimulation()
        case "5": Example5_InputValidation()
        default:
        MsgBox("Invalid choice! Please select 1-5.", "Error", "OK IconX")
    }

    ; Show menu again
    SetTimer(() => ShowMainMenu(), -500)
}

; Start the demo
ShowMainMenu()
