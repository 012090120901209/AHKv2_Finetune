#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * DirSelect Advanced Applications - Part 2
 * ============================================================================
 * 
 * Advanced DirSelect applications and patterns in AutoHotkey v2.
 * 
 * @description This file covers advanced DirSelect usage including:
 *              - Folder browsing utilities
 *              - Multi-folder operations
 *              - Folder comparison and synchronization
 *              - Smart folder selection
 *              - Folder organization tools
 *              - Directory management workflows
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/DirSelect.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Folder Browsing Utilities
; ============================================================================
/**
 * Creates advanced folder browsing tools.
 * 
 * @description Shows utility functions for folder browsing.
 */
Example1_FolderBrowsingUtilities() {
    ; Quick folder opener
    QuickFolderOpen()

    ; Recent folders menu
    RecentFoldersMenu()

    ; Favorite folders
    FavoriteFolders()

    ; Folder history
    FolderHistory()
}

/**
 * Quick folder opener with presets.
 */
QuickFolderOpen() {
    presets := Map(
        "Desktop", A_Desktop,
        "Documents", A_MyDocuments,
        "Downloads", A_MyDocuments . "\..\Downloads",
        "Pictures", A_MyDocuments . "\Pictures",
        "Projects", "C:\Projects",
        "Temp", A_Temp
    )

    choice := MsgBox("Quick Open:`n`n"
        . "Yes - Desktop`n"
        . "No - Documents`n"
        . "Cancel - Custom",
        "Quick Folder Open",
        "YesNoCancel")

    Switch choice {
        Case "Yes":
            startDir := presets["Desktop"]
        Case "No":
            startDir := presets["Documents"]
        Case "Cancel":
            startDir := ""
    }

    folder := DirSelect(startDir, , "Quick Folder Open")

    if (folder != "") {
        MsgBox "Opened folder:`n`n" . folder
    }
}

/**
 * Recent folders functionality (simulated).
 */
RecentFoldersMenu() {
    ; Simulated recent folders
    recentFolders := [
        A_Desktop,
        A_MyDocuments,
        A_Temp,
        A_ScriptDir
    ]

    MsgBox "Recent Folders:`n`n"
        . "1. " . recentFolders[1] . "`n"
        . "2. " . recentFolders[2] . "`n"
        . "3. " . recentFolders[3] . "`n"
        . "4. " . recentFolders[4]

    folder := DirSelect(recentFolders[1], , "Select from recent or browse")

    if (folder != "") {
        MsgBox "Selected: " . folder
        ; Add to recent folders list
    }
}

/**
 * Favorite folders system.
 */
FavoriteFolders() {
    ; Simulated favorites
    favorites := Map(
        "Work", A_MyDocuments . "\Work",
        "Personal", A_MyDocuments . "\Personal",
        "Projects", "C:\Projects"
    )

    favoritesList := "Favorite Folders:`n`n"
    for name, path in favorites {
        favoritesList .= "• " . name . ": " . path . "`n"
    }

    MsgBox favoritesList

    folder := DirSelect(favorites["Work"], , "Browse favorites")

    if (folder != "") {
        MsgBox "Selected: " . folder
    }
}

/**
 * Folder history with navigation.
 */
FolderHistory() {
    static history := []

    folder := DirSelect("", , "Select folder (saves to history)")

    if (folder != "") {
        ; Add to history
        if (!HasValue(history, folder))
            history.Push(folder)

        ; Show history
        historyText := "Folder History:`n`n"
        for index, path in history {
            historyText .= index . ". " . path . "`n"
        }

        MsgBox historyText
    }
}

/**
 * Check if array contains value.
 */
HasValue(arr, value) {
    for item in arr {
        if (item = value)
            return true
    }
    return false
}

; ============================================================================
; EXAMPLE 2: Multi-Folder Operations
; ============================================================================
/**
 * Demonstrates operations involving multiple folders.
 * 
 * @description Shows multi-folder workflows.
 */
Example2_MultiFolderOperations() {
    ; Folder comparison
    CompareFolders()

    ; Folder synchronization setup
    SetupFolderSync()

    ; Multi-folder backup
    MultiFolder_Backup()

    ; Folder merging
    MergeFolders()
}

/**
 * Compares two folders.
 */
