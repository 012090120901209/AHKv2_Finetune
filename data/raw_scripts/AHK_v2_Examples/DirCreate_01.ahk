/**
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
    testPath := A_Desktop . "\TestFolder_" . FormatTime(A_Now, "yyyyMMddHHmmss")

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
        fullPath := basePath . "\" . folderName

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
    basePath := A_Desktop . "\ProjectStructure_" . FormatTime(A_Now, "yyyyMMddHHmmss")

    ; Create base folder first
    CreateFolder(basePath)

    ; Define nested structure
    structure := [
        "src",
        "src\components",
        "src\utils",
        "src\assets",
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
    basePath := A_Desktop . "\BatchFolders_" . FormatTime(A_Now, "yyyyMMddHHmmss")
    CreateFolder(basePath)

    folders := [
        basePath . "\Folder1",
        basePath . "\Folder2",
        basePath . "\Folder3",
        basePath . "\Folder4",
        basePath . "\Folder5"
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
        "src\js",
        "src\css",
        "src\images",
        "src\components",
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
            basePath := A_MyDocuments . "\Projects"

        projectPath := basePath . "\" . projectName

        ; Create base project folder
        CreateFolder(projectPath)

        ; Create template structure
        return CreateNestedFolders(projectPath, ProjectTemplateGenerator.WebProjectTemplate)
    }

    static CreatePythonProject(projectName, basePath := "") {
        if (basePath = "")
            basePath := A_MyDocuments . "\Projects"

        projectPath := basePath . "\" . projectName
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

        folderPath := basePath . "\" . year . "\" . month . "\" . day

        return CreateFolder(folderPath)
    }

    static CreateMonthlyStructure(basePath, year) {
        results := []

        ; Create year folder
        yearPath := basePath . "\" . year
        CreateFolder(yearPath)

        ; Create month folders
        Loop 12 {
            month := Format("{:02}", A_Index)
            monthPath := yearPath . "\" . month
            result := CreateFolder(monthPath)
            results.Push(result)
        }

        return results
    }
}

Example6_DateBased() {
    basePath := A_Desktop . "\DateOrganized"

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
    basePath := A_Desktop . "\ConditionalTest"

    folders := [
        basePath,
        basePath . "\Logs",
        basePath . "\Data",
        basePath . "\Temp",
        basePath . "\Output"
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
