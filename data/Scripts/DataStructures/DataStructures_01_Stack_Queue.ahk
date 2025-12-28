#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Custom Data Structures - Stack and Queue
 * 
 * Demonstrates implementing Stack (LIFO) and Queue (FIFO) data structures
 * using AutoHotkey v2 Arrays as the underlying storage.
 * 
 * Source: AHK_Notes/Concepts/data-structures-in-ahk-v2.md
 */

; Test Stack (LIFO - Last In First Out)
myStack := Stack()
myStack.Push("First")
myStack.Push("Second")
myStack.Push("Third")

MsgBox("Stack (LIFO) Test:`n`n"
    . "Push: First, Second, Third`n"
    . "Size: " myStack.Size() "`n"
    . "Peek: " myStack.Peek() "`n"
    . "Pop: " myStack.Pop() "`n"
    . "Pop: " myStack.Pop() "`n"
    . "Size: " myStack.Size(), , "T5")

; Test Queue (FIFO - First In First Out)
myQueue := Queue()
myQueue.Enqueue("Task 1")
myQueue.Enqueue("Task 2")
myQueue.Enqueue("Task 3")

MsgBox("Queue (FIFO) Test:`n`n"
    . "Enqueue: Task 1, Task 2, Task 3`n"
    . "Size: " myQueue.Size() "`n"
    . "Peek: " myQueue.Peek() "`n"
    . "Dequeue: " myQueue.Dequeue() "`n"
    . "Dequeue: " myQueue.Dequeue() "`n"
    . "Size: " myQueue.Size(), , "T5")

; Test practical use case: Undo/Redo
undoStack := Stack()
redoStack := Stack()

; Simulate actions
DoAction("Create File", undoStack, redoStack)
DoAction("Edit Text", undoStack, redoStack)
DoAction("Save File", undoStack, redoStack)

MsgBox("Undo/Redo Demo:`n`n"
    . "Actions: Create, Edit, Save`n"
    . "Undo stack: " undoStack.Size() " items", , "T2")

; Undo twice
undone := Undo(undoStack, redoStack)
MsgBox("Undo: " undone, , "T2")
undone := Undo(undoStack, redoStack)
MsgBox("Undo: " undone, , "T2")

; Redo once
redone := Redo(undoStack, redoStack)
MsgBox("Redo: " redone, , "T2")

/**
 * Stack - LIFO Data Structure
 */
class Stack {
    items := []

    /**
     * Push item onto stack
     */
    Push(item) {
        this.items.Push(item)
    }

    /**
     * Pop item from stack
     * @return {any} Top item or empty string if empty
     */
    Pop() {
        if (this.IsEmpty())
            throw Error("Stack is empty")
        return this.items.Pop()
    }

    /**
     * Peek at top item without removing
     */
    Peek() {
        if (this.IsEmpty())
            return ""
        return this.items[this.items.Length]
    }

    /**
     * Check if stack is empty
     */
    IsEmpty() {
        return this.items.Length == 0
    }

    /**
     * Get stack size
     */
    Size() {
        return this.items.Length
    }

    /**
     * Clear stack
     */
    Clear() {
        this.items := []
    }
}

/**
 * Queue - FIFO Data Structure
 */
class Queue {
    items := []

    /**
     * Add item to back of queue
     */
    Enqueue(item) {
        this.items.Push(item)
    }

    /**
     * Remove item from front of queue
     * @return {any} Front item or throws if empty
     */
    Dequeue() {
        if (this.IsEmpty())
            throw Error("Queue is empty")
        return this.items.RemoveAt(1)
    }

    /**
     * Peek at front item without removing
     */
    Peek() {
        if (this.IsEmpty())
            return ""
        return this.items[1]
    }

    /**
     * Check if queue is empty
     */
    IsEmpty() {
        return this.items.Length == 0
    }

    /**
     * Get queue size
     */
    Size() {
        return this.items.Length
    }

    /**
     * Clear queue
     */
    Clear() {
        this.items := []
    }
}

/**
 * DoAction - Simulate action with undo support
 */
DoAction(action, undoStack, redoStack) {
    undoStack.Push(action)
    redoStack.Clear()  ; Clear redo on new action
}

/**
 * Undo - Undo last action
 */
Undo(undoStack, redoStack) {
    if (undoStack.IsEmpty())
        return "Nothing to undo"

    action := undoStack.Pop()
    redoStack.Push(action)
    return action
}

/**
 * Redo - Redo last undone action
 */
Redo(undoStack, redoStack) {
    if (redoStack.IsEmpty())
        return "Nothing to redo"

    action := redoStack.Pop()
    undoStack.Push(action)
    return action
}

/*
* Key Concepts:
*
* 1. Stack (LIFO):
*    Push(item)  ; Add to top
*    Pop()       ; Remove from top
*    Peek()      ; View top without removing
*    Last in, first out
*
* 2. Queue (FIFO):
*    Enqueue(item)  ; Add to back
*    Dequeue()      ; Remove from front
*    Peek()         ; View front without removing
*    First in, first out
*
* 3. Implementation:
*    Both use Array as underlying storage
*    Stack: Push/Pop at end (fast)
*    Queue: Push at end, RemoveAt(1) from front
*
* 4. Use Cases:
*    Stack:
*    ✅ Undo/Redo systems
*    ✅ Function call stack
*    ✅ Expression evaluation
*    ✅ Backtracking algorithms
*
*    Queue:
*    ✅ Task scheduling
*    ✅ Event handling
*    ✅ Breadth-first search
*    ✅ Print job management
*
* 5. Performance:
*    Stack operations: O(1) - very fast
*    Queue Enqueue: O(1)
*    Queue Dequeue: O(n) - shifts array
*
* 6. Arrays in AHK v2:
*    1-indexed (not 0-indexed!)
*    Passed by reference
*    Dynamic sizing
*/

