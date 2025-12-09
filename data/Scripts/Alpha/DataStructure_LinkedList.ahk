#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Linked List - Singly linked list with common operations
; Demonstrates node-based data structure

class LinkedList {
    class Node {
        __New(value) {
            this.value := value
            this.next := ""
        }
    }

    __New() {
        this.head := ""
        this.tail := ""
        this.length := 0
    }

    Append(value) {
        node := LinkedList.Node(value)
        if !this.head {
            this.head := node
            this.tail := node
        } else {
            this.tail.next := node
            this.tail := node
        }
        this.length++
        return this
    }

    Prepend(value) {
        node := LinkedList.Node(value)
        if !this.head {
            this.head := node
            this.tail := node
        } else {
            node.next := this.head
            this.head := node
        }
        this.length++
        return this
    }

    Get(index) {
        if index < 0 || index >= this.length
            return ""

        current := this.head
        Loop index
            current := current.next
        return current.value
    }

    Remove(value) {
        if !this.head
            return false

        if this.head.value = value {
            this.head := this.head.next
            if !this.head
                this.tail := ""
            this.length--
            return true
        }

        current := this.head
        while current.next {
            if current.next.value = value {
                if current.next = this.tail
                    this.tail := current
                current.next := current.next.next
                this.length--
                return true
            }
            current := current.next
        }
        return false
    }

    Contains(value) {
        current := this.head
        while current {
            if current.value = value
                return true
            current := current.next
        }
        return false
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

    Reverse() {
        prev := ""
        current := this.head
        this.tail := this.head

        while current {
            next := current.next
            current.next := prev
            prev := current
            current := next
        }
        this.head := prev
        return this
    }

    __Enum(varCount) {
        current := this.head
        return (&value) => current ? (value := current.value, current := current.next, true) : false
    }
}

; Demo
list := LinkedList()
list.Append(1).Append(2).Append(3).Prepend(0)

result := "List: "
for value in list
    result .= value " "

result .= "`nLength: " list.length
result .= "`nGet(2): " list.Get(2)
result .= "`nContains(5): " list.Contains(5)

MsgBox(result)

; Reverse
list.Reverse()
result := "Reversed: "
for value in list
    result .= value " "

MsgBox(result)

; Remove
list.Remove(2)
arr := list.ToArray()
result := "After removing 2: "
for v in arr
    result .= v " "

MsgBox(result)
