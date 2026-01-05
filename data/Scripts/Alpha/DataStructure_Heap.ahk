#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Binary Heap / Priority Queue - Min/Max heap implementation
; Demonstrates efficient priority-based operations

class BinaryHeap {
    __New(comparator := "") {
        this.heap := []
        ; Default: min-heap (smaller values have higher priority)
        this.comparator := comparator ? comparator : (a, b) => a < b
    }

    ; Factory methods
    static MinHeap() => BinaryHeap((a, b) => a < b)
    static MaxHeap() => BinaryHeap((a, b) => a > b)

    Push(value) {
        this.heap.Push(value)
        this._bubbleUp(this.heap.Length)
        return this
    }

    Pop() {
        if !this.heap.Length
            return ""

        top := this.heap[1]
        last := this.heap.Pop()

        if this.heap.Length {
            this.heap[1] := last
            this._bubbleDown(1)
        }

        return top
    }

    Peek() => this.heap.Length ? this.heap[1] : ""

    Count() => this.heap.Length

    IsEmpty() => !this.heap.Length

    _bubbleUp(index) {
        while index > 1 {
            parent := index // 2
            if this.comparator(this.heap[index], this.heap[parent]) {
                this._swap(index, parent)
                index := parent
            } else {
                break
            }
        }
    }

    _bubbleDown(index) {
        size := this.heap.Length

        Loop {
            left := index * 2
            right := index * 2 + 1
            best := index

            if left <= size && this.comparator(this.heap[left], this.heap[best])
                best := left

            if right <= size && this.comparator(this.heap[right], this.heap[best])
                best := right

            if best != index {
                this._swap(index, best)
                index := best
            } else {
                break
            }
        }
    }

    _swap(i, j) {
        temp := this.heap[i]
        this.heap[i] := this.heap[j]
        this.heap[j] := temp
    }

    ToArray() => this.heap.Clone()
}

; Priority Queue with priorities
class PriorityQueue {
    __New(minPriority := true) {
        comparator := minPriority
            ? (a, b) => a["priority"] < b["priority"]
            : (a, b) => a["priority"] > b["priority"]
        this.heap := BinaryHeap(comparator)
    }

    Enqueue(item, priority) {
        this.heap.Push(Map("item", item, "priority", priority))
        return this
    }

    Dequeue() {
        entry := this.heap.Pop()
        return entry ? entry["item"] : ""
    }

    Peek() {
        entry := this.heap.Peek()
        return entry ? entry["item"] : ""
    }

    PeekPriority() {
        entry := this.heap.Peek()
        return entry ? entry["priority"] : ""
    }

    Count() => this.heap.Count()
    IsEmpty() => this.heap.IsEmpty()
}

; Demo - Min Heap
minHeap := BinaryHeap.MinHeap()

values := [5, 2, 8, 1, 9, 3, 7, 4, 6]
for v in values
    minHeap.Push(v)

result := "Min Heap Demo:`n`n"
result .= "Inserted: "
for i, v in values
    result .= (i > 1 ? ", " : "") v

result .= "`n`nExtracted (should be sorted ascending):`n"
while !minHeap.IsEmpty()
    result .= minHeap.Pop() " "

MsgBox(result)

; Demo - Max Heap
maxHeap := BinaryHeap.MaxHeap()

for v in values
    maxHeap.Push(v)

result := "Max Heap Demo:`n`n"
result .= "Inserted: "
for i, v in values
    result .= (i > 1 ? ", " : "") v

result .= "`n`nExtracted (should be sorted descending):`n"
while !maxHeap.IsEmpty()
    result .= maxHeap.Pop() " "

MsgBox(result)

; Demo - Priority Queue (task scheduler)
tasks := PriorityQueue(true)  ; Min priority = highest priority (1 is urgent)

; Add tasks with priorities (1 = highest, 5 = lowest)
tasks.Enqueue("Critical bug fix", 1)
tasks.Enqueue("Code review", 3)
tasks.Enqueue("Update docs", 5)
tasks.Enqueue("Security patch", 1)
tasks.Enqueue("Feature request", 4)
tasks.Enqueue("Refactor module", 3)

result := "Priority Queue - Task Scheduler:`n`n"
result .= "Tasks in priority order:`n`n"

while !tasks.IsEmpty() {
    task := tasks.Dequeue()
    result .= task "`n"
}

MsgBox(result)

; Demo - Heap with custom objects
class TaskItem {
    __New(name, deadline) {
        this.name := name
        this.deadline := deadline
    }
}

; Sort by deadline (earlier = higher priority)
deadlineHeap := BinaryHeap((a, b) => a.deadline < b.deadline)

deadlineHeap.Push(TaskItem("Task A", 20250115))
deadlineHeap.Push(TaskItem("Task B", 20250110))
deadlineHeap.Push(TaskItem("Task C", 20250120))
deadlineHeap.Push(TaskItem("Task D", 20250105))
deadlineHeap.Push(TaskItem("Task E", 20250112))

result := "Custom Object Heap (by deadline):`n`n"
while !deadlineHeap.IsEmpty() {
    item := deadlineHeap.Pop()
    result .= Format("{} (deadline: {})`n", item.name, item.deadline)
}

MsgBox(result)

; Demo - Top K elements
numbers := [64, 34, 25, 12, 22, 11, 90, 87, 45, 67, 23, 56, 78, 89]
k := 5

; Use max heap of size k for top-k smallest
; Actually, for top-k smallest, use min-heap to extract all then take first k
; For efficiency, use max-heap of size k

result := "Top " k " Smallest Elements:`n`n"
result .= "Input: "
for i, v in numbers
    result .= (i > 1 ? ", " : "") v

; Simple approach: use heap sort then take first k
minHeap := BinaryHeap.MinHeap()
for v in numbers
    minHeap.Push(v)

result .= "`n`nTop " k " smallest: "
Loop k {
    if minHeap.IsEmpty()
        break
    result .= minHeap.Pop() " "
}

MsgBox(result)
