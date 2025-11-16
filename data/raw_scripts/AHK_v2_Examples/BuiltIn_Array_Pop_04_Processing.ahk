#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * Array.Pop() - Data Processing and Queue Operations
 * ============================================================================
 *
 * This file demonstrates using Pop() for various data processing tasks,
 * queue operations, and batch processing scenarios.
 *
 * @description Data processing patterns using Array.Pop()
 * @author AutoHotkey v2 Documentation
 * @version 1.0.0
 * @date 2025-01-16
 */

; ============================================================================
; Example 1: Task Queue Processing
; ============================================================================
; Process tasks from a queue using Pop()
Example1_TaskQueueProcessing() {
    OutputDebug("=== Example 1: Task Queue Processing ===`n")

    taskQueue := TaskQueue()

    ; Add tasks
    taskQueue.Enqueue({id: 1, name: "Send Email", priority: 2})
    taskQueue.Enqueue({id: 2, name: "Process Payment", priority: 1})
    taskQueue.Enqueue({id: 3, name: "Update Database", priority: 3})
    taskQueue.Enqueue({id: 4, name: "Generate Report", priority: 2})
    taskQueue.Enqueue({id: 5, name: "Cleanup Cache", priority: 4})

    OutputDebug("Tasks in queue: " taskQueue.Size() "`n`n")

    ; Process all tasks
    OutputDebug("Processing tasks:`n")
    processedCount := 0

    while (!taskQueue.IsEmpty()) {
        task := taskQueue.Dequeue()
        processedCount++

        OutputDebug("  [" processedCount "] " task.name
                    " (Priority: " task.priority ")`n")
        OutputDebug("      Remaining: " taskQueue.Size() "`n")
    }

    OutputDebug("`nAll " processedCount " tasks processed!`n`n")
}

; ============================================================================
; Example 2: Batch Processing with Pop
; ============================================================================
; Process data in batches
Example2_BatchProcessing() {
    OutputDebug("=== Example 2: Batch Processing ===`n")

    ; Large dataset
    dataSet := []
    Loop 25 {
        dataSet.Push({id: A_Index, value: "Item " A_Index})
    }

    OutputDebug("Total items: " dataSet.Length "`n")

    batchSize := 5
    batchNumber := 1

    ; Process in batches
    OutputDebug("Processing in batches of " batchSize ":`n`n")

    while (dataSet.Length > 0) {
        OutputDebug("Batch " batchNumber ":`n")

        currentBatch := []
        Loop batchSize {
            if (dataSet.Length = 0) {
                break
            }
            currentBatch.Push(dataSet.Pop())
        }

        ; Process batch
        for item in currentBatch {
            OutputDebug("  - Processing: " item.value "`n")
        }

        OutputDebug("  Batch complete | Remaining: " dataSet.Length "`n`n")
        batchNumber++
    }

    OutputDebug("All batches processed!`n`n")
}

