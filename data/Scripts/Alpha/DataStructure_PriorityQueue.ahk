#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Priority Queue - Min-heap implementation
; Demonstrates efficient priority-based retrieval

class PriorityQueue {
    __New() => this.heap := []

    Enqueue(item, priority) {
        this.heap.Push(Map("item", item, "priority", priority))
        this.BubbleUp(this.heap.Length)
    }

    Dequeue() {
        if !this.heap.Length
            return ""

        top := this.heap[1]
        last := this.heap.Pop()

        if this.heap.Length {
            this.heap[1] := last
            this.BubbleDown(1)
        }

        return top["item"]
    }

    BubbleUp(index) {
        while index > 1 {
            parent := index // 2
            if this.heap[parent]["priority"] <= this.heap[index]["priority"]
                break
            this.Swap(parent, index)
            index := parent
        }
    }

    BubbleDown(index) {
        loop {
            smallest := index
            left := index * 2
            right := left + 1

            if left <= this.heap.Length && this.heap[left]["priority"] < this.heap[smallest]["priority"]
                smallest := left
            if right <= this.heap.Length && this.heap[right]["priority"] < this.heap[smallest]["priority"]
                smallest := right

            if smallest = index
                break

            this.Swap(index, smallest)
            index := smallest
        }
    }

    Swap(i, j) {
        temp := this.heap[i]
        this.heap[i] := this.heap[j]
        this.heap[j] := temp
    }

    Peek() => this.heap.Length ? this.heap[1]["item"] : ""
    IsEmpty() => !this.heap.Length
    Size() => this.heap.Length
}

; Demo - task scheduling by priority
pq := PriorityQueue()

pq.Enqueue("Low priority task", 10)
pq.Enqueue("Critical bug fix", 1)
pq.Enqueue("Medium priority feature", 5)
pq.Enqueue("Another critical issue", 1)
pq.Enqueue("Nice to have", 8)

result := "Processing tasks by priority:`n"
while !pq.IsEmpty()
    result .= "- " pq.Dequeue() "`n"

MsgBox(result)
