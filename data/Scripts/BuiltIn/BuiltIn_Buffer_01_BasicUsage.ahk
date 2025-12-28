#Requires AutoHotkey v2.0

/**
 * BuiltIn_Buffer_01_BasicUsage.ahk
 * 
 * DESCRIPTION:
 * Demonstrates fundamental Buffer object creation, sizing, and basic operations.
 * Shows how to allocate raw memory blocks and access them safely in AutoHotkey v2.
 * 
 * FEATURES:
 * - Buffer object creation with various sizes
 * - Memory initialization and zeroing
 * - Pointer access and manipulation
 * - Size property usage
 * - Dynamic buffer resizing patterns
 * - Memory safety best practices
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Buffer Object
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Buffer() constructor for memory allocation
 * - Ptr property for pointer access
 * - Size property for buffer dimensions
 * - Automatic memory management (garbage collection)
 * - Type-safe pointer operations
 * 
 * LEARNING POINTS:
 * 1. Buffer objects provide safe memory allocation without manual cleanup
 * 2. All Buffer memory is zero-initialized by default
 * 3. Ptr property returns the memory address for DllCall and NumPut/NumGet
 * 4. Size property is read-only; create new Buffer for different sizes
 * 5. Buffers are automatically freed when no longer referenced
 */

; ================================================================================================
; EXAMPLE 1: Basic Buffer Creation and Properties
; ================================================================================================
; Demonstrates creating buffers of various sizes and accessing their properties