; ============================================================================
; Example 3: Message Queue Processing
; ============================================================================
; Handle message queue with different message types
Example3_MessageQueueProcessing() {
    OutputDebug("=== Example 3: Message Queue Processing ===`n")

    messageQueue := []

    ; Add various messages
    messageQueue.Push({type: "INFO", message: "System started"})
    messageQueue.Push({type: "WARNING", message: "Low memory"})
    messageQueue.Push({type: "ERROR", message: "Connection failed"})
    messageQueue.Push({type: "INFO", message: "Task completed"})
    messageQueue.Push({type: "CRITICAL", message: "Security breach"})

    OutputDebug("Messages in queue: " messageQueue.Length "`n`n")

    ; Process messages by type
    criticalMessages := []
    errors := []
    warnings := []
    info := []

    while (messageQueue.Length > 0) {
        msg := messageQueue.Pop()

        switch msg.type {
            case "CRITICAL":
                criticalMessages.Push(msg)
            case "ERROR":
                errors.Push(msg)
            case "WARNING":
                warnings.Push(msg)
            case "INFO":
                info.Push(msg)
        }
    }

    OutputDebug("Message classification:`n")
    OutputDebug("  Critical: " criticalMessages.Length "`n")
    OutputDebug("  Errors: " errors.Length "`n")
    OutputDebug("  Warnings: " warnings.Length "`n")
    OutputDebug("  Info: " info.Length "`n`n")

    ; Process critical first
    OutputDebug("Processing critical messages:`n")
    for msg in criticalMessages {
        OutputDebug("  ! " msg.message "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: File Processing Queue
; ============================================================================
; Process files from a queue
Example4_FileProcessingQueue() {
    OutputDebug("=== Example 4: File Processing Queue ===`n")

    fileQueue := []

    ; Simulate files to process
    fileQueue.Push({name: "document1.txt", size: 1024, type: "text"})
    fileQueue.Push({name: "image1.jpg", size: 2048, type: "image"})
    fileQueue.Push({name: "video1.mp4", size: 10240, type: "video"})
    fileQueue.Push({name: "document2.pdf", size: 512, type: "document"})
    fileQueue.Push({name: "archive.zip", size: 5120, type: "archive"})

    OutputDebug("Files in queue: " fileQueue.Length "`n")

    totalSize := 0
    for file in fileQueue {
        totalSize += file.size
    }

    OutputDebug("Total size: " totalSize " KB`n`n")

    ; Process files
    OutputDebug("Processing files:`n")
    processed := 0
    totalProcessed := 0

    while (fileQueue.Length > 0) {
        file := fileQueue.Pop()
        processed++
        totalProcessed += file.size

        OutputDebug("  [" processed "] " file.name
                    " (" file.size " KB) - " file.type "`n")
        OutputDebug("      Progress: " Round((totalProcessed / totalSize) * 100, 1) "%`n")
    }

    OutputDebug("`nAll files processed!`n`n")
}

; ============================================================================
; Example 5: Event Processing
; ============================================================================
; Process events in reverse chronological order
Example5_EventProcessing() {
    OutputDebug("=== Example 5: Event Processing ===`n")

    eventLog := []

    ; Log events
    LogEvent(eventLog, "UserLogin", "User123 logged in")
    Sleep(10)
    LogEvent(eventLog, "FileAccess", "Opened document.txt")
    Sleep(10)
    LogEvent(eventLog, "FileEdit", "Modified document.txt")
    Sleep(10)
    LogEvent(eventLog, "FileSave", "Saved document.txt")
    Sleep(10)
    LogEvent(eventLog, "UserLogout", "User123 logged out")

    OutputDebug("Events logged: " eventLog.Length "`n`n")

    ; Process in reverse (most recent first)
    OutputDebug("Processing events (most recent first):`n")

    while (eventLog.Length > 0) {
        event := eventLog.Pop()
        OutputDebug("  [" event.timestamp "] " event.type ": " event.message "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Work Stealing Pattern
; ============================================================================
; Simulate work stealing from shared queue
Example6_WorkStealing() {
    OutputDebug("=== Example 6: Work Stealing Pattern ===`n")

    sharedQueue := []

    ; Fill work queue
    Loop 15 {
        sharedQueue.Push({workId: A_Index, data: "Work item " A_Index})
    }

    OutputDebug("Total work items: " sharedQueue.Length "`n`n")

    ; Simulate multiple workers stealing from queue
    workers := ["Worker A", "Worker B", "Worker C"]

    while (sharedQueue.Length > 0) {
        for workerName in workers {
            if (sharedQueue.Length = 0) {
                break
            }

            ; Worker steals work from end of queue
            work := sharedQueue.Pop()
            OutputDebug(workerName " took: " work.data "`n")
            OutputDebug("  Remaining work: " sharedQueue.Length "`n")

            if (sharedQueue.Length = 0) {
                break
            }
        }
    }

    OutputDebug("`nAll work completed!`n`n")
}

; ============================================================================
; Example 7: Garbage Collection Simulation
; ============================================================================
; Simulate cleanup/garbage collection
Example7_GarbageCollection() {
    OutputDebug("=== Example 7: Garbage Collection Simulation ===`n")

    ; Objects to potentially clean up
    objectPool := []

    ; Create objects with reference counts
    objectPool.Push({id: 1, refs: 0, data: "Object1"})
    objectPool.Push({id: 2, refs: 2, data: "Object2"})
    objectPool.Push({id: 3, refs: 0, data: "Object3"})
    objectPool.Push({id: 4, refs: 1, data: "Object4"})
    objectPool.Push({id: 5, refs: 0, data: "Object5"})
    objectPool.Push({id: 6, refs: 3, data: "Object6"})

    OutputDebug("Objects in pool: " objectPool.Length "`n`n")

    ; Mark and sweep - collect unreferenced objects
    OutputDebug("Garbage collection (removing refs=0):`n")

    collected := []
    kept := []

    while (objectPool.Length > 0) {
        obj := objectPool.Pop()

        if (obj.refs = 0) {
            collected.Push(obj)
            OutputDebug("  Collected: " obj.data " (ID: " obj.id ")`n")
        } else {
            kept.Push(obj)
            OutputDebug("  Kept: " obj.data " (Refs: " obj.refs ")`n")
        }
    }

    OutputDebug("`nGarbage collection complete:`n")
    OutputDebug("  Collected: " collected.Length " objects`n")
    OutputDebug("  Kept: " kept.Length " objects`n`n")
}

; ============================================================================
; Helper Functions and Classes
; ============================================================================

class TaskQueue {
    tasks := []

    Enqueue(task) {
        this.tasks.Push(task)
    }

    Dequeue() {
        if (this.IsEmpty()) {
            throw Error("Queue is empty")
        }
        return this.tasks.Pop()
    }

    IsEmpty() => this.tasks.Length = 0

    Size() => this.tasks.Length

    Clear() {
        this.tasks := []
    }
}

/**
 * Logs an event with timestamp
 * @param {Array} log - Event log array
 * @param {String} type - Event type
 * @param {String} message - Event message
 */
LogEvent(log, type, message) {
    event := {
        timestamp: A_TickCount,
        type: type,
        message: message
    }
    log.Push(event)
}

/**
 * Formats an array for display
 */
FormatArray(arr) {
    if (arr.Length = 0) {
        return "[]"
    }

    result := "["
    for index, value in arr {
        if (index > 1) {
            result .= ", "
        }

        if (IsObject(value)) {
            result .= "{Object}"
        } else {
            result .= value
        }
    }
    result .= "]"

    return result
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    ; Clear debug output
    OutputDebug("`n" String.Repeat("=", 80) "`n")
    OutputDebug("Array.Pop() - Data Processing Examples`n")
    OutputDebug(String.Repeat("=", 80) "`n`n")

    ; Run all examples
    Example1_TaskQueueProcessing()
    Example2_BatchProcessing()
    Example3_MessageQueueProcessing()
    Example4_FileProcessingQueue()
    Example5_EventProcessing()
    Example6_WorkStealing()
    Example7_GarbageCollection()

    OutputDebug(String.Repeat("=", 80) "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(String.Repeat("=", 80) "`n")

    MsgBox("Array.Pop() processing examples completed!`nCheck DebugView for output.",
           "Examples Complete", "Icon!")
}

; Run the examples
Main()
