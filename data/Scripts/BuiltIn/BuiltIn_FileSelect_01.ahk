#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * ============================================================================
 * FileSelect Basic Examples - Part 1
 * ============================================================================
 * 
 * Comprehensive examples demonstrating FileSelect usage in AutoHotkey v2.
 * 
 * @description This file covers fundamental FileSelect functionality including:
 *              - Basic file selection
 *              - File type filters
 *              - Multi-file selection
 *              - Save dialogs
 *              - Initial directories
 *              - Dialog options
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileSelect.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Basic File Selection
; ============================================================================
/**
 * Demonstrates basic file selection dialog.
 * 
 * @description Shows how to open file selection dialogs and
 *              handle selected files.
 */
Example1_BasicFileSelection() {
    ; Simple file open dialog
    selectedFile := FileSelect()

    if (selectedFile != "") {
        MsgBox "You selected:`n`n" . selectedFile
        ShowFileInfo(selectedFile)
    } else {
        MsgBox "No file was selected (dialog cancelled)."
    }

    ; File open with default directory
    selectedFile := FileSelect(, A_Desktop, "Select a file from Desktop")

    if (selectedFile != "") {
        MsgBox "Selected from Desktop:`n`n" . selectedFile
    }

    ; File open from Documents
    selectedFile := FileSelect(, A_MyDocuments, "Select a document")

    if (selectedFile != "") {
        MsgBox "Selected document:`n`n" . selectedFile
    }

    ; File open with custom prompt
    selectedFile := FileSelect(, , "Please choose an image file to process")

    if (selectedFile != "") {
        MsgBox "Image file selected:`n`n" . selectedFile
    }
}

/**
 * Shows file information.
 */
ShowFileInfo(filePath) {
    if (FileExist(filePath)) {
        SplitPath filePath, &fileName, &fileDir, &fileExt, &fileNameNoExt

        fileSize := FileGetSize(filePath)
        fileSizeKB := Round(fileSize / 1024, 2)

        MsgBox Format("═══ File Information ═══`n`n"
            . "Full Path: {1}`n`n"
            . "Directory: {2}`n"
            . "File Name: {3}`n"
            . "Extension: {4}`n"
            . "Name (no ext): {5}`n"
            . "Size: {6} bytes ({7} KB)",
            filePath,
            fileDir,
            fileName,
            fileExt,
            fileNameNoExt,
            fileSize,
            fileSizeKB)
    }
}

; ============================================================================
; EXAMPLE 2: File Type Filters
; ============================================================================
/**
 * Shows file selection with type filters.
 * 
 * @description Demonstrates filtering files by extension.
 * 
 * Filter Format: "Description (*.ext1;*.ext2)"
 */
Example2_FileTypeFilters() {
    ; Text files only
    selectedFile := FileSelect(, , "Select a text file", "Text Files (*.txt)")

    if (selectedFile != "") {
        MsgBox "Text file selected:`n`n" . selectedFile
    }

    ; Image files
    selectedFile := FileSelect(, ,
        "Select an image",
        "Images (*.png;*.jpg;*.jpeg;*.gif;*.bmp)")

    if (selectedFile != "") {
        MsgBox "Image file selected:`n`n" . selectedFile
    }

    ; Document files
    selectedFile := FileSelect(, ,
        "Select a document",
        "Documents (*.doc;*.docx;*.pdf;*.txt)")

    if (selectedFile != "") {
        MsgBox "Document selected:`n`n" . selectedFile
    }

    ; Excel files
    selectedFile := FileSelect(, ,
        "Select a spreadsheet",
        "Excel Files (*.xlsx;*.xls)")

    if (selectedFile != "") {
        MsgBox "Spreadsheet selected:`n`n" . selectedFile
    }

    ; Multiple filter options
    selectedFile := FileSelect(, ,
        "Select a media file",
        "Video Files (*.mp4;*.avi;*.mkv)|Audio Files (*.mp3;*.wav;*.flac)")

    if (selectedFile != "") {
        MsgBox "Media file selected:`n`n" . selectedFile
    }

    ; All files with specific types highlighted
    selectedFile := FileSelect(, ,
        "Select any file",
        "Common Files (*.txt;*.pdf;*.doc)|All Files (*.*)")

    if (selectedFile != "") {
        MsgBox "File selected:`n`n" . selectedFile
    }

    ; Script files
    selectedFile := FileSelect(, ,
        "Select a script",
        "Scripts (*.ahk;*.ahk2;*.py;*.js)")

    if (selectedFile != "") {
        MsgBox "Script selected:`n`n" . selectedFile
    }
}

