#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * ============================================================================
 * FileSelect Advanced Applications - Part 2
 * ============================================================================
 * 
 * Advanced FileSelect applications and patterns in AutoHotkey v2.
 * 
 * @description This file covers advanced FileSelect usage including:
 *              - File validation and verification
 *              - Batch file operations
 *              - File format detection
 *              - Smart default paths
 *              - File size filtering
 *              - Extension management
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileSelect.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: File Validation and Verification
; ============================================================================
/**
 * Demonstrates file validation after selection.
 * 
 * @description Shows how to validate selected files.
 */
Example1_FileValidation() {
    ; Size validation
    file := FileSelect(, , "Select a file (max 10 MB)", "All Files (*.*)")

    if (file != "") {
        if (ValidateFileSize(file, 10485760)) {  ; 10 MB
            MsgBox "File is valid size."
        } else {
            MsgBox "File exceeds 10 MB limit!", "Error", "Iconx"
        }
    }

    ; Extension validation
    file := FileSelect(, , "Select an image", "All Files (*.*)")

    if (file != "") {
        validExts := ["png", "jpg", "jpeg", "gif", "bmp"]
        if (ValidateExtension(file, validExts)) {
            MsgBox "Valid image file selected."
        } else {
            MsgBox "File must be an image!", "Error", "Iconx"
        }
    }

    ; Readability check
    file := FileSelect(, , "Select a file to read")

    if (file != "" && ValidateReadable(file)) {
        content := FileRead(file)
        MsgBox "File loaded successfully!`n`n" . SubStr(content, 1, 100) . "..."
    }

    ; Content validation (check for specific data)
    file := FileSelect(, , "Select a JSON file", "JSON Files (*.json)")

    if (file != "" && ValidateJSON(file)) {
        MsgBox "Valid JSON file!"
    }
}

/**
 * Validates file size.
 */
ValidateFileSize(filePath, maxBytes) {
    return FileGetSize(filePath) <= maxBytes
}

/**
 * Validates file extension.
 */
ValidateExtension(filePath, validExtensions) {
    SplitPath filePath, , , &ext
    for validExt in validExtensions {
        if (StrLower(ext) = StrLower(validExt))
            return true
    }
    return false
}

/**
 * Validates file is readable.
 */
ValidateReadable(filePath) {
    try {
        FileRead(filePath)
        return true
    } catch {
        MsgBox "Cannot read file!", "Error", "Iconx"
        return false
    }
}

/**
 * Validates JSON content.
 */
