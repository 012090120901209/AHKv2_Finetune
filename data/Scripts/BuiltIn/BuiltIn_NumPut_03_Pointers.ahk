#Requires AutoHotkey v2.0

/**
* BuiltIn_NumPut_03_Pointers.ahk
*
* DESCRIPTION:
* Advanced NumPut usage for writing pointer values to buffers.
* Covers pointer storage, indirection, and pointer-based data structures.
*
* FEATURES:
* - Writing pointer values to buffers
* - Creating pointer arrays
* - Building linked structures
* - Platform-aware pointer handling
* - Function pointer tables
* - Practical pointer manipulation
*
* SOURCE:
* AutoHotkey v2 Documentation - NumPut, Pointers
*
* KEY V2 FEATURES DEMONSTRATED:
* - NumPut with "Ptr" type (platform-dependent size)
* - NumPut with "UPtr" type (unsigned pointer)
* - A_PtrSize for cross-platform compatibility
* - Building pointer chains
* - Pointer validation
*
* LEARNING POINTS:
* 1. Ptr type is 4 bytes on 32-bit, 8 bytes on 64-bit
* 2. NumPut stores memory addresses, not values
* 3. Pointer arrays enable indirect data access
* 4. Null pointers (0) can be written safely
* 5. Pointer chains enable complex data structures
*/

; ================================================================================================
; EXAMPLE 1: Basic Pointer Writing
; ================================================================================================

