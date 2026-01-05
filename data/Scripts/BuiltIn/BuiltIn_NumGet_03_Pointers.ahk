#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_NumGet_03_Pointers.ahk
 * 
 * DESCRIPTION:
 * Advanced NumGet usage for reading and dereferencing pointers from buffers.
 * Covers pointer arithmetic, pointer chains, and indirect memory access.
 * 
 * FEATURES:
 * - Reading pointer values from buffers
 * - Pointer dereferencing techniques
 * - Pointer chains and indirect access
 * - Platform-aware pointer handling (32-bit vs 64-bit)
 * - Null pointer handling
 * - Practical pointer-based data structures
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - NumGet, Pointers
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - NumGet with "Ptr" type (platform-dependent size)
 * - NumGet with "UPtr" type (unsigned pointer)
 * - A_PtrSize for platform detection
 * - Multi-level pointer dereferencing
 * - Pointer validation
 * 
 * LEARNING POINTS:
 * 1. Ptr type is 4 bytes on 32-bit, 8 bytes on 64-bit systems
 * 2. Pointers store memory addresses, not values directly
 * 3. Dereferencing means reading from the address stored in pointer
 * 4. Pointer chains enable complex data structures
 * 5. Always validate pointers before dereferencing
 */

; ================================================================================================
; EXAMPLE 1: Basic Pointer Reading
; ================================================================================================
; Demonstrates reading pointer values from buffers

