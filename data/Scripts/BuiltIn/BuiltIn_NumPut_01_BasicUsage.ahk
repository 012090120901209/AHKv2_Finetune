#Requires AutoHotkey v2.0

/**
 * BuiltIn_NumPut_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Fundamental NumPut usage for writing integer values to binary data.
 * Covers all integer types, basic memory writing patterns, and type safety.
 * 
 * FEATURES:
 * - Writing signed and unsigned integers
 * - Understanding type sizes and limits
 * - Sequential writing with offset management
 * - Overwrite protection patterns
 * - Integer array creation
 * - Practical data packing
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - NumPut Function
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - NumPut(type, value, buffer, offset) syntax
 * - Type specifiers: UChar, Char, UShort, Short, UInt, Int, UInt64, Int64
 * - Return value (address after written data)
 * - Chaining NumPut calls
 * - Buffer integration
 * 
 * LEARNING POINTS:
 * 1. NumPut writes numeric values to memory at specified offsets
 * 2. Type parameter determines bytes written and value interpretation
 * 3. NumPut returns address immediately after written data
 * 4. Multiple NumPut calls can be chained
 * 5. Always ensure buffer is large enough for writes
 */

; ================================================================================================
; EXAMPLE 1: Basic Integer Writing
; ================================================================================================

