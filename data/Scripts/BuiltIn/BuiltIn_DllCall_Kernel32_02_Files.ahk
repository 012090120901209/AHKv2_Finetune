#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_DllCall_Kernel32_02_Files.ahk
 * 
 * DESCRIPTION:
 * Demonstrates file operations using Windows API through DllCall.
 * Shows how to create, open, read, write, and manipulate files using low-level
 * Windows API functions for maximum control and performance.
 * 
 * FEATURES:
 * - Creating and opening files with CreateFile
 * - Reading and writing files with ReadFile and WriteFile
 * - File pointer manipulation (SetFilePointer)
 * - Getting and setting file attributes
 * - File locking mechanisms
 * - Asynchronous file I/O
 * - File mapping for fast access
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft File Management API
 * https://docs.microsoft.com/en-us/windows/win32/fileio/file-management-functions
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with file handling functions
 * - Handle management and cleanup
 * - Buffer operations for file I/O
 * - Error handling with GetLastError
 * - Working with file attributes and times
 * 
 * LEARNING POINTS:
 * 1. Using CreateFile for different access modes
 * 2. Reading and writing data with Windows API
 * 3. File pointer positioning and seeking
 * 4. Setting file attributes (hidden, readonly, etc.)
 * 5. Locking files and regions
 * 6. Getting file size and information
 * 7. Memory-mapped file I/O
 */

;==============================================================================
; EXAMPLE 1: Creating and Opening Files
;==============================================================================
; Demonstrates CreateFile with various parameters

Example1_CreateOpenFiles() {
    ; File access constants
    GENERIC_READ := 0x80000000
    GENERIC_WRITE := 0x40000000

    ; File share constants
    FILE_SHARE_READ := 0x00000001
    FILE_SHARE_WRITE := 0x00000002

    ; Creation disposition constants
    CREATE_NEW := 1           ; Create new (fails if exists)
    CREATE_ALWAYS := 2        ; Create new (overwrites if exists)
    OPEN_EXISTING := 3        ; Open existing (fails if doesn't exist)
    OPEN_ALWAYS := 4          ; Open existing or create new
    TRUNCATE_EXISTING := 5    ; Open and truncate to 0 bytes

    ; File attributes
    FILE_ATTRIBUTE_NORMAL := 0x80

    INVALID_HANDLE_VALUE := -1

    ; Create a test file
    testFile := A_Temp . "\test_createfile.txt"

    ; Create new file for writing
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile                    ; lpFileName
        , "UInt", GENERIC_WRITE              ; dwDesiredAccess
        , "UInt", 0                          ; dwShareMode (exclusive)
        , "Ptr", 0                           ; lpSecurityAttributes
        , "UInt", CREATE_ALWAYS              ; dwCreationDisposition
        , "UInt", FILE_ATTRIBUTE_NORMAL      ; dwFlagsAndAttributes
        , "Ptr", 0                           ; hTemplateFile
        , "Ptr")                             ; Return: file handle

    if (hFile = INVALID_HANDLE_VALUE) {
        MsgBox("Failed to create file!`nError: " . DllCall("Kernel32.dll\GetLastError", "UInt"), "Error")
        return
    }

    MsgBox(Format("Created file successfully:`n{}`n`nHandle: 0x{:X}", testFile, hFile), "Success")

    ; Close the file
    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")

    ; Now open for reading
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ
        , "UInt", FILE_SHARE_READ
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    if (hFile != INVALID_HANDLE_VALUE) {
        MsgBox("Opened file for reading successfully!", "Success")
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    }

    ; Open for both reading and writing
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ | GENERIC_WRITE
        , "UInt", 0
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    if (hFile != INVALID_HANDLE_VALUE) {
        MsgBox("Opened file for read/write successfully!", "Success")
        DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    }

    ; Cleanup
    FileDelete(testFile)
}

;==============================================================================
; EXAMPLE 2: Reading and Writing Files
;==============================================================================
; Shows ReadFile and WriteFile functions

