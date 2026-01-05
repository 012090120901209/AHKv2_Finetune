#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Examples - RunWait Function (Part 1: Wait for Completion)
 * ============================================================================
 * 
 * RunWait launches programs and waits for them to complete before continuing.
 * 
 * @description Examples demonstrating RunWait basics and waiting for completion
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * SYNTAX:
 *   ExitCode := RunWait(Target [, WorkingDir, Options])
 * 
 * KEY DIFFERENCES FROM RUN:
 *   - RunWait BLOCKS until program exits
 *   - Returns the exit code of the program
 *   - Script pauses at RunWait until completion
 *   - No PID parameter (process will be gone when it returns)
 * 
 * USE CASES:
 *   - Sequential operations
 *   - Batch processing
 *   - Build scripts
 *   - Automated installations
 *   - File conversions
 */

; ============================================================================
; Example 1: Basic RunWait vs Run
; ============================================================================
; Demonstrates the blocking nature of RunWait

Example1_RunWaitVsRun() {
    MsgBox("Example 1: RunWait vs Run Comparison`n`n" .
        "See the difference between Run and RunWait:",
        "RunWait - Example 1", "Icon!")

    ; Demonstrate Run (non-blocking)
    result := MsgBox("First, let's demonstrate Run (non-blocking).`n`n" .
        "Run will launch Notepad and IMMEDIATELY continue.`n" .
        "The script doesn't wait for Notepad to close.`n`n" .
        "Continue?",
        "Run Example", "YesNo Icon?")

    if result = "Yes" {
        MsgBox("Launching Notepad with Run...`n" .
            "Watch what happens!", "Run", "T2")

        Run("notepad.exe", , , &pid)

        ; This executes immediately
        MsgBox("This message appeared IMMEDIATELY after Run!`n`n" .
            "Notepad PID: " . pid . "`n" .
            "Notepad is still running in the background.`n`n" .
            "This is non-blocking behavior.", "Run Behavior", "T4")

        Sleep(1000)

        if ProcessExist(pid)
            ProcessClose(pid)
    }

    Sleep(1500)

    ; Demonstrate RunWait (blocking)
    result := MsgBox("Now, let's demonstrate RunWait (blocking).`n`n" .
        "RunWait will launch Notepad and WAIT for you to close it.`n" .
        "The script will pause until Notepad exits.`n`n" .
        "Continue?",
        "RunWait Example", "YesNo Icon?")

    if result = "Yes" {
        MsgBox("Launching Notepad with RunWait...`n`n" .
            "IMPORTANT: Close Notepad to continue!`n" .
            "The script will wait for you.", "RunWait", "T3")

        startTime := A_TickCount

        ; This blocks until notepad closes
        exitCode := RunWait("notepad.exe")

        elapsed := (A_TickCount - startTime) / 1000

        MsgBox("This message appeared AFTER you closed Notepad!`n`n" .
            "Time you took: " . Format("{:.1f}", elapsed) . " seconds`n" .
            "Exit Code: " . exitCode . "`n`n" .
            "This is blocking behavior - the script waited!", "RunWait Behavior", "T5")
    }

    MsgBox("Comparison complete!`n`n" .
        "Key takeaway:`n" .
        "• Run: Non-blocking, script continues immediately`n" .
        "• RunWait: Blocking, script waits for program to exit",
        "Complete", "Icon!")
}

; ============================================================================
; Example 2: Sequential Operations
; ============================================================================
; Using RunWait for sequential task execution