; ============================================================================
; EXAMPLE 3: Multi-File Selection
; ============================================================================
/**
 * Demonstrates selecting multiple files.
 * 
 * @description Shows how to select and process multiple files.
 * 
 * Option M: Enable multi-select
 */
Example3_MultiFileSelection() {
    ; Select multiple files
    selectedFiles := FileSelect("M", , "Select one or more files")

    if (selectedFiles.Length > 0) {
        fileList := "Selected " . selectedFiles.Length . " file(s):`n`n"

        for index, file in selectedFiles {
            SplitPath file, &fileName
            fileList .= index . ". " . fileName . "`n"
        }

        MsgBox fileList
    } else {
        MsgBox "No files were selected."
    }

    ; Multi-select with filter
    selectedFiles := FileSelect("M", ,
        "Select multiple images",
        "Images (*.png;*.jpg;*.jpeg)")

    if (selectedFiles.Length > 0) {
        MsgBox Format("Selected {1} image(s)", selectedFiles.Length)
        ProcessMultipleFiles(selectedFiles)
    }

    ; Multi-select from specific folder
    selectedFiles := FileSelect("M", A_MyDocuments,
        "Select documents",
        "Documents (*.txt;*.pdf;*.doc;*.docx)")

    if (selectedFiles.Length > 0) {
        ; Calculate total size
        totalSize := 0
        for file in selectedFiles {
            totalSize += FileGetSize(file)
        }

        totalSizeMB := Round(totalSize / 1048576, 2)

        MsgBox Format("Selected {1} documents`n`nTotal size: {2} MB",
            selectedFiles.Length,
            totalSizeMB)
    }
}

/**
 * Processes multiple files.
 */
ProcessMultipleFiles(files) {
    MsgBox "Processing " . files.Length . " files..."

    for index, file in files {
        SplitPath file, &fileName, &fileDir, &fileExt

        ; Show progress
        if (Mod(index, 5) = 0) {  ; Every 5 files
            ToolTip Format("Processing: {1}/{2}`n{3}",
                index,
                files.Length,
                fileName)
        }
    }

    ToolTip
    MsgBox "Processing complete!"
}

; ============================================================================
; EXAMPLE 4: Save File Dialogs
; ============================================================================
/**
 * Shows save file dialog variations.
 * 
 * @description Demonstrates save dialogs for file creation.
 * 
 * Option S: Show save dialog (instead of open)
 */
Example4_SaveFileDialogs() {
    ; Simple save dialog
    savePath := FileSelect("S", , "Save your file")

    if (savePath != "") {
        MsgBox "File will be saved to:`n`n" . savePath
        ; FileAppend "content", savePath
    }

    ; Save with default filename
    savePath := FileSelect("S", A_Desktop . "\report.txt", "Save report")

    if (savePath != "") {
        MsgBox "Report will be saved as:`n`n" . savePath
    }

    ; Save with extension filter
    savePath := FileSelect("S", , "Save as text file", "Text Files (*.txt)")

    if (savePath != "") {
        ; Auto-add extension if missing
        if (!RegExMatch(savePath, "\.txt$"))
            savePath .= ".txt"

        MsgBox "Text file will be saved as:`n`n" . savePath
    }

    ; Save image
    savePath := FileSelect("S", ,
        "Save image",
        "PNG Image (*.png)|JPEG Image (*.jpg)")

    if (savePath != "") {
        MsgBox "Image will be saved as:`n`n" . savePath
    }

    ; Save with automatic extension
    SaveWithExtension("data.json", "JSON Files (*.json)")
    SaveWithExtension("config.ini", "Config Files (*.ini)")
    SaveWithExtension("output.csv", "CSV Files (*.csv)")
}

/**
 * Saves file with automatic extension handling.
 */
SaveWithExtension(defaultName, filter) {
    savePath := FileSelect("S", A_MyDocuments . "\" . defaultName,
        "Save file", filter)

    if (savePath != "") {
        ; Extract extension from filter
        RegExMatch(filter, "\*\.(\w+)", &match)
        if (match && !RegExMatch(savePath, "\." . match[1] . "$"))
            savePath .= "." . match[1]

        MsgBox "File will be saved as:`n`n" . savePath
    }
}