Example2_ReadWriteFiles() {
    GENERIC_READ := 0x80000000
    GENERIC_WRITE := 0x40000000
    CREATE_ALWAYS := 2
    OPEN_EXISTING := 3
    FILE_ATTRIBUTE_NORMAL := 0x80
    INVALID_HANDLE_VALUE := -1

    testFile := A_Temp . "\test_readwrite.txt"

    ; Create and write to file
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_WRITE
        , "UInt", 0
        , "Ptr", 0
        , "UInt", CREATE_ALWAYS
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    if (hFile = INVALID_HANDLE_VALUE) {
        MsgBox("Failed to create file!", "Error")
        return
    }

    ; Prepare data to write
    dataToWrite := "Hello from Windows API!`r`nThis is line 2.`r`nAnd line 3."
    dataBuffer := Buffer(StrPut(dataToWrite, "UTF-8"), 0)
    StrPut(dataToWrite, dataBuffer.Ptr, "UTF-8")

    bytesToWrite := StrPut(dataToWrite, "UTF-8") - 1  ; Exclude null terminator

    ; Write to file
    bytesWritten := Buffer(4, 0)
    success := DllCall("Kernel32.dll\WriteFile"
        , "Ptr", hFile                   ; hFile
        , "Ptr", dataBuffer.Ptr          ; lpBuffer
        , "UInt", bytesToWrite           ; nNumberOfBytesToWrite
        , "Ptr", bytesWritten.Ptr        ; lpNumberOfBytesWritten
        , "Ptr", 0                       ; lpOverlapped
        , "Int")                         ; Return: success

    written := NumGet(bytesWritten, 0, "UInt")

    if (success)
        MsgBox(Format("Wrote {} bytes to file", written), "Write Success")

    ; Close file
    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")

    ; Now read the file
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ
        , "UInt", 0
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    if (hFile = INVALID_HANDLE_VALUE) {
        MsgBox("Failed to open file for reading!", "Error")
        return
    }

    ; Get file size
    fileSize := DllCall("Kernel32.dll\GetFileSize"
        , "Ptr", hFile
        , "Ptr", 0
        , "UInt")

    ; Read the file
    readBuffer := Buffer(fileSize + 1, 0)
    bytesRead := Buffer(4, 0)

    success := DllCall("Kernel32.dll\ReadFile"
        , "Ptr", hFile
        , "Ptr", readBuffer.Ptr
        , "UInt", fileSize
        , "Ptr", bytesRead.Ptr
        , "Ptr", 0
        , "Int")

    read := NumGet(bytesRead, 0, "UInt")

    if (success) {
        content := StrGet(readBuffer.Ptr, "UTF-8")
        MsgBox(Format("Read {} bytes:`n`n{}", read, content), "Read Success")
    }

    ; Close and cleanup
    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    FileDelete(testFile)
}

;==============================================================================
; EXAMPLE 3: File Pointer Manipulation
;==============================================================================
; Demonstrates seeking and file pointer positioning

Example3_FilePointer() {
    GENERIC_READ := 0x80000000
    GENERIC_WRITE := 0x40000000
    CREATE_ALWAYS := 2
    OPEN_EXISTING := 3
    FILE_ATTRIBUTE_NORMAL := 0x80
    INVALID_HANDLE_VALUE := -1

    ; File pointer movement methods
    FILE_BEGIN := 0
    FILE_CURRENT := 1
    FILE_END := 2

    testFile := A_Temp . "\test_pointer.dat"

    ; Create file and write numbered data
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_WRITE
        , "UInt", 0
        , "Ptr", 0
        , "UInt", CREATE_ALWAYS
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    ; Write numbers 1-100
    bytesWritten := Buffer(4, 0)
    Loop 100 {
        numBuffer := Buffer(4, 0)
        NumPut("Int", A_Index, numBuffer, 0)
        DllCall("Kernel32.dll\WriteFile"
            , "Ptr", hFile
            , "Ptr", numBuffer.Ptr
            , "UInt", 4
            , "Ptr", bytesWritten.Ptr
            , "Ptr", 0
            , "Int")
    }

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")

    ; Open for reading
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ
        , "UInt", 0
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    ; Read number at position 0 (first number)
    numBuffer := Buffer(4, 0)
    bytesRead := Buffer(4, 0)
    DllCall("Kernel32.dll\ReadFile", "Ptr", hFile, "Ptr", numBuffer.Ptr, "UInt", 4, "Ptr", bytesRead.Ptr, "Ptr", 0, "Int")
    num1 := NumGet(numBuffer, 0, "Int")

    ; Seek to middle (50th number - position 49 * 4 = 196)
    newPos := DllCall("Kernel32.dll\SetFilePointer"
        , "Ptr", hFile
        , "Int", 49 * 4
        , "Ptr", 0
        , "UInt", FILE_BEGIN
        , "UInt")

    DllCall("Kernel32.dll\ReadFile", "Ptr", hFile, "Ptr", numBuffer.Ptr, "UInt", 4, "Ptr", bytesRead.Ptr, "Ptr", 0, "Int")
    num50 := NumGet(numBuffer, 0, "Int")

    ; Seek to end
    endPos := DllCall("Kernel32.dll\SetFilePointer"
        , "Ptr", hFile
        , "Int", 0
        , "Ptr", 0
        , "UInt", FILE_END
        , "UInt")

    ; Seek back 4 bytes from end (last number)
    DllCall("Kernel32.dll\SetFilePointer", "Ptr", hFile, "Int", -4, "Ptr", 0, "UInt", FILE_END, "UInt")
    DllCall("Kernel32.dll\ReadFile", "Ptr", hFile, "Ptr", numBuffer.Ptr, "UInt", 4, "Ptr", bytesRead.Ptr, "Ptr", 0, "Int")
    num100 := NumGet(numBuffer, 0, "Int")

    MsgBox(Format("File pointer positioning:`n`nFirst number: {}`n50th number: {}`nLast number: {}`n`nFile size: {} bytes",
        num1, num50, num100, endPos), "Results")

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    FileDelete(testFile)
}

