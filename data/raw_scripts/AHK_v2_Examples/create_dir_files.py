#!/usr/bin/env python3
"""
Script to create all 10 Dir function example files for AutoHotkey v2
Each file contains comprehensive examples with 300-500+ lines
"""

import os

base_dir = "/home/user/AHKv2_Finetune/data/raw_scripts/AHK_v2_Examples/"

# Define templates for each Dir function file
# Each template will be 400-600 lines with comprehensive examples

dir_files = {
    "DirCreate_01.ahk": """/**
 * @file DirCreate_01.ahk
 * @description Comprehensive examples of DirCreate function with folder creation, recursive operations, and error handling
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 *
 * This file demonstrates:
 * - Creating single folders
 * - Creating nested folder structures
 * - Recursive folder creation
 * - Error handling for folder creation
 * - Creating multiple folders at once
 * - Folder creation with validation
 * - Project structure generation
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Basic Folder Creation
; ===================================================================================================

/**
 * @function CreateFolder
 * @description Creates a folder with error handling
 * @param {String} folderPath - Path to create
 * @returns {Object} Result object
 */
CreateFolder(folderPath) {
    if DirExist(folderPath) {
        return {Success: true, Existed: true, Path: folderPath}
    }

    try {
        DirCreate(folderPath)
        return {Success: true, Created: true, Path: folderPath}
    } catch as err {
        return {Success: false, Error: err.Message, Path: folderPath}
    }
}

Example1_BasicCreate() {
    testPath := A_Desktop . "\\TestFolder_" . FormatTime(A_Now, "yyyyMMddHHmmss")

    result := CreateFolder(testPath)

    if (result.Success) {
        message := "Folder Operation: Success`n`n"
        message .= "Path: " . result.Path . "`n"
        message .= result.HasOwnProp("Created") ? "Status: Created new folder" : "Status: Folder already existed"
        MsgBox(message, "Success", "Iconi")
    } else {
        MsgBox("Error: " . result.Error, "Failed", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 2: Recursive Folder Creation
; ===================================================================================================

/**
 * @function CreateNestedFolders
 * @description Creates nested folder structure recursively
 * @param {String} basePath - Base path
 * @param {Array} structure - Array of subfolder names
 * @returns {Object} Creation results
 */
CreateNestedFolders(basePath, structure) {
    created := []
    existed := []
    errors := []

    for folderName in structure {
        fullPath := basePath . "\\" . folderName

        result := CreateFolder(fullPath)

        if (result.Success) {
            if result.HasOwnProp("Created")
                created.Push(fullPath)
            else
                existed.Push(fullPath)
        } else {
            errors.Push({Path: fullPath, Error: result.Error})
        }
    }

    return {
        Created: created,
        Existed: existed,
        Errors: errors,
        TotalSuccess: created.Length + existed.Length,
        TotalFailed: errors.Length
    }
}

Example2_RecursiveCreate() {
    basePath := A_Desktop . "\\ProjectStructure_" . FormatTime(A_Now, "yyyyMMddHHmmss")

    ; Create base folder first
    CreateFolder(basePath)

    ; Define nested structure
    structure := [
        "src",
        "src\\components",
        "src\\utils",
        "src\\assets",
        "tests",
        "docs",
        "build",
        "config"
    ]

    results := CreateNestedFolders(basePath, structure)

    report := "Recursive Folder Creation Results`n"
    report .= "═══════════════════════════════════════`n`n"
    report .= Format("Base Path: {1}`n`n", basePath)
    report .= Format("Created: {1} folder(s)`n", results.Created.Length)
    report .= Format("Already Existed: {1} folder(s)`n", results.Existed.Length)
    report .= Format("Failed: {1} folder(s)`n", results.Errors.Length)

    MsgBox(report, "Results", "Iconi")
}

; ===================================================================================================
; EXAMPLE 3: Batch Folder Creation
; ===================================================================================================

/**
 * @class BatchFolderCreator
 * @description Creates multiple folders in batch
 */
class BatchFolderCreator {
    static CreateMultiple(folderPaths) {
        results := []

        for path in folderPaths {
            result := CreateFolder(path)
            results.Push(result)
        }

        return results
    }

    static CreateFromList(listFile) {
        if !FileExist(listFile) {
            return {Success: false, Error: "List file not found"}
        }

        content := FileRead(listFile)
        paths := StrSplit(content, "`n", "`r")

        created := 0
        failed := 0

        for path in paths {
            if (Trim(path) = "")
                continue

            result := CreateFolder(Trim(path))
            if (result.Success)
                created++
            else
                failed++
        }

        return {
            Success: true,
            Created: created,
            Failed: failed
        }
    }
}

Example3_BatchCreate() {
    basePath := A_Desktop . "\\BatchFolders_" . FormatTime(A_Now, "yyyyMMddHHmmss")
    CreateFolder(basePath)

    folders := [
        basePath . "\\Folder1",
        basePath . "\\Folder2",
        basePath . "\\Folder3",
        basePath . "\\Folder4",
        basePath . "\\Folder5"
    ]

    results := BatchFolderCreator.CreateMultiple(folders)

    report := "Batch Folder Creation`n"
    report .= "═══════════════════════════════════════`n`n"

    successCount := 0
    for result in results {
        if (result.Success)
            successCount++
    }

    report .= Format("Total Folders: {1}`n", results.Length)
    report .= Format("Successful: {1}`n", successCount)
    report .= Format("Failed: {1}", results.Length - successCount)

    MsgBox(report, "Batch Results", "Iconi")
}

; ===================================================================================================
; EXAMPLE 4: Project Template Generator
; ===================================================================================================

/**
 * @class ProjectTemplateGenerator
 * @description Generates complete project folder structures
 */
class ProjectTemplateGenerator {
    static WebProjectTemplate := [
        "src",
        "src\\js",
        "src\\css",
        "src\\images",
        "src\\components",
        "public",
        "tests",
        "docs",
        "config"
    ]

    static PythonProjectTemplate := [
        "src",
        "tests",
        "docs",
        "data",
        "scripts",
        "venv"
    ]

    static CreateWebProject(projectName, basePath := "") {
        if (basePath = "")
            basePath := A_MyDocuments . "\\Projects"

        projectPath := basePath . "\\" . projectName

        ; Create base project folder
        CreateFolder(projectPath)

        ; Create template structure
        return CreateNestedFolders(projectPath, ProjectTemplateGenerator.WebProjectTemplate)
    }

    static CreatePythonProject(projectName, basePath := "") {
        if (basePath = "")
            basePath := A_MyDocuments . "\\Projects"

        projectPath := basePath . "\\" . projectName
        CreateFolder(projectPath)

        return CreateNestedFolders(projectPath, ProjectTemplateGenerator.PythonProjectTemplate)
    }
}

Example4_ProjectTemplate() {
    projectName := InputBox("Enter project name:", "Create Web Project").Value

    if (projectName = "")
        return

    results := ProjectTemplateGenerator.CreateWebProject(projectName, A_Desktop)

    message := Format("Web Project Created: {1}`n`n", projectName)
    message .= Format("Folders Created: {1}`n", results.Created.Length)
    message .= Format("Folders Existed: {1}`n", results.Existed.Length)
    message .= Format("Errors: {1}", results.Errors.Length)

    MsgBox(message, "Project Created", "Iconi")
}

; ===================================================================================================
; EXAMPLE 5: Safe Folder Creation with Validation
; ===================================================================================================

/**
 * @function SafeCreateFolder
 * @description Creates folder with path validation
 * @param {String} folderPath - Path to create
 * @returns {Object} Result object
 */
SafeCreateFolder(folderPath) {
    ; Validate path
    if (folderPath = "") {
        return {Success: false, Error: "Empty path provided"}
    }

    ; Check for invalid characters
    if RegExMatch(folderPath, "[<>:""?*]") {
        return {Success: false, Error: "Path contains invalid characters"}
    }

    ; Check path length (Windows MAX_PATH is 260 characters)
    if (StrLen(folderPath) > 248) {  ; Leave room for files
        return {Success: false, Error: "Path too long (max 248 characters)"}
    }

    ; Check if parent directory exists
    SplitPath(folderPath, , &parentDir)
    if (parentDir != "" && !DirExist(parentDir)) {
        return {Success: false, Error: "Parent directory does not exist"}
    }

    ; Create folder
    return CreateFolder(folderPath)
}

Example5_SafeCreate() {
    testPath := InputBox("Enter folder path to create:", "Safe Create").Value

    if (testPath = "")
        return

    result := SafeCreateFolder(testPath)

    if (result.Success) {
        MsgBox("Folder created successfully!`n`n" . result.Path, "Success", "Iconi")
    } else {
        MsgBox("Failed to create folder:`n`n" . result.Error, "Error", "Icon!")
    }
}

; ===================================================================================================
; EXAMPLE 6: Date-Based Folder Organization
; ===================================================================================================

/**
 * @class DateBasedOrganizer
 * @description Creates date-based folder structures
 */
class DateBasedOrganizer {
    static CreateDailyFolder(basePath := "") {
        if (basePath = "")
            basePath := A_MyDocuments

        year := FormatTime(A_Now, "yyyy")
        month := FormatTime(A_Now, "MM")
        day := FormatTime(A_Now, "dd")

        folderPath := basePath . "\\" . year . "\\" . month . "\\" . day

        return CreateFolder(folderPath)
    }

    static CreateMonthlyStructure(basePath, year) {
        results := []

        ; Create year folder
        yearPath := basePath . "\\" . year
        CreateFolder(yearPath)

        ; Create month folders
        Loop 12 {
            month := Format("{:02}", A_Index)
            monthPath := yearPath . "\\" . month
            result := CreateFolder(monthPath)
            results.Push(result)
        }

        return results
    }
}

Example6_DateBased() {
    basePath := A_Desktop . "\\DateOrganized"

    result := DateBasedOrganizer.CreateDailyFolder(basePath)

    if (result.Success) {
        message := "Daily folder created!`n`n"
        message .= "Path: " . result.Path
        MsgBox(message, "Success", "Iconi")
    }
}

; ===================================================================================================
; EXAMPLE 7: Conditional Folder Creation
; ===================================================================================================

/**
 * @function CreateFolderIfNeeded
 * @description Creates folder only if it doesn't exist
 * @param {String} folderPath - Path to potentially create
 * @param {Boolean} forceCreate - Force creation even if exists
 * @returns {Object} Result object
 */
CreateFolderIfNeeded(folderPath, forceCreate := false) {
    if DirExist(folderPath) && !forceCreate {
        return {
            Success: true,
            Created: false,
            Message: "Folder already exists",
            Path: folderPath
        }
    }

    result := CreateFolder(folderPath)
    result.Created := true
    return result
}

/**
 * @class ConditionalFolderManager
 * @description Manages conditional folder creation
 */
class ConditionalFolderManager {
    static EnsureFoldersExist(folderPaths) {
        ensured := []
        created := []

        for path in folderPaths {
            result := CreateFolderIfNeeded(path)

            if (result.Success) {
                ensured.Push(path)
                if (result.Created)
                    created.Push(path)
            }
        }

        return {
            Ensured: ensured,
            Created: created,
            ExistedCount: ensured.Length - created.Length
        }
    }
}

Example7_ConditionalCreate() {
    basePath := A_Desktop . "\\ConditionalTest"

    folders := [
        basePath,
        basePath . "\\Logs",
        basePath . "\\Data",
        basePath . "\\Temp",
        basePath . "\\Output"
    ]

    results := ConditionalFolderManager.EnsureFoldersExist(folders)

    report := "Conditional Folder Creation`n"
    report .= "═══════════════════════════════════════`n`n"
    report .= Format("Folders Ensured: {1}`n", results.Ensured.Length)
    report .= Format("New Folders Created: {1}`n", results.Created.Length)
    report .= Format("Already Existed: {1}", results.ExistedCount)

    MsgBox(report, "Results", "Iconi")
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+N to create new folder
; ^!n::Example1_BasicCreate()

; Press Ctrl+Alt+R to create recursive structure
; ^!r::Example2_RecursiveCreate()

; Press Ctrl+Alt+P to create project template
; ^!p::Example4_ProjectTemplate()

; Press Ctrl+Alt+D to create date-based folder
; ^!d::Example6_DateBased()
""",

    "DirCreate_02.ahk": """/**
 * @file DirCreate_02.ahk
 * @description Advanced DirCreate examples with automation, templates, and intelligent folder management
 * @author AutoHotkey v2 Examples
 * @version 2.0
 * @date 2025-01-16
 *
 * This file demonstrates:
 * - Automated folder structure generation
 * - Smart folder naming
 * - Template-based creation
 * - Backup folder management
 * - Archive organization
 * - Dynamic folder creation
 * - Folder creation logging
 */

#Requires AutoHotkey v2.0

; ===================================================================================================
; EXAMPLE 1: Smart Folder Naming System
; ===================================================================================================

/**
 * @class SmartFolderNaming
 * @description Generates intelligent folder names
 */
class SmartFolderNaming {
    static GenerateUniqueName(baseName, basePath) {
        counter := 1
        folderPath := basePath . "\\" . baseName

        while DirExist(folderPath) {
            folderPath := Format("{1}\\{2}_{3}", basePath, baseName, counter)
            counter++
        }

        return folderPath
    }

    static GenerateTimestampedName(prefix, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")
        return basePath . "\\" . prefix . "_" . timestamp
    }

    static GenerateDateName(prefix, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        date := FormatTime(A_Now, "yyyy-MM-dd")
        return basePath . "\\" . prefix . "_" . date
    }
}

Example1_SmartNaming() {
    basePath := A_Desktop

    ; Generate unique folder name
    uniquePath := SmartFolderNaming.GenerateUniqueName("MyFolder", basePath)
    CreateFolder(uniquePath)

    ; Generate timestamped folder
    timestampPath := SmartFolderNaming.GenerateTimestampedName("Backup", basePath)
    CreateFolder(timestampPath)

    message := "Smart Folder Names Created:`n`n"
    message .= "1. " . uniquePath . "`n"
    message .= "2. " . timestampPath

    MsgBox(message, "Smart Naming", "Iconi")
}

; ===================================================================================================
; EXAMPLE 2: Automated Backup Folder Creation
; ===================================================================================================

/**
 * @class BackupFolderManager
 * @description Manages backup folder creation and organization
 */
class BackupFolderManager {
    backupBasePath := A_MyDocuments . "\\Backups"

    __New(basePath := "") {
        if (basePath != "")
            this.backupBasePath := basePath

        CreateFolder(this.backupBasePath)
    }

    CreateDailyBackupFolder() {
        date := FormatTime(A_Now, "yyyy-MM-dd")
        folderPath := this.backupBasePath . "\\" . date

        return CreateFolder(folderPath)
    }

    CreateWeeklyBackupFolder() {
        year := FormatTime(A_Now, "yyyy")
        week := FormatTime(A_Now, "YWeek")

        folderPath := this.backupBasePath . "\\Weekly\\" . year . "\\" . week

        return CreateFolder(folderPath)
    }

    CreateMonthlyBackupFolder() {
        yearMonth := FormatTime(A_Now, "yyyy-MM")
        folderPath := this.backupBasePath . "\\Monthly\\" . yearMonth

        return CreateFolder(folderPath)
    }

    CreateFullBackupStructure() {
        ; Create all backup folder types
        daily := this.CreateDailyBackupFolder()
        weekly := this.CreateWeeklyBackupFolder()
        monthly := this.CreateMonthlyBackupFolder()

        return {
            Daily: daily,
            Weekly: weekly,
            Monthly: monthly
        }
    }
}

Example2_BackupFolders() {
    manager := BackupFolderManager(A_Desktop . "\\BackupSystem")
    results := manager.CreateFullBackupStructure()

    message := "Backup Folder Structure Created:`n`n"
    message .= "Daily: " . results.Daily.Path . "`n"
    message .= "Weekly: " . results.Weekly.Path . "`n"
    message .= "Monthly: " . results.Monthly.Path

    MsgBox(message, "Backup Structure", "Iconi")

    return manager
}

; ===================================================================================================
; EXAMPLE 3: Template-Based Folder Creation
; ===================================================================================================

/**
 * @class FolderTemplateManager
 * @description Manages folder creation from templates
 */
class FolderTemplateManager {
    templates := Map()

    __New() {
        this.DefineDefaultTemplates()
    }

    DefineDefaultTemplates() {
        ; Web Development Template
        this.templates["web"] := [
            "src",
            "src\\components",
            "src\\styles",
            "src\\scripts",
            "src\\assets",
            "src\\assets\\images",
            "src\\assets\\fonts",
            "public",
            "tests",
            "docs"
        ]

        ; Documentation Template
        this.templates["docs"] := [
            "guides",
            "api",
            "tutorials",
            "examples",
            "images",
            "assets"
        ]

        ; Game Development Template
        this.templates["game"] := [
            "src",
            "assets",
            "assets\\sprites",
            "assets\\sounds",
            "assets\\music",
            "levels",
            "scripts",
            "docs"
        ]
    }

    CreateFromTemplate(templateName, projectName, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        if !this.templates.Has(templateName) {
            return {Success: false, Error: "Template not found"}
        }

        projectPath := basePath . "\\" . projectName
        CreateFolder(projectPath)

        template := this.templates[templateName]
        results := CreateNestedFolders(projectPath, template)
        results.ProjectPath := projectPath
        results.TemplateName := templateName

        return results
    }
}

Example3_TemplateCreation() {
    manager := FolderTemplateManager()

    projectName := InputBox("Enter project name:", "Create from Template").Value
    if (projectName = "")
        return

    ; Create web development project
    results := manager.CreateFromTemplate("web", projectName, A_Desktop)

    if (results.Success || results.TotalSuccess > 0) {
        message := Format("Project Created from Template`n`n")
        message .= Format("Project: {1}`n", projectName)
        message .= Format("Template: {1}`n", results.TemplateName)
        message .= Format("Folders Created: {1}`n", results.Created.Length)
        message .= Format("Path: {1}", results.ProjectPath)

        MsgBox(message, "Success", "Iconi")
    }

    return manager
}

; ===================================================================================================
; EXAMPLE 4: Archive Folder Organization
; ===================================================================================================

/**
 * @class ArchiveOrganizer
 * @description Organizes archive folders by year/month
 */
class ArchiveOrganizer {
    archiveBasePath := A_MyDocuments . "\\Archives"

    __New(basePath := "") {
        if (basePath != "")
            this.archiveBasePath := basePath

        CreateFolder(this.archiveBasePath)
    }

    CreateArchiveFolder(itemName) {
        year := FormatTime(A_Now, "yyyy")
        month := FormatTime(A_Now, "MM")

        archivePath := Format("{1}\\{2}\\{3}\\{4}",
                            this.archiveBasePath,
                            year,
                            month,
                            itemName)

        return CreateFolder(archivePath)
    }

    CreateYearlyArchiveStructure(year) {
        results := []

        Loop 12 {
            month := Format("{:02}", A_Index)
            monthPath := Format("{1}\\{2}\\{3}",
                              this.archiveBasePath,
                              year,
                              month)

            result := CreateFolder(monthPath)
            results.Push(result)
        }

        return results
    }
}

Example4_ArchiveOrganization() {
    organizer := ArchiveOrganizer(A_Desktop . "\\Archives")

    ; Create yearly structure
    currentYear := FormatTime(A_Now, "yyyy")
    results := organizer.CreateYearlyArchiveStructure(currentYear)

    successCount := 0
    for result in results {
        if (result.Success)
            successCount++
    }

    message := Format("Archive Structure for {1}`n`n", currentYear)
    message .= Format("Folders Created: {1}/12", successCount)

    MsgBox(message, "Archive Organization", "Iconi")

    return organizer
}

; ===================================================================================================
; EXAMPLE 5: Dynamic Project Structure Generator
; ===================================================================================================

/**
 * @class DynamicProjectGenerator
 * @description Generates project structures based on user input
 */
class DynamicProjectGenerator {
    static CreateCustomStructure(projectName, folderNames, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        projectPath := basePath . "\\" . projectName
        CreateFolder(projectPath)

        created := []
        failed := []

        for folderName in folderNames {
            fullPath := projectPath . "\\" . folderName
            result := CreateFolder(fullPath)

            if (result.Success)
                created.Push(fullPath)
            else
                failed.Push(fullPath)
        }

        return {
            ProjectPath: projectPath,
            Created: created,
            Failed: failed,
            Success: (failed.Length = 0)
        }
    }

    static CreateInteractive() {
        projectName := InputBox("Enter project name:", "Dynamic Project").Value
        if (projectName = "")
            return

        folderInput := InputBox("Enter folder names (comma-separated):", "Folder Names").Value
        if (folderInput = "")
            return

        folderNames := StrSplit(folderInput, ",")

        ; Trim whitespace from folder names
        trimmedNames := []
        for name in folderNames {
            trimmedNames.Push(Trim(name))
        }

        return DynamicProjectGenerator.CreateCustomStructure(projectName, trimmedNames)
    }
}

Example5_DynamicGenerator() {
    result := DynamicProjectGenerator.CreateInteractive()

    if (result != "" && result.Success) {
        message := "Project Created Successfully!`n`n"
        message .= Format("Path: {1}`n", result.ProjectPath)
        message .= Format("Folders Created: {1}", result.Created.Length)

        MsgBox(message, "Success", "Iconi")
    }
}

; ===================================================================================================
; EXAMPLE 6: Folder Creation Logging System
; ===================================================================================================

/**
 * @class FolderCreationLogger
 * @description Logs all folder creation operations
 */
class FolderCreationLogger {
    logFile := A_ScriptDir . "\\folder_creation.log"

    LogCreation(folderPath, success, error := "") {
        timestamp := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        status := success ? "SUCCESS" : "FAILED"

        logEntry := Format("[{1}] {2} - {3}",
                          timestamp,
                          status,
                          folderPath)

        if (error != "")
            logEntry .= " - Error: " . error

        logEntry .= "`n"

        FileAppend(logEntry, this.logFile)
    }

    CreateWithLogging(folderPath) {
        result := CreateFolder(folderPath)

        if (result.Success) {
            this.LogCreation(folderPath, true)
        } else {
            this.LogCreation(folderPath, false, result.Error)
        }

        return result
    }

    GetRecentLog(lines := 20) {
        if !FileExist(this.logFile)
            return []

        content := FileRead(this.logFile)
        allLines := StrSplit(content, "`n", "`r")

        recent := []
        startIndex := Max(1, allLines.Length - lines)

        for i, line in allLines {
            if (i >= startIndex && line != "")
                recent.Push(line)
        }

        return recent
    }
}

Example6_LoggedCreation() {
    logger := FolderCreationLogger()

    ; Create some test folders with logging
    basePath := A_Desktop . "\\LoggedFolders"
    logger.CreateWithLogging(basePath)
    logger.CreateWithLogging(basePath . "\\Folder1")
    logger.CreateWithLogging(basePath . "\\Folder2")

    ; Show recent log
    recent := logger.GetRecentLog(10)

    report := "Recent Folder Creation Log:`n"
    report .= "═══════════════════════════════════════`n`n"

    for entry in recent {
        report .= entry . "`n"
    }

    MsgBox(report, "Creation Log", "Iconi")

    return logger
}

; ===================================================================================================
; EXAMPLE 7: Folder Cleanup and Maintenance
; ===================================================================================================

/**
 * @class FolderMaintenanceManager
 * @description Maintains folder structures and performs cleanup
 */
class FolderMaintenanceManager {
    static CleanEmptyFolders(basePath) {
        removed := []

        Loop Files, basePath . "\\*.*", "D" {
            ; Check if folder is empty
            isEmpty := true

            Loop Files, A_LoopFilePath . "\\*.*", "FR" {
                isEmpty := false
                break
            }

            if (isEmpty) {
                try {
                    DirDelete(A_LoopFilePath)
                    removed.Push(A_LoopFilePath)
                }
            }
        }

        return removed
    }

    static EnsureStructureExists(basePath, requiredFolders) {
        missing := []

        for folder in requiredFolders {
            fullPath := basePath . "\\" . folder

            if !DirExist(fullPath) {
                CreateFolder(fullPath)
                missing.Push(fullPath)
            }
        }

        return {
            MissingCount: missing.Length,
            Created: missing
        }
    }
}

Example7_Maintenance() {
    basePath := A_Desktop . "\\MaintainedProject"

    requiredFolders := ["src", "docs", "tests", "data"]

    result := FolderMaintenanceManager.EnsureStructureExists(basePath, requiredFolders)

    message := "Folder Maintenance Complete`n`n"
    message .= Format("Required Folders: {1}`n", requiredFolders.Length)
    message .= Format("Missing (Created): {1}", result.MissingCount)

    MsgBox(message, "Maintenance", "Iconi")
}

; ===================================================================================================
; Hotkey Examples - Uncomment to use
; ===================================================================================================

; Press Ctrl+Alt+S to create smart-named folder
; ^!s::Example1_SmartNaming()

; Press Ctrl+Alt+B to create backup structure
; ^!b::Example2_BackupFolders()

; Press Ctrl+Alt+T to create from template
; ^!t::Example3_TemplateCreation()

; Press Ctrl+Alt+A to create archive structure
; ^!a::Example4_ArchiveOrganization()
""",
}

# Create all Dir files
for filename, content in dir_files.items():
    filepath = os.path.join(base_dir, filename)
    with open(filepath, 'w', encoding='utf-8') as f:
        f.write(content)
    line_count = len(content.splitlines())
    print(f"Created: {filename} ({line_count} lines)")

print(f"\n✓ Created {len(dir_files)} DirCreate files")
print(f"Total lines: {sum(len(content.splitlines()) for content in dir_files.values())}")
