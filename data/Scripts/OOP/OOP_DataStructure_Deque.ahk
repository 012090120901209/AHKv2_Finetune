#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Deque (Double-Ended Queue)
; Demonstrates: Insertion/deletion at both ends, flexible queue

class Deque {
    __New() => this.items := []

    AddFront(value) {
        this.items.InsertAt(1, value)
        return this
    }

    AddRear(value) {
        this.items.Push(value)
        return this
    }

    RemoveFront() {
        if (this.IsEmpty())
            throw Error("Deque is empty")
        return this.items.RemoveAt(1)
    }

    RemoveRear() {
        if (this.IsEmpty())
            throw Error("Deque is empty")
        return this.items.Pop()
    }

    PeekFront() => this.IsEmpty() ? "" : this.items[1]

    PeekRear() => this.IsEmpty() ? "" : this.items[this.items.Length]

    IsEmpty() => this.items.Length = 0

    Size() => this.items.Length

    Clear() => (this.items := [], this)

    Contains(value) {
        for item in this.items
            if (item = value)
                return true
        return false
    }

    ToArray() => this.items.Clone()

    ToString() => "[" . this.items.Join(", ") . "]"
}

; Palindrome checker using deque
IsPalindrome(str) {
    dequeobj := Deque()

    ; Add all characters
    loop parse str
        if (A_LoopField != " ")
            dequeobj .AddRear(StrLower(A_LoopField))

    ; Check palindrome
    while (dequeobj .Size() > 1) {
        if (dequeobj .RemoveFront() != dequeobj .RemoveRear())
            return false
    }

    return true
}

; Usage
dequeobj := Deque()

; Add elements
dequeobj .AddRear(1).AddRear(2).AddRear(3)
MsgBox("Deque after AddRear: " . dequeobj .ToString())

dequeobj .AddFront(0).AddFront(-1)
MsgBox("Deque after AddFront: " . dequeobj .ToString())

; Peek
MsgBox("Front: " . dequeobj .PeekFront() . "`nRear: " . dequeobj .PeekRear())

; Remove
MsgBox("Removed from front: " . dequeobj .RemoveFront() . "`nDeque: " . dequeobj .ToString())
MsgBox("Removed from rear: " . dequeobj .RemoveRear() . "`nDeque: " . dequeobj .ToString())

; Palindrome checker
MsgBox("Is 'racecar' a palindrome? " . (IsPalindrome("racecar") ? "Yes" : "No"))
MsgBox("Is 'hello' a palindrome? " . (IsPalindrome("hello") ? "Yes" : "No"))
MsgBox("Is 'A man a plan a canal Panama' a palindrome? " . (IsPalindrome("A man a plan a canal Panama") ? "Yes" : "No"))

; Sliding window maximum
FindMaxInWindow(arr, k) {
    result := []
    dequeobj := Deque()

    loop arr.Length {
        i := A_Index

        ; Remove elements outside window
        while (!dequeobj .IsEmpty() && dequeobj .PeekFront() < i - k + 1)
            dequeobj .RemoveFront()

        ; Remove smaller elements from rear
        while (!dequeobj .IsEmpty() && arr[dequeobj .PeekRear()] < arr[i])
            dequeobj .RemoveRear()

        dequeobj .AddRear(i)

        ; Add to result when window is complete
        if (i >= k)
            result.Push(arr[dequeobj .PeekFront()])
    }

    return result
}

nums := [1, 3, -1, -3, 5, 3, 6, 7]
maxInWindow := FindMaxInWindow(nums, 3)
MsgBox("Array: " . nums.Join(", ") . "`nMax in sliding window (k=3): " . maxInWindow.Join(", "))