Example1_BasicPointerReading() {
    ; Create buffers for data and pointers
    dataBuf := Buffer(20)
    ptrBuf := Buffer(A_PtrSize * 3)  ; 3 pointers

    ; Write data values
    NumPut("Int", 1000, dataBuf, 0)
    NumPut("Int", 2000, dataBuf, 4)
    NumPut("Int", 3000, dataBuf, 8)

    ; Store pointers to data buffer locations
    NumPut("Ptr", dataBuf.Ptr, ptrBuf, 0)           ; Points to offset 0
    NumPut("Ptr", dataBuf.Ptr + 4, ptrBuf, A_PtrSize)   ; Points to offset 4
    NumPut("Ptr", dataBuf.Ptr + 8, ptrBuf, A_PtrSize * 2) ; Points to offset 8

    ; Read pointers
    ptr1 := NumGet(ptrBuf, 0, "Ptr")
    ptr2 := NumGet(ptrBuf, A_PtrSize, "Ptr")
    ptr3 := NumGet(ptrBuf, A_PtrSize * 2, "Ptr")

    ; Dereference pointers to get values
    value1 := NumGet(ptr1, "Int")
    value2 := NumGet(ptr2, "Int")
    value3 := NumGet(ptr3, "Int")

    ; Display results
    result := "Basic Pointer Reading:`n`n"
    result .= "Platform: " . (A_PtrSize = 8 ? "64-bit" : "32-bit") . "`n"
    result .= "Pointer Size: " . A_PtrSize . " bytes`n`n"

    result .= "Data Buffer (20 bytes):`n"
    result .= "  Address: 0x" . Format("{:X}", dataBuf.Ptr) . "`n`n"

    result .= "Pointer Buffer (" . (A_PtrSize * 3) . " bytes):`n`n"

    result .= "Pointer 1 (offset 0):`n"
    result .= "  Stored Address: 0x" . Format("{:X}", ptr1) . "`n"
    result .= "  Dereferenced Value: " . value1 . "`n`n"

    result .= "Pointer 2 (offset " . A_PtrSize . "):`n"
    result .= "  Stored Address: 0x" . Format("{:X}", ptr2) . "`n"
    result .= "  Dereferenced Value: " . value2 . "`n`n"

    result .= "Pointer 3 (offset " . (A_PtrSize * 2) . "):`n"
    result .= "  Stored Address: 0x" . Format("{:X}", ptr3) . "`n"
    result .= "  Dereferenced Value: " . value3

    MsgBox(result, "Example 1: Basic Pointer Reading", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Pointer Arrays
; ================================================================================================
; Shows working with arrays of pointers

Example2_PointerArrays() {
    ; Create multiple data buffers
    count := 5
    dataBuffers := []
    loop count {
        buf := Buffer(4)
        NumPut("Int", A_Index * 1000, buf, 0)
        dataBuffers.Push(buf)
    }

    ; Create pointer array
    ptrArray := Buffer(A_PtrSize * count)

    ; Store pointers to each data buffer
    loop count {
        NumPut("Ptr", dataBuffers[A_Index].Ptr, ptrArray, (A_Index - 1) * A_PtrSize)
    }

    ; Read and dereference all pointers
    values := []
    loop count {
        ; Read pointer from array
        ptr := NumGet(ptrArray, (A_Index - 1) * A_PtrSize, "Ptr")

        ; Dereference to get value
        value := NumGet(ptr, "Int")
        values.Push(value)
    }

    ; Calculate statistics
    sum := 0
    for value in values {
        sum += value
    }
    average := sum / count

    ; Display results
    result := "Pointer Array Example:`n`n"
    result .= "Array Size: " . count . " pointers`n"
    result .= "Array Buffer: " . ptrArray.Size . " bytes`n`n"

    result .= "Pointer Array Contents:`n"
    loop count {
        offset := (A_Index - 1) * A_PtrSize
        ptr := NumGet(ptrArray, offset, "Ptr")
        value := values[A_Index]

        result .= "  [" . (A_Index - 1) . "] "
        result .= "Ptr: 0x" . Format("{:X}", ptr)
        result .= " -> Value: " . value . "`n"
    }

    result .= "`nStatistics:`n"
    result .= "  Sum: " . sum . "`n"
    result .= "  Average: " . average

    MsgBox(result, "Example 2: Pointer Arrays", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Pointer Chains (Multi-Level Indirection)
; ================================================================================================
; Demonstrates following pointer chains

Example3_PointerChains() {
    ; Create data buffer
    dataBuf := Buffer(4)
    NumPut("Int", 42, dataBuf, 0)

    ; Create level 1 pointer (points to data)
    ptr1Buf := Buffer(A_PtrSize)
    NumPut("Ptr", dataBuf.Ptr, ptr1Buf, 0)

    ; Create level 2 pointer (points to level 1 pointer)
    ptr2Buf := Buffer(A_PtrSize)
    NumPut("Ptr", ptr1Buf.Ptr, ptr2Buf, 0)

    ; Create level 3 pointer (points to level 2 pointer)
    ptr3Buf := Buffer(A_PtrSize)
    NumPut("Ptr", ptr2Buf.Ptr, ptr3Buf, 0)

    ; Follow the chain from level 3 to data
    level3Ptr := NumGet(ptr3Buf, 0, "Ptr")        ; Get address of ptr2Buf
    level2Ptr := NumGet(level3Ptr, "Ptr")         ; Get address of ptr1Buf
    level1Ptr := NumGet(level2Ptr, "Ptr")         ; Get address of dataBuf
    finalValue := NumGet(level1Ptr, "Int")        ; Get the actual value

    ; Alternative: direct chain following
    directValue := NumGet(NumGet(NumGet(ptr3Buf, 0, "Ptr"), "Ptr"), "Int")

    ; Display results
    result := "Pointer Chain Example (Triple Indirection):`n`n"
    result .= "Chain Structure:`n"
    result .= "  ptr3Buf -> ptr2Buf -> ptr1Buf -> dataBuf -> value`n`n"

    result .= "Following the Chain:`n"
    result .= "  1. Read ptr3Buf: 0x" . Format("{:X}", level3Ptr) . " (address of ptr2Buf)`n"
    result .= "  2. Read from 0x" . Format("{:X}", level3Ptr) . ": 0x"
        . Format("{:X}", level2Ptr) . " (address of ptr1Buf)`n"
    result .= "  3. Read from 0x" . Format("{:X}", level2Ptr) . ": 0x"
        . Format("{:X}", level1Ptr) . " (address of dataBuf)`n"
    result .= "  4. Read from 0x" . Format("{:X}", level1Ptr) . ": "
        . finalValue . " (final value)`n`n"

    result .= "Verification:`n"
    result .= "  Step-by-step result: " . finalValue . "`n"
    result .= "  Direct chain result: " . directValue . "`n"
    result .= "  Data buffer value: " . NumGet(dataBuf, 0, "Int") . "`n`n"

    result .= "All methods return: " . (finalValue = directValue && directValue = 42 ? "42 ✓" : "Error")

    MsgBox(result, "Example 3: Pointer Chains", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Null Pointer Handling
; ================================================================================================
; Shows proper null pointer detection and handling

Example4_NullPointers() {
    ; Create buffer with mix of valid and null pointers
    ptrCount := 5
    ptrBuf := Buffer(A_PtrSize * ptrCount)

    ; Create some data buffers
    data1 := Buffer(4)
    data2 := Buffer(4)
    NumPut("Int", 100, data1, 0)
    NumPut("Int", 200, data2, 0)

    ; Store pointers: some valid, some null
    NumPut("Ptr", data1.Ptr, ptrBuf, 0)           ; Valid
    NumPut("Ptr", 0, ptrBuf, A_PtrSize)           ; Null
    NumPut("Ptr", data2.Ptr, ptrBuf, A_PtrSize * 2)  ; Valid
    NumPut("Ptr", 0, ptrBuf, A_PtrSize * 3)       ; Null
    NumPut("Ptr", 0, ptrBuf, A_PtrSize * 4)       ; Null

    ; Safe pointer dereferencing function
    SafeDeref(ptr, default := 0) {
        if ptr = 0 || ptr = ""
            return default
        try {
            return NumGet(ptr, "Int")
        } catch {
            return default
        }
    }

    ; Process pointer array safely
    results := []
    validCount := 0
    nullCount := 0

    loop ptrCount {
        offset := (A_Index - 1) * A_PtrSize
        ptr := NumGet(ptrBuf, offset, "Ptr")

        if ptr = 0 {
            results.Push({ index: A_Index - 1, ptr: 0, value: "NULL", valid: false })
            nullCount++
        } else {
            value := SafeDeref(ptr, -1)
            results.Push({ index: A_Index - 1, ptr: ptr, value: value, valid: true })
            validCount++
        }
    }

    ; Display results
    result := "Null Pointer Handling:`n`n"
    result .= "Pointer Array (" . ptrCount . " pointers):`n`n"

    for entry in results {
        result .= "  [" . entry.index . "] "

        if entry.valid {
            result .= "0x" . Format("{:X}", entry.ptr)
            result .= " -> " . entry.value . " ✓`n"
        } else {
            result .= "NULL (0x0) `n"
        }
    }

    result .= "`nSummary:`n"
    result .= "  Valid Pointers: " . validCount . "`n"
    result .= "  Null Pointers: " . nullCount . "`n`n"

    result .= "Safety Notes:`n"
    result .= "  • Always check ptr != 0 before dereferencing`n"
    result .= "  • Use try/catch for additional safety`n"
    result .= "  • Provide sensible defaults for null cases"

    MsgBox(result, "Example 4: Null Pointer Handling", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Linked List with Pointers
; ================================================================================================
; Practical example: reading a linked list structure

Example5_LinkedList() {
    ; Node structure: [value: Int][next: Ptr]
    nodeSize := 4 + A_PtrSize

    ; Create linked list nodes
    node1 := Buffer(nodeSize)
    node2 := Buffer(nodeSize)
    node3 := Buffer(nodeSize)
    node4 := Buffer(nodeSize)

    ; Node 1: value=10, next->node2
    NumPut("Int", 10, node1, 0)
    NumPut("Ptr", node2.Ptr, node1, 4)

    ; Node 2: value=20, next->node3
    NumPut("Int", 20, node2, 0)
    NumPut("Ptr", node3.Ptr, node2, 4)

    ; Node 3: value=30, next->node4
    NumPut("Int", 30, node3, 0)
    NumPut("Ptr", node4.Ptr, node3, 4)

    ; Node 4: value=40, next=NULL
    NumPut("Int", 40, node4, 0)
    NumPut("Ptr", 0, node4, 4)

    ; Traverse linked list
    values := []
    currentPtr := node1.Ptr
    nodeCount := 0

    while currentPtr != 0 {
        ; Read value from current node
        value := NumGet(currentPtr, 0, "Int")
        values.Push(value)

        ; Read next pointer
        currentPtr := NumGet(currentPtr, 4, "Ptr")
        nodeCount++

        ; Safety limit
        if nodeCount > 100
            break
    }

    ; Calculate sum
    sum := 0
    for value in values {
        sum += value
    }

    ; Display results
    result := "Linked List Traversal:`n`n"
    result .= "Node Structure: [Int value][Ptr next] = " . nodeSize . " bytes`n`n"

    result .= "List Traversal:`n"
    loop values.Length {
        result .= "  Node " . A_Index . ": value=" . values[A_Index]

        if A_Index < values.Length
            result .= " -> "
        else
            result .= " -> NULL"

        result .= "`n"
    }

    result .= "`nStatistics:`n"
    result .= "  Total Nodes: " . nodeCount . "`n"
    result .= "  Sum of Values: " . sum . "`n"
    result .= "  Average: " . Round(sum / nodeCount, 2)

    MsgBox(result, "Example 5: Linked List", "Icon!")
}

; ================================================================================================
; EXAMPLE 6: Function Pointers and Callbacks
; ================================================================================================
; Shows reading function pointer addresses

Example6_FunctionPointers() {
    ; Get addresses of Windows API functions using DllCall
    user32 := DllCall("GetModuleHandle", "Str", "user32.dll", "Ptr")
    kernel32 := DllCall("GetModuleHandle", "Str", "kernel32.dll", "Ptr")

    ; Get specific function addresses
    messageBoxAddr := DllCall("GetProcAddress", "Ptr", user32, "AStr", "MessageBoxW", "Ptr")
    sleepAddr := DllCall("GetProcAddress", "Ptr", kernel32, "AStr", "Sleep", "Ptr")
    getTickAddr := DllCall("GetProcAddress", "Ptr", kernel32, "AStr", "GetTickCount", "Ptr")

    ; Store function pointers in a buffer
    funcPtrBuf := Buffer(A_PtrSize * 3)
    NumPut("Ptr", messageBoxAddr, funcPtrBuf, 0)
    NumPut("Ptr", sleepAddr, funcPtrBuf, A_PtrSize)
    NumPut("Ptr", getTickAddr, funcPtrBuf, A_PtrSize * 2)

    ; Read function pointers back
    msgBoxPtr := NumGet(funcPtrBuf, 0, "Ptr")
    sleepPtr := NumGet(funcPtrBuf, A_PtrSize, "Ptr")
    tickPtr := NumGet(funcPtrBuf, A_PtrSize * 2, "Ptr")

    ; Verify we can call through the pointers (example with GetTickCount)
    ; Note: In real code, you'd use CallbackCreate for custom functions
    tickCount := DllCall(tickPtr, "UInt")

    ; Display results
    result := "Function Pointers:`n`n"
    result .= "DLL Module Handles:`n"
    result .= "  user32.dll: 0x" . Format("{:X}", user32) . "`n"
    result .= "  kernel32.dll: 0x" . Format("{:X}", kernel32) . "`n`n"

    result .= "Function Pointer Table:`n"
    result .= "  [0] MessageBoxW: 0x" . Format("{:X}", msgBoxPtr) . "`n"
    result .= "  [1] Sleep: 0x" . Format("{:X}", sleepPtr) . "`n"
    result .= "  [2] GetTickCount: 0x" . Format("{:X}", tickPtr) . "`n`n"

    result .= "Verification:`n"
    result .= "  Called GetTickCount via pointer`n"
    result .= "  Result: " . tickCount . " ms since boot`n`n"

    result .= "Use Case:`n"
    result .= "  Function pointers enable:`n"
    result .= "  - Dynamic function dispatch`n"
    result .= "  - Callback mechanisms`n"
    result .= "  - Plugin systems`n"
    result .= "  - Virtual method tables"

    MsgBox(result, "Example 6: Function Pointers", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    NumGet Pointer Examples

    1. Basic Pointer Reading
    2. Pointer Arrays
    3. Pointer Chains (Multi-Level Indirection)
    4. Null Pointer Handling
    5. Linked List with Pointers
    6. Function Pointers and Callbacks

    Select an example (1-6) or press Cancel to exit:
    )"

    choice := InputBox(menu, "NumGet Pointer Examples", "w450 h320")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_BasicPointerReading()
        case "2": Example2_PointerArrays()
        case "3": Example3_PointerChains()
        case "4": Example4_NullPointers()
        case "5": Example5_LinkedList()
        case "6": Example6_FunctionPointers()
        default: MsgBox("Invalid selection. Please choose 1-6.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
