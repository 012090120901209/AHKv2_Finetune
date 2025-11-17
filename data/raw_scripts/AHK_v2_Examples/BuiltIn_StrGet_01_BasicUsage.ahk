#Requires AutoHotkey v2.0
/**
 * BuiltIn_StrGet_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Demonstrates reading strings from binary data using StrGet.
 * Covers basic string extraction from buffers and memory addresses.
 *
 * FEATURES:
 * - Reading null-terminated strings
 * - String length specification
 * - UTF-16 and UTF-8 string reading
 * - Reading multiple strings from buffer
 * - String pointer dereferencing
 * - Practical string extraction
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - StrGet Function
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrGet(address, length, encoding) syntax
 * - StrGet with Buffer objects
 * - UTF-16 (default encoding on Windows)
 * - UTF-8 support
 * - Automatic null termination handling
 *
 * LEARNING POINTS:
 * 1. StrGet reads strings from memory addresses
 * 2. Default encoding is UTF-16 on Windows
 * 3. Length parameter can be omitted for null-terminated strings
 * 4. StrGet handles Unicode properly
 * 5. Can read from Buffer.Ptr or numeric addresses
 */

; ================================================================================================
; EXAMPLE 1: Basic String Reading
; ================================================================================================

Example1_BasicStringReading() {
    ; Create buffer and write string using StrPut
    str := "Hello, World!"
    buf := Buffer(StrPut(str, "UTF-16") * 2)
    StrPut(str, buf, "UTF-16")

    ; Read string back using StrGet
    readStr := StrGet(buf, "UTF-16")

    ; Display results
    result := "Basic String Reading:`n`n"
    result .= "Original String: '" . str . "'`n"
    result .= "Buffer Size: " . buf.Size . " bytes`n"
    result .= "Read String: '" . readStr . "'`n`n"
    result .= "Match: " . (str = readStr ? "Yes ✓" : "No")

    MsgBox(result, "Example 1: Basic String Reading", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Reading with Length Specification
; ================================================================================================

Example2_LengthSpecification() {
    ; Create buffer with long string
    fullStr := "AutoHotkey v2 is awesome!"
    buf := Buffer(StrPut(fullStr, "UTF-16") * 2)
    StrPut(fullStr, buf, "UTF-16")

    ; Read different lengths
    str10 := StrGet(buf, 10, "UTF-16")
    str20 := StrGet(buf, 20, "UTF-16")
    strFull := StrGet(buf, "UTF-16")

    ; Display results
    result := "String Reading with Length:`n`n"
    result .= "Full String: '" . fullStr . "'`n"
    result .= "Length: " . StrLen(fullStr) . " characters`n`n"

    result .= "Read Operations:`n"
    result .= "  First 10 chars: '" . str10 . "'`n"
    result .= "  First 20 chars: '" . str20 . "'`n"
    result .= "  Full (auto): '" . strFull . "'"

    MsgBox(result, "Example 2: Length Specification", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Reading Multiple Strings
; ================================================================================================

Example3_MultipleStrings() {
    ; Create buffer with multiple null-terminated strings
    strings := ["First", "Second", "Third", "Fourth"]

    ; Calculate total size needed
    totalSize := 0
    offsets := []

    for str in strings {
        offsets.Push(totalSize)
        totalSize += StrPut(str, "UTF-16") * 2
    }

    ; Create buffer and write strings
    buf := Buffer(totalSize)
    for str in strings {
        StrPut(str, buf.Ptr + offsets[A_Index], "UTF-16")
    }

    ; Read strings back
    readStrings := []
    for offset in offsets {
        readStrings.Push(StrGet(buf.Ptr + offset, "UTF-16"))
    }

    ; Display results
    result := "Reading Multiple Strings:`n`n"
    result .= "Buffer Size: " . buf.Size . " bytes`n"
    result .= "Strings Stored: " . strings.Length . "`n`n"

    loop strings.Length {
        result .= "String " . A_Index . ":`n"
        result .= "  Offset: " . offsets[A_Index] . " bytes`n"
        result .= "  Value: '" . readStrings[A_Index] . "'`n"
        if A_Index < strings.Length
            result .= "`n"
    }

    MsgBox(result, "Example 3: Multiple Strings", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Pointer Dereferencing
; ================================================================================================

Example4_PointerDereferencing() {
    ; Create string buffer
    str := "Pointer Test String"
    strBuf := Buffer(StrPut(str, "UTF-16") * 2)
    StrPut(str, strBuf, "UTF-16")

    ; Create pointer buffer
    ptrBuf := Buffer(A_PtrSize)
    NumPut("Ptr", strBuf.Ptr, ptrBuf, 0)

    ; Read pointer and dereference to get string
    strPtr := NumGet(ptrBuf, 0, "Ptr")
    readStr := StrGet(strPtr, "UTF-16")

    ; Display results
    result := "Pointer Dereferencing:`n`n"
    result .= "Original String: '" . str . "'`n"
    result .= "String Address: 0x" . Format("{:X}", strBuf.Ptr) . "`n`n"

    result .= "Pointer Buffer:`n"
    result .= "  Stored Address: 0x" . Format("{:X}", strPtr) . "`n"
    result .= "  Dereferenced String: '" . readStr . "'`n`n"

    result .= "Match: " . (str = readStr ? "Yes ✓" : "No")

    MsgBox(result, "Example 4: Pointer Dereferencing", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Reading Windows API Strings
; ================================================================================================

Example5_WindowsAPIStrings() {
    ; Get computer name using Windows API
    nameBuf := Buffer(260 * 2)
    sizeBuf := Buffer(4)
    NumPut("UInt", 260, sizeBuf, 0)

    DllCall("GetComputerNameW", "Ptr", nameBuf.Ptr, "Ptr", sizeBuf.Ptr)

    ; Read string using StrGet
    computerName := StrGet(nameBuf, "UTF-16")

    ; Get Windows directory
    winDirBuf := Buffer(260 * 2)
    DllCall("GetWindowsDirectoryW", "Ptr", winDirBuf.Ptr, "UInt", 260)
    windowsDir := StrGet(winDirBuf, "UTF-16")

    ; Get system directory
    sysDirBuf := Buffer(260 * 2)
    DllCall("GetSystemDirectoryW", "Ptr", sysDirBuf.Ptr, "UInt", 260)
    systemDir := StrGet(sysDirBuf, "UTF-16")

    ; Display results
    result := "Windows API String Reading:`n`n"
    result .= "Computer Name:`n"
    result .= "  " . computerName . "`n`n"

    result .= "Windows Directory:`n"
    result .= "  " . windowsDir . "`n`n"

    result .= "System Directory:`n"
    result .= "  " . systemDir . "`n`n"

    result .= "All strings read using StrGet with UTF-16 encoding"

    MsgBox(result, "Example 5: Windows API Strings", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: String Array Reading
; ================================================================================================

Example6_StringArrays() {
    ; Create array of name strings
    names := ["Alice", "Bob", "Charlie", "Diana", "Edward"]

    ; Calculate offsets and total size
    offsets := []
    totalSize := 0

    for name in names {
        offsets.Push(totalSize)
        totalSize += StrPut(name, "UTF-16") * 2
    }

    ; Create and populate buffer
    buf := Buffer(totalSize)
    for name in names {
        StrPut(name, buf.Ptr + offsets[A_Index], "UTF-16")
    }

    ; Create pointer array
    ptrArray := Buffer(A_PtrSize * names.Length)
    loop names.Length {
        NumPut("Ptr", buf.Ptr + offsets[A_Index], ptrArray, (A_Index - 1) * A_PtrSize)
    }

    ; Read strings via pointer array
    readNames := []
    loop names.Length {
        ptr := NumGet(ptrArray, (A_Index - 1) * A_PtrSize, "Ptr")
        readNames.Push(StrGet(ptr, "UTF-16"))
    }

    ; Display results
    result := "String Array Reading:`n`n"
    result .= "Array Size: " . names.Length . " names`n"
    result .= "Total Buffer: " . buf.Size . " bytes`n"
    result .= "Pointer Array: " . ptrArray.Size . " bytes`n`n"

    result .= "Names via Pointer Array:`n"
    loop names.Length {
        ptr := NumGet(ptrArray, (A_Index - 1) * A_PtrSize, "Ptr")
        result .= "  [" . (A_Index - 1) . "] 0x" . Format("{:X}", ptr)
            . " -> '" . readNames[A_Index] . "'`n"
    }

    MsgBox(result, "Example 6: String Arrays", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    StrGet Basic Usage Examples

    1. Basic String Reading
    2. Reading with Length Specification
    3. Reading Multiple Strings
    4. Pointer Dereferencing
    5. Reading Windows API Strings
    6. String Array Reading

    Select an example (1-6) or press Cancel to exit:
    )"

    choice := InputBox(menu, "StrGet Basic Examples", "w450 h320")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicStringReading()
        case "2": Example2_LengthSpecification()
        case "3": Example3_MultipleStrings()
        case "4": Example4_PointerDereferencing()
        case "5": Example5_WindowsAPIStrings()
        case "6": Example6_StringArrays()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