; ============================================================================
; EXAMPLE 5: Dialog Options
; ============================================================================
/**
 * Demonstrates various dialog options.
 * 
 * @description Shows different FileSelect option combinations.
 * 
 * Options:
 * - M: Multi-select
 * - S: Save dialog
 * - D: Select directory (folder)
 * - 1: File must exist
 * - 2: Path must exist
 * - 8: Prompt to create new file
 * - 16: Prompt to overwrite
 * - 32: Follow shortcuts
 */
Example5_DialogOptions() {
    ; File must exist (Option 1)
    selectedFile := FileSelect("1", , "Select an existing file")

    if (selectedFile != "") {
        if (FileExist(selectedFile))
            MsgBox "Existing file selected:`n`n" . selectedFile
    }

    ; Path must exist (Option 2)
    selectedFile := FileSelect("2", , "File from existing path")

    if (selectedFile != "") {
        SplitPath selectedFile, , &dir
        MsgBox Format("File: {1}`n`nDirectory exists: {2}",
            selectedFile,
            DirExist(dir) ? "Yes" : "No")
    }

    ; Prompt to create (Option 8)
    savePath := FileSelect("S8", , "Save file (prompt if new)")

    if (savePath != "") {
        if (FileExist(savePath))
            MsgBox "Overwriting existing file"
        else
            MsgBox "Creating new file"
    }

    ; Prompt to overwrite (Option 16)
    savePath := FileSelect("S16", , "Save file (confirm overwrite)")

    if (savePath != "") {
        MsgBox "File will be saved as:`n`n" . savePath
    }

    ; Combined options: Save with overwrite confirmation
    savePath := FileSelect("S16", ,
        "Save with protection",
        "All Files (*.*)")

    if (savePath != "") {
        MsgBox "Protected save to:`n`n" . savePath
    }

    ; Multi-select existing files only
    selectedFiles := FileSelect("M1", , "Select existing files")

    if (selectedFiles.Length > 0) {
        MsgBox Format("Selected {1} existing file(s)", selectedFiles.Length)
    }
}

; ============================================================================
; EXAMPLE 6: Initial Directory Customization
; ============================================================================
/**
 * Shows different initial directory options.
 * 
 * @description Demonstrates starting the dialog in specific folders.
 */
Example6_InitialDirectories() {
    ; Start in Desktop
    selectedFile := FileSelect(, A_Desktop, "Select from Desktop")
    if (selectedFile != "")
        MsgBox "Selected from Desktop"

    ; Start in Documents
    selectedFile := FileSelect(, A_MyDocuments, "Select from Documents")
    if (selectedFile != "")
        MsgBox "Selected from Documents"

    ; Start in user folder
    selectedFile := FileSelect(, A_UserProfile, "Select from User folder")
    if (selectedFile != "")
        MsgBox "Selected from User folder"

    ; Start in program directory
    selectedFile := FileSelect(, A_ScriptDir, "Select from Script folder")
    if (selectedFile != "")
        MsgBox "Selected from Script folder"

    ; Start in temp folder
    selectedFile := FileSelect(, A_Temp, "Select from Temp")
    if (selectedFile != "")
        MsgBox "Selected from Temp folder"

    ; Custom path
    customPath := "C:\Projects"
    if (DirExist(customPath)) {
        selectedFile := FileSelect(, customPath, "Select from Projects")
        if (selectedFile != "")
            MsgBox "Selected from custom path"
    }

    ; Remember last used directory
    selectedFile := SelectWithMemory()
}

/**
 * File select that remembers last directory.
 */
SelectWithMemory() {
    static lastDir := A_MyDocuments

    selectedFile := FileSelect(, lastDir, "Select file (remembers location)")

    if (selectedFile != "") {
        SplitPath selectedFile, , &newDir
        lastDir := newDir  ; Remember this directory
        MsgBox "Selected:`n`n" . selectedFile . "`n`nNext dialog will start here."
        return selectedFile
    }

    return ""
}

; ============================================================================
; EXAMPLE 7: Practical File Selection Scenarios
; ============================================================================
/**
 * Real-world file selection scenarios.
 * 
 * @description Practical examples for common use cases.
 */
Example7_PracticalScenarios() {
    ; Image batch processor
    BatchImageSelector()

    ; Document converter
    DocumentConverterSelector()

    ; Backup file selector
    BackupFileSelector()

    ; Import/Export selector
    ImportExportSelector()

    ; Project file opener
    ProjectFileSelector()
}

