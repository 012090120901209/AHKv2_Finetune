#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Circular Buffer / Ring Buffer - Fixed-size FIFO
; Demonstrates efficient bounded queue

class CircularBuffer {
    __New(capacity) {
        this.capacity := capacity
        this.buffer := []
        this.head := 0      ; Write position
        this.tail := 0      ; Read position
        this.count := 0     ; Current item count
        
        ; Pre-allocate buffer
        Loop capacity
            this.buffer.Push("")
    }

    Push(value) {
        index := Mod(this.head, this.capacity) + 1
        this.buffer[index] := value
        this.head++
        
        if this.count < this.capacity {
            this.count++
        } else {
            ; Overwrite oldest (move tail)
            this.tail++
        }
        
        return this
    }

    Pop() {
        if !this.count
            return ""

        index := Mod(this.tail, this.capacity) + 1
        value := this.buffer[index]
        this.tail++
        this.count--
        
        return value
    }

    Peek() {
        if !this.count
            return ""
        index := Mod(this.tail, this.capacity) + 1
        return this.buffer[index]
    }

    PeekLast() {
        if !this.count
            return ""
        index := Mod(this.head - 1, this.capacity) + 1
        return this.buffer[index]
    }

    IsFull() => this.count = this.capacity
    IsEmpty() => this.count = 0
    Count() => this.count
    Capacity() => this.capacity

    ; Get item by index (0 = oldest)
    Get(index) {
        if index < 0 || index >= this.count
            return ""
        actualIndex := Mod(this.tail + index, this.capacity) + 1
        return this.buffer[actualIndex]
    }

    ; Convert to array (oldest to newest)
    ToArray() {
        arr := []
        Loop this.count
            arr.Push(this.Get(A_Index - 1))
        return arr
    }

    Clear() {
        this.head := 0
        this.tail := 0
        this.count := 0
        return this
    }
}

; Sliding Window Statistics using circular buffer
class SlidingWindow {
    __New(size) {
        this.buffer := CircularBuffer(size)
        this.sum := 0
    }

    Add(value) {
        ; If full, subtract the value being overwritten
        if this.buffer.IsFull()
            this.sum -= this.buffer.Peek()
        
        this.buffer.Push(value)
        this.sum += value
        return this
    }

    Average() {
        if this.buffer.IsEmpty()
            return 0
        return this.sum / this.buffer.Count()
    }

    Sum() => this.sum

    Min() {
        if this.buffer.IsEmpty()
            return ""
        
        minVal := this.buffer.Get(0)
        Loop this.buffer.Count() - 1 {
            val := this.buffer.Get(A_Index)
            if val < minVal
                minVal := val
        }
        return minVal
    }

    Max() {
        if this.buffer.IsEmpty()
            return ""
        
        maxVal := this.buffer.Get(0)
        Loop this.buffer.Count() - 1 {
            val := this.buffer.Get(A_Index)
            if val > maxVal
                maxVal := val
        }
        return maxVal
    }

    Values() => this.buffer.ToArray()
    Count() => this.buffer.Count()
}

; Demo - Basic circular buffer
buffer := CircularBuffer(5)

result := "Circular Buffer Demo (capacity: 5):`n`n"

; Add items
Loop 7 {
    buffer.Push(A_Index * 10)
    result .= Format("Push {}: [{}]`n", A_Index * 10, _join(buffer.ToArray()))
}

result .= "`nBuffer full: " buffer.IsFull() "`n"
result .= "Oldest (peek): " buffer.Peek() "`n"
result .= "Newest (peekLast): " buffer.PeekLast() "`n"

_join(arr, sep := ", ") {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") v
    return result
}

MsgBox(result)

; Demo - Pop operations
result := "Pop Operations:`n`n"
result .= "Before: [" _join(buffer.ToArray()) "]`n`n"

Loop 3 {
    popped := buffer.Pop()
    result .= Format("Pop: {} → [{}]`n", popped, _join(buffer.ToArray()))
}

MsgBox(result)

; Demo - Sliding window average
window := SlidingWindow(5)

result := "Sliding Window Average Demo:`n`n"
result .= "Window size: 5`n`n"

values := [10, 20, 30, 40, 50, 60, 70, 80]
for value in values {
    window.Add(value)
    result .= Format("Add {}: avg={:.1f}, sum={}, [{}]`n", 
        value, 
        window.Average(),
        window.Sum(),
        _join(window.Values()))
}

MsgBox(result)

; Demo - Sliding window statistics
window2 := SlidingWindow(4)

values := [15, 7, 23, 11, 18, 9, 25, 13]

result := "Sliding Window Statistics:`n`n"
result .= "Window size: 4`n`n"

for value in values {
    window2.Add(value)
    result .= Format("Add {}: min={}, max={}, avg={:.1f}`n",
        value,
        window2.Min(),
        window2.Max(),
        window2.Average())
}

MsgBox(result)

; Demo - Log buffer use case
logBuffer := CircularBuffer(10)

; Simulate log entries
logs := [
    "[INFO] Application started",
    "[DEBUG] Loading config",
    "[INFO] Connected to database",
    "[WARN] High memory usage",
    "[DEBUG] Query executed",
    "[ERROR] Connection timeout",
    "[INFO] Reconnecting...",
    "[INFO] Connection restored",
    "[DEBUG] Cache cleared",
    "[INFO] Processing request",
    "[DEBUG] Response sent",
    "[WARN] Slow query detected",
    "[INFO] Request completed"
]

for log in logs
    logBuffer.Push(log)

result := "Log Buffer Use Case:`n`n"
result .= "Last 10 log entries (most recent at bottom):`n`n"

for log in logBuffer.ToArray()
    result .= log "`n"

result .= "`n(Older entries automatically discarded)"

MsgBox(result)
