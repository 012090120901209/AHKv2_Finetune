#Requires AutoHotkey v2.0

/**
 * BuiltIn_Gui_01.ahk - Basic GUI Creation and Window Management
 *
 * This file demonstrates fundamental GUI creation in AutoHotkey v2.
 * Topics covered:
 * - Creating simple windows
 * - Basic window properties (title, size, position)
 * - Window visibility and state management
 * - Modal vs modeless windows
 * - Window destruction and cleanup
 * - Basic message boxes and simple dialogs
 * - Window centering and screen positioning
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024
 */

; =============================================================================
; Example 1: Simple Window Creation
; =============================================================================

/**
 * Creates the most basic GUI window with minimal configuration
 * Demonstrates default window properties and simple show/hide
 */
Example1_SimpleWindow() {
    ; Create a basic GUI with a title
    myGui := Gui("+AlwaysOnTop", "My First Window")

    ; Add some basic text
    myGui.Add("Text", "x10 y10", "Hello, this is a simple AHK v2 GUI window!")
    myGui.Add("Text", "x10 y40", "Window created with Gui() constructor")

    ; Add a button to close the window
    closeBtn := myGui.Add("Button", "x10 y70 w100", "Close")
    closeBtn.OnEvent("Click", (*) => myGui.Destroy())

    ; Set window size
    myGui.Show("w300 h150")
}

; =============================================================================
; Example 2: Window Properties and Options
; =============================================================================

/**
 * Demonstrates various window properties and options
 * Shows how to configure window appearance and behavior
 */
