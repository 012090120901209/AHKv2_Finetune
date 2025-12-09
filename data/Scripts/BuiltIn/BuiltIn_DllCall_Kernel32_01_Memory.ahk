#Requires AutoHotkey v2.0

/**
* BuiltIn_DllCall_Kernel32_01_Memory.ahk
*
* DESCRIPTION:
* Demonstrates memory management operations using Windows API through DllCall.
* Shows how to allocate, lock, unlock, free memory, and work with virtual memory,
* heaps, and memory-mapped files.
*
* FEATURES:
* - Global memory allocation (GlobalAlloc, GlobalLock, GlobalFree)
* - Local memory allocation (LocalAlloc, LocalLock, LocalFree)
* - Virtual memory management (VirtualAlloc, VirtualFree)
* - Heap operations (HeapCreate, HeapAlloc, HeapFree)
* - Memory copying and comparison
* - Memory-mapped files
* - Memory information and statistics
*
* SOURCE:
* AutoHotkey v2 Documentation - DllCall
* https://www.autohotkey.com/docs/v2/lib/DllCall.htm
* Microsoft Memory Management API
* https://docs.microsoft.com/en-us/windows/win32/memory/memory-management-functions
*
* KEY V2 FEATURES DEMONSTRATED:
* - DllCall() with Kernel32 memory functions
* - Pointer arithmetic and manipulation
* - Memory buffer handling
* - NumGet/NumPut for memory access
* - Structure packing and alignment
*
* LEARNING POINTS:
* 1. Difference between Global, Local, and Virtual memory
* 2. Proper memory allocation and deallocation
* 3. Locking and unlocking memory handles
* 4. Using heaps for efficient memory management
* 5. Memory copying with different functions
* 6. Working with memory-mapped files
* 7. Getting memory status and statistics
*/

;==============================================================================
; EXAMPLE 1: Global Memory Allocation
;==============================================================================
; Demonstrates GlobalAlloc, GlobalLock, GlobalFree

Example1_GlobalMemory() {
    ; Global memory flags
    GMEM_FIXED := 0x0000        ; Fixed memory
    GMEM_MOVEABLE := 0x0002     ; Moveable memory
    GMEM_ZEROINIT := 0x0040     ; Initialize to zero
    GHND := GMEM_MOVEABLE | GMEM_ZEROINIT
    GPTR := GMEM_FIXED | GMEM_ZEROINIT

    ; Allocate 1KB of moveable, zero-initialized memory
    size := 1024
    hMem := DllCall("Kernel32.dll\GlobalAlloc"
    , "UInt", GHND           ; uFlags
    , "UPtr", size           ; dwBytes
    , "Ptr")                 ; Return: handle

    if (!hMem) {
        MsgBox("Failed to allocate global memory!", "Error")
        return
    }

    MsgBox(Format("Allocated global memory:`nHandle: 0x{:X}`nSize: {} bytes", hMem, size), "Success")

    ; Lock the memory to get a pointer
    pMem := DllCall("Kernel32.dll\GlobalLock"
    , "Ptr", hMem            ; hMem
    , "Ptr")                 ; Return: pointer

    if (!pMem) {
        DllCall("Kernel32.dll\GlobalFree", "Ptr", hMem, "Ptr")
        MsgBox("Failed to lock global memory!", "Error")
        return
    }

    ; Write data to the memory
    testData := "Hello from Global Memory!"
    StrPut(testData, pMem, StrLen(testData) + 1, "UTF-8")

    ; Write some numbers
    NumPut("Int", 12345, pMem, 100)
    NumPut("Int", 67890, pMem, 104)

    ; Read back the data
    readString := StrGet(pMem, "UTF-8")
    readNum1 := NumGet(pMem, 100, "Int")
    readNum2 := NumGet(pMem, 104, "Int")

    MsgBox(Format("Data written and read:`n`nString: {}`nNumber 1: {}`nNumber 2: {}",
    readString, readNum1, readNum2), "Memory Contents")

    ; Get memory size
    memSize := DllCall("Kernel32.dll\GlobalSize"
    , "Ptr", hMem            ; hMem
    , "UPtr")                ; Return: size

    ; Get lock count
    ; Unlock the memory
    DllCall("Kernel32.dll\GlobalUnlock"
    , "Ptr", hMem            ; hMem
    , "Int")                 ; Return: lock count

    ; Get memory flags
    flags := DllCall("Kernel32.dll\GlobalFlags"
    , "Ptr", hMem            ; hMem
    , "UInt")                ; Return: flags

    MsgBox(Format("Memory Info:`n`nSize: {} bytes`nFlags: 0x{:X}", memSize, flags), "Memory Info")

    ; Free the memory
    result := DllCall("Kernel32.dll\GlobalFree"
    , "Ptr", hMem            ; hMem
    , "Ptr")                 ; Return: NULL if success

    if (result = 0)
    MsgBox("Global memory freed successfully!", "Success")
    else
    MsgBox("Failed to free global memory!", "Error")
}

