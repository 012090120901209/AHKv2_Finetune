#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Examples - Run Function (Part 4: Verbs and Advanced Features)
 * ============================================================================
 *
 * Advanced Run features including verbs, shell operations, and error handling.
 *
 * @description Examples demonstrating verbs (open, edit, print, runas) and advanced features
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 *
 * VERBS:
 *   Verbs are actions that can be performed on files/programs:
 *   - open: Opens the file with default program
 *   - edit: Opens file in editor
 *   - print: Prints the file
 *   - explore: Opens Explorer at location
 *   - runas: Run with elevated privileges
 *   - properties: Show file properties
 *
 * SYNTAX WITH VERBS:
 *   Run "*verb target.ext"
 *   Example: Run "*edit myfile.txt"
 */

; ============================================================================
; Example 1: File Verbs (Open, Edit, Print)
; ============================================================================
; Demonstrates using different verbs on files

Example1_FileVerbs() {
    MsgBox("Example 1: File Verbs`n`n" .
           "Demonstrate different verbs: open, edit, print, properties",
           "Run - Example 1", "Icon!")

    ; Create test file
    testFile := A_Temp . "\ahk_verb_test.txt"

    try {
        FileAppend("AutoHotkey v2 Verb Test`n" .
                  "======================`n`n" .
                  "This file demonstrates different file verbs:`n" .
                  "- Open (default action)`n" .
                  "- Edit (open in editor)`n" .
                  "- Print (send to printer)`n" .
                  "- Properties (show file properties)`n`n" .
                  "Created: " . A_Now,
                  testFile)

        MsgBox("Created test file:`n" . testFile . "`n`n" .
               "We'll demonstrate different verbs on this file.",
               "File Created", "T3")

        ; Verb 1: Open (default action)
        result := MsgBox("Verb 1: OPEN`n`n" .
                        "Opens the file with its default associated program.`n" .
                        "For .txt files, this is usually Notepad.`n`n" .
                        "Execute?",
                        "Open Verb", "YesNo Icon?")

        if result = "Yes" {
            Run(testFile)  ; No verb prefix = default "open"
            MsgBox("Executed: Open verb (default action)`n" .
                   "File opened in default program.", "Opened", "T2")
            Sleep(2000)
        }

        ; Verb 2: Edit
        result := MsgBox("Verb 2: EDIT`n`n" .
                        "Opens the file in the default editor (usually Notepad for .txt).`n" .
                        "For some files, this may differ from 'open'.`n`n" .
                        "Execute?",
                        "Edit Verb", "YesNo Icon?")

        if result = "Yes" {
            Run("*edit " . testFile)
            MsgBox("Executed: Edit verb`n" .
                   "File opened in editor.", "Edited", "T2")
            Sleep(2000)
        }

        ; Verb 3: Properties
        result := MsgBox("Verb 3: PROPERTIES`n`n" .
                        "Shows the Windows properties dialog for the file.`n" .
                        "This is the same as right-click → Properties.`n`n" .
                        "Execute?",
                        "Properties Verb", "YesNo Icon?")

        if result = "Yes" {
            Run("*properties " . testFile)
            MsgBox("Executed: Properties verb`n" .
                   "File properties dialog should be visible.", "Properties", "T3")
        }

        MsgBox("Verb demonstration complete!`n`n" .
               "Test file: " . testFile . "`n" .
               "You can delete it manually if desired.",
               "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: RunAs Verb (Administrator Elevation)
; ============================================================================
; Comprehensive RunAs examples

Example2_RunAsVerb() {
    MsgBox("Example 2: RunAs Verb (Administrator Elevation)`n`n" .
           "The *RunAs verb requests administrator privileges via UAC.",
           "Run - Example 2", "Icon!")

    ; Example programs that typically need admin rights
    adminPrograms := [
        {name: "Registry Editor", cmd: "regedit.exe", desc: "Edit Windows Registry"},
        {name: "System Configuration", cmd: "msconfig.exe", desc: "System Configuration Utility"},
        {name: "Disk Management", cmd: "diskmgmt.msc", desc: "Disk Management Console"},
        {name: "Services", cmd: "services.msc", desc: "Windows Services Manager"}
    ]

    programList := "Programs that typically require admin rights:`n`n"
    for index, prog in adminPrograms {
        programList .= index . ". " . prog.name . " - " . prog.desc . "`n"
    }

    MsgBox(programList, "Admin Programs", "Icon!")

    result := MsgBox("Launch Registry Editor with admin privileges?`n`n" .
                     "You may see a UAC prompt.`n" .
                     "Click Yes/No in the UAC dialog to proceed or cancel.",
                     "RunAs Example", "YesNo Icon?")

    if result = "Yes" {
        try {
            Run("*RunAs regedit.exe", , , &pid)
            MsgBox("Launched Registry Editor with UAC elevation (PID: " . pid . ")`n`n" .
                   "The *RunAs prefix triggered the UAC prompt.",
                   "Launched", "Icon! T3")

            Sleep(2000)

            closeResult := MsgBox("Close Registry Editor now?", "Close?", "YesNo")
            if closeResult = "Yes" && ProcessExist(pid)
                ProcessClose(pid)

        } catch Error as err {
            MsgBox("Error launching with RunAs:`n" . err.Message . "`n`n" .
                   "This usually means:`n" .
                   "• UAC was cancelled`n" .
                   "• Insufficient permissions`n" .
                   "• Program not found",
                   "Error")
        }
    }

    ; Demonstrate creating admin CMD session
    result := MsgBox("Create an elevated CMD session?`n`n" .
                     "This CMD will have administrator privileges.",
                     "Admin CMD", "YesNo Icon?")

    if result = "Yes" {
        try {
            Run('*RunAs cmd.exe /k echo Administrative Command Prompt && echo. && whoami /priv', , , &cmdPID)
            MsgBox("Launched elevated CMD (PID: " . cmdPID . ")`n`n" .
                   "The 'whoami /priv' command shows your privileges.`n" .
                   "Notice the elevated privileges in the output!",
                   "Admin CMD", "Icon! T4")

            Sleep(5000)

            if ProcessExist(cmdPID) {
                closeResult := MsgBox("Close elevated CMD?", "Close?", "YesNo")
                if closeResult = "Yes"
                    ProcessClose(cmdPID)
            }

        } catch Error as err {
            MsgBox("Error: " . err.Message, "Error")
        }
    }
}

; ============================================================================
; Example 3: Explore Verb
; ============================================================================
; Using explore verb to open Explorer at specific locations

Example3_ExploreVerb() {
    MsgBox("Example 3: Explore Verb`n`n" .
           "The *explore verb opens Explorer and selects the specified file/folder.",
           "Run - Example 3", "Icon!")

    ; Create test structure
    testBase := A_Temp . "\ahk_explore_test"
    subDir := testBase . "\SubFolder"

    try {
        if !DirExist(testBase)
            DirCreate(testBase)
        if !DirExist(subDir)
            DirCreate(subDir)

        ; Create test files
        testFile1 := testBase . "\important_file.txt"
        testFile2 := subDir . "\data.txt"

        FileAppend("Important file in root", testFile1)
        FileAppend("Data file in subfolder", testFile2)

        MsgBox("Created test structure:`n" .
               testBase . "`n" .
               "├── important_file.txt`n" .
               "└── SubFolder\`n" .
               "    └── data.txt",
               "Structure Created", "T3")

        ; Example 1: Explore folder
        result := MsgBox("Open Explorer at test folder?`n`n" .
                        "The folder will be opened and ready for browsing.",
                        "Explore Folder", "YesNo Icon?")

        if result = "Yes" {
            Run("*explore " . testBase)
            MsgBox("Opened Explorer at:`n" . testBase, "Explorer Opened", "T2")
            Sleep(2000)
        }

        ; Example 2: Explore and select specific file
        result := MsgBox("Open Explorer and SELECT a specific file?`n`n" .
                        "This uses /select parameter instead of explore verb.`n" .
                        "The file will be highlighted in Explorer.",
                        "Select File", "YesNo Icon?")

        if result = "Yes" {
            Run('explorer.exe /select,"' . testFile1 . '"')
            MsgBox("Opened Explorer with important_file.txt selected!`n`n" .
                   "Notice the file is highlighted.",
                   "File Selected", "T3")
        }

        MsgBox("Explore verb demonstration complete!`n`n" .
               "Test files remain in:`n" . testBase,
               "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 4: Comprehensive Verb Handler
; ============================================================================
; GUI to test different verbs on files

Example4_VerbHandler() {
    MsgBox("Example 4: Comprehensive Verb Handler`n`n" .
           "Interactive GUI to test different verbs on files.",
           "Run - Example 4", "Icon!")

    ; Create test files of different types
    testDir := A_Temp . "\ahk_verb_handler"

    try {
        if !DirExist(testDir)
            DirCreate(testDir)

        ; Create various file types
        testFiles := Map()

        ; Text file
        txtFile := testDir . "\test.txt"
        FileAppend("Sample text file for verb testing.", txtFile)
        testFiles["Text File (.txt)"] := txtFile

        ; HTML file
        htmlFile := testDir . "\test.html"
        FileAppend("<html><body><h1>Test HTML</h1><p>For verb testing</p></body></html>", htmlFile)
        testFiles["HTML File (.html)"] := htmlFile

        ; Batch file
        batFile := testDir . "\test.bat"
        FileAppend("@echo off`necho Test batch file`npause", batFile)
        testFiles["Batch File (.bat)"] := batFile

        CreateVerbGUI(testFiles, testDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateVerbGUI(testFiles, testDir) {
    verbGUI := Gui(, "File Verb Handler")
    verbGUI.SetFont("s10")

    verbGUI.Add("Text", "w450", "Select file and verb to execute:")

    ; File selection
    fileList := []
    for desc in testFiles
        fileList.Push(desc)

    verbGUI.Add("Text", "xm", "File:")
    fileDD := verbGUI.Add("DropDownList", "w450", fileList)
    fileDD.Choose(1)

    ; Verb selection
    verbGUI.Add("Text", "xm", "Verb:")
    verbDD := verbGUI.Add("DropDownList", "w450", [
        "open (Default action)",
        "edit (Open in editor)",
        "print (Send to printer)",
        "properties (Show properties dialog)",
        "explore (Open Explorer at location)"
    ])
    verbDD.Choose(1)

    ; Status
    statusText := verbGUI.Add("Text", "w450 h60 +Border",
        "Select file and verb, then click Execute.")

    ; Execute button
    verbGUI.Add("Button", "w450 h35", "Execute Verb").OnEvent("Click", ExecuteVerb)

    ; Helper buttons
    verbGUI.Add("Button", "w220 h30", "Open Test Folder").OnEvent("Click", (*) => Run("explorer.exe " . testDir))
    verbGUI.Add("Button", "x+10 yp w220 h30", "Refresh Files").OnEvent("Click", (*) => RefreshFiles())

    verbGUI.Add("Button", "xm w450 h30", "Close").OnEvent("Click", (*) => verbGUI.Destroy())

    ExecuteVerb(*) {
        selectedFile := fileDD.Text
        filePath := testFiles[selectedFile]

        verbs := ["", "edit", "print", "properties", "explore"]
        selectedVerb := verbs[verbDD.Value]

        if !FileExist(filePath) {
            statusText.Text := "❌ Error: File not found!`n" . filePath
            return
        }

        try {
            if selectedVerb = ""
                Run(filePath)
            else
                Run("*" . selectedVerb . " `"" . filePath . "`"")

            statusText.Text := "✓ Executed verb: " . (selectedVerb = "" ? "open (default)" : selectedVerb) . "`n" .
                              "File: " . selectedFile . "`n" .
                              "Path: " . filePath
        } catch Error as err {
            statusText.Text := "❌ Failed to execute verb!`n" .
                              "Verb: " . selectedVerb . "`n" .
                              "Error: " . err.Message
        }
    }

    RefreshFiles() {
        statusText.Text := "File list refreshed.`n" .
                          "Files in: " . testDir
    }

    verbGUI.Show()

    MsgBox("Verb Handler GUI Created!`n`n" .
           "Test different verbs on different file types.`n" .
           "Notice how some verbs work differently depending on file type!",
           "Verb Handler Ready", "Icon!")
}

; ============================================================================
; Example 5: Error Handling with Run
; ============================================================================
; Comprehensive error handling for Run operations

Example5_ErrorHandling() {
    MsgBox("Example 5: Error Handling with Run`n`n" .
           "Demonstrate proper error handling for Run operations.",
           "Run - Example 5", "Icon!")

    ; Create error handling GUI
    CreateErrorHandlerGUI()
}

CreateErrorHandlerGUI() {
    errGUI := Gui(, "Run Error Handling Examples")
    errGUI.SetFont("s10")

    errGUI.Add("Text", "w500", "Test various error scenarios:")

    ; Test buttons
    errGUI.Add("Button", "w500 h35", "Test 1: Non-existent Program").OnEvent("Click", (*) => TestError1())
    errGUI.Add("Button", "w500 h35", "Test 2: Invalid Path").OnEvent("Click", (*) => TestError2())
    errGUI.Add("Button", "w500 h35", "Test 3: Non-existent File with Verb").OnEvent("Click", (*) => TestError3())
    errGUI.Add("Button", "w500 h35", "Test 4: Proper Error Recovery").OnEvent("Click", (*) => TestError4())
    errGUI.Add("Button", "w500 h35", "Test 5: Validation Before Run").OnEvent("Click", (*) => TestError5())

    errGUI.Add("Text", "w500 0x10")

    resultText := errGUI.Add("Edit", "w500 h150 +ReadOnly +Multi",
        "Click test buttons to see error handling in action.")

    errGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => errGUI.Destroy())

    ; Test 1: Non-existent program
    TestError1() {
        resultText.Value := "Testing: Non-existent Program`n" .
                           "Attempting to run 'nonexistent.exe'...`n`n"

        try {
            Run("nonexistent.exe")
            resultText.Value .= "❌ UNEXPECTED: Program launched!`n"
        } catch Error as err {
            resultText.Value .= "✓ CAUGHT ERROR (as expected):`n" .
                               "Message: " . err.Message . "`n" .
                               "What: " . err.What . "`n" .
                               "Extra: " . err.Extra
        }
    }

    ; Test 2: Invalid path
    TestError2() {
        resultText.Value := "Testing: Invalid Path`n" .
                           "Attempting to run program from non-existent directory...`n`n"

        try {
            Run("notepad.exe", "Z:\NonExistent\Path")
            resultText.Value .= "❌ UNEXPECTED: Program launched!`n"
        } catch Error as err {
            resultText.Value .= "✓ CAUGHT ERROR (as expected):`n" .
                               "Message: " . err.Message . "`n" .
                               "The working directory doesn't exist."
        }
    }

    ; Test 3: Non-existent file with verb
    TestError3() {
        resultText.Value := "Testing: Non-existent File with Verb`n" .
                           "Attempting to edit non-existent file...`n`n"

        try {
            Run("*edit C:\NonExistent\file.txt")
            resultText.Value .= "❌ UNEXPECTED: Operation completed!`n"
        } catch Error as err {
            resultText.Value .= "✓ CAUGHT ERROR (as expected):`n" .
                               "Message: " . err.Message . "`n" .
                               "File not found."
        }
    }

    ; Test 4: Proper error recovery
    TestError4() {
        resultText.Value := "Testing: Error Recovery Pattern`n" .
                           "Try to run preferred program, fall back to alternative...`n`n"

        ; Try to run preferred program
        try {
            Run("code.exe")  ; VS Code (might not be installed)
            resultText.Value .= "✓ SUCCESS: Launched VS Code`n"
        } catch {
            resultText.Value .= "⚠ VS Code not found, trying Notepad instead...`n"
            try {
                Run("notepad.exe")
                resultText.Value .= "✓ SUCCESS: Launched Notepad (fallback)`n"
                Sleep(1500)
                ; Close notepad after demo
                if pid := ProcessExist("notepad.exe")
                    ProcessClose(pid)
            } catch Error as err {
                resultText.Value .= "❌ FAILED: Even fallback failed!`n" . err.Message
            }
        }
    }

    ; Test 5: Validation before run
    TestError5() {
        resultText.Value := "Testing: Validation Before Run`n" .
                           "Check file existence before attempting to run...`n`n"

        testFile := "C:\NonExistent\file.txt"

        ; Validate first
        if !FileExist(testFile) {
            resultText.Value .= "✓ VALIDATION: File doesn't exist: " . testFile . "`n" .
                               "Aborting operation (preventing error).`n`n" .
                               "This is better than try/catch when you can validate first!"
        } else {
            try {
                Run("*edit " . testFile)
                resultText.Value .= "✓ SUCCESS: File opened in editor`n"
            } catch Error as err {
                resultText.Value .= "❌ ERROR: " . err.Message
            }
        }
    }

    errGUI.Show()

    MsgBox("Error Handling GUI Created!`n`n" .
           "Click test buttons to see different error scenarios and handling strategies.`n`n" .
           "Best practices:`n" .
           "• Always use try/catch with Run`n" .
           "• Validate inputs when possible`n" .
           "• Provide fallback options`n" .
           "• Give user feedback on errors",
           "Error Handler Ready", "Icon!")
}

; ============================================================================
; Example 6: Advanced RunAs Scenarios
; ============================================================================
; More complex RunAs use cases

Example6_AdvancedRunAs() {
    MsgBox("Example 6: Advanced RunAs Scenarios`n`n" .
           "Explore complex scenarios requiring administrator privileges.",
           "Run - Example 6", "Icon!")

    scenarios := [
        {
            name: "System File Editor",
            desc: "Edit a system file that requires admin rights",
            file: A_WinDir . "\System32\drivers\etc\hosts"
        },
        {
            name: "Install Software",
            desc: "Run an installer with elevated privileges",
            file: ""  ; Would be actual installer path
        },
        {
            name: "System Configuration",
            desc: "Modify system settings requiring admin",
            file: ""
        }
    ]

    ; Demonstrate editing hosts file with admin rights
    result := MsgBox("Attempt to edit Windows hosts file?`n`n" .
                     "File: " . A_WinDir . "\System32\drivers\etc\hosts`n`n" .
                     "This requires administrator privileges.`n" .
                     "UAC prompt will appear.",
                     "Edit Hosts File", "YesNo Icon?")

    if result = "Yes" {
        hostsFile := A_WinDir . "\System32\drivers\etc\hosts"

        if FileExist(hostsFile) {
            try {
                Run('*RunAs notepad.exe "' . hostsFile . '"')
                MsgBox("Launched Notepad with admin rights to edit hosts file!`n`n" .
                       "Note: You need to accept the UAC prompt for this to work.`n`n" .
                       "The hosts file controls DNS resolution on your computer.",
                       "Launched", "Icon! T4")
            } catch Error as err {
                MsgBox("Failed to launch with admin rights:`n" . err.Message . "`n`n" .
                       "Possible reasons:`n" .
                       "• UAC was cancelled`n" .
                       "• User lacks admin privileges`n" .
                       "• Group Policy restrictions",
                       "Error")
            }
        } else {
            MsgBox("Hosts file not found at expected location.", "Not Found")
        }
    }

    MsgBox("RunAs scenarios demonstration complete!`n`n" .
           "Remember: Always use *RunAs for operations requiring elevation.",
           "Complete", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "Run Function Examples (Part 4) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w500", "AutoHotkey v2 - Run Function (Verbs & Advanced Features)")
    menu.SetFont("s9")
    menu.Add("Text", "w500", "Select an example to run:")

    menu.Add("Button", "w500 h35", "Example 1: File Verbs (Open, Edit, Print, Properties)").OnEvent("Click", (*) => (menu.Hide(), Example1_FileVerbs(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 2: RunAs Verb (Administrator Elevation)").OnEvent("Click", (*) => (menu.Hide(), Example2_RunAsVerb(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 3: Explore Verb").OnEvent("Click", (*) => (menu.Hide(), Example3_ExploreVerb(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 4: Comprehensive Verb Handler").OnEvent("Click", (*) => (menu.Hide(), Example4_VerbHandler(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 5: Error Handling with Run").OnEvent("Click", (*) => (menu.Hide(), Example5_ErrorHandling(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 6: Advanced RunAs Scenarios").OnEvent("Click", (*) => (menu.Hide(), Example6_AdvancedRunAs(), menu.Show()))

    menu.Add("Text", "w500 0x10")
    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
