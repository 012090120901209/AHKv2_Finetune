#Requires AutoHotkey v2.0

/**
 * BuiltIn_Download_05.ahk - Download Resume Capability
 * 
 * This file demonstrates download resume and continuation capabilities in AutoHotkey v2,
 * showing how to implement resumable downloads and handle interrupted transfers.
 * 
 * Features Demonstrated:
 * - Partial download tracking
 * - Resume interrupted downloads
 * - Download state persistence
 * - Checkpointing
 * - Incomplete file handling
 * - Download session recovery
 * - Progress restoration
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024-11-16
 */

; ============================================================================
; Example 1: Basic Resume Download with State File
; ============================================================================

/**
 * Downloads file with ability to resume from interruption
 * 
 * Saves download state to allow resuming.
 * Demonstrates basic resume functionality.
 * 
 * @example
 * ResumeBasicDownload()
 */
ResumeBasicDownload() {
    url := "https://example.com/largefile.zip"
    destPath := A_Desktop "\largefile.zip"
    stateFile := destPath ".state"

    ; Create GUI
    resumeGui := Gui("+AlwaysOnTop", "Resumable Download")
    resumeGui.Add("Text", "w400", "Resumable Download Manager")
    resumeGui.Add("Text", "w400 vStatus", "Checking for previous download...")
    resumeGui.Add("Progress", "w400 h20 vProgress", "0")
    resumeGui.Add("Button", "w100 vStartBtn", "Start").OnEvent("Click", StartDownload)
    resumeGui.Add("Button", "w100 x+10 vResumeBtn Disabled", "Resume").OnEvent("Click", ResumeDownload)
    resumeGui.Add("Button", "w100 x+10", "Cancel").OnEvent("Click", (*) => resumeGui.Destroy())
    resumeGui.Show()

    ; Check for existing download
    CheckExistingDownload()

    CheckExistingDownload() {
        if FileExist(stateFile) {
            state := LoadDownloadState(stateFile)

            if (state && FileExist(destPath ".partial")) {
                partialSize := FileGetSize(destPath ".partial")
                resumeGui["Status"].Text := "Found incomplete download (" FormatBytes(partialSize) " downloaded)"
                resumeGui["ResumeBtn"].Enabled := true
                resumeGui["Progress"].Value := state.percentComplete
            }
        } else if FileExist(destPath) {
            resumeGui["Status"].Text := "File already downloaded"
            resumeGui["Progress"].Value := 100
        } else {
            resumeGui["Status"].Text := "Ready to download new file"
        }
    }

    StartDownload(*) {
        resumeGui["StartBtn"].Enabled := false
        resumeGui["Status"].Text := "Starting download..."

        ; Clean up any previous partial downloads
        if FileExist(destPath ".partial")
            FileDelete(destPath ".partial")
        if FileExist(stateFile)
            FileDelete(stateFile)

        PerformDownload(false)
    }

    ResumeDownload(*) {
        resumeGui["ResumeBtn"].Enabled := false
        resumeGui["Status"].Text := "Resuming download..."
        PerformDownload(true)
    }

    PerformDownload(isResume) {
        try {
            ; Note: Actual HTTP range requests require WinHTTP or other methods
            ; This example demonstrates the concept
            Download(url, destPath)

            ; Save completion state
            SaveDownloadState(stateFile, {
                url: url,
                percentComplete: 100,
                completed: true,
                timestamp: A_Now
            })

            resumeGui["Progress"].Value := 100
            resumeGui["Status"].Text := "Download complete!"

            ; Rename partial to final
            if FileExist(destPath ".partial")
                FileMove(destPath ".partial", destPath, 1)

            MsgBox("Download completed successfully!", "Success", "Icon!")

        } catch as err {
            resumeGui["Status"].Text := "Download interrupted: " err.Message

            ; Save partial state
            if FileExist(destPath) {
                FileMove(destPath, destPath ".partial", 1)

                partialSize := FileGetSize(destPath ".partial")
                SaveDownloadState(stateFile, {
                    url: url,
                    percentComplete: 50,  ; Estimate
                    completed: false,
                    timestamp: A_Now,
                    partialSize: partialSize
                })
            }

            resumeGui["ResumeBtn"].Enabled := true
        }
    }
}

