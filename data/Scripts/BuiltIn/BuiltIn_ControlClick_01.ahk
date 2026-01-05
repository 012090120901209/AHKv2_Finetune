#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * BuiltIn_ControlClick_01 - Basic Control Clicking
 * ============================================================================
 * 
 * Demonstrates basic ControlClick functionality for automating UI interactions
 * without requiring window focus or mouse movement.
 * 
 * @description
 * ControlClick sends a click directly to a control within a window, making it
 * ideal for background automation. Unlike Click, ControlClick doesn't require
 * the target window to be active or visible.
 * 
 * Key Features:
 * - Direct control targeting without focus
 * - Background window automation
 * - Multiple button support (left, right, middle)
 * - Error handling and validation
 * - Control identification methods
 * 
 * @syntax ControlClick Control, WinTitle, WinText, WhichButton, ClickCount
 * 
 * @author AutoHotkey Community
 * @version 1.0.0
 * @since 2024-01-16
 * 
 * @example
 * ; Click a button in Notepad
 * ControlClick "Button1", "Untitled - Notepad"
 * 
 * @see https://www.autohotkey.com/docs/v2/lib/ControlClick.htm
 */

; ============================================================================
; Example 1: Basic Control Click - Clicking Notepad's Menu Items
; ============================================================================

/**
 * @function Example1_BasicControlClick
 * @description Demonstrates basic ControlClick usage with Notepad menus
 * Opens Notepad and clicks menu items using control identifiers
 */
Example1_BasicControlClick() {
    MsgBox("Example 1: Basic Control Click`n`n" .
        "This will open Notepad and automate clicking the File menu.",
        "Control Click Demo", "OK Icon!")

    ; Launch Notepad
    Run("notepad.exe")
    WinWait("Untitled - Notepad", , 5)

    if !WinExist("Untitled - Notepad") {
        MsgBox("Failed to launch Notepad!", "Error", "OK IconX")
        return
    }

    Sleep(500)

    ; Click on the menu bar using control name
    try {
        ; Click the File menu (MenuBar control)
        ControlClick("MenuBar1", "Untitled - Notepad")
        Sleep(300)

        MsgBox("File menu clicked successfully!", "Success", "OK Icon!")

        ; Send Escape to close the menu
        ControlSend("{Escape}", "Edit1", "Untitled - Notepad")

    } catch Error as err {
        MsgBox("Error clicking control: " . err.Message, "Error", "OK IconX")
    }

    ; Close Notepad
    WinClose("Untitled - Notepad")
    if WinExist("Notepad") {
        Sleep(200)
        ControlClick("Button2", "Notepad")  ; Click "Don't Save"
    }
}

; ============================================================================
; Example 2: Using Different Control Identification Methods
; ============================================================================

/**
 * @function Example2_ControlIdentification
 * @description Shows different ways to identify and click controls
 * Demonstrates ClassNN, Text, and HWND identification methods
 */
Example2_ControlIdentification() {
    MsgBox("Example 2: Control Identification Methods`n`n" .
        "Demonstrates different ways to identify controls.",
        "Control Identification", "OK Icon!")

    ; Create a GUI for demonstration
    myGui := Gui("+AlwaysOnTop", "Control Identification Demo")
    myGui.Add("Text", "w300", "This GUI demonstrates control identification methods:")
    myGui.Add("Text", "w300 y+10", "Each button can be clicked using different identifiers.")

    btn1 := myGui.Add("Button", "w280 y+20", "Button 1 - Click Me!")
    btn2 := myGui.Add("Button", "w280 y+10", "Button 2 - Or Click Me!")
    btn3 := myGui.Add("Button", "w280 y+10", "Button 3 - Or Me!")

    closeBtn := myGui.Add("Button", "w280 y+20", "Close Window")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Wait for window to appear
    Sleep(500)
    winTitle := "Control Identification Demo"

    ; Method 1: Using ClassNN (Class name and instance number)
    MsgBox("Clicking Button 1 using ClassNN identifier...", "Method 1", "T1")
    try {
        ControlClick("Button1", winTitle)  ; ClassNN: Button1
        Sleep(500)
    } catch Error as err {
        MsgBox("Error with ClassNN: " . err.Message, "Error", "OK IconX")
    }

    ; Method 2: Using button text
    MsgBox("Clicking Button 2 using text identifier...", "Method 2", "T1")
    try {
        ControlClick("Button 2 - Or Click Me!", winTitle)  ; Text content
        Sleep(500)
    } catch Error as err {
        MsgBox("Error with text: " . err.Message, "Error", "OK IconX")
    }

    ; Method 3: Using HWND (window handle)
    MsgBox("Clicking Button 3 using HWND identifier...", "Method 3", "T1")
    try {
        hwnd := btn3.Hwnd
        ControlClick("ahk_id " . hwnd, winTitle)  ; HWND
        Sleep(500)
    } catch Error as err {
        MsgBox("Error with HWND: " . err.Message, "Error", "OK IconX")
    }

    MsgBox("All identification methods demonstrated!", "Complete", "OK Icon!")

    ; Close the GUI
    if WinExist(winTitle)
        myGui.Destroy()
}