Example2_WindowProperties() {
    ; Create GUI with multiple options
    myGui := Gui("+Resize +MinSize200x150 +MaxSize600x400", "Window Properties Demo")

    ; Set background color
    myGui.BackColor := "0xF0F0F0"

    ; Add informational text
    myGui.Add("Text", "x20 y20 w360", "This window demonstrates various properties:")
    myGui.Add("Text", "x20 y45", "• Resizable (try dragging edges)")
    myGui.Add("Text", "x20 y65", "• Minimum size: 200x150")
    myGui.Add("Text", "x20 y85", "• Maximum size: 600x400")
    myGui.Add("Text", "x20 y105", "• Custom background color")
    myGui.Add("Text", "x20 y125", "• Custom font (see below)")

    ; Add text with custom font
    customText := myGui.Add("Text", "x20 y155 w360 cBlue", "This text uses a custom font!")
    myGui.SetFont("s12 Bold", "Arial")
    customText.SetFont()

    ; Reset font for other controls
    myGui.SetFont("s9 Norm", "Segoe UI")

    ; Add position information
    posText := myGui.Add("Text", "x20 y190 w360", "Window Position: N/A")

    ; Update position on move
    myGui.OnEvent("Size", UpdateInfo)
    myGui.OnEvent("Move", UpdateInfo)

    UpdateInfo(*) {
        myGui.GetPos(&x, &y, &w, &h)
        posText.Value := Format("Position: X={1} Y={2} | Size: W={3} H={4}", x, y, w, h)
    }

    ; Add buttons
    myGui.Add("Button", "x20 y230 w100", "Minimize").OnEvent("Click", (*) => WinMinimize(myGui.Hwnd))
    myGui.Add("Button", "x130 y230 w100", "Maximize").OnEvent("Click", (*) => WinMaximize(myGui.Hwnd))
    myGui.Add("Button", "x240 y230 w100", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w400 h280")
    UpdateInfo()
}

; =============================================================================
; Example 3: Centered and Positioned Windows
; =============================================================================

/**
 * Shows different window positioning techniques
 * Demonstrates centering and custom positioning
 */
Example3_WindowPositioning() {
    ; Create GUI
    myGui := Gui("+AlwaysOnTop", "Window Positioning Demo")
    myGui.BackColor := "White"

    myGui.Add("Text", "x20 y20 w360", "Demonstrates various window positioning methods:")
    myGui.Add("Text", "x20 y50", "Click buttons to create windows at different positions")

    ; Center screen button
    centerBtn := myGui.Add("Button", "x20 y80 w160", "Center on Screen")
    centerBtn.OnEvent("Click", (*) => CreatePositionedWindow("center"))

    ; Top-left button
    topLeftBtn := myGui.Add("Button", "x190 y80 w160", "Top-Left Corner")
    topLeftBtn.OnEvent("Click", (*) => CreatePositionedWindow("topleft"))

    ; Top-right button
    topRightBtn := myGui.Add("Button", "x20 y110 w160", "Top-Right Corner")
    topRightBtn.OnEvent("Click", (*) => CreatePositionedWindow("topright"))

    ; Bottom-right button
    bottomRightBtn := myGui.Add("Button", "x190 y110 w160", "Bottom-Right Corner")
    bottomRightBtn.OnEvent("Click", (*) => CreatePositionedWindow("bottomright"))

    ; Custom position button
    customBtn := myGui.Add("Button", "x20 y140 w330", "Custom Position (X=100, Y=100)")
    customBtn.OnEvent("Click", (*) => CreatePositionedWindow("custom"))

    ; Close button
    myGui.Add("Button", "x20 y180 w330", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w400 h230")

    CreatePositionedWindow(position) {
        newGui := Gui("+ToolWindow", "Positioned Window - " position)
        newGui.Add("Text", "x20 y20", "This window is positioned at: " position)
        newGui.Add("Button", "x20 y50 w100", "Close").OnEvent("Click", (*) => newGui.Destroy())

        ; Get monitor dimensions
        MonitorGet(1, &Left, &Top, &Right, &Bottom)
        screenWidth := Right - Left
        screenHeight := Bottom - Top
        winWidth := 250
        winHeight := 100

        switch position {
            case "center":
                x := (screenWidth - winWidth) // 2
                y := (screenHeight - winHeight) // 2
                newGui.Show(Format("x{1} y{2} w{3} h{4}", x, y, winWidth, winHeight))
            case "topleft":
                newGui.Show(Format("x{1} y{2} w{3} h{4}", 0, 0, winWidth, winHeight))
            case "topright":
                newGui.Show(Format("x{1} y{2} w{3} h{4}", screenWidth - winWidth, 0, winWidth, winHeight))
            case "bottomright":
                newGui.Show(Format("x{1} y{2} w{3} h{4}", screenWidth - winWidth, screenHeight - winHeight, winWidth, winHeight))
            case "custom":
                newGui.Show(Format("x{1} y{2} w{3} h{4}", 100, 100, winWidth, winHeight))
        }
    }
}

; =============================================================================
; Example 4: Modal vs Modeless Windows
; =============================================================================

/**
 * Demonstrates the difference between modal and modeless windows
 * Modal windows block interaction with parent window
 */
Example4_ModalModeless() {
    ; Create main window
    mainGui := Gui(, "Modal vs Modeless Demo")
    mainGui.BackColor := "0xFFFFE0"

    mainGui.Add("Text", "x20 y20 w360", "Understanding Modal and Modeless Windows:")
    mainGui.Add("Text", "x20 y50 w360", "Modal: Blocks interaction with parent until closed")
    mainGui.Add("Text", "x20 y70 w360", "Modeless: Allows interaction with both windows")

    ; Modal dialog button
    modalBtn := myGui.Add("Button", "x20 y110 w160", "Open Modal Dialog")
    modalBtn.OnEvent("Click", (*) => ShowModalDialog(mainGui))

    ; Modeless window button
    modelessBtn := mainGui.Add("Button", "x190 y110 w160", "Open Modeless Window")
    modelessBtn.OnEvent("Click", (*) => ShowModelessWindow())

    ; Counter to show main window is responsive
    counterText := mainGui.Add("Text", "x20 y150 w360", "Counter: 0")
    counter := 0

    incrementBtn := mainGui.Add("Button", "x20 y180 w160", "Increment Counter")
    incrementBtn.OnEvent("Click", (*) => (counter++, counterText.Value := "Counter: " counter))

    resetBtn := mainGui.Add("Button", "x190 y180 w160", "Reset Counter")
    resetBtn.OnEvent("Click", (*) => (counter := 0, counterText.Value := "Counter: 0"))

    mainGui.Add("Button", "x20 y220 w330", "Close").OnEvent("Click", (*) => mainGui.Destroy())

    mainGui.Show("w400 h270")

    ShowModalDialog(owner) {
        ; Create modal dialog
        dialogGui := Gui("+Owner" owner.Hwnd " +ToolWindow", "Modal Dialog")

        dialogGui.Add("Text", "x20 y20 w260", "This is a MODAL dialog.")
        dialogGui.Add("Text", "x20 y45 w260", "Try clicking the main window - you can't!")
        dialogGui.Add("Text", "x20 y70 w260", "You must close this window first.")

        okBtn := dialogGui.Add("Button", "x20 y110 w100", "OK")
        okBtn.OnEvent("Click", (*) => dialogGui.Destroy())

        cancelBtn := dialogGui.Add("Button", "x130 y110 w100", "Cancel")
        cancelBtn.OnEvent("Click", (*) => dialogGui.Destroy())

        dialogGui.Show("w300 h160")

        ; Disable owner window
        owner.Opt("+Disabled")

        ; Re-enable on close
        dialogGui.OnEvent("Close", (*) => owner.Opt("-Disabled"))
        dialogGui.OnEvent("Escape", (*) => dialogGui.Destroy())
    }

    ShowModelessWindow() {
        ; Create modeless window
        modelessGui := Gui("+AlwaysOnTop +ToolWindow", "Modeless Window")

        modelessGui.Add("Text", "x20 y20 w260", "This is a MODELESS window.")
        modelessGui.Add("Text", "x20 y45 w260", "You can interact with both windows!")
        modelessGui.Add("Text", "x20 y70 w260", "Try clicking the main window.")

        modelessGui.Add("Button", "x20 y110 w100", "Close").OnEvent("Click", (*) => modelessGui.Destroy())

        modelessGui.Show("w300 h160")
    }
}

; =============================================================================
; Example 5: Window State Management
; =============================================================================

/**
 * Demonstrates window state management (minimize, maximize, restore)
 * Shows how to detect and respond to window state changes
 */
Example5_WindowState() {
    myGui := Gui("+Resize", "Window State Management")
    myGui.BackColor := "0xE8F4F8"

    myGui.Add("Text", "x20 y20 w360", "Window State Management Demo")

    stateText := myGui.Add("Text", "x20 y50 w360", "Current State: Normal")
    historyEdit := myGui.Add("Edit", "x20 y80 w360 h120 ReadOnly Multi", "Window State History:`n")

    ; Track state changes
    LogState(state) {
        currentTime := FormatTime(A_Now, "HH:mm:ss")
        historyEdit.Value .= Format("[{1}] {2}`n", currentTime, state)
    }

    ; Handle size events
    myGui.OnEvent("Size", WindowSizeHandler)

    WindowSizeHandler(guiObj, MinMax, Width, Height) {
        switch MinMax {
            case -1:
                stateText.Value := "Current State: Minimized"
                LogState("Window minimized")
            case 1:
                stateText.Value := "Current State: Maximized"
                LogState("Window maximized")
            case 0:
                stateText.Value := "Current State: Normal (Restored)"
                LogState("Window restored to normal")
        }
    }

    ; State control buttons
    myGui.Add("Button", "x20 y220 w110", "Minimize").OnEvent("Click", (*) => WinMinimize(myGui.Hwnd))
    myGui.Add("Button", "x140 y220 w110", "Maximize").OnEvent("Click", (*) => WinMaximize(myGui.Hwnd))
    myGui.Add("Button", "x260 y220 w110", "Restore").OnEvent("Click", (*) => WinRestore(myGui.Hwnd))

    myGui.Add("Button", "x20 y250 w350", "Clear History").OnEvent("Click", (*) => historyEdit.Value := "Window State History:`n")
    myGui.Add("Button", "x20 y280 w350", "Close").OnEvent("Click", (*) => myGui.Destroy())

    myGui.Show("w400 h330")
    LogState("Window created and shown")
}

; =============================================================================
; Example 6: Simple Dialog Boxes
; =============================================================================

/**
 * Creates simple dialog boxes for common tasks
 * Input dialogs, confirmation dialogs, about dialogs
 */
Example6_SimpleDialogs() {
    mainGui := Gui(, "Dialog Box Examples")
    mainGui.BackColor := "White"

    mainGui.Add("Text", "x20 y20 w360 h30", "Click buttons to show different types of dialog boxes:")

    resultText := mainGui.Add("Text", "x20 y60 w360 h80 Border", "Result will appear here...")

    ; Input dialog button
    inputBtn := mainGui.Add("Button", "x20 y150 w170", "Input Dialog")
    inputBtn.OnEvent("Click", (*) => ShowInputDialog())

    ; Confirmation dialog button
    confirmBtn := mainGui.Add("Button", "x200 y150 w170", "Confirmation Dialog")
    confirmBtn.OnEvent("Click", (*) => ShowConfirmDialog())

    ; About dialog button
    aboutBtn := mainGui.Add("Button", "x20 y180 w170", "About Dialog")
    aboutBtn.OnEvent("Click", (*) => ShowAboutDialog())

    ; Choice dialog button
    choiceBtn := mainGui.Add("Button", "x200 y180 w170", "Choice Dialog")
    choiceBtn.OnEvent("Click", (*) => ShowChoiceDialog())

    mainGui.Add("Button", "x20 y220 w350", "Close").OnEvent("Click", (*) => mainGui.Destroy())

    mainGui.Show("w400 h270")

    ShowInputDialog() {
        dialogGui := Gui("+Owner" mainGui.Hwnd " +ToolWindow", "Input Dialog")
        dialogGui.Add("Text", "x20 y20", "Please enter your name:")
        nameEdit := dialogGui.Add("Edit", "x20 y45 w260")
        nameEdit.Focus()

        okBtn := dialogGui.Add("Button", "x20 y80 w100 Default", "OK")
        okBtn.OnEvent("Click", SubmitInput)

        cancelBtn := dialogGui.Add("Button", "x130 y80 w100", "Cancel")
        cancelBtn.OnEvent("Click", (*) => (dialogGui.Destroy(), mainGui.Opt("-Disabled")))

        dialogGui.OnEvent("Escape", (*) => (dialogGui.Destroy(), mainGui.Opt("-Disabled")))

        SubmitInput(*) {
            name := nameEdit.Value
            dialogGui.Destroy()
            mainGui.Opt("-Disabled")
            resultText.Value := "You entered: " (name != "" ? name : "[Empty]")
        }

        dialogGui.Show("w300 h130")
        mainGui.Opt("+Disabled")
    }

    ShowConfirmDialog() {
        dialogGui := Gui("+Owner" mainGui.Hwnd " +ToolWindow", "Confirm Action")
        dialogGui.Add("Text", "x20 y20 w260", "Are you sure you want to proceed?")
        dialogGui.Add("Text", "x20 y45 w260", "This action cannot be undone.")

        yesBtn := dialogGui.Add("Button", "x20 y80 w100 Default", "Yes")
        yesBtn.OnEvent("Click", (*) => (dialogGui.Destroy(), mainGui.Opt("-Disabled"), resultText.Value := "User clicked: YES"))

        noBtn := dialogGui.Add("Button", "x130 y80 w100", "No")
        noBtn.OnEvent("Click", (*) => (dialogGui.Destroy(), mainGui.Opt("-Disabled"), resultText.Value := "User clicked: NO"))

        dialogGui.OnEvent("Escape", (*) => (dialogGui.Destroy(), mainGui.Opt("-Disabled")))

        dialogGui.Show("w300 h130")
        mainGui.Opt("+Disabled")
    }

    ShowAboutDialog() {
        aboutGui := Gui("+Owner" mainGui.Hwnd " +ToolWindow", "About")
        aboutGui.BackColor := "White"

        aboutGui.SetFont("s12 Bold")
        aboutGui.Add("Text", "x20 y20 w260 Center", "My Application v2.0")
        aboutGui.SetFont("s9 Norm")
        aboutGui.Add("Text", "x20 y50 w260 Center", "Created with AutoHotkey v2")
        aboutGui.Add("Text", "x20 y75 w260 Center", "© 2024 AHK Community")
        aboutGui.Add("Text", "x20 y100 w260 Center", "All rights reserved")

        aboutGui.Add("Button", "x90 y140 w120", "OK").OnEvent("Click", (*) => (aboutGui.Destroy(), mainGui.Opt("-Disabled")))

        aboutGui.Show("w300 h185")
        mainGui.Opt("+Disabled")
    }

    ShowChoiceDialog() {
        choiceGui := Gui("+Owner" mainGui.Hwnd " +ToolWindow", "Make a Choice")
        choiceGui.Add("Text", "x20 y20 w260", "Select your favorite programming language:")

        ddl := choiceGui.Add("DropDownList", "x20 y50 w260", ["AutoHotkey", "Python", "JavaScript", "C++", "Java"])
        ddl.Choose(1)

        okBtn := choiceGui.Add("Button", "x20 y90 w100 Default", "OK")
        okBtn.OnEvent("Click", SubmitChoice)

        cancelBtn := choiceGui.Add("Button", "x130 y90 w100", "Cancel")
        cancelBtn.OnEvent("Click", (*) => (choiceGui.Destroy(), mainGui.Opt("-Disabled")))

        SubmitChoice(*) {
            choice := ddl.Text
            choiceGui.Destroy()
            mainGui.Opt("-Disabled")
            resultText.Value := "You selected: " choice
        }

        choiceGui.Show("w300 h140")
        mainGui.Opt("+Disabled")
    }
}

; =============================================================================
; Example 7: Window Cleanup and Destruction
; =============================================================================

/**
 * Demonstrates proper window cleanup and destruction
 * Shows different ways to close windows and clean up resources
 */
Example7_WindowCleanup() {
    mainGui := Gui(, "Window Cleanup Demo")
    mainGui.BackColor := "0xFFF0F0"

    mainGui.Add("Text", "x20 y20 w360", "Demonstrates proper window cleanup:")

    logEdit := mainGui.Add("Edit", "x20 y50 w360 h150 ReadOnly Multi", "Event Log:`n")

    LogEvent(msg) {
        timestamp := FormatTime(A_Now, "HH:mm:ss")
        logEdit.Value .= Format("[{1}] {2}`n", timestamp, msg)
    }

    ; Create child window button
    createBtn := mainGui.Add("Button", "x20 y220 w170", "Create Child Window")
    createBtn.OnEvent("Click", (*) => CreateChildWindow())

    ; Clear log button
    clearBtn := mainGui.Add("Button", "x200 y220 w170", "Clear Log")
    clearBtn.OnEvent("Click", (*) => logEdit.Value := "Event Log:`n")

    ; Close button with cleanup
    closeBtn := mainGui.Add("Button", "x20 y250 w350", "Close (with cleanup)")
    closeBtn.OnEvent("Click", CloseWithCleanup)

    mainGui.OnEvent("Close", CloseWithCleanup)

    mainGui.Show("w400 h300")
    LogEvent("Main window created")

    childWindows := []

    CreateChildWindow() {
        childGui := Gui("+Owner" mainGui.Hwnd " +ToolWindow", "Child Window #" (childWindows.Length + 1))
        childGui.BackColor := "0xF0FFF0"

        childGui.Add("Text", "x20 y20 w260", "This is child window #" (childWindows.Length + 1))
        childGui.Add("Text", "x20 y45 w260", "It will be closed when parent closes")

        childGui.Add("Button", "x20 y80 w100", "Close").OnEvent("Click", (*) => DestroyChild(childGui))

        childGui.OnEvent("Close", (*) => DestroyChild(childGui))

        childGui.Show("w300 h130")
        childWindows.Push(childGui)

        LogEvent("Created child window #" childWindows.Length)
    }

    DestroyChild(childGui) {
        ; Find and remove from array
        for index, gui in childWindows {
            if (gui.Hwnd = childGui.Hwnd) {
                childWindows.RemoveAt(index)
                LogEvent("Child window destroyed")
                break
            }
        }
        childGui.Destroy()
    }

    CloseWithCleanup(*) {
        LogEvent("Starting cleanup process...")

        ; Close all child windows
        for childGui in childWindows {
            try {
                childGui.Destroy()
                LogEvent("Closed child window")
            }
        }

        LogEvent("All child windows closed")
        LogEvent("Main window closing")

        ; Small delay to show final log messages
        Sleep(500)
        mainGui.Destroy()
    }
}

; =============================================================================
; Main Menu - Example Launcher
; =============================================================================

/**
 * Creates a main menu to launch all examples
 */
ShowMainMenu() {
    menuGui := Gui(, "BuiltIn_Gui_01 - Basic GUI Examples")
    menuGui.BackColor := "White"

    menuGui.SetFont("s10 Bold")
    menuGui.Add("Text", "x20 y20 w360", "Basic GUI Creation Examples")
    menuGui.SetFont("s9 Norm")

    menuGui.Add("Text", "x20 y50 w360", "Select an example to run:")

    ; Example buttons
    menuGui.Add("Button", "x20 y80 w360", "Example 1: Simple Window Creation").OnEvent("Click", (*) => Example1_SimpleWindow())
    menuGui.Add("Button", "x20 y110 w360", "Example 2: Window Properties").OnEvent("Click", (*) => Example2_WindowProperties())
    menuGui.Add("Button", "x20 y140 w360", "Example 3: Window Positioning").OnEvent("Click", (*) => Example3_WindowPositioning())
    menuGui.Add("Button", "x20 y170 w360", "Example 4: Modal vs Modeless").OnEvent("Click", (*) => Example4_ModalModeless())
    menuGui.Add("Button", "x20 y200 w360", "Example 5: Window State Management").OnEvent("Click", (*) => Example5_WindowState())
    menuGui.Add("Button", "x20 y230 w360", "Example 6: Simple Dialogs").OnEvent("Click", (*) => Example6_SimpleDialogs())
    menuGui.Add("Button", "x20 y260 w360", "Example 7: Window Cleanup").OnEvent("Click", (*) => Example7_WindowCleanup())

    menuGui.Add("Button", "x20 y300 w360", "Exit").OnEvent("Click", (*) => ExitApp())

    menuGui.Show("w400 h350")
}

; Show the main menu
ShowMainMenu()
