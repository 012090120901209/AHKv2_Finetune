#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Examples - RunWait Function (Part 4: Batch Processing)
* ============================================================================
*
* Advanced batch processing techniques with RunWait.
*
* @description Examples demonstrating batch operations and file processing
* @author AHK v2 Documentation Team
* @date 2024
* @version 2.0.0
*
* BATCH PROCESSING:
*   RunWait is ideal for batch operations because:
*   - Each operation completes before next starts
*   - Exit codes can be checked for each step
*   - Results can be validated before proceeding
*   - Error handling is straightforward
*/

; ============================================================================
; Example 1: Sequential File Processing
; ============================================================================
; Process multiple files one by one

Example1_FileProcessing() {
    MsgBox("Example 1: Sequential File Processing`n`n" .
    "Process multiple files sequentially:",
    "RunWait - Example 1", "Icon!")

    processDir := A_Temp . "\ahk_file_batch"

    try {
        if !DirExist(processDir)
        DirCreate(processDir)

        ; Create test files
        testFiles := []
        Loop 5 {
            fileName := processDir . "\file" . A_Index . ".txt"
            FileAppend("File " . A_Index . " content`nCreated: " . A_Now, fileName)
            testFiles.Push(fileName)
        }

        ; Create processor
        processorBat := processDir . "\file_processor.bat"
        FileAppend("@echo off`necho Processing: %1`ntype %1`ntimeout /t 1 /nobreak >nul`nexit /b 0", processorBat)

        MsgBox("Created " . testFiles.Length . " files to process.`n`n" .
        "Each will be processed sequentially.", "Files Created", "T3")

        result := MsgBox("Process all files?", "Process?", "YesNo Icon?")

        if result = "Yes" {
            for index, file in testFiles {
                MsgBox("Processing file " . index . "/" . testFiles.Length . "...`n" .
                file, "Processing", "T2")

                exitCode := RunWait('"' . processorBat . '" "' . file . '"', processDir, "Hide")

                if exitCode != 0 {
                    MsgBox("Error processing file " . index . "!`nExit code: " . exitCode, "Error")
                    break
                }
            }

            MsgBox("All files processed successfully!", "Complete", "Icon!")
        }

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: Batch Conversion System
; ============================================================================
; Convert multiple files with progress tracking

Example2_BatchConversion() {
    MsgBox("Example 2: Batch Conversion System`n`n" .
    "Convert multiple files with progress tracking:",
    "RunWait - Example 2", "Icon!")

    conversionDir := A_Temp . "\ahk_batch_convert"

    try {
        if !DirExist(conversionDir)
        DirCreate(conversionDir)

        CreateBatchConverter(conversionDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateBatchConverter(conversionDir) {
    ; Create sample source files
    sourceDir := conversionDir . "\source"
    outputDir := conversionDir . "\output"

    if !DirExist(sourceDir)
    DirCreate(sourceDir)
    if !DirExist(outputDir)
    DirCreate(outputDir)

    Loop 10 {
        FileAppend("Source file " . A_Index . " content", sourceDir . "\source" . A_Index . ".txt")
    }

    ; Create converter script
    converterBat := conversionDir . "\converter.bat"
    FileAppend("@echo off`npowershell -Command `"(Get-Content '%1').ToUpper() | Set-Content '%2'`"`nexit /b 0", converterBat)

    ; Create GUI
    converterGUI := Gui(, "Batch File Converter")
    converterGUI.SetFont("s10")

    converterGUI.Add("Text", "w500", "Batch File Conversion System")
    converterGUI.Add("Text", "w500", "Convert 10 files from source to output folder:")

    progressBar := converterGUI.Add("Progress", "w500 h30", 0)
    statusText := converterGUI.Add("Text", "w500", "Ready to convert...")
    logText := converterGUI.Add("Edit", "w500 h150 +ReadOnly +Multi", "Conversion log will appear here...")

    convertBtn := converterGUI.Add("Button", "w500 h35", "Start Batch Conversion")
    convertBtn.OnEvent("Click", StartConversion)

    converterGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => converterGUI.Destroy())

    StartConversion(*) {
        convertBtn.Enabled := false
        logText.Value := "Starting batch conversion...`n`n"

        ; Get all source files
        sourceFiles := []
        Loop Files, sourceDir . "\*.txt" {
            sourceFiles.Push(A_LoopFileFullPath)
        }

        totalFiles := sourceFiles.Length
        converted := 0
        failed := 0

        for index, sourceFile in sourceFiles {
            SplitPath(sourceFile, &fileName)
            outputFile := outputDir . "\" . fileName

            progressBar.Value := ((index - 1) / totalFiles) * 100
            statusText.Text := "Converting " . index . "/" . totalFiles . ": " . fileName

            logText.Value .= "[" . index . "] " . fileName . "..."

            exitCode := RunWait('"' . converterBat . '" "' . sourceFile . '" "' . outputFile . '"',
            conversionDir, "Hide")

            if exitCode = 0 {
                logText.Value .= " ✓ Done`n"
                converted++
            } else {
                logText.Value .= " ✗ Failed (Exit: " . exitCode . ")`n"
                failed++
            }
        }

        progressBar.Value := 100
        statusText.Text := "Conversion complete!"

        logText.Value .= "`n========================================`n"
        logText.Value .= "BATCH CONVERSION COMPLETE`n"
        logText.Value .= "========================================`n"
        logText.Value .= "Total Files: " . totalFiles . "`n"
        logText.Value .= "Converted: " . converted . "`n"
        logText.Value .= "Failed: " . failed . "`n"

        convertBtn.Enabled := true
    }

    converterGUI.Show()

    MsgBox("Batch Converter Created!`n`n" .
    "Source: " . sourceDir . "`n" .
    "Output: " . outputDir . "`n`n" .
    "Click 'Start Batch Conversion' to process all files!",
    "Converter Ready", "Icon!")
}

; ============================================================================
; Example 3: Multi-Stage Pipeline
; ============================================================================
; Process files through multiple stages

Example3_MultiStagePipeline() {
    MsgBox("Example 3: Multi-Stage Processing Pipeline`n`n" .
    "Process files through multiple stages:",
    "RunWait - Example 3", "Icon!")

    pipelineDir := A_Temp . "\ahk_pipeline"

    try {
        if !DirExist(pipelineDir)
        DirCreate(pipelineDir)

        CreatePipeline(pipelineDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreatePipeline(pipelineDir) {
    ; Create pipeline directories
    stages := ["stage1_validate", "stage2_process", "stage3_finalize"]

    for stage in stages {
        stageDir := pipelineDir . "\" . stage
        if !DirExist(stageDir)
        DirCreate(stageDir)
    }

    ; Create input files
    inputDir := pipelineDir . "\input"
    if !DirExist(inputDir)
    DirCreate(inputDir)

    Loop 5 {
        FileAppend("Input data " . A_Index, inputDir . "\input" . A_Index . ".txt")
    }

    pipelineGUI := Gui(, "Multi-Stage Pipeline")
    pipelineGUI.SetFont("s10")

    pipelineGUI.Add("Text", "w500", "Multi-Stage File Processing Pipeline")
    pipelineGUI.Add("Text", "w500", "Process files through 3 stages:")
    pipelineGUI.Add("Text", "w500", "Stage 1: Validate → Stage 2: Process → Stage 3: Finalize")

    logText := pipelineGUI.Add("Edit", "w500 h200 +ReadOnly +Multi",
    "Pipeline stages:`n" .
    "1. Validate - Check file integrity`n" .
    "2. Process - Transform data`n" .
    "3. Finalize - Create output`n`n" .
    "Click 'Run Pipeline' to start...")

    runBtn := pipelineGUI.Add("Button", "w500 h35", "Run Pipeline")
    runBtn.OnEvent("Click", RunPipeline)

    pipelineGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => pipelineGUI.Destroy())

    RunPipeline(*) {
        runBtn.Enabled := false
        logText.Value := "Starting pipeline...`n`n"

        ; Get input files
        inputFiles := []
        Loop Files, inputDir . "\*.txt" {
            inputFiles.Push(A_LoopFileFullPath)
        }

        for index, inputFile in inputFiles {
            SplitPath(inputFile, &fileName, &fileDir, &fileExt, &fileNameNoExt)

            logText.Value .= "Processing: " . fileName . "`n"

            ; Stage 1: Validate
            logText.Value .= "  [1/3] Validating..."
            Sleep(500)  ; Simulate validation
            logText.Value .= " ✓`n"

            ; Stage 2: Process
            stage2File := pipelineDir . "\stage2_process\" . fileName
            logText.Value .= "  [2/3] Processing..."

            FileAppend(FileRead(inputFile) . "`nProcessed at stage 2", stage2File)
            Sleep(500)
            logText.Value .= " ✓`n"

            ; Stage 3: Finalize
            stage3File := pipelineDir . "\stage3_finalize\" . fileName
            logText.Value .= "  [3/3] Finalizing..."

            FileAppend(FileRead(stage2File) . "`nFinalized at stage 3", stage3File)
            Sleep(500)
            logText.Value .= " ✓`n`n"
        }

        logText.Value .= "========================================`n"
        logText.Value .= "PIPELINE COMPLETE`n"
        logText.Value .= "========================================`n"
        logText.Value .= "Files processed: " . inputFiles.Length . "`n"
        logText.Value .= "Output: " . pipelineDir . "\stage3_finalize\`n"

        runBtn.Enabled := true
    }

    pipelineGUI.Show()

    MsgBox("Multi-Stage Pipeline Created!`n`n" .
    "Files will be processed through 3 sequential stages.`n" .
    "Each file must complete all stages successfully.",
    "Pipeline Ready", "Icon!")
}

; ============================================================================
; Example 4: Dependency-Based Processing
; ============================================================================
; Process files based on dependencies

Example4_DependencyProcessing() {
    MsgBox("Example 4: Dependency-Based Processing`n`n" .
    "Process files respecting their dependencies:",
    "RunWait - Example 4", "Icon!")

    depDir := A_Temp . "\ahk_dependencies"

    try {
        if !DirExist(depDir)
        DirCreate(depDir)

        CreateDependencySystem(depDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateDependencySystem(depDir) {
    ; Define dependency graph
    ; A depends on nothing
    ; B depends on A
    ; C depends on A
    ; D depends on B and C
    dependencies := Map(
    "A", [],
    "B", ["A"],
    "C", ["A"],
    "D", ["B", "C"]
    )

    depGUI := Gui(, "Dependency-Based Processing")
    depGUI.SetFont("s10")

    depGUI.Add("Text", "w500", "Dependency-Based Build System")
    depGUI.Add("Text", "w500", "Process order respects dependencies:")
    depGUI.Add("Text", "w500", "D depends on B,C → B,C depend on A")

    logText := depGUI.Add("Edit", "w500 h200 +ReadOnly +Multi",
    "Dependency Graph:`n" .
    "  A (no dependencies)`n" .
    "  ├─ B (depends on A)`n" .
    "  ├─ C (depends on A)`n" .
    "  └─ D (depends on B, C)`n`n" .
    "Click 'Start Build' to process in dependency order...")

    buildBtn := depGUI.Add("Button", "w500 h35", "Start Build")
    buildBtn.OnEvent("Click", StartBuild)

    depGUI.Add("Button", "w500 h30", "Close").OnEvent("Click", (*) => depGUI.Destroy())

    StartBuild(*) {
        buildBtn.Enabled := false
        logText.Value := "Starting dependency-based build...`n`n"

        completed := Map()
        buildOrder := []

        ; Determine build order (topological sort)
        ProcessTarget("D")

        logText.Value .= "Build order determined: " . buildOrder.Join(" → ") . "`n`n"

        ; Execute builds in order
        for target in buildOrder {
            logText.Value .= "Building " . target . "..."

            ; Simulate build
            Sleep(800)

            logText.Value .= " ✓ Complete`n"
            completed[target] := true
        }

        logText.Value .= "`n========================================`n"
        logText.Value .= "BUILD SUCCESSFUL`n"
        logText.Value .= "========================================`n"
        logText.Value .= "All targets built in dependency order.`n"

        buildBtn.Enabled := true

        ProcessTarget(target) {
            ; Skip if already processed
            if completed.Has(target)
            return

            ; Process dependencies first
            if dependencies.Has(target) {
                for dep in dependencies[target] {
                    ProcessTarget(dep)
                }
            }

            ; Add to build order
            buildOrder.Push(target)
            completed[target] := true
        }
    }

    depGUI.Show()

    MsgBox("Dependency System Created!`n`n" .
    "Targets are built in dependency order.`n" .
    "Dependencies are always built before their dependents.",
    "System Ready", "Icon!")
}

; ============================================================================
; Example 5: Batch Processing with Rollback
; ============================================================================
; Process batch with ability to rollback on error

Example5_BatchWithRollback() {
    MsgBox("Example 5: Batch Processing with Rollback`n`n" .
    "Process batch with automatic rollback on errors:",
    "RunWait - Example 5", "Icon!")

    rollbackDir := A_Temp . "\ahk_rollback"

    try {
        if !DirExist(rollbackDir)
        DirCreate(rollbackDir)

        CreateRollbackSystem(rollbackDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateRollbackSystem(rollbackDir) {
    rollbackGUI := Gui(, "Batch Processing with Rollback")
    rollbackGUI.SetFont("s10")

    rollbackGUI.Add("Text", "w500", "Batch Processing with Transaction Rollback")
    rollbackGUI.Add("Text", "w500", "If any step fails, all changes are rolled back:")

    logText := rollbackGUI.Add("Edit", "w500 h200 +ReadOnly +Multi",
    "This simulates a transaction system:`n" .
    "• All operations tracked`n" .
    "• On error: rollback all changes`n" .
    "• On success: commit all changes`n`n" .
    "Click 'Run Batch (Success)' or 'Run Batch (Fail at Step 3)'...")

    rollbackGUI.Add("Button", "w240 h35", "Run Batch (Success)").OnEvent("Click", (*) => RunBatch(false))
    rollbackGUI.Add("Button", "x+20 yp w240 h35", "Run Batch (Fail at 3)").OnEvent("Click", (*) => RunBatch(true))

    rollbackGUI.Add("Button", "xm w500 h30", "Close").OnEvent("Click", (*) => rollbackGUI.Destroy())

    RunBatch(shouldFail) {
        logText.Value := "Starting batch operation...`n`n"

        operations := [
        {
            name: "Create user", file: "user.dat"},
            {
                name: "Create profile", file: "profile.dat"},
                {
                    name: "Initialize settings", file: "settings.dat"},
                    {
                        name: "Set permissions", file: "permissions.dat"},
                        {
                            name: "Finalize setup", file: "setup.dat"
                        }
                        ]

                        completedOps := []
                        success := true

                        ; Execute operations
                        for index, op in operations {
                            logText.Value .= "[" . index . "/5] " . op.name . "..."

                            ; Simulate failure at step 3 if requested
                            if shouldFail && index = 3 {
                                logText.Value .= " ✗ FAILED`n`n"
                                success := false
                                break
                            }

                            ; Create file (simulate operation)
                            FileAppend("Operation: " . op.name . "`nTime: " . A_Now,
                            rollbackDir . "\" . op.file)

                            completedOps.Push(op.file)
                            logText.Value .= " ✓`n"
                            Sleep(500)
                        }

                        if success {
                            logText.Value .= "`n========================================`n"
                            logText.Value .= "BATCH SUCCESSFUL - COMMITTED`n"
                            logText.Value .= "========================================`n"
                            logText.Value .= "All operations committed successfully.`n"
                            logText.Value .= "Created files: " . completedOps.Length . "`n"
                        } else {
                            logText.Value .= "========================================`n"
                            logText.Value .= "BATCH FAILED - ROLLING BACK`n"
                            logText.Value .= "========================================`n"

                            ; Rollback: delete all created files
                            for file in completedOps {
                                filePath := rollbackDir . "\" . file
                                if FileExist(filePath) {
                                    FileDelete(filePath)
                                    logText.Value .= "Rolled back: " . file . "`n"
                                }
                            }

                            logText.Value .= "`nAll changes rolled back. System restored.`n"
                        }
                    }

                    rollbackGUI.Show()

                    MsgBox("Rollback System Created!`n`n" .
                    "Try both success and failure scenarios to see rollback in action!",
                    "Rollback System Ready", "Icon!")
                }

                ; ============================================================================
                ; Main Menu
                ; ============================================================================

                ShowMainMenu() {
                    menu := Gui(, "RunWait Function Examples (Part 4) - Main Menu")
                    menu.SetFont("s10")

                    menu.Add("Text", "w500", "AutoHotkey v2 - RunWait Function (Batch Processing)")
                    menu.SetFont("s9")
                    menu.Add("Text", "w500", "Select an example to run:")

                    menu.Add("Button", "w500 h35", "Example 1: Sequential File Processing").OnEvent("Click", (*) => (menu.Hide(), Example1_FileProcessing(), menu.Show()))
                    menu.Add("Button", "w500 h35", "Example 2: Batch Conversion System").OnEvent("Click", (*) => (menu.Hide(), Example2_BatchConversion(), menu.Show()))
                    menu.Add("Button", "w500 h35", "Example 3: Multi-Stage Pipeline").OnEvent("Click", (*) => (menu.Hide(), Example3_MultiStagePipeline(), menu.Show()))
                    menu.Add("Button", "w500 h35", "Example 4: Dependency-Based Processing").OnEvent("Click", (*) => (menu.Hide(), Example4_DependencyProcessing(), menu.Show()))
                    menu.Add("Button", "w500 h35", "Example 5: Batch Processing with Rollback").OnEvent("Click", (*) => (menu.Hide(), Example5_BatchWithRollback(), menu.Show()))

                    menu.Add("Text", "w500 0x10")
                    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

                    menu.Show()
                }

                ShowMainMenu()
