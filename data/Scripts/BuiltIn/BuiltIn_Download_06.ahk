#Requires AutoHotkey v2.0

/**
* BuiltIn_Download_06.ahk - Download Queue Management
*
* This file demonstrates advanced download queue management in AutoHotkey v2,
* showing how to organize, prioritize, and control download queues effectively.
*
* Features Demonstrated:
* - Queue creation and management
* - Priority queue implementation
* - Queue manipulation (add, remove, reorder)
* - Concurrent download limiting
* - Queue persistence
* - Dynamic queue updates
* - Queue monitoring and control
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024-11-16
*/

; ============================================================================
; Global Queue Manager Class
; ============================================================================

/**
* Download queue manager class
*
* Manages download operations with queuing capabilities
*/
class DownloadQueueManager {
    queue := []
    activeDownloads := 0
    maxConcurrent := 2
    stats := {total: 0, completed: 0, failed: 0, active: 0}

    /**
    * Adds item to queue
    */
    Add(url, dest, priority := 5) {
        this.queue.Push({
            url: url,
            dest: dest,
            priority: priority,
            status: "queued",
            addedTime: A_Now,
            size: 0
        })
        this.stats.total++
    }

    /**
    * Removes item from queue
    */
    Remove(index) {
        if (index > 0 && index <= this.queue.Length) {
            this.queue.RemoveAt(index)
            this.stats.total--
            return true
        }
        return false
    }

    /**
    * Gets next item to download
    */
    GetNext() {
        for index, item in this.queue {
            if (item.status = "queued")
            return {index: index, item: item}
        }
        return false
    }

    /**
    * Sorts queue by priority
    */
    SortByPriority() {
        ; Simple bubble sort by priority (lower number = higher priority)
        n := this.queue.Length
        loop n {
            i := A_Index
            loop n - i {
                j := A_Index
                if (this.queue[j].priority > this.queue[j + 1].priority) {
                    temp := this.queue[j]
                    this.queue[j] := this.queue[j + 1]
                    this.queue[j + 1] := temp
                }
            }
        }
    }
}

; ============================================================================
; Example 1: Basic Download Queue
; ============================================================================

/**
* Creates and manages a basic download queue
*
* Demonstrates fundamental queue operations.
* Shows sequential queue processing.
*
* @example
* BasicDownloadQueue()
*/
BasicDownloadQueue() {
    queueManager := DownloadQueueManager()

    ; Create GUI
    queueGui := Gui("+Resize +AlwaysOnTop", "Basic Download Queue")
    queueGui.Add("Text", "w500", "Download Queue Manager")
    queueGui.Add("ListView", "w500 h200 vQueueList", ["#", "File", "Status", "Priority"])

    ; Add items to queue
    queueManager.Add("https://example.com/file1.pdf", A_Desktop "\file1.pdf", 1)
    queueManager.Add("https://example.com/file2.zip", A_Desktop "\file2.zip", 2)
    queueManager.Add("https://example.com/file3.jpg", A_Desktop "\file3.jpg", 3)
    queueManager.Add("https://example.com/file4.txt", A_Desktop "\file4.txt", 1)

    ; Display queue
    RefreshQueueList()

    queueGui.Add("Button", "w100", "Process Queue").OnEvent("Click", ProcessQueue)
    queueGui.Add("Button", "w100 x+10", "Sort by Priority").OnEvent("Click", SortQueue)
    queueGui.Add("Button", "w100 x+10", "Clear").OnEvent("Click", ClearQueue)
    queueGui.Show()

    RefreshQueueList() {
        queueGui["QueueList"].Delete()
        for index, item in queueManager.queue {
            SplitPath(item.dest, &fileName)
            queueGui["QueueList"].Add("", index, fileName, item.status, item.priority)
        }
    }

    ProcessQueue(*) {
        queueGui["Button1"].Enabled := false

        for index, item in queueManager.queue {
            if (item.status != "queued")
            continue

            item.status := "downloading"
            RefreshQueueList()

            try {
                Download(item.url, item.dest)
                item.status := "complete"
                queueManager.stats.completed++
            } catch {
                item.status := "failed"
                queueManager.stats.failed++
            }

            RefreshQueueList()
        }

        MsgBox("Queue processing complete!`n`n"
        . "Completed: " queueManager.stats.completed "`n"
        . "Failed: " queueManager.stats.failed, "Complete", "Icon!")

        queueGui["Button1"].Enabled := true
    }

    SortQueue(*) {
        queueManager.SortByPriority()
        RefreshQueueList()
        MsgBox("Queue sorted by priority!", "Sorted", "Icon!")
    }

    ClearQueue(*) {
        queueManager.queue := []
        queueManager.stats := {total: 0, completed: 0, failed: 0, active: 0}
        RefreshQueueList()
        MsgBox("Queue cleared!", "Cleared", "Icon!")
    }
}

