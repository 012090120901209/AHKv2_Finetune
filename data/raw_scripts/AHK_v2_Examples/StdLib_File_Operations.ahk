#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * AHK v2 Standard Library Examples - Part 1: File Operations
 *
 * Built-in file handling functions and classes
 * Documentation: https://www.autohotkey.com/docs/v2/
 */

; ═══════════════════════════════════════════════════════════════════════════
; FILE READING & WRITING (Examples 1-15)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 1: FileRead() - Read entire file
 */
FileReadExample() {
    testFile := A_ScriptDir "\test.txt"
    FileDelete(testFile)
    FileAppend("Line 1`nLine 2`nLine 3", testFile)

    content := FileRead(testFile)
    MsgBox("File content:`n" content)

    FileDelete(testFile)
}

/**
 * Example 2: FileAppend() - Append to file
 */
FileAppendExample() {
    logFile := A_ScriptDir "\log.txt"
    FileDelete(logFile)

    FileAppend("Log entry 1`n", logFile)
    FileAppend("Log entry 2`n", logFile)
    FileAppend("Log entry 3`n", logFile)

    content := FileRead(logFile)
    MsgBox("Log file:`n" content)

    FileDelete(logFile)
}

/**
 * Example 3: FileOpen() - File object for reading/writing
 */
FileOpenExample() {
    dataFile := A_ScriptDir "\data.txt"

    ; Write mode
    file := FileOpen(dataFile, "w")
    file.WriteLine("First line")
    file.WriteLine("Second line")
    file.Write("Third line without newline")
    file.Close()

    ; Read mode
    file := FileOpen(dataFile, "r")
    MsgBox("Line 1: " file.ReadLine()
        . "`nLine 2: " file.ReadLine()
        . "`nRemaining: " file.Read())
    file.Close()

    FileDelete(dataFile)
}

/**
 * Example 4: FileExist() - Check if file exists
 */
FileExistExample() {
    file1 := A_ScriptDir "\exists.txt"
    FileDelete(file1)
    FileAppend("test", file1)

    result1 := FileExist(file1) ? "File exists" : "File not found"
    result2 := FileExist(A_ScriptDir "\nonexistent.txt") ? "Exists" : "Not found"

    MsgBox(result1 "`n" result2)

    FileDelete(file1)
}

/**
 * Example 5: FileDelete() and FileRecycle() - Delete files
 */
FileDeleteExample() {
    temp1 := A_ScriptDir "\temp1.txt"
    temp2 := A_ScriptDir "\temp2.txt"

    FileAppend("temp", temp1)
    FileAppend("temp", temp2)

    FileDelete(temp1)  ; Permanently delete
    FileRecycle(temp2)  ; Send to recycle bin

    MsgBox("temp1 deleted permanently`ntemp2 sent to recycle bin")
}

/**
 * Example 6: FileCopy() - Copy files
 */
FileCopyExample() {
    source := A_ScriptDir "\source.txt"
    dest := A_ScriptDir "\destination.txt"

    FileDelete(source)
    FileDelete(dest)
    FileAppend("Original content", source)

    FileCopy(source, dest, true)  ; true = overwrite if exists

    MsgBox("Source: " FileRead(source) "`nDestination: " FileRead(dest))

    FileDelete(source)
    FileDelete(dest)
}

/**
 * Example 7: FileMove() - Move/rename files
 */
FileMoveExample() {
    oldName := A_ScriptDir "\oldname.txt"
    newName := A_ScriptDir "\newname.txt"

    FileDelete(oldName)
    FileDelete(newName)
    FileAppend("test content", oldName)

    FileMove(oldName, newName, true)

    exists := FileExist(newName) ? "Yes" : "No"
    MsgBox("File moved/renamed`nNew file exists: " exists)

    FileDelete(newName)
}

/**
 * Example 8: FileGetSize() - Get file size
 */
FileGetSizeExample() {
    testFile := A_ScriptDir "\sizetest.txt"
    FileDelete(testFile)
    FileAppend("This is a test file with some content.", testFile)

    sizeBytes := FileGetSize(testFile)
    sizeKB := Round(sizeBytes / 1024, 2)

    MsgBox("File size: " sizeBytes " bytes (" sizeKB " KB)")

    FileDelete(testFile)
}

/**
 * Example 9: FileGetAttrib() - Get file attributes
 */
FileGetAttribExample() {
    testFile := A_ScriptDir "\attrtest.txt"
    FileDelete(testFile)
    FileAppend("test", testFile)

    attrib := FileGetAttrib(testFile)

    output := "File attributes: " attrib "`n`n"
    output .= "Read-only: " (InStr(attrib, "R") ? "Yes" : "No") "`n"
    output .= "Hidden: " (InStr(attrib, "H") ? "Yes" : "No") "`n"
    output .= "Archive: " (InStr(attrib, "A") ? "Yes" : "No")

    MsgBox(output)

    FileDelete(testFile)
}

/**
 * Example 10: FileSetAttrib() - Set file attributes
 */
FileSetAttribExample() {
    testFile := A_ScriptDir "\setattr.txt"
    FileDelete(testFile)
    FileAppend("test", testFile)

    FileSetAttrib("+R", testFile)  ; Make read-only
    MsgBox("File set to read-only")

    FileSetAttrib("-R", testFile)  ; Remove read-only
    MsgBox("Read-only removed")

    FileDelete(testFile)
}

