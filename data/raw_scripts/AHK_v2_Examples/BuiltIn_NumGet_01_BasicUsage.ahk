#Requires AutoHotkey v2.0
/**
 * BuiltIn_NumGet_01_BasicUsage.ahk
 *
 * DESCRIPTION:
 * Demonstrates fundamental NumGet usage for reading integer values from binary data.
 * Covers all integer types and basic memory reading patterns.
 *
 * FEATURES:
 * - Reading signed and unsigned integers
 * - Understanding type sizes (Char, Short, Int, Int64)
 * - Offset calculations for sequential reads
 * - Endianness considerations
 * - Type safety and overflow handling
 * - Practical integer data extraction
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - NumGet Function
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - NumGet(buffer, offset, type) syntax
 * - Type specifiers: UChar, Char, UShort, Short, UInt, Int, UInt64, Int64
 * - Automatic pointer arithmetic
 * - Buffer integration with NumGet
 * - Zero-based offset indexing
 *
 * LEARNING POINTS:
 * 1. NumGet reads numeric values from binary data at specified offsets
 * 2. Type parameter determines how many bytes to read and interpretation
 * 3. Offset is in bytes, zero-indexed from buffer start
 * 4. Signed types can represent negative numbers using two's complement
 * 5. Always ensure offset + type_size <= buffer size to avoid access violations
 */

; ================================================================================================
; EXAMPLE 1: Basic Integer Reading
; ================================================================================================
; Demonstrates reading different integer types from a buffer