;==============================================================================
; EXAMPLE 2: Local Memory Allocation
;==============================================================================
; Shows local memory functions (faster than global for small allocations)

Example2_LocalMemory() {
    ; Local memory flags (same values as global)
    LMEM_FIXED := 0x0000
    LMEM_MOVEABLE := 0x0002
    LMEM_ZEROINIT := 0x0040
    LHND := LMEM_MOVEABLE | LMEM_ZEROINIT

    ; Allocate local memory for a structure
    structSize := 64
    hLocal := DllCall("Kernel32.dll\LocalAlloc"
    , "UInt", LHND
    , "UPtr", structSize
    , "Ptr")

    if (!hLocal) {
        MsgBox("Failed to allocate local memory!", "Error")
        return
    }

    ; Lock and get pointer
    pLocal := DllCall("Kernel32.dll\LocalLock"
    , "Ptr", hLocal
    , "Ptr")

    ; Create a simple structure: POINT {x: Int, y: Int}
    NumPut("Int", 100, pLocal, 0)   ; x = 100
    NumPut("Int", 200, pLocal, 4)   ; y = 200

    ; Create another structure: SIZE {cx: Int, cy: Int}
    NumPut("Int", 640, pLocal, 8)   ; cx = 640
    NumPut("Int", 480, pLocal, 12)  ; cy = 480

    ; Read back
    x := NumGet(pLocal, 0, "Int")
    y := NumGet(pLocal, 4, "Int")
    cx := NumGet(pLocal, 8, "Int")
    cy := NumGet(pLocal, 12, "Int")

    MsgBox(Format("Structures in local memory:`n`nPOINT: ({}, {})`nSIZE: ({}, {})", x, y, cx, cy), "Local Memory")

    ; Unlock
    DllCall("Kernel32.dll\LocalUnlock", "Ptr", hLocal, "Int")

    ; Get local memory size
    localSize := DllCall("Kernel32.dll\LocalSize"
    , "Ptr", hLocal
    , "UPtr")

    MsgBox("Local memory size: " . localSize . " bytes", "Info")

    ; Free local memory
    DllCall("Kernel32.dll\LocalFree", "Ptr", hLocal, "Ptr")

    MsgBox("Local memory freed!", "Success")
}

;==============================================================================
; EXAMPLE 3: Virtual Memory Allocation
;==============================================================================
; Demonstrates VirtualAlloc and VirtualFree for large allocations

