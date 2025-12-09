#Requires AutoHotkey v2.0

/**
* BuiltIn_Buffer_02_Memory.ahk
*
* DESCRIPTION:
* Advanced memory allocation, management, and manipulation using Buffer objects.
* Covers memory copying, alignment, DllCall integration, and low-level operations.
*
* FEATURES:
* - Memory allocation strategies
* - Buffer memory copying and moving
* - Memory alignment techniques
* - DllCall integration with buffers
* - Memory pools and reuse patterns
* - Performance optimization techniques
*
* SOURCE:
* AutoHotkey v2 Documentation - Buffer and DllCall
*
* KEY V2 FEATURES DEMONSTRATED:
* - RtlMoveMemory for fast memory operations
* - RtlZeroMemory for efficient zeroing
* - RtlFillMemory for pattern filling
* - Proper pointer arithmetic with Buffer.Ptr
* - Memory alignment for performance
*
* LEARNING POINTS:
* 1. Windows API functions provide efficient memory operations
* 2. Memory alignment affects performance on some architectures
* 3. Buffers can be reused to reduce allocation overhead
* 4. DllCall requires proper pointer management with Buffers
* 5. Large memory operations should use optimized system calls
*/

; ================================================================================================
; EXAMPLE 1: Memory Copy Operations
; ================================================================================================
; Demonstrates various ways to copy memory between buffers