CompareFolders() {
    folder1 := DirSelect("", , "Select first folder to compare")
    if (folder1 = "")
        return

    folder2 := DirSelect("", , "Select second folder to compare")
    if (folder2 = "")
        return

    ; Count files in each
    count1 := 0
    Loop Files folder1 . "\*.*" {
        count1++
    }

    count2 := 0
    Loop Files folder2 . "\*.*" {
        count2++
    }

    MsgBox Format("Folder Comparison:`n`n"
        . "Folder 1: {1}`nFiles: {2}`n`n"
        . "Folder 2: {3}`nFiles: {4}`n`n"
        . "Difference: {5} files",
        folder1, count1,
        folder2, count2,
        Abs(count1 - count2))
}

/**
 * Sets up folder synchronization.
 */
SetupFolderSync() {
    sourceFolder := DirSelect("", , "Select source folder")
    if (sourceFolder = "")
        return

    targetFolder := DirSelect("", , "Select target folder")
    if (targetFolder = "")
        return

    MsgBox Format("Folder Sync Setup:`n`n"
        . "Source: {1}`n"
        . "Target: {2}`n`n"
        . "Sync mode: One-way (source → target)",
        sourceFolder,
        targetFolder),
        "Sync Configuration",
        "Iconi"
}

/**
 * Multiple folder backup.
 */
MultiFolder_Backup() {
    folders := []

    ; Collect folders to backup
    Loop 3 {
        folder := DirSelect("", , Format("Select folder #{1} to backup (or cancel to finish)", A_Index))

        if (folder = "")
            break

        folders.Push(folder)
    }

    if (folders.Length = 0) {
        MsgBox "No folders selected for backup."
        return
    }

    ; Select backup destination
    backupDest := DirSelect("", , "Select backup destination")

    if (backupDest != "") {
        folderList := ""
        for folder in folders {
            folderList .= "• " . folder . "`n"
        }

        MsgBox Format("Backup {1} folders to:`n{2}`n`nFolders:`n{3}",
            folders.Length,
            backupDest,
            folderList),
            "Backup Plan",
            "Iconi"
    }
}

/**
 * Merges folders.
 */
MergeFolders() {
    sourceFolder := DirSelect("", , "Select source folder (will be merged)")
    if (sourceFolder = "")
        return

    targetFolder := DirSelect("", , "Select target folder (merge destination)")
    if (targetFolder = "")
        return

    confirm := MsgBox(Format("Merge contents of:`n{1}`n`nInto:`n{2}`n`nContinue?",
        sourceFolder,
        targetFolder),
        "Confirm Merge",
        "YesNo Icon!")

    if (confirm = "Yes") {
        MsgBox "Folders would be merged (demo mode)",
            "Merge",
            "Iconi"
    }
}

; ============================================================================
; EXAMPLE 3: Smart Folder Selection
; ============================================================================
/**
 * Implements intelligent folder selection.
 * 
 * @description Shows context-aware folder selection.
 */
Example3_SmartFolderSelection() {
    ; Auto-detect project root
    SelectProjectRoot()

    ; Smart export folder
    SmartExportFolder()

    ; Workspace selector
    WorkspaceSelector()

    ; Auto-organize folder
    AutoOrganizeFolder()
}

/**
 * Selects project root intelligently.
 */
SelectProjectRoot() {
    ; Start from script directory and look for project indicators
    currentDir := A_ScriptDir
    projectRoot := currentDir

    ; Look for .git, package.json, etc.
    Loop {
        if (DirExist(projectRoot . "\.git")
            || FileExist(projectRoot . "\package.json")
            || FileExist(projectRoot . "\*.sln")) {
            MsgBox "Project root detected at:`n`n" . projectRoot
            break
        }

        ; Move up one directory
        SplitPath projectRoot, , &parentDir

        if (parentDir = projectRoot)  ; At root
            break

        projectRoot := parentDir
    }

    folder := DirSelect(projectRoot, , "Confirm project root")

    if (folder != "") {
        MsgBox "Project root: " . folder
    }
}

/**
 * Smart export folder based on date.
 */
SmartExportFolder() {
    baseExportDir := A_MyDocuments . "\Exports"

    ; Create date-based subfolder
    dateFolder := baseExportDir . "\" . FormatTime(, "yyyy-MM")

    if (!DirExist(baseExportDir)) {
        try DirCreate baseExportDir
    }

    if (!DirExist(dateFolder)) {
        try DirCreate dateFolder
    }

    folder := DirSelect(dateFolder, , "Select export folder (auto-organized by date)")

    if (folder != "") {
        MsgBox "Export to: " . folder
    }
}

