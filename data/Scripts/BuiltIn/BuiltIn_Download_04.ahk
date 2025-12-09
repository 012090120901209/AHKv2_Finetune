#Requires AutoHotkey v2.0

/**
* BuiltIn_Download_04.ahk - Batch Download Operations
*
* This file demonstrates batch download operations in AutoHotkey v2,
* showing how to download multiple files efficiently and manage batch processes.
*
* Features Demonstrated:
* - Multiple file downloads
* - Batch processing
* - Parallel download concepts
* - Sequential downloads
* - Batch progress tracking
* - Download lists from files
* - Organized batch downloads
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024-11-16
*/

; ============================================================================
; Example 1: Simple Batch Download
; ============================================================================

/**
* Downloads multiple files sequentially
*
* Demonstrates basic batch download functionality.
* Downloads files one after another with progress tracking.
*
* @example
* SimpleBatchDownload()
*/
SimpleBatchDownload() {
    ; Define files to download
    downloadList := [
    {
        url: "https://example.com/file1.pdf", dest: A_Desktop "\Downloads\file1.pdf"},
        {
            url: "https://example.com/file2.zip", dest: A_Desktop "\Downloads\file2.zip"},
            {
                url: "https://example.com/file3.jpg", dest: A_Desktop "\Downloads\file3.jpg"},
                {
                    url: "https://example.com/file4.txt", dest: A_Desktop "\Downloads\file4.txt"
                }
                ]

                ; Create download directory
                downloadDir := A_Desktop "\Downloads"
                if !FileExist(downloadDir)
                DirCreate(downloadDir)

                ; Create progress GUI
                batchGui := Gui("+AlwaysOnTop", "Batch Download")
                batchGui.Add("Text", "w400", "Batch Download Progress")
                batchGui.Add("Progress", "w400 h20 vOverallProgress Range0-" downloadList.Length, "0")
                batchGui.Add("Text", "w400 vCurrentFile", "Ready to start...")
                batchGui.Add("ListView", "w400 h150 vFileList", ["#", "File", "Status"])

                ; Add files to list
                for index, item in downloadList {
                    SplitPath(item.dest, &fileName)
                    batchGui["FileList"].Add("", index, fileName, "Pending")
                }

                batchGui.Show()

                ; Download each file
                successCount := 0
                failCount := 0

                for index, item in downloadList {
                    SplitPath(item.dest, &fileName)
                    batchGui["CurrentFile"].Text := "Downloading: " fileName
                    batchGui["FileList"].Modify(index, "Col3", "Downloading")

                    try {
                        Download(item.url, item.dest)

                        if FileExist(item.dest) {
                            batchGui["FileList"].Modify(index, "Col3", "Complete")
                            successCount++
                        } else {
                            batchGui["FileList"].Modify(index, "Col3", "Failed")
                            failCount++
                        }
                    } catch {
                        batchGui["FileList"].Modify(index, "Col3", "Failed")
                        failCount++
                    }

                    batchGui["OverallProgress"].Value := index
                    Sleep(100)
                }

                batchGui["CurrentFile"].Text := "Batch complete! Success: " successCount " | Failed: " failCount

                MsgBox("Batch download complete!`n`n"
                . "Successful: " successCount "`n"
                . "Failed: " failCount, "Batch Complete", "Icon!")

                Sleep(2000)
                batchGui.Destroy()
            }

            ; ============================================================================
            ; Example 2: Batch Download from URL List File
            ; ============================================================================

            /**
            * Downloads files from a URL list file
            *
            * Reads URLs from a text file and downloads each one.
            * Demonstrates loading download lists from external files.
            *
            * @example
            * BatchDownloadFromFile()
            */
            BatchDownloadFromFile() {
                ; Create sample URL list file
                urlListFile := A_Desktop "\download_list.txt"

                sampleURLs := "
                (
                https://example.com/document1.pdf
                https://example.com/image1.jpg
                https://example.com/archive1.zip
                https://example.com/data1.json
                https://example.com/video1.mp4
                )"

                FileDelete(urlListFile)
                FileAppend(sampleURLs, urlListFile)

                MsgBox("Created sample URL list at:`n" urlListFile "`n`nClick OK to start batch download.", "URL List", "Icon!")

                ; Read URL list
                if !FileExist(urlListFile) {
                    MsgBox("URL list file not found!`n`nPath: " urlListFile, "Error", "IconX")
                    return
                }

                urlContent := FileRead(urlListFile)
                urls := []

                ; Parse URLs from file
                loop parse, urlContent, "`n", "`r" {
                    url := Trim(A_LoopField)
                    if (url != "" && RegExMatch(url, "i)^https?://"))
                    urls.Push(url)
                }

                if (urls.Length = 0) {
                    MsgBox("No valid URLs found in file!", "Error", "IconX")
                    return
                }

                ; Create batch download GUI
                listGui := Gui("+AlwaysOnTop +Resize", "Batch Download from File")
                listGui.Add("Text", "w500", "Downloading " urls.Length " files from list...")
                listGui.Add("ListView", "w500 h200 vURLList", ["#", "URL", "Status", "Size"])

                for index, url in urls {
                    listGui["URLList"].Add("", index, url, "Waiting", "---")
                }

                listGui.Add("Progress", "w500 h20 vProgress Range0-" urls.Length, "0")
                listGui.Add("Text", "w500 vStatus", "Ready to start...")
                listGui.Show()

                ; Download directory
                destDir := A_Desktop "\BatchDownloads"
                if !FileExist(destDir)
                DirCreate(destDir)

                ; Process downloads
                stats := {success: 0, failed: 0, totalSize: 0}

                for index, url in urls {
                    listGui["URLList"].Modify(index, "Col3", "Downloading")
                    listGui["Status"].Text := "Downloading file " index " of " urls.Length "..."

                    ; Generate filename from URL
                    SplitPath(url, &fileName)
                    if (fileName = "")
                    fileName := "file_" index ".dat"

                    destPath := destDir "\" fileName

                    try {
                        Download(url, destPath)

                        if FileExist(destPath) {
                            fileSize := FileGetSize(destPath)
                            stats.success++
                            stats.totalSize += fileSize
                            listGui["URLList"].Modify(index, "Col3", "Complete")
                            listGui["URLList"].Modify(index, "Col4", FormatBytes(fileSize))
                        } else {
                            throw Error("File not created")
                        }
                    } catch as err {
                        stats.failed++
                        listGui["URLList"].Modify(index, "Col3", "Failed")
                        listGui["URLList"].Modify(index, "Col4", "Error")
                    }

                    listGui["Progress"].Value := index
                }

                listGui["Status"].Text := "Complete! Success: " stats.success " | Failed: " stats.failed
                . " | Total Size: " FormatBytes(stats.totalSize)

                MsgBox("Batch download from file complete!`n`n"
                . "Total URLs: " urls.Length "`n"
                . "Successful: " stats.success "`n"
                . "Failed: " stats.failed "`n"
                . "Total Downloaded: " FormatBytes(stats.totalSize), "Complete", "Icon!")
            }

            /**
            * Formats bytes to human-readable size
            */
            FormatBytes(bytes) {
                if (bytes < 1024)
                return bytes " B"
                else if (bytes < 1024 * 1024)
                return Round(bytes / 1024, 2) " KB"
                else if (bytes < 1024 * 1024 * 1024)
                return Round(bytes / (1024 * 1024), 2) " MB"
                else
                return Round(bytes / (1024 * 1024 * 1024), 2) " GB"
            }

            ; ============================================================================
            ; Example 3: Categorized Batch Download
            ; ============================================================================

            /**
            * Downloads files organized by category
            *
            * Downloads files into category-specific folders.
            * Demonstrates organized batch downloading.
            *
            * @example
            * CategorizedBatchDownload()
            */
            CategorizedBatchDownload() {
                ; Define categorized downloads
                categories := Map(
                "Documents", [
                "https://example.com/manual.pdf",
                "https://example.com/guide.docx",
                "https://example.com/readme.txt"
                ],
                "Images", [
                "https://example.com/photo1.jpg",
                "https://example.com/photo2.png",
                "https://example.com/logo.svg"
                ],
                "Archives", [
                "https://example.com/data.zip",
                "https://example.com/backup.7z"
                ],
                "Media", [
                "https://example.com/audio.mp3",
                "https://example.com/video.mp4"
                ]
                )

                ; Create GUI
                catGui := Gui("+AlwaysOnTop", "Categorized Batch Download")
                catGui.Add("Text", "w500", "Downloading files organized by category...")
                catGui.Add("ListView", "w500 h250 vCatList", ["Category", "File", "Status", "Size"])
                catGui.Add("Text", "w500 vProgress", "")
                catGui.Show()

                ; Base directory
                baseDir := A_Desktop "\CategorizedDownloads"

                ; Statistics
                totalFiles := 0
                for category, urls in categories
                totalFiles += urls.Length

                processed := 0
                stats := Map()

                ; Process each category
                for category, urls in categories {
                    ; Create category directory
                    categoryDir := baseDir "\" category
                    if !FileExist(categoryDir)
                    DirCreate(categoryDir)

                    stats[category] := {success: 0, failed: 0}

                    ; Download files in category
                    for index, url in urls {
                        SplitPath(url, &fileName)

                        ; Add to list
                        row := catGui["CatList"].Add("", category, fileName, "Downloading", "---")

                        destPath := categoryDir "\" fileName

                        try {
                            Download(url, destPath)

                            if FileExist(destPath) {
                                fileSize := FileGetSize(destPath)
                                catGui["CatList"].Modify(row, "Col3", "Complete")
                                catGui["CatList"].Modify(row, "Col4", FormatBytes(fileSize))
                                stats[category].success++
                            } else {
                                catGui["CatList"].Modify(row, "Col3", "Failed")
                                stats[category].failed++
                            }
                        } catch {
                            catGui["CatList"].Modify(row, "Col3", "Failed")
                            stats[category].failed++
                        }

                        processed++
                        catGui["Progress"].Text := "Progress: " processed " / " totalFiles " files"
                    }
                }

                ; Generate summary
                summary := "Categorized Batch Download Complete!`n`n"
                for category, stat in stats {
                    summary .= category ": " stat.success " succeeded, " stat.failed " failed`n"
                }

                MsgBox(summary, "Complete", "Icon!")
            }

            ; ============================================================================
            ; Example 4: Batch Download with Size Filtering
            ; ============================================================================

            /**
            * Downloads files with size-based filtering
            *
            * Skips files that exceed size limits.
            * Demonstrates conditional batch downloading.
            *
            * @example
            * BatchDownloadWithSizeFilter()
            */
            BatchDownloadWithSizeFilter() {
                ; Download configuration
                maxFileSize := 10 * 1024 * 1024  ; 10 MB limit

                downloads := [
                {
                    url: "https://example.com/small.txt", expectedSize: 1024},
                    {
                        url: "https://example.com/medium.pdf", expectedSize: 500 * 1024},
                        {
                            url: "https://example.com/large.zip", expectedSize: 20 * 1024 * 1024},
                            {
                                url: "https://example.com/tiny.json", expectedSize: 512
                            }
                            ]

                            ; Create GUI
                            filterGui := Gui("+AlwaysOnTop", "Size-Filtered Batch Download")
                            filterGui.Add("Text", "w450", "Max file size: " FormatBytes(maxFileSize))
                            filterGui.Add("ListView", "w450 h200 vFilterList", ["File", "Expected Size", "Status"])

                            for item in downloads {
                                SplitPath(item.url, &fileName)
                                status := (item.expectedSize > maxFileSize) ? "Skipped (Too Large)" : "Pending"
                                filterGui["FilterList"].Add("", fileName, FormatBytes(item.expectedSize), status)
                            }

                            filterGui.Add("Button", "w100", "Start").OnEvent("Click", StartFiltered)
                            filterGui.Show()

                            StartFiltered(*) {
                                filterGui["Button1"].Enabled := false

                                destDir := A_Desktop "\FilteredDownloads"
                                if !FileExist(destDir)
                                DirCreate(destDir)

                                downloaded := 0
                                skipped := 0

                                for index, item in downloads {
                                    if (item.expectedSize > maxFileSize) {
                                        skipped++
                                        continue
                                    }

                                    SplitPath(item.url, &fileName)
                                    destPath := destDir "\" fileName

                                    filterGui["FilterList"].Modify(index, "Col3", "Downloading")

                                    try {
                                        Download(item.url, destPath)

                                        if FileExist(destPath) {
                                            actualSize := FileGetSize(destPath)

                                            if (actualSize > maxFileSize) {
                                                FileDelete(destPath)
                                                filterGui["FilterList"].Modify(index, "Col3", "Deleted (Too Large)")
                                                skipped++
                                            } else {
                                                filterGui["FilterList"].Modify(index, "Col3", "Complete")
                                                downloaded++
                                            }
                                        }
                                    } catch {
                                        filterGui["FilterList"].Modify(index, "Col3", "Failed")
                                    }
                                }

                                MsgBox("Filtered download complete!`n`n"
                                . "Downloaded: " downloaded "`n"
                                . "Skipped: " skipped, "Complete", "Icon!")
                            }
                        }

                        ; ============================================================================
                        ; Example 5: Batch Download with Progress Callbacks
                        ; ============================================================================

                        /**
                        * Batch download with per-file callbacks
                        *
                        * Executes callbacks for each download event.
                        * Demonstrates event-driven batch downloading.
                        *
                        * @example
                        * BatchDownloadWithCallbacks()
                        */
                        BatchDownloadWithCallbacks() {
                            ; Download list
                            files := [
                            "https://example.com/alpha.txt",
                            "https://example.com/beta.pdf",
                            "https://example.com/gamma.jpg",
                            "https://example.com/delta.zip"
                            ]

                            ; Create callback GUI
                            callbackGui := Gui("+AlwaysOnTop", "Batch Download with Callbacks")
                            callbackGui.Add("Text", "w500", "Batch Download Event Log")
                            callbackGui.Add("Edit", "w500 h250 vEventLog ReadOnly +Multi")
                            callbackGui.Add("Progress", "w500 h20 vProgress Range0-" files.Length, "0")
                            callbackGui.Add("Button", "w100", "Start").OnEvent("Click", StartBatch)
                            callbackGui.Show()

                            eventLog := []

                            LogEvent(event, details := "") {
                                timestamp := FormatTime(, "HH:mm:ss")
                                logLine := "[" timestamp "] " event
                                if (details != "")
                                logLine .= " - " details

                                eventLog.Push(logLine)

                                ; Update log display
                                logText := ""
                                for line in eventLog
                                logText .= line "`n"
                                callbackGui["EventLog"].Value := logText
                            }

                            OnFileStart(index, url) {
                                SplitPath(url, &fileName)
                                LogEvent("START", "File " index ": " fileName)
                            }

                            OnFileComplete(index, url, size) {
                                SplitPath(url, &fileName)
                                LogEvent("COMPLETE", fileName " (" FormatBytes(size) ")")
                            }

                            OnFileError(index, url, error) {
                                SplitPath(url, &fileName)
                                LogEvent("ERROR", fileName " - " error)
                            }

                            StartBatch(*) {
                                callbackGui["Button1"].Enabled := false
                                LogEvent("BATCH START", files.Length " files queued")

                                destDir := A_Desktop "\CallbackDownloads"
                                if !FileExist(destDir)
                                DirCreate(destDir)

                                successCount := 0
                                failCount := 0

                                for index, url in files {
                                    OnFileStart(index, url)

                                    SplitPath(url, &fileName)
                                    destPath := destDir "\" fileName

                                    try {
                                        Download(url, destPath)

                                        if FileExist(destPath) {
                                            fileSize := FileGetSize(destPath)
                                            OnFileComplete(index, url, fileSize)
                                            successCount++
                                        } else {
                                            throw Error("File not created")
                                        }
                                    } catch as err {
                                        OnFileError(index, url, err.Message)
                                        failCount++
                                    }

                                    callbackGui["Progress"].Value := index
                                }

                                LogEvent("BATCH COMPLETE", "Success: " successCount " | Failed: " failCount)

                                MsgBox("Batch download complete!`n`nCheck event log for details.", "Complete", "Icon!")
                            }
                        }

                        ; ============================================================================
                        ; Example 6: Smart Batch Download with Deduplication
                        ; ============================================================================

                        /**
                        * Batch download with duplicate detection
                        *
                        * Skips files that already exist with same size.
                        * Demonstrates smart downloading to save bandwidth.
                        *
                        * @example
                        * SmartBatchDownload()
                        */
                        SmartBatchDownload() {
                            ; Files to download
                            downloads := [
                            {
                                url: "https://example.com/file1.pdf", size: 1024 * 500},
                                {
                                    url: "https://example.com/file2.zip", size: 1024 * 1024 * 2},
                                    {
                                        url: "https://example.com/file3.jpg", size: 1024 * 300},
                                        {
                                            url: "https://example.com/file1.pdf", size: 1024 * 500}  ; Duplicate
                                            ]

                                            ; Create GUI
                                            smartGui := Gui("+AlwaysOnTop", "Smart Batch Download")
                                            smartGui.Add("Text", "w500", "Smart Download with Deduplication")
                                            smartGui.Add("ListView", "w500 h200 vSmartList", ["File", "URL", "Status", "Action"])

                                            for item in downloads {
                                                SplitPath(item.url, &fileName)
                                                smartGui["SmartList"].Add("", fileName, item.url, "Checking", "---")
                                            }

                                            smartGui.Add("Button", "w100", "Start").OnEvent("Click", StartSmart)
                                            smartGui.Show()

                                            StartSmart(*) {
                                                smartGui["Button1"].Enabled := false

                                                destDir := A_Desktop "\SmartDownloads"
                                                if !FileExist(destDir)
                                                DirCreate(destDir)

                                                processed := Map()
                                                stats := {downloaded: 0, skipped: 0, failed: 0}

                                                for index, item in downloads {
                                                    SplitPath(item.url, &fileName)
                                                    destPath := destDir "\" fileName

                                                    ; Check if already processed
                                                    if processed.Has(fileName) {
                                                        smartGui["SmartList"].Modify(index, "Col3", "Skipped")
                                                        smartGui["SmartList"].Modify(index, "Col4", "Duplicate")
                                                        stats.skipped++
                                                        continue
                                                    }

                                                    ; Check if file exists
                                                    if FileExist(destPath) {
                                                        existingSize := FileGetSize(destPath)

                                                        if (existingSize = item.size) {
                                                            smartGui["SmartList"].Modify(index, "Col3", "Skipped")
                                                            smartGui["SmartList"].Modify(index, "Col4", "Already Exists")
                                                            stats.skipped++
                                                            processed[fileName] := true
                                                            continue
                                                        }
                                                    }

                                                    ; Download file
                                                    smartGui["SmartList"].Modify(index, "Col3", "Downloading")

                                                    try {
                                                        Download(item.url, destPath)

                                                        if FileExist(destPath) {
                                                            smartGui["SmartList"].Modify(index, "Col3", "Complete")
                                                            smartGui["SmartList"].Modify(index, "Col4", "Downloaded")
                                                            stats.downloaded++
                                                            processed[fileName] := true
                                                        }
                                                    } catch {
                                                        smartGui["SmartList"].Modify(index, "Col3", "Failed")
                                                        smartGui["SmartList"].Modify(index, "Col4", "Error")
                                                        stats.failed++
                                                    }
                                                }

                                                MsgBox("Smart batch download complete!`n`n"
                                                . "Downloaded: " stats.downloaded "`n"
                                                . "Skipped: " stats.skipped "`n"
                                                . "Failed: " stats.failed, "Complete", "Icon!")
                                            }
                                        }

                                        ; ============================================================================
                                        ; Example 7: Priority-Based Batch Download
                                        ; ============================================================================

                                        /**
                                        * Downloads files based on priority levels
                                        *
                                        * Processes high-priority downloads first.
                                        * Demonstrates priority queue batch downloading.
                                        *
                                        * @example
                                        * PriorityBatchDownload()
                                        */
                                        PriorityBatchDownload() {
                                            ; Define downloads with priorities (1=highest, 3=lowest)
                                            downloads := [
                                            {
                                                url: "https://example.com/critical.zip", priority: 1, name: "Critical File"},
                                                {
                                                    url: "https://example.com/normal1.pdf", priority: 2, name: "Normal File 1"},
                                                    {
                                                        url: "https://example.com/urgent.exe", priority: 1, name: "Urgent Update"},
                                                        {
                                                            url: "https://example.com/normal2.jpg", priority: 2, name: "Normal File 2"},
                                                            {
                                                                url: "https://example.com/optional.txt", priority: 3, name: "Optional File"},
                                                                {
                                                                    url: "https://example.com/important.doc", priority: 1, name: "Important Doc"
                                                                }
                                                                ]

                                                                ; Sort by priority
                                                                sortedDownloads := []
                                                                for item in downloads
                                                                sortedDownloads.Push(item)

                                                                ; Simple bubble sort by priority
                                                                n := sortedDownloads.Length
                                                                loop n {
                                                                    i := A_Index
                                                                    loop n - i {
                                                                        j := A_Index
                                                                        if (sortedDownloads[j].priority > sortedDownloads[j + 1].priority) {
                                                                            temp := sortedDownloads[j]
                                                                            sortedDownloads[j] := sortedDownloads[j + 1]
                                                                            sortedDownloads[j + 1] := temp
                                                                        }
                                                                    }
                                                                }

                                                                ; Create GUI
                                                                priorityGui := Gui("+AlwaysOnTop", "Priority-Based Batch Download")
                                                                priorityGui.Add("Text", "w500", "Downloads sorted by priority (1=Highest)")
                                                                priorityGui.Add("ListView", "w500 h200 vPriorityList", ["Priority", "File", "Status"])

                                                                for item in sortedDownloads {
                                                                    priorityText := (item.priority = 1) ? "HIGH" : (item.priority = 2) ? "NORMAL" : "LOW"
                                                                    priorityGui["PriorityList"].Add("", priorityText, item.name, "Queued")
                                                                }

                                                                priorityGui.Add("Progress", "w500 h20 vProgress Range0-" sortedDownloads.Length, "0")
                                                                priorityGui.Add("Button", "w100", "Start").OnEvent("Click", StartPriority)
                                                                priorityGui.Show()

                                                                StartPriority(*) {
                                                                    priorityGui["Button1"].Enabled := false

                                                                    destDir := A_Desktop "\PriorityDownloads"
                                                                    if !FileExist(destDir)
                                                                    DirCreate(destDir)

                                                                    for index, item in sortedDownloads {
                                                                        priorityGui["PriorityList"].Modify(index, "Col3", "Downloading")

                                                                        SplitPath(item.url, &fileName)
                                                                        destPath := destDir "\" fileName

                                                                        try {
                                                                            Download(item.url, destPath)
                                                                            priorityGui["PriorityList"].Modify(index, "Col3", "Complete")
                                                                        } catch {
                                                                            priorityGui["PriorityList"].Modify(index, "Col3", "Failed")
                                                                        }

                                                                        priorityGui["Progress"].Value := index
                                                                    }

                                                                    MsgBox("Priority-based download complete!", "Complete", "Icon!")
                                                                }
                                                            }

                                                            ; ============================================================================
                                                            ; Test Runner - Uncomment to run individual examples
                                                            ; ============================================================================

                                                            ; Run Example 1: Simple batch download
                                                            ; SimpleBatchDownload()

                                                            ; Run Example 2: Batch download from file
                                                            ; BatchDownloadFromFile()

                                                            ; Run Example 3: Categorized batch download
                                                            ; CategorizedBatchDownload()

                                                            ; Run Example 4: Batch download with size filtering
                                                            ; BatchDownloadWithSizeFilter()

                                                            ; Run Example 5: Batch download with callbacks
                                                            ; BatchDownloadWithCallbacks()

                                                            ; Run Example 6: Smart batch download with deduplication
                                                            ; SmartBatchDownload()

                                                            ; Run Example 7: Priority-based batch download
                                                            ; PriorityBatchDownload()