Example1_MemoryCopy() {
    ; Create source buffer with test data
    source := Buffer(100)
    loop 25 {
        offset := (A_Index - 1) * 4
        NumPut("Int", A_Index * 100, source, offset)
    }

    ; Method 1: RtlMoveMemory (fast, handles overlapping regions)
    dest1 := Buffer(100)
    DllCall("RtlMoveMemory"
    , "Ptr", dest1.Ptr
    , "Ptr", source.Ptr
    , "UPtr", source.Size)

    ; Method 2: Byte-by-byte copy (slow, but demonstrates manual approach)
    dest2 := Buffer(100)
    loop source.Size {
        value := NumGet(source, A_Index - 1, "UChar")
        NumPut("UChar", value, dest2, A_Index - 1)
    }

    ; Method 3: Copy with RtlCopyMemory (same as RtlMoveMemory on Windows)
    dest3 := Buffer(100)
    DllCall("ntdll\RtlCopyMemory"
    , "Ptr", dest3.Ptr
    , "Ptr", source.Ptr
    , "UPtr", source.Size)

    ; Partial copy - copy first 40 bytes only
    dest4 := Buffer(100)  ; Create 100-byte buffer
    DllCall("RtlMoveMemory"
    , "Ptr", dest4.Ptr
    , "Ptr", source.Ptr
    , "UPtr", 40)  ; Only copy 40 bytes

    ; Verify copies
    VerifyBuffers(buf1, buf2) {
        loop buf1.Size {
            if NumGet(buf1, A_Index - 1, "UChar") != NumGet(buf2, A_Index - 1, "UChar")
            return false
        }
        return true
    }

    ; Performance measurement (approximate)
    iterations := 1000
    start := A_TickCount

    loop iterations {
        temp := Buffer(100)
        DllCall("RtlMoveMemory", "Ptr", temp.Ptr, "Ptr", source.Ptr, "UPtr", 100)
    }

    elapsed := A_TickCount - start

    ; Display results
    result := "Memory Copy Operations:`n`n"
    result .= "Source buffer: 100 bytes with test data`n`n"

    result .= "Copy Methods:`n"
    result .= "  RtlMoveMemory: " . (VerifyBuffers(source, dest1) ? "✓" : "✗") . " Success`n"
    result .= "  Byte-by-byte: " . (VerifyBuffers(source, dest2) ? "✓" : "✗") . " Success`n"
    result .= "  RtlCopyMemory: " . (VerifyBuffers(source, dest3) ? "✓" : "✗") . " Success`n`n"

    result .= "Partial copy (40 bytes):`n"
    result .= "  First 10 integers copied: "
    loop 5 {
        value := NumGet(dest4, (A_Index - 1) * 4, "Int")
        result .= value . " "
    }
    result .= "`n  Remaining bytes: " . (NumGet(dest4, 40, "Int") = 0 ? "Zero" : "Non-zero") . "`n`n"

    result .= "Performance: " . iterations . " copies in " . elapsed . "ms"

    MsgBox(result, "Example 1: Memory Copy", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Memory Zeroing and Filling
; ================================================================================================
; Shows efficient techniques for zeroing and pattern-filling memory

Example2_ZeroingAndFilling() {
    ; Create buffer with random-looking data
    buf := Buffer(256)
    loop 64 {
        NumPut("Int", A_Index * 12345, buf, (A_Index - 1) * 4)
    }

    ; Method 1: RtlZeroMemory - fastest way to zero memory
    zeroBuf := Buffer(256)
    loop 64 {
        NumPut("Int", 0xDEADBEEF, zeroBuf, (A_Index - 1) * 4)  ; Fill with pattern
    }

    DllCall("RtlZeroMemory"
    , "Ptr", zeroBuf.Ptr
    , "UPtr", zeroBuf.Size)

    ; Method 2: RtlFillMemory - fill with a byte value
    fillBuf := Buffer(256)
    DllCall("RtlFillMemory"
    , "Ptr", fillBuf.Ptr
    , "UPtr", fillBuf.Size
    , "UChar", 0xAA)  ; Fill with 0xAA

    ; Method 3: Selective zeroing - zero specific regions
    selectiveBuf := Buffer(256)
    loop 64 {
        NumPut("Int", A_Index * 1000, selectiveBuf, (A_Index - 1) * 4)
    }

    ; Zero bytes 64-127 (middle section)
    DllCall("RtlZeroMemory"
    , "Ptr", selectiveBuf.Ptr + 64
    , "UPtr", 64)

    ; Method 4: Fill with multi-byte pattern
    patternBuf := Buffer(256)
    pattern := 0x12345678

    loop 64 {
        NumPut("Int", pattern, patternBuf, (A_Index - 1) * 4)
    }

    ; Verify operations
    CheckZero(buf, offset, size) {
        loop size {
            if NumGet(buf, offset + A_Index - 1, "UChar") != 0
            return false
        }
        return true
    }

    CheckFill(buf, fillValue, size) {
        loop size {
            if NumGet(buf, A_Index - 1, "UChar") != fillValue
            return false
        }
        return true
    }

    ; Display results
    result := "Memory Zeroing and Filling:`n`n"

    result .= "RtlZeroMemory (256 bytes):`n"
    result .= "  All zeros: " . (CheckZero(zeroBuf, 0, 256) ? "Yes" : "No") . "`n`n"

    result .= "RtlFillMemory (0xAA pattern):`n"
    result .= "  All 0xAA: " . (CheckFill(fillBuf, 0xAA, 256) ? "Yes" : "No") . "`n"
    result .= "  Sample bytes: "
    loop 8 {
        result .= Format("{:02X} ", NumGet(fillBuf, A_Index - 1, "UChar"))
    }
    result .= "`n`n"

    result .= "Selective Zeroing:`n"
    result .= "  Bytes 0-63: " . (CheckZero(selectiveBuf, 0, 64) ? "Zero" : "Non-zero") . "`n"
    result .= "  Bytes 64-127: " . (CheckZero(selectiveBuf, 64, 64) ? "Zero" : "Non-zero") . "`n"
    result .= "  Bytes 128-255: " . (CheckZero(selectiveBuf, 128, 128) ? "Zero" : "Non-zero") . "`n`n"

    result .= "Multi-byte Pattern Fill:`n"
    result .= "  Pattern: 0x" . Format("{:08X}", pattern) . "`n"
    result .= "  First 4 integers: "
    loop 4 {
        value := NumGet(patternBuf, (A_Index - 1) * 4, "Int")
        result .= "0x" . Format("{:08X}", value) . " "
    }

    MsgBox(result, "Example 2: Zeroing and Filling", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Memory Alignment
; ================================================================================================
; Demonstrates memory alignment for optimal performance

Example3_MemoryAlignment() {
    ; Check alignment of buffer pointers
    CheckAlignment(buf, alignment) {
        return (buf.Ptr & (alignment - 1)) = 0
    }

    ; Create multiple buffers and check their alignment
    buffers := []
    alignmentResults := Map()

    loop 10 {
        size := A_Index * 16
        buf := Buffer(size)
        buffers.Push(buf)

        ; Check various alignment boundaries
        alignmentResults[size] := {
            Ptr: buf.Ptr,
            Align4: CheckAlignment(buf, 4),
            Align8: CheckAlignment(buf, 8),
            Align16: CheckAlignment(buf, 16),
            Align32: CheckAlignment(buf, 32),
            Align64: CheckAlignment(buf, 64)
        }
    }

    ; Create aligned buffer manually (if needed)
    CreateAlignedBuffer(size, alignment) {
        ; Allocate extra space for alignment
        buf := Buffer(size + alignment)

        ; Calculate aligned address
        addr := buf.Ptr
        alignedAddr := (addr + alignment - 1) & ~(alignment - 1)
        offset := alignedAddr - addr

        return {
            Buffer: buf,
            AlignedPtr: alignedAddr,
            Offset: offset,
            IsAligned: CheckAlignment({Ptr: alignedAddr}, alignment)
        }
    }

    ; Create a 64-byte aligned buffer
    aligned64 := CreateAlignedBuffer(1024, 64)

    ; Performance test - aligned vs unaligned access
    ; (Note: Modern CPUs handle unaligned access well, but alignment still matters)
    testBuf := Buffer(1024)
    iterations := 100000

    ; Aligned writes
    start := A_TickCount
    loop iterations {
        NumPut("Int64", 0x1234567890ABCDEF, testBuf, 0)
        NumPut("Int64", 0xFEDCBA0987654321, testBuf, 8)
    }
    alignedTime := A_TickCount - start

    ; Display results
    result := "Memory Alignment Analysis:`n`n"

    result .= "Buffer Alignment Check (first 5 buffers):`n"
    count := 0
    for size, info in alignmentResults {
        count++
        if count > 5
        break

        result .= "  Size " . size . " bytes:`n"
        result .= "    Pointer: 0x" . Format("{:X}", info.Ptr) . "`n"
        result .= "    4-byte aligned: " . (info.Align4 ? "✓" : "✗") . "`n"
        result .= "    8-byte aligned: " . (info.Align8 ? "✓" : "✗") . "`n"
        result .= "    16-byte aligned: " . (info.Align16 ? "✓" : "✗") . "`n"
    }

    result .= "`nCustom 64-byte Aligned Buffer:`n"
    result .= "  Original pointer: 0x" . Format("{:X}", aligned64.Buffer.Ptr) . "`n"
    result .= "  Aligned pointer: 0x" . Format("{:X}", aligned64.AlignedPtr) . "`n"
    result .= "  Offset: " . aligned64.Offset . " bytes`n"
    result .= "  64-byte aligned: " . (aligned64.IsAligned ? "✓" : "✗") . "`n`n"

    result .= "Performance Test:`n"
    result .= "  " . iterations . " aligned Int64 writes: " . alignedTime . "ms"

    MsgBox(result, "Example 3: Memory Alignment", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Memory Pool Manager
; ================================================================================================
; Implements a simple memory pool for efficient buffer reuse

Example4_MemoryPool() {

    ; Create a memory pool for 1KB buffers
    pool := MemoryPool(1024, 5)

    ; Simulate usage pattern
    buffers := []

    ; Acquire 10 buffers
    loop 10 {
        buf := pool.Acquire()
        NumPut("Int", A_Index * 1000, buf, 0)
        buffers.Push(buf)
    }

    stats1 := pool.GetStats()

    ; Release first 5 buffers
    loop 5 {
        pool.Release(buffers[A_Index])
    }

    stats2 := pool.GetStats()

    ; Acquire 5 more buffers (should reuse released ones)
    loop 5 {
        buf := pool.Acquire()
        NumPut("Int", (A_Index + 10) * 1000, buf, 0)
        buffers.Push(buf)
    }

    stats3 := pool.GetStats()

    ; Display results
    result := "Memory Pool Manager:`n`n"

    result .= "Pool Configuration:`n"
    result .= "  Block Size: " . pool.blockSize . " bytes`n"
    result .= "  Initial Blocks: 5`n`n"

    result .= "After acquiring 10 buffers:`n"
    result .= "  Total Allocated: " . stats1.TotalAllocated . "`n"
    result .= "  In Use: " . stats1.InUse . "`n"
    result .= "  Available: " . stats1.Available . "`n"
    result .= "  Reuse Rate: " . stats1.ReuseRate . "%`n`n"

    result .= "After releasing 5 buffers:`n"
    result .= "  In Use: " . stats2.InUse . "`n"
    result .= "  Available: " . stats2.Available . "`n`n"

    result .= "After acquiring 5 more buffers:`n"
    result .= "  Total Allocated: " . stats3.TotalAllocated . "`n"
    result .= "  In Use: " . stats3.InUse . "`n"
    result .= "  Available: " . stats3.Available . "`n"
    result .= "  Reuse Rate: " . stats3.ReuseRate . "%`n`n"

    result .= "Efficiency: Reused " . stats3.ReuseCount . " buffers, "
    result .= "allocated only " . stats3.TotalAllocated . " total"

    MsgBox(result, "Example 4: Memory Pool", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: Advanced DllCall Integration
; ================================================================================================
; Demonstrates using Buffers with Windows API functions

Example5_DllCallIntegration() {
    ; Example 1: Get computer name using GetComputerNameW
    nameBuffer := Buffer(260 * 2)  ; MAX_COMPUTERNAME_LENGTH + 1, UTF-16
    sizeBuffer := Buffer(4)
    NumPut("UInt", 260, sizeBuffer, 0)

    result1 := DllCall("GetComputerNameW"
    , "Ptr", nameBuffer.Ptr
    , "Ptr", sizeBuffer.Ptr
    , "Int")

    computerName := result1 ? StrGet(nameBuffer, "UTF-16") : "Unknown"

    ; Example 2: Get system info using GetSystemInfo
    SYSTEM_INFO_SIZE := 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4 + 4  ; 36 bytes on x64, adjust for x86
    if A_PtrSize = 8
    SYSTEM_INFO_SIZE := 48

    sysInfoBuf := Buffer(SYSTEM_INFO_SIZE)

    DllCall("GetSystemInfo", "Ptr", sysInfoBuf.Ptr)

    ; Parse SYSTEM_INFO structure
    pageSize := NumGet(sysInfoBuf, 4, "UInt")
    numberOfProcessors := NumGet(sysInfoBuf, A_PtrSize = 8 ? 20 : 16, "UInt")

    ; Example 3: Get memory status using GlobalMemoryStatusEx
    MEMORYSTATUSEX_SIZE := 64
    memStatusBuf := Buffer(MEMORYSTATUSEX_SIZE)
    NumPut("UInt", MEMORYSTATUSEX_SIZE, memStatusBuf, 0)

    DllCall("GlobalMemoryStatusEx", "Ptr", memStatusBuf.Ptr)

    memoryLoad := NumGet(memStatusBuf, 4, "UInt")
    totalPhys := NumGet(memStatusBuf, 8, "UInt64")
    availPhys := NumGet(memStatusBuf, 16, "UInt64")

    ; Example 4: Generate random bytes using RtlGenRandom (SystemFunction036)
    randomBuf := Buffer(32)
    DllCall("Advapi32\SystemFunction036", "Ptr", randomBuf.Ptr, "UInt", 32)

    randomHex := ""
    loop 16 {
        randomHex .= Format("{:02X}", NumGet(randomBuf, A_Index - 1, "UChar"))
    }

    ; Display results
    result := "DllCall Integration Examples:`n`n"

    result .= "Computer Information:`n"
    result .= "  Name: " . computerName . "`n`n"

    result .= "System Information:`n"
    result .= "  Page Size: " . pageSize . " bytes`n"
    result .= "  Number of Processors: " . numberOfProcessors . "`n`n"

    result .= "Memory Status:`n"
    result .= "  Memory Load: " . memoryLoad . "%`n"
    result .= "  Total Physical: " . Round(totalPhys / 1024 / 1024 / 1024, 2) . " GB`n"
    result .= "  Available Physical: " . Round(availPhys / 1024 / 1024 / 1024, 2) . " GB`n`n"

    result .= "Cryptographically Random Bytes:`n"
    result .= "  " . randomHex . "..."

    MsgBox(result, "Example 5: DllCall Integration", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    Buffer Memory Management Examples

    1. Memory Copy Operations
    2. Memory Zeroing and Filling
    3. Memory Alignment
    4. Memory Pool Manager
    5. Advanced DllCall Integration

    Select an example (1-5) or press Cancel to exit:
    )"

    choice := InputBox(menu, "Buffer Memory Examples", "w400 h300")

    if choice.Result = "Cancel"
    return

    switch choice.Value {
        case "1": Example1_MemoryCopy()
        case "2": Example2_ZeroingAndFilling()
        case "3": Example3_MemoryAlignment()
        case "4": Example4_MemoryPool()
        case "5": Example5_DllCallIntegration()
        default: MsgBox("Invalid selection. Please choose 1-5.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()

; Moved class MemoryPool from nested scope
class MemoryPool {
    __New(blockSize, initialBlocks := 10) {
        this.blockSize := blockSize
        this.available := []
        this.inUse := Map()
        this.totalAllocated := 0
        this.allocCount := 0
        this.reuseCount := 0

        ; Pre-allocate initial blocks
        loop initialBlocks {
            this.available.Push(Buffer(blockSize))
            this.totalAllocated++
        }
    }

    ; Acquire a buffer from the pool
    Acquire() {
        if this.available.Length > 0 {
            buf := this.available.Pop()
            this.reuseCount++
        } else {
            buf := Buffer(this.blockSize)
            this.totalAllocated++
        }

        this.allocCount++
        this.inUse[buf.Ptr] := buf

        ; Zero the buffer before returning
        DllCall("RtlZeroMemory", "Ptr", buf.Ptr, "UPtr", buf.Size)

        return buf
    }

    ; Release a buffer back to the pool
    Release(buf) {
        if !this.inUse.Has(buf.Ptr)
        throw Error("Buffer not acquired from this pool")

        this.inUse.Delete(buf.Ptr)
        this.available.Push(buf)
    }

    ; Get pool statistics
    GetStats() {
        return {
            BlockSize: this.blockSize,
            TotalAllocated: this.totalAllocated,
            Available: this.available.Length,
            InUse: this.inUse.Count,
            AllocCount: this.allocCount,
            ReuseCount: this.reuseCount,
            ReuseRate: this.allocCount > 0
            ? Round((this.reuseCount / this.allocCount) * 100, 2)
            : 0
        }
    }

    ; Clear all buffers
    Clear() {
        this.available := []
        this.inUse := Map()
    }
}
