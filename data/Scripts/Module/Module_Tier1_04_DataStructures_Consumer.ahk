#Requires AutoHotkey v2.1-alpha.17

/**
* Module Tier 1 Example 04: DataStructures Consumer
*
* This example demonstrates:
* - Importing and using module classes
* - Creating instances from exported classes
* - Using class methods
* - Error handling with module classes
*
* USAGE: Run this file directly
*
* @requires Module_Tier1_03_DataStructures_Module.ahk
*/

#SingleInstance Force

; Import DataStructures module with alias
Import DataStructures as DS

; ============================================================
; Example 1: Stack (LIFO)
; ============================================================

stack := DS.Stack()

; Push items
stack.Push("First")
stack.Push("Second")
stack.Push("Third")

MsgBox("Stack size: " stack.Size()
. "`nPeek (top): " stack.Peek(),
"Stack - After Pushing", "Icon!")

; Pop items (LIFO - Last In, First Out)
result := "Popping items:`n"
result .= stack.Pop() " (should be: Third)`n"
result .= stack.Pop() " (should be: Second)`n"
result .= stack.Pop() " (should be: First)`n"
result .= "`nStack is empty: " (stack.IsEmpty() ? "Yes" : "No")

MsgBox(result, "Stack - LIFO Behavior", "Icon!")

; ============================================================
; Example 2: Queue (FIFO)
; ============================================================

queue := DS.Queue()

; Enqueue items
queue.Enqueue("First")
queue.Enqueue("Second")
queue.Enqueue("Third")

MsgBox("Queue size: " queue.Size()
. "`nPeek (front): " queue.Peek(),
"Queue - After Enqueuing", "Icon!")

; Dequeue items (FIFO - First In, First Out)
result := "Dequeuing items:`n"
result .= queue.Dequeue() " (should be: First)`n"
result .= queue.Dequeue() " (should be: Second)`n"
result .= queue.Dequeue() " (should be: Third)`n"
result .= "`nQueue is empty: " (queue.IsEmpty() ? "Yes" : "No")

MsgBox(result, "Queue - FIFO Behavior", "Icon!")

; ============================================================
; Example 3: Cache
; ============================================================

cache := DS.Cache(3)  ; Max 3 items

; Store data
cache.Set("user1", "Alice")
cache.Set("user2", "Bob")
cache.Set("user3", "Charlie")

MsgBox("Cache size: " cache.Size()
. "`nuser1: " cache.Get("user1")
. "`nuser2: " cache.Get("user2")
. "`nuser3: " cache.Get("user3"),
"Cache - Initial Data", "Icon!")

; Add 4th item (should evict oldest)
cache.Set("user4", "David")

MsgBox("After adding user4:`n"
. "Cache size: " cache.Size()
. "`nuser1: " (cache.Has("user1") ? cache.Get("user1") : "EVICTED")
. "`nuser2: " cache.Get("user2")
. "`nuser3: " cache.Get("user3")
. "`nuser4: " cache.Get("user4"),
"Cache - LRU Behavior", "Icon!")

; ============================================================
; Example 4: Counter
; ============================================================

counter := DS.Counter(0)

; Increment
counter.Increment()
counter.Increment(5)
counter.Increment(3)

MsgBox("After increments:`n"
. "Count: " counter.Value()
. " (should be: 9)",
"Counter - Increment", "Icon!")

; Decrement
counter.Decrement(2)

MsgBox("After decrement by 2:`n"
. "Count: " counter.Value()
. " (should be: 7)",
"Counter - Decrement", "Icon!")

; Reset
counter.Reset()

MsgBox("After reset:`n"
. "Count: " counter.Value()
. " (should be: 0)",
"Counter - Reset", "Icon!")

; ============================================================
; Example 5: Error Handling
; ============================================================

emptyStack := DS.Stack()

try {
    emptyStack.Pop()  ; Should throw error
    MsgBox("No error thrown?", "Error", "Icon!")
} catch as err {
    MsgBox("Successfully caught error:`n" err.Message,
    "Error Handling - Stack", "Icon!")
}

emptyQueue := DS.Queue()

try {
    emptyQueue.Dequeue()  ; Should throw error
    MsgBox("No error thrown?", "Error", "Icon!")
} catch as err {
    MsgBox("Successfully caught error:`n" err.Message,
    "Error Handling - Queue", "Icon!")
}

; ============================================================
; Example 6: Practical Use Case - Undo/Redo
; ============================================================

class TextEditor {
    text := ""
    undoStack := ""
    redoStack := ""

    __New() {
        ; Import DataStructures into the class
        global DS
        this.undoStack := DS.Stack()
        this.redoStack := DS.Stack()
    }

    Write(newText) {
        ; Save current state to undo stack
        this.undoStack.Push(this.text)
        this.text := newText
        ; Clear redo stack when new action performed
        this.redoStack.Clear()
    }

    Undo() {
        if this.undoStack.IsEmpty()
        return false
        ; Save current to redo
        this.redoStack.Push(this.text)
        ; Restore previous
        this.text := this.undoStack.Pop()
        return true
    }

    Redo() {
        if this.redoStack.IsEmpty()
        return false
        ; Save current to undo
        this.undoStack.Push(this.text)
        ; Restore next
        this.text := this.redoStack.Pop()
        return true
    }

    GetText() {
        return this.text
    }
}

editor := TextEditor()

editor.Write("Hello")
editor.Write("Hello World")
editor.Write("Hello World!")

result := "Current text: " editor.GetText() "`n`n"

editor.Undo()
result .= "After 1 undo: " editor.GetText() "`n"

editor.Undo()
result .= "After 2 undo: " editor.GetText() "`n"

editor.Redo()
result .= "After 1 redo: " editor.GetText() "`n"

MsgBox(result, "Practical Use Case - Undo/Redo", "Icon!")