Example1_BasicIntegerWriting() {
    buf := Buffer(30)

    ; Write different integer types
    NumPut("UChar", 255, buf, 0)
    NumPut("Char", -128, buf, 1)
    NumPut("UShort", 65535, buf, 2)
    NumPut("Short", -32768, buf, 4)
    NumPut("UInt", 4294967295, buf, 6)
    NumPut("Int", -2147483648, buf, 10)
    NumPut("UInt64", 0xFFFFFFFFFFFFFFFF, buf, 14)
    NumPut("Int64", -9223372036854775808, buf, 22)

    ; Read back to verify
    result := "Basic Integer Writing Examples:`n`n"
    result .= "8-bit Integers:`n"
    result .= "  UChar (offset 0): " . NumGet(buf, 0, "UChar") . "`n"
    result .= "  Char (offset 1): " . NumGet(buf, 1, "Char") . "`n`n"

    result .= "16-bit Integers:`n"
    result .= "  UShort (offset 2): " . NumGet(buf, 2, "UShort") . "`n"
    result .= "  Short (offset 4): " . NumGet(buf, 4, "Short") . "`n`n"

    result .= "32-bit Integers:`n"
    result .= "  UInt (offset 6): " . NumGet(buf, 6, "UInt") . "`n"
    result .= "  Int (offset 10): " . NumGet(buf, 10, "Int") . "`n`n"

    result .= "64-bit Integers:`n"
    result .= "  UInt64 (offset 14): " . NumGet(buf, 14, "UInt64") . "`n"
    result .= "  Int64 (offset 22): " . NumGet(buf, 22, "Int64")

    MsgBox(result, "Example 1: Basic Integer Writing", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Chained NumPut Calls
; ================================================================================================

Example2_ChainedNumPut() {
    buf := Buffer(20)

    ; Method 1: Individual calls
    NumPut("Int", 100, buf, 0)
    NumPut("Int", 200, buf, 4)
    NumPut("Int", 300, buf, 8)

    ; Method 2: Chained calls (NumPut returns next address)
    buf2 := Buffer(20)
    addr := NumPut("Int", 100, buf2, 0)
    addr := NumPut("Int", 200, addr)
    addr := NumPut("Int", 300, addr)
    addr := NumPut("Int", 400, addr)
    addr := NumPut("Int", 500, addr)

    ; Read results
    result := "Chained NumPut Examples:`n`n"

    result .= "Method 1 - Individual Calls:`n  "
    loop 3 {
        result .= NumGet(buf, (A_Index - 1) * 4, "Int") . " "
    }

    result .= "`n`nMethod 2 - Chained Calls:`n  "
    loop 5 {
        result .= NumGet(buf2, (A_Index - 1) * 4, "Int") . " "
    }

    result .= "`n`nNote: Chained calls are more efficient!"

    MsgBox(result, "Example 2: Chained NumPut", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Creating Integer Arrays
; ================================================================================================

Example3_IntegerArrays() {
    arraySize := 10
    buf := Buffer(arraySize * 4)

    ; Fill array with sequential values
    loop arraySize {
        NumPut("Int", A_Index * 100, buf, (A_Index - 1) * 4)
    }

    ; Read and process array
    values := []
    sum := 0
    loop arraySize {
        value := NumGet(buf, (A_Index - 1) * 4, "Int")
        values.Push(value)
        sum += value
    }

    ; Modify array - double each value
    loop arraySize {
        current := NumGet(buf, (A_Index - 1) * 4, "Int")
        NumPut("Int", current * 2, buf, (A_Index - 1) * 4)
    }

    ; Read modified values
    modifiedValues := []
    loop arraySize {
        modifiedValues.Push(NumGet(buf, (A_Index - 1) * 4, "Int"))
    }

    ; Display results
    result := "Integer Array Creation:`n`n"
    result .= "Original Values:`n  "
    for value in values {
        result .= value . " "
    }

    result .= "`n`nModified (×2):`n  "
    for value in modifiedValues {
        result .= value . " "
    }

    result .= "`n`nSum: " . sum
    result .= "`nAverage: " . (sum / arraySize)

    MsgBox(result, "Example 3: Integer Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Mixed Type Writing
; ================================================================================================

Example4_MixedTypes() {
    buf := Buffer(14)

    ; Write mixed types
    NumPut("UChar", 200, buf, 0)
    NumPut("Char", -50, buf, 1)
    NumPut("UShort", 50000, buf, 2)
    NumPut("Short", -20000, buf, 4)
    NumPut("UInt", 3000000, buf, 6)
    NumPut("Int", -1500000, buf, 10)

    ; Display memory dump
    result := "Mixed Type Writing:`n`n"
    result .= "Buffer Layout (14 bytes):`n"
    result .= "Offset | Type   | Value`n"
    result .= "-------|--------|-------------`n"
    result .= "0      | UChar  | " . NumGet(buf, 0, "UChar") . "`n"
    result .= "1      | Char   | " . NumGet(buf, 1, "Char") . "`n"
    result .= "2      | UShort | " . NumGet(buf, 2, "UShort") . "`n"
    result .= "4      | Short  | " . NumGet(buf, 4, "Short") . "`n"
    result .= "6      | UInt   | " . NumGet(buf, 6, "UInt") . "`n"
    result .= "10     | Int    | " . NumGet(buf, 10, "Int") . "`n`n"

    result .= "Hex Dump (first 14 bytes):`n  "
    loop 14 {
        result .= Format("{:02X} ", NumGet(buf, A_Index - 1, "UChar"))
    }

    MsgBox(result, "Example 4: Mixed Types", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Data Packing Example
; ================================================================================================

Example5_DataPacking() {
    ; Pack RGB color values (0-255) into buffer
    colorCount := 5
    buf := Buffer(colorCount * 3)

    colors := [{
        r: 255, g: 0, b: 0 },      ; Red
        {
            r: 0, g: 255, b: 0 },      ; Green
        {
            r: 0, g: 0, b: 255 },      ; Blue
        {
            r: 255, g: 255, b: 0 },    ; Yellow
        {
            r: 128, g: 0, b: 128 }     ; Purple
    ]

    ; Pack colors
    loop colorCount {
        offset := (A_Index - 1) * 3
        color := colors[A_Index]
        NumPut("UChar", color.r, buf, offset)
        NumPut("UChar", color.g, buf, offset + 1)
        NumPut("UChar", color.b, buf, offset + 2)
    }

    ; Unpack and display
    result := "Data Packing Example (RGB Colors):`n`n"
    result .= "Packed " . colorCount . " colors into " . buf.Size . " bytes`n`n"

    colorNames := ["Red", "Green", "Blue", "Yellow", "Purple"]
    loop colorCount {
        offset := (A_Index - 1) * 3
        r := NumGet(buf, offset, "UChar")
        g := NumGet(buf, offset + 1, "UChar")
        b := NumGet(buf, offset + 2, "UChar")

        result .= colorNames[A_Index] . ": RGB(" . r . ", " . g . ", " . b . ")`n"
    }

    MsgBox(result, "Example 5: Data Packing", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Building Binary Data Structures
; ================================================================================================

Example6_BinaryStructures() {
    ; Create file header structure
    buf := Buffer(20)

    magic := 0x41484B32  ; "AHK2"
    version := 0x0200     ; v2.0
    flags := 0x0001       ; Compressed
    fileSize := 1048576   ; 1 MB
    dataOffset := 512     ; Data starts at 512

    NumPut("UInt", magic, buf, 0)
    NumPut("UShort", version, buf, 4)
    NumPut("UShort", flags, buf, 6)
    NumPut("UInt", fileSize, buf, 8)
    NumPut("UInt", dataOffset, buf, 12)
    NumPut("UInt", 0, buf, 16)  ; Reserved

    ; Verify written data
    result := "Binary Structure Building:`n`n"
    result .= "File Header (20 bytes):`n`n"

    result .= "Magic: 0x" . Format("{:08X}", NumGet(buf, 0, "UInt"))
    result .= " ('" . Chr(magic & 0xFF) . Chr((magic >> 8) & 0xFF)
        . Chr((magic >> 16) & 0xFF) . Chr((magic >> 24) & 0xFF) . "')`n"

    ver := NumGet(buf, 4, "UShort")
    result .= "Version: 0x" . Format("{:04X}", ver)
        . " (" . (ver >> 8) . "." . (ver & 0xFF) . ")`n"

    result .= "Flags: 0x" . Format("{:04X}", NumGet(buf, 6, "UShort")) . "`n"
    result .= "File Size: " . NumGet(buf, 8, "UInt") . " bytes`n"
    result .= "Data Offset: " . NumGet(buf, 12, "UInt") . " bytes`n"

    MsgBox(result, "Example 6: Binary Structures", "Icon!")
}

; ================================================================================================
; EXAMPLE 7: Safe Writing with Bounds Checking
; ================================================================================================

Example7_BoundsChecking() {
    SafeNumPut(type, value, buf, offset) {
        typeSize := Map(
            "UChar", 1, "Char", 1,
            "UShort", 2, "Short", 2,
            "UInt", 4, "Int", 4,
            "UInt64", 8, "Int64", 8
        )

        if !typeSize.Has(type)
            return { success: false, error: "Unknown type" }

        if offset < 0
            return { success: false, error: "Negative offset" }

        if offset + typeSize[type] > buf.Size
            return { success: false, error: "Buffer overflow" }

        NumPut(type, value, buf, offset)
        return { success: true, address: buf.Ptr + offset + typeSize[type] }
    }

    buf := Buffer(10)

    ; Safe writes
    results := []
    results.Push(SafeNumPut("Int", 100, buf, 0))      ; OK
    results.Push(SafeNumPut("Int", 200, buf, 4))      ; OK
    results.Push(SafeNumPut("Int", 300, buf, 8))      ; Error - overflow
    results.Push(SafeNumPut("Int64", 400, buf, 6))    ; Error - overflow

    ; Display results
    result := "Safe Writing with Bounds Checking:`n`n"
    result .= "Buffer Size: " . buf.Size . " bytes`n`n"

    loop results.Length {
        res := results[A_Index]
        result .= "Write " . A_Index . ": "
        if res.success
            result .= "Success ✓`n"
        else
            result .= "Failed - " . res.error . "`n"
    }

    result .= "`nValues written:`n"
    result .= "  [0]: " . NumGet(buf, 0, "Int") . "`n"
    result .= "  [4]: " . NumGet(buf, 4, "Int")

    MsgBox(result, "Example 7: Bounds Checking", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
                        (
                        NumPut Basic Integer Writing Examples

                        1. Basic Integer Writing (All Types)
                        2. Chained NumPut Calls
                        3. Creating Integer Arrays
                        4. Mixed Type Writing
                        5. Data Packing Example
                        6. Building Binary Data Structures
                        7. Safe Writing with Bounds Checking

                        Select an example (1-7) or press Cancel to exit:
                        )"

    choice := InputBox(menu, "NumPut Basic Examples", "w450 h350")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicIntegerWriting()
        case "2": Example2_ChainedNumPut()
        case "3": Example3_IntegerArrays()
        case "4": Example4_MixedTypes()
        case "5": Example5_DataPacking()
        case "6": Example6_BinaryStructures()
        case "7": Example7_BoundsChecking()
        default: MsgBox("Invalid selection. Please choose 1-7.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
