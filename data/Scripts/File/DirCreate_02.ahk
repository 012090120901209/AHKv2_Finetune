/**
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
        folderPath := basePath . "\" . baseName

        while DirExist(folderPath) {
            folderPath := Format("{1}\{2}_{3}", basePath, baseName, counter)
            counter++
        }

        return folderPath
    }

    static GenerateTimestampedName(prefix, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        timestamp := FormatTime(A_Now, "yyyyMMdd_HHmmss")
        return basePath . "\" . prefix . "_" . timestamp
    }

    static GenerateDateName(prefix, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        date := FormatTime(A_Now, "yyyy-MM-dd")
        return basePath . "\" . prefix . "_" . date
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
    backupBasePath := A_MyDocuments . "\Backups"

    __New(basePath := "") {
        if (basePath != "")
            this.backupBasePath := basePath

        CreateFolder(this.backupBasePath)
    }

    CreateDailyBackupFolder() {
        date := FormatTime(A_Now, "yyyy-MM-dd")
        folderPath := this.backupBasePath . "\" . date

        return CreateFolder(folderPath)
    }

    CreateWeeklyBackupFolder() {
        year := FormatTime(A_Now, "yyyy")
        week := FormatTime(A_Now, "YWeek")

        folderPath := this.backupBasePath . "\Weekly\" . year . "\" . week

        return CreateFolder(folderPath)
    }

    CreateMonthlyBackupFolder() {
        yearMonth := FormatTime(A_Now, "yyyy-MM")
        folderPath := this.backupBasePath . "\Monthly\" . yearMonth

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
    manager := BackupFolderManager(A_Desktop . "\BackupSystem")
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
            "src\components",
            "src\styles",
            "src\scripts",
            "src\assets",
            "src\assets\images",
            "src\assets\fonts",
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
            "assets\sprites",
            "assets\sounds",
            "assets\music",
            "levels",
            "scripts",
            "docs"
        ]
    }

    CreateFromTemplate(templateName, projectName, basePath := "") {
        if (basePath = "")
            basePath := A_Desktop

        if !this.templates.Has(templateName) {
            return { Success: false, Error: "Template not found" }
        }

        projectPath := basePath . "\" . projectName
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
    archiveBasePath := A_MyDocuments . "\Archives"

    __New(basePath := "") {
        if (basePath != "")
            this.archiveBasePath := basePath

        CreateFolder(this.archiveBasePath)
    }

    CreateArchiveFolder(itemName) {
        year := FormatTime(A_Now, "yyyy")
        month := FormatTime(A_Now, "MM")

        archivePath := Format("{1}\{2}\{3}\{4}",
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
            monthPath := Format("{1}\{2}\{3}",
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
    organizer := ArchiveOrganizer(A_Desktop . "\Archives")

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

        projectPath := basePath . "\" . projectName
        CreateFolder(projectPath)

        created := []
        failed := []

        for folderName in folderNames {
            fullPath := projectPath . "\" . folderName
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
    logFile := A_ScriptDir . "\folder_creation.log"

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
    basePath := A_Desktop . "\LoggedFolders"
    logger.CreateWithLogging(basePath)
    logger.CreateWithLogging(basePath . "\Folder1")
    logger.CreateWithLogging(basePath . "\Folder2")

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

        Loop Files, basePath . "\*.*", "D" {
            ; Check if folder is empty
            isEmpty := true

            Loop Files, A_LoopFilePath . "\*.*", "FR" {
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
            fullPath := basePath . "\" . folder

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
    basePath := A_Desktop . "\MaintainedProject"

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