Example1_BasicIntegerReading() {
    ; Create buffer and write test values
    buf := Buffer(32)

    ; Write test values using NumPut
    NumPut("UChar", 255, buf, 0)           ; Max unsigned byte
    NumPut("Char", -128, buf, 1)           ; Min signed byte
    NumPut("UShort", 65535, buf, 2)        ; Max unsigned short
    NumPut("Short", -32768, buf, 4)        ; Min signed short
    NumPut("UInt", 4294967295, buf, 6)     ; Max unsigned int
    NumPut("Int", -2147483648, buf, 10)    ; Min signed int
    NumPut("UInt64", 0xFFFFFFFFFFFFFFFF, buf, 14)  ; Max unsigned int64
    NumPut("Int64", -9223372036854775808, buf, 22) ; Min signed int64

    ; Read values back using NumGet
    ucharValue := NumGet(buf, 0, "UChar")
    charValue := NumGet(buf, 1, "Char")
    ushortValue := NumGet(buf, 2, "UShort")
    shortValue := NumGet(buf, 4, "Short")
    uintValue := NumGet(buf, 6, "UInt")
    intValue := NumGet(buf, 10, "Int")
    uint64Value := NumGet(buf, 14, "UInt64")
    int64Value := NumGet(buf, 22, "Int64")

    ; Display results
    result := "Basic Integer Reading Examples:`n`n"

    result .= "8-bit Integers (1 byte):`n"
    result .= "  UChar (offset 0): " . ucharValue . " (max: 255)`n"
    result .= "  Char (offset 1): " . charValue . " (min: -128)`n`n"

    result .= "16-bit Integers (2 bytes):`n"
    result .= "  UShort (offset 2): " . ushortValue . " (max: 65535)`n"
    result .= "  Short (offset 4): " . shortValue . " (min: -32768)`n`n"

    result .= "32-bit Integers (4 bytes):`n"
    result .= "  UInt (offset 6): " . uintValue . " (max: 4294967295)`n"
    result .= "  Int (offset 10): " . intValue . " (min: -2147483648)`n`n"

    result .= "64-bit Integers (8 bytes):`n"
    result .= "  UInt64 (offset 14): " . uint64Value . "`n"
    result .= "  Int64 (offset 22): " . int64Value

    MsgBox(result, "Example 1: Basic Integer Reading", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Sequential Data Reading
; ================================================================================================
; Shows how to read multiple values sequentially with offset calculation

Example2_SequentialReading() {
    ; Create a buffer with sequential integer data
    buf := Buffer(40)

    ; Write 10 integers
    loop 10 {
        NumPut("Int", A_Index * 100, buf, (A_Index - 1) * 4)
    }

    ; Method 1: Manual offset calculation
    values1 := []
    loop 10 {
        offset := (A_Index - 1) * 4
        value := NumGet(buf, offset, "Int")
        values1.Push(value)
    }

    ; Method 2: Using running offset
    values2 := []
    offset := 0
    loop 10 {
        value := NumGet(buf, offset, "Int")
        values2.Push(value)
        offset += 4  ; Move to next integer
    }

    ; Method 3: Reading specific positions
    first := NumGet(buf, 0, "Int")
    middle := NumGet(buf, 20, "Int")  ; 5th element (index 4 * 4 bytes)
    last := NumGet(buf, 36, "Int")    ; 10th element (index 9 * 4 bytes)

    ; Display results
    result := "Sequential Data Reading:`n`n"

    result .= "Method 1 - Manual offset calculation:`n  "
    for value in values1 {
        result .= value . " "
    }

    result .= "`n`nMethod 2 - Running offset:`n  "
    for value in values2 {
        result .= value . " "
    }

    result .= "`n`nMethod 3 - Specific positions:`n"
    result .= "  First (offset 0): " . first . "`n"
    result .= "  Middle (offset 20): " . middle . "`n"
    result .= "  Last (offset 36): " . last

    MsgBox(result, "Example 2: Sequential Reading", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Mixed Type Reading
; ================================================================================================
; Demonstrates reading different types from the same buffer

Example3_MixedTypeReading() {
    ; Create a buffer with mixed data types
    ; Layout: [UChar][Char][UShort][Short][UInt][Int]
    ; Sizes:  [1]    [1]   [2]     [2]    [4]   [4]  = 14 bytes

    buf := Buffer(14)

    ; Write values
    NumPut("UChar", 200, buf, 0)
    NumPut("Char", -50, buf, 1)
    NumPut("UShort", 50000, buf, 2)
    NumPut("Short", -20000, buf, 4)
    NumPut("UInt", 3000000, buf, 6)
    NumPut("Int", -1500000, buf, 10)

    ; Calculate offsets
    offsets := Map(
        "UChar", 0,
        "Char", 1,
        "UShort", 2,
        "Short", 4,
        "UInt", 6,
        "Int", 10
    )

    sizes := Map(
        "UChar", 1,
        "Char", 1,
        "UShort", 2,
        "Short", 2,
        "UInt", 4,
        "Int", 4
    )

    ; Read back all values
    results := Map()
    results["UChar"] := NumGet(buf, offsets["UChar"], "UChar")
    results["Char"] := NumGet(buf, offsets["Char"], "Char")
    results["UShort"] := NumGet(buf, offsets["UShort"], "UShort")
    results["Short"] := NumGet(buf, offsets["Short"], "Short")
    results["UInt"] := NumGet(buf, offsets["UInt"], "UInt")
    results["Int"] := NumGet(buf, offsets["Int"], "Int")

    ; Display results with memory layout
    result := "Mixed Type Reading Example:`n`n"
    result .= "Buffer Layout (14 bytes):`n"
    result .= "  Offset | Type   | Size | Value`n"
    result .= "  -------|--------|------|-------------`n"

    for typeName, offset in offsets {
        result .= "  " . Format("{:6}", offset)
        result .= " | " . Format("{:6}", typeName)
        result .= " | " . Format("{:4}", sizes[typeName])
        result .= " | " . results[typeName] . "`n"
    }

    result .= "`nTotal buffer size: " . buf.Size . " bytes"

    MsgBox(result, "Example 3: Mixed Type Reading", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Integer Array Processing
; ================================================================================================
; Shows practical array reading and processing

Example4_ArrayProcessing() {
    ; Create array of integers representing sensor readings
    sensorCount := 20
    buf := Buffer(sensorCount * 4)

    ; Simulate sensor data (temperatures in Celsius * 10)
    sensorData := [215, 223, 218, 230, 225, 220, 228, 232, 227, 224,
                   226, 229, 231, 228, 225, 223, 221, 219, 222, 224]

    ; Write sensor data
    loop sensorCount {
        NumPut("Int", sensorData[A_Index], buf, (A_Index - 1) * 4)
    }

    ; Process array: find min, max, average
    min := 999999
    max := -999999
    sum := 0

    loop sensorCount {
        value := NumGet(buf, (A_Index - 1) * 4, "Int")
        sum += value

        if value < min
            min := value
        if value > max
            max := value
    }

    average := sum / sensorCount

    ; Find readings above average
    aboveAverage := []
    loop sensorCount {
        value := NumGet(buf, (A_Index - 1) * 4, "Int")
        if value > average
            aboveAverage.Push({index: A_Index, value: value})
    }

    ; Find consecutive increases
    increases := []
    loop sensorCount - 1 {
        current := NumGet(buf, (A_Index - 1) * 4, "Int")
        next := NumGet(buf, A_Index * 4, "Int")
        if next > current
            increases.Push(A_Index)
    }

    ; Display results
    result := "Integer Array Processing:`n`n"
    result .= "Sensor Count: " . sensorCount . " readings`n"
    result .= "Data Type: Int (4 bytes each)`n"
    result .= "Buffer Size: " . buf.Size . " bytes`n`n"

    result .= "Statistics (temperatures in °C * 10):`n"
    result .= "  Minimum: " . Format("{:.1f}", min / 10) . "°C`n"
    result .= "  Maximum: " . Format("{:.1f}", max / 10) . "°C`n"
    result .= "  Average: " . Format("{:.1f}", average / 10) . "°C`n"
    result .= "  Range: " . Format("{:.1f}", (max - min) / 10) . "°C`n`n"

    result .= "Above Average: " . aboveAverage.Length . " readings`n"
    result .= "Consecutive Increases: " . increases.Length . " times"

    MsgBox(result, "Example 4: Array Processing", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Signed vs Unsigned Interpretation
; ================================================================================================
; Demonstrates the difference between signed and unsigned reads

Example5_SignedVsUnsigned() {
    ; Create buffer with bytes that have different signed/unsigned interpretations
    buf := Buffer(16)

    ; Write values that differ when interpreted as signed vs unsigned
    NumPut("UChar", 255, buf, 0)   ; 255 unsigned, -1 signed
    NumPut("UChar", 200, buf, 1)   ; 200 unsigned, -56 signed
    NumPut("UChar", 128, buf, 2)   ; 128 unsigned, -128 signed
    NumPut("UChar", 127, buf, 3)   ; 127 both (max positive signed)

    NumPut("UShort", 65535, buf, 4)  ; 65535 unsigned, -1 signed
    NumPut("UShort", 40000, buf, 6)  ; 40000 unsigned, -25536 signed
    NumPut("UShort", 32768, buf, 8)  ; 32768 unsigned, -32768 signed

    NumPut("UInt", 4294967295, buf, 10)  ; Max uint, -1 signed
    NumPut("UInt", 3000000000, buf, 14)  ; Different interpretations

    ; Read as unsigned
    result := "Signed vs Unsigned Interpretation:`n`n"
    result .= "8-bit Values:`n"
    result .= "  Offset 0:`n"
    result .= "    As UChar: " . NumGet(buf, 0, "UChar") . "`n"
    result .= "    As Char: " . NumGet(buf, 0, "Char") . "`n"

    result .= "  Offset 1:`n"
    result .= "    As UChar: " . NumGet(buf, 1, "UChar") . "`n"
    result .= "    As Char: " . NumGet(buf, 1, "Char") . "`n"

    result .= "`n16-bit Values:`n"
    result .= "  Offset 4:`n"
    result .= "    As UShort: " . NumGet(buf, 4, "UShort") . "`n"
    result .= "    As Short: " . NumGet(buf, 4, "Short") . "`n"

    result .= "  Offset 6:`n"
    result .= "    As UShort: " . NumGet(buf, 6, "UShort") . "`n"
    result .= "    As Short: " . NumGet(buf, 6, "Short") . "`n"

    result .= "`n32-bit Values:`n"
    result .= "  Offset 10:`n"
    result .= "    As UInt: " . NumGet(buf, 10, "UInt") . "`n"
    result .= "    As Int: " . NumGet(buf, 10, "Int") . "`n"

    result .= "  Offset 14:`n"
    result .= "    As UInt: " . NumGet(buf, 14, "UInt") . "`n"
    result .= "    As Int: " . NumGet(buf, 14, "Int") . "`n"

    result .= "`nKey Point: Same bytes, different interpretation!"

    MsgBox(result, "Example 5: Signed vs Unsigned", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Practical Data Extraction
; ================================================================================================
; Real-world example: reading a simple binary file header

Example6_BinaryHeader() {
    ; Simulate a binary file header structure:
    ; [4 bytes] Magic number (0x44484B41 = "AHKD")
    ; [2 bytes] Version (major.minor as UShort)
    ; [2 bytes] Flags (bitfield)
    ; [4 bytes] File size
    ; [4 bytes] Data offset
    ; [4 bytes] Record count
    ; Total: 20 bytes

    buf := Buffer(20)

    ; Write header
    NumPut("UInt", 0x44484B41, buf, 0)      ; Magic "AHKD"
    NumPut("UShort", 0x0201, buf, 4)        ; Version 2.1 (0x02 major, 0x01 minor)
    NumPut("UShort", 0x0005, buf, 6)        ; Flags: 0b0101 = compressed + encrypted
    NumPut("UInt", 1048576, buf, 8)         ; File size: 1 MB
    NumPut("UInt", 1024, buf, 12)           ; Data offset: 1 KB
    NumPut("UInt", 5000, buf, 16)           ; Record count: 5000

    ; Read and parse header
    magic := NumGet(buf, 0, "UInt")
    version := NumGet(buf, 4, "UShort")
    flags := NumGet(buf, 6, "UShort")
    fileSize := NumGet(buf, 8, "UInt")
    dataOffset := NumGet(buf, 12, "UInt")
    recordCount := NumGet(buf, 16, "UInt")

    ; Parse version
    versionMajor := (version >> 8) & 0xFF
    versionMinor := version & 0xFF

    ; Parse flags
    isCompressed := (flags & 0x01) != 0
    isEncrypted := (flags & 0x04) != 0

    ; Convert magic to string
    magicStr := Chr(magic & 0xFF)
        . Chr((magic >> 8) & 0xFF)
        . Chr((magic >> 16) & 0xFF)
        . Chr((magic >> 24) & 0xFF)

    ; Display results
    result := "Binary File Header Parsing:`n`n"
    result .= "Header Structure (20 bytes):`n`n"

    result .= "Magic Number:`n"
    result .= "  Hex: 0x" . Format("{:08X}", magic) . "`n"
    result .= "  ASCII: '" . magicStr . "'`n`n"

    result .= "Version:`n"
    result .= "  Raw: 0x" . Format("{:04X}", version) . "`n"
    result .= "  Parsed: " . versionMajor . "." . versionMinor . "`n`n"

    result .= "Flags:`n"
    result .= "  Raw: 0x" . Format("{:04X}", flags) . "`n"
    result .= "  Compressed: " . (isCompressed ? "Yes" : "No") . "`n"
    result .= "  Encrypted: " . (isEncrypted ? "Yes" : "No") . "`n`n"

    result .= "File Information:`n"
    result .= "  Size: " . Format("{:,}", fileSize) . " bytes ("
        . Round(fileSize / 1024 / 1024, 2) . " MB)`n"
    result .= "  Data Offset: " . dataOffset . " bytes`n"
    result .= "  Record Count: " . Format("{:,}", recordCount)

    MsgBox(result, "Example 6: Binary Header Parsing", "Icon!")
}

; ================================================================================================
; EXAMPLE 7: Endianness Handling
; ================================================================================================
; Shows how to handle different byte orders (little-endian vs big-endian)

Example7_Endianness() {
    ; Create buffer with a known value
    buf := Buffer(8)

    ; Write value 0x12345678 (305419896 decimal)
    NumPut("UInt", 0x12345678, buf, 0)

    ; Read as normal (little-endian on x86/x64)
    normalRead := NumGet(buf, 0, "UInt")

    ; Read individual bytes to show byte order
    byte0 := NumGet(buf, 0, "UChar")
    byte1 := NumGet(buf, 1, "UChar")
    byte2 := NumGet(buf, 2, "UChar")
    byte3 := NumGet(buf, 3, "UChar")

    ; Function to swap endianness for 32-bit integer
    SwapEndian32(value) {
        return ((value & 0xFF) << 24)
            | ((value & 0xFF00) << 8)
            | ((value & 0xFF0000) >> 8)
            | ((value >> 24) & 0xFF)
    }

    ; Simulate big-endian read
    bigEndianValue := SwapEndian32(normalRead)

    ; Write in big-endian format
    NumPut("UChar", 0x12, buf, 4)
    NumPut("UChar", 0x34, buf, 5)
    NumPut("UChar", 0x56, buf, 6)
    NumPut("UChar", 0x78, buf, 7)

    ; Read as if it were little-endian (will be wrong)
    wrongRead := NumGet(buf, 4, "UInt")

    ; Display results
    result := "Endianness Handling:`n`n"

    result .= "Original Value: 0x12345678 (" . normalRead . ")`n`n"

    result .= "Little-Endian Storage (x86/x64):`n"
    result .= "  Byte 0: 0x" . Format("{:02X}", byte0) . " (0x78)`n"
    result .= "  Byte 1: 0x" . Format("{:02X}", byte1) . " (0x56)`n"
    result .= "  Byte 2: 0x" . Format("{:02X}", byte2) . " (0x34)`n"
    result .= "  Byte 3: 0x" . Format("{:02X}", byte3) . " (0x12)`n"
    result .= "  Note: Least significant byte first!`n`n"

    result .= "Big-Endian Conversion:`n"
    result .= "  Swapped: 0x" . Format("{:08X}", bigEndianValue) . "`n`n"

    result .= "Reading Big-Endian Data:`n"
    result .= "  Manual bytes: 0x12 0x34 0x56 0x78`n"
    result .= "  Direct read: 0x" . Format("{:08X}", wrongRead) . " (wrong!)`n"
    result .= "  Must swap bytes for correct interpretation"

    MsgBox(result, "Example 7: Endianness", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    NumGet Basic Integer Reading Examples

    1. Basic Integer Reading (All Types)
    2. Sequential Data Reading
    3. Mixed Type Reading
    4. Integer Array Processing
    5. Signed vs Unsigned Interpretation
    6. Practical Binary Header Parsing
    7. Endianness Handling

    Select an example (1-7) or press Cancel to exit:
    )"

    choice := InputBox(menu, "NumGet Basic Examples", "w450 h350")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicIntegerReading()
        case "2": Example2_SequentialReading()
        case "3": Example3_MixedTypeReading()
        case "4": Example4_ArrayProcessing()
        case "5": Example5_SignedVsUnsigned()
        case "6": Example6_BinaryHeader()
        case "7": Example7_Endianness()
        default: MsgBox("Invalid selection. Please choose 1-7.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
