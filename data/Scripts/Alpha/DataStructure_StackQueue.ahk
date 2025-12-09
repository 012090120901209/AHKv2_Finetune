#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Stack and Queue - Basic LIFO and FIFO structures
; Demonstrates fundamental container patterns

class Stack {
    __New() => this.items := []

    Push(value) {
        this.items.Push(value)
        return this
    }

    Pop() {
        if this.IsEmpty()
            throw Error("Stack is empty")
        return this.items.Pop()
    }

    Peek() {
        if this.IsEmpty()
            throw Error("Stack is empty")
        return this.items[this.items.Length]
    }

    IsEmpty() => this.items.Length = 0
    Size() => this.items.Length
    Clear() => this.items := []

    ToArray() {
        arr := []
        Loop this.items.Length
            arr.Push(this.items[this.items.Length - A_Index + 1])
        return arr
    }

    __Enum(varCount) {
        idx := this.items.Length + 1
        return (&value) => --idx > 0 ? (value := this.items[idx], true) : false
    }
}

class Queue {
    __New() => this.items := []

    Enqueue(value) {
        this.items.Push(value)
        return this
    }

    Dequeue() {
        if this.IsEmpty()
            throw Error("Queue is empty")
        return this.items.RemoveAt(1)
    }

    Peek() {
        if this.IsEmpty()
            throw Error("Queue is empty")
        return this.items[1]
    }

    IsEmpty() => this.items.Length = 0
    Size() => this.items.Length
    Clear() => this.items := []
    ToArray() => this.items.Clone()

    __Enum(varCount) {
        idx := 0
        items := this.items
        return (&value) => ++idx <= items.Length ? (value := items[idx], true) : false
    }
}

; Deque - Double-ended queue
class Deque {
    __New() => this.items := []

    PushFront(value) {
        this.items.InsertAt(1, value)
        return this
    }

    PushBack(value) {
        this.items.Push(value)
        return this
    }

    PopFront() {
        if this.IsEmpty()
            throw Error("Deque is empty")
        return this.items.RemoveAt(1)
    }

    PopBack() {
        if this.IsEmpty()
            throw Error("Deque is empty")
        return this.items.Pop()
    }

    PeekFront() => this.IsEmpty() ? "" : this.items[1]
    PeekBack() => this.IsEmpty() ? "" : this.items[this.items.Length]
    IsEmpty() => this.items.Length = 0
    Size() => this.items.Length
}

; Demo - Stack (LIFO)
myStack := Stack()
myStack.Push("first").Push("second").Push("third")

result := "Stack (LIFO):`n"
result .= "Peek: " myStack.Peek() "`n"
result .= "Pop order: "
while !myStack.IsEmpty()
    result .= myStack.Pop() " "

MsgBox(result)

; Demo - Queue (FIFO)
myQueue := Queue()
myQueue.Enqueue("first").Enqueue("second").Enqueue("third")

result := "Queue (FIFO):`n"
result .= "Peek: " myQueue.Peek() "`n"
result .= "Dequeue order: "
while !myQueue.IsEmpty()
    result .= myQueue.Dequeue() " "

MsgBox(result)

; Demo - Deque
myDeque := Deque()
myDeque.PushBack("B").PushFront("A").PushBack("C")

result := "Deque:`nFront: " myDeque.PeekFront() "`nBack: " myDeque.PeekBack()
result .= "`nPop from both ends: "
result .= myDeque.PopFront() " ... " myDeque.PopBack()

MsgBox(result)