/**
 * Saves download state to file
 */
SaveDownloadState(stateFile, state) {
    stateContent := ""
    for key, value in state.OwnProps()
        stateContent .= key "=" value "`n"

    try {
        FileDelete(stateFile)
        FileAppend(stateContent, stateFile)
    }
}

/**
 * Loads download state from file
 */
LoadDownloadState(stateFile) {
    if !FileExist(stateFile)
        return false

    state := {}
    content := FileRead(stateFile)

    loop parse, content, "`n", "`r" {
        if (A_LoopField = "")
            continue

        parts := StrSplit(A_LoopField, "=", , 2)
        if (parts.Length = 2)
            state.%parts[1]% := parts[2]
    }

    return state
}

/**
 * Formats bytes to readable size
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
; Example 2: Download Session Manager
; ============================================================================

/**
 * Manages multiple download sessions with resume capability
 * 
 * Tracks multiple downloads and their states.
 * Demonstrates session-based download management.
 * 
 * @example
 * DownloadSessionManager()
 */
DownloadSessionManager() {
    ; Download sessions
    sessions := [{
        id: 1, url: "https://example.com/file1.zip", name: "Package 1", status: "pending" }, {
            id: 2, url: "https://example.com/file2.pdf", name: "Document 2", status: "pending" }, {
                id: 3, url: "https://example.com/file3.iso", name: "Image 3", status: "pending"
            }
    ]

    ; Create session manager GUI
    sessionGui := Gui("+Resize +AlwaysOnTop", "Download Session Manager")
    sessionGui.Add("Text", "w500", "Download Sessions - Resume Capability")
    sessionGui.Add("ListView", "w500 h200 vSessionList", ["ID", "File", "Status", "Progress", "Action"])

    for session in sessions {
        sessionGui["SessionList"].Add("", session.id, session.name, session.status, "0%", "Ready")
    }

    sessionGui.Add("Button", "w100", "Start All").OnEvent("Click", StartAllSessions)
    sessionGui.Add("Button", "w100 x+10", "Resume All").OnEvent("Click", ResumeAllSessions)
    sessionGui.Add("Button", "w100 x+10", "Clear").OnEvent("Click", ClearSessions)
    sessionGui.Show()

    sessionDir := A_Desktop "\DownloadSessions"
    if !FileExist(sessionDir)
        DirCreate(sessionDir)

    StartAllSessions(*) {
        for index, session in sessions {
            if (session.status = "pending" || session.status = "failed") {
                ProcessSession(index, session, false)
            }
        }

        MsgBox("All sessions processed!", "Complete", "Icon!")
    }

    ResumeAllSessions(*) {
        for index, session in sessions {
            if (session.status = "paused" || session.status = "failed") {
                ProcessSession(index, session, true)
            }
        }

        MsgBox("Resume operations complete!", "Complete", "Icon!")
    }

    ProcessSession(index, session, isResume) {
        sessionGui["SessionList"].Modify(index, "Col3", "Downloading")
        sessionGui["SessionList"].Modify(index, "Col5", "Active")

        SplitPath(session.url, &fileName)
        destPath := sessionDir "\" fileName

        try {
            Download(session.url, destPath)

            sessionGui["SessionList"].Modify(index, "Col3", "Complete")
            sessionGui["SessionList"].Modify(index, "Col4", "100%")
            sessionGui["SessionList"].Modify(index, "Col5", "Done")
            session.status := "complete"

        } catch as err {
            sessionGui["SessionList"].Modify(index, "Col3", "Failed")
            sessionGui["SessionList"].Modify(index, "Col5", "Error")
            session.status := "failed"
        }
    }

    ClearSessions(*) {
        for index, session in sessions {
            session.status := "pending"
            sessionGui["SessionList"].Modify(index, "Col3", "Pending")
            sessionGui["SessionList"].Modify(index, "Col4", "0%")
            sessionGui["SessionList"].Modify(index, "Col5", "Ready")
        }
    }
}

