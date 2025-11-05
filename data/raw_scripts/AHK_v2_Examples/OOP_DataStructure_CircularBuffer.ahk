#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; OOP Data Structure: Circular Buffer (Ring Buffer)
; Demonstrates: Fixed-size buffer, wrapping, efficient queue operations

class CircularBuffer {
    __New(capacity) {
        this.capacity := capacity
        this.buffer := []
        this.head := 0
        this.tail := 0
        this.size := 0

        loop capacity
            this.buffer.Push("")
    }

    Enqueue(value) {
        if (this.IsFull())
            throw Error("Buffer is full")

        this.buffer[this.tail + 1] := value  ; +1 for 1-based indexing
        this.tail := Mod(this.tail + 1, this.capacity)
        this.size++

        return this
    }

    EnqueueOverwrite(value) {
        this.buffer[this.tail + 1] := value
        this.tail := Mod(this.tail + 1, this.capacity)

        if (this.IsFull())
            this.head := Mod(this.head + 1, this.capacity)
        else
            this.size++

        return this
    }

    Dequeue() {
        if (this.IsEmpty())
            throw Error("Buffer is empty")

        value := this.buffer[this.head + 1]
        this.head := Mod(this.head + 1, this.capacity)
        this.size--

        return value
    }

    Peek() {
        if (this.IsEmpty())
            return ""
        return this.buffer[this.head + 1]
    }

    IsEmpty() => this.size = 0

    IsFull() => this.size = this.capacity

    Size() => this.size

    Capacity() => this.capacity

    Clear() => (this.head := 0, this.tail := 0, this.size := 0, this)

    ToArray() {
        arr := []
        index := this.head
        loop this.size {
            arr.Push(this.buffer[index + 1])
            index := Mod(index + 1, this.capacity)
        }
        return arr
    }

    ToString() => "[" . this.ToArray().Join(", ") . "] (" . this.size . "/" . this.capacity . ")"
}

; Usage
buffer := CircularBuffer(5)

; Enqueue elements
buffer.Enqueue("A").Enqueue("B").Enqueue("C")
MsgBox("Buffer: " . buffer.ToString())

; Dequeue
MsgBox("Dequeued: " . buffer.Dequeue() . "`nBuffer: " . buffer.ToString())

; Fill buffer
buffer.Enqueue("D").Enqueue("E").Enqueue("F")
MsgBox("Full buffer: " . buffer.ToString())

; Try to enqueue when full (will error)
try
    buffer.Enqueue("G")
catch Error as e
    MsgBox("Error: " . e.Message)

; Overwrite mode
buffer.EnqueueOverwrite("G")  ; Overwrites oldest
MsgBox("After overwrite: " . buffer.ToString())

; Dequeue all
result := ""
while (!buffer.IsEmpty())
    result .= buffer.Dequeue() . " "
MsgBox("Dequeued all: " . result . "`nBuffer: " . buffer.ToString())

; Use case: Logging with fixed size
logBuffer := CircularBuffer(10)

; Simulate logging
loop 15 {
    logBuffer.EnqueueOverwrite("Log entry #" . A_Index)
}

MsgBox("Last 10 log entries:`n" . logBuffer.ToArray().Join("`n"))
