#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Examples - Run Function (Part 3: Working Directory Advanced)
 * ============================================================================
 * 
 * Advanced working directory techniques and relative path handling.
 * 
 * @description Deep dive into working directory management
 * @author AHK v2 Documentation Team
 * @date 2024
 * @version 2.0.0
 * 
 * WORKING DIRECTORY IMPORTANCE:
 *   - Determines where relative paths resolve
 *   - Affects file I/O operations in launched programs
 *   - Critical for batch files and scripts
 *   - Impacts some program behaviors
 */

; ============================================================================
; Example 1: Working Directory vs Script Directory
; ============================================================================
; Understanding the difference between script dir and working dir

Example1_DirectoryDifference() {
    MsgBox("Example 1: Working Directory vs Script Directory`n`n" .
        "Understanding the difference between A_ScriptDir and working directory:",
        "Run - Example 1", "Icon!")

    ; Create demonstration structure
    testBase := A_Temp . "\ahk_dir_demo"
    scriptLoc := testBase . "\scripts"
    workLoc := testBase . "\workdir"

    try {
        ; Create directories
        if !DirExist(testBase)
            DirCreate(testBase)
        if !DirExist(scriptLoc)
            DirCreate(scriptLoc)
        if !DirExist(workLoc)
            DirCreate(workLoc)

        ; Create marker files
        FileAppend("This file is in the SCRIPT directory", scriptLoc . "\script_marker.txt")
        FileAppend("This file is in the WORKING directory", workLoc . "\work_marker.txt")

        ; Create a batch file that shows its working directory
        batchFile := scriptLoc . "\show_dirs.bat"
        batchContent := "
        (
        @echo off
        echo ========================================
        echo Directory Information
        echo ========================================
        echo.
        echo Current Working Directory: %CD%
        echo Batch File Location: %~dp0
        echo.
        echo Contents of Current Directory:
        dir /b
        echo.
        pause
        )"
        FileAppend(batchContent, batchFile)

        MsgBox("Created test structure:`n`n" .
            "Script Location: " . scriptLoc . "`n" .
            "Working Directory: " . workLoc . "`n`n" .
            "The batch file is in scriptLoc but will run with workLoc as working dir.",
            "Structure Created", "T4")

        ; Run batch with different working directory
        Run('"' . batchFile . '"', workLoc, , &pid)

        MsgBox("Batch file launched!`n`n" .
            "Notice:`n" .
            "• Batch File Location shows: " . scriptLoc . "`n" .
            "• Current Working Directory shows: " . workLoc . "`n" .
            "• Directory listing shows files from: " . workLoc . "`n`n" .
            "This demonstrates the working dir controls where the program operates!",
            "Running", "Icon! T5")

        Sleep(6000)
        if ProcessExist(pid)
            ProcessClose(pid)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 2: Project-Based Program Launcher
; ============================================================================
; Launch programs with project-specific working directories

Example2_ProjectLauncher() {
    MsgBox("Example 2: Project-Based Program Launcher`n`n" .
        "Launch programs in project-specific working directories:",
        "Run - Example 2", "Icon!")

    ; Create multiple project directories
    projectBase := A_Temp . "\ahk_projects"
    projects := Map()

    try {
        if !DirExist(projectBase)
            DirCreate(projectBase)

        ; Create project structure
        projectNames := ["Project_Alpha", "Project_Beta", "Project_Gamma"]

        for projectName in projectNames {
            projectDir := projectBase . "\" . projectName
            if !DirExist(projectDir)
                DirCreate(projectDir)

            ; Create project files
            FileAppend("Project: " . projectName . "`n" .
                "Created: " . A_Now . "`n" .
                "Status: Active", projectDir . "\project_info.txt")

            FileAppend("# " . projectName . " README`n`n" .
                "This is the readme file for " . projectName . ".",
                projectDir . "\README.md")

            projects[projectName] := projectDir
        }

        MsgBox("Created " . projects.Count . " project directories:`n`n" .
            projects.Join("`n"), "Projects Created", "T3")

        ; Create project launcher GUI
        CreateProjectLauncher(projects, projectBase)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateProjectLauncher(projects, projectBase) {
    launcher := Gui(, "Project-Based Launcher")
    launcher.SetFont("s10")

    launcher.Add("Text", "w400", "Select a project and launch tool:")

    ; Project selection
    projectNames := []
    for name in projects
        projectNames.Push(name)

    launcher.Add("Text", "xm", "Project:")
    projectDD := launcher.Add("DropDownList", "w400", projectNames)
    projectDD.Choose(1)

    ; Tool selection
    launcher.Add("Text", "xm", "Tool:")
    toolDD := launcher.Add("DropDownList", "w400", [
        "CMD (Command Prompt)",
        "PowerShell",
        "Explorer (File Browser)",
        "Notepad (Edit project_info.txt)"
    ])
    toolDD.Choose(1)

    ; Status
    statusText := launcher.Add("Text", "w400 h50 +Border", "Select project and tool, then click Launch.")

    ; Launch button
    launcher.Add("Button", "w400 h35", "Launch Tool in Project Directory").OnEvent("Click", LaunchTool)

    ; Open project folder button
    launcher.Add("Button", "w400 h30", "Open All Projects Folder").OnEvent("Click", (*) => Run("explorer.exe " . projectBase))

    launcher.Add("Button", "w400 h30", "Close").OnEvent("Click", (*) => launcher.Destroy())

    LaunchTool(*) {
        selectedProject := projectNames[projectDD.Value]
        selectedWorkDir := projects[selectedProject]

        tools := [{
            name: "CMD", cmd: "cmd.exe /k dir" }, {
                name: "PowerShell", cmd: "powershell.exe -NoExit -Command `"Get-ChildItem; Write-Host 'Project: " . selectedProject . "'`"" }, {
                    name: "Explorer", cmd: "explorer.exe ." }, {
                        name: "Notepad", cmd: "notepad.exe project_info.txt"
                    }
        ]

        selectedTool := tools[toolDD.Value]

        try {
            Run(selectedTool.cmd, selectedWorkDir, , &pid)
            statusText.Text := "✓ Launched: " . selectedTool.name . "`n" .
                "Project: " . selectedProject . "`n" .
                "Working Dir: " . selectedWorkDir . "`n" .
                "PID: " . pid
        } catch Error as err {
            statusText.Text := "❌ Failed to launch!`nError: " . err.Message
        }
    }

    launcher.Show()

    MsgBox("Project Launcher Created!`n`n" .
        "Select any project and tool to launch it with the project's directory " .
        "as the working directory. Notice how each tool operates within the project folder!",
        "Launcher Ready", "Icon!")
}

; ============================================================================
; Example 3: Relative Path Resolution
; ============================================================================
; Demonstrates how working directory affects relative path resolution

Example3_RelativePaths() {
    MsgBox("Example 3: Relative Path Resolution`n`n" .
        "See how working directory affects relative path resolution:",
        "Run - Example 3", "Icon!")

    ; Create test structure
    baseDir := A_Temp . "\ahk_relative_test"
    dir1 := baseDir . "\Location1"
    dir2 := baseDir . "\Location2"

    try {
        ; Create directories
        if !DirExist(baseDir)
            DirCreate(baseDir)
        if !DirExist(dir1)
            DirCreate(dir1)
        if !DirExist(dir2)
            DirCreate(dir2)

        ; Create files with same name in different locations
        FileAppend("This is data.txt from Location1`n" .
            "Path: " . dir1, dir1 . "\data.txt")

        FileAppend("This is data.txt from Location2`n" .
            "Path: " . dir2, dir2 . "\data.txt")

        ; Create a batch file that reads data.txt (relative path)
        batchFile := baseDir . "\read_data.bat"
        batchContent := "
                    (
                    @echo off
                    echo ========================================
                    echo Reading data.txt from current directory
                    echo ========================================
                    echo.
                    echo Current Directory: %CD%
                    echo.
                    if exist data.txt (
                    echo Contents of data.txt:
                    type data.txt
                    ) else (
        echo ERROR: data.txt not found !
    )
    echo.
    pause
) "
FileAppend(batchContent, batchFile)

MsgBox("Created test structure with identical filenames in different locations:`n`n" .
    "Location1: " . dir1 . "\data.txt`n" .
    "Location2: " . dir2 . "\data.txt`n`n" .
    "We'll run the same batch file with different working directories.",
    "Setup Complete", "T4")

; Run batch from Location1
Run('"' . batchFile . '"', dir1, , &pid1)
MsgBox("Running batch with Location1 as working directory.`n" .
    "Notice it reads data.txt from Location1!", "Location 1", "T4")

Sleep(4000)
if ProcessExist(pid1)
    ProcessClose(pid1)

Sleep(1000)

; Run batch from Location2
Run('"' . batchFile . '"', dir2, , &pid2)
MsgBox("Running same batch with Location2 as working directory.`n" .
    "Notice it reads data.txt from Location2!`n`n" .
    "This shows how working directory affects relative path resolution.",
    "Location 2", "T4")

Sleep(4000)
if ProcessExist(pid2)
    ProcessClose(pid2)

MsgBox("Demonstration complete!`n`n" .
    "Key lesson: Working directory determines where relative paths point to.`n" .
    "Test files remain in: " . baseDir,
    "Complete", "Icon!")

} catch Error as err {
    MsgBox("Error: " . err.Message, "Error")
}
}

; ============================================================================
; Example 4: Multi-Instance Program Manager
; ============================================================================
; Launch multiple instances with different working directories

Example4_MultiInstance() {
    MsgBox("Example 4: Multi-Instance Program Manager`n`n" .
        "Launch multiple instances of programs with different working directories:",
        "Run - Example 4", "Icon!")

    ; Create instance directories
    baseDir := A_Temp . "\ahk_instances"
    instances := []

    try {
        if !DirExist(baseDir)
            DirCreate(baseDir)

        ; Create 3 instance directories
        Loop 3 {
            instanceDir := baseDir . "\Instance_" . A_Index
            if !DirExist(instanceDir)
                DirCreate(instanceDir)

            ; Create instance-specific config file
            configFile := instanceDir . "\config.txt"
            FileAppend("Instance Number: " . A_Index . "`n" .
                "Instance Name: Instance_" . A_Index . "`n" .
                "Created: " . A_Now . "`n" .
                "Working Directory: " . instanceDir,
                configFile)

            instances.Push({ dir: instanceDir, num: A_Index })
        }

        MsgBox("Created " . instances.Length . " instance directories.`n`n" .
            "Each has its own config.txt file.`n" .
            "We'll launch CMD for each instance...",
            "Instances Created", "T3")

        ; Launch CMD for each instance
        pids := []

        for instance in instances {
            cmdLine := 'cmd.exe /k "echo Instance ' . instance.num .
                ' & type config.txt & echo. & echo Working in: %CD%"'

            Run(cmdLine, instance.dir, , &pid)
            pids.Push(pid)

            Sleep(800)
        }

        MsgBox("Launched " . pids.Length . " CMD instances!`n`n" .
            "Each CMD window:`n" .
            "• Runs the same command`n" .
            "• Has different working directory`n" .
            "• Reads its own config.txt`n`n" .
            "PIDs: " . pids.Join(", "),
            "Instances Running", "Icon! T5")

        Sleep(6000)

        ; Cleanup
        for pid in pids {
            if ProcessExist(pid)
                ProcessClose(pid)
        }

        MsgBox("All instances closed.`n" .
            "Instance directories remain in: " . baseDir,
            "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

; ============================================================================
; Example 5: Development Environment Launcher
; ============================================================================
; Launch development tools with project-specific settings

Example5_DevEnvironment() {
    MsgBox("Example 5: Development Environment Launcher`n`n" .
        "Launch a complete development environment for a project:",
        "Run - Example 5", "Icon!")

    ; Create project structure
    projectDir := A_Temp . "\ahk_dev_project"
    srcDir := projectDir . "\src"
    docsDir := projectDir . "\docs"
    logsDir := projectDir . "\logs"

    try {
        ; Create directory structure
        for dir in [projectDir, srcDir, docsDir, logsDir] {
            if !DirExist(dir)
                DirCreate(dir)
        }

        ; Create sample files
        FileAppend("// Main source file`n" .
            "function main() {`n" .
            "    console.log('Hello from project');`n" .
            "}",
            srcDir . "\main.js")

        FileAppend("# Project Documentation`n`n" .
            "This is a sample development project.",
            docsDir . "\README.md")

        FileAppend("Project initialized: " . A_Now,
            logsDir . "\init.log")

        MsgBox("Created development project structure:`n`n" .
            "Project: " . projectDir . "`n" .
            "• src\ (source code)`n" .
            "• docs\ (documentation)`n" .
            "• logs\ (log files)",
            "Project Created", "T3")

        ; Launch development environment GUI
        CreateDevLauncher(projectDir, srcDir, docsDir, logsDir)

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreateDevLauncher(projectDir, srcDir, docsDir, logsDir) {
    dev := Gui(, "Development Environment Launcher")
    dev.SetFont("s10")

    dev.Add("Text", "w450", "Project: " . projectDir)
    dev.Add("Text", "w450 0x10")

    statusText := dev.Add("Text", "w450 h60 +Border",
        "Click buttons to launch development tools.`n" .
        "Each tool will open in its appropriate directory.")

    dev.Add("Text", "w450 0x10")

    ; Launch buttons
    dev.Add("Button", "w450 h35", "📁 Open Project Folder (Explorer)").OnEvent("Click", (*) => LaunchDevTool("explorer", projectDir, "Explorer", statusText))
    dev.Add("Button", "w450 h35", "💻 CMD in Project Root").OnEvent("Click", (*) => LaunchDevTool("cmd_root", projectDir, "CMD (Root)", statusText))
    dev.Add("Button", "w450 h35", "📝 CMD in Source Directory").OnEvent("Click", (*) => LaunchDevTool("cmd_src", srcDir, "CMD (Source)", statusText))
    dev.Add("Button", "w450 h35", "📄 Edit Source File (Notepad)").OnEvent("Click", (*) => LaunchDevTool("edit_src", srcDir, "Notepad (Source)", statusText))
    dev.Add("Button", "w450 h35", "📖 Edit Documentation (Notepad)").OnEvent("Click", (*) => LaunchDevTool("edit_docs", docsDir, "Notepad (Docs)", statusText))
    dev.Add("Button", "w450 h35", "📊 View Logs Directory").OnEvent("Click", (*) => LaunchDevTool("logs", logsDir, "Explorer (Logs)", statusText))

    dev.Add("Text", "w450 0x10")
    dev.Add("Button", "w450 h30", "Close").OnEvent("Click", (*) => dev.Destroy())

    LaunchDevTool(toolType, workDir, toolName, statusCtrl) {
        try {
            switch toolType {
                case "explorer":
                    Run("explorer.exe " . workDir)
                case "cmd_root", "cmd_src":
                    Run("cmd.exe /k dir", workDir, , &pid)
                    statusCtrl.Text := "✓ Launched: " . toolName . "`nWorking Dir: " . workDir . "`nPID: " . pid
                    return
                case "edit_src":
                    Run("notepad.exe main.js", workDir, , &pid)
                case "edit_docs":
                    Run("notepad.exe README.md", workDir, , &pid)
                case "logs":
                    Run("explorer.exe " . workDir)
            }
            statusCtrl.Text := "✓ Launched: " . toolName . "`nWorking Dir: " . workDir
        } catch Error as err {
            statusCtrl.Text := "❌ Failed: " . toolName . "`nError: " . err.Message
        }
    }

    dev.Show()

    MsgBox("Development Environment Launcher Ready!`n`n" .
        "Each button launches a tool with the appropriate working directory:`n" .
        "• Project tools use project root`n" .
        "• Source editor uses src directory`n" .
        "• Documentation editor uses docs directory`n`n" .
        "This simulates a real development workflow!",
        "Dev Environment", "Icon!")
}

; ============================================================================
; Example 6: Portable App Launcher
; ============================================================================
; Launch portable apps with proper working directories

Example6_PortableApps() {
    MsgBox("Example 6: Portable App Launcher`n`n" .
        "Demonstrate launching portable applications with correct working directories:",
        "Run - Example 6", "Icon!")

    ; Create portable app structure
    portableBase := A_Temp . "\ahk_portable_apps"
    app1Dir := portableBase . "\PortableApp1"
    app2Dir := portableBase . "\PortableApp2"

    try {
        ; Create structure
        for dir in [portableBase, app1Dir, app2Dir] {
            if !DirExist(dir)
                DirCreate(dir)
        }

        ; Create "portable apps" (batch files that show their context)
        CreatePortableApp(app1Dir, "App1", "1.0")
        CreatePortableApp(app2Dir, "App2", "2.0")

        MsgBox("Created portable app structure:`n`n" .
            "Base: " . portableBase . "`n" .
            "• PortableApp1`n" .
            "• PortableApp2`n`n" .
            "Each app has its own config and data files.",
            "Structure Created", "T3")

        ; Launch portable apps
        MsgBox("Launching PortableApp1 with its directory as working dir...", "Launching App1", "T2")
        Run(app1Dir . "\app.bat", app1Dir, , &pid1)

        Sleep(3000)

        MsgBox("Launching PortableApp2 with its directory as working dir...", "Launching App2", "T2")
        Run(app2Dir . "\app.bat", app2Dir, &pid2)

        Sleep(3000)

        MsgBox("Both apps are running from their own directories!`n`n" .
            "Each app can find its config and data files because " .
            "the working directory is set to the app's folder.`n`n" .
            "This is how portable apps work!",
            "Apps Running", "Icon! T4")

        Sleep(4000)

        ; Cleanup
        for pid in [pid1, pid2] {
            if ProcessExist(pid)
                ProcessClose(pid)
        }

        MsgBox("Portable apps closed.`n" .
            "Files remain in: " . portableBase,
            "Complete", "Icon!")

    } catch Error as err {
        MsgBox("Error: " . err.Message, "Error")
    }
}

CreatePortableApp(appDir, appName, version) {
    ; Create config file
    configFile := appDir . "\config.ini"
    FileAppend("[Settings]`n" .
        "AppName=" . appName . "`n" .
        "Version=" . version . "`n" .
        "DataDir=.\data`n" .
        "LogDir=.\logs",
        configFile)

    ; Create data directory
    dataDir := appDir . "\data"
    if !DirExist(dataDir)
        DirCreate(dataDir)

    FileAppend("Sample data for " . appName,
        dataDir . "\sample.dat")

    ; Create batch file (the "portable app")
    batchFile := appDir . "\app.bat"
    batchContent := "
                (
                @echo off
                echo ========================================
                echo " . appName . " v" . version . "
                echo ========================================
                echo.
                echo Working Directory: %CD%
                echo.
                echo Loading configuration from config.ini:
                type config.ini
                echo.
                echo Data files in .\data:
                dir /b data
                echo.
                pause
                )"
    FileAppend(batchContent, batchFile)
}

; ============================================================================
; Main Menu
; ============================================================================

ShowMainMenu() {
    menu := Gui(, "Run Function Examples (Part 3) - Main Menu")
    menu.SetFont("s10")

    menu.Add("Text", "w500", "AutoHotkey v2 - Run Function (Working Directory Advanced)")
    menu.SetFont("s9")
    menu.Add("Text", "w500", "Select an example to run:")

    menu.Add("Button", "w500 h35", "Example 1: Working Directory vs Script Directory").OnEvent("Click", (*) => (menu.Hide(), Example1_DirectoryDifference(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 2: Project-Based Program Launcher").OnEvent("Click", (*) => (menu.Hide(), Example2_ProjectLauncher(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 3: Relative Path Resolution").OnEvent("Click", (*) => (menu.Hide(), Example3_RelativePaths(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 4: Multi-Instance Program Manager").OnEvent("Click", (*) => (menu.Hide(), Example4_MultiInstance(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 5: Development Environment Launcher").OnEvent("Click", (*) => (menu.Hide(), Example5_DevEnvironment(), menu.Show()))
    menu.Add("Button", "w500 h35", "Example 6: Portable App Launcher").OnEvent("Click", (*) => (menu.Hide(), Example6_PortableApps(), menu.Show()))

    menu.Add("Text", "w500 0x10")
    menu.Add("Button", "w500 h30", "Exit").OnEvent("Click", (*) => ExitApp())

    menu.Show()
}

ShowMainMenu()
