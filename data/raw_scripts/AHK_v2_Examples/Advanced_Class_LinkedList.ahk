#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Linked List Data Structure
class Node {
    __New(data) {
        this.data := data
        this.next := ""
    }
}

class LinkedList {
    __New() {
        this.head := ""
        this.length := 0
    }
    
    Append(data) {
        node := Node(data)
        
        if (this.head = "") {
            this.head := node
        } else {
            current := this.head
            while (current.next != "") {
                current := current.next
            }
            current.next := node
        }
        
        this.length++
    }
    
    Prepend(data) {
        node := Node(data)
        node.next := this.head
        this.head := node
        this.length++
    }
    
    GetAt(index) {
        if (index < 0 || index >= this.length)
            return ""
        
        current := this.head
        Loop index {
            current := current.next
        }
        
        return current.data
    }
    
    ToArray() {
        arr := []
        current := this.head
        
        while (current != "") {
            arr.Push(current.data)
            current := current.next
        }
        
        return arr
    }
}

; Demo
list := LinkedList()
list.Append("First")
list.Append("Second")
list.Append("Third")
list.Prepend("Zero")

arr := list.ToArray()
MsgBox("List contents: " ArrayToString(arr))

ArrayToString(arr) {
    result := ""
    for item in arr {
        result .= (result ? ", " : "") item
    }
    return result
}
