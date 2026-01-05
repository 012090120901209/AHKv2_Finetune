#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Stack with Min/Max Tracking
; Demonstrates: O(1) min/max operations, auxiliary stacks

class MinMaxStack {
    __New() => (this.stack := [], this.minStack := [], this.maxStack := [])

    Push(value) {
        this.stack.Push(value)

        ; Update min stack
        if (this.minStack.Length = 0 || value <= this.GetMin())
            this.minStack.Push(value)

        ; Update max stack
        if (this.maxStack.Length = 0 || value >= this.GetMax())
            this.maxStack.Push(value)

        return this
    }

    Pop() {
        if (this.IsEmpty())
            throw Error("Stack is empty")

        value := this.stack.Pop()

        if (value = this.GetMin())
            this.minStack.Pop()

        if (value = this.GetMax())
            this.maxStack.Pop()

        return value
    }

    Peek() => this.IsEmpty() ? "" : this.stack[this.stack.Length]

    GetMin() => this.minStack.Length > 0 ? this.minStack[this.minStack.Length] : ""

    GetMax() => this.maxStack.Length > 0 ? this.maxStack[this.maxStack.Length] : ""

    IsEmpty() => this.stack.Length = 0

    Size() => this.stack.Length

    Clear() => (this.stack := [], this.minStack := [], this.maxStack := [], this)

    ToArray() => this.stack.Clone()

    ToString() => "[" . this.stack.Join(", ") . "] | Min: " . this.GetMin() . " | Max: " . this.GetMax()
}

; Usage
stack := MinMaxStack()

; Push values
stack.Push(5).Push(2).Push(8).Push(1).Push(9)
MsgBox("Stack: " . stack.ToString())

; Get min and max
MsgBox("Current Min: " . stack.GetMin() . "`nCurrent Max: " . stack.GetMax())

; Pop and check min/max
MsgBox("Popped: " . stack.Pop() . "`nStack: " . stack.ToString())
MsgBox("Popped: " . stack.Pop() . "`nStack: " . stack.ToString())

; Min and max should update
MsgBox("After pops:`nMin: " . stack.GetMin() . "`nMax: " . stack.GetMax())

; More operations
stack.Push(0).Push(10)
MsgBox("After adding 0 and 10:`nStack: " . stack.ToString())

; Use case: Stock prices
prices := MinMaxStack()
prices.Push(100).Push(95).Push(105).Push(90).Push(110)

MsgBox("Stock Prices: " . prices.ToArray().Join(", ") . "`n`nLowest: $" . prices.GetMin() . "`nHighest: $" . prices.GetMax())
