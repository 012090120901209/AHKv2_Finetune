#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Doubly Linked List - Bidirectional traversal
; Demonstrates two-way node linking

class DoublyLinkedList {
    class Node {
        __New(value) {
            this.value := value
            this.next := ""
            this.prev := ""
        }
    }

    __New() {
        this.head := ""
        this.tail := ""
        this.length := 0
    }

    Append(value) {
        node := DoublyLinkedList.Node(value)
        if !this.head {
            this.head := node
            this.tail := node
        } else {
            node.prev := this.tail
            this.tail.next := node
            this.tail := node
        }
        this.length++
        return this
    }

    Prepend(value) {
        node := DoublyLinkedList.Node(value)
        if !this.head {
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
        if index <= 0
            return this.Prepend(value)
        if index >= this.length
            return this.Append(value)

        node := DoublyLinkedList.Node(value)
        current := this.head
        Loop index - 1
            current := current.next

        node.next := current.next
        node.prev := current
        current.next.prev := node
        current.next := node
        this.length++
        return this
    }

    RemoveAt(index) {
        if index < 0 || index >= this.length || !this.head
            return ""

        if index = 0 {
            value := this.head.value
            this.head := this.head.next
            if this.head
                this.head.prev := ""
            else
                this.tail := ""
            this.length--
            return value
        }

        current := this.head
        Loop index
            current := current.next

        value := current.value
        if current.prev
            current.prev.next := current.next
        if current.next
            current.next.prev := current.prev
        if current = this.tail
            this.tail := current.prev

        this.length--
        return value
    }

    Get(index) {
        if index < 0 || index >= this.length
            return ""

        ; Optimize by traversing from closer end
        if index < this.length / 2 {
            current := this.head
            Loop index
                current := current.next
        } else {
            current := this.tail
            Loop this.length - 1 - index
                current := current.prev
        }
        return current.value
    }

    ToArray() {
        arr := []
        current := this.head
        while current {
            arr.Push(current.value)
            current := current.next
        }
        return arr
    }

    ToArrayReverse() {
        arr := []
        current := this.tail
        while current {
            arr.Push(current.value)
            current := current.prev
        }
        return arr
    }

    __Enum(varCount) {
        current := this.head
        if varCount = 1
            return (&value) => current ? (value := current.value, current := current.next, true) : false
        else
            return Enum2

        Enum2(&index, &value) {
            static i := 0
            if current {
                index := i++
                value := current.value
                current := current.next
                return true
            }
            i := 0
            return false
        }
    }
}

; Demo
dll := DoublyLinkedList()
dll.Append("B").Append("D").Prepend("A").InsertAt(2, "C")

result := "Forward: "
for v in dll
    result .= v " "

result .= "`nReverse: "
for v in dll.ToArrayReverse()
    result .= v " "

MsgBox(result)

; Random access
MsgBox("Get(0): " dll.Get(0) "`nGet(2): " dll.Get(2) "`nGet(3): " dll.Get(3))

; Remove
removed := dll.RemoveAt(1)
result := "Removed '" removed "': "
for v in dll
    result .= v " "

MsgBox(result)