/**
 * Workspace selector with categories.
 */
WorkspaceSelector() {
    category := MsgBox("Select workspace category:`n`n"
        . "Yes - Development`n"
        . "No - Documents",
        "Workspace",
        "YesNo")

    if (category = "Yes") {
        baseDir := "C:\Development"
        title := "Select Development Workspace"
    } else {
        baseDir := A_MyDocuments
        title := "Select Documents Workspace"
    }

    if (!DirExist(baseDir))
        baseDir := A_MyDocuments

    folder := DirSelect(baseDir, , title)

    if (folder != "") {
        MsgBox "Workspace selected: " . folder
    }
}

/**
 * Auto-organize folder with smart categorization.
 */
AutoOrganizeFolder() {
    folder := DirSelect("", , "Select folder to auto-organize")

    if (folder = "") {
        return
    }

    ; Create category subfolders
    categories := [
        "Documents",
        "Images",
        "Videos",
        "Audio",
        "Archives",
        "Other"
    ]

    for category in categories {
        categoryPath := folder . "\" . category
        if (!DirExist(categoryPath)) {
            try DirCreate categoryPath
        }
    }

    MsgBox Format("Created organization structure in:`n{1}`n`n"
        . "Categories: {2}",
        folder,
        categories.Length),
        "Auto-Organize",
        "Iconi"
}

; ============================================================================
; EXAMPLE 4: Folder Organization Tools
; ============================================================================
/**
 * Creates folder organization utilities.
 * 
 * @description Shows organizational tools.
 */
Example4_FolderOrganization() {
    ; Create dated folder structure
    CreateDatedStructure()

    ; Project template creator
    CreateProjectTemplate()

    ; Cleanup empty folders
    CleanupEmptyFolders()

    ; Flatten folder structure
    FlattenFolderStructure()
}

/**
 * Creates dated folder structure.
 */
CreateDatedStructure() {
    baseFolder := DirSelect("", , "Select base folder for dated structure")

    if (baseFolder = "")
        return

    ; Create year/month/day structure
    year := FormatTime(, "yyyy")
    month := FormatTime(, "MM")
    day := FormatTime(, "dd")

    yearFolder := baseFolder . "\" . year
    monthFolder := yearFolder . "\" . month
    dayFolder := monthFolder . "\" . day

    created := []

    for folderPath in [yearFolder, monthFolder, dayFolder] {
        if (!DirExist(folderPath)) {
            try {
                DirCreate folderPath
                created.Push(folderPath)
            }
        }
    }

    if (created.Length > 0) {
        MsgBox Format("Created {1} dated folders:`n`n{2}",
            created.Length,
            dayFolder),
            "Dated Structure",
            "Iconi"
    }
}

/**
 * Creates project template.
 */
CreateProjectTemplate() {
    rootFolder := DirSelect("", 1, "Select or create project root folder")

    if (rootFolder = "")
        return

    projectName := InputBox("Enter project name:", "Project Name").Value

    if (projectName = "")
        return

    projectRoot := rootFolder . "\" . projectName

    template := [
        "\src",
        "\src\assets",
        "\src\components",
        "\src\utils",
        "\docs",
        "\tests",
        "\build",
        "\dist"
    ]

    createdCount := 0

    for subFolder in template {
        fullPath := projectRoot . subFolder
        try {
            if (!DirExist(fullPath)) {
                DirCreate fullPath
                createdCount++
            }
        }
    }

    MsgBox Format("Project template created!`n`n"
        . "Project: {1}`n"
        . "Folders created: {2}",
        projectName,
        createdCount),
        "Template Created",
        "Iconi"
}

/**
 * Cleans up empty folders.
 */