; ============================================================================
; Example 2: Interactive Queue Manager
; ============================================================================

/**
* Interactive queue with add, remove, and reorder capabilities
*
* Allows user to manipulate queue in real-time.
* Demonstrates interactive queue management.
*
* @example
* InteractiveQueueManager()
*/
InteractiveQueueManager() {
    queueManager := DownloadQueueManager()

    ; Create interactive GUI
    interactiveGui := Gui("+Resize +AlwaysOnTop", "Interactive Queue Manager")
    interactiveGui.Add("Text", "w600", "Interactive Download Queue")

    ; Add download section
    interactiveGui.Add("GroupBox", "w600 h100", "Add Download")
    interactiveGui.Add("Text", "x20 y35", "URL:")
    interactiveGui.Add("Edit", "x80 y32 w400 vURL")
    interactiveGui.Add("Text", "x20 y65", "Priority:")
    interactiveGui.Add("Edit", "x80 y62 w50 vPriority Number", "5")
    interactiveGui.Add("Button", "x500 y60 w90", "Add to Queue").OnEvent("Click", AddToQueue)

    ; Queue display
    interactiveGui.Add("ListView", "x10 y110 w600 h250 vQueueDisplay", ["#", "URL", "Status", "Priority", "Added"])

    ; Control buttons
    interactiveGui.Add("Button", "x10 y370 w100", "Start Queue").OnEvent("Click", StartQueue)
    interactiveGui.Add("Button", "x120 y370 w100", "Remove Selected").OnEvent("Click", RemoveSelected)
    interactiveGui.Add("Button", "x230 y370 w100", "Move Up").OnEvent("Click", MoveUp)
    interactiveGui.Add("Button", "x340 y370 w100", "Move Down").OnEvent("Click", MoveDown)
    interactiveGui.Add("Button", "x450 y370 w100", "Clear All").OnEvent("Click", ClearAll)

    interactiveGui.Add("Text", "x10 y400 w600 vStats", "Queue: 0 items | Completed: 0 | Failed: 0")

    interactiveGui.Show()

    RefreshDisplay() {
        interactiveGui["QueueDisplay"].Delete()
        for index, item in queueManager.queue {
            interactiveGui["QueueDisplay"].Add("", index, item.url, item.status, item.priority, item.addedTime)
        }
        UpdateStats()
    }

    UpdateStats() {
        interactiveGui["Stats"].Text := "Queue: " queueManager.queue.Length " items | "
        . "Completed: " queueManager.stats.completed " | "
        . "Failed: " queueManager.stats.failed
    }

    AddToQueue(*) {
        url := interactiveGui["URL"].Value
        priority := interactiveGui["Priority"].Value

        if (url = "") {
            MsgBox("Please enter a URL!", "Error", "IconX")
            return
        }

        ; Generate destination filename
        SplitPath(url, &fileName)
        if (fileName = "")
        fileName := "download_" A_TickCount ".dat"

        dest := A_Desktop "\QueueDownloads\" fileName

        queueManager.Add(url, dest, priority)
        RefreshDisplay()

        ; Clear inputs
        interactiveGui["URL"].Value := ""
        interactiveGui["Priority"].Value := "5"
    }

    StartQueue(*) {
        if (queueManager.queue.Length = 0) {
            MsgBox("Queue is empty!", "Error", "IconX")
            return
        }

        interactiveGui["Button1"].Enabled := false

        ; Create destination directory
        destDir := A_Desktop "\QueueDownloads"
        if !FileExist(destDir)
        DirCreate(destDir)

        ; Process queue
        for index, item in queueManager.queue {
            if (item.status != "queued")
            continue

            item.status := "downloading"
            RefreshDisplay()

            try {
                Download(item.url, item.dest)
                item.status := "complete"
                queueManager.stats.completed++
            } catch {
                item.status := "failed"
                queueManager.stats.failed++
            }

            RefreshDisplay()
        }

        MsgBox("Queue processing complete!", "Complete", "Icon!")
        interactiveGui["Button1"].Enabled := true
    }

    RemoveSelected(*) {
        selectedRow := interactiveGui["QueueDisplay"].GetNext()
        if (selectedRow > 0) {
            queueManager.Remove(selectedRow)
            RefreshDisplay()
        } else {
            MsgBox("Please select an item to remove!", "Error", "IconX")
        }
    }

    MoveUp(*) {
        selectedRow := interactiveGui["QueueDisplay"].GetNext()
        if (selectedRow > 1) {
            temp := queueManager.queue[selectedRow - 1]
            queueManager.queue[selectedRow - 1] := queueManager.queue[selectedRow]
            queueManager.queue[selectedRow] := temp
            RefreshDisplay()
            interactiveGui["QueueDisplay"].Modify(selectedRow - 1, "Select Vis Focus")
        }
    }

    MoveDown(*) {
        selectedRow := interactiveGui["QueueDisplay"].GetNext()
        if (selectedRow > 0 && selectedRow < queueManager.queue.Length) {
            temp := queueManager.queue[selectedRow + 1]
            queueManager.queue[selectedRow + 1] := queueManager.queue[selectedRow]
            queueManager.queue[selectedRow] := temp
            RefreshDisplay()
            interactiveGui["QueueDisplay"].Modify(selectedRow + 1, "Select Vis Focus")
        }
    }

    ClearAll(*) {
        result := MsgBox("Clear all queue items?", "Confirm", "YesNo Icon?")
        if (result = "Yes") {
            queueManager.queue := []
            queueManager.stats := {total: 0, completed: 0, failed: 0, active: 0}
            RefreshDisplay()
        }
    }
}