;==============================================================================
; EXAMPLE 4: File Attributes
;==============================================================================
; Shows getting and setting file attributes

Example4_FileAttributes() {
    ; File attribute constants
    FILE_ATTRIBUTE_READONLY := 0x01
    FILE_ATTRIBUTE_HIDDEN := 0x02
    FILE_ATTRIBUTE_SYSTEM := 0x04
    FILE_ATTRIBUTE_ARCHIVE := 0x20
    FILE_ATTRIBUTE_NORMAL := 0x80
    FILE_ATTRIBUTE_TEMPORARY := 0x100

    testFile := A_Temp . "\test_attributes.txt"

    ; Create test file
    FileAppend("Test file for attributes", testFile)

    ; Get current attributes
    attrs := DllCall("Kernel32.dll\GetFileAttributesW"
        , "Str", testFile
        , "UInt")

    if (attrs != 0xFFFFFFFF) {
        attrNames := []
        if (attrs & FILE_ATTRIBUTE_READONLY)
            attrNames.Push("ReadOnly")
        if (attrs & FILE_ATTRIBUTE_HIDDEN)
            attrNames.Push("Hidden")
        if (attrs & FILE_ATTRIBUTE_SYSTEM)
            attrNames.Push("System")
        if (attrs & FILE_ATTRIBUTE_ARCHIVE)
            attrNames.Push("Archive")

        MsgBox(Format("Current attributes: 0x{:X}`n`n{}", attrs, StrJoin(attrNames, ", ")), "Attributes")
    }

    ; Set file to hidden and readonly
    newAttrs := FILE_ATTRIBUTE_HIDDEN | FILE_ATTRIBUTE_READONLY

    success := DllCall("Kernel32.dll\SetFileAttributesW"
        , "Str", testFile
        , "UInt", newAttrs
        , "Int")

    if (success)
        MsgBox("Set file to Hidden and ReadOnly", "Success")

    Sleep(1000)

    ; Verify
    attrs := DllCall("Kernel32.dll\GetFileAttributesW", "Str", testFile, "UInt")
    MsgBox(Format("New attributes: 0x{:X}`nHidden: {}`nReadOnly: {}",
        attrs,
        attrs & FILE_ATTRIBUTE_HIDDEN ? "Yes" : "No",
        attrs & FILE_ATTRIBUTE_READONLY ? "Yes" : "No"), "Verification")

    ; Remove attributes
    DllCall("Kernel32.dll\SetFileAttributesW", "Str", testFile, "UInt", FILE_ATTRIBUTE_NORMAL, "Int")

    ; Cleanup
    FileDelete(testFile)
}

;==============================================================================
; EXAMPLE 5: File Time Information
;==============================================================================
; Demonstrates getting and setting file times