CleanupEmptyFolders() {
    folder := DirSelect("", , "Select folder to clean up empty subfolders")

    if (folder = "")
        return

    emptyFolders := []

    ; Find empty folders
    Loop Files folder . "\*.*", "D" {
        isEmpty := true
        Loop Files A_LoopFilePath . "\*.*", "FD" {
            isEmpty := false
            break
        }

        if (isEmpty)
            emptyFolders.Push(A_LoopFilePath)
    }

    if (emptyFolders.Length > 0) {
        folderList := ""
        for emptyFolder in emptyFolders {
            SplitPath emptyFolder, &name
            folderList .= "• " . name . "`n"
        }

        confirm := MsgBox(Format("Found {1} empty folder(s):`n`n{2}`nDelete them?",
            emptyFolders.Length,
            folderList),
            "Empty Folders",
            "YesNo Icon?")

        if (confirm = "Yes") {
            MsgBox "Empty folders would be deleted (demo mode)",
                "Cleanup",
                "Iconi"
        }
    } else {
        MsgBox "No empty folders found.",
            "Cleanup",
            "Iconi"
    }
}

/**
 * Flattens nested folder structure.
 */
FlattenFolderStructure() {
    sourceFolder := DirSelect("", , "Select folder to flatten")

    if (sourceFolder = "")
        return

    targetFolder := DirSelect("", , "Select destination for flattened files")

    if (targetFolder = "") {
        return
    }

    ; Count files in nested structure
    fileCount := 0
    Loop Files sourceFolder . "\*.*", "FR" {
        fileCount++
    }

    confirm := MsgBox(Format("Flatten {1} files from:`n{2}`n`nTo:`n{3}`n`nContinue?",
        fileCount,
        sourceFolder,
        targetFolder),
        "Flatten Structure",
        "YesNo Icon?")

    if (confirm = "Yes") {
        MsgBox "Files would be flattened (demo mode)",
            "Flatten",
            "Iconi"
    }
}

; ============================================================================
; EXAMPLE 5: Directory Management Workflows
; ============================================================================
/**
 * Complete directory management workflows.
 * 
 * @description Shows end-to-end directory workflows.
 */
Example5_DirectoryWorkflows() {
    ; Archive old folders
    ArchiveOldFolders()

    ; Migrate folders
    MigrateFolders()

    ; Clone folder structure
    CloneFolderStructure()

    ; Snapshot folder state
    SnapshotFolderState()
}

/**
 * Archives old folders.
 */
ArchiveOldFolders() {
    sourceFolder := DirSelect("", , "Select folder to archive")

    if (sourceFolder = "")
        return

    archiveRoot := DirSelect("", , "Select archive destination")

    if (archiveRoot = "")
        return

    ; Create archive subfolder with timestamp
    timestamp := FormatTime(, "yyyyMMdd_HHmmss")
    SplitPath sourceFolder, &folderName

    archivePath := archiveRoot . "\Archive_" . folderName . "_" . timestamp

    confirm := MsgBox(Format("Archive folder:`n{1}`n`nTo:`n{2}`n`nProceed?",
        sourceFolder,
        archivePath),
        "Archive",
        "YesNo Icon?")

    if (confirm = "Yes") {
        MsgBox "Folder would be archived (demo mode)",
            "Archive",
            "Iconi"
    }
}

/**
 * Migrates folders to new location.
 */
MigrateFolders() {
    oldLocation := DirSelect("", , "Select old location")

    if (oldLocation = "")
        return

    newLocation := DirSelect("", 1, "Select or create new location")

    if (newLocation = "")
        return

    MsgBox Format("Migration Plan:`n`n"
        . "From: {1}`n"
        . "To: {2}`n`n"
        . "This will move all contents.",
        oldLocation,
        newLocation),
        "Migration",
        "Iconi"
}

/**
 * Clones folder structure (folders only, no files).
 */
CloneFolderStructure() {
    sourceFolder := DirSelect("", , "Select folder structure to clone")

    if (sourceFolder = "")
        return

    targetFolder := DirSelect("", 1, "Select destination for cloned structure")

    if (targetFolder = "")
        return

    ; Count subfolders
    folderCount := 0
    Loop Files sourceFolder . "\*.*", "DR" {
        folderCount++
    }

    MsgBox Format("Clone structure from:`n{1}`n`nTo:`n{2}`n`n"
        . "Subfolders to create: {3}",
        sourceFolder,
        targetFolder,
        folderCount),
        "Clone Structure",
        "Iconi"
}

/**
 * Creates snapshot of folder state.
 */