Example1_BasicPointerWriting() {
    ; Create data buffers
    data1 := Buffer(4)
    data2 := Buffer(4)
    data3 := Buffer(4)

    NumPut("Int", 100, data1, 0)
    NumPut("Int", 200, data2, 0)
    NumPut("Int", 300, data3, 0)

    ; Create pointer buffer
    ptrBuf := Buffer(A_PtrSize * 3)

    ; Write pointers
    NumPut("Ptr", data1.Ptr, ptrBuf, 0)
    NumPut("Ptr", data2.Ptr, ptrBuf, A_PtrSize)
    NumPut("Ptr", data3.Ptr, ptrBuf, A_PtrSize * 2)

    ; Read and dereference
    result := "Basic Pointer Writing:`n`n"
    result .= "Platform: " . (A_PtrSize = 8 ? "64-bit" : "32-bit") . "`n"
    result .= "Pointer Size: " . A_PtrSize . " bytes`n`n"

    loop 3 {
        offset := (A_Index - 1) * A_PtrSize
        ptr := NumGet(ptrBuf, offset, "Ptr")
        value := NumGet(ptr, "Int")

        result .= "Pointer " . A_Index . ":`n"
        result .= "  Address: 0x" . Format("{:X}", ptr) . "`n"
        result .= "  Value: " . value . "`n`n"
    }

    MsgBox(result, "Example 1: Basic Pointer Writing", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Creating Pointer Arrays
; ================================================================================================

Example2_PointerArrays() {
    ; Create string buffers
    strings := ["Hello", "World", "AutoHotkey", "v2", "Pointers"]
    strBuffers := []

    ; Create buffer for each string
    for str in strings {
        buf := Buffer(StrPut(str, "UTF-16") * 2)
        StrPut(str, buf, "UTF-16")
        strBuffers.Push(buf)
    }

    ; Create pointer array
    ptrArray := Buffer(A_PtrSize * strings.Length)

    ; Write pointers to array
    loop strings.Length {
        NumPut("Ptr", strBuffers[A_Index].Ptr, ptrArray, (A_Index - 1) * A_PtrSize)
    }

    ; Read pointers and dereference to strings
    result := "Pointer Array Example:`n`n"
    result .= "String Pointer Array (" . strings.Length . " entries):`n`n"

    loop strings.Length {
        ptr := NumGet(ptrArray, (A_Index - 1) * A_PtrSize, "Ptr")
        str := StrGet(ptr, "UTF-16")

        result .= "[" . (A_Index - 1) . "] 0x" . Format("{:X}", ptr) . " -> '" . str . "'`n"
    }

    MsgBox(result, "Example 2: Pointer Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Building Linked List
; ================================================================================================

Example3_LinkedList() {
    ; Node structure: value(Int) + next(Ptr)
    nodeSize := 4 + A_PtrSize

    ; Create nodes
    node1 := Buffer(nodeSize)
    node2 := Buffer(nodeSize)
    node3 := Buffer(nodeSize)
    node4 := Buffer(nodeSize)

    ; Write node data
    NumPut("Int", 10, node1, 0)
    NumPut("Ptr", node2.Ptr, node1, 4)

    NumPut("Int", 20, node2, 0)
    NumPut("Ptr", node3.Ptr, node2, 4)

    NumPut("Int", 30, node3, 0)
    NumPut("Ptr", node4.Ptr, node3, 4)

    NumPut("Int", 40, node4, 0)
    NumPut("Ptr", 0, node4, 4)  ; NULL terminator

    ; Traverse list
    values := []
    current := node1.Ptr

    while current != 0 {
        value := NumGet(current, 0, "Int")
        values.Push(value)
        current := NumGet(current, 4, "Ptr")
    }

    ; Display results
    result := "Linked List Creation:`n`n"
    result .= "Node Structure: [Int value][Ptr next] = " . nodeSize . " bytes`n`n"
    result .= "List Traversal:`n  "

    for value in values {
        result .= value
        if A_Index < values.Length
        result .= " -> "
        else
        result .= " -> NULL"
    }

    result .= "`n`nNodes: " . values.Length
    result .= "`nSum: " . (10 + 20 + 30 + 40)

    MsgBox(result, "Example 3: Linked List", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Null Pointer Handling
; ================================================================================================

Example4_NullPointers() {
    ; Create mixed pointer array
    ptrBuf := Buffer(A_PtrSize * 5)

    data1 := Buffer(4)
    data2 := Buffer(4)
    NumPut("Int", 100, data1, 0)
    NumPut("Int", 200, data2, 0)

    ; Write mix of valid and null pointers
    NumPut("Ptr", data1.Ptr, ptrBuf, 0)
    NumPut("Ptr", 0, ptrBuf, A_PtrSize)          ; NULL
    NumPut("Ptr", data2.Ptr, ptrBuf, A_PtrSize * 2)
    NumPut("Ptr", 0, ptrBuf, A_PtrSize * 3)      ; NULL
    NumPut("Ptr", 0, ptrBuf, A_PtrSize * 4)      ; NULL

    ; Process pointer array
    result := "Null Pointer Handling:`n`n"

    validCount := 0
    nullCount := 0

    loop 5 {
        ptr := NumGet(ptrBuf, (A_Index - 1) * A_PtrSize, "Ptr")

        result .= "[" . (A_Index - 1) . "] "

        if ptr = 0 {
            result .= "NULL`n"
            nullCount++
        } else {
            value := NumGet(ptr, "Int")
            result .= "0x" . Format("{:X}", ptr) . " -> " . value . "`n"
            validCount++
        }
    }

    result .= "`nValid: " . validCount . " | Null: " . nullCount

    MsgBox(result, "Example 4: Null Pointers", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Pointer to Pointer (Double Indirection)
; ================================================================================================

Example5_DoubleIndirection() {
    ; Create data
    dataBuf := Buffer(4)
    NumPut("Int", 42, dataBuf, 0)

    ; Level 1: pointer to data
    ptr1Buf := Buffer(A_PtrSize)
    NumPut("Ptr", dataBuf.Ptr, ptr1Buf, 0)

    ; Level 2: pointer to pointer
    ptr2Buf := Buffer(A_PtrSize)
    NumPut("Ptr", ptr1Buf.Ptr, ptr2Buf, 0)

    ; Dereference chain
    level2 := NumGet(ptr2Buf, 0, "Ptr")
    level1 := NumGet(level2, "Ptr")
    finalValue := NumGet(level1, "Int")

    ; Display results
    result := "Double Indirection (Pointer to Pointer):`n`n"
    result .= "Data Value: 42`n"
    result .= "Data Address: 0x" . Format("{:X}", dataBuf.Ptr) . "`n`n"

    result .= "Level 1 Pointer:`n"
    result .= "  Stored at: 0x" . Format("{:X}", ptr1Buf.Ptr) . "`n"
    result .= "  Points to: 0x" . Format("{:X}", dataBuf.Ptr) . "`n`n"

    result .= "Level 2 Pointer:`n"
    result .= "  Stored at: 0x" . Format("{:X}", ptr2Buf.Ptr) . "`n"
    result .= "  Points to: 0x" . Format("{:X}", ptr1Buf.Ptr) . "`n`n"

    result .= "Dereferencing:**ptr2 = " . finalValue

    MsgBox(result, "Example 5: Double Indirection", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Building Index Table
; ================================================================================================

Example6_IndexTable() {
    ; Create data array
    dataCount := 10
    dataBuf := Buffer(dataCount * 4)

    loop dataCount {
        NumPut("Int", A_Index * 1000, dataBuf, (A_Index - 1) * 4)
    }

    ; Create index table (pointers to specific elements)
    indexCount := 5
    indexBuf := Buffer(A_PtrSize * indexCount)

    ; Index specific elements: 0, 2, 4, 6, 8 (even indices)
    loop indexCount {
        targetIndex := (A_Index - 1) * 2
        targetPtr := dataBuf.Ptr + (targetIndex * 4)
        NumPut("Ptr", targetPtr, indexBuf, (A_Index - 1) * A_PtrSize)
    }

    ; Access via index table
    result := "Index Table Example:`n`n"
    result .= "Data Array: 10 integers`n"
    result .= "Index Table: " . indexCount . " pointers (even indices)`n`n"

    result .= "Indexed Access:`n"
    loop indexCount {
        ptr := NumGet(indexBuf, (A_Index - 1) * A_PtrSize, "Ptr")
        value := NumGet(ptr, "Int")

        result .= "  Index[" . (A_Index - 1) . "] -> Data["
        . ((A_Index - 1) * 2) . "] = " . value . "`n"
    }

    MsgBox(result, "Example 6: Index Table", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    NumPut Pointer Examples

    1. Basic Pointer Writing
    2. Creating Pointer Arrays
    3. Building Linked List
    4. Null Pointer Handling
    5. Double Indirection (Pointer to Pointer)
    6. Building Index Table

    Select an example (1-6) or press Cancel to exit:
    )"

    choice := InputBox(menu, "NumPut Pointer Examples", "w450 h320")

    if choice.Result = "Cancel"
    return

    switch choice.Value {
        case "1": Example1_BasicPointerWriting()
        case "2": Example2_PointerArrays()
        case "3": Example3_LinkedList()
        case "4": Example4_NullPointers()
        case "5": Example5_DoubleIndirection()
        case "6": Example6_IndexTable()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