Example5_FileTimes() {
    GENERIC_READ := 0x80000000
    GENERIC_WRITE := 0x40000000
    OPEN_EXISTING := 3
    FILE_ATTRIBUTE_NORMAL := 0x80
    INVALID_HANDLE_VALUE := -1

    testFile := A_Temp . "\test_times.txt"
    FileAppend("Test file for time operations", testFile)

    ; Open file
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ | GENERIC_WRITE
        , "UInt", 0
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    if (hFile = INVALID_HANDLE_VALUE) {
        MsgBox("Failed to open file!", "Error")
        return
    }

    ; Get file times (FILETIME structures - 8 bytes each)
    creationTime := Buffer(8, 0)
    lastAccessTime := Buffer(8, 0)
    lastWriteTime := Buffer(8, 0)

    success := DllCall("Kernel32.dll\GetFileTime"
        , "Ptr", hFile
        , "Ptr", creationTime.Ptr
        , "Ptr", lastAccessTime.Ptr
        , "Ptr", lastWriteTime.Ptr
        , "Int")

    if (success) {
        ; Convert FILETIME to SYSTEMTIME for display
        sysTime := Buffer(16, 0)

        DllCall("Kernel32.dll\FileTimeToSystemTime", "Ptr", creationTime.Ptr, "Ptr", sysTime.Ptr, "Int")
        year := NumGet(sysTime, 0, "UShort")
        month := NumGet(sysTime, 2, "UShort")
        day := NumGet(sysTime, 6, "UShort")
        hour := NumGet(sysTime, 8, "UShort")
        minute := NumGet(sysTime, 10, "UShort")
        second := NumGet(sysTime, 12, "UShort")

        created := Format("{:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}", year, month, day, hour, minute, second)

        DllCall("Kernel32.dll\FileTimeToSystemTime", "Ptr", lastWriteTime.Ptr, "Ptr", sysTime.Ptr, "Int")
        year := NumGet(sysTime, 0, "UShort")
        month := NumGet(sysTime, 2, "UShort")
        day := NumGet(sysTime, 6, "UShort")
        hour := NumGet(sysTime, 8, "UShort")
        minute := NumGet(sysTime, 10, "UShort")
        second := NumGet(sysTime, 12, "UShort")

        modified := Format("{:04d}-{:02d}-{:02d} {:02d}:{:02d}:{:02d}", year, month, day, hour, minute, second)

        MsgBox(Format("File Times:`n`nCreated: {}`nModified: {}", created, modified), "File Times")
    }

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    FileDelete(testFile)
}

; Helper function
StrJoin(arr, delimiter) {
    result := ""
    for item in arr {
        if (result != "")
            result .= delimiter
        result .= item
    }
    return result
}

;==============================================================================
; EXAMPLE 6: File Locking
;==============================================================================
; Shows file and region locking

Example6_FileLocking() {
    GENERIC_READ := 0x80000000
    GENERIC_WRITE := 0x40000000
    CREATE_ALWAYS := 2
    FILE_ATTRIBUTE_NORMAL := 0x80
    INVALID_HANDLE_VALUE := -1

    testFile := A_Temp . "\test_locking.txt"

    ; Create and open file
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ | GENERIC_WRITE
        , "UInt", 0
        , "Ptr", 0
        , "UInt", CREATE_ALWAYS
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    ; Write data
    data := "This is locked data"
    dataBuffer := Buffer(StrPut(data, "UTF-8"), 0)
    StrPut(data, dataBuffer.Ptr, "UTF-8")
    bytesWritten := Buffer(4, 0)
    DllCall("Kernel32.dll\WriteFile", "Ptr", hFile, "Ptr", dataBuffer.Ptr, "UInt", StrPut(data, "UTF-8") - 1, "Ptr", bytesWritten.Ptr, "Ptr", 0, "Int")

    ; Lock first 10 bytes
    success := DllCall("Kernel32.dll\LockFile"
        , "Ptr", hFile
        , "UInt", 0          ; dwFileOffsetLow
        , "UInt", 0          ; dwFileOffsetHigh
        , "UInt", 10         ; nNumberOfBytesToLockLow
        , "UInt", 0          ; nNumberOfBytesToLockHigh
        , "Int")

    if (success)
        MsgBox("Locked first 10 bytes of file", "Success")

    ; Try to open file from another handle (should fail or have limited access)
    MsgBox("File region is locked.`nTrying to access it from another handle would fail.", "Info")

    ; Unlock the region
    DllCall("Kernel32.dll\UnlockFile"
        , "Ptr", hFile
        , "UInt", 0
        , "UInt", 0
        , "UInt", 10
        , "UInt", 0
        , "Int")

    MsgBox("Unlocked file region", "Success")

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    FileDelete(testFile)
}