ValidateJSON(filePath) {
    try {
        content := FileRead(filePath)
        ; Simple check - starts with { or [
        return RegExMatch(Trim(content), "^[\[{]")
    } catch {
        return false
    }
}

; ============================================================================
; EXAMPLE 2: Batch File Operations
; ============================================================================
/**
 * Demonstrates batch file processing.
 * 
 * @description Shows multi-file operations.
 */
Example2_BatchOperations() {
    ; Batch rename
    BatchRenameFiles()

    ; Batch convert
    BatchConvertFiles()

    ; Batch move
    BatchMoveFiles()

    ; Batch delete
    BatchDeleteFiles()
}

/**
 * Batch file renaming.
 */
BatchRenameFiles() {
    files := FileSelect("M", , "Select files to rename", "All Files (*.*)")

    if (files.Length = 0)
        return

    prefix := InputBox("Enter prefix for files:", "Batch Rename").Value
    if (prefix = "")
        return

    preview := "Rename Preview:`n`n"

    for index, file in files {
        SplitPath file, &fileName, &fileDir, &fileExt, &nameNoExt

        newName := prefix . "_" . index . "." . fileExt
        newPath := fileDir . "\" . newName

        preview .= Format("{1}.  {2} → {3}`n", index, fileName, newName)

        if (index >= 10) {
            preview .= "... and " . (files.Length - 10) . " more`n"
            break
        }
    }

    MsgBox preview
}

/**
 * Batch file conversion.
 */
BatchConvertFiles() {
    files := FileSelect("M", ,
        "Select images to convert",
        "Images (*.png;*.jpg;*.bmp)")

    if (files.Length = 0)
        return

    outputFormat := MsgBox("Convert to:`n`nYes = PNG`nNo = JPEG",
        "Output Format",
        "YesNo")

    targetExt := (outputFormat = "Yes") ? "png" : "jpg"

    MsgBox Format("Will convert {1} file(s) to .{2}",
        files.Length,
        targetExt)
}

/**
 * Batch file move.
 */
BatchMoveFiles() {
    files := FileSelect("M", , "Select files to move")

    if (files.Length = 0)
        return

    destDir := FileSelect("D", , "Select destination folder")

    if (destDir != "") {
        MsgBox Format("Move {1} files to:`n{2}",
            files.Length,
            destDir)
    }
}

/**
 * Batch file deletion with confirmation.
 */
BatchDeleteFiles() {
    files := FileSelect("M", , "Select files to delete")

    if (files.Length = 0)
        return

    confirm := MsgBox(Format("Delete {1} file(s)?`n`nThis cannot be undone!",
        files.Length),
        "Confirm Deletion",
        "YesNo Iconx 256")

    if (confirm = "Yes") {
        MsgBox "Files would be deleted (demo mode)"
        ; Loop files.Length
        ;     FileDelete files[A_Index]
    }
}

; ============================================================================
; EXAMPLE 3: Smart Default Paths
; ============================================================================
/**
 * Demonstrates intelligent default path selection.
 * 
 * @description Shows context-aware default paths.
 */
Example3_SmartDefaultPaths() {
    ; Smart path based on file type
    SmartFileOpen("image")
    SmartFileOpen("document")
    SmartFileOpen("video")
    SmartFileOpen("music")

    ; Recent files directory
    OpenFromRecent()

    ; Project-based defaults
    OpenProjectFile()
}

/**
 * Opens file with smart default path based on type.
 */
SmartFileOpen(fileType) {
    Switch fileType {
        Case "image":
            defaultDir := A_MyDocuments . "\Pictures"
            filter := "Images (*.png;*.jpg;*.jpeg;*.gif)"
            title := "Open Image"

        Case "document":
            defaultDir := A_MyDocuments
            filter := "Documents (*.txt;*.doc;*.docx;*.pdf)"
            title := "Open Document"

        Case "video":
            defaultDir := A_MyDocuments . "\Videos"
            filter := "Videos (*.mp4;*.avi;*.mkv)"
            title := "Open Video"

        Case "music":
            defaultDir := A_MyDocuments . "\Music"
            filter := "Audio (*.mp3;*.wav;*.flac)"
            title := "Open Audio"

        Default:
            defaultDir := A_MyDocuments
            filter := "All Files (*.*)"
            title := "Open File"
    }

    ; Use default directory if it exists
    if (!DirExist(defaultDir))
        defaultDir := A_MyDocuments

    file := FileSelect(, defaultDir, title, filter)

    if (file != "") {
        MsgBox Format("Opened {1} file:`n{2}", fileType, file)
    }
}

/**
 * Opens from recent files location.
 */
OpenFromRecent() {
    ; Simulate recent files directory
    recentDir := A_Temp . "\Recent"

    file := FileSelect(, DirExist(recentDir) ? recentDir : A_MyDocuments,
        "Open Recent File")

    if (file != "") {
        MsgBox "Opened from recent: " . file
    }
}

/**
 * Opens project-specific file.
 */
OpenProjectFile() {
    ; Simulate project directory
    projectDir := "C:\Projects\MyProject"

    if (!DirExist(projectDir))
        projectDir := A_MyDocuments

    file := FileSelect(, projectDir,
        "Open Project File",
        "Project Files (*.ahk;*.txt;*.json)")

    if (file != "") {
        MsgBox "Opened project file: " . file
    }
}

; ============================================================================
; EXAMPLE 4: File Format Detection
; ============================================================================
/**
 * Detects and handles different file formats.
 * 
 * @description Shows file format identification.
 */
Example4_FormatDetection() {
    file := FileSelect(, , "Select any file")

    if (file = "")
        return

    format := DetectFileFormat(file)

    MsgBox Format("File Format Detection:`n`n"
        . "File: {1}`n"
        . "Detected Type: {2}`n"
        . "Handler: {3}",
        file,
        format.type,
        format.handler)

    ; Handle based on format
    HandleFileByFormat(file, format)
}

/**
 * Detects file format.
 */
DetectFileFormat(filePath) {
    SplitPath filePath, , , &ext

    format := { type: "Unknown", handler: "Default" }

    Switch StrLower(ext) {
        Case "txt", "log", "md":
            format.type := "Text Document"
            format.handler := "Text Editor"

        Case "jpg", "jpeg", "png", "gif", "bmp":
            format.type := "Image"
            format.handler := "Image Viewer"

        Case "pdf":
            format.type := "PDF Document"
            format.handler := "PDF Reader"

        Case "doc", "docx":
            format.type := "Word Document"
            format.handler := "Word Processor"

        Case "xls", "xlsx":
            format.type := "Spreadsheet"
            format.handler := "Excel"

        Case "mp3", "wav", "flac":
            format.type := "Audio"
            format.handler := "Media Player"

        Case "mp4", "avi", "mkv":
            format.type := "Video"
            format.handler := "Video Player"

        Case "zip", "rar", "7z":
            format.type := "Archive"
            format.handler := "Archive Manager"

        Case "ahk", "ahk2":
            format.type := "AutoHotkey Script"
            format.handler := "AutoHotkey"

        Case "json", "xml", "ini":
            format.type := "Configuration"
            format.handler := "Config Editor"
    }

    return format
}

/**
 * Handles file based on detected format.
 */
HandleFileByFormat(filePath, format) {
    Switch format.type {
        Case "Text Document":
            MsgBox "Opening in text editor..."

        Case "Image":
            MsgBox "Opening in image viewer..."

        Case "PDF Document":
            MsgBox "Opening PDF..."

        Case "AutoHotkey Script":
            MsgBox "Would you like to:`n`n1. Edit script`n2. Run script"

        Default:
            MsgBox "Opening with default program..."
    }
}

; ============================================================================
; EXAMPLE 5: Advanced Filter Patterns
; ============================================================================
/**
 * Shows advanced filter patterns.
 * 
 * @description Demonstrates complex filter combinations.
 */
Example5_AdvancedFilters() {
    ; Office documents
    file := FileSelect(, ,
        "Select Office document",
        "Word (*.doc;*.docx)|Excel (*.xls;*.xlsx)|PowerPoint (*.ppt;*.pptx)|All Office (*.*)")

    ; Source code files
    file := FileSelect(, ,
        "Select source code",
        "AutoHotkey (*.ahk;*.ahk2)|Python (*.py)|JavaScript (*.js)|C/C++ (*.c;*.cpp;*.h)|All Code (*.*)")

    ; Media files
    file := FileSelect(, ,
        "Select media file",
        "All Media (*.mp3;*.mp4;*.avi;*.mkv;*.wav;*.flac)|Video Only (*.mp4;*.avi;*.mkv)|Audio Only (*.mp3;*.wav;*.flac)")

    ; Web files
    file := FileSelect(, ,
        "Select web file",
        "HTML (*.html;*.htm)|CSS (*.css)|JavaScript (*.js)|All Web (*.html;*.css;*.js)")

    ; Data files
    file := FileSelect(, ,
        "Select data file",
        "CSV (*.csv)|JSON (*.json)|XML (*.xml)|Database (*.db;*.sqlite)|All Data (*.*)")

    if (file != "") {
        MsgBox "Selected: " . file
    }
}

; ============================================================================
; EXAMPLE 6: File Browser Utilities
; ============================================================================
/**
 * Creates file browsing utilities.
 * 
 * @description Shows file browser implementations.
 */
Example6_BrowserUtilities() {
    ; Quick open (type-specific)
    QuickOpenDialog()

    ; Advanced file picker
    AdvancedFilePicker()

    ; Filtered file browser
    FilteredBrowser()
}

/**
 * Quick open dialog.
 */
QuickOpenDialog() {
    fileType := MsgBox("Quick Open:`n`n"
        . "Yes = Image`n"
        . "No = Document`n"
        . "Cancel = Any File",
        "Quick Open",
        "YesNoCancel")

    Switch fileType {
        Case "Yes":
            filter := "Images (*.png;*.jpg;*.jpeg)"
        Case "No":
            filter := "Documents (*.txt;*.doc;*.docx;*.pdf)"
        Case "Cancel":
            filter := "All Files (*.*)"
    }

    file := FileSelect(, , "Quick Open", filter)

    if (file != "") {
        MsgBox "Quick opened: " . file
    }
}

/**
 * Advanced file picker with options.
 */
AdvancedFilePicker() {
    ; Choose mode
    mode := MsgBox("File Picker Mode:`n`n"
        . "Yes = Single File`n"
        . "No = Multiple Files",
        "Mode Selection",
        "YesNo")

    options := (mode = "No") ? "M" : ""

    ; Choose location
    location := MsgBox("Start Location:`n`n"
        . "Yes = Desktop`n"
        . "No = Documents",
        "Location",
        "YesNo")

    startDir := (location = "Yes") ? A_Desktop : A_MyDocuments

    ; Select files
    result := FileSelect(options, startDir, "Advanced Picker")

    if (mode = "No" && result.Length > 0) {
        MsgBox Format("Selected {1} files", result.Length)
    } else if (mode = "Yes" && result != "") {
        MsgBox "Selected: " . result
    }
}

/**
 * Filtered file browser.
 */
FilteredBrowser() {
    category := InputBox("Enter category (image/document/code/media):",
        "Category").Value

    Switch StrLower(category) {
        Case "image":
            filter := "Images (*.png;*.jpg;*.jpeg;*.gif;*.bmp)"
        Case "document":
            filter := "Documents (*.txt;*.doc;*.docx;*.pdf)"
        Case "code":
            filter := "Source Code (*.ahk;*.py;*.js;*.html;*.css)"
        Case "media":
            filter := "Media (*.mp3;*.mp4;*.avi;*.wav)"
        Default:
            filter := "All Files (*.*)"
    }

    file := FileSelect(, , Format("Browse {1} Files", category), filter)

    if (file != "") {
        MsgBox Format("Selected {1} file:`n{2}", category, file)
    }
}

; ============================================================================
; EXAMPLE 7: File Operation Workflows
; ============================================================================
/**
 * Complete file operation workflows.
 * 
 * @description Shows end-to-end file workflows.
 */
Example7_FileWorkflows() {
    ; Edit and save workflow
    EditSaveWorkflow()

    ; Import and process workflow
    ImportProcessWorkflow()

    ; Backup workflow
    BackupWorkflow()
}

/**
 * Edit and save workflow.
 */
EditSaveWorkflow() {
    ; Open existing file
    file := FileSelect(, ,
        "Open file to edit",
        "Text Files (*.txt)")

    if (file = "")
        return

    ; Simulate editing
    MsgBox "Editing: " . file . "`n`n(Simulated changes made)"

    ; Save
    saveChoice := MsgBox("Save changes?", "Save", "YesNoCancel")

    if (saveChoice = "Yes") {
        MsgBox "File saved: " . file
    } else if (saveChoice = "No") {
        savePath := FileSelect("S", , "Save as new file", "Text Files (*.txt)")
        if (savePath != "")
            MsgBox "Saved as: " . savePath
    }
}

/**
 * Import and process workflow.
 */
ImportProcessWorkflow() {
    ; Select input file
    inputFile := FileSelect(, ,
        "Select input data",
        "Data Files (*.csv;*.json)")

    if (inputFile = "")
        return

    ; Process
    MsgBox "Processing: " . inputFile . "`n`n(Simulated processing)"

    ; Save output
    SplitPath inputFile, , &dir, , &nameNoExt

    outputFile := FileSelect("S",
        dir . "\" . nameNoExt . "_processed.txt",
        "Save processed data",
        "Text Files (*.txt)")

    if (outputFile != "") {
        MsgBox Format("Workflow complete:`n`nInput: {1}`nOutput: {2}",
            inputFile,
            outputFile)
    }
}

/**
 * Backup workflow.
 */
BackupWorkflow() {
    ; Select files to backup
    files := FileSelect("M", , "Select files to backup")

    if (files.Length = 0)
        return

    ; Select backup location
    backupDir := FileSelect("D", , "Select backup folder")

    if (backupDir = "") {
        MsgBox "Backup cancelled - no destination selected."
        return
    }

    ; Confirm backup
    confirm := MsgBox(Format("Backup {1} files to:`n{2}`n`nProceed?",
        files.Length,
        backupDir),
        "Confirm Backup",
        "YesNo")

    if (confirm = "Yes") {
        MsgBox "Backup would proceed (demo mode)"
        ; Actual backup code here
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_FileValidation()
^2:: Example2_BatchOperations()
^3:: Example3_SmartDefaultPaths()
^4:: Example4_FormatDetection()
^5:: Example5_AdvancedFilters()
^6:: Example6_BrowserUtilities()
^7:: Example7_FileWorkflows()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * Advanced FileSelect applications:
 * 1. File validation (size, extension, readability, content)
 * 2. Batch operations (rename, convert, move, delete)
 * 3. Smart default paths based on file type
 * 4. File format detection and handling
 * 5. Advanced filter patterns for specific file categories
 * 6. File browser utilities (quick open, advanced picker)
 * 7. Complete file operation workflows
 * 
 * Best Practices:
 * - Always validate selected files before processing
 * - Use appropriate filters for expected file types
 * - Handle cancellation gracefully
 * - Confirm destructive operations
 * - Provide clear feedback during batch operations
 * - Remember last used directories for better UX
 * - Auto-add extensions for save dialogs
 * 
 * ============================================================================
 */