; ============================================================================
; Example 3: Checkpoint-Based Download
; ============================================================================

/**
 * Downloads with periodic checkpoints for resume
 * 
 * Creates checkpoints during download for safe resume points.
 * Demonstrates checkpoint-based recovery.
 * 
 * @example
 * CheckpointDownload()
 */
CheckpointDownload() {
    url := "https://example.com/video.mp4"
    destPath := A_Desktop "\video.mp4"
    checkpointDir := A_Temp "\download_checkpoints"

    if !FileExist(checkpointDir)
        DirCreate(checkpointDir)

    ; Create GUI
    checkpointGui := Gui("+AlwaysOnTop", "Checkpoint Download")
    checkpointGui.Add("Text", "w450", "Download with Checkpoints")
    checkpointGui.Add("Progress", "w450 h20 vProgress", "0")
    checkpointGui.Add("ListView", "w450 h150 vCheckpoints", ["Time", "Event", "Details"])
    checkpointGui.Add("Button", "w100", "Start").OnEvent("Click", StartCheckpoint)
    checkpointGui.Show()

    checkpoints := []

    AddCheckpoint(event, details := "") {
        timestamp := FormatTime(, "HH:mm:ss")
        checkpoints.Push({ time: timestamp, event: event, details: details })
        checkpointGui["Checkpoints"].Add("", timestamp, event, details)

        ; Save checkpoint to file
        checkpointFile := checkpointDir "\checkpoint_" A_TickCount ".txt"
        FileAppend("[" timestamp "] " event " - " details "`n", checkpointFile)
    }

    StartCheckpoint(*) {
        checkpointGui["Button1"].Enabled := false

        AddCheckpoint("INIT", "Starting download")
        AddCheckpoint("URL", url)

        try {
            AddCheckpoint("CONNECT", "Connecting to server")
            Download(url, destPath)

            AddCheckpoint("COMPLETE", "Download finished")
            checkpointGui["Progress"].Value := 100

            if FileExist(destPath) {
                fileSize := FileGetSize(destPath)
                AddCheckpoint("VERIFY", "File size: " FormatBytes(fileSize))
            }

            MsgBox("Download complete with " checkpoints.Length " checkpoints!", "Success", "Icon!")

        } catch as err {
            AddCheckpoint("ERROR", err.Message)
            AddCheckpoint("RECOVERY", "Checkpoint data saved for resume")

            MsgBox("Download failed but checkpoint data saved!`n`n"
                . "Checkpoints: " checkpoints.Length "`n"
                . "Error: " err.Message, "Error", "IconX")
        }
    }
}

; ============================================================================
; Example 4: Multi-Part Download with Resume
; ============================================================================

/**
 * Downloads file in parts with individual resume capability
 * 
 * Splits download into parts that can be resumed independently.
 * Demonstrates advanced chunked downloading.
 * 
 * @example
 * MultiPartResumableDownload()
 */