SnapshotFolderState() {
    folder := DirSelect("", , "Select folder to snapshot")

    if (folder = "")
        return

    ; Collect folder statistics
    fileCount := 0
    totalSize := 0

    Loop Files folder . "\*.*", "R" {
        fileCount++
        totalSize += FileGetSize(A_LoopFilePath)
    }

    snapshot := Format("═══ Folder Snapshot ═══`n`n"
        . "Path: {1}`n"
        . "Date: {2}`n"
        . "Files: {3}`n"
        . "Total Size: {4} MB",
        folder,
        FormatTime(, "yyyy-MM-dd HH:mm:ss"),
        fileCount,
        Round(totalSize / 1048576, 2))

    MsgBox snapshot, "Snapshot Created", "Iconi"

    ; Save snapshot option
    save := MsgBox("Save snapshot to file?", "Save", "YesNo")

    if (save = "Yes") {
        savePath := FileSelect("S",
            A_MyDocuments . "\folder_snapshot.txt",
            "Save snapshot",
            "Text Files (*.txt)")

        if (savePath != "") {
            MsgBox "Snapshot would be saved to:`n" . savePath,
                "Save Snapshot",
                "Iconi"
            ; FileAppend snapshot, savePath
        }
    }
}

; ============================================================================
; EXAMPLE 6: Advanced Folder Utilities
; ============================================================================
/**
 * Advanced folder management utilities.
 * 
 * @description Shows specialized folder tools.
 */
Example6_AdvancedUtilities() {
    ; Folder size calculator
    CalculateFolderSize()

    ; Duplicate folder finder
    FindDuplicateFolders()

    ; Folder permissions check
    CheckFolderPermissions()

    ; Folder age analyzer
    AnalyzeFolderAge()
}

/**
 * Calculates total folder size.
 */
CalculateFolderSize() {
    folder := DirSelect("", , "Select folder to analyze size")

    if (folder = "")
        return

    totalSize := 0
    fileCount := 0

    Loop Files folder . "\*.*", "R" {
        totalSize += FileGetSize(A_LoopFilePath)
        fileCount++
    }

    sizeMB := Round(totalSize / 1048576, 2)
    sizeGB := Round(totalSize / 1073741824, 2)

    MsgBox Format("Folder Size Analysis:`n`n"
        . "Path: {1}`n`n"
        . "Files: {2}`n"
        . "Total Size: {3} MB ({4} GB)",
        folder,
        fileCount,
        sizeMB,
        sizeGB),
        "Folder Size",
        "Iconi"
}

/**
 * Finds potentially duplicate folders.
 */
FindDuplicateFolders() {
    folder := DirSelect("", , "Select folder to scan for duplicates")

    if (folder = "")
        return

    folders := Map()

    ; Scan subfolders
    Loop Files folder . "\*.*", "D" {
        folderName := A_LoopFileName
        if (folders.Has(folderName)) {
            folders[folderName]++
        } else {
            folders[folderName] := 1
        }
    }

    duplicates := ""
    dupCount := 0

    for name, count in folders {
        if (count > 1) {
            duplicates .= "• " . name . " (" . count . " instances)`n"
            dupCount++
        }
    }

    if (dupCount > 0) {
        MsgBox Format("Found {1} duplicate folder name(s):`n`n{2}",
            dupCount,
            duplicates),
            "Duplicates Found",
            "Icon!"
    } else {
        MsgBox "No duplicate folder names found.",
            "No Duplicates",
            "Iconi"
    }
}

/**
 * Checks folder permissions.
 */
CheckFolderPermissions() {
    folder := DirSelect("", , "Select folder to check permissions")

    if (folder = "")
        return

    canRead := DirExist(folder) ? true : false
    canWrite := false

    ; Test write permission
    testFile := folder . "\~test_write.tmp"
    try {
        FileAppend "", testFile
        FileDelete testFile
        canWrite := true
    }

    permissions := Format("Folder Permissions:`n`n"
        . "Path: {1}`n`n"
        . "Read: {2}`n"
        . "Write: {3}",
        folder,
        canRead ? "✓ Yes" : "❌ No",
        canWrite ? "✓ Yes" : "❌ No")

    MsgBox permissions, "Permissions Check", "Iconi"
}

/**
 * Analyzes folder age.
 */
