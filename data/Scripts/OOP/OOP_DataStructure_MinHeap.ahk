#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP Data Structure: Min Heap (Priority Queue)
; Demonstrates: Heap property, heapify operations, priority queue

class MinHeap {
    __New() => this.heap := []

    Insert(value) {
        this.heap.Push(value)
        this._HeapifyUp(this.heap.Length)
        return this
    }

    ExtractMin() {
        if (this.IsEmpty())
        return ""

        min := this.heap[1]
        last := this.heap.Pop()

        if (this.heap.Length > 0) {
            this.heap[1] := last
            this._HeapifyDown(1)
        }

        return min
    }

    Peek() => this.IsEmpty() ? "" : this.heap[1]

    IsEmpty() => this.heap.Length = 0

    Size() => this.heap.Length

    _HeapifyUp(index) {
        if (index <= 1)
        return

        parentIndex := index // 2

        if (this.heap[index] < this.heap[parentIndex]) {
            ; Swap
            temp := this.heap[index]
            this.heap[index] := this.heap[parentIndex]
            this.heap[parentIndex] := temp

            this._HeapifyUp(parentIndex)
        }
    }

    _HeapifyDown(index) {
        smallest := index
        leftChild := 2 * index
        rightChild := 2 * index + 1

        if (leftChild <= this.heap.Length && this.heap[leftChild] < this.heap[smallest])
        smallest := leftChild

        if (rightChild <= this.heap.Length && this.heap[rightChild] < this.heap[smallest])
        smallest := rightChild

        if (smallest != index) {
            temp := this.heap[index]
            this.heap[index] := this.heap[smallest]
            this.heap[smallest] := temp

            this._HeapifyDown(smallest)
        }
    }

    ToArray() => this.heap.Clone()

    ToString() => "[" . this.heap.Join(", ") . "]"
}

; Usage
heap := MinHeap()

; Insert elements
heap.Insert(10).Insert(5).Insert(20).Insert(1).Insert(15).Insert(30).Insert(3)
MsgBox("Heap: " . heap.ToString() . "`nSize: " . heap.Size())

; Peek min
MsgBox("Minimum element: " . heap.Peek())

; Extract min elements
MsgBox("Extract min: " . heap.ExtractMin() . "`nHeap: " . heap.ToString())
MsgBox("Extract min: " . heap.ExtractMin() . "`nHeap: " . heap.ToString())
MsgBox("Extract min: " . heap.ExtractMin() . "`nHeap: " . heap.ToString())

; Priority queue simulation
tasks := MinHeap()
tasks.Insert({priority: 3, name: "Low priority task"})
.Insert({priority: 1, name: "Critical task"})
.Insert({priority: 2, name: "Medium priority task"})
.Insert({priority: 1, name: "Another critical task"})

MsgBox("Processing tasks by priority...")
while (!tasks.IsEmpty()) {
    task := tasks.ExtractMin()
    MsgBox("Processing: " . task.name . " (Priority: " . task.priority . ")")
}
