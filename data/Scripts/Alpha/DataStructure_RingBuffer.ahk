#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Ring Buffer - Fixed-size circular queue
; Demonstrates efficient FIFO with bounded memory

class RingBuffer {
    __New(capacity) {
        this.capacity := capacity
        this.buffer := []
        Loop capacity
            this.buffer.Push("")
        this.head := 1
        this.tail := 1
        this.count := 0
    }

    Push(item) {
        this.buffer[this.tail] := item
        this.tail := Mod(this.tail, this.capacity) + 1

        if this.count < this.capacity
            this.count++
        else
            this.head := Mod(this.head, this.capacity) + 1
    }

    Pop() {
        if this.count = 0
            return ""

        item := this.buffer[this.head]
        this.head := Mod(this.head, this.capacity) + 1
        this.count--
        return item
    }

    Peek() => this.count > 0 ? this.buffer[this.head] : ""
    PeekLast() => this.count > 0 ? this.buffer[Mod(this.tail - 2 + this.capacity, this.capacity) + 1] : ""
    
    IsFull() => this.count = this.capacity
    IsEmpty() => this.count = 0
    Size() => this.count
    
    ToArray() {
        result := []
        if this.count = 0
            return result
        
        i := this.head
        Loop this.count {
            result.Push(this.buffer[i])
            i := Mod(i, this.capacity) + 1
        }
        return result
    }
}

; Demo - log buffer
logBuffer := RingBuffer(5)

; Add logs
Loop 8 {
    logBuffer.Push("Log entry " A_Index)
    arr := logBuffer.ToArray()
    
    content := ""
    for item in arr
        content .= item ", "
    
    OutputDebug("After push " A_Index ": [" content "]`n")
}

MsgBox("Buffer keeps last 5 entries:`n" 
     . "Size: " logBuffer.Size() "`n"
     . "Full: " logBuffer.IsFull() "`n`n"
     . "Contents: " logBuffer.ToArray()[1] " ... " logBuffer.PeekLast())