Example3_VirtualMemory() {
    ; Virtual memory allocation types
    MEM_COMMIT := 0x1000        ; Commit pages
    MEM_RESERVE := 0x2000       ; Reserve address space
    MEM_RELEASE := 0x8000       ; Release pages

    ; Memory protection constants
    PAGE_READWRITE := 0x04      ; Read/write access
    PAGE_READONLY := 0x02       ; Read-only access

    ; Allocate 1MB of virtual memory
    size := 1024 * 1024  ; 1 MB

    pVirtual := DllCall("Kernel32.dll\VirtualAlloc"
    , "Ptr", 0               ; lpAddress (0 = let system choose)
    , "UPtr", size           ; dwSize
    , "UInt", MEM_COMMIT | MEM_RESERVE  ; flAllocationType
    , "UInt", PAGE_READWRITE ; flProtect
    , "Ptr")                 ; Return: pointer

    if (!pVirtual) {
        MsgBox("Failed to allocate virtual memory!", "Error")
        return
    }

    MsgBox(Format("Allocated virtual memory:`nAddress: 0x{:X}`nSize: {} bytes ({} KB)",
    pVirtual, size, size // 1024), "Success")

    ; Write pattern to memory
    Loop 1000 {
        NumPut("Int", A_Index, pVirtual, (A_Index - 1) * 4)
    }

    ; Read back some values
    val1 := NumGet(pVirtual, 0, "Int")
    val500 := NumGet(pVirtual, 499 * 4, "Int")
    val1000 := NumGet(pVirtual, 999 * 4, "Int")

    MsgBox(Format("Values written:`n`nFirst: {}`nMiddle (500): {}`nLast (1000): {}",
    val1, val500, val1000), "Virtual Memory Contents")

    ; Query memory information
    memInfo := Buffer(48, 0)  ; MEMORY_BASIC_INFORMATION structure

    bytesReturned := DllCall("Kernel32.dll\VirtualQuery"
    , "Ptr", pVirtual        ; lpAddress
    , "Ptr", memInfo.Ptr     ; lpBuffer
    , "UPtr", 48             ; dwLength
    , "UPtr")                ; Return: bytes returned

    if (bytesReturned > 0) {
        baseAddress := NumGet(memInfo, 0, "Ptr")
        allocationBase := NumGet(memInfo, 8, "Ptr")
        regionSize := NumGet(memInfo, 24, "UPtr")
        state := NumGet(memInfo, 32, "UInt")
        protect := NumGet(memInfo, 36, "UInt")

        info := Format("
        (
        Virtual Memory Info:

        Base Address: 0x{:X}
        Allocation Base: 0x{:X}
        Region Size: {} bytes
        State: 0x{:X}
        Protection: 0x{:X}
        )", baseAddress, allocationBase, regionSize, state, protect)

        MsgBox(info, "Memory Query")
    }

    ; Free virtual memory
    result := DllCall("Kernel32.dll\VirtualFree"
    , "Ptr", pVirtual        ; lpAddress
    , "UPtr", 0              ; dwSize (0 when using MEM_RELEASE)
    , "UInt", MEM_RELEASE    ; dwFreeType
    , "Int")                 ; Return: success

    if (result)
    MsgBox("Virtual memory freed successfully!", "Success")
    else
    MsgBox("Failed to free virtual memory!", "Error")
}

;==============================================================================
; EXAMPLE 4: Heap Operations
;==============================================================================
; Shows heap creation and allocation for efficient memory management

Example4_HeapOperations() {
    ; Heap flags
    HEAP_NO_SERIALIZE := 0x00000001
    HEAP_ZERO_MEMORY := 0x00000008

    ; Create a private heap (initial 4KB, max 64KB)
    hHeap := DllCall("Kernel32.dll\HeapCreate"
    , "UInt", 0              ; flOptions
    , "UPtr", 4096           ; dwInitialSize (4KB)
    , "UPtr", 65536          ; dwMaximumSize (64KB, 0 = growable)
    , "Ptr")                 ; Return: heap handle

    if (!hHeap) {
        MsgBox("Failed to create heap!", "Error")
        return
    }

    MsgBox(Format("Created private heap:`nHandle: 0x{:X}`nInitial: 4KB, Max: 64KB", hHeap), "Success")

    ; Allocate multiple blocks from the heap
    allocations := []

    Loop 5 {
        size := A_Index * 128  ; Variable sizes

        pBlock := DllCall("Kernel32.dll\HeapAlloc"
        , "Ptr", hHeap                      ; hHeap
        , "UInt", HEAP_ZERO_MEMORY         ; dwFlags
        , "UPtr", size                      ; dwBytes
        , "Ptr")                            ; Return: pointer

        if (pBlock) {
            ; Write identifier to each block
            NumPut("Int", A_Index * 1000, pBlock, 0)
            allocations.Push({ptr: pBlock, size: size, id: A_Index})
        }
    }

    MsgBox(Format("Allocated {} blocks from heap", allocations.Length), "Success")

    ; Read back and verify
    results := "Heap Allocations:`n`n"
    for block in allocations {
        id := NumGet(block.ptr, 0, "Int")
        results .= Format("Block {}: Size={} bytes, ID={}`n", block.id, block.size, id)
    }

    MsgBox(results, "Heap Contents")

    ; Get heap size
    totalSize := 0
    for block in allocations {
        blockSize := DllCall("Kernel32.dll\HeapSize"
        , "Ptr", hHeap
        , "UInt", 0
        , "Ptr", block.ptr
        , "UPtr")
        totalSize += blockSize
    }

    MsgBox(Format("Total allocated from heap: {} bytes", totalSize), "Heap Size")

    ; Free all allocations
    for block in allocations {
        DllCall("Kernel32.dll\HeapFree"
        , "Ptr", hHeap
        , "UInt", 0
        , "Ptr", block.ptr
        , "Int")
    }

    ; Destroy the heap
    result := DllCall("Kernel32.dll\HeapDestroy"
    , "Ptr", hHeap
    , "Int")

    if (result)
    MsgBox("Heap destroyed successfully!", "Success")
}

;==============================================================================
; EXAMPLE 5: Memory Copying and Comparison
;==============================================================================
; Demonstrates memory copy, move, and comparison functions

Example5_MemoryCopyCompare() {
    ; Allocate source and destination buffers
    sourceSize := 256
    hSource := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 0x0040, "UPtr", sourceSize, "Ptr")
    hDest := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 0x0040, "UPtr", sourceSize, "Ptr")

    pSource := DllCall("Kernel32.dll\GlobalLock", "Ptr", hSource, "Ptr")
    pDest := DllCall("Kernel32.dll\GlobalLock", "Ptr", hDest, "Ptr")

    ; Fill source with pattern
    Loop 64 {
        NumPut("Int", A_Index * 10, pSource, (A_Index - 1) * 4)
    }

    ; Copy memory using RtlMoveMemory (same as CopyMemory)
    DllCall("Kernel32.dll\RtlMoveMemory"
    , "Ptr", pDest           ; Destination
    , "Ptr", pSource         ; Source
    , "UPtr", 128            ; Length (copy first 128 bytes)
    , "Ptr")

    MsgBox("Copied 128 bytes from source to destination", "Memory Copy")

    ; Compare the copied portion
    result := DllCall("msvcrt.dll\memcmp"
    , "Ptr", pSource         ; buf1
    , "Ptr", pDest           ; buf2
    , "UPtr", 128            ; count
    , "Int")                 ; Return: 0 if equal

    MsgBox("Memory comparison result: " . (result = 0 ? "EQUAL" : "DIFFERENT"), "Comparison")

    ; Verify some values
    srcVal1 := NumGet(pSource, 0, "Int")
    dstVal1 := NumGet(pDest, 0, "Int")
    srcVal10 := NumGet(pSource, 36, "Int")
    dstVal10 := NumGet(pDest, 36, "Int")

    MsgBox(Format("Value verification:`n`nSource[0]: {}, Dest[0]: {}`nSource[10]: {}, Dest[10]: {}",
    srcVal1, dstVal1, srcVal10, dstVal10), "Verification")

    ; Fill destination with zeros
    DllCall("Kernel32.dll\RtlZeroMemory"
    , "Ptr", pDest
    , "UPtr", sourceSize
    , "Ptr")

    MsgBox("Destination memory zeroed", "Zero Memory")

    ; Verify it's zeroed
    allZero := true
    Loop 64 {
        if (NumGet(pDest, (A_Index - 1) * 4, "Int") != 0) {
            allZero := false
            break
        }
    }

    MsgBox("Destination is all zeros: " . (allZero ? "YES" : "NO"), "Verification")

    ; Cleanup
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hSource, "Int")
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hDest, "Int")
    DllCall("Kernel32.dll\GlobalFree", "Ptr", hSource, "Ptr")
    DllCall("Kernel32.dll\GlobalFree", "Ptr", hDest, "Ptr")

    MsgBox("Memory freed!", "Cleanup")
}

