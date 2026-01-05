#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Examples - Run Function (Part 2: Parameters and Working Dir)
 * ============================================================================
 * 
 * Advanced usage of Run with command-line parameters and working directories.
 * 
 * @description Examples for parameters, arguments, and working directory control
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * WORKING DIRECTORY:
 *   The WorkingDir parameter sets the initial current directory for the program.
 *   This is important for programs that load files relative to their working directory.
 * 
 * PARAMETER ESCAPING:
 *   - Use quotes for paths with spaces: "C:\Program Files\..."
 *   - Escape quotes in parameters: `"
 *   - Build complex command lines carefully
 */

; ============================================================================
; Example 1: Working Directory Control
; ============================================================================
; Demonstrates how working directory affects program behavior

Example1_WorkingDirectory() {
    MsgBox("Example 1: Working Directory Control`n`n" .
        "See how different working directories affect program behavior:",
        "Run - Example 1", "Icon!")

    ; Create test structure
    baseDir := A_Temp . "\ahk_workdir_test"
    dir1 := baseDir . "\Directory1"
    dir2 := baseDir . "\Directory2"

    try {
        ; Create directories
        if !DirExist(baseDir)
            DirCreate(baseDir)
        if !DirExist(dir1)
            DirCreate(dir1)
        if !DirExist(dir2)
            DirCreate(dir2)

        ; Create test files in each directory
        FileAppend("This file is in Directory1", dir1 . "\file1.txt")
        FileAppend("This file is in Directory2", dir2 . "\file2.txt")

        MsgBox("Created test structure:`n" .
            "Base: " . baseDir . "`n" .
            "Dir1: " . dir1 . "\file1.txt`n" .
            "Dir2: " . dir2 . "\file2.txt",
            "Structure Created", "T3")

        ; Open CMD in Directory1
        Run("cmd.exe /k dir", dir1, , &pid1)
        MsgBox("Opened CMD in Directory1 (PID: " . pid1 . ")`n" .
            "Notice the current directory in CMD.", "Working Dir 1", "T3")

        Sleep(2000)

        ; Open CMD in Directory2
        Run("cmd.exe /k dir", dir2, , &pid2)
        MsgBox("Opened CMD in Directory2 (PID: " . pid2 . ")`n" .
            "Notice how the directory differs from the first one.", "Working Dir 2", "T3")

        Sleep(2000)

        ; Cleanup
        if ProcessExist(pid1)
            ProcessClose(pid1)
        if ProcessExist(pid2)
            ProcessClose(pid2)

        MsgBox("Test complete. The working directory determines where the program starts.`n`n" .
            "Test files are in: " . baseDir, "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: Complex Command Line Building
; ============================================================================
; Shows how to build complex command lines with proper escaping

Example2_ComplexCommands() {
    MsgBox("Example 2: Complex Command Lines`n`n" .
        "Build and execute complex commands with parameters:",
        "Run - Example 2", "Icon!")

    ; Example 1: PowerShell with complex command
    psCommand := 'powershell.exe -NoProfile -Command "Get-Process | Where-Object {$_.WorkingSet -gt 100MB} | Select-Object -First 5 Name,WorkingSet | Format-Table"'

    result := MsgBox("Execute PowerShell command to show top 5 processes by memory?`n`n" .
        "Command: " . psCommand,
        "PowerShell Example", "YesNo Icon?")

    if result = "Yes" {
        try {
            Run(psCommand, , , &psPID)
            MsgBox("Launched PowerShell command (PID: " . psPID . ")`n" .
                "Window will close automatically after showing results.", "Launched", "T3")
        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error")
        }
    }

    Sleep(2000)

    ; Example 2: CMD with multiple commands chained
    cmdCommand := 'cmd.exe /k "echo Current System Info & echo. & systeminfo | findstr /B /C:"OS Name" /C:"OS Version" /C:"System Type" & echo. & pause"'

    result := MsgBox("Execute CMD command to show system information?`n`n" .
        "This demonstrates command chaining with &",
        "CMD Example", "YesNo Icon?")

    if result = "Yes" {
        try {
            Run(cmdCommand, , , &cmdPID)
            MsgBox("Launched CMD command (PID: " . cmdPID . ")`n" .
                "Press any key in the CMD window to close it.", "Launched", "T3")

            Sleep(5000)
            if ProcessExist(cmdPID)
                ProcessClose(cmdPID)

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error")
        }
    }
}

; ============================================================================
; Example 3: Program with Multiple Parameters
; ============================================================================
; Demonstrates passing multiple parameters to programs

Example3_MultipleParameters() {
    MsgBox("Example 3: Multiple Parameters`n`n" .
        "Pass multiple parameters and switches to programs:",
        "Run - Example 3", "Icon!")

    ; Create test directory and files
    testDir := A_Temp . "\ahk_params_test"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create several test files
        testFiles := []
        Loop 5 {
            fileName := testDir . "\test_file_" . A_Index . ".txt"
            FileAppend("Test file number " . A_Index . "`nCreated: " . A_Now, fileName)
            testFiles.Push(fileName)
        }

        MsgBox("Created " . testFiles.Length . " test files in:`n" . testDir,
            "Files Created", "T2")

        ; Example 1: Open Explorer with specific folder selected
        if testFiles.Length > 0 {
            explorerCmd := 'explorer.exe /select,"' . testFiles[1] . '"'

            Run(explorerCmd)
            MsgBox("Opened Explorer with first file selected using /select parameter",
                "Explorer Parameters", "T3")
        }

        Sleep(2000)

        ; Example 2: Open multiple Notepad instances with different files
        result := MsgBox("Open multiple Notepad windows with different files?`n`n" .
            "This will open " . Min(3, testFiles.Length) . " Notepad instances.",
            "Multiple Notepads", "YesNo Icon?")

        if result = "Yes" {
            pids := []
            Loop Min(3, testFiles.Length) {
                notepadCmd := 'notepad.exe "' . testFiles[A_Index] . '"'
                Run(notepadCmd, , , &pid)
                pids.Push(pid)
                Sleep(500)
            }

            MsgBox("Opened " . pids.Length . " Notepad instances.`n" .
                "PIDs: " . pids.Join(", "), "Opened", "T3")

            Sleep(3000)

            ; Close all opened Notepads
            for pid in pids {
                if ProcessExist(pid)
                    ProcessClose(pid)
            }
        }

        MsgBox("Test files remain in: " . testDir . "`n" .
            "You can delete this folder when done.", "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 4: Environment Variables in Commands
; ============================================================================
; Using environment variables in Run commands

Example4_EnvironmentVariables() {
    MsgBox("Example 4: Environment Variables`n`n" .
        "Use environment variables in Run commands:",
        "Run - Example 4", "Icon!")

    ; Get some common environment variables
    userProfile := EnvGet("USERPROFILE")
    systemRoot := EnvGet("SystemRoot")
    programFiles := EnvGet("ProgramFiles")

    envInfo := "Current Environment Variables:`n`n" .
        "USERPROFILE: " . userProfile . "`n" .
        "SystemRoot: " . systemRoot . "`n" .
        "ProgramFiles: " . programFiles

    MsgBox(envInfo, "Environment", "Icon!")

    ; Example 1: Open user profile folder
    try {
        Run("explorer.exe " . userProfile)
        MsgBox("Opened user profile folder:`n" . userProfile, "User Profile", "T2")
    }

    Sleep(2000)

    ; Example 2: Open System32 using environment variable
    try {
        sys32Path := systemRoot . "\System32"
        Run("explorer.exe " . sys32Path)
        MsgBox("Opened System32 folder:`n" . sys32Path, "System32", "T2")
    }

    Sleep(2000)

    ; Example 3: Use CMD with environment variables
    cmdLine := 'cmd.exe /k "echo User Profile: %USERPROFILE% & echo System Root: %SystemRoot% & echo. & pause"'

    try {
        Run(cmdLine, , , &pid)
        MsgBox("Launched CMD showing environment variables (PID: " . pid . ")`n" .
            "CMD can access environment variables directly with %VAR% syntax.", "CMD Env Vars", "T3")

        Sleep(4000)
        if ProcessExist(pid)
            ProcessClose(pid)
    }
}

; ============================================================================
; Example 5: Batch File Executor
; ============================================================================
; Create and execute batch files with parameters

Example5_BatchExecutor() {
    MsgBox("Example 5: Batch File Executor`n`n" .
        "Create and execute batch files with parameters:",
        "Run - Example 5", "Icon!")

    batchDir := A_Temp . "\ahk_batch_test"

    try {
        ; Create directory
        if !DirExist(batchDir)
            DirCreate(batchDir)

        ; Create a batch file that accepts parameters
        batchFile := batchDir . "\test_batch.bat"
        batchContent := "
        (
        @echo off
        echo ========================================
        echo Batch File Parameter Test
        echo ========================================
        echo.
        echo Parameter 1: %1
        echo Parameter 2: %2
        echo Parameter 3: %3
        echo.
        echo All Parameters: %*
        echo.
        echo Current Directory: %CD%
        echo Batch File Location: %~dp0
        echo.
        pause
        )"

        FileAppend(batchContent, batchFile)

        MsgBox("Created batch file:`n" . batchFile . "`n`n" .
            "The batch file will display parameters passed to it.", "Batch Created", "T3")

        ; Execute batch file with parameters
        param1 := "Hello"
        param2 := "AutoHotkey"
        param3 := "v2.0"

        ; Build command with parameters
        batchCmd := '"' . batchFile . '" "' . param1 . '" "' . param2 . '" "' . param3 . '"'

        Run('cmd.exe /k ' . batchCmd, batchDir, , &pid)

        MsgBox("Executed batch file with parameters:`n" .
            "Param1: " . param1 . "`n" .
            "Param2: " . param2 . "`n" .
            "Param3: " . param3 . "`n`n" .
            "Working Directory: " . batchDir, "Batch Executed", "T4")

        Sleep(5000)

        if ProcessExist(pid)
            ProcessClose(pid)

        MsgBox("Batch file test complete.`n" .
            "Files remain in: " . batchDir, "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 6: Advanced Program Launcher with Parameters
; ============================================================================
; GUI for launching programs with custom parameters

Example6_AdvancedLauncher() {
    /**
     * Creates an advanced launcher that allows specifying:
     * - Target program
     * - Command-line parameters
     * - Working directory
     * - Window state
     */

    launcher := Gui("+Resize", "Advanced Program Launcher")
    launcher.SetFont("s10")

    ; Program/File
    launcher.Add("Text", "w400", "Program or File to Run:")
    programEdit := launcher.Add("Edit", "w350", "notepad.exe")
    launcher.Add("Button", "x+5 yp w40 h23", "...").OnEvent("Click", BrowseProgram)

    ; Parameters
    launcher.Add("Text", "xm w400", "Command-Line Parameters:")
    paramsEdit := launcher.Add("Edit", "w400")

    ; Working Directory
    launcher.Add("Text", "w400", "Working Directory (optional):")
    workdirEdit := launcher.Add("Edit", "w350", A_ScriptDir)
    launcher.Add("Button", "x+5 yp w40 h23", "...").OnEvent("Click", BrowseWorkDir)

    ; Window State
    launcher.Add("Text", "xm w400", "Window State:")
    stateDD := launcher.Add("DropDownList", "w400", ["Normal", "Max", "Min", "Hide"])
    stateDD.Choose(1)

    ; Capture PID checkbox
    capturePIDCheck := launcher.Add("Checkbox", "w400", "Capture and display Process ID")
    capturePIDCheck.Value := 1

    ; Status text
    statusText := launcher.Add("Text", "w400 h40 +Border", "Ready to launch...")

    ; Buttons
    launcher.Add("Button", "w195 h35", "Launch Program").OnEvent("Click", LaunchProgram)
    launcher.Add("Button", "x+10 yp w195 h35", "Clear All").OnEvent("Click", ClearAll)

    launcher.Add("Button", "xm w400 h30", "Close").OnEvent("Click", (*) => launcher.Destroy())

    ; Browse for program
    BrowseProgram(*) {
        selected := FileSelect(3, , "Select Program or File", "Programs (*.exe; *.bat; *.cmd)")
        if selected
            programEdit.Value := selected
    }

    ; Browse for working directory
    BrowseWorkDir(*) {
        selected := DirSelect(, 3, "Select Working Directory")
        if selected
            workdirEdit.Value := selected
    }

    ; Clear all fields
    ClearAll(*) {
        programEdit.Value := ""
        paramsEdit.Value := ""
        workdirEdit.Value := ""
        stateDD.Choose(1)
        capturePIDCheck.Value := 1
        statusText.Text := "Ready to launch..."
    }

    ; Launch the program
    LaunchProgram(*) {
        program := Trim(programEdit.Value)
        params := Trim(paramsEdit.Value)
        workdir := Trim(workdirEdit.Value)
        stateOptions := ["", "Max", "Min", "Hide"]
        state := stateOptions[stateDD.Value]

        if program = "" {
            statusText.Text := "❌ Error: No program specified!"
            return
        }

        ; Build command
        command := program
        if params != ""
            command .= " " . params

        ; Use working directory if specified
        useWorkDir := (workdir != "") ? workdir : ""

        try {
            if capturePIDCheck.Value {
                Run(command, useWorkDir, state, &pid)
                statusText.Text := "✓ Launched: " . program . "`nPID: " . pid . " | State: " . (state = "" ? "Normal" : state)
            } else {
                Run(command, useWorkDir, state)
                statusText.Text := "✓ Launched: " . program . "`nState: " . (state = "" ? "Normal" : state)
            }
        } catch Error as err {
            statusText.Text := "❌ Failed to launch!`nError: " . err.Message
        }
    }

    launcher.Show()

    MsgBox("Advanced Program Launcher Created!`n`n" .
        "Features:`n" .
        "• Specify program/file to run`n" .
        "• Add command-line parameters`n" .
        "• Set working directory`n" .
        "• Choose window state`n" .
        "• Capture process ID`n`n" .
        "Try launching different programs with various options!",
        "Example 6", "Icon!")
}

; ============================================================================
; Example 7: Run with Elevated Privileges (RunAs)
; ============================================================================
; Demonstrates running programs with administrator privileges

Example7_RunAsAdmin() {
    MsgBox("Example 7: Run with Administrator Privileges`n`n" .
        "Some programs require administrator privileges to run properly.`n" .
        "We'll use the 'RunAs' verb to request elevation.",
        "Run - Example 7", "Icon!")

    result := MsgBox("Attempt to open Registry Editor with admin privileges?`n`n" .
        "You may see a UAC prompt if UAC is enabled.",
        "RunAs Example", "YesNo Icon?")

    if result = "Yes" {
        try {
            ; Using *RunAs prefix to request elevation
            Run("*RunAs regedit.exe", , , &pid)

            MsgBox("Launched Registry Editor with admin request (PID: " . pid . ")`n`n" .
                "Note: The *RunAs prefix triggers a UAC prompt on Vista+.",
                "Launched", "Icon! T3")

            Sleep(2000)

            ; Close regedit
            if ProcessExist(pid) {
                result2 := MsgBox("Close Registry Editor now?", "Close?", "YesNo")
                if result2 = "Yes"
                    ProcessClose(pid)
            }

        } catch Error as err {
            MsgBox("Error: " . err.Message . "`n`n" .
                "This might occur if UAC was cancelled or if there are permission issues.",
                "Error")
        }
    }

    MsgBox("RunAs demonstration complete.`n`n" .
        "Remember: Always use *RunAs prefix when elevation is needed.`n" .
        "Example: Run('*RunAs notepad.exe')",
        "Complete", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "Run Function Examples (Part 2) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w450", "AutoHotkey v2 - Run Function (Parameters & Working Dir)")
    menu.SetFont("s9")
    menu.Add("Text", "w450", "Select an example to run:")

    menu.Add("Button", "w450 h35", "Example 1: Working Directory Control").OnEvent("Click", (*) => (menu.Hide(), Example1_WorkingDirectory(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 2: Complex Command Lines").OnEvent("Click", (*) => (menu.Hide(), Example2_ComplexCommands(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 3: Multiple Parameters").OnEvent("Click", (*) => (menu.Hide(), Example3_MultipleParameters(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 4: Environment Variables").OnEvent("Click", (*) => (menu.Hide(), Example4_EnvironmentVariables(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 5: Batch File Executor").OnEvent("Click", (*) => (menu.Hide(), Example5_BatchExecutor(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 6: Advanced Program Launcher").OnEvent("Click", (*) => (menu.Hide(), Example6_AdvancedLauncher(), menu.Show()))
    menu.Add("Button", "w450 h35", "Example 7: Run with Admin Privileges (RunAs)").OnEvent("Click", (*) => (menu.Hide(), Example7_RunAsAdmin(), menu.Show()))

    menu.Add("Text", "w450 0x10")
    menu.Add("Button", "w450 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
