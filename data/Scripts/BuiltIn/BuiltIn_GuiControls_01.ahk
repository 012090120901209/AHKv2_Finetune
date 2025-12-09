#Requires AutoHotkey v2.0

/**
* BuiltIn_GuiControls_01.ahk - Button and Text Controls
*
* This file demonstrates button and text controls in AutoHotkey v2.
* Topics covered:
* - Button types and styles
* - Text controls and labels
* - Static text formatting
* - Button events and handlers
* - Dynamic button states (enable/disable)
* - Button icons and images
* - Grouped buttons and button bars
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024
*/

; =============================================================================
; Example 1: Basic Buttons
; =============================================================================

/**
* Demonstrates basic button creation and click handling
* Shows different button styles and configurations
*/
Example1_BasicButtons() {
    myGui := Gui(, "Basic Buttons Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Button Types and Styles")
    myGui.SetFont("s9 Norm")

    ; Regular button
    btn1 := myGui.Add("Button", "x20 y50 w200", "Standard Button")
    btn1.OnEvent("Click", (*) => MsgBox("Standard button clicked!", "Button Click"))

    ; Default button (activated by Enter key)
    btn2 := myGui.Add("Button", "x230 y50 w200 Default", "Default Button")
    btn2.OnEvent("Click", (*) => MsgBox("Default button clicked! (Try pressing Enter)", "Button Click"))

    ; Disabled button
    btn3 := myGui.Add("Button", "x20 y90 w200 Disabled", "Disabled Button")
    btn3.OnEvent("Click", (*) => MsgBox("This should not appear!", "Error"))

    ; Button with custom dimensions
    btn4 := myGui.Add("Button", "x230 y90 w200 h40", "Tall Button")
    btn4.OnEvent("Click", (*) => MsgBox("Tall button clicked!", "Button Click"))

    ; Small button
    btn5 := myGui.Add("Button", "x20 y145 w95 h25", "Small")
    btn5.OnEvent("Click", (*) => MsgBox("Small button clicked!", "Button Click"))

    ; Medium button
    btn6 := myGui.Add("Button", "x125 y145 w95 h25", "Medium")
    btn6.OnEvent("Click", (*) => MsgBox("Medium button clicked!", "Button Click"))

    ; Large button
    btn7 := myGui.Add("Button", "x230 y145 w200 h50", "Large Button")
    btn7.SetFont("s12 Bold")
    btn7.OnEvent("Click", (*) => MsgBox("Large button clicked!", "Button Click"))

    ; Click counter
    myGui.Add("Text", "x20 y210 w200", "Button with counter:")
    clickCount := 0
    counterText := myGui.Add("Text", "x230 y210 w200", "Clicks: 0")
    counterBtn := myGui.Add("Button", "x20 y230 w410", "Click Me!")
    counterBtn.OnEvent("Click", (*) => (clickCount++, counterText.Value := "Clicks: " clickCount))

    ; Reset button
    myGui.Add("Button", "x20 y270 w200", "Reset Counter").OnEvent("Click", (*) => (clickCount := 0, counterText.Value := "Clicks: 0"))

    ; Close button
    myGui.Add("Button", "x230 y270 w200", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w450 h320")
}

; =============================================================================
; Example 2: Text Controls and Formatting
; =============================================================================

/**
* Demonstrates various text control types and formatting
* Shows static text, labels, and text styling
*/
Example2_TextControls() {
    myGui := Gui(, "Text Controls Demo")
    myGui.BackColor := "White"

    ; Title
    myGui.SetFont("s14 Bold")
    myGui.Add("Text", "x20 y20 w560", "Text Control Examples")

    ; Regular text
    myGui.SetFont("s9 Norm")
    myGui.Add("Text", "x20 y55 w560", "This is regular text with the default font.")

    ; Bold text
    myGui.SetFont("s9 Bold")
    myGui.Add("Text", "x20 y80 w560", "This text is BOLD.")

    ; Italic text
    myGui.SetFont("s9 Italic")
    myGui.Add("Text", "x20 y100 w560", "This text is italic.")

    ; Large text
    myGui.SetFont("s16 Bold")
    myGui.Add("Text", "x20 y125 w560", "Large Bold Text")

    ; Small text
    myGui.SetFont("s7")
    myGui.Add("Text", "x20 y155 w560", "Small text (size 7)")

    ; Colored text
    myGui.SetFont("s10 Bold")
    text1 := myGui.Add("Text", "x20 y175 w130 cRed", "Red Text")
    text2 := myGui.Add("Text", "x160 y175 w130 cBlue", "Blue Text")
    text3 := myGui.Add("Text", "x300 y175 w130 cGreen", "Green Text")
    text4 := myGui.Add("Text", "x440 y175 w130 c800080", "Purple Text")

    ; Text with background
    myGui.SetFont("s9 Norm")
    bgText1 := myGui.Add("Text", "x20 y205 w130 h30 BackgroundYellow Center Border", "Yellow BG")
    bgText2 := myGui.Add("Text", "x160 y205 w130 h30 BackgroundAqua Center Border", "Aqua BG")
    bgText3 := myGui.Add("Text", "x300 y205 w130 h30 BackgroundLime Center Border", "Lime BG")
    bgText4 := myGui.Add("Text", "x440 y205 w130 h30 BackgroundPink Center Border", "Pink BG")

    ; Text alignment
    myGui.Add("Text", "x20 y250 w180 h30 Border", "Left aligned (default)")
    myGui.Add("Text", "x210 y250 w180 h30 Border Center", "Center aligned")
    myGui.Add("Text", "x400 y250 w180 h30 Border Right", "Right aligned")

    ; Multi-line text
    myGui.Add("Text", "x20 y295 w560 h60 Border", "This is a multi-line text control.`nIt can display multiple lines of text.`nUse ``n for line breaks.")

    ; Dynamic text update
    myGui.Add("Text", "x20 y370", "Dynamic text updates:")
    dynamicText := myGui.Add("Text", "x20 y395 w460 h30 Border BackgroundWhite", "Time: " FormatTime(, "HH:mm:ss"))

    ; Update time every second
    SetTimer(UpdateTime, 1000)
    UpdateTime() {
        try dynamicText.Value := "Time: " FormatTime(, "HH:mm:ss")
    }

    ; Stop timer on close
    myGui.OnEvent("Close", (*) => (SetTimer(UpdateTime, 0), myGui.Destroy()))

    myGui.Add("Button", "x490 y395 w90", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w600 h450")
}

; =============================================================================
; Example 3: Button States and Interactions
; =============================================================================

/**
* Demonstrates button state management
* Enable, disable, show, hide functionality
*/
Example3_ButtonStates() {
    myGui := Gui(, "Button States Demo")
    myGui.BackColor := "0xF0F0F0"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Button State Management")
    myGui.SetFont("s9 Norm")

    ; Target buttons
    myGui.Add("Text", "x20 y55", "Target Buttons:")
    targetBtn1 := myGui.Add("Button", "x20 y75 w140", "Target Button 1")
    targetBtn2 := myGui.Add("Button", "x170 y75 w140", "Target Button 2")
    targetBtn3 := myGui.Add("Button", "x320 y75 w140", "Target Button 3")

    targetBtn1.OnEvent("Click", (*) => MsgBox("Target Button 1 clicked!"))
    targetBtn2.OnEvent("Click", (*) => MsgBox("Target Button 2 clicked!"))
    targetBtn3.OnEvent("Click", (*) => MsgBox("Target Button 3 clicked!"))

    ; Control buttons - Enable/Disable
    myGui.Add("Text", "x20 y120", "Enable/Disable Controls:")
    myGui.Add("Button", "x20 y140 w140", "Disable Button 1").OnEvent("Click", (*) => targetBtn1.Enabled := false)
    myGui.Add("Button", "x170 y140 w140", "Disable Button 2").OnEvent("Click", (*) => targetBtn2.Enabled := false)
    myGui.Add("Button", "x320 y140 w140", "Disable Button 3").OnEvent("Click", (*) => targetBtn3.Enabled := false)

    myGui.Add("Button", "x20 y175 w140", "Enable Button 1").OnEvent("Click", (*) => targetBtn1.Enabled := true)
    myGui.Add("Button", "x170 y175 w140", "Enable Button 2").OnEvent("Click", (*) => targetBtn2.Enabled := true)
    myGui.Add("Button", "x320 y175 w140", "Enable Button 3").OnEvent("Click", (*) => targetBtn3.Enabled := true)

    ; Show/Hide controls
    myGui.Add("Text", "x20 y220", "Show/Hide Controls:")
    myGui.Add("Button", "x20 y240 w140", "Hide Button 1").OnEvent("Click", (*) => targetBtn1.Visible := false)
    myGui.Add("Button", "x170 y240 w140", "Hide Button 2").OnEvent("Click", (*) => targetBtn2.Visible := false)
    myGui.Add("Button", "x320 y240 w140", "Hide Button 3").OnEvent("Click", (*) => targetBtn3.Visible := false)

    myGui.Add("Button", "x20 y275 w140", "Show Button 1").OnEvent("Click", (*) => targetBtn1.Visible := true)
    myGui.Add("Button", "x170 y275 w140", "Show Button 2").OnEvent("Click", (*) => targetBtn2.Visible := true)
    myGui.Add("Button", "x320 y275 w140", "Show Button 3").OnEvent("Click", (*) => targetBtn3.Visible := true)

    ; Bulk operations
    myGui.Add("Text", "x20 y320", "Bulk Operations:")
    myGui.Add("Button", "x20 y340 w140", "Disable All").OnEvent("Click", DisableAll)
    myGui.Add("Button", "x170 y340 w140", "Enable All").OnEvent("Click", EnableAll)
    myGui.Add("Button", "x320 y340 w140", "Toggle All").OnEvent("Click", ToggleAll)

    DisableAll(*) {
        targetBtn1.Enabled := false
        targetBtn2.Enabled := false
        targetBtn3.Enabled := false
    }

    EnableAll(*) {
        targetBtn1.Enabled := true
        targetBtn2.Enabled := true
        targetBtn3.Enabled := true
    }

    ToggleAll(*) {
        targetBtn1.Enabled := !targetBtn1.Enabled
        targetBtn2.Enabled := !targetBtn2.Enabled
        targetBtn3.Enabled := !targetBtn3.Enabled
    }

    myGui.Add("Button", "x20 y380 w440", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w480 h430")
}

; =============================================================================
; Example 4: Button Groups and Toolbars
; =============================================================================

/**
* Creates button groups and toolbar-like layouts
* Demonstrates organized button collections
*/
Example4_ButtonGroups() {
    myGui := Gui(, "Button Groups Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x10 y10 w580", "Button Groups and Toolbars")
    myGui.SetFont("s9 Norm")

    ; Toolbar-style button bar
    myGui.Add("Text", "x10 y40 w580 h1 Background0xCCCCCC", "")  ; Separator line
    toolbar := myGui.Add("Text", "x0 y41 w600 h40 Background0xF0F0F0", "")

    ; Toolbar buttons
    btnNew := myGui.Add("Button", "x10 y47 w70 h25", "New")
    btnOpen := myGui.Add("Button", "x85 y47 w70 h25", "Open")
    btnSave := myGui.Add("Button", "x160 y47 w70 h25", "Save")
    btnSep1 := myGui.Add("Text", "x235 y47 w1 h25 Background0xCCCCCC", "")
    btnCut := myGui.Add("Button", "x240 y47 w70 h25", "Cut")
    btnCopy := myGui.Add("Button", "x315 y47 w70 h25", "Copy")
    btnPaste := myGui.Add("Button", "x390 y47 w70 h25", "Paste")
    btnSep2 := myGui.Add("Text", "x465 y47 w1 h25 Background0xCCCCCC", "")
    btnHelp := myGui.Add("Button", "x470 y47 w70 h25", "Help")

    ; Status display
    statusText := myGui.Add("Text", "x10 y90 w580 h30 Border BackgroundWhite", "Ready")

    btnNew.OnEvent("Click", (*) => statusText.Value := "New file created")
    btnOpen.OnEvent("Click", (*) => statusText.Value := "Open dialog would appear...")
    btnSave.OnEvent("Click", (*) => statusText.Value := "File saved successfully")
    btnCut.OnEvent("Click", (*) => statusText.Value := "Cut to clipboard")
    btnCopy.OnEvent("Click", (*) => statusText.Value := "Copied to clipboard")
    btnPaste.OnEvent("Click", (*) => statusText.Value := "Pasted from clipboard")
    btnHelp.OnEvent("Click", (*) => statusText.Value := "Help documentation...")

    ; Navigation buttons
    myGui.Add("GroupBox", "x10 y130 w280 h80", "Navigation Controls")
    btnFirst := myGui.Add("Button", "x20 y150 w60", "|<< First")
    btnPrev := myGui.Add("Button", "x90 y150 w60", "< Prev")
    btnNext := myGui.Add("Button", "x160 y150 w60", "Next >")
    btnLast := myGui.Add("Button", "x230 y150 w50", "Last >>|")

    pageText := myGui.Add("Text", "x20 y180 w260 Center", "Page 1 of 10")
    currentPage := 1

    btnFirst.OnEvent("Click", (*) => UpdatePage(1))
    btnPrev.OnEvent("Click", (*) => UpdatePage(Max(1, currentPage - 1)))
    btnNext.OnEvent("Click", (*) => UpdatePage(Min(10, currentPage + 1)))
    btnLast.OnEvent("Click", (*) => UpdatePage(10))

    UpdatePage(page) {
        currentPage := page
        pageText.Value := "Page " currentPage " of 10"
        btnFirst.Enabled := (currentPage > 1)
        btnPrev.Enabled := (currentPage > 1)
        btnNext.Enabled := (currentPage < 10)
        btnLast.Enabled := (currentPage < 10)
    }
    UpdatePage(1)

    ; Yes/No/Cancel buttons
    myGui.Add("GroupBox", "x300 y130 w290 h80", "Dialog Buttons")
    btnYes := myGui.Add("Button", "x310 y150 w85", "Yes")
    btnNo := myGui.Add("Button", "x405 y150 w85", "No")
    btnCancel := myGui.Add("Button", "x500 y150 w80", "Cancel")

    resultText := myGui.Add("Text", "x310 y180 w270 Center", "Click a button...")

    btnYes.OnEvent("Click", (*) => resultText.Value := "You clicked: YES")
    btnNo.OnEvent("Click", (*) => resultText.Value := "You clicked: NO")
    btnCancel.OnEvent("Click", (*) => resultText.Value := "You clicked: CANCEL")

    ; Media player controls
    myGui.Add("GroupBox", "x10 y220 w580 h90", "Media Player Controls")

    btnStop := myGui.Add("Button", "x130 y245 w60 h40", "⬛ Stop")
    btnPlay := myGui.Add("Button", "x200 y245 w60 h40", "▶ Play")
    btnPause := myGui.Add("Button", "x270 y245 w60 h40", "⏸ Pause")
    btnRewind := myGui.Add("Button", "x340 y245 w60 h40", "⏪ RW")
    btnFF := myGui.Add("Button", "x410 y245 w60 h40", "FF ⏩")

    playerStatus := myGui.Add("Text", "x20 y290 w560 Center", "Status: Stopped")

    btnStop.OnEvent("Click", (*) => playerStatus.Value := "Status: Stopped")
    btnPlay.OnEvent("Click", (*) => playerStatus.Value := "Status: Playing...")
    btnPause.OnEvent("Click", (*) => playerStatus.Value := "Status: Paused")
    btnRewind.OnEvent("Click", (*) => playerStatus.Value := "Status: Rewinding...")
    btnFF.OnEvent("Click", (*) => playerStatus.Value := "Status: Fast forwarding...")

    ; Number pad
    myGui.Add("GroupBox", "x10 y320 w200 h180", "Number Pad")
    numDisplay := myGui.Add("Edit", "x20 y340 w180 h25 ReadOnly Right")

    numPadButtons := []
    startX := 20
    startY := 375
    for row in [[7,8,9], [4,5,6], [1,2,3], [0]] {
        for col, num in row {
            x := startX + (col - 1) * 60
            y := startY + (A_Index - 1) * 35
            if (num = 0) {
                btn := myGui.Add("Button", Format("x{1} y{2} w120 h30", x, y), String(num))
            } else {
                btn := myGui.Add("Button", Format("x{1} y{2} w55 h30", x, y), String(num))
            }
            btn.OnEvent("Click", (*) => numDisplay.Value .= String(num))
        }
    }

    myGui.Add("Button", "x140 y375 w55 h30", "Clear").OnEvent("Click", (*) => numDisplay.Value := "")
    myGui.Add("Button", "x140 y410 w55 h30", "⌫").OnEvent("Click", (*) => numDisplay.Value := SubStr(numDisplay.Value, 1, -1))

    ; Action buttons
    myGui.Add("GroupBox", "x220 y320 w370 h100", "Action Buttons")
    myGui.Add("Button", "x230 y345 w110 h30", "Submit").OnEvent("Click", (*) => MsgBox("Form submitted!", "Action"))
    myGui.Add("Button", "x350 y345 w110 h30", "Reset").OnEvent("Click", (*) => MsgBox("Form reset!", "Action"))
    myGui.Add("Button", "x470 y345 w110 h30", "Cancel").OnEvent("Click", (*) => MsgBox("Action cancelled!", "Action"))

    myGui.Add("Button", "x230 y380 w175 h30", "Apply Changes").OnEvent("Click", (*) => MsgBox("Changes applied!", "Action"))
    myGui.Add("Button", "x415 y380 w165 h30", "Discard Changes").OnEvent("Click", (*) => MsgBox("Changes discarded!", "Action"))

    ; Close button
    myGui.Add("Button", "x220 y430 w370 h30", "Close Window").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w600 h480")
}

; =============================================================================
; Example 5: Dynamic Button Text
; =============================================================================

/**
* Demonstrates dynamic button text changes
* Buttons that change their labels based on state
*/
Example5_DynamicButtons() {
    myGui := Gui(, "Dynamic Button Text Demo")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w460", "Dynamic Button Text")
    myGui.SetFont("s9 Norm")

    ; Toggle button
    myGui.Add("Text", "x20 y55", "Toggle Button:")
    isOn := false
    toggleBtn := myGui.Add("Button", "x20 y75 w200 h40", "Turn ON")
    toggleBtn.SetFont("s10 Bold")

    statusIndicator := myGui.Add("Text", "x230 y75 w200 h40 Border Center BackgroundRed cWhite", "Status: OFF")
    statusIndicator.SetFont("s12 Bold")

    toggleBtn.OnEvent("Click", ToggleState)

    ToggleState(*) {
        isOn := !isOn
        if (isOn) {
            toggleBtn.Value := "Turn OFF"
            statusIndicator.Value := "Status: ON"
            statusIndicator.Opt("BackgroundGreen")
        } else {
            toggleBtn.Value := "Turn ON"
            statusIndicator.Value := "Status: OFF"
            statusIndicator.Opt("BackgroundRed")
        }
    }

    ; Start/Stop button
    myGui.Add("Text", "x20 y135", "Start/Stop Button:")
    isRunning := false
    startStopBtn := myGui.Add("Button", "x20 y155 w200 h40", "▶ Start")
    startStopBtn.SetFont("s10 Bold")

    progressText := myGui.Add("Text", "x230 y155 w200 h40 Border Center", "Not running")
    progressText.SetFont("s10")

    startStopBtn.OnEvent("Click", StartStop)

    StartStop(*) {
        isRunning := !isRunning
        if (isRunning) {
            startStopBtn.Value := "⬛ Stop"
            startStopBtn.Opt("BackgroundRed")
            progressText.Value := "Running..."
            SetTimer(UpdateProgress, 1000)
        } else {
            startStopBtn.Value := "▶ Start"
            startStopBtn.Opt("BackgroundDefault")
            progressText.Value := "Stopped"
            SetTimer(UpdateProgress, 0)
        }
    }

    UpdateProgress() {
        static counter := 0
        counter++
        try progressText.Value := "Running... " counter "s"
    }

    ; Multi-state button
    myGui.Add("Text", "x20 y215", "Multi-State Button:")
    states := ["State 1: Initial", "State 2: Processing", "State 3: Complete", "State 1: Initial"]
    currentState := 1

    stateBtn := myGui.Add("Button", "x20 y235 w200 h40", states[1])
    stateBtn.SetFont("s10")

    stateDisplay := myGui.Add("Text", "x230 y235 w200 h40 Border Center BackgroundYellow", "Click to advance")

    stateBtn.OnEvent("Click", AdvanceState)

    AdvanceState(*) {
        currentState++
        if (currentState > 3)
        currentState := 1

        stateBtn.Value := states[currentState]

        switch currentState {
            case 1:
            stateDisplay.Opt("BackgroundYellow")
            stateDisplay.Value := "Ready to start"
            case 2:
            stateDisplay.Opt("BackgroundAqua")
            stateDisplay.Value := "In progress..."
            case 3:
            stateDisplay.Opt("BackgroundLime")
            stateDisplay.Value := "✓ Completed!"
        }
    }

    ; Counter button
    myGui.Add("Text", "x20 y295", "Counter Button:")
    clickCount := 0
    counterBtn := myGui.Add("Button", "x20 y315 w410 h40", "Clicked 0 times - Click me!")
    counterBtn.SetFont("s11")

    counterBtn.OnEvent("Click", IncrementCounter)

    IncrementCounter(*) {
        clickCount++
        counterBtn.Value := Format("Clicked {1} time{2} - Click me!", clickCount, clickCount = 1 ? "" : "s")

        if (clickCount = 10) {
            MsgBox("Congratulations! You've clicked 10 times!", "Achievement")
        }
    }

    ; Timer button
    myGui.Add("Text", "x20 y375", "Timer Button:")
    timerBtn := myGui.Add("Button", "x20 y395 w410 h40", "Click to start 10 second countdown")
    timerBtn.SetFont("s11 Bold")

    timerBtn.OnEvent("Click", StartCountdown)

    StartCountdown(*) {
        timerBtn.Enabled := false
        countdown := 10

        UpdateTimer() {
            if (countdown > 0) {
                try {
                    timerBtn.Value := Format("Countdown: {1} seconds...", countdown)
                    countdown--
                }
            } else {
                try {
                    timerBtn.Value := "🎉 Time's up! Click to restart"
                    timerBtn.Enabled := true
                }
                SetTimer(, 0)
            }
        }

        SetTimer(UpdateTimer, 1000)
        UpdateTimer()
    }

    myGui.OnEvent("Close", (*) => (SetTimer(UpdateProgress, 0), myGui.Destroy()))
    myGui.Add("Button", "x20 y455 w410", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w450 h510")
}

; =============================================================================
; Example 6: Button Layout Patterns
; =============================================================================

/**
* Common button layout patterns
* Dialog buttons, confirmation patterns
*/
Example6_ButtonLayouts() {
    myGui := Gui(, "Button Layout Patterns")
    myGui.BackColor := "White"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Common Button Layout Patterns")
    myGui.SetFont("s9 Norm")

    ; OK pattern
    myGui.Add("GroupBox", "x20 y50 w560 h60", "Pattern 1: Single OK Button")
    myGui.Add("Button", "x470 y70 w90", "OK").OnEvent("Click", (*) => ShowResult("OK clicked"))

    ; OK/Cancel pattern
    myGui.Add("GroupBox", "x20 y120 w560 h60", "Pattern 2: OK / Cancel")
    myGui.Add("Button", "x370 y140 w90", "OK").OnEvent("Click", (*) => ShowResult("OK clicked"))
    myGui.Add("Button", "x470 y140 w90", "Cancel").OnEvent("Click", (*) => ShowResult("Cancel clicked"))

    ; Yes/No pattern
    myGui.Add("GroupBox", "x20 y190 w560 h60", "Pattern 3: Yes / No")
    myGui.Add("Button", "x370 y210 w90", "Yes").OnEvent("Click", (*) => ShowResult("Yes clicked"))
    myGui.Add("Button", "x470 y210 w90", "No").OnEvent("Click", (*) => ShowResult("No clicked"))

    ; Yes/No/Cancel pattern
    myGui.Add("GroupBox", "x20 y260 w560 h60", "Pattern 4: Yes / No / Cancel")
    myGui.Add("Button", "x270 y280 w90", "Yes").OnEvent("Click", (*) => ShowResult("Yes clicked"))
    myGui.Add("Button", "x370 y280 w90", "No").OnEvent("Click", (*) => ShowResult("No clicked"))
    myGui.Add("Button", "x470 y280 w90", "Cancel").OnEvent("Click", (*) => ShowResult("Cancel clicked"))

    ; Save/Don't Save/Cancel pattern
    myGui.Add("GroupBox", "x20 y330 w560 h60", "Pattern 5: Save / Don't Save / Cancel")
    myGui.Add("Button", "x240 y350 w100", "Save").OnEvent("Click", (*) => ShowResult("Save clicked"))
    myGui.Add("Button", "x350 y350 w110", "Don't Save").OnEvent("Click", (*) => ShowResult("Don't Save clicked"))
    myGui.Add("Button", "x470 y350 w90", "Cancel").OnEvent("Click", (*) => ShowResult("Cancel clicked"))

    ; Apply/Reset/Close pattern
    myGui.Add("GroupBox", "x20 y400 w560 h60", "Pattern 6: Apply / Reset / Close")
    myGui.Add("Button", "x270 y420 w90", "Apply").OnEvent("Click", (*) => ShowResult("Apply clicked"))
    myGui.Add("Button", "x370 y420 w90", "Reset").OnEvent("Click", (*) => ShowResult("Reset clicked"))
    myGui.Add("Button", "x470 y420 w90", "Close").OnEvent("Click", (*) => ShowResult("Close clicked"))

    ; Result display
    resultText := myGui.Add("Text", "x20 y475 w560 h30 Border BackgroundWhite Center", "Click any button to see result")
    resultText.SetFont("s10")

    ShowResult(msg) {
        resultText.Value := "Result: " msg
    }

    myGui.Add("Button", "x20 y520 w560", "Exit Demo").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w600 h570")
}

; =============================================================================
; Example 7: Button Click Feedback
; =============================================================================

/**
* Visual and textual feedback for button clicks
* Demonstrates user feedback techniques
*/
Example7_ButtonFeedback() {
    myGui := Gui(, "Button Click Feedback Demo")
    myGui.BackColor := "0xF5F5F5"

    myGui.SetFont("s11 Bold")
    myGui.Add("Text", "x20 y20 w560", "Button Click Feedback Examples")
    myGui.SetFont("s9 Norm")

    ; Visual feedback - color change
    myGui.Add("Text", "x20 y55", "Visual Feedback (Color Change):")
    colorBtn := myGui.Add("Button", "x20 y75 w200 h40", "Click Me!")
    colorBtn.SetFont("s10 Bold")

    colorBtn.OnEvent("Click", ColorFeedback)

    ColorFeedback(*) {
        colorBtn.Opt("BackgroundGreen")
        colorBtn.Value := "✓ Clicked!"
        SetTimer(() => (colorBtn.Opt("BackgroundDefault"), colorBtn.Value := "Click Me!"), -1000)
    }

    ; Text feedback
    myGui.Add("Text", "x230 y55", "Text Feedback:")
    textBtn := myGui.Add("Button", "x230 y75 w200 h40", "Submit Form")
    feedbackText := myGui.Add("Text", "x440 y75 w140 h40 Border Center BackgroundWhite", "Ready")

    textBtn.OnEvent("Click", TextFeedback)

    TextFeedback(*) {
        feedbackText.Value := "Submitting..."
        feedbackText.Opt("BackgroundYellow")
        SetTimer(CompleteSubmit, -1500)
    }

    CompleteSubmit() {
        try {
            feedbackText.Value := "✓ Complete!"
            feedbackText.Opt("BackgroundLime")
            SetTimer(() => (feedbackText.Value := "Ready", feedbackText.Opt("BackgroundWhite")), -2000)
        }
    }

    ; Disable feedback
    myGui.Add("Text", "x20 y135", "Disable During Process:")
    processBtn := myGui.Add("Button", "x20 y155 w200 h40", "Start Process")
    processStatus := myGui.Add("Text", "x230 y155 w350 h40 Border BackgroundWhite", "Ready to start")
    processStatus.SetFont("s10")

    processBtn.OnEvent("Click", StartProcess)

    StartProcess(*) {
        processBtn.Enabled := false
        processBtn.Value := "Processing..."
        processStatus.Value := "Working, please wait..."
        processStatus.Opt("BackgroundAqua")

        SetTimer(FinishProcess, -3000)
    }

    FinishProcess() {
        try {
            processBtn.Enabled := true
            processBtn.Value := "Start Process"
            processStatus.Value := "✓ Process completed successfully!"
            processStatus.Opt("BackgroundLime")
            SetTimer(() => (processStatus.Value := "Ready to start", processStatus.Opt("BackgroundWhite")), -2000)
        }
    }

    ; Click log
    myGui.Add("Text", "x20 y215", "Click Event Log:")
    logEdit := myGui.Add("Edit", "x20 y235 w560 h150 ReadOnly Multi", "Event Log:`n")

    logBtn1 := myGui.Add("Button", "x20 y395 w130", "Log Event A")
    logBtn2 := myGui.Add("Button", "x160 y395 w130", "Log Event B")
    logBtn3 := myGui.Add("Button", "x300 y395 w130", "Log Event C")
    clearBtn := myGui.Add("Button", "x440 y395 w140", "Clear Log")

    logBtn1.OnEvent("Click", (*) => LogEvent("Event A triggered"))
    logBtn2.OnEvent("Click", (*) => LogEvent("Event B triggered"))
    logBtn3.OnEvent("Click", (*) => LogEvent("Event C triggered"))
    clearBtn.OnEvent("Click", (*) => logEdit.Value := "Event Log:`n")

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        logEdit.Value .= Format("[{1}] {2}`n", timestamp, msg)
        ControlSend("{End}", logEdit)
    }

    ; Sound feedback (simulated)
    myGui.Add("Text", "x20 y435", "Audio Feedback (system beep):")
    soundBtn := myGui.Add("Button", "x20 y455 w200", "Click for Sound")
    soundBtn.OnEvent("Click", (*) => (SoundBeep(800, 100), LogEvent("Sound played")))

    myGui.Add("Button", "x230 y455 w350", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.OnEvent("Close", (*) => myGui.Destroy())

    myGui.Show("w600 h500")
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
* Creates a main menu to launch all examples
*/
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_GuiControls_01 - Button & Text Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Button and Text Control Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    ; Example buttons
    menuGui.Add("Button", "x20 y80 w360", "Example 1: Basic Buttons").OnEvent("Click", (*) => Example1_BasicButtons())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Text Controls").OnEvent("Click", (*) => Example2_TextControls())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Button States").OnEvent("Click", (*) => Example3_ButtonStates())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Button Groups").OnEvent("Click", (*) => Example4_ButtonGroups())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Dynamic Button Text").OnEvent("Click", (*) => Example5_DynamicButtons())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Button Layout Patterns").OnEvent("Click", (*) => Example6_ButtonLayouts())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Button Click Feedback").OnEvent("Click", (*) => Example7_ButtonFeedback())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
