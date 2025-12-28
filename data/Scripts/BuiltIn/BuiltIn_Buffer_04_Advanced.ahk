#Requires AutoHotkey v2.0

/**
 * BuiltIn_Buffer_04_Advanced.ahk
 * 
 * DESCRIPTION:
 * Advanced Buffer techniques including circular buffers, ring buffers, memory-mapped
 * patterns, and high-performance data processing scenarios.
 * 
 * FEATURES:
 * - Circular/ring buffer implementation
 * - Double buffering for rendering
 * - Memory-mapped file simulation
 * - Bit manipulation in buffers
 * - Custom allocator patterns
 * - Zero-copy techniques
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Advanced Buffer Techniques
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Advanced pointer arithmetic
 * - Efficient memory reuse strategies
 * - Bit-level buffer operations
 * - Performance optimization patterns
 * - Thread-safe buffer concepts
 * 
 * LEARNING POINTS:
 * 1. Circular buffers enable efficient FIFO without memory reallocation
 * 2. Double buffering prevents tearing in rendering scenarios
 * 3. Bit manipulation allows compact data storage
 * 4. Memory reuse patterns reduce allocation overhead
 * 5. Understanding buffer internals enables advanced optimizations
 */

; ================================================================================================
; EXAMPLE 1: Circular/Ring Buffer
; ================================================================================================
; Implements a circular buffer for efficient FIFO operations

