#Requires AutoHotkey v2.0
/**
 * BuiltIn_StrPut_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Demonstrates writing strings to binary data using StrPut.
 * Covers basic string storage in buffers and memory addresses.
 *
 * FEATURES:
 * - Writing null-terminated strings
 * - Buffer size calculation
 * - UTF-16 and UTF-8 string writing
 * - Multiple string storage
 * - String pointer creation
 * - Practical string serialization
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - StrPut Function
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrPut(string, address, length, encoding) syntax
 * - StrPut size calculation mode
 * - UTF-16 writing (Windows default)
 * - UTF-8 writing
 * - Automatic null termination
 *
 * LEARNING POINTS:
 * 1. StrPut writes strings to memory addresses
 * 2. Call StrPut without buffer to get required size
 * 3. Default encoding is UTF-16 on Windows
 * 4. StrPut adds null terminator automatically
 * 5. Returns number of characters written
 */

; ================================================================================================
; EXAMPLE 1: Basic String Writing
; ================================================================================================

Example1_BasicStringWriting() {
    str := "Hello, World!"

    ; Get required buffer size
    reqSize := StrPut(str, "UTF-16") * 2

    ; Create buffer and write string
    buf := Buffer(reqSize)
    charsWritten := StrPut(str, buf, "UTF-16")

    ; Read back to verify
    readStr := StrGet(buf, "UTF-16")

    ; Display results
    result := "Basic String Writing:`n`n"
    result .= "Original String: '" . str . "'`n"
    result .= "String Length: " . StrLen(str) . " characters`n`n"

    result .= "Buffer Info:`n"
    result .= "  Required Size: " . reqSize . " bytes`n"
    result .= "  Characters Written: " . charsWritten . "`n`n"

    result .= "Verification:`n"
    result .= "  Read Back: '" . readStr . "'`n"
    result .= "  Match: " . (str = readStr ? "Yes ✓" : "No")

    MsgBox(result, "Example 1: Basic String Writing", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Writing Multiple Strings
; ================================================================================================

Example2_MultipleStrings() {
    strings := ["First", "Second", "Third", "Fourth", "Fifth"]

    ; Calculate total size
    totalSize := 0
    offsets := []

    for str in strings {
        offsets.Push(totalSize)
        totalSize += StrPut(str, "UTF-16") * 2
    }

    ; Create buffer and write all strings
    buf := Buffer(totalSize)

    for str in strings {
        StrPut(str, buf.Ptr + offsets[A_Index], "UTF-16")
    }

    ; Read back for verification
    readStrings := []
    for offset in offsets {
        readStrings.Push(StrGet(buf.Ptr + offset, "UTF-16"))
    }

    ; Display results
    result := "Writing Multiple Strings:`n`n"
    result .= "Total Strings: " . strings.Length . "`n"
    result .= "Buffer Size: " . buf.Size . " bytes`n`n"

    result .= "String Storage:`n"
    loop strings.Length {
        result .= "  [" . (A_Index - 1) . "] Offset " . offsets[A_Index]
            . ": '" . readStrings[A_Index] . "'`n"
    }

    MsgBox(result, "Example 2: Multiple Strings", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Creating String Pointer Arrays
; ================================================================================================

Example3_StringPointerArrays() {
    names := ["Alice", "Bob", "Charlie", "Diana"]

    ; Allocate buffers for each string
    strBuffers := []
    for name in names {
        size := StrPut(name, "UTF-16") * 2
        buf := Buffer(size)
        StrPut(name, buf, "UTF-16")
        strBuffers.Push(buf)
    }

    ; Create pointer array
    ptrArray := Buffer(A_PtrSize * names.Length)
    loop names.Length {
        NumPut("Ptr", strBuffers[A_Index].Ptr, ptrArray, (A_Index - 1) * A_PtrSize)
    }

    ; Access strings via pointers
    result := "String Pointer Array:`n`n"
    result .= "Array Size: " . names.Length . " names`n`n"

    loop names.Length {
        ptr := NumGet(ptrArray, (A_Index - 1) * A_PtrSize, "Ptr")
        name := StrGet(ptr, "UTF-16")
        result .= "  [" . (A_Index - 1) . "] -> '" . name . "'`n"
    }

    MsgBox(result, "Example 3: String Pointer Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Windows API String Parameters
; ================================================================================================

Example4_WindowsAPIStrings() {
    ; Create message for MessageBox
    title := "AutoHotkey v2"
    message := "This string was written using StrPut!"

    ; Write strings to buffers
    titleBuf := Buffer(StrPut(title, "UTF-16") * 2)
    msgBuf := Buffer(StrPut(message, "UTF-16") * 2)

    StrPut(title, titleBuf, "UTF-16")
    StrPut(message, msgBuf, "UTF-16")

    ; Call Windows API
    result := DllCall("MessageBoxW"
        , "Ptr", 0
        , "Ptr", msgBuf.Ptr
        , "Ptr", titleBuf.Ptr
        , "UInt", 0x40  ; MB_ICONINFORMATION
        , "Int")

    ; Display results
    resultText := "Windows API String Usage:`n`n"
    resultText .= "MessageBox called with:`n"
    resultText .= "  Title: '" . title . "'`n"
    resultText .= "  Message: '" . message . "'`n`n"
    resultText .= "Strings written using StrPut with UTF-16 encoding`n"
    resultText .= "Result: " . result . " (1=OK button clicked)"

    MsgBox(resultText, "Example 4: Windows API", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: String Buffer Management
; ================================================================================================

Example5_BufferManagement() {
    class StringBuffer {
        __New(initialSize := 1024) {
            this.buffer := Buffer(initialSize)
            this.capacity := initialSize
            this.position := 0
            this.strings := []
        }

        Append(str) {
            reqSize := StrPut(str, "UTF-16") * 2

            if this.position + reqSize > this.capacity {
                newCapacity := Max(this.capacity * 2, this.position + reqSize)
                newBuf := Buffer(newCapacity)

                DllCall("RtlMoveMemory"
                    , "Ptr", newBuf.Ptr
                    , "Ptr", this.buffer.Ptr
                    , "UPtr", this.position)

                this.buffer := newBuf
                this.capacity := newCapacity
            }

            offset := this.position
            StrPut(str, this.buffer.Ptr + offset, "UTF-16")
            this.strings.Push({offset: offset, string: str})
            this.position += reqSize

            return offset
        }

        GetString(index) {
            if index < 1 || index > this.strings.Length
                return ""

            info := this.strings[index]
            return StrGet(this.buffer.Ptr + info.offset, "UTF-16")
        }

        GetStats() {
            return {
                Count: this.strings.Length,
                UsedBytes: this.position,
                Capacity: this.capacity,
                Utilization: Round((this.position / this.capacity) * 100, 2)
            }
        }
    }

    ; Use string buffer
    sb := StringBuffer(64)

    testStrings := ["Hello", "World", "AutoHotkey", "v2", "Binary", "Data", "Strings"]

    for str in testStrings {
        sb.Append(str)
    }

    stats := sb.GetStats()

    ; Display results
    result := "String Buffer Management:`n`n"
    result .= "Appended " . stats.Count . " strings`n`n"

    result .= "First 5 Strings:`n"
    loop Min(5, stats.Count) {
        result .= "  [" . A_Index . "] '" . sb.GetString(A_Index) . "'`n"
    }

    result .= "`nBuffer Statistics:`n"
    result .= "  Used: " . stats.UsedBytes . " bytes`n"
    result .= "  Capacity: " . stats.Capacity . " bytes`n"
    result .= "  Utilization: " . stats.Utilization . "%"

    MsgBox(result, "Example 5: Buffer Management", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    StrPut Basic Usage Examples

    1. Basic String Writing
    2. Writing Multiple Strings
    3. Creating String Pointer Arrays
    4. Windows API String Parameters
    5. String Buffer Management

    Select an example (1-5) or press Cancel to exit:
    )"

    choice := InputBox(menu, "StrPut Basic Examples", "w450 h300")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicStringWriting()
        case "2": Example2_MultipleStrings()
        case "3": Example3_StringPointerArrays()
        case "4": Example4_WindowsAPIStrings()
        case "5": Example5_BufferManagement()
        default: MsgBox("Invalid selection. Please choose 1-5.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