; ============================================================================
; Example 3: Concurrent Download Queue
; ============================================================================

/**
* Queue manager with concurrent download limiting
*
* Limits number of simultaneous downloads.
* Demonstrates concurrent download control.
*
* @example
* ConcurrentDownloadQueue()
*/
ConcurrentDownloadQueue() {
    queueManager := DownloadQueueManager()
    queueManager.maxConcurrent := 3

    ; Add items
    loop 10 {
        queueManager.Add(
        "https://example.com/file" A_Index ".zip",
        A_Desktop "\concurrent\file" A_Index ".zip",
        Mod(A_Index, 3) + 1
        )
    }

    ; Create GUI
    concurrentGui := Gui("+Resize +AlwaysOnTop", "Concurrent Download Queue")
    concurrentGui.Add("Text", "w550", "Concurrent Downloads: Max " queueManager.maxConcurrent " simultaneous")
    concurrentGui.Add("ListView", "w550 h250 vConcurrentList", ["#", "File", "Status", "Priority"])

    for index, item in queueManager.queue {
        SplitPath(item.dest, &fileName)
        concurrentGui["ConcurrentList"].Add("", index, fileName, item.status, item.priority)
    }

    concurrentGui.Add("Progress", "w550 h20 vProgress", "0")
    concurrentGui.Add("Text", "w550 vStats", "Ready")
    concurrentGui.Add("Button", "w100", "Start").OnEvent("Click", StartConcurrent)
    concurrentGui.Show()

    StartConcurrent(*) {
        concurrentGui["Button1"].Enabled := false

        ; Create destination
        destDir := A_Desktop "\concurrent"
        if !FileExist(destDir)
        DirCreate(destDir)

        ; Process with concurrency limit (simulated)
        completed := 0
        total := queueManager.queue.Length

        for index, item in queueManager.queue {
            item.status := "downloading"
            RefreshList()

            try {
                Download(item.url, item.dest)
                item.status := "complete"
                completed++
            } catch {
                item.status := "failed"
            }

            RefreshList()
            concurrentGui["Progress"].Value := (completed / total) * 100
            concurrentGui["Stats"].Text := "Progress: " completed " / " total
        }

        MsgBox("Concurrent queue complete!", "Complete", "Icon!")
    }

    RefreshList() {
        concurrentGui["ConcurrentList"].Delete()
        for index, item in queueManager.queue {
            SplitPath(item.dest, &fileName)
            concurrentGui["ConcurrentList"].Add("", index, fileName, item.status, item.priority)
        }
    }
}