/**
 * Batch image selector.
 */
BatchImageSelector() {
    images := FileSelect("M", ,
        "Select images to process",
        "Images (*.png;*.jpg;*.jpeg;*.gif;*.bmp)")

    if (images.Length > 0) {
        MsgBox Format("Ready to process {1} images`n`n"
            . "Operations available:`n"
            . "- Resize`n"
            . "- Convert format`n"
            . "- Apply filters",
            images.Length)
    }
}

/**
 * Document converter selector.
 */
DocumentConverterSelector() {
    sourceFile := FileSelect(, ,
        "Select document to convert",
        "Documents (*.doc;*.docx;*.txt;*.rtf)")

    if (sourceFile = "")
        return

    SplitPath sourceFile, &fileName, &fileDir, &fileExt, &nameNoExt

    outputPath := FileSelect("S",
        fileDir . "\" . nameNoExt . ".pdf",
        "Save as PDF",
        "PDF Files (*.pdf)")

    if (outputPath != "") {
        MsgBox Format("Convert:`n{1}`n`nTo:`n{2}",
            sourceFile,
            outputPath)
    }
}

/**
 * Backup file selector.
 */
BackupFileSelector() {
    filesToBackup := FileSelect("M", ,
        "Select files to backup",
        "All Files (*.*)")

    if (filesToBackup.Length = 0)
        return

    backupDir := FileSelect("D", , "Select backup destination")

    if (backupDir != "") {
        totalSize := 0
        for file in filesToBackup {
            totalSize += FileGetSize(file)
        }

        MsgBox Format("Backup {1} files to:`n{2}`n`n"
            . "Total size: {3} MB",
            filesToBackup.Length,
            backupDir,
            Round(totalSize / 1048576, 2))
    }
}

/**
 * Import/Export selector.
 */
ImportExportSelector() {
    ; Import
    importFile := FileSelect(, ,
        "Import data file",
        "Data Files (*.csv;*.json;*.xml)")

    if (importFile != "") {
        MsgBox "Importing data from:`n`n" . importFile
    }

    ; Export
    exportPath := FileSelect("S", A_MyDocuments . "\export.csv",
        "Export data",
        "CSV Files (*.csv)")

    if (exportPath != "") {
        if (!RegExMatch(exportPath, "\.csv$"))
            exportPath .= ".csv"

        MsgBox "Exporting data to:`n`n" . exportPath
    }
}

/**
 * Project file selector.
 */
ProjectFileSelector() {
    projectFile := FileSelect(, ,
        "Open project file",
        "Project Files (*.aproj;*.project)|All Files (*.*)")

    if (projectFile = "")
        return

    ; Check if valid project file
    if (FileExist(projectFile)) {
        SplitPath projectFile, &fileName, &projDir

        MsgBox Format("Opening project:`n`n"
            . "File: {1}`n"
            . "Location: {2}`n`n"
            . "Loading project resources...",
            fileName,
            projDir)

        ; Load recent files from same directory
        ; Show project structure
        ; Initialize project environment
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_BasicFileSelection()
^2:: Example2_FileTypeFilters()
^3:: Example3_MultiFileSelection()
^4:: Example4_SaveFileDialogs()
^5:: Example5_DialogOptions()
^6:: Example6_InitialDirectories()
^7:: Example7_PracticalScenarios()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * FileSelect fundamentals covered:
 * 1. Basic file selection with prompts
 * 2. File type filters for specific extensions
 * 3. Multi-file selection (Option M)
 * 4. Save file dialogs (Option S)
 * 5. Dialog options (exist checks, overwrite prompts)
 * 6. Initial directory customization
 * 7. Practical scenarios (batch processing, conversion, backup)
 * 
 * Key Points:
 * - FileSelect returns empty string if cancelled
 * - Use "M" option for multi-select (returns array)
 * - Use "S" option for save dialogs
 * - Filters format: "Description (*.ext1;*.ext2)"
 * - Options can be combined (e.g., "MS" for multi-select save)
 * - Always validate returned paths
 * - Handle cancellation gracefully
 * 
 * Common Options:
 * - M: Multi-select
 * - S: Save dialog
 * - D: Select folders (not files)
 * - 1: File must exist
 * - 2: Path must exist
 * - 8: Prompt to create
 * - 16: Prompt to overwrite
 * 
 * ============================================================================
 */