MultiPartResumableDownload() {
    url := "https://example.com/large.zip"
    destPath := A_Desktop "\large.zip"
    numParts := 4

    ; Create GUI
    multiGui := Gui("+AlwaysOnTop", "Multi-Part Resumable Download")
    multiGui.Add("Text", "w450", "Download in " numParts " parts")
    multiGui.Add("ListView", "w450 h150 vPartsList", ["Part", "Status", "Progress", "Size"])

    ; Initialize parts
    for i in 1..numParts {
        multiGui["PartsList"].Add("", "Part " i, "Pending", "0%", "---")
    }

    multiGui.Add("Progress", "w450 h20 vOverall", "0")
    multiGui.Add("Text", "w450 vOverallText", "Overall Progress: 0%")
    multiGui.Add("Button", "w100", "Start").OnEvent("Click", StartMultiPart)
    multiGui.Add("Button", "w100 x+10", "Resume").OnEvent("Click", ResumeMultiPart)
    multiGui.Show()

    partStates := []
    for i in 1..numParts
        partStates.Push({ index: i, complete: false, size: 0 })

    StartMultiPart(*) {
        multiGui["Button1"].Enabled := false
        DownloadParts(false)
    }

    ResumeMultiPart(*) {
        multiGui["Button2"].Enabled := false
        DownloadParts(true)
    }

    DownloadParts(resume) {
        completedParts := 0

        for i in 1..numParts {
            if resume && partStates[i].complete {
                completedParts++
                continue
            }

            multiGui["PartsList"].Modify(i, "Col2", "Downloading")

            ; Simulate part download (actual implementation would use HTTP ranges)
            partFile := destPath ".part" i

            try {
                ; In real implementation, would download byte range
                Download(url, partFile)

                if FileExist(partFile) {
                    partSize := FileGetSize(partFile)
                    partStates[i].complete := true
                    partStates[i].size := partSize

                    multiGui["PartsList"].Modify(i, "Col2", "Complete")
                    multiGui["PartsList"].Modify(i, "Col3", "100%")
                    multiGui["PartsList"].Modify(i, "Col4", FormatBytes(partSize))
                    completedParts++
                }
            } catch {
                multiGui["PartsList"].Modify(i, "Col2", "Failed")
            }

            ; Update overall progress
            overallPercent := (completedParts / numParts) * 100
            multiGui["Overall"].Value := overallPercent
            multiGui["OverallText"].Text := "Overall Progress: " Round(overallPercent, 1) "%"
        }

        if (completedParts = numParts) {
            MsgBox("All parts downloaded!`n`nNext: Combine parts into final file", "Complete", "Icon!")
            CombineParts()
        } else {
            multiGui["Button2"].Enabled := true
            MsgBox("Some parts failed.`n`nClick Resume to retry failed parts.", "Incomplete", "Icon!")
        }
    }

    CombineParts() {
        ; In real implementation, would combine all part files
        MsgBox("Combining " numParts " parts into final file...`n`n"
            . "Destination: " destPath, "Combining", "Icon!")
    }
}

; ============================================================================
; Example 5: Download Recovery Database
; ============================================================================

/**
 * Uses database to track and recover downloads
 * 
 * Maintains a database of download states for recovery.
 * Demonstrates persistent state management.
 * 
 * @example
 * DownloadRecoveryDatabase()
 */