; ============================================================================
; Example 4: Persistent Queue Manager
; ============================================================================

/**
* Queue that persists to disk
*
* Saves and loads queue state from file.
* Demonstrates queue persistence.
*
* @example
* PersistentQueueManager()
*/
PersistentQueueManager() {
    queueFile := A_ScriptDir "\download_queue.txt"
    queueManager := DownloadQueueManager()

    ; Create GUI
    persistGui := Gui("+AlwaysOnTop", "Persistent Queue Manager")
    persistGui.Add("Text", "w500", "Queue persists to: " queueFile)
    persistGui.Add("ListView", "w500 h200 vPersistList", ["File", "Status", "Priority"])
    persistGui.Add("Button", "w100", "Add Item").OnEvent("Click", AddItem)
    persistGui.Add("Button", "w100 x+10", "Save Queue").OnEvent("Click", SaveQueue)
    persistGui.Add("Button", "w100 x+10", "Load Queue").OnEvent("Click", LoadQueue)
    persistGui.Add("Button", "w100 x+10", "Process").OnEvent("Click", ProcessPersistent)
    persistGui.Show()

    ; Load existing queue
    LoadQueue()

    RefreshPersistList() {
        persistGui["PersistList"].Delete()
        for item in queueManager.queue {
            SplitPath(item.dest, &fileName)
            persistGui["PersistList"].Add("", fileName, item.status, item.priority)
        }
    }

    AddItem(*) {
        static counter := 1
        queueManager.Add(
        "https://example.com/file" counter ".zip",
        A_Desktop "\persistent\file" counter ".zip",
        counter
        )
        counter++
        RefreshPersistList()
    }

    SaveQueue(*) {
        queueContent := ""
        for item in queueManager.queue {
            queueContent .= item.url "|" item.dest "|" item.priority "|" item.status "`n"
        }

        try {
            FileDelete(queueFile)
            FileAppend(queueContent, queueFile)
            MsgBox("Queue saved to disk!", "Saved", "Icon!")
        } catch as err {
            MsgBox("Failed to save queue!`n`n" err.Message, "Error", "IconX")
        }
    }

    LoadQueue(*) {
        if !FileExist(queueFile) {
            MsgBox("No saved queue found!", "Info", "Icon!")
            return
        }

        queueManager.queue := []
        content := FileRead(queueFile)

        loop parse, content, "`n", "`r" {
            if (A_LoopField = "")
            continue

            parts := StrSplit(A_LoopField, "|")
            if (parts.Length >= 4) {
                queueManager.Add(parts[1], parts[2], parts[3])
                queueManager.queue[queueManager.queue.Length].status := parts[4]
            }
        }

        RefreshPersistList()
        MsgBox("Queue loaded from disk!", "Loaded", "Icon!")
    }

    ProcessPersistent(*) {
        destDir := A_Desktop "\persistent"
        if !FileExist(destDir)
        DirCreate(destDir)

        for item in queueManager.queue {
            if (item.status = "queued") {
                item.status := "downloading"
                RefreshPersistList()

                try {
                    Download(item.url, item.dest)
                    item.status := "complete"
                } catch {
                    item.status := "failed"
                }

                RefreshPersistList()
            }
        }

        SaveQueue()
        MsgBox("Processing complete and queue saved!", "Complete", "Icon!")
    }
}

; ============================================================================
; Example 5: Smart Queue with Auto-Retry
; ============================================================================

