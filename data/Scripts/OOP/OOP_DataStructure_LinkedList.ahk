#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Linked List
; Demonstrates: Nodes, pointers, insertion, deletion, traversal

class ListNode {
    __New(value) => (this.value := value, this.next := "")
    ToString() => String(this.value)
}

class LinkedList {
    __New() => (this.head := "", this.tail := "", this.length := 0)

    Append(value) {
        node := ListNode(value)
        if (!this.head) {
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
        node := ListNode(value)
        node.next := this.head
        this.head := node
        if (!this.tail)
        this.tail := node
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

        node := ListNode(value)
        prev := this.GetNodeAt(index - 1)
        node.next := prev.next
        prev.next := node
        this.length++
        return this
    }

    RemoveAt(index) {
        if (index < 0 || index >= this.length)
        return false

        if (index = 0) {
            this.head := this.head.next
            if (this.length = 1)
            this.tail := ""
        } else {
            prev := this.GetNodeAt(index - 1)
            prev.next := prev.next.next
            if (index = this.length - 1)
            this.tail := prev
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

        current := this.head
        loop index
        current := current.next
        return current
    }

    IndexOf(value) {
        current := this.head
        index := 0
        while (current) {
            if (current.value = value)
            return index
            current := current.next
            index++
        }
        return -1
    }

    Contains(value) => this.IndexOf(value) != -1

    Clear() => (this.head := "", this.tail := "", this.length := 0, this)

    ToArray() {
        arr := []
        current := this.head
        while (current) {
            arr.Push(current.value)
            current := current.next
        }
        return arr
    }

    ToString() => this.ToArray().Join(" -> ")
}

; Usage
list := LinkedList()

; Append elements
list.Append(10).Append(20).Append(30).Append(40)
MsgBox("List: " . list.ToString() . "`nLength: " . list.length)

; Prepend
list.Prepend(5)
MsgBox("After prepend: " . list.ToString())

; Insert at index
list.InsertAt(3, 25)
MsgBox("After insert at 3: " . list.ToString())

; Get element
MsgBox("Element at index 2: " . list.Get(2))

; Find index
MsgBox("Index of 25: " . list.IndexOf(25))

; Contains
MsgBox("Contains 30? " . (list.Contains(30) ? "Yes" : "No"))
MsgBox("Contains 100? " . (list.Contains(100) ? "Yes" : "No"))

; Remove
list.RemoveAt(3)
MsgBox("After removing index 3: " . list.ToString())

; Convert to array
arr := list.ToArray()
MsgBox("As array: [" . arr.Join(", ") . "]")
