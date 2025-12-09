#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Doubly Linked List
; Demonstrates: Bidirectional traversal, prev/next pointers

class DNode {
    __New(value) => (this.value := value, this.next := "", this.prev := "")
}

class DoublyLinkedList {
    __New() => (this.head := "", this.tail := "", this.length := 0)

    Append(value) {
        node := DNode(value)

        if (!this.head) {
            this.head := node
            this.tail := node
        } else {
            this.tail.next := node
            node.prev := this.tail
            this.tail := node
        }

        this.length++
        return this
    }

    Prepend(value) {
        node := DNode(value)

        if (!this.head) {
            this.head := node
            this.tail := node
        } else {
            node.next := this.head
            this.head.prev := node
            this.head := node
        }

        this.length++
        return this
    }

    InsertAt(index, value) {
        if (index < 0 || index > this.length)
        return false
        if (index = 0)
        return this.Prepend(value)
        if (index = this.length)
        return this.Append(value)

        node := DNode(value)
        current := this.GetNodeAt(index)

        node.next := current
        node.prev := current.prev
        current.prev.next := node
        current.prev := node

        this.length++
        return this
    }

    RemoveAt(index) {
        if (index < 0 || index >= this.length)
        return false

        if (index = 0) {
            this.head := this.head.next
            if (this.head)
            this.head.prev := ""
            else
            this.tail := ""
        } else if (index = this.length - 1) {
            this.tail := this.tail.prev
            if (this.tail)
            this.tail.next := ""
            else
            this.head := ""
        } else {
            current := this.GetNodeAt(index)
            current.prev.next := current.next
            current.next.prev := current.prev
        }

        this.length--
        return true
    }

    Get(index) {
        node := this.GetNodeAt(index)
        return node ? node.value : ""
    }

    GetNodeAt(index) {
        if (index < 0 || index >= this.length)
        return ""

        ; Optimize by choosing direction
        if (index < this.length // 2) {
            current := this.head
            loop index
            current := current.next
        } else {
            current := this.tail
            loop this.length - index - 1
            current := current.prev
        }

        return current
    }

    Reverse() {
        if (!this.head)
        return this

        current := this.head
        temp := ""

        while (current) {
            temp := current.prev
            current.prev := current.next
            current.next := temp
            current := current.prev
        }

        temp := this.head
        this.head := this.tail
        this.tail := temp

        return this
    }

    ToArray() {
        arr := []
        current := this.head
        while (current) {
            arr.Push(current.value)
            current := current.next
        }
        return arr
    }

    ToArrayReverse() {
        arr := []
        current := this.tail
        while (current) {
            arr.Push(current.value)
            current := current.prev
        }
        return arr
    }

    ToString() => this.ToArray().Join(" <-> ")
}

; Usage
list := DoublyLinkedList()

; Append and prepend
list.Append(10).Append(20).Append(30)
MsgBox("List: " . list.ToString())

list.Prepend(5)
MsgBox("After prepend: " . list.ToString())

; Insert
list.InsertAt(2, 15)
MsgBox("After insert at 2: " . list.ToString())

; Forward and backward traversal
MsgBox("Forward: " . list.ToArray().Join(", ") . "`nBackward: " . list.ToArrayReverse().Join(", "))

; Remove
list.RemoveAt(1)
MsgBox("After remove at 1: " . list.ToString())

; Reverse
list.Reverse()
MsgBox("After reverse: " . list.ToString())

list.Reverse()  ; Reverse back
MsgBox("Reversed back: " . list.ToString())