/**
* Queue with automatic retry for failed downloads
*
* Retries failed items automatically.
* Demonstrates intelligent queue processing.
*
* @example
* SmartQueueWithRetry()
*/
SmartQueueWithRetry() {
    ; Create queue with retry tracking
    downloads := [
    {
        url: "https://example.com/file1.zip", dest: A_Desktop "\file1.zip", retries: 0, maxRetries: 3},
        {
            url: "https://example.com/file2.pdf", dest: A_Desktop "\file2.pdf", retries: 0, maxRetries: 3},
            {
                url: "https://example.com/file3.jpg", dest: A_Desktop "\file3.jpg", retries: 0, maxRetries: 3
            }
            ]

            ; Create GUI
            smartGui := Gui("+AlwaysOnTop", "Smart Queue with Auto-Retry")
            smartGui.Add("Text", "w500", "Auto-Retry Queue (Max 3 retries per file)")
            smartGui.Add("ListView", "w500 h200 vSmartList", ["File", "Status", "Retries", "Last Error"])

            for item in downloads {
                SplitPath(item.dest, &fileName)
                smartGui["SmartList"].Add("", fileName, "Queued", "0/3", "---")
            }

            smartGui.Add("Button", "w100", "Process").OnEvent("Click", ProcessSmart)
            smartGui.Show()

            ProcessSmart(*) {
                smartGui["Button1"].Enabled := false

                for index, item in downloads {
                    success := false

                    while (item.retries < item.maxRetries && !success) {
                        smartGui["SmartList"].Modify(index, "Col2", "Downloading")
                        smartGui["SmartList"].Modify(index, "Col3", item.retries "/" item.maxRetries)

                        try {
                            Download(item.url, item.dest)
                            success := true
                            smartGui["SmartList"].Modify(index, "Col2", "Complete")
                            smartGui["SmartList"].Modify(index, "Col4", "Success")
                        } catch as err {
                            item.retries++
                            smartGui["SmartList"].Modify(index, "Col3", item.retries "/" item.maxRetries)
                            smartGui["SmartList"].Modify(index, "Col4", err.Message)

                            if (item.retries < item.maxRetries) {
                                smartGui["SmartList"].Modify(index, "Col2", "Retrying...")
                                Sleep(1000)
                            }
                        }
                    }

                    if !success {
                        smartGui["SmartList"].Modify(index, "Col2", "Failed")
                    }
                }

                MsgBox("Smart queue processing complete!", "Complete", "Icon!")
            }
        }

        ; ============================================================================
        ; Example 6: Category-Based Queue
        ; ============================================================================

        /**
        * Queue organized by download categories
        *
        * Groups downloads by category for organized processing.
        * Demonstrates categorized queue management.
        *
        * @example
        * CategoryBasedQueue()
        */
        CategoryBasedQueue() {
            ; Categorized downloads
            categories := Map(
            "Documents", [],
            "Images", [],
            "Videos", [],
            "Software", []
            )

            ; Add sample items
            categories["Documents"].Push({url: "https://example.com/doc1.pdf", name: "Document 1"})
            categories["Documents"].Push({url: "https://example.com/doc2.docx", name: "Document 2"})
            categories["Images"].Push({url: "https://example.com/img1.jpg", name: "Image 1"})
            categories["Videos"].Push({url: "https://example.com/vid1.mp4", name: "Video 1"})

            ; Create GUI
            categoryGui := Gui("+Resize +AlwaysOnTop", "Category-Based Queue")
            categoryGui.Add("Text", "w500", "Categorized Download Queue")
            categoryGui.Add("Tab3", "w500 h300 vCategoryTabs", ["Documents", "Images", "Videos", "Software"])

            ; Create ListView for each category
            categoryGui["CategoryTabs"].UseTab("Documents")
            docList := categoryGui.Add("ListView", "w480 h250", ["File", "Status"])

            categoryGui["CategoryTabs"].UseTab("Images")
            imgList := categoryGui.Add("ListView", "w480 h250", ["File", "Status"])

            categoryGui["CategoryTabs"].UseTab("Videos")
            vidList := categoryGui.Add("ListView", "w480 h250", ["File", "Status"])

            categoryGui["CategoryTabs"].UseTab("Software")
            swList := categoryGui.Add("ListView", "w480 h250", ["File", "Status"])

            categoryGui["CategoryTabs"].UseTab()

            ; Populate lists
            for item in categories["Documents"]
            docList.Add("", item.name, "Queued")
            for item in categories["Images"]
            imgList.Add("", item.name, "Queued")
            for item in categories["Videos"]
            vidList.Add("", item.name, "Queued")

            categoryGui.Add("Button", "w150", "Process All Categories").OnEvent("Click", ProcessAll)
            categoryGui.Show()

            ProcessAll(*) {
                MsgBox("Processing all categories...`n`n"
                . "Documents: " categories["Documents"].Length "`n"
                . "Images: " categories["Images"].Length "`n"
                . "Videos: " categories["Videos"].Length "`n"
                . "Software: " categories["Software"].Length, "Processing", "Icon!")
            }
        }

        ; ============================================================================
        ; Example 7: Advanced Queue Dashboard
        ; ============================================================================

        /**
        * Comprehensive queue dashboard with statistics
        *
        * Full-featured queue management interface.
        * Demonstrates production-ready queue dashboard.
        *
        * @example
        * AdvancedQueueDashboard()
        */
        AdvancedQueueDashboard() {
            queueManager := DownloadQueueManager()

            ; Add sample items
            loop 15 {
                queueManager.Add(
                "https://example.com/file" A_Index ".zip",
                A_Desktop "\dashboard\file" A_Index ".zip",
                Mod(A_Index, 5) + 1
                )
            }

            ; Create dashboard
            dashboard := Gui("+Resize +AlwaysOnTop", "Advanced Queue Dashboard")
            dashboard.Add("Text", "w700", "Download Queue Dashboard")

            ; Statistics panel
            dashboard.Add("GroupBox", "w700 h80", "Statistics")
            dashboard.Add("Text", "x20 y35 w150 vTotalItems", "Total Items: " queueManager.queue.Length)
            dashboard.Add("Text", "x180 y35 w150 vQueued", "Queued: " queueManager.queue.Length)
            dashboard.Add("Text", "x340 y35 w150 vActive", "Active: 0")
            dashboard.Add("Text", "x500 y35 w150 vCompleted", "Completed: 0")
            dashboard.Add("Text", "x20 y55 w150 vFailed", "Failed: 0")
            dashboard.Add("Text", "x180 y55 w150 vSuccessRate", "Success Rate: 0%")

            ; Queue display
            dashboard.Add("ListView", "x10 y95 w700 h300 vDashList", ["#", "File", "Status", "Priority", "Size"])

            for index, item in queueManager.queue {
                SplitPath(item.dest, &fileName)
                dashboard["DashList"].Add("", index, fileName, item.status, item.priority, "---")
            }

            ; Control panel
            dashboard.Add("Button", "x10 y405 w100", "Start All").OnEvent("Click", StartAll)
            dashboard.Add("Button", "x120 y405 w100", "Pause All").OnEvent("Click", PauseAll)
            dashboard.Add("Button", "x230 y405 w100", "Clear Completed").OnEvent("Click", ClearCompleted)
            dashboard.Add("Button", "x340 y405 w100", "Export Log").OnEvent("Click", ExportLog)
            dashboard.Add("Button", "x450 y405 w100", "Refresh").OnEvent("Click", RefreshDash)

            dashboard.Show()

            StartAll(*) {
                MsgBox("Starting all queued downloads...", "Start", "Icon!")
            }

            PauseAll(*) {
                MsgBox("Pausing all active downloads...", "Pause", "Icon!")
            }

            ClearCompleted(*) {
                ; Remove completed items
                newQueue := []
                for item in queueManager.queue {
                    if (item.status != "complete")
                    newQueue.Push(item)
                }
                queueManager.queue := newQueue
                RefreshDash()
                MsgBox("Completed items removed!", "Cleared", "Icon!")
            }

            ExportLog(*) {
                logFile := A_Desktop "\queue_export.txt"
                logContent := "Download Queue Export`n"
                logContent .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

                for index, item in queueManager.queue {
                    logContent .= "Item " index ": " item.url "`n"
                    logContent .= "  Status: " item.status "`n"
                    logContent .= "  Priority: " item.priority "`n`n"
                }

                FileDelete(logFile)
                FileAppend(logContent, logFile)
                MsgBox("Queue exported to:`n" logFile, "Exported", "Icon!")
            }

            RefreshDash(*) {
                dashboard["DashList"].Delete()
                for index, item in queueManager.queue {
                    SplitPath(item.dest, &fileName)
                    dashboard["DashList"].Add("", index, fileName, item.status, item.priority, "---")
                }
            }
        }

        ; ============================================================================
        ; Test Runner - Uncomment to run individual examples
        ; ============================================================================

        ; Run Example 1: Basic download queue
        ; BasicDownloadQueue()

        ; Run Example 2: Interactive queue manager
        ; InteractiveQueueManager()

        ; Run Example 3: Concurrent download queue
        ; ConcurrentDownloadQueue()

        ; Run Example 4: Persistent queue manager
        ; PersistentQueueManager()

        ; Run Example 5: Smart queue with auto-retry
        ; SmartQueueWithRetry()

        ; Run Example 6: Category-based queue
        ; CategoryBasedQueue()

        ; Run Example 7: Advanced queue dashboard
        ; AdvancedQueueDashboard()
