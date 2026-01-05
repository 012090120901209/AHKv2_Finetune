#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Examples - Run Function (Part 1: Basic Program Execution)
 * ============================================================================
 * 
 * The Run function launches external programs, documents, URLs, or shortcuts.
 * 
 * @description Examples demonstrating basic program execution with Run
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * SYNTAX:
 *   Run(Target [, WorkingDir, Options, &OutputVarPID])
 * 
 * PARAMETERS:
 *   - Target: Program/document/URL to run
 *   - WorkingDir: Working directory (optional)
 *   - Options: "Max", "Min", "Hide" (optional)
 *   - OutputVarPID: Variable to receive Process ID (optional)
 * 
 * COMMON USE CASES:
 *   - Launching applications
 *   - Opening documents
 *   - Opening URLs in default browser
 *   - Starting system utilities
 *   - Creating application launchers
 */

; ============================================================================
; Example 1: Basic Program Launching
; ============================================================================
; Demonstrates launching various types of programs and files

Example1_BasicLaunching() {
    MsgBox("Example 1: Basic Program Launching`n`n" .
        "This example shows how to launch different types of programs:",
        "Run - Example 1", "Icon!")

    ; Launch Notepad
    try {
        Run("notepad.exe")
        MsgBox("Launched: Notepad", "Success", "T2")
    } catch Error as err {
        MsgBox("Failed to launch Notepad: " . err.Message, "Error")
    }

    Sleep(2000)

    ; Launch Calculator
    try {
        Run("calc.exe")
        MsgBox("Launched: Calculator", "Success", "T2")
    } catch Error as err {
        MsgBox("Failed to launch Calculator: " . err.Message, "Error")
    }

    Sleep(2000)

    ; Launch Windows Explorer at C:\
    try {
        Run("explorer.exe C:\")
        MsgBox("Launched: Explorer at C:\", "Success", "T2")
    } catch Error as err {
        MsgBox("Failed to launch Explorer: " . err.Message, "Error")
    }

    Sleep(2000)

    ; Launch Windows Settings (modern apps)
    try {
        Run("ms-settings:")
        MsgBox("Launched: Windows Settings", "Success", "T2")
    } catch Error as err {
        MsgBox("Failed to launch Settings: " . err.Message, "Error")
    }

    Sleep(2000)

    ; Open a website in default browser
    try {
        Run("https://www.autohotkey.com")
        MsgBox("Opened: AutoHotkey website in default browser", "Success", "T2")
    } catch Error as err {
        MsgBox("Failed to open website: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: Capturing Process IDs
; ============================================================================
; Shows how to capture and use the Process ID of launched programs

Example2_CaptureProcessID() {
    MsgBox("Example 2: Capturing Process IDs`n`n" .
        "Launch programs and track their Process IDs:",
        "Run - Example 2", "Icon!")

    ; Launch notepad and capture its PID
    try {
        Run("notepad.exe", , , &notepadPID)
        MsgBox("Notepad launched with PID: " . notepadPID, "Process ID", "T3")

        ; Wait a moment
        Sleep(2000)

        ; Check if process still exists
        if ProcessExist(notepadPID) {
            MsgBox("Notepad (PID: " . notepadPID . ") is still running.", "Status", "T3")
        }

        ; Close the notepad we just launched
        if ProcessExist(notepadPID) {
            ProcessClose(notepadPID)
            MsgBox("Closed Notepad (PID: " . notepadPID . ")", "Cleanup", "T2")
        }

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 3: Window State Control
; ============================================================================
; Demonstrates launching programs with different window states

Example3_WindowStates() {
    MsgBox("Example 3: Window State Control`n`n" .
        "Launch programs with different window states:",
        "Run - Example 3", "Icon!")

    ; Launch maximized
    try {
        Run("notepad.exe", , "Max", &pid1)
        MsgBox("Launched Notepad MAXIMIZED (PID: " . pid1 . ")", "Max State", "T2")
        Sleep(2000)
        if ProcessExist(pid1)
            ProcessClose(pid1)
    }

    Sleep(1000)

    ; Launch minimized
    try {
        Run("notepad.exe", , "Min", &pid2)
        MsgBox("Launched Notepad MINIMIZED (PID: " . pid2 . ")", "Min State", "T2")
        Sleep(2000)
        if ProcessExist(pid2)
            ProcessClose(pid2)
    }

    Sleep(1000)

    ; Launch hidden
    try {
        Run("notepad.exe", , "Hide", &pid3)
        MsgBox("Launched Notepad HIDDEN (PID: " . pid3 . ")`n" .
            "It's running but not visible!", "Hide State", "T2")
        Sleep(2000)
        if ProcessExist(pid3)
            ProcessClose(pid3)
    }
}

; ============================================================================
; Example 4: Command Line Arguments
; ============================================================================
; Shows how to pass arguments to programs

Example4_CommandLineArgs() {
    MsgBox("Example 4: Command Line Arguments`n`n" .
        "Pass arguments to programs when launching:",
        "Run - Example 4", "Icon!")

    ; Create a test file first
    testFile := A_Temp . "\ahk_test_run.txt"
    try {
        FileAppend("This is a test file created by AHK v2`n" .
            "Demonstrating Run with command line arguments.", testFile)
    }

    ; Open specific file in notepad
    if FileExist(testFile) {
        try {
            Run("notepad.exe `"" . testFile . "`"", , , &pid)
            MsgBox("Opened test file in Notepad (PID: " . pid . ")`n" .
                "File: " . testFile, "With Arguments", "T3")

            Sleep(3000)

            if ProcessExist(pid)
                ProcessClose(pid)

        } catch Error as err {
            MsgBox("Error opening file: " . err.Message, "Error")
        }
    }

    ; Run CMD with specific command
    try {
        Run('cmd.exe /k echo Hello from AutoHotkey v2 && echo Current directory: %CD%', , , &cmdPID)
        MsgBox("Launched CMD with custom commands (PID: " . cmdPID . ")`n" .
            "Notice the /k parameter keeps CMD open.", "CMD Example", "T3")

        Sleep(3000)

        if ProcessExist(cmdPID)
            ProcessClose(cmdPID)

    } catch Error as err {
        MsgBox("Error launching CMD: " . err.Message, "Error")
    }

    ; Cleanup
    if FileExist(testFile) {
        try FileDelete(testFile)
    }
}

; ============================================================================
; Example 5: Application Launcher GUI
; ============================================================================
; A practical application launcher with custom buttons

Example5_ApplicationLauncher() {
    /**
     * Creates a simple application launcher window with buttons for
     * frequently used programs. Demonstrates practical use of Run.
     */

    ; Create the launcher GUI
    launcher := Gui("+AlwaysOnTop", "Quick Application Launcher")
    launcher.SetFont("s10")

    ; Add descriptive text
    launcher.Add("Text", "w300", "Click a button to launch an application:")

    ; Add separator
    launcher.Add("Text", "w300 0x10")  ; 0x10 = SS_SUNKEN

    ; Add launch buttons in a grid
    launcher.Add("Button", "w140 h40", "📝 Notepad").OnEvent("Click", (*) => LaunchApp("notepad.exe", "Notepad"))
    launcher.Add("Button", "x+10 yp w140 h40", "🧮 Calculator").OnEvent("Click", (*) => LaunchApp("calc.exe", "Calculator"))

    launcher.Add("Button", "xm w140 h40", "📁 Explorer").OnEvent("Click", (*) => LaunchApp("explorer.exe", "Explorer"))
    launcher.Add("Button", "x+10 yp w140 h40", "🎨 Paint").OnEvent("Click", (*) => LaunchApp("mspaint.exe", "Paint"))

    launcher.Add("Button", "xm w140 h40", "⚙️ Settings").OnEvent("Click", (*) => LaunchApp("ms-settings:", "Settings"))
    launcher.Add("Button", "x+10 yp w140 h40", "💻 Task Manager").OnEvent("Click", (*) => LaunchApp("taskmgr.exe", "Task Manager"))

    launcher.Add("Button", "xm w140 h40", "🌐 Browser").OnEvent("Click", (*) => LaunchApp("https://www.google.com", "Browser"))
    launcher.Add("Button", "x+10 yp w140 h40", "📧 Mail").OnEvent("Click", (*) => LaunchApp("mailto:", "Email"))

    ; Add separator
    launcher.Add("Text", "xm w300 0x10")

    ; Add status bar
    statusText := launcher.Add("Text", "w300 h30 +Border", "Ready to launch applications...")

    ; Add close button
    launcher.Add("Button", "w300 h30", "Close Launcher").OnEvent("Click", (*) => launcher.Destroy())

    /**
     * Launch application helper function
     * @param {String} target - Program to launch
     * @param {String} name - Display name
     */
    LaunchApp(target, name) {
        try {
            Run(target, , , &pid)
            statusText.Text := "✓ Launched: " . name . " (PID: " . pid . ")"
        } catch Error as err {
            statusText.Text := "✗ Failed to launch " . name . ": " . err.Message
        }
    }

    launcher.Show()

    ; Show instruction message
    MsgBox("Application Launcher Created!`n`n" .
        "Click any button to launch the corresponding application.`n" .
        "The status bar shows launch results with Process IDs.`n`n" .
        "Close the launcher window when done.",
        "Example 5 - Application Launcher", "Icon!")
}

; ============================================================================
; Example 6: Smart Document Opener
; ============================================================================
; Opens documents in their associated programs

Example6_DocumentOpener() {
    MsgBox("Example 6: Smart Document Opener`n`n" .
        "Opens documents with their default associated programs:",
        "Run - Example 6", "Icon!")

    ; Create test files with different extensions
    testDir := A_Temp . "\ahk_doc_test"

    try {
        ; Create directory if it doesn't exist
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create test files
        testFiles := Map()

        ; Text file
        txtFile := testDir . "\test.txt"
        FileAppend("This is a test text file.", txtFile)
        testFiles["Text File (.txt)"] := txtFile

        ; HTML file
        htmlFile := testDir . "\test.html"
        FileAppend("<html><body><h1>Test HTML File</h1></body></html>", htmlFile)
        testFiles["HTML File (.html)"] := htmlFile

        ; CSV file
        csvFile := testDir . "\test.csv"
        FileAppend("Name,Age,City`nJohn,30,NYC`nJane,25,LA", csvFile)
        testFiles["CSV File (.csv)"] := csvFile

        ; Show what we'll open
        fileList := ""
        for description, path in testFiles {
            fileList .= description . "`n"
        }

        MsgBox("Created test files:`n" . fileList . "`nOpening each file...",
            "Files Created", "T3")

        ; Open each file with its associated program
        for description, path in testFiles {
            if FileExist(path) {
                try {
                    Run(path)
                    MsgBox("Opened: " . description . "`n" .
                        "Path: " . path, "File Opened", "T2")
                    Sleep(2000)
                } catch Error as err {
                    MsgBox("Failed to open " . description . "`n" .
                        "Error: " . err.Message, "Error")
                }
            }
        }

        MsgBox("All test files have been opened in their associated programs.`n`n" .
            "Files are located in: " . testDir . "`n" .
            "You can delete this folder when done.",
            "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error creating test files: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 7: URL Handler and Protocol Launcher
; ============================================================================
; Demonstrates opening various URL protocols

Example7_URLProtocols() {
    MsgBox("Example 7: URL Protocols and Handlers`n`n" .
        "Launch various URL protocols and special URIs:",
        "Run - Example 7", "Icon!")

    ; Array of different protocols to demonstrate
    protocols := [{
        name: "HTTP Website", url: "https://www.autohotkey.com" }, {
            name: "Email Client", url: "mailto:example@email.com?subject=Test&body=Hello" }, {
                name: "Windows Settings", url: "ms-settings:windowsupdate" }, {
                    name: "Microsoft Store", url: "ms-windows-store:" }, {
                        name: "File Explorer", url: "file:///" . A_WinDir },
    ]

    ; Show available protocols
    protocolList := ""
    for index, protocol in protocols {
        protocolList .= index . ". " . protocol.name . "`n"
    }

    result := MsgBox("Available protocols to test:`n`n" . protocolList . "`n" .
        "Launch all protocols?",
        "Protocol Launcher", "YesNo Icon?")

    if result = "Yes" {
        for index, protocol in protocols {
            try {
                Run(protocol.url)
                MsgBox("Launched: " . protocol.name . "`n" .
                    "URL: " . protocol.url, "Protocol " . index, "T2")
                Sleep(1500)
            } catch Error as err {
                MsgBox("Failed to launch: " . protocol.name . "`n" .
                    "Error: " . err.Message, "Error", "T3")
            }
        }

        MsgBox("All protocol launches attempted.", "Complete", "Icon!")
    }
}

; ============================================================================
; Main Menu - Run All Examples
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "Run Function Examples - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w400", "AutoHotkey v2 - Run Function Examples")
    menu.SetFont("s9")
    menu.Add("Text", "w400", "Select an example to run:")

    menu.Add("Button", "w400 h35", "Example 1: Basic Program Launching").OnEvent("Click", (*) => (menu.Hide(), Example1_BasicLaunching(), menu.Show()))
    menu.Add("Button", "w400 h35", "Example 2: Capturing Process IDs").OnEvent("Click", (*) => (menu.Hide(), Example2_CaptureProcessID(), menu.Show()))
    menu.Add("Button", "w400 h35", "Example 3: Window State Control").OnEvent("Click", (*) => (menu.Hide(), Example3_WindowStates(), menu.Show()))
    menu.Add("Button", "w400 h35", "Example 4: Command Line Arguments").OnEvent("Click", (*) => (menu.Hide(), Example4_CommandLineArgs(), menu.Show()))
    menu.Add("Button", "w400 h35", "Example 5: Application Launcher GUI").OnEvent("Click", (*) => (menu.Hide(), Example5_ApplicationLauncher(), menu.Show()))
    menu.Add("Button", "w400 h35", "Example 6: Smart Document Opener").OnEvent("Click", (*) => (menu.Hide(), Example6_DocumentOpener(), menu.Show()))
    menu.Add("Button", "w400 h35", "Example 7: URL Protocols and Handlers").OnEvent("Click", (*) => (menu.Hide(), Example7_URLProtocols(), menu.Show()))

    menu.Add("Text", "w400 0x10")
    menu.Add("Button", "w400 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

; Show the main menu when script starts
ShowMainMenu()