Example1_CircularBuffer() {

    ; Create circular buffer with capacity of 5
    cb := CircularBuffer(5)

    ; Add elements
    operations := "Operations:`n"
    loop 5 {
        cb.Enqueue(A_Index * 10)
        operations .= "  Enqueue(" . (A_Index * 10) . ")`n"
    }

    state1 := "After 5 enqueues: " . ArrayToString(cb.GetAll())

    ; Remove 2 elements
    val1 := cb.Dequeue()
    val2 := cb.Dequeue()
    operations .= "  Dequeue() -> " . val1 . "`n"
    operations .= "  Dequeue() -> " . val2 . "`n"

    state2 := "After 2 dequeues: " . ArrayToString(cb.GetAll())

    ; Add 3 more elements (wraps around)
    cb.Enqueue(60)
    cb.Enqueue(70)
    cb.Enqueue(80)
    operations .= "  Enqueue(60), Enqueue(70), Enqueue(80)`n"

    state3 := "After wrapping around: " . ArrayToString(cb.GetAll())

    ; Helper function
    ArrayToString(arr) {
        str := "["
        for val in arr {
            str .= val . (A_Index < arr.Length ? ", " : "")
        }
        return str . "]"
    }

    ; Display results
    result := "Circular Buffer Example:`n`n"
    result .= "Capacity: " . cb.GetCapacity() . " elements`n`n"
    result .= operations . "`n"
    result .= "States:`n"
    result .= "  " . state1 . "`n"
    result .= "  " . state2 . "`n"
    result .= "  " . state3 . "`n`n"
    result .= "Current size: " . cb.GetSize() . "/" . cb.GetCapacity()

    MsgBox(result, "Example 1: Circular Buffer", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: Double Buffering
; ================================================================================================
; Demonstrates double buffering technique for smooth rendering

Example2_DoubleBuffering() {

    ; Create a small framebuffer
    db := DoubleBuffer(50, 50)

    ; Clear to blue background
    db.Clear(0, 0, 128)

    ; Draw some lines in back buffer
    db.DrawLine(0, 0, 49, 49, 255, 255, 0)      ; Yellow diagonal
    db.DrawLine(49, 0, 0, 49, 255, 0, 255)      ; Magenta diagonal
    db.DrawLine(0, 25, 49, 25, 0, 255, 0)       ; Green horizontal
    db.DrawLine(25, 0, 25, 49, 255, 0, 0)       ; Red vertical

    ; Swap buffers
    swapped := db.Swap()

    ; Read some pixels from front buffer
    center := db.GetPixel(25, 25)
    corner := db.GetPixel(0, 0)
    edge := db.GetPixel(25, 0)

    ; Display results
    result := "Double Buffering Example:`n`n"
    result .= "Framebuffer: " . db.width . "x" . db.height . " pixels`n"
    result .= "Buffer size: " . (db.width * db.height * 4) . " bytes each`n`n"

    result .= "Operations:`n"
    result .= "  1. Cleared back buffer to blue`n"
    result .= "  2. Drew 4 colored lines`n"
    result .= "  3. Swapped buffers: " . (swapped ? "Success" : "No changes") . "`n`n"

    result .= "Sample Pixels (from front buffer):`n"
    result .= "  Center (25,25): RGB(" . center.r . "," . center.g . "," . center.b . ")`n"
    result .= "  Corner (0,0): RGB(" . corner.r . "," . corner.g . "," . corner.b . ")`n"
    result .= "  Edge (25,0): RGB(" . edge.r . "," . edge.g . "," . edge.b . ")`n`n"

    result .= "Back buffer dirty: " . (db.isBackBufferDirty ? "Yes" : "No")

    MsgBox(result, "Example 2: Double Buffering", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Bit Manipulation in Buffers
; ================================================================================================
; Shows techniques for working with individual bits in buffers

Example3_BitManipulation() {

    ; Create bit array with 32 bits
    bits := BitArray(32)

    ; Set some bits
    bits.SetBit(0)
    bits.SetBit(7)
    bits.SetBit(15)
    bits.SetBit(23)
    bits.SetBit(31)

    state1 := bits.ToString()

    ; Toggle some bits
    bits.ToggleBit(7)   ; Clear
    bits.ToggleBit(8)   ; Set
    bits.ToggleBit(16)  ; Set

    state2 := bits.ToString()

    ; Clear a bit
    bits.ClearBit(0)

    state3 := bits.ToString()

    ; Count set bits
    setBitCount := bits.CountSetBits()

    ; Display results
    result := "Bit Manipulation Example:`n`n"
    result .= "Bit Array: 32 bits (" . bits.numBytes . " bytes)`n`n"

    result .= "Operations:`n"
    result .= "  1. Set bits: 0, 7, 15, 23, 31`n"
    result .= "     " . state1 . "`n`n"

    result .= "  2. Toggle bits: 7, 8, 16`n"
    result .= "     " . state2 . "`n`n"

    result .= "  3. Clear bit: 0`n"
    result .= "     " . state3 . "`n`n"

    result .= "Statistics:`n"
    result .= "  Set bits: " . setBitCount . "/32`n"
    result .= "  Memory usage: " . bits.numBytes . " bytes`n"
    result .= "  Bits per byte: 8 (efficient storage)"

    MsgBox(result, "Example 3: Bit Manipulation", "Icon!")
}

; ================================================================================================
; EXAMPLE 4: Memory-Mapped Pattern
; ================================================================================================
; Simulates memory-mapped file operations using buffers

Example4_MemoryMapped() {

    ; Create memory-mapped file (1 KB)
    mmf := MemoryMappedFile(1024)

    ; Write some data
    writeOps := ""

    ; Write a header (magic number + version)
    mmf.WriteInt(0, 0x4D4D4658)  ; "MMFX" magic
    mmf.WriteInt(4, 1)            ; Version 1
    writeOps .= "  Wrote header at offset 0`n"

    ; Write some records at different offsets
    mmf.WriteInt(100, 12345)
    mmf.WriteInt(104, 67890)
    writeOps .= "  Wrote records at offset 100`n"

    mmf.WriteInt(200, 99999)
    mmf.WriteInt(204, 11111)
    writeOps .= "  Wrote records at offset 200`n"

    ; Read back data
    magic := mmf.ReadInt(0)
    version := mmf.ReadInt(4)
    record1 := mmf.ReadInt(100)
    record2 := mmf.ReadInt(104)
    record3 := mmf.ReadInt(200)
    record4 := mmf.ReadInt(204)

    ; Flush to "disk"
    bytesWritten := mmf.Flush()

    ; Display results
    result := "Memory-Mapped File Simulation:`n`n"
    result .= "File Size: " . mmf.size . " bytes`n`n"

    result .= "Write Operations:`n" . writeOps . "`n"

    result .= "Read Operations:`n"
    result .= "  Header:`n"
    result .= "    Magic: 0x" . Format("{:08X}", magic) . "`n"
    result .= "    Version: " . version . "`n`n"

    result .= "  Records:`n"
    result .= "    Offset 100: " . record1 . ", " . record2 . "`n"
    result .= "    Offset 200: " . record3 . ", " . record4 . "`n`n"

    result .= "Flush Result:`n"
    result .= "  Bytes written: " . bytesWritten . "`n"
    result .= "  Dirty after flush: " . (mmf.IsDirty() ? "Yes" : "No")

    MsgBox(result, "Example 4: Memory-Mapped Pattern", "Icon!")
}

; ================================================================================================
; EXAMPLE 5: High-Performance Data Processor
; ================================================================================================
; Demonstrates efficient batch processing using buffers

Example5_HighPerformance() {

    ; Create test data
    testData := []
    loop 10000 {
        testData.Push(Random(1, 1000))
    }

    ; Process data
    processor := DataProcessor()

    ; Method 1: Regular processing
    time1 := processor.ProcessIntegers(testData)
    results1 := processor.GetResults()

    ; Method 2: Batch processing
    time2 := processor.ProcessBatch(testData, 4)
    results2 := processor.GetResults()

    ; Verify results match
    resultsMatch := true
    loop Min(results1.Length, results2.Length) {
        if results1[A_Index] != results2[A_Index] {
            resultsMatch := false
            break
        }
    }

    ; Display results
    result := "High-Performance Data Processor:`n`n"
    result .= "Input: " . testData.Length . " integers`n"
    result .= "Operation: value * 2 + 10`n`n"

    result .= "Performance Comparison:`n"
    result .= "  Regular processing: " . time1 . "ms`n"
    result .= "  Batch processing (4x): " . time2 . "ms`n"

    if time1 > 0
        result .= "  Speedup: " . Round(time1 / time2, 2) . "x`n`n"
    else
        result .= "`n"

    result .= "Sample Results (first 10):`n"
    result .= "  Input:  "
    loop 10 {
        result .= testData[A_Index] . " "
    }
    result .= "`n  Output: "
    loop 10 {
        result .= results1[A_Index] . " "
    }
    result .= "`n`n"

    result .= "Verification:`n"
    result .= "  Results match: " . (resultsMatch ? "Yes" : "No") . "`n"
    result .= "  Total processed: " . processor.processCount . " values"

    MsgBox(result, "Example 5: High-Performance Processing", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    Advanced Buffer Techniques

    1. Circular/Ring Buffer
    2. Double Buffering
    3. Bit Manipulation in Buffers
    4. Memory-Mapped Pattern
    5. High-Performance Data Processor

    Select an example (1-5) or press Cancel to exit:
    )"

    choice := InputBox(menu, "Advanced Buffer Examples", "w400 h300")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_CircularBuffer()
        case "2": Example2_DoubleBuffering()
        case "3": Example3_BitManipulation()
        case "4": Example4_MemoryMapped()
        case "5": Example5_HighPerformance()
        default: MsgBox("Invalid selection. Please choose 1-5.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()

; Moved class CircularBuffer from nested scope
class CircularBuffer {
    __New(capacity) {
        this.buffer := Buffer(capacity * 4)  ; Store integers
        this.capacity := capacity
        this.size := 0
        this.head := 0  ; Write position
        this.tail := 0  ; Read position
    }

    ; Add element to buffer
    Enqueue(value) {
        if this.IsFull()
            throw Error("Buffer is full")

        NumPut("Int", value, this.buffer, this.head * 4)
        this.head := Mod(this.head + 1, this.capacity)
        this.size++
        return true
    }

    ; Remove and return element from buffer
    Dequeue() {
        if this.IsEmpty()
            throw Error("Buffer is empty")

        value := NumGet(this.buffer, this.tail * 4, "Int")
        this.tail := Mod(this.tail + 1, this.capacity)
        this.size--
        return value
    }

    ; Peek at next element without removing
    Peek() {
        if this.IsEmpty()
            throw Error("Buffer is empty")
        return NumGet(this.buffer, this.tail * 4, "Int")
    }

    ; Check if buffer is empty
    IsEmpty() => this.size = 0

    ; Check if buffer is full
    IsFull() => this.size = this.capacity

    ; Get current size
    GetSize() => this.size

    ; Get capacity
    GetCapacity() => this.capacity

    ; Get all elements (without removing)
    GetAll() {
        result := []
        index := this.tail
        loop this.size {
            result.Push(NumGet(this.buffer, index * 4, "Int"))
            index := Mod(index + 1, this.capacity)
        }
        return result
    }

    ; Clear buffer
    Clear() {
        this.size := 0
        this.head := 0
        this.tail := 0
    }
}

; Moved class DoubleBuffer from nested scope
class DoubleBuffer {
    __New(width, height) {
        this.width := width
        this.height := height
        this.pixelSize := 4  ; RGBA

        ; Create two buffers
        bufferSize := width * height * this.pixelSize
        this.frontBuffer := Buffer(bufferSize)
        this.backBuffer := Buffer(bufferSize)

        ; Clear both buffers
        DllCall("RtlZeroMemory", "Ptr", this.frontBuffer.Ptr, "UPtr", bufferSize)
        DllCall("RtlZeroMemory", "Ptr", this.backBuffer.Ptr, "UPtr", bufferSize)

        this.isBackBufferDirty := false
    }

    ; Set pixel in back buffer (RGBA)
    SetPixel(x, y, r, g, b, a := 255) {
        if x < 0 || x >= this.width || y < 0 || y >= this.height
            return false

        offset := (y * this.width + x) * this.pixelSize
        NumPut("UChar", r, this.backBuffer, offset)
        NumPut("UChar", g, this.backBuffer, offset + 1)
        NumPut("UChar", b, this.backBuffer, offset + 2)
        NumPut("UChar", a, this.backBuffer, offset + 3)

        this.isBackBufferDirty := true
        return true
    }

    ; Get pixel from front buffer
    GetPixel(x, y) {
        if x < 0 || x >= this.width || y < 0 || y >= this.height
            return { r: 0, g: 0, b: 0, a: 0 }

        offset := (y * this.width + x) * this.pixelSize
        return {
            r: NumGet(this.frontBuffer, offset, "UChar"),
            g: NumGet(this.frontBuffer, offset + 1, "UChar"),
            b: NumGet(this.frontBuffer, offset + 2, "UChar"),
            a: NumGet(this.frontBuffer, offset + 3, "UChar")
        }
    }

    ; Swap buffers (present back buffer to front)
    Swap() {
        if !this.isBackBufferDirty
            return false

        ; Fast memory copy
        bufferSize := this.width * this.height * this.pixelSize
        DllCall("RtlMoveMemory"
            , "Ptr", this.frontBuffer.Ptr
            , "Ptr", this.backBuffer.Ptr
            , "UPtr", bufferSize)

        this.isBackBufferDirty := false
        return true
    }

    ; Clear back buffer
    Clear(r := 0, g := 0, b := 0, a := 255) {
        loop this.width * this.height {
            offset := (A_Index - 1) * this.pixelSize
            NumPut("UChar", r, this.backBuffer, offset)
            NumPut("UChar", g, this.backBuffer, offset + 1)
            NumPut("UChar", b, this.backBuffer, offset + 2)
            NumPut("UChar", a, this.backBuffer, offset + 3)
        }
        this.isBackBufferDirty := true
    }

    ; Draw a line (simple Bresenham)
    DrawLine(x1, y1, x2, y2, r, g, b) {
        dx := Abs(x2 - x1)
        dy := Abs(y2 - y1)
        sx := x1 < x2 ? 1 : -1
        sy := y1 < y2 ? 1 : -1
        err := dx - dy

        loop {
            this.SetPixel(x1, y1, r, g, b)

            if x1 = x2 && y1 = y2
                break

            e2 := 2 * err
            if e2 > -dy {
                err -= dy
                x1 += sx
            }
            if e2 < dx {
                err += dx
                y1 += sy
            }
        }
    }
}

; Moved class BitArray from nested scope
class BitArray {
    __New(numBits) {
        this.numBits := numBits
        this.numBytes := Ceil(numBits / 8)
        this.buffer := Buffer(this.numBytes)
        DllCall("RtlZeroMemory", "Ptr", this.buffer.Ptr, "UPtr", this.numBytes)
    }

    ; Set bit at index
    SetBit(index) {
        if index < 0 || index >= this.numBits
            return false

        byteIndex := index >> 3  ; Divide by 8
        bitIndex := index & 7    ; Modulo 8

        currentByte := NumGet(this.buffer, byteIndex, "UChar")
        newByte := currentByte | (1 << bitIndex)
        NumPut("UChar", newByte, this.buffer, byteIndex)
        return true
    }

    ; Clear bit at index
    ClearBit(index) {
        if index < 0 || index >= this.numBits
            return false

        byteIndex := index >> 3
        bitIndex := index & 7

        currentByte := NumGet(this.buffer, byteIndex, "UChar")
        newByte := currentByte & ~(1 << bitIndex)
        NumPut("UChar", newByte, this.buffer, byteIndex)
        return true
    }

    ; Get bit at index
    GetBit(index) {
        if index < 0 || index >= this.numBits
            return false

        byteIndex := index >> 3
        bitIndex := index & 7

        currentByte := NumGet(this.buffer, byteIndex, "UChar")
        return (currentByte & (1 << bitIndex)) != 0
    }

    ; Toggle bit at index
    ToggleBit(index) {
        if index < 0 || index >= this.numBits
            return false

        byteIndex := index >> 3
        bitIndex := index & 7

        currentByte := NumGet(this.buffer, byteIndex, "UChar")
        newByte := currentByte ^ (1 << bitIndex)
        NumPut("UChar", newByte, this.buffer, byteIndex)
        return true
    }

    ; Count set bits
    CountSetBits() {
        count := 0
        loop this.numBytes {
            byte := NumGet(this.buffer, A_Index - 1, "UChar")
            ; Brian Kernighan's algorithm
            while byte {
                byte &= byte - 1
                count++
            }
        }
        return count
    }

    ; Get string representation
    ToString(maxBits := 64) {
        str := ""
        limit := Min(this.numBits, maxBits)
        loop limit {
            str .= this.GetBit(A_Index - 1) ? "1" : "0"
            if Mod(A_Index, 8) = 0 && A_Index < limit
                str .= " "
        }
        if this.numBits > maxBits
            str .= "..."
        return str
    }
}

; Moved class MemoryMappedFile from nested scope
class MemoryMappedFile {
    __New(size) {
        this.buffer := Buffer(size)
        this.size := size
        this.dirty := false

        ; Initialize with zeros
        DllCall("RtlZeroMemory", "Ptr", this.buffer.Ptr, "UPtr", size)
    }

    ; Write data at offset
    Write(offset, data, dataSize) {
        if offset < 0 || offset + dataSize > this.size
            return false

        DllCall("RtlMoveMemory"
            , "Ptr", this.buffer.Ptr + offset
            , "Ptr", data.Ptr
            , "UPtr", dataSize)

        this.dirty := true
        return true
    }

    ; Read data from offset
    Read(offset, size) {
        if offset < 0 || offset + size > this.size
            return Buffer(0)

        result := Buffer(size)
        DllCall("RtlMoveMemory"
            , "Ptr", result.Ptr
            , "Ptr", this.buffer.Ptr + offset
            , "UPtr", size)

        return result
    }

    ; Write integer at offset
    WriteInt(offset, value) {
        if offset < 0 || offset + 4 > this.size
            return false

        NumPut("Int", value, this.buffer, offset)
        this.dirty := true
        return true
    }

    ; Read integer from offset
    ReadInt(offset) {
        if offset < 0 || offset + 4 > this.size
            return 0
        return NumGet(this.buffer, offset, "Int")
    }

    ; Flush changes (simulate writing to disk)
    Flush() {
        if !this.dirty
            return 0

        ; In real implementation, would write to file
        bytesWritten := this.size
        this.dirty := false
        return bytesWritten
    }

    ; Get dirty status
    IsDirty() => this.dirty
}

; Moved class DataProcessor from nested scope
class DataProcessor {
    __New() {
        this.inputBuffer := Buffer(0)
        this.outputBuffer := Buffer(0)
        this.processCount := 0
    }

    ; Process array of integers - transform each value
    ProcessIntegers(values) {
        count := values.Length
        this.inputBuffer := Buffer(count * 4)
        this.outputBuffer := Buffer(count * 4)

        ; Copy input values to buffer
        loop count {
            NumPut("Int", values[A_Index], this.inputBuffer, (A_Index - 1) * 4)
        }

        ; Process: multiply by 2 and add 10
        start := A_TickCount
        loop count {
            offset := (A_Index - 1) * 4
            value := NumGet(this.inputBuffer, offset, "Int")
            result := value * 2 + 10
            NumPut("Int", result, this.outputBuffer, offset)
        }
        elapsed := A_TickCount - start

        this.processCount := count
        return elapsed
    }

    ; Get results
    GetResults() {
        if this.processCount = 0
            return []

        results := []
        loop this.processCount {
            value := NumGet(this.outputBuffer, (A_Index - 1) * 4, "Int")
            results.Push(value)
        }
        return results
    }

    ; Process with SIMD-like pattern (process 4 at a time)
    ProcessBatch(values, batchSize := 4) {
        count := values.Length
        this.inputBuffer := Buffer(count * 4)
        this.outputBuffer := Buffer(count * 4)

        ; Copy input
        loop count {
            NumPut("Int", values[A_Index], this.inputBuffer, (A_Index - 1) * 4)
        }

        ; Process in batches
        start := A_TickCount
        fullBatches := count // batchSize

        ; Process full batches
        loop fullBatches {
            baseIndex := (A_Index - 1) * batchSize
            loop batchSize {
                offset := (baseIndex + A_Index - 1) * 4
                value := NumGet(this.inputBuffer, offset, "Int")
                result := value * 2 + 10
                NumPut("Int", result, this.outputBuffer, offset)
            }
        }

        ; Process remainder
        remainder := Mod(count, batchSize)
        if remainder > 0 {
            loop remainder {
                offset := (fullBatches * batchSize + A_Index - 1) * 4
                value := NumGet(this.inputBuffer, offset, "Int")
                result := value * 2 + 10
                NumPut("Int", result, this.outputBuffer, offset)
            }
        }

        elapsed := A_TickCount - start
        this.processCount := count
        return elapsed
    }
}