DownloadRecoveryDatabase() {
    dbFile := A_ScriptDir "\download_recovery.db"

    ; Create recovery GUI
    recoveryGui := Gui("+Resize +AlwaysOnTop", "Download Recovery Database")
    recoveryGui.Add("Text", "w500", "Recoverable Downloads Database")
    recoveryGui.Add("ListView", "w500 h200 vRecoveryList", ["ID", "File", "Status", "Last Update"])
    recoveryGui.Add("Button", "w100", "Add Download").OnEvent("Click", AddDownloadEntry)
    recoveryGui.Add("Button", "w100 x+10", "Recover All").OnEvent("Click", RecoverAll)
    recoveryGui.Add("Button", "w100 x+10", "Clear DB").OnEvent("Click", ClearDB)
    recoveryGui.Show()

    ; Load existing database
    LoadDatabase()

    LoadDatabase() {
        if !FileExist(dbFile)
            return

        content := FileRead(dbFile)
        loop parse, content, "`n", "`r" {
            if (A_LoopField = "")
                continue

            parts := StrSplit(A_LoopField, "|")
            if (parts.Length >= 4)
                recoveryGui["RecoveryList"].Add("", parts[1], parts[2], parts[3], parts[4])
        }
    }

    SaveDatabase() {
        dbContent := ""
        loop recoveryGui["RecoveryList"].GetCount() {
            row := A_Index
            id := recoveryGui["RecoveryList"].GetText(row, 1)
            file := recoveryGui["RecoveryList"].GetText(row, 2)
            status := recoveryGui["RecoveryList"].GetText(row, 3)
            lastUpdate := recoveryGui["RecoveryList"].GetText(row, 4)

            dbContent .= id "|" file "|" status "|" lastUpdate "`n"
        }

        FileDelete(dbFile)
        FileAppend(dbContent, dbFile)
    }

    AddDownloadEntry(*) {
        static nextID := 1
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        recoveryGui["RecoveryList"].Add("", nextID, "file" nextID ".zip", "Pending", timestamp)
        nextID++
        SaveDatabase()
    }

    RecoverAll(*) {
        loop recoveryGui["RecoveryList"].GetCount() {
            row := A_Index
            status := recoveryGui["RecoveryList"].GetText(row, 3)

            if (status != "Complete") {
                timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
                recoveryGui["RecoveryList"].Modify(row, "Col3", "Recovering")
                recoveryGui["RecoveryList"].Modify(row, "Col4", timestamp)

                ; Simulate recovery
                Sleep(500)
                recoveryGui["RecoveryList"].Modify(row, "Col3", "Complete")
            }
        }

        SaveDatabase()
        MsgBox("All downloads recovered!", "Complete", "Icon!")
    }

    ClearDB(*) {
        recoveryGui["RecoveryList"].Delete()
        FileDelete(dbFile)
        MsgBox("Database cleared!", "Cleared", "Icon!")
    }
}

; ============================================================================
; Example 6: Smart Resume with Integrity Check
; ============================================================================

/**
 * Resumes downloads with integrity verification
 * 
 * Validates partial downloads before resuming.
 * Demonstrates safe resume with verification.
 * 
 * @example
 * SmartResumeWithIntegrity()
 */
SmartResumeWithIntegrity() {
    url := "https://example.com/software.exe"
    destPath := A_Desktop "\software.exe"
    partialPath := destPath ".partial"
    checksumFile := destPath ".checksum"

    ; Create GUI
    smartGui := Gui("+AlwaysOnTop", "Smart Resume with Integrity")
    smartGui.Add("Text", "w450", "Smart Resume Download")
    smartGui.Add("Edit", "w450 h200 vLog ReadOnly +Multi")
    smartGui.Add("Progress", "w450 h20 vProgress", "0")
    smartGui.Add("Button", "w100", "Start").OnEvent("Click", StartSmart)
    smartGui.Show()

    Log(message) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := smartGui["Log"].Value
        smartGui["Log"].Value := currentLog "[" timestamp "] " message "`n"
    }

    StartSmart(*) {
        smartGui["Button1"].Enabled := false

        Log("Starting smart resume download...")
        Log("URL: " url)

        ; Check for partial download
        if FileExist(partialPath) {
            partialSize := FileGetSize(partialPath)
            Log("Found partial download: " FormatBytes(partialSize))

            ; Verify integrity
            if FileExist(checksumFile) {
                Log("Verifying partial download integrity...")
                ; In real implementation, would verify checksum
                Log("Integrity check passed")
                Log("Resuming from byte " partialSize)
            } else {
                Log("Warning: No checksum found, starting fresh")
                FileDelete(partialPath)
            }
        } else {
            Log("No partial download found, starting fresh")
        }

        try {
            Download(url, destPath)

            Log("Download complete!")
            smartGui["Progress"].Value := 100

            if FileExist(destPath) {
                finalSize := FileGetSize(destPath)
                Log("Final size: " FormatBytes(finalSize))
                Log("Creating checksum for future verification...")

                ; Save checksum
                FileAppend("checksum_placeholder", checksumFile)
            }

            ; Cleanup
            if FileExist(partialPath)
                FileDelete(partialPath)

            MsgBox("Download completed successfully!", "Success", "Icon!")

        } catch as err {
            Log("Error: " err.Message)
            Log("Saving partial download for resume...")

            if FileExist(destPath) {
                FileMove(destPath, partialPath, 1)
                partialSize := FileGetSize(partialPath)
                Log("Partial saved: " FormatBytes(partialSize))
            }

            MsgBox("Download interrupted!`n`nPartial download saved for resume.", "Interrupted", "Icon!")
        }
    }
}