;==============================================================================
; EXAMPLE 6: Memory Status
;==============================================================================
; Shows how to get system memory information

Example6_MemoryStatus() {
    ; MEMORYSTATUSEX structure (64 bytes)
    memStatus := Buffer(64, 0)
    NumPut("UInt", 64, memStatus, 0)  ; dwLength

    success := DllCall("Kernel32.dll\GlobalMemoryStatusEx"
    , "Ptr", memStatus.Ptr
    , "Int")

    if (!success) {
        MsgBox("Failed to get memory status!", "Error")
        return
    }

    ; Extract values
    memoryLoad := NumGet(memStatus, 4, "UInt")
    totalPhys := NumGet(memStatus, 8, "UInt64")
    availPhys := NumGet(memStatus, 16, "UInt64")
    totalPageFile := NumGet(memStatus, 24, "UInt64")
    availPageFile := NumGet(memStatus, 32, "UInt64")
    totalVirtual := NumGet(memStatus, 40, "UInt64")
    availVirtual := NumGet(memStatus, 48, "UInt64")

    ; Convert to MB
    totalPhysMB := Round(totalPhys / 1048576, 2)
    availPhysMB := Round(availPhys / 1048576, 2)
    totalVirtualMB := Round(totalVirtual / 1048576, 2)
    availVirtualMB := Round(availVirtual / 1048576, 2)

    info := Format("
    (
    System Memory Status:
    =====================

    Memory Load: {}%

    Physical Memory:
    - Total: {} MB ({} GB)
    - Available: {} MB ({} GB)
    - In Use: {} MB

    Virtual Memory:
    - Total: {} MB ({} GB)
    - Available: {} MB ({} GB)

    Page File:
    - Total: {} MB
    - Available: {} MB
    )",
    memoryLoad,
    totalPhysMB, Round(totalPhysMB / 1024, 2),
    availPhysMB, Round(availPhysMB / 1024, 2),
    totalPhysMB - availPhysMB,
    totalVirtualMB, Round(totalVirtualMB / 1024, 2),
    availVirtualMB, Round(availVirtualMB / 1024, 2),
    Round(totalPageFile / 1048576, 2),
    Round(availPageFile / 1048576, 2))

    MsgBox(info, "Memory Status")
}