/**
 * Example 11: FileGetTime() - Get file timestamp
 */
FileGetTimeExample() {
    testFile := A_ScriptDir "\timetest.txt"
    FileDelete(testFile)
    FileAppend("test", testFile)

    modTime := FileGetTime(testFile, "M")  ; M = modified
    createTime := FileGetTime(testFile, "C")  ; C = created

    MsgBox("Created: " FormatTime(createTime, "yyyy-MM-dd HH:mm:ss")
        . "`nModified: " FormatTime(modTime, "yyyy-MM-dd HH:mm:ss"))

    FileDelete(testFile)
}

/**
 * Example 12: FileSetTime() - Set file timestamp
 */
FileSetTimeExample() {
    testFile := A_ScriptDir "\settimetest.txt"
    FileDelete(testFile)
    FileAppend("test", testFile)

    ; Set to specific date/time
    FileSetTime("20240101120000", testFile, "M")

    newTime := FileGetTime(testFile, "M")
    MsgBox("Modified time set to: " FormatTime(newTime, "yyyy-MM-dd HH:mm:ss"))

    FileDelete(testFile)
}

/**
 * Example 13: FileSelect() - File picker dialog
 */
FileSelectExample() {
    selectedFile := FileSelect(3, , "Select a file", "Text Files (*.txt)")

    if selectedFile
        MsgBox("You selected: " selectedFile)
    else
        MsgBox("No file selected")
}

/**
 * Example 14: DirSelect() - Folder picker dialog
 */
DirSelectExample() {
    selectedDir := DirSelect(, 0, "Select a folder")

    if selectedDir
        MsgBox("You selected: " selectedDir)
    else
        MsgBox("No folder selected")
}

/**
 * Example 15: Loop Files - Iterate through files
 */
LoopFilesExample() {
    ; Create test files
    testDir := A_ScriptDir "\testfiles"
    DirCreate(testDir)

    Loop 5
        FileAppend("test" A_Index, testDir "\file" A_Index ".txt")

    ; List all files
    output := "Files in folder:`n`n"
    Loop Files testDir "\*.txt" {
        output .= A_LoopFileName " (" A_LoopFileSize " bytes)`n"
    }

    MsgBox(output)

    ; Cleanup
    Loop Files testDir "\*.*"
        FileDelete(A_LoopFilePath)
    DirDelete(testDir)
}

; ═══════════════════════════════════════════════════════════════════════════
; DIRECTORY OPERATIONS (Examples 16-20)
; ═══════════════════════════════════════════════════════════════════════════

/**
 * Example 16: DirCreate() - Create directory
 */
DirCreateExample() {
    newDir := A_ScriptDir "\newfolder"

    if DirExist(newDir)
        DirDelete(newDir)

    DirCreate(newDir)
    MsgBox("Directory created: " newDir)

    DirDelete(newDir)
}

/**
 * Example 17: DirDelete() - Delete directory
 */
DirDeleteExample() {
    testDir := A_ScriptDir "\tempdir"
    DirCreate(testDir)
    FileAppend("test", testDir "\file.txt")

    DirDelete(testDir, true)  ; true = delete even if not empty
    MsgBox("Directory deleted")
}

/**
 * Example 18: DirExist() - Check if directory exists
 */
DirExistExample() {
    exists1 := DirExist(A_ScriptDir) ? "Yes" : "No"
    exists2 := DirExist("C:\NonExistentFolder") ? "Yes" : "No"

    MsgBox("Script directory exists: " exists1
        . "`nNonexistent folder exists: " exists2)
}

/**
 * Example 19: DirCopy() - Copy directory
 */
DirCopyExample() {
    sourceDir := A_ScriptDir "\sourcedir"
    destDir := A_ScriptDir "\destdir"

    ; Create source with files
    DirCreate(sourceDir)
    FileAppend("file1", sourceDir "\file1.txt")
    FileAppend("file2", sourceDir "\file2.txt")

    ; Copy
    DirCopy(sourceDir, destDir, true)

    MsgBox("Directory copied")

    ; Cleanup
    DirDelete(sourceDir, true)
    DirDelete(destDir, true)
}

/**
 * Example 20: DirMove() - Move/rename directory
 */
DirMoveExample() {
    oldDir := A_ScriptDir "\olddir"
    newDir := A_ScriptDir "\newdir"

    DirCreate(oldDir)
    FileAppend("test", oldDir "\file.txt")

    DirMove(oldDir, newDir)

    MsgBox("Directory moved/renamed")

    DirDelete(newDir, true)
}

; Menu
MsgBox("AHK v2 Standard Library - File Operations (Part 1)`n`n"
    . "FILE OPERATIONS (1-15):`n"
    . "1. FileRead   2. FileAppend   3. FileOpen   4. FileExist   5. FileDelete`n"
    . "6. FileCopy   7. FileMove   8. FileGetSize   9. FileGetAttrib   10. FileSetAttrib`n"
    . "11. FileGetTime   12. FileSetTime   13. FileSelect   14. DirSelect   15. Loop Files`n`n"
    . "DIRECTORY OPS (16-20):`n"
    . "16. DirCreate   17. DirDelete   18. DirExist   19. DirCopy   20. DirMove`n`n"
    . "Call any example function to run!")

; Uncomment to test:
; FileReadExample()
; FileOpenExample()
; LoopFilesExample()