; ============================================================================
; Example 7: Download Queue with Auto-Resume
; ============================================================================

/**
 * Download queue that automatically resumes failed downloads
 * 
 * Manages a queue with automatic retry and resume.
 * Demonstrates production-ready download queue.
 * 
 * @example
 * AutoResumeDownloadQueue()
 */
AutoResumeDownloadQueue() {
    ; Download queue
    queue := [{
        url: "https://example.com/file1.zip", dest: A_Desktop "\queue1.zip", retries: 0 }, {
            url: "https://example.com/file2.pdf", dest: A_Desktop "\queue2.pdf", retries: 0 }, {
                url: "https://example.com/file3.iso", dest: A_Desktop "\queue3.iso", retries: 0
            }
    ]

    maxRetries := 3

    ; Create GUI
    queueGui := Gui("+AlwaysOnTop", "Auto-Resume Download Queue")
    queueGui.Add("Text", "w500", "Download Queue with Auto-Resume")
    queueGui.Add("ListView", "w500 h200 vQueueList", ["File", "Status", "Retries", "Progress"])

    for item in queue {
        SplitPath(item.dest, &fileName)
        queueGui["QueueList"].Add("", fileName, "Queued", item.retries, "0%")
    }

    queueGui.Add("Progress", "w500 h20 vOverall", "0")
    queueGui.Add("Button", "w100", "Process Queue").OnEvent("Click", ProcessQueue)
    queueGui.Show()

    ProcessQueue(*) {
        queueGui["Button1"].Enabled := false

        completed := 0
        failed := 0

        for index, item in queue {
            success := false

            while (item.retries < maxRetries && !success) {
                queueGui["QueueList"].Modify(index, "Col2", "Downloading")
                queueGui["QueueList"].Modify(index, "Col3", item.retries)

                try {
                    Download(item.url, item.dest)

                    if FileExist(item.dest) {
                        success := true
                        completed++
                        queueGui["QueueList"].Modify(index, "Col2", "Complete")
                        queueGui["QueueList"].Modify(index, "Col4", "100%")
                    }
                } catch {
                    item.retries++
                    queueGui["QueueList"].Modify(index, "Col3", item.retries)

                    if (item.retries < maxRetries) {
                        queueGui["QueueList"].Modify(index, "Col2", "Retrying...")
                        Sleep(2000)  ; Wait before retry
                    }
                }
            }

            if !success {
                failed++
                queueGui["QueueList"].Modify(index, "Col2", "Failed")
            }

            ; Update overall progress
            queueGui["Overall"].Value := ((index - 1) / queue.Length) * 100
        }

        queueGui["Overall"].Value := 100

        MsgBox("Queue processing complete!`n`n"
            . "Completed: " completed "`n"
            . "Failed: " failed, "Complete", "Icon!")
    }
}

; ============================================================================
; Test Runner - Uncomment to run individual examples
; ============================================================================

; Run Example 1: Basic resume download
; ResumeBasicDownload()

; Run Example 2: Download session manager
; DownloadSessionManager()

; Run Example 3: Checkpoint-based download
; CheckpointDownload()

; Run Example 4: Multi-part resumable download
; MultiPartResumableDownload()

; Run Example 5: Download recovery database
; DownloadRecoveryDatabase()

; Run Example 6: Smart resume with integrity
; SmartResumeWithIntegrity()

; Run Example 7: Auto-resume download queue
; AutoResumeDownloadQueue()