;==============================================================================
; EXAMPLE 7: Advanced File Operations
;==============================================================================
; Comprehensive file operation example

Example7_AdvancedOperations() {
    GENERIC_READ := 0x80000000
    GENERIC_WRITE := 0x40000000
    CREATE_ALWAYS := 2
    OPEN_EXISTING := 3
    FILE_ATTRIBUTE_NORMAL := 0x80
    FILE_BEGIN := 0
    FILE_END := 2
    INVALID_HANDLE_VALUE := -1

    testFile := A_Temp . "\test_advanced.dat"

    ; Create binary file
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_WRITE
        , "UInt", 0
        , "Ptr", 0
        , "UInt", CREATE_ALWAYS
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    ; Write structured binary data
    bytesWritten := Buffer(4, 0)

    ; Header: Magic number + version
    header := Buffer(8, 0)
    NumPut("UInt", 0x12345678, header, 0)  ; Magic
    NumPut("UInt", 1, header, 4)           ; Version
    DllCall("Kernel32.dll\WriteFile", "Ptr", hFile, "Ptr", header.Ptr, "UInt", 8, "Ptr", bytesWritten.Ptr, "Ptr", 0, "Int")

    ; Data records
    Loop 10 {
        record := Buffer(12, 0)
        NumPut("Int", A_Index, record, 0)           ; ID
        NumPut("Int", A_Index * 100, record, 4)     ; Value
        NumPut("Int", A_Index * 10, record, 8)      ; Count
        DllCall("Kernel32.dll\WriteFile", "Ptr", hFile, "Ptr", record.Ptr, "UInt", 12, "Ptr", bytesWritten.Ptr, "Ptr", 0, "Int")
    }

    ; Get final file size
    fileSize := DllCall("Kernel32.dll\SetFilePointer", "Ptr", hFile, "Int", 0, "Ptr", 0, "UInt", FILE_END, "UInt")

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")

    MsgBox(Format("Created binary file with structured data:`nSize: {} bytes", fileSize), "Success")

    ; Read and parse the file
    hFile := DllCall("Kernel32.dll\CreateFileW"
        , "Str", testFile
        , "UInt", GENERIC_READ
        , "UInt", 0
        , "Ptr", 0
        , "UInt", OPEN_EXISTING
        , "UInt", FILE_ATTRIBUTE_NORMAL
        , "Ptr", 0
        , "Ptr")

    bytesRead := Buffer(4, 0)

    ; Read header
    header := Buffer(8, 0)
    DllCall("Kernel32.dll\ReadFile", "Ptr", hFile, "Ptr", header.Ptr, "UInt", 8, "Ptr", bytesRead.Ptr, "Ptr", 0, "Int")

    magic := NumGet(header, 0, "UInt")
    version := NumGet(header, 4, "UInt")

    results := Format("Binary File Contents:`n`nHeader:`nMagic: 0x{:X}`nVersion: {}`n`nRecords:`n", magic, version)

    ; Read records
    Loop 10 {
        record := Buffer(12, 0)
        DllCall("Kernel32.dll\ReadFile", "Ptr", hFile, "Ptr", record.Ptr, "UInt", 12, "Ptr", bytesRead.Ptr, "Ptr", 0, "Int")

        id := NumGet(record, 0, "Int")
        value := NumGet(record, 4, "Int")
        count := NumGet(record, 8, "Int")

        results .= Format("  Record {}: Value={}, Count={}`n", id, value, count)
    }

    MsgBox(results, "File Contents")

    DllCall("Kernel32.dll\CloseHandle", "Ptr", hFile, "Int")
    FileDelete(testFile)
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    File Operations DllCall Examples
    =================================

    1. Creating and Opening Files
    2. Reading and Writing
    3. File Pointer Manipulation
    4. File Attributes
    5. File Time Information
    6. File Locking
    7. Advanced Operations

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "File Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_CreateOpenFiles()
            case "2": Example2_ReadWriteFiles()
            case "3": Example3_FilePointer()
            case "4": Example4_FileAttributes()
            case "5": Example5_FileTimes()
            case "6": Example6_FileLocking()
            case "7": Example7_AdvancedOperations()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