;==============================================================================
; EXAMPLE 7: Advanced Memory Operations
;==============================================================================
; Demonstrates memory protection and advanced features

Example7_AdvancedMemory() {
    ; Allocate memory
    size := 4096
    pMem := DllCall("Kernel32.dll\VirtualAlloc"
    , "Ptr", 0
    , "UPtr", size
    , "UInt", 0x3000  ; MEM_COMMIT | MEM_RESERVE
    , "UInt", 0x04    ; PAGE_READWRITE
    , "Ptr")

    if (!pMem) {
        MsgBox("Failed to allocate memory!", "Error")
        return
    }

    ; Write some data
    NumPut("Int", 12345, pMem, 0)

    ; Change protection to read-only
    oldProtect := Buffer(4, 0)
    success := DllCall("Kernel32.dll\VirtualProtect"
    , "Ptr", pMem
    , "UPtr", size
    , "UInt", 0x02      ; PAGE_READONLY
    , "Ptr", oldProtect.Ptr
    , "Int")

    if (success) {
        oldProt := NumGet(oldProtect, 0, "UInt")
        MsgBox(Format("Changed protection to read-only`nOld protection: 0x{:X}", oldProt), "Success")

        ; Try to read (should work)
        value := NumGet(pMem, 0, "Int")
        MsgBox("Read value: " . value, "Read Successful")

        ; Restore write access
        DllCall("Kernel32.dll\VirtualProtect"
        , "Ptr", pMem
        , "UPtr", size
        , "UInt", 0x04  ; PAGE_READWRITE
        , "Ptr", oldProtect.Ptr
        , "Int")

        MsgBox("Protection restored to read-write", "Success")
    }

    ; Lock pages in memory (may require admin rights)
    locked := DllCall("Kernel32.dll\VirtualLock"
    , "Ptr", pMem
    , "UPtr", size
    , "Int")

    if (locked) {
        MsgBox("Pages locked in physical memory", "Success")

        ; Unlock
        DllCall("Kernel32.dll\VirtualUnlock"
        , "Ptr", pMem
        , "UPtr", size
        , "Int")
    } else {
        MsgBox("Could not lock pages (may require admin rights)", "Info")
    }

    ; Free memory
    DllCall("Kernel32.dll\VirtualFree", "Ptr", pMem, "UPtr", 0, "UInt", 0x8000, "Int")

    MsgBox("Advanced memory operations complete!", "Complete")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    Memory Operations DllCall Examples
    ===================================

    1. Global Memory Allocation
    2. Local Memory Allocation
    3. Virtual Memory Allocation
    4. Heap Operations
    5. Memory Copy and Compare
    6. Memory Status
    7. Advanced Memory Operations

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "Memory Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
        break

        switch choice {
            case "1": Example1_GlobalMemory()
            case "2": Example2_LocalMemory()
            case "3": Example3_VirtualMemory()
            case "4": Example4_HeapOperations()
            case "5": Example5_MemoryCopyCompare()
            case "6": Example6_MemoryStatus()
            case "7": Example7_AdvancedMemory()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
