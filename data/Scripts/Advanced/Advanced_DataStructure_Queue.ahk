#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced Data Structure Example: Queue Implementation
; Demonstrates: FIFO queue, dequeue operations, task queue simulation

; Queue class implementation
class Queue {
    __New() {
        this.items := []
    }

    ; Add item to back of queue
    Enqueue(item) {
        this.items.Push(item)
    }

    ; Remove and return item from front of queue
    Dequeue() {
        if (this.IsEmpty())
            throw Error("Queue is empty")
        return this.items.RemoveAt(1)
    }

    ; View front item without removing
    Peek() {
        if (this.IsEmpty())
            throw Error("Queue is empty")
        return this.items[1]
    }

    ; Check if queue is empty
    IsEmpty() {
        return this.items.Length = 0
    }

    ; Get queue size
    Size() {
        return this.items.Length
    }

    ; Clear all items
    Clear() {
        this.items := []
    }

    ; Get all items as array (for display)
    ToArray() {
        return this.items.Clone()
    }
}

; Priority Queue class
class PriorityQueue extends Queue {
    ; Enqueue with priority (lower number = higher priority)
    Enqueue(item, priority := 5) {
        element := { item: item, priority: priority }

        ; Find correct position based on priority
        inserted := false
        Loop this.items.Length {
            if (priority < this.items[A_Index].priority) {
                this.items.InsertAt(A_Index, element)
                inserted := true
                break
            }
        }

        ; If not inserted, add to end
        if (!inserted)
            this.items.Push(element)
    }

    ; Override Dequeue to return just the item
    Dequeue() {
        if (this.IsEmpty())
            throw Error("Queue is empty")
        element := this.items.RemoveAt(1)
        return element.item
    }

    ; Override Peek
    Peek() {
        if (this.IsEmpty())
            throw Error("Queue is empty")
        return this.items[1].item
    }
}

; Create GUI for queue demonstration
Persistent

queueGui := Gui()
queueGui.Title := "Queue Data Structure Demo"

; Queue type selector
queueGui.Add("Text", "x10 y10", "Queue Type:")
queueType := queueGui.Add("DropDownList", "x100 y7 w150", ["FIFO Queue", "Priority Queue"])
queueType.Choose(1)
queueType.OnEvent("Change", SwitchQueueType)

; Input section
queueGui.Add("Text", "x10 y40", "Add Item:")
itemInput := queueGui.Add("Edit", "x100 y37 w200")
priorityInput := queueGui.Add("Edit", "x310 y37 w50 Number Disabled", "5")
queueGui.Add("Text", "x370 y40 Disabled vPriorityLabel", "Priority")
queueGui.Add("Button", "x450 y36 w100", "Enqueue").OnEvent("Click", EnqueueItem)

; Queue operations
queueGui.Add("Button", "x10 y75 w100", "Dequeue").OnEvent("Click", DequeueItem)
queueGui.Add("Button", "x120 y75 w100", "Peek").OnEvent("Click", PeekItem)
queueGui.Add("Button", "x230 y75 w100", "Clear").OnEvent("Click", ClearQueue)
queueGui.Add("Button", "x340 y75 w100", "Process All").OnEvent("Click", ProcessAll)

; Queue display
queueGui.Add("Text", "x10 y115", "Queue Contents (Front â†’ Back):")
queueDisplay := queueGui.Add("ListView", "x10 y135 w540 h200", ["Position", "Item", "Priority"])

; Stats
queueGui.Add("Text", "x10 y345", "Queue Size:")
sizeText := queueGui.Add("Edit", "x100 y342 w80 ReadOnly", "0")

queueGui.Add("Text", "x200 y345", "Total Processed:")
processedText := queueGui.Add("Edit", "x320 y342 w80 ReadOnly", "0")

; Activity log
queueGui.Add("Text", "x10 y375", "Activity Log:")
logDisplay := queueGui.Add("Edit", "x10 y395 w540 h100 ReadOnly Multi")

queueGui.Show("w560 h510")

; Global variables
global demoQueue := Queue()
global totalProcessed := 0
global activityLog := ""

SwitchQueueType(*) {
    global demoQueue

    qType := queueType.Text

    if (qType = "Priority Queue") {
        demoQueue := PriorityQueue()
        priorityInput.Enabled := true
        try queueGui["PriorityLabel"].Enabled := true
    } else {
        demoQueue := Queue()
        priorityInput.Enabled := false
        try queueGui["PriorityLabel"].Enabled := false
    }

    ClearQueue()
}

EnqueueItem(*) {
    global demoQueue

    item := Trim(itemInput.Value)

    if (item = "") {
        MsgBox("Please enter an item!", "Error")
        return
    }

    try {
        if (queueType.Text = "Priority Queue") {
            priority := Integer(priorityInput.Value)
            demoQueue.Enqueue(item, priority)
            LogActivity("Enqueued: " item " (Priority: " priority ")")
        } else {
            demoQueue.Enqueue(item)
            LogActivity("Enqueued: " item)
        }

        itemInput.Value := ""
        UpdateDisplay()
    } catch Error as err {
        MsgBox("Error: " err.Message, "Error")
    }
}

DequeueItem(*) {
    global demoQueue, totalProcessed

    try {
        item := demoQueue.Dequeue()
        totalProcessed++
        LogActivity("Dequeued: " item)
        UpdateDisplay()
        MsgBox("Dequeued: " item, "Success")
    } catch Error as err {
        MsgBox(err.Message, "Error")
    }
}

PeekItem(*) {
    global demoQueue

    try {
        item := demoQueue.Peek()
        LogActivity("Peeked: " item)
        MsgBox("Next item: " item, "Peek")
    } catch Error as err {
        MsgBox(err.Message, "Error")
    }
}

ClearQueue(*) {
    global demoQueue

    demoQueue.Clear()
    LogActivity("Queue cleared")
    UpdateDisplay()
}

ProcessAll(*) {
    global demoQueue, totalProcessed

    if (demoQueue.IsEmpty()) {
        MsgBox("Queue is empty!", "Error")
        return
    }

    count := demoQueue.Size()

    while (!demoQueue.IsEmpty()) {
        item := demoQueue.Dequeue()
        totalProcessed++
        Sleep(100)  ; Simulate processing time
    }

    LogActivity("Processed all " count " items")
    UpdateDisplay()
    MsgBox("Processed " count " items", "Complete")
}

UpdateDisplay() {
    global demoQueue, sizeText, processedText

    ; Update size
    sizeText.Value := demoQueue.Size()
    processedText.Value := totalProcessed

    ; Update ListView
    queueDisplay.Delete()

    items := demoQueue.ToArray()

    for i, element in items {
        if (queueType.Text = "Priority Queue") {
            queueDisplay.Add(, i, element.item, element.priority)
        } else {
            queueDisplay.Add(, i, element, "-")
        }
    }

    queueDisplay.ModifyCol()
}

LogActivity(message) {
    global activityLog

    timestamp := FormatTime(, "HH:mm:ss")
    entry := "[" timestamp "] " message "`n"
    activityLog .= entry

    ; Keep only last 20 entries
    lines := StrSplit(activityLog, "`n")
    if (lines.Length > 20) {
        activityLog := ""
        Loop lines.Length - 20 {
            activityLog .= lines[A_Index + lines.Length - 20] "`n"
        }
    }

    logDisplay.Value := activityLog
}