; ============================================================================
; Example 3: Background Window Control Clicking
; ============================================================================

/**
 * @function Example3_BackgroundClicking
 * @description Demonstrates clicking controls in background windows
 * Shows how ControlClick works without activating the window
 */
Example3_BackgroundClicking() {
    MsgBox("Example 3: Background Window Clicking`n`n" .
        "This will click buttons without activating the window.",
        "Background Clicking", "OK Icon!")

    ; Create a target GUI window
    targetGui := Gui("+AlwaysOnTop", "Background Target")
    targetGui.Add("Text", "w300", "This window will receive clicks in the background:")

    clickCounter := 0
    statusText := targetGui.Add("Text", "w300 h60 y+20 Border",
        "Click count: 0`nLast click time: Never")

    ; Add buttons to click
    btn1 := targetGui.Add("Button", "w140 y+20", "Counter Button")
    btn1.OnEvent("Click", (*) => UpdateCounter())

    btn2 := targetGui.Add("Button", "w140 x+10", "Reset Counter")
    btn2.OnEvent("Click", (*) => ResetCounter())

    targetGui.Show("x100 y100")

    ; Create a control GUI window
    controlGui := Gui("+AlwaysOnTop", "Control Panel")
    controlGui.Add("Text", "w300", "Use these buttons to click the target window:")

    clickBtn := controlGui.Add("Button", "w280 y+20", "Click Counter Button (Background)")
    clickBtn.OnEvent("Click", (*) => BackgroundClick("Button1"))

    resetBtn := controlGui.Add("Button", "w280 y+10", "Click Reset Button (Background)")
    resetBtn.OnEvent("Click", (*) => BackgroundClick("Button2"))

    closeBtn := controlGui.Add("Button", "w280 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => CloseDemo())

    controlGui.Show("x450 y100")

    ; Helper function to update counter
    UpdateCounter(*) {
        clickCounter++
        statusText.Value := "Click count: " . clickCounter .
            "`nLast click time: " . FormatTime(, "HH:mm:ss")
    }

    ; Helper function to reset counter
    ResetCounter(*) {
        clickCounter := 0
        statusText.Value := "Click count: 0`nLast click time: " . FormatTime(, "HH:mm:ss")
    }

    ; Background click function
    BackgroundClick(controlName) {
        try {
            ; Click without activating the target window
            ControlClick(controlName, "Background Target")

            ; Show feedback in control panel (without blocking)
            ToolTip("Clicked " . controlName . " in background")
            SetTimer(() => ToolTip(), -1000)

        } catch Error as err {
            MsgBox("Error clicking control: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Close demo function
    CloseDemo(*) {
        if WinExist("Background Target")
            targetGui.Destroy()
        if WinExist("Control Panel")
            controlGui.Destroy()
    }

    MsgBox("Background clicking demo started!`n`n" .
        "Notice how you can click buttons without the window becoming active.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 4: Button Click Types (Left, Right, Middle)
; ============================================================================

/**
 * @function Example4_ButtonTypes
 * @description Demonstrates clicking with different mouse buttons
 * Shows Left, Right, and Middle button clicks on controls
 */
Example4_ButtonTypes() {
    MsgBox("Example 4: Different Button Click Types`n`n" .
        "Demonstrates Left, Right, and Middle button clicks.",
        "Button Types", "OK Icon!")

    ; Create GUI with context menu support
    myGui := Gui("+AlwaysOnTop", "Button Types Demo")
    myGui.Add("Text", "w350", "Right-click the list to see context menu:")

    ; Add ListBox with right-click support
    lb := myGui.Add("ListBox", "w350 h120 y+10",
        ["Item 1", "Item 2", "Item 3", "Item 4", "Item 5"])

    ; Create context menu
    contextMenu := Menu()
    contextMenu.Add("Add Item", (*) => AddItem())
    contextMenu.Add("Remove Item", (*) => RemoveItem())
    contextMenu.Add()
    contextMenu.Add("Clear All", (*) => ClearAll())

    ; Status display
    statusText := myGui.Add("Text", "w350 h80 y+20 Border",
        "Status: Ready`nLast action: None`nClick type: None")

    ; Control buttons
    leftBtn := myGui.Add("Button", "w110 y+20", "Left Click")
    leftBtn.OnEvent("Click", (*) => SimulateClick("Left"))

    rightBtn := myGui.Add("Button", "w110 x+10", "Right Click")
    rightBtn.OnEvent("Click", (*) => SimulateClick("Right"))

    middleBtn := myGui.Add("Button", "w110 x+10", "Middle Click")
    middleBtn.OnEvent("Click", (*) => SimulateClick("Middle"))

    closeBtn := myGui.Add("Button", "w350 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Setup ListBox events
    lb.OnEvent("ContextMenu", (*) => contextMenu.Show())

    ; Helper functions
    AddItem(*) {
        currentItems := []
        Loop lb.GetCount()
            currentItems.Push(lb.GetText(A_Index))

        newItem := "Item " . (currentItems.Length + 1)
        lb.Add([newItem])
        UpdateStatus("Added: " . newItem, "Context Menu")
    }

    RemoveItem(*) {
        selected := lb.Value
        if (selected > 0) {
            itemText := lb.GetText(selected)
            lb.Delete(selected)
            UpdateStatus("Removed: " . itemText, "Context Menu")
        } else {
            UpdateStatus("No item selected", "Error")
        }
    }

    ClearAll(*) {
        lb.Delete()
        UpdateStatus("All items cleared", "Context Menu")
    }

    UpdateStatus(action, clickType) {
        statusText.Value := "Status: Action completed`n" .
            "Last action: " . action . "`n" .
            "Click type: " . clickType
    }

    ; Simulate different click types
    SimulateClick(buttonType) {
        try {
            winTitle := "Button Types Demo"

            Switch buttonType {
                Case "Left":
                    ControlClick("ListBox1", winTitle, , "Left", 1)
                    UpdateStatus("ListBox clicked", "Left Button")

                Case "Right":
                    ControlClick("ListBox1", winTitle, , "Right", 1)
                    Sleep(100)
                    ; Note: Context menu would appear with real right-click
                    UpdateStatus("ListBox right-clicked (would show context menu)", "Right Button")

                Case "Middle":
                    ControlClick("ListBox1", winTitle, , "Middle", 1)
                    UpdateStatus("ListBox middle-clicked", "Middle Button")
            }

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    MsgBox("Different button types demo started!`n`n" .
        "Use the buttons to simulate different mouse click types.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 5: Click Count and Multiple Clicks
; ============================================================================

/**
 * @function Example5_ClickCount
 * @description Demonstrates single, double, and multiple clicks on controls
 * Shows how to use the ClickCount parameter
 */
Example5_ClickCount() {
    MsgBox("Example 5: Click Count and Multiple Clicks`n`n" .
        "Demonstrates single, double, and multiple clicks.",
        "Click Count", "OK Icon!")

    ; Create demo GUI
    myGui := Gui("+AlwaysOnTop", "Click Count Demo")
    myGui.Add("Text", "w350", "Monitor click events on the edit control below:")

    ; Edit control that responds to clicks
    edit := myGui.Add("Edit", "w350 h100 y+10",
        "Click this area with different click counts.`n`n" .
        "Try single click, double click, etc.")

    ; Click counter displays
    myGui.Add("Text", "w350 y+20", "Click Statistics:")
    singleCount := myGui.Add("Text", "w350", "Single clicks: 0")
    doubleCount := myGui.Add("Text", "w350", "Double clicks: 0")
    tripleCount := myGui.Add("Text", "w350", "Triple clicks: 0")

    ; Counters
    singles := 0
    doubles := 0
    triples := 0

    ; Control buttons
    myGui.Add("Text", "w350 y+20", "Simulate clicks using ControlClick:")

    singleBtn := myGui.Add("Button", "w110 y+10", "Single Click")
    singleBtn.OnEvent("Click", (*) => SimClick(1))

    doubleBtn := myGui.Add("Button", "w110 x+10", "Double Click")
    doubleBtn.OnEvent("Click", (*) => SimClick(2))

    tripleBtn := myGui.Add("Button", "w110 x+10", "Triple Click")
    tripleBtn.OnEvent("Click", (*) => SimClick(3))

    resetBtn := myGui.Add("Button", "w350 y+20", "Reset Counters")
    resetBtn.OnEvent("Click", (*) => ResetCounters())

    closeBtn := myGui.Add("Button", "w350 y+10", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Simulate click function
    SimClick(count) {
        try {
            winTitle := "Click Count Demo"

            ; Perform the control click with specified count
            ControlClick("Edit1", winTitle, , "Left", count)

            ; Update counters
            Switch count {
                Case 1:
                    singles++
                    singleCount.Value := "Single clicks: " . singles
                Case 2:
                    doubles++
                    doubleCount.Value := "Double clicks: " . doubles
                Case 3:
                    triples++
                    tripleCount.Value := "Triple clicks: " . triples
            }

            ; Visual feedback
            ToolTip("Performed " . count . " click(s)")
            SetTimer(() => ToolTip(), -1000)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error", "OK IconX")
        }
    }

    ; Reset function
    ResetCounters(*) {
        singles := 0
        doubles := 0
        triples := 0
        singleCount.Value := "Single clicks: 0"
        doubleCount.Value := "Double clicks: 0"
        tripleCount.Value := "Triple clicks: 0"
        MsgBox("Counters reset!", "Reset", "OK Icon! T1")
    }

    MsgBox("Click count demo started!`n`n" .
        "Use the buttons to simulate different click counts.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 6: Error Handling and Validation
; ============================================================================

/**
 * @function Example6_ErrorHandling
 * @description Comprehensive error handling for ControlClick operations
 * Shows proper validation and error recovery techniques
 */
Example6_ErrorHandling() {
    MsgBox("Example 6: Error Handling and Validation`n`n" .
        "Demonstrates proper error handling for ControlClick.",
        "Error Handling", "OK Icon!")

    ; Create demo GUI
    myGui := Gui("+AlwaysOnTop", "Error Handling Demo")
    myGui.Add("Text", "w400", "Test various error conditions:")

    ; Test target window
    myGui.Add("Text", "w400 y+20", "Target Window:")
    winEdit := myGui.Add("Edit", "w400", "Notepad")

    ; Test control name
    myGui.Add("Text", "w400 y+10", "Control Name:")
    ctrlEdit := myGui.Add("Edit", "w400", "Edit1")

    ; Results display
    myGui.Add("Text", "w400 y+20", "Test Results:")
    resultEdit := myGui.Add("Edit", "w400 h150 ReadOnly", "")

    ; Test buttons
    testBtn := myGui.Add("Button", "w190 y+20", "Test Click")
    testBtn.OnEvent("Click", (*) => TestClick())

    validBtn := myGui.Add("Button", "w190 x+20", "Validated Click")
    validBtn.OnEvent("Click", (*) => ValidatedClick())

    clearBtn := myGui.Add("Button", "w190 y+10", "Clear Results")
    clearBtn.OnEvent("Click", (*) => resultEdit.Value := "")

    closeBtn := myGui.Add("Button", "w190 x+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show()

    ; Basic test click without validation
    TestClick(*) {
        winTitle := winEdit.Value
        ctrlName := ctrlEdit.Value

        try {
            ControlClick(ctrlName, winTitle)
            AppendResult("✓ Click successful!")

        } catch Error as err {
            AppendResult("✗ Error: " . err.Message)
        }
    }

    ; Validated click with proper checks
    ValidatedClick(*) {
        winTitle := winEdit.Value
        ctrlName := ctrlEdit.Value

        AppendResult("`n--- Starting Validated Click ---")

        ; Step 1: Check if window title is provided
        if (winTitle = "") {
            AppendResult("✗ Window title is empty!")
            return
        }
        AppendResult("✓ Window title provided: " . winTitle)

        ; Step 2: Check if control name is provided
        if (ctrlName = "") {
            AppendResult("✗ Control name is empty!")
            return
        }
        AppendResult("✓ Control name provided: " . ctrlName)

        ; Step 3: Check if window exists
        if !WinExist(winTitle) {
            AppendResult("✗ Window not found: " . winTitle)
            AppendResult("  Attempting to launch Notepad...")

            try {
                Run("notepad.exe")
                if !WinWait(winTitle, , 5) {
                    AppendResult("✗ Failed to launch window!")
                    return
                }
                AppendResult("✓ Window launched successfully!")
            } catch Error as err {
                AppendResult("✗ Error launching: " . err.Message)
                return
            }
        } else {
            AppendResult("✓ Window exists!")
        }

        ; Step 4: Check if control exists
        try {
            hwnd := ControlGetHwnd(ctrlName, winTitle)
            AppendResult("✓ Control found (HWND: " . hwnd . ")")
        } catch {
            AppendResult("✗ Control not found: " . ctrlName)
            AppendResult("  Available controls:")

            try {
                controls := WinGetControls(winTitle)
                for index, ctrl in controls {
                    if (index <= 5)  ; Show first 5 controls
                        AppendResult("    - " . ctrl)
                }
                if (controls.Length > 5)
                    AppendResult("    ... and " . (controls.Length - 5) . " more")
            } catch {
                AppendResult("  Could not enumerate controls")
            }
            return
        }

        ; Step 5: Attempt the click
        try {
            ControlClick(ctrlName, winTitle)
            AppendResult("✓ Click executed successfully!")
            AppendResult("--- Validation Complete ---`n")

        } catch Error as err {
            AppendResult("✗ Click failed: " . err.Message)
            AppendResult("--- Validation Failed ---`n")
        }
    }

    ; Helper to append results
    AppendResult(text) {
        current := resultEdit.Value
        resultEdit.Value := current . text . "`n"

        ; Auto-scroll to bottom
        SendMessage(0x115, 7, 0, resultEdit.Hwnd)  ; WM_VSCROLL, SB_BOTTOM
    }

    MsgBox("Error handling demo started!`n`n" .
        "Try both methods to see the difference between basic and validated clicks.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Example 7: Real-World Application - Form Automation
; ============================================================================

/**
 * @function Example7_FormAutomation
 * @description Real-world form filling automation using ControlClick
 * Demonstrates automated form interaction for testing
 */
Example7_FormAutomation() {
    MsgBox("Example 7: Form Automation`n`n" .
        "Demonstrates automated form filling for testing.",
        "Form Automation", "OK Icon!")

    ; Create a sample form
    formGui := Gui("+AlwaysOnTop", "Sample Registration Form")
    formGui.Add("Text", "w400", "User Registration Form")

    ; Form fields
    formGui.Add("Text", "w400 y+20", "Full Name:")
    nameEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Email:")
    emailEdit := formGui.Add("Edit", "w400")

    formGui.Add("Text", "w400 y+10", "Country:")
    countryDDL := formGui.Add("DropDownList", "w400",
        ["USA", "Canada", "UK", "Australia", "Other"])

    formGui.Add("Text", "w400 y+10", "Subscribe to newsletter:")
    newsletterChk := formGui.Add("CheckBox", "w400", "Yes, send me updates")

    formGui.Add("Text", "w400 y+10", "Account Type:")
    personalRB := formGui.Add("Radio", "w190", "Personal")
    businessRB := formGui.Add("Radio", "w190 x+20", "Business")

    ; Form buttons
    submitBtn := formGui.Add("Button", "w190 y+20", "Submit Form")
    submitBtn.OnEvent("Click", (*) => SubmitForm())

    clearBtn := formGui.Add("Button", "w190 x+20", "Clear Form")
    clearBtn.OnEvent("Click", (*) => ClearForm())

    formGui.Show("x100 y100")

    ; Create automation control panel
    controlGui := Gui("+AlwaysOnTop", "Automation Control")
    controlGui.Add("Text", "w350", "Automated Form Filling:")

    autoBtn := controlGui.Add("Button", "w340 y+20", "Fill Form Automatically")
    autoBtn.OnEvent("Click", (*) => AutoFillForm())

    stepBtn := controlGui.Add("Button", "w340 y+10", "Fill Form (Step-by-Step)")
    stepBtn.OnEvent("Click", (*) => StepFillForm())

    statusEdit := controlGui.Add("Edit", "w340 h150 y+20 ReadOnly",
        "Status: Ready for automation")

    closeBtn := controlGui.Add("Button", "w340 y+20", "Close Demo")
    closeBtn.OnEvent("Click", (*) => CloseAll())

    controlGui.Show("x520 y100")

    ; Automated form filling
    AutoFillForm(*) {
        formTitle := "Sample Registration Form"
        statusEdit.Value := "Starting automated form fill...`n"

        try {
            ; Fill name field using ControlSetText (companion to ControlClick)
            ControlSetText("John Doe", "Edit1", formTitle)
            statusEdit.Value .= "✓ Name filled`n"
            Sleep(200)

            ; Fill email field
            ControlSetText("john.doe@example.com", "Edit2", formTitle)
            statusEdit.Value .= "✓ Email filled`n"
            Sleep(200)

            ; Select country from dropdown (requires click to open)
            ControlClick("ComboBox1", formTitle)
            Sleep(100)
            ControlSend("{Down 2}{Enter}", "ComboBox1", formTitle)
            statusEdit.Value .= "✓ Country selected`n"
            Sleep(200)

            ; Check newsletter checkbox
            ControlClick("Button3", formTitle)  ; Newsletter checkbox
            statusEdit.Value .= "✓ Newsletter checked`n"
            Sleep(200)

            ; Select account type radio button
            ControlClick("Button5", formTitle)  ; Business radio
            statusEdit.Value .= "✓ Account type selected`n"
            Sleep(200)

            statusEdit.Value .= "`n✓ Form filled successfully!"

        } catch Error as err {
            statusEdit.Value .= "`n✗ Error: " . err.Message
        }
    }

    ; Step-by-step form filling with prompts
    StepFillForm(*) {
        formTitle := "Sample Registration Form"
        statusEdit.Value := "Step-by-step fill started...`n"

        steps := [{
            name: "Name", ctrl: "Edit1", value: "Jane Smith", desc: "Filling name field" }, {
                name: "Email", ctrl: "Edit2", value: "jane.smith@example.com", desc: "Filling email field" }, {
                    name: "Newsletter", ctrl: "Button3", value: "CLICK", desc: "Checking newsletter" }, {
                        name: "Account", ctrl: "Button4", value: "CLICK", desc: "Selecting Personal account"
                    }
        ]

        for index, step in steps {
            MsgBox("Step " . index . ": " . step.desc, "Automation", "OK Icon! T2")

            try {
                if (step.value = "CLICK") {
                    ControlClick(step.ctrl, formTitle)
                } else {
                    ControlSetText(step.value, step.ctrl, formTitle)
                }
                statusEdit.Value .= "✓ " . step.name . " completed`n"
                Sleep(300)
            } catch Error as err {
                statusEdit.Value .= "✗ " . step.name . " failed: " . err.Message . "`n"
                return
            }
        }

        statusEdit.Value .= "`n✓ All steps completed!"
    }

    ; Submit form handler
    SubmitForm(*) {
        data := "Form Submitted:`n`n" .
            "Name: " . nameEdit.Value . "`n" .
            "Email: " . emailEdit.Value . "`n" .
            "Country: " . countryDDL.Text . "`n" .
            "Newsletter: " . (newsletterChk.Value ? "Yes" : "No") . "`n" .
            "Type: " . (personalRB.Value ? "Personal" : "Business")

        MsgBox(data, "Form Submitted", "OK Icon!")
    }

    ; Clear form handler
    ClearForm(*) {
        nameEdit.Value := ""
        emailEdit.Value := ""
        countryDDL.Value := 0
        newsletterChk.Value := 0
        personalRB.Value := 0
        businessRB.Value := 0
        MsgBox("Form cleared!", "Clear", "OK Icon! T1")
    }

    ; Close all windows
    CloseAll(*) {
        if WinExist("Sample Registration Form")
            formGui.Destroy()
        if WinExist("Automation Control")
            controlGui.Destroy()
    }

    MsgBox("Form automation demo started!`n`n" .
        "Use the control panel to automate form filling.",
        "Info", "OK Icon! T3")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menuText := "
                (
                ControlClick Examples - Basic Usage
                =====================================

                1. Basic Control Click (Notepad)
                2. Control Identification Methods
                3. Background Window Clicking
                4. Button Click Types (Left/Right/Middle)
                5. Click Count and Multiple Clicks
                6. Error Handling and Validation
                7. Form Automation Example

                Select an example (1-7) or press Esc to exit
                )"

    choice := InputBox(menuText, "ControlClick Examples", "w400 h350")

    if (choice.Result = "Cancel")
        return

    switch choice.Value {
        case "1": Example1_BasicControlClick()
        case "2": Example2_ControlIdentification()
        case "3": Example3_BackgroundClicking()
        case "4": Example4_ButtonTypes()
        case "5": Example5_ClickCount()
        case "6": Example6_ErrorHandling()
        case "7": Example7_FormAutomation()
        default:
            MsgBox("Invalid choice! Please select 1-7.", "Error", "OK IconX")
    }

    ; Show menu again
    SetTimer(() => ShowMainMenu(), -500)
}

; Start the demo
ShowMainMenu()