AnalyzeFolderAge() {
    folder := DirSelect("", , "Select folder to analyze age")

    if (folder = "")
        return

    newest := 0
    oldest := 99999999999999
    fileCount := 0

    Loop Files folder . "\*.*", "R" {
        fileTime := FileGetTime(A_LoopFilePath, "M")

        if (fileTime > newest)
            newest := fileTime

        if (fileTime < oldest)
            oldest := fileTime

        fileCount++
    }

    if (fileCount > 0) {
        newestDate := FormatTime(newest, "yyyy-MM-dd HH:mm")
        oldestDate := FormatTime(oldest, "yyyy-MM-dd HH:mm")

        MsgBox Format("Folder Age Analysis:`n`n"
            . "Files: {1}`n`n"
            . "Oldest file: {2}`n"
            . "Newest file: {3}",
            fileCount,
            oldestDate,
            newestDate),
            "Folder Age",
            "Iconi"
    }
}

; ============================================================================
; EXAMPLE 7: Folder Browser Integration
; ============================================================================
/**
 * Integrates folder selection with system browser.
 * 
 * @description Shows browser integration patterns.
 */
Example7_BrowserIntegration() {
    ; Select and open in Explorer
    SelectAndOpen()

    ; Select and copy path
    SelectAndCopyPath()

    ; Select and create shortcut
    SelectAndCreateShortcut()

    ; Select and show properties
    SelectAndShowProperties()
}

/**
 * Selects folder and opens in Explorer.
 */
SelectAndOpen() {
    folder := DirSelect("", , "Select folder to open in Explorer")

    if (folder != "") {
        MsgBox "Would open in Explorer:`n`n" . folder,
            "Open Folder",
            "Iconi"
        ; Run 'explorer.exe "' . folder . '"'
    }
}

/**
 * Selects folder and copies path to clipboard.
 */
SelectAndCopyPath() {
    folder := DirSelect("", , "Select folder to copy path")

    if (folder != "") {
        A_Clipboard := folder
        MsgBox "Path copied to clipboard:`n`n" . folder,
            "Path Copied",
            "Iconi"
    }
}

/**
 * Selects folder and creates desktop shortcut.
 */
SelectAndCreateShortcut() {
    folder := DirSelect("", , "Select folder for shortcut")

    if (folder != "") {
        SplitPath folder, &folderName

        shortcutPath := A_Desktop . "\" . folderName . ".lnk"

        MsgBox Format("Shortcut would be created:`n`n"
            . "Target: {1}`n"
            . "Shortcut: {2}",
            folder,
            shortcutPath),
            "Create Shortcut",
            "Iconi"
        ; FileCreateShortcut folder, shortcutPath
    }
}

/**
 * Selects folder and shows simulated properties.
 */
SelectAndShowProperties() {
    folder := DirSelect("", , "Select folder to view properties")

    if (folder != "") {
        fileCount := 0
        folderCount := 0

        Loop Files folder . "\*.*", "F" {
            fileCount++
        }

        Loop Files folder . "\*.*", "D" {
            folderCount++
        }

        MsgBox Format("Folder Properties:`n`n"
            . "Location: {1}`n`n"
            . "Contains:`n"
            . "  Files: {2}`n"
            . "  Folders: {3}",
            folder,
            fileCount,
            folderCount),
            "Properties",
            "Iconi"
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_FolderBrowsingUtilities()
^2:: Example2_MultiFolderOperations()
^3:: Example3_SmartFolderSelection()
^4:: Example4_FolderOrganization()
^5:: Example5_DirectoryWorkflows()
^6:: Example6_AdvancedUtilities()
^7:: Example7_BrowserIntegration()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * Advanced DirSelect applications:
 * 1. Folder browsing utilities (quick open, favorites, history)
 * 2. Multi-folder operations (compare, sync, backup, merge)
 * 3. Smart folder selection (auto-detect, context-aware)
 * 4. Folder organization tools (templates, cleanup, flatten)
 * 5. Directory management workflows (archive, migrate, clone)
 * 6. Advanced utilities (size calc, duplicates, permissions, age)
 * 7. Browser integration (open, copy path, shortcuts, properties)
 * 
 * Best Practices:
 * - Validate folder existence before operations
 * - Provide clear confirmation for destructive actions
 * - Use smart defaults based on context
 * - Remember user preferences and history
 * - Handle errors gracefully with meaningful messages
 * - Offer preview before executing bulk operations
 * - Create backup copies for safety
 * - Integrate with system features when appropriate
 * 
 * ============================================================================
 */

