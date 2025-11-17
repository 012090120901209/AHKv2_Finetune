#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * DirSelect Basic Examples - Part 1
 * ============================================================================
 *
 * Comprehensive examples demonstrating DirSelect usage in AutoHotkey v2.
 *
 * @description This file covers fundamental DirSelect functionality including:
 *              - Basic folder selection
 *              - Initial directory specification
 *              - Dialog options and prompts
 *              - Folder validation
 *              - Common directory shortcuts
 *              - Folder creation options
 *
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/DirSelect.htm
 *
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Basic Folder Selection
; ============================================================================
/**
 * Demonstrates basic folder selection dialog.
 *
 * @description Shows how to open folder selection dialogs and
 *              handle selected directories.
 */
Example1_BasicFolderSelection() {
    ; Simple folder select
    selectedFolder := DirSelect()

    if (selectedFolder != "") {
        MsgBox "You selected:`n`n" . selectedFolder
        ShowFolderInfo(selectedFolder)
    } else {
        MsgBox "No folder was selected (dialog cancelled)."
    }

    ; Folder select with starting directory
    selectedFolder := DirSelect(A_MyDocuments, , "Select a folder from Documents")

    if (selectedFolder != "") {
        MsgBox "Selected from Documents:`n`n" . selectedFolder
    }

    ; Folder select from Desktop
    selectedFolder := DirSelect(A_Desktop, , "Select a folder from Desktop")

    if (selectedFolder != "") {
        MsgBox "Selected from Desktop:`n`n" . selectedFolder
    }

    ; Folder select with custom prompt
    selectedFolder := DirSelect("", , "Choose destination folder for backup")

    if (selectedFolder != "") {
        MsgBox "Backup destination:`n`n" . selectedFolder
    }

    ; Folder select from specific path
    selectedFolder := DirSelect("C:\", , "Select a folder from C: drive")

    if (selectedFolder != "") {
        MsgBox "Selected folder:`n`n" . selectedFolder
    }
}

/**
 * Shows folder information.
 */
ShowFolderInfo(folderPath) {
    if (DirExist(folderPath)) {
        ; Count files in folder (non-recursive)
        fileCount := 0
        Loop Files folderPath . "\*.*" {
            fileCount++
        }

        ; Count subfolders
        folderCount := 0
        Loop Files folderPath . "\*.*", "D" {
            folderCount++
        }

        MsgBox Format("═══ Folder Information ═══`n`n"
                    . "Path: {1}`n`n"
                    . "Files: {2}`n"
                    . "Subfolders: {3}",
                    folderPath,
                    fileCount,
                    folderCount)
    }
}

; ============================================================================
; EXAMPLE 2: Initial Directory Options
; ============================================================================
/**
 * Shows different initial directory configurations.
 *
 * @description Demonstrates starting the dialog in various locations.
 */
Example2_InitialDirectories() {
    ; Start in Desktop
    folder := DirSelect(A_Desktop, , "Select from Desktop")
    if (folder != "")
        MsgBox "Desktop folder: " . folder

    ; Start in Documents
    folder := DirSelect(A_MyDocuments, , "Select from Documents")
    if (folder != "")
        MsgBox "Documents folder: " . folder

    ; Start in User Profile
    folder := DirSelect(A_UserProfile, , "Select from User Profile")
    if (folder != "")
        MsgBox "User folder: " . folder

    ; Start in Script Directory
    folder := DirSelect(A_ScriptDir, , "Select from Script Directory")
    if (folder != "")
        MsgBox "Script folder: " . folder

    ; Start in Program Files
    folder := DirSelect(A_ProgramFiles, , "Select from Program Files")
    if (folder != "")
        MsgBox "Program Files folder: " . folder

    ; Start in Temp
    folder := DirSelect(A_Temp, , "Select from Temp")
    if (folder != "")
        MsgBox "Temp folder: " . folder

    ; Start in AppData
    folder := DirSelect(A_AppData, , "Select from AppData")
    if (folder != "")
        MsgBox "AppData folder: " . folder

    ; Custom starting directory
    customPath := "C:\Projects"
    if (DirExist(customPath)) {
        folder := DirSelect(customPath, , "Select from Projects")
        if (folder != "")
            MsgBox "Project folder: " . folder
    }
}

; ============================================================================
; EXAMPLE 3: Dialog Options
; ============================================================================
/**
 * Demonstrates DirSelect dialog options.
 *
 * @description Shows different option combinations.
 *
 * Options:
 * - 0: Default behavior
 * - 1: Provide edit field for manual path entry
 * - 2: "New Folder" button (pre-Vista)
 */
Example3_DialogOptions() {
    ; Default option (browse only)
    folder := DirSelect("", 0, "Browse for folder")
    if (folder != "")
        MsgBox "Default: " . folder

    ; Allow manual path entry (option 1)
    folder := DirSelect("", 1, "Browse or type folder path")
    if (folder != "") {
        if (DirExist(folder))
            MsgBox "Folder exists: " . folder
        else
            MsgBox "Folder does not exist: " . folder
    }

    ; With new folder button (option 2 - pre-Vista systems)
    folder := DirSelect("", 2, "Select or create new folder")
    if (folder != "")
        MsgBox "Selected: " . folder

    ; Combined options (1 + 2 = 3)
    folder := DirSelect("", 3, "Full options enabled")
    if (folder != "")
        MsgBox "Full options: " . folder

    ; Specific starting point with options
    folder := DirSelect(A_MyDocuments, 1, "Documents (type or browse)")
    if (folder != "")
        MsgBox "Selected: " . folder
}

; ============================================================================
; EXAMPLE 4: Folder Validation
; ============================================================================
/**
 * Shows folder validation after selection.
 *
 * @description Demonstrates validating selected folders.
 */
Example4_FolderValidation() {
    ; Validate folder exists
    folder := DirSelect("", , "Select an existing folder")

    if (folder != "") {
        if (ValidateFolderExists(folder)) {
            MsgBox "Valid folder selected: " . folder
        } else {
            MsgBox "Folder does not exist!", "Error", "Iconx"
        }
    }

    ; Validate folder is writable
    folder := DirSelect("", , "Select a writable folder")

    if (folder != "" && ValidateFolderWritable(folder)) {
        MsgBox "Folder is writable: " . folder
    }

    ; Validate folder is not empty
    folder := DirSelect("", , "Select a non-empty folder")

    if (folder != "") {
        if (ValidateFolderNotEmpty(folder)) {
            MsgBox "Folder contains files/folders."
        } else {
            MsgBox "Folder is empty!", "Warning", "Icon!"
        }
    }

    ; Validate folder has minimum space
    folder := DirSelect("", , "Select folder (min 100 MB free)")

    if (folder != "" && ValidateFolderSpace(folder, 104857600)) {
        MsgBox "Folder has sufficient space."
    }

    ; Validate folder path length
    folder := DirSelect("", , "Select folder")

    if (folder != "" && ValidatePathLength(folder, 200)) {
        MsgBox "Path length is acceptable."
    } else if (folder != "") {
        MsgBox "Path is too long!", "Warning", "Icon!"
    }
}

/**
 * Validates folder exists.
 */
ValidateFolderExists(folderPath) {
    return DirExist(folderPath) != ""
}

/**
 * Validates folder is writable.
 */
ValidateFolderWritable(folderPath) {
    testFile := folderPath . "\~test_write.tmp"

    try {
        FileAppend "", testFile
        FileDelete testFile
        return true
    } catch {
        return false
    }
}

/**
 * Validates folder is not empty.
 */
ValidateFolderNotEmpty(folderPath) {
    Loop Files folderPath . "\*.*", "FD" {
        return true  ; Found at least one item
    }
    return false
}

/**
 * Validates folder has minimum free space.
 */
ValidateFolderSpace(folderPath, minBytes) {
    ; Extract drive letter
    drive := SubStr(folderPath, 1, 2)

    try {
        freeSpace := DriveGetSpaceFree(drive)
        return (freeSpace * 1048576) >= minBytes
    } catch {
        return false
    }
}

/**
 * Validates path length.
 */
ValidatePathLength(path, maxLength) {
    return StrLen(path) <= maxLength
}

; ============================================================================
; EXAMPLE 5: Common Directory Shortcuts
; ============================================================================
/**
 * Demonstrates using system directory shortcuts.
 *
 * @description Shows quick access to common folders.
 */
Example5_SystemShortcuts() {
    ; Desktop
    SelectSystemFolder("Desktop", A_Desktop)

    ; Documents
    SelectSystemFolder("Documents", A_MyDocuments)

    ; Downloads (construct path)
    SelectSystemFolder("Downloads", A_MyDocuments . "\..\Downloads")

    ; Pictures
    SelectSystemFolder("Pictures", A_MyDocuments . "\Pictures")

    ; Music
    SelectSystemFolder("Music", A_MyDocuments . "\Music")

    ; Videos
    SelectSystemFolder("Videos", A_MyDocuments . "\Videos")

    ; AppData Roaming
    SelectSystemFolder("AppData Roaming", A_AppData)

    ; AppData Local
    SelectSystemFolder("AppData Local", A_AppDataLocal)

    ; Program Data
    SelectSystemFolder("ProgramData", A_AppDataCommon)
}

/**
 * Selects from a system folder.
 */
SelectSystemFolder(name, path) {
    if (DirExist(path)) {
        folder := DirSelect(path, , Format("Select from {1}", name))

        if (folder != "") {
            MsgBox Format("{1} folder selected:`n{2}", name, folder)
        }
    } else {
        MsgBox Format("{1} folder not found: {2}", name, path),
               "Warning",
               "Icon!"
    }
}

; ============================================================================
; EXAMPLE 6: Folder Creation Workflow
; ============================================================================
/**
 * Shows folder creation workflows.
 *
 * @description Demonstrates creating folders after selection.
 */
Example6_FolderCreation() {
    ; Select and create if needed
    folder := DirSelect("", 1, "Select or enter new folder path")

    if (folder != "") {
        if (!DirExist(folder)) {
            create := MsgBox(Format("Folder does not exist:`n{1}`n`nCreate it?",
                                   folder),
                           "Create Folder",
                           "YesNo Icon?")

            if (create = "Yes") {
                try {
                    DirCreate folder
                    MsgBox "Folder created successfully!", "Success", "Iconi"
                } catch as err {
                    MsgBox "Failed to create folder!`n`n" . err.Message,
                           "Error",
                           "Iconx"
                }
            }
        } else {
            MsgBox "Folder already exists: " . folder
        }
    }

    ; Create nested folder structure
    CreateNestedFolders()

    ; Create project structure
    CreateProjectStructure()
}

/**
 * Creates nested folders.
 */
CreateNestedFolders() {
    baseFolder := DirSelect("", , "Select base folder for nested structure")

    if (baseFolder = "")
        return

    projectName := InputBox("Enter project name:", "Project Name").Value

    if (projectName = "")
        return

    ; Create structure
    folders := [
        baseFolder . "\" . projectName,
        baseFolder . "\" . projectName . "\src",
        baseFolder . "\" . projectName . "\docs",
        baseFolder . "\" . projectName . "\tests",
        baseFolder . "\" . projectName . "\output"
    ]

    created := 0
    for folderPath in folders {
        try {
            if (!DirExist(folderPath)) {
                DirCreate folderPath
                created++
            }
        }
    }

    MsgBox Format("Created {1} folders for project: {2}",
                 created,
                 projectName),
           "Project Structure Created",
           "Iconi"
}

/**
 * Creates complete project structure.
 */
CreateProjectStructure() {
    rootFolder := DirSelect("", , "Select root folder for project")

    if (rootFolder = "")
        return

    structure := [
        "\src",
        "\src\lib",
        "\src\utils",
        "\docs",
        "\tests",
        "\tests\unit",
        "\tests\integration",
        "\output",
        "\resources"
    ]

    for subFolder in structure {
        fullPath := rootFolder . subFolder
        try {
            if (!DirExist(fullPath))
                DirCreate fullPath
        }
    }

    MsgBox "Project structure created in:`n`n" . rootFolder,
           "Complete",
           "Iconi"
}

; ============================================================================
; EXAMPLE 7: Practical Folder Selection Scenarios
; ============================================================================
/**
 * Real-world folder selection scenarios.
 *
 * @description Practical examples for common use cases.
 */
Example7_PracticalScenarios() {
    ; Backup destination selection
    SelectBackupDestination()

    ; Install directory selection
    SelectInstallDirectory()

    ; Export folder selection
    SelectExportFolder()

    ; Project directory selection
    SelectProjectDirectory()

    ; Cache directory selection
    SelectCacheDirectory()
}

/**
 * Selects backup destination.
 */
SelectBackupDestination() {
    backupFolder := DirSelect("", ,
                             "Select backup destination folder")

    if (backupFolder = "") {
        MsgBox "Backup cancelled - no destination selected."
        return
    }

    ; Validate sufficient space
    if (!ValidateFolderWritable(backupFolder)) {
        MsgBox "Cannot write to selected folder!", "Error", "Iconx"
        return
    }

    ; Create backup subfolder with timestamp
    timestamp := FormatTime(, "yyyyMMdd_HHmmss")
    backupPath := backupFolder . "\Backup_" . timestamp

    try {
        DirCreate backupPath
        MsgBox Format("Backup will be saved to:`n`n{1}", backupPath),
               "Backup Ready",
               "Iconi"
    } catch as err {
        MsgBox "Failed to create backup folder!`n`n" . err.Message,
               "Error",
               "Iconx"
    }
}

/**
 * Selects installation directory.
 */
SelectInstallDirectory() {
    defaultInstall := A_ProgramFiles . "\MyApplication"

    installDir := DirSelect(A_ProgramFiles, 1,
                           "Select installation directory")

    if (installDir = "") {
        MsgBox "Installation cancelled."
        return
    }

    ; Check if folder exists
    if (DirExist(installDir)) {
        overwrite := MsgBox("Directory already exists:`n`n" . installDir
                          . "`n`nOverwrite existing installation?",
                          "Directory Exists",
                          "YesNo Icon!")

        if (overwrite = "No") {
            MsgBox "Installation cancelled."
            return
        }
    }

    MsgBox Format("Application will be installed to:`n`n{1}",
                 installDir),
           "Installation Path",
           "Iconi"
}

/**
 * Selects export folder.
 */
SelectExportFolder() {
    exportFolder := DirSelect(A_MyDocuments, ,
                             "Select folder for exported files")

    if (exportFolder = "") {
        MsgBox "Export cancelled."
        return
    }

    ; Create export subfolder
    exportSubFolder := exportFolder . "\Export_" . FormatTime(, "yyyyMMdd")

    if (!DirExist(exportSubFolder)) {
        try {
            DirCreate exportSubFolder
            MsgBox Format("Files will be exported to:`n`n{1}",
                         exportSubFolder),
                   "Export Ready",
                   "Iconi"
        }
    } else {
        MsgBox Format("Using existing export folder:`n`n{1}",
                     exportSubFolder),
               "Export Folder",
               "Iconi"
    }
}

/**
 * Selects project directory.
 */
SelectProjectDirectory() {
    projectFolder := DirSelect("", ,
                              "Select or create project directory")

    if (projectFolder = "") {
        MsgBox "Project setup cancelled."
        return
    }

    ; Check if it's a new project
    if (!DirExist(projectFolder)) {
        create := MsgBox(Format("Create new project at:`n`n{1}",
                               projectFolder),
                        "New Project",
                        "YesNo Icon?")

        if (create = "Yes") {
            try {
                DirCreate projectFolder
                MsgBox "Project directory created!`n`nSetup complete.",
                       "Success",
                       "Iconi"
            }
        }
    } else {
        MsgBox "Opening existing project:`n`n" . projectFolder,
               "Existing Project",
               "Iconi"
    }
}

/**
 * Selects cache directory.
 */
SelectCacheDirectory() {
    defaultCache := A_Temp . "\AppCache"

    cacheFolder := DirSelect(A_Temp, ,
                            "Select cache directory")

    if (cacheFolder = "") {
        cacheFolder := defaultCache
        MsgBox "Using default cache directory:`n`n" . cacheFolder
    }

    ; Ensure cache directory exists
    if (!DirExist(cacheFolder)) {
        try {
            DirCreate cacheFolder
            MsgBox "Cache directory created:`n`n" . cacheFolder,
                   "Cache Ready",
                   "Iconi"
        }
    }

    ; Optionally clear old cache
    clearCache := MsgBox("Clear existing cache files?",
                        "Clear Cache",
                        "YesNo Icon?")

    if (clearCache = "Yes") {
        MsgBox "Cache would be cleared (demo mode)",
               "Clear Cache",
               "Iconi"
        ; DirDelete cacheFolder, true
        ; DirCreate cacheFolder
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1::Example1_BasicFolderSelection()
^2::Example2_InitialDirectories()
^3::Example3_DialogOptions()
^4::Example4_FolderValidation()
^5::Example5_SystemShortcuts()
^6::Example6_FolderCreation()
^7::Example7_PracticalScenarios()
^0::ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 *
 * DirSelect fundamentals covered:
 * 1. Basic folder selection with prompts
 * 2. Initial directory configuration (system folders)
 * 3. Dialog options (manual entry, new folder button)
 * 4. Folder validation (exists, writable, not empty, space)
 * 5. System directory shortcuts (Desktop, Documents, etc.)
 * 6. Folder creation workflows
 * 7. Practical scenarios (backup, install, export, project, cache)
 *
 * Key Points:
 * - DirSelect returns empty string if cancelled
 * - First parameter is starting directory
 * - Second parameter is options (0/1/2/3)
 * - Third parameter is dialog prompt
 * - Always validate returned paths
 * - Check if folder exists before use
 * - Handle folder creation errors
 * - Provide clear user feedback
 *
 * Common Options:
 * - 0: Default browse only
 * - 1: Allow manual path entry
 * - 2: Show "New Folder" button
 * - 3: Both manual entry and new folder button
 *
 * ============================================================================
 */