Example2_SequentialOperations() {
    MsgBox("Example 2: Sequential Operations`n`n" .
        "Use RunWait to execute tasks in sequence:",
        "RunWait - Example 2", "Icon!")

    ; Create work directory
    workDir := A_Temp . "\ahk_sequential"

    try {
        if !DirExist(workDir)
            DirCreate(workDir)

        ; Create batch files for sequential tasks
        task1 := workDir . "\task1.bat"
        task2 := workDir . "\task2.bat"
        task3 := workDir . "\task3.bat"

        FileAppend("
        (
        @echo off
        echo ========================================
        echo TASK 1: Creating Files
        echo ========================================
        echo.
        echo Creating file1.txt...
        echo Task 1 output > file1.txt
        echo Done!
        echo.
        timeout /t 2 /nobreak >nul
        )", task1)

        FileAppend("
        (
        @echo off
        echo ========================================
        echo TASK 2: Processing Files
        echo ========================================
        echo.
        if exist file1.txt (
        echo Found file1.txt from Task 1
        echo Processing...
        type file1.txt
        echo Task 2 processed > file2.txt
        echo Done!
        ) else (
            echo ERROR: file1.txt not found !
        )
        echo.
        timeout / t 2 / nobreak > nul
    ) ", task2)

    FileAppend("
        (
        @echo off
        echo ========================================
        echo TASK 3: Final Summary
        echo ========================================
        echo.
        echo Checking results...
        echo.
        if exist file1.txt echo [OK] file1.txt exists
        if exist file2.txt echo [OK] file2.txt exists
        echo.
        echo All tasks completed successfully!
        echo.
        pause
        )", task3)

    MsgBox("Created 3 sequential tasks:`n`n" .
        "Task 1: Creates file1.txt`n" .
        "Task 2: Processes file1.txt, creates file2.txt`n" .
        "Task 3: Verifies all files exist`n`n" .
        "Each task MUST wait for the previous one to complete!",
        "Tasks Created", "T4")

    result := MsgBox("Execute all tasks in sequence?`n`n" .
        "RunWait ensures each task completes before the next starts.",
        "Execute?", "YesNo Icon?")

    if result = "Yes" {
        ; Execute tasks sequentially
        MsgBox("Starting Task 1...", "Task 1", "T1")
        exitCode1 := RunWait('"' . task1 . '"', workDir)

        MsgBox("Task 1 complete (Exit Code: " . exitCode1 . ")`n" .
            "Starting Task 2...", "Task 2", "T1")
        exitCode2 := RunWait('"' . task2 . '"', workDir)

        MsgBox("Task 2 complete (Exit Code: " . exitCode2 . ")`n" .
            "Starting Task 3...", "Task 3", "T1")
        exitCode3 := RunWait('"' . task3 . '"', workDir)

        MsgBox("All tasks complete!`n`n" .
            "Exit Codes:`n" .
            "Task 1: " . exitCode1 . "`n" .
            "Task 2: " . exitCode2 . "`n" .
            "Task 3: " . exitCode3 . "`n`n" .
            "Files created in: " . workDir,
            "Complete", "Icon!")
    }

} catch Error as err {
    MsgBox("Error: " . err.Message, "Error")
}
}

; ============================================================================
; Example 3: Build Script Simulator
; ============================================================================
; Simulate a build process with multiple steps

Example3_BuildScript() {
    MsgBox("Example 3: Build Script Simulator`n`n" .
        "Simulate a software build process with multiple steps:",
        "RunWait - Example 3", "Icon!")

    buildDir := A_Temp . "\ahk_build"

    try {
        if !DirExist(buildDir)
            DirCreate(buildDir)

        ; Create build steps
        CreateBuildSteps(buildDir)

        ; Create build GUI
        CreateBuildGUI(buildDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateBuildSteps(buildDir) {
    ; Step 1: Clean
    cleanBat := buildDir . "\clean.bat"
    FileAppend("
    (
    @echo off
    echo [BUILD] Cleaning build directory...
    if exist build rd /s /q build
    mkdir build
    echo [BUILD] Clean complete
    timeout /t 1 /nobreak >nul
    exit /b 0
    )", cleanBat)

    ; Step 2: Compile
    compileBat := buildDir . "\compile.bat"
    FileAppend("
    (
    @echo off
    echo [BUILD] Compiling source files...
    echo Compiling main.cpp...
    echo Compiled output > build\main.o
    timeout /t 2 /nobreak >nul
    echo [BUILD] Compilation complete
    exit /b 0
    )", compileBat)

    ; Step 3: Link
    linkBat := buildDir . "\link.bat"
    FileAppend("
    (
    @echo off
    echo [BUILD] Linking object files...
    if not exist build\main.o (
    echo [ERROR] main.o not found!
    exit /b 1
    )
        echo Creating executable...
        echo Executable > build\program.exe
        timeout / t 1 / nobreak > nul
        echo[BUILD] Linking complete
        exit / b 0
    ) ", linkBat)

    ; Step 4: Test
    testBat := buildDir . "\test.bat"
    FileAppend("
    (
    @echo off
    echo [BUILD] Running tests...
    if not exist build\program.exe (
    echo [ERROR] program.exe not found!
    exit /b 1
    )
        echo Running unit tests...
        timeout / t 1 / nobreak > nul
        echo[TEST] All tests passed
        exit / b 0
    ) ", testBat)

    ; Step 5: Package
    packageBat := buildDir . "\package.bat"
    FileAppend("
    (
    @echo off
    echo [BUILD] Creating distribution package...
    echo Packaging files...
    echo Package > build\package.zip
    timeout /t 1 /nobreak >nul
    echo [BUILD] Package complete
    exit /b 0
    )", packageBat)
}

CreateBuildGUI(buildDir) {
    buildGUI := Gui(, "Build Script Simulator")
    buildGUI.SetFont("s10")

    buildGUI.Add("Text", "w500", "Software Build Process Simulator")
    buildGUI.Add("Text", "w500", "Each step must complete before the next begins:")

    buildGUI.Add("Text", "w500 0x10")

    ; Build steps list
    buildGUI.Add("Text", "w500",
        "Build Steps:`n" .
        "1. Clean - Remove old build files`n" .
        "2. Compile - Compile source code`n" .
        "3. Link - Create executable`n" .
        "4. Test - Run unit tests`n" .
        "5. Package - Create distribution")

    buildGUI.Add("Text", "w500 0x10")

    ; Progress display
    progressText := buildGUI.Add("Edit", "w500 h150 +ReadOnly +Multi",
        "Click 'Start Build' to begin...`n")

    ; Buttons
    startBtn := buildGUI.Add("Button", "w240 h35", "Start Build")
    startBtn.OnEvent("Click", StartBuild)

    buildGUI.Add("Button", "x+20 yp w240 h35", "Close").OnEvent("Click", (*) => buildGUI.Destroy())

    StartBuild(*) {
        startBtn.Enabled := false
        progressText.Value := "Starting build process...`n`n"

        steps := [{
            name: "Clean", file: buildDir . "\clean.bat" }, {
                name: "Compile", file: buildDir . "\compile.bat" }, {
                    name: "Link", file: buildDir . "\link.bat" }, {
                        name: "Test", file: buildDir . "\test.bat" }, {
                            name: "Package", file: buildDir . "\package.bat"
                        }
        ]

        buildSuccess := true
        totalSteps := steps.Length

        for index, step in steps {
            progressText.Value .= "[" . index . "/" . totalSteps . "] Running: " . step.name . "...`n"

            startTime := A_TickCount

            ; RunWait blocks until step completes
            exitCode := RunWait('"' . step.file . '"', buildDir, "Hide")

            elapsed := (A_TickCount - startTime) / 1000

            if exitCode = 0 {
                progressText.Value .= "    ✓ " . step.name . " completed (" .
                    Format("{:.1f}", elapsed) . "s, Exit: " . exitCode . ")`n`n"
            } else {
                progressText.Value .= "    ✗ " . step.name . " FAILED (Exit: " . exitCode . ")`n`n"
                buildSuccess := false
                break
            }
        }

        if buildSuccess {
            progressText.Value .= "========================================`n" .
                "BUILD SUCCESSFUL!`n" .
                "========================================`n" .
                "Output: " . buildDir . "\build\"
        } else {
            progressText.Value .= "========================================`n" .
                "BUILD FAILED!`n" .
                "========================================`n" .
                "Fix errors and try again."
        }

        startBtn.Enabled := true
    }

    buildGUI.Show()

    MsgBox("Build Script Simulator Created!`n`n" .
        "Click 'Start Build' to run all build steps sequentially.`n" .
        "RunWait ensures each step completes before the next starts.`n`n" .
        "Watch the progress display to see each step execute!",
        "Build Simulator Ready", "Icon!")
}

; ============================================================================
; Example 4: File Conversion Pipeline
; ============================================================================
; Process files through multiple conversion steps

Example4_ConversionPipeline() {
    MsgBox("Example 4: File Conversion Pipeline`n`n" .
        "Process files through a conversion pipeline:",
        "RunWait - Example 4", "Icon!")

    pipelineDir := A_Temp . "\ahk_pipeline"

    try {
        if !DirExist(pipelineDir)
            DirCreate(pipelineDir)

        ; Create source file
        sourceFile := pipelineDir . "\source.txt"
        FileAppend("Original text file content`nLine 2`nLine 3", sourceFile)

        ; Create conversion scripts
        CreateConversionScripts(pipelineDir)

        ; Run pipeline
        RunPipeline(pipelineDir, sourceFile)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateConversionScripts(pipelineDir) {
    ; Step 1: Uppercase converter
    step1 := pipelineDir . "\uppercase.bat"
    FileAppend("
                    (
                    @echo off
                    echo Converting to uppercase...
                    powershell -Command `"(Get-Content '%1').ToUpper() | Set-Content '%2'`"
                    exit /b 0
                    )", step1)

    ; Step 2: Add line numbers
    step2 := pipelineDir . "\linenumbers.bat"
    FileAppend("
                    (
                    @echo off
                    echo Adding line numbers...
                    setlocal EnableDelayedExpansion
                    set line=0
                    (for /f `"delims=`" %%a in (%1) do (
                    set /a line+=1
                    echo !line!: %%a
                    )) > %2
        exit / b 0
    ) ", step2)

    ; Step 3: Add header/footer
    step3 := pipelineDir . "\addheader.bat"
    FileAppend("
                    (
                    @echo off
                    echo Adding header and footer...
                    (
                    echo ==================
                    echo PROCESSED FILE
                    echo ==================
                    type %1
                    echo ==================
                    echo END OF FILE
                    echo ==================
                    ) > %2
        exit / b 0
    ) ", step3)
}

RunPipeline(pipelineDir, sourceFile) {
    result := MsgBox("Run file conversion pipeline?`n`n" .
        "Steps:`n" .
        "1. Convert to uppercase`n" .
        "2. Add line numbers`n" .
        "3. Add header/footer`n`n" .
        "Each step waits for previous to complete.",
        "Run Pipeline?", "YesNo Icon?")

    if result != "Yes"
        return

    ; Intermediate files
    step1Out := pipelineDir . "\step1_output.txt"
    step2Out := pipelineDir . "\step2_output.txt"
    step3Out := pipelineDir . "\final_output.txt"

    ; Execute pipeline
    MsgBox("Starting conversion pipeline...`n" .
        "Source: " . sourceFile, "Pipeline", "T2")

    ; Step 1
    exitCode1 := RunWait('"' . pipelineDir . '\uppercase.bat" "' . sourceFile . '" "' . step1Out . '"',
        pipelineDir, "Hide")
    MsgBox("Step 1 complete (Exit: " . exitCode1 . ")`n" .
        "Converted to uppercase", "Step 1", "T2")

    ; Step 2
    exitCode2 := RunWait('"' . pipelineDir . '\linenumbers.bat" "' . step1Out . '" "' . step2Out . '"',
        pipelineDir, "Hide")
    MsgBox("Step 2 complete (Exit: " . exitCode2 . ")`n" .
        "Added line numbers", "Step 2", "T2")

    ; Step 3
    exitCode3 := RunWait('"' . pipelineDir . '\addheader.bat" "' . step2Out . '" "' . step3Out . '"',
        pipelineDir, "Hide")
    MsgBox("Step 3 complete (Exit: " . exitCode3 . ")`n" .
        "Added header/footer", "Step 3", "T2")

    ; Show results
    if FileExist(step3Out) {
        finalContent := FileRead(step3Out)
        MsgBox("Pipeline complete!`n`n" .
            "Final output:`n" .
            "----------------------------------------`n" .
            finalContent . "`n" .
            "----------------------------------------`n`n" .
            "Files saved in: " . pipelineDir,
            "Complete", "Icon!")
    }
}

; ============================================================================
; Example 5: Interactive Installation Wizard
; ============================================================================
; Simulate software installation with sequential steps

Example5_InstallWizard() {
    MsgBox("Example 5: Interactive Installation Wizard`n`n" .
        "Simulate multi-step software installation:",
        "RunWait - Example 5", "Icon!")

    installDir := A_Temp . "\ahk_install"

    try {
        if !DirExist(installDir)
            DirCreate(installDir)

        CreateInstallWizard(installDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateInstallWizard(installDir) {
    wizard := Gui(, "Software Installation Wizard")
    wizard.SetFont("s10")

    wizard.Add("Text", "w450", "Installation Wizard - Demo Application v1.0")
    wizard.Add("Text", "w450 0x10")

    statusText := wizard.Add("Edit", "w450 h200 +ReadOnly +Multi",
        "Welcome to the Installation Wizard!`n`n" .
        "This will install Demo Application to your computer.`n`n" .
        "Click 'Start Installation' to begin...")

    progressBar := wizard.Add("Progress", "w450 h25", 0)

    installBtn := wizard.Add("Button", "w450 h35", "Start Installation")
    installBtn.OnEvent("Click", StartInstall)

    wizard.Add("Button", "w450 h30", "Close").OnEvent("Click", (*) => wizard.Destroy())

    StartInstall(*) {
        installBtn.Enabled := false

        steps := [{
            name: "Checking system requirements", duration: 1 }, {
                name: "Extracting files", duration: 2 }, {
                    name: "Installing components", duration: 2 }, {
                        name: "Creating shortcuts", duration: 1 }, {
                            name: "Finalizing installation", duration: 1
                        }
        ]

        statusText.Value := "Starting installation...`n`n"
        totalSteps := steps.Length

        for index, step in steps {
            progressBar.Value := ((index - 1) / totalSteps) * 100
            statusText.Value .= "[Step " . index . "/" . totalSteps . "] " . step.name . "...`n"

            ; Simulate step with timeout command
            RunWait('cmd.exe /c timeout /t ' . step.duration . ' /nobreak', , "Hide")

            statusText.Value .= "    ✓ Complete`n`n"
            progressBar.Value := (index / totalSteps) * 100
        }

        statusText.Value .= "========================================`n" .
            "INSTALLATION COMPLETE!`n" .
            "========================================`n`n" .
            "Demo Application has been successfully installed.`n" .
            "Installation directory: " . installDir

        MsgBox("Installation completed successfully!", "Success", "Icon!")
        installBtn.Enabled := true
    }

    wizard.Show()

    MsgBox("Installation Wizard Created!`n`n" .
        "Click 'Start Installation' to run through the installation steps.`n" .
        "Each step uses RunWait to ensure proper sequencing.",
        "Wizard Ready", "Icon!")
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "RunWait Function Examples (Part 1) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w500", "AutoHotkey v2 - RunWait Function (Wait for Completion)")
    menu.SetFont("s9")
    menu.Add("Text", "w500", "Select an example to run:")

    menu.Add("Button", "w500 h35", "Example 1: RunWait vs Run Comparison").OnEvent("Click", (*) => (menu.Hide(), Example1_RunWaitVsRun(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 2: Sequential Operations").OnEvent("Click", (*) => (menu.Hide(), Example2_SequentialOperations(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 3: Build Script Simulator").OnEvent("Click", (*) => (menu.Hide(), Example3_BuildScript(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 4: File Conversion Pipeline").OnEvent("Click", (*) => (menu.Hide(), Example4_ConversionPipeline(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 5: Interactive Installation Wizard").OnEvent("Click", (*) => (menu.Hide(), Example5_InstallWizard(), menu.Show()))

    menu.Add("Text", "w500 0x10")
    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