Example1_BasicCreation() {
    ; Create a small 16-byte buffer
    smallBuffer := Buffer(16)

    ; Create a medium 1KB buffer
    mediumBuffer := Buffer(1024)

    ; Create a large 1MB buffer
    largeBuffer := Buffer(1024 * 1024)

    ; Display buffer properties
    result := ""
    result .= "Small Buffer (16 bytes):`n"
    result .= "  Size: " . smallBuffer.Size . " bytes`n"
    result .= "  Pointer: 0x" . Format("{:X}", smallBuffer.Ptr) . "`n`n"

    result .= "Medium Buffer (1KB):`n"
    result .= "  Size: " . mediumBuffer.Size . " bytes`n"
    result .= "  Pointer: 0x" . Format("{:X}", mediumBuffer.Ptr) . "`n`n"

    result .= "Large Buffer (1MB):`n"
    result .= "  Size: " . largeBuffer.Size . " bytes`n"
    result .= "  Pointer: 0x" . Format("{:X}", largeBuffer.Ptr) . "`n`n"

    ; Verify buffers are zero-initialized
    isZeroInitialized := true
    loop 16 {
        if NumGet(smallBuffer, A_Index - 1, "UChar") != 0 {
            isZeroInitialized := false
            break
        }
    }

    result .= "All buffers are zero-initialized: " . (isZeroInitialized ? "Yes" : "No")

    MsgBox(result, "Example 1: Basic Buffer Creation", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Buffer Size Calculations
; ================================================================================================
; Shows how to calculate required buffer sizes for different data types

Example2_SizeCalculations() {
    ; Calculate sizes for common data types
    sizeChar := 1       ; UChar, Char
    sizeShort := 2      ; Short, UShort
    sizeInt := 4        ; Int, UInt
    sizeInt64 := 8      ; Int64, UInt64
    sizeFloat := 4      ; Float
    sizeDouble := 8     ; Double
    sizePtr := A_PtrSize ; Pointer (4 on 32-bit, 8 on 64-bit)

    ; Create a buffer to hold a complex structure:
    ; struct Person {
    ;     int age;           // 4 bytes
    ;     double height;     // 8 bytes
    ;     int64 id;          // 8 bytes
    ;     char name[32];     // 32 bytes
    ; }

    structSize := 4 + 8 + 8 + 32  ; Total: 52 bytes
    personBuffer := Buffer(structSize)

    ; Create buffer for an array of 10 integers
    intArraySize := 10 * sizeInt  ; 10 * 4 = 40 bytes
    intArrayBuffer := Buffer(intArraySize)

    ; Create buffer for 100 double values
    doubleArraySize := 100 * sizeDouble  ; 100 * 8 = 800 bytes
    doubleArrayBuffer := Buffer(doubleArraySize)

    ; Display size calculations
    result := "Data Type Sizes:`n"
    result .= "  Char/UChar: " . sizeChar . " byte`n"
    result .= "  Short/UShort: " . sizeShort . " bytes`n"
    result .= "  Int/UInt: " . sizeInt . " bytes`n"
    result .= "  Int64/UInt64: " . sizeInt64 . " bytes`n"
    result .= "  Float: " . sizeFloat . " bytes`n"
    result .= "  Double: " . sizeDouble . " bytes`n"
    result .= "  Pointer: " . sizePtr . " bytes (platform-dependent)`n`n"

    result .= "Structure Sizes:`n"
    result .= "  Person struct: " . personBuffer.Size . " bytes`n"
    result .= "  10 integers: " . intArrayBuffer.Size . " bytes`n"
    result .= "  100 doubles: " . doubleArrayBuffer.Size . " bytes`n"

    MsgBox(result, "Example 2: Buffer Size Calculations", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Memory Initialization Patterns
; ================================================================================================
; Demonstrates different ways to initialize buffer memory

Example3_Initialization() {
    ; Create a 100-byte buffer
    buf := Buffer(100)

    ; Pattern 1: Zero initialization (automatic)
    ; Buffer is already zeroed, but we can verify
    firstTenBytes := ""
    loop 10 {
        value := NumGet(buf, A_Index - 1, "UChar")
        firstTenBytes .= value . " "
    }

    ; Pattern 2: Fill with a specific byte value (0xFF)
    loop 50 {
        NumPut("UChar", 0xFF, buf, A_Index - 1)
    }

    ; Pattern 3: Fill with a pattern (alternating 0xAA, 0x55)
    loop 25 {
        offset := 50 + (A_Index - 1) * 2
        NumPut("UChar", 0xAA, buf, offset)
        NumPut("UChar", 0x55, buf, offset + 1)
    }

    ; Read back and display the patterns
    result := "Memory Initialization Patterns:`n`n"
    result .= "Bytes 0-9 (zero-initialized): " . firstTenBytes . "`n`n"

    result .= "Bytes 0-49 (filled with 0xFF):`n  "
    loop 10 {
        value := NumGet(buf, A_Index - 1, "UChar")
        result .= Format("{:02X} ", value)
    }
    result .= "...`n`n"

    result .= "Bytes 50-59 (alternating pattern):`n  "
    loop 10 {
        value := NumGet(buf, 50 + A_Index - 1, "UChar")
        result .= Format("{:02X} ", value)
    }

    MsgBox(result, "Example 3: Memory Initialization", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Working with Buffer Pointers
; ================================================================================================
; Shows how to use Buffer.Ptr for various operations

Example4_PointerOperations() {
    ; Create a buffer for storing integers
    buf := Buffer(20)  ; 5 integers * 4 bytes

    ; Store some values using the pointer
    NumPut("Int", 100, buf, 0)
    NumPut("Int", 200, buf, 4)
    NumPut("Int", 300, buf, 8)
    NumPut("Int", 400, buf, 12)
    NumPut("Int", 500, buf, 16)

    ; Get the buffer pointer
    pBuffer := buf.Ptr

    ; Read values back using pointer arithmetic
    values := []
    loop 5 {
        offset := (A_Index - 1) * 4
        value := NumGet(pBuffer + offset, "Int")
        values.Push(value)
    }

    ; Demonstrate pointer safety - creating a copy
    copyBuffer := Buffer(buf.Size)

    ; Use DllCall to copy memory (RtlMoveMemory)
    DllCall("RtlMoveMemory"
        , "Ptr", copyBuffer.Ptr
        , "Ptr", buf.Ptr
        , "UPtr", buf.Size)

    ; Verify the copy
    copyValues := []
    loop 5 {
        offset := (A_Index - 1) * 4
        value := NumGet(copyBuffer, offset, "Int")
        copyValues.Push(value)
    }

    ; Display results
    result := "Original Buffer:`n"
    result .= "  Pointer: 0x" . Format("{:X}", buf.Ptr) . "`n"
    result .= "  Values: "
    for value in values
        result .= value . " "
    result .= "`n`n"

    result .= "Copied Buffer:`n"
    result .= "  Pointer: 0x" . Format("{:X}", copyBuffer.Ptr) . "`n"
    result .= "  Values: "
    for value in copyValues
        result .= value . " "

    MsgBox(result, "Example 4: Pointer Operations", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Buffer Lifetime and Scope Management
; ================================================================================================
; Demonstrates buffer lifetime, scope, and automatic memory management

Example5_LifetimeManagement() {
    global resultText := ""

    ; Function that creates and returns a buffer
    CreateBuffer(size) {
        buf := Buffer(size)
        NumPut("Int", 12345, buf, 0)
        return buf  ; Buffer survives beyond function scope
    }

    ; Function that demonstrates local buffer
    UseLocalBuffer() {
        localBuf := Buffer(100)
        NumPut("Int", 99999, localBuf, 0)
        value := NumGet(localBuf, 0, "Int")
        return value  ; Returns value, but buffer will be freed
    }

    ; Create a buffer that persists
    persistentBuf := CreateBuffer(16)
    value1 := NumGet(persistentBuf, 0, "Int")

    ; Use a local buffer (will be freed after function returns)
    value2 := UseLocalBuffer()

    ; Store buffer in an object to extend lifetime
    container := {
        data: Buffer(32),
        size: 32
    }
    NumPut("Int", 54321, container.data, 0)
    value3 := NumGet(container.data, 0, "Int")

    ; Create an array of buffers
    bufferArray := []
    loop 5 {
        buf := Buffer(8)
        NumPut("Int", A_Index * 1000, buf, 0)
        bufferArray.Push(buf)  ; Buffers stay alive in array
    }

    ; Read values from buffer array
    arrayValues := ""
    for index, buf in bufferArray {
        value := NumGet(buf, 0, "Int")
        arrayValues .= value . " "
    }

    ; Display results
    result := "Buffer Lifetime Management:`n`n"
    result .= "Persistent buffer value: " . value1 . "`n"
    result .= "Local buffer returned value: " . value2 . "`n"
    result .= "Object-contained buffer value: " . value3 . "`n`n"
    result .= "Buffer array values: " . arrayValues . "`n`n"
    result .= "All buffers are automatically managed - no manual cleanup needed!"

    MsgBox(result, "Example 5: Lifetime Management", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Buffer Comparison and Verification
; ================================================================================================
; Shows techniques for comparing and verifying buffer contents

Example6_BufferComparison() {
    ; Create two identical buffers
    buf1 := Buffer(20)
    buf2 := Buffer(20)

    ; Fill with same data
    loop 5 {
        offset := (A_Index - 1) * 4
        NumPut("Int", A_Index * 100, buf1, offset)
        NumPut("Int", A_Index * 100, buf2, offset)
    }

    ; Create a different buffer
    buf3 := Buffer(20)
    loop 5 {
        offset := (A_Index - 1) * 4
        NumPut("Int", A_Index * 200, buf3, offset)  ; Different values
    }

    ; Function to compare two buffers
    CompareBuffers(b1, b2) {
        if b1.Size != b2.Size
            return false

        loop b1.Size {
            if NumGet(b1, A_Index - 1, "UChar") != NumGet(b2, A_Index - 1, "UChar")
                return false
        }
        return true
    }

    ; Function to calculate buffer checksum
    CalculateChecksum(buf) {
        checksum := 0
        loop buf.Size {
            checksum += NumGet(buf, A_Index - 1, "UChar")
        }
        return checksum & 0xFFFFFFFF  ; 32-bit checksum
    }

    ; Perform comparisons
    identical := CompareBuffers(buf1, buf2)
    different := !CompareBuffers(buf1, buf3)

    ; Calculate checksums
    checksum1 := CalculateChecksum(buf1)
    checksum2 := CalculateChecksum(buf2)
    checksum3 := CalculateChecksum(buf3)

    ; Display results
    result := "Buffer Comparison Results:`n`n"
    result .= "buf1 == buf2: " . (identical ? "True" : "False") . "`n"
    result .= "buf1 != buf3: " . (different ? "True" : "False") . "`n`n"
    result .= "Checksums:`n"
    result .= "  buf1: 0x" . Format("{:08X}", checksum1) . "`n"
    result .= "  buf2: 0x" . Format("{:08X}", checksum2) . "`n"
    result .= "  buf3: 0x" . Format("{:08X}", checksum3) . "`n`n"
    result .= "buf1 and buf2 checksums match: " . (checksum1 = checksum2 ? "Yes" : "No")

    MsgBox(result, "Example 6: Buffer Comparison", "Icon!")
}

; ================================================================================================
; EXAMPLE 7: Practical Buffer Usage - Binary Data Handler
; ================================================================================================
; A comprehensive example showing buffer usage in a real-world scenario

Example7_PracticalUsage() {
    ; Binary data handler class using buffers

    ; Create handler and write data
    handler := BinaryDataHandler(64)

    handler.WriteInt(42)
    handler.WriteDouble(3.14159)
    handler.WriteString("Hello, Buffer!")
    handler.WriteInt(2024)
    handler.WriteDouble(2.71828)
    handler.WriteString("AutoHotkey v2")

    ; Get statistics
    stats := handler.GetStats()

    ; Get final data
    finalData := handler.GetData()

    ; Display results
    result := "Binary Data Handler Example:`n`n"
    result .= "Operations performed:`n"
    result .= "  - WriteInt(42)`n"
    result .= "  - WriteDouble(3.14159)`n"
    result .= '  - WriteString("Hello, Buffer!")`n'
    result .= "  - WriteInt(2024)`n"
    result .= "  - WriteDouble(2.71828)`n"
    result .= '  - WriteString("AutoHotkey v2")`n`n'

    result .= "Buffer Statistics:`n"
    result .= "  Used: " . stats.UsedBytes . " bytes`n"
    result .= "  Capacity: " . stats.Capacity . " bytes`n"
    result .= "  Utilization: " . stats.Utilization . "%`n`n"

    result .= "Final data size: " . finalData.Size . " bytes"

    MsgBox(result, "Example 7: Practical Usage", "Icon!")
}

; ================================================================================================
; Main Menu to Run Examples
; ================================================================================================

ShowMenu() {
    menu := "
        (
        Buffer Basic Usage Examples

        1. Basic Buffer Creation and Properties
        2. Buffer Size Calculations
        3. Memory Initialization Patterns
        4. Working with Buffer Pointers
        5. Buffer Lifetime and Scope Management
        6. Buffer Comparison and Verification
        7. Practical Usage - Binary Data Handler

        Select an example (1-7) or press Cancel to exit:
        )"

    choice := InputBox(menu, "Buffer Basic Usage Examples", "w400 h350")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicCreation()
        case "2": Example2_SizeCalculations()
        case "3": Example3_Initialization()
        case "4": Example4_PointerOperations()
        case "5": Example5_LifetimeManagement()
        case "6": Example6_BufferComparison()
        case "7": Example7_PracticalUsage()
        default: MsgBox("Invalid selection. Please choose 1-7.", "Error", "Icon!")
    }

    ; Show menu again
    SetTimer(() => ShowMenu(), -100)
}

; Start the menu
ShowMenu()

; Moved class BinaryDataHandler from nested scope
class BinaryDataHandler {
    __New(initialSize := 1024) {
        this.buffer := Buffer(initialSize)
        this.position := 0
        this.capacity := initialSize
    }

    ; Write an integer
    WriteInt(value) {
        this.EnsureCapacity(4)
        NumPut("Int", value, this.buffer, this.position)
        this.position += 4
    }

    ; Write a double
    WriteDouble(value) {
        this.EnsureCapacity(8)
        NumPut("Double", value, this.buffer, this.position)
        this.position += 8
    }

    ; Write a string (with length prefix)
    WriteString(str) {
        strLen := StrLen(str)
        bytesNeeded := 4 + (strLen * 2)  ; Length + UTF-16 chars
        this.EnsureCapacity(bytesNeeded)

        NumPut("Int", strLen, this.buffer, this.position)
        this.position += 4

        StrPut(str, this.buffer.Ptr + this.position, strLen, "UTF-16")
        this.position += strLen * 2
    }

    ; Ensure buffer has enough capacity
    EnsureCapacity(bytesNeeded) {
        if this.position + bytesNeeded > this.capacity {
            ; Need to grow - create new larger buffer
            newCapacity := Max(this.capacity * 2, this.position + bytesNeeded)
            newBuffer := Buffer(newCapacity)

            ; Copy existing data
            DllCall("RtlMoveMemory"
                , "Ptr", newBuffer.Ptr
                , "Ptr", this.buffer.Ptr
                , "UPtr", this.position)

            this.buffer := newBuffer
            this.capacity := newCapacity
        }
    }

    ; Get the used portion of the buffer
    GetData() {
        if this.position = 0
            return Buffer(0)

        result := Buffer(this.position)
        DllCall("RtlMoveMemory"
            , "Ptr", result.Ptr
            , "Ptr", this.buffer.Ptr
            , "UPtr", this.position)
        return result
    }

    ; Get statistics
    GetStats() {
        return {
            UsedBytes: this.position,
            Capacity: this.capacity,
            Utilization: Round((this.position / this.capacity) * 100, 2)
        }
    }
}
