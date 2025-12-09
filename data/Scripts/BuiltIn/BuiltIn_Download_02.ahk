#Requires AutoHotkey v2.0

/**
* BuiltIn_Download_02.ahk - Download Progress Tracking
*
* This file demonstrates advanced download operations with progress tracking,
* user feedback, and monitoring capabilities in AutoHotkey v2.
*
* Features Demonstrated:
* - Progress bar integration
* - Download time estimation
* - Speed calculation
* - Status updates
* - GUI-based progress tracking
* - Callback-based monitoring
* - Real-time download statistics
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024-11-16
*/

; ============================================================================
; Example 1: Basic Progress Bar Download
; ============================================================================

/**
* Downloads a file with a simple progress bar display
*
* Uses a GUI progress bar to show download progress.
* Demonstrates basic progress tracking with visual feedback.
*
* @example
* DownloadWithProgressBar()
*/
DownloadWithProgressBar() {
    url := "https://www.example.com/largefile.zip"
    destPath := A_Desktop "\largefile.zip"

    ; Create progress GUI
    progressGui := Gui("+AlwaysOnTop", "Download Progress")
    progressGui.Add("Text", "w300", "Downloading file...")
    progressGui.Add("Text", "w300 vStatus", "Initializing download...")
    progressBar := progressGui.Add("Progress", "w300 h20 vProgress", "0")
    progressGui.Add("Button", "w100 vCancelBtn", "Cancel").OnEvent("Click", (*) => CancelDownload())
    progressGui.Show()

    ; Download state
    downloadCancelled := false

    CancelDownload(*) {
        downloadCancelled := true
        progressGui.Destroy()
    }

    ; Start download in timer-based monitoring
    startTime := A_TickCount
    downloadComplete := false

    ; Initiate download in separate thread concept (simulated with timer)
    SetTimer(MonitorDownload, 100)

    try {
        ; Note: Actual Download function is synchronous
        ; This example simulates monitoring for demonstration
        Download(url, destPath)
        downloadComplete := true
    } catch as err {
        downloadComplete := true
        if !downloadCancelled {
            MsgBox("Download failed!`n`nError: " err.Message, "Error", "Icon!")
        }
    }

    MonitorDownload() {
        if downloadComplete || downloadCancelled {
            SetTimer(MonitorDownload, 0)
            if downloadComplete && !downloadCancelled {
                progressGui["Status"].Text := "Download complete!"
                progressBar.Value := 100
                Sleep(1000)
            }
            if IsObject(progressGui)
            progressGui.Destroy()
            return
        }

        ; Update progress (simulated)
        elapsed := (A_TickCount - startTime) / 1000
        progressGui["Status"].Text := "Downloading... (" Round(elapsed, 1) "s elapsed)"
    }
}

; ============================================================================
; Example 2: Download with Time Estimation
; ============================================================================

/**
* Downloads a file and estimates completion time
*
* Calculates download speed and estimates time remaining.
* Demonstrates time-based progress tracking.
*
* @example
* DownloadWithTimeEstimation()
*/
DownloadWithTimeEstimation() {
    url := "https://www.example.com/file.zip"
    destPath := A_Desktop "\file.zip"
    expectedSize := 10 * 1024 * 1024  ; 10 MB expected

    ; Create enhanced progress GUI
    progressGui := Gui("+AlwaysOnTop", "Download Progress")
    progressGui.Add("Text", "w400", "Downloading: " url)
    progressGui.Add("Progress", "w400 h20 vProgressBar", "0")
    progressGui.Add("Text", "w400 vStatusText", "Starting download...")
    progressGui.Add("Text", "w200 vSpeedText", "Speed: Calculating...")
    progressGui.Add("Text", "w200 x+0 vTimeText", "Time remaining: Calculating...")
    progressGui.Add("Button", "w100", "Cancel").OnEvent("Click", (*) => progressGui.Destroy())
    progressGui.Show()

    startTime := A_TickCount
    lastCheck := startTime
    lastSize := 0

    ; Download with monitoring
    SetTimer(UpdateProgress, 250)
    downloadActive := true

    try {
        Download(url, destPath)

        ; Final update
        progressGui["ProgressBar"].Value := 100
        progressGui["StatusText"].Text := "Download complete!"

        if FileExist(destPath) {
            finalSize := FileGetSize(destPath)
            totalTime := (A_TickCount - startTime) / 1000
            avgSpeed := finalSize / totalTime

            progressGui["SpeedText"].Text := "Avg Speed: " FormatSpeed(avgSpeed)
            progressGui["TimeText"].Text := "Total Time: " FormatTime(totalTime)
        }

        Sleep(2000)
    } catch as err {
        MsgBox("Download failed!`n`nError: " err.Message, "Error", "Icon!")
    } finally {
        downloadActive := false
        SetTimer(UpdateProgress, 0)
        if IsObject(progressGui)
        progressGui.Destroy()
    }

    UpdateProgress() {
        if !downloadActive
        return

        if FileExist(destPath) {
            currentSize := FileGetSize(destPath)
            currentTime := A_TickCount
            elapsed := (currentTime - lastCheck) / 1000

            if elapsed > 0 {
                speed := (currentSize - lastSize) / elapsed
                percentComplete := (currentSize / expectedSize) * 100

                progressGui["ProgressBar"].Value := Min(percentComplete, 100)
                progressGui["SpeedText"].Text := "Speed: " FormatSpeed(speed)

                if speed > 0 {
                    remaining := (expectedSize - currentSize) / speed
                    progressGui["TimeText"].Text := "Time remaining: " FormatTime(remaining)
                }

                lastSize := currentSize
                lastCheck := currentTime
            }
        }
    }
}

/**
* Formats speed in bytes/sec to human-readable format
*
* @param {Number} bytesPerSec - Speed in bytes per second
* @return {String} Formatted speed string
*/
FormatSpeed(bytesPerSec) {
    if (bytesPerSec < 1024)
    return Round(bytesPerSec) " B/s"
    else if (bytesPerSec < 1024 * 1024)
    return Round(bytesPerSec / 1024, 2) " KB/s"
    else
    return Round(bytesPerSec / (1024 * 1024), 2) " MB/s"
}

/**
* Formats time in seconds to human-readable format
*
* @param {Number} seconds - Time in seconds
* @return {String} Formatted time string
*/
FormatTime(seconds) {
    if (seconds < 60)
    return Round(seconds) "s"
    else if (seconds < 3600)
    return Floor(seconds / 60) "m " Mod(Floor(seconds), 60) "s"
    else
    return Floor(seconds / 3600) "h " Floor(Mod(seconds, 3600) / 60) "m"
}

; ============================================================================
; Example 3: Multiple Downloads with Progress Dashboard
; ============================================================================

/**
* Downloads multiple files with a comprehensive progress dashboard
*
* Displays progress for multiple simultaneous downloads.
* Demonstrates managing multiple download operations.
*
* @example
* DownloadDashboard()
*/
DownloadDashboard() {
    ; Define download queue
    downloads := [
    {
        url: "https://example.com/file1.zip", dest: A_Desktop "\file1.zip", name: "File 1"},
        {
            url: "https://example.com/file2.pdf", dest: A_Desktop "\file2.pdf", name: "File 2"},
            {
                url: "https://example.com/file3.jpg", dest: A_Desktop "\file3.jpg", name: "File 3"},
                {
                    url: "https://example.com/file4.mp4", dest: A_Desktop "\file4.mp4", name: "File 4"
                }
                ]

                ; Create dashboard GUI
                dashboard := Gui("+Resize +AlwaysOnTop", "Download Dashboard")
                dashboard.Add("Text", "w500", "Download Manager - Multiple Files")
                dashboard.Add("ListView", "w500 h200 vDownloadList", ["File", "Status", "Progress", "Speed"])

                ; Add files to list
                for index, download in downloads {
                    dashboard["DownloadList"].Add("", download.name, "Pending", "0%", "---")
                }

                dashboard.Add("Text", "w500 vSummary", "Total: " downloads.Length " files | Completed: 0 | Failed: 0")
                dashboard.Add("Button", "w100", "Start").OnEvent("Click", StartDownloads)
                dashboard.Add("Button", "w100 x+10", "Close").OnEvent("Click", (*) => dashboard.Destroy())
                dashboard.Show()

                completedCount := 0
                failedCount := 0

                StartDownloads(*) {
                    ; Disable start button
                    dashboard["Button1"].Enabled := false

                    ; Download each file
                    for index, download in downloads {
                        ; Update status
                        dashboard["DownloadList"].Modify(index, "Col2", "Downloading")
                        startTime := A_TickCount

                        try {
                            ; Download file
                            Download(download.url, download.dest)

                            ; Update on success
                            elapsed := (A_TickCount - startTime) / 1000
                            if FileExist(download.dest) {
                                fileSize := FileGetSize(download.dest)
                                speed := fileSize / elapsed
                                dashboard["DownloadList"].Modify(index, "Col2", "Complete")
                                dashboard["DownloadList"].Modify(index, "Col3", "100%")
                                dashboard["DownloadList"].Modify(index, "Col4", FormatSpeed(speed))
                                completedCount++
                            }
                        } catch as err {
                            dashboard["DownloadList"].Modify(index, "Col2", "Failed")
                            dashboard["DownloadList"].Modify(index, "Col3", "Error")
                            dashboard["DownloadList"].Modify(index, "Col4", "---")
                            failedCount++
                        }

                        ; Update summary
                        dashboard["Summary"].Text := "Total: " downloads.Length " files | Completed: " completedCount " | Failed: " failedCount

                        Sleep(100)
                    }

                    MsgBox("All downloads processed!`n`nCompleted: " completedCount "`nFailed: " failedCount, "Complete", "Icon!")
                }
            }

            ; ============================================================================
            ; Example 4: Download with Percentage-Based Progress
            ; ============================================================================

            /**
            * Downloads file with precise percentage tracking
            *
            * Shows detailed percentage-based progress information.
            * Demonstrates accurate progress calculation.
            *
            * @example
            * DownloadWithPercentage()
            */
            DownloadWithPercentage() {
                url := "https://www.example.com/document.pdf"
                destPath := A_Desktop "\document.pdf"
                expectedSize := 5 * 1024 * 1024  ; 5 MB

                ; Create percentage progress GUI
                progressGui := Gui("+AlwaysOnTop", "Download Progress")
                progressGui.Add("Text", "w350", "Downloading: document.pdf")
                progressGui.Add("Progress", "w350 h25 vProgressBar Range0-100", "0")
                progressGui.Add("Text", "w350 vPercentText Center", "0% complete")
                progressGui.Add("Text", "w350 vSizeText Center", "0 MB / " Round(expectedSize / (1024*1024), 2) " MB")
                progressGui.Show()

                startTime := A_TickCount

                ; Monitor download progress
                SetTimer(CheckProgress, 100)
                isDownloading := true

                try {
                    Download(url, destPath)
                    isDownloading := false

                    ; Final update
                    if FileExist(destPath) {
                        actualSize := FileGetSize(destPath)
                        progressGui["ProgressBar"].Value := 100
                        progressGui["PercentText"].Text := "100% complete"
                        progressGui["SizeText"].Text := Round(actualSize / (1024*1024), 2) " MB downloaded"
                    }

                    Sleep(1500)
                } catch as err {
                    isDownloading := false
                    MsgBox("Download failed!`n`nError: " err.Message, "Error", "Icon!")
                } finally {
                    SetTimer(CheckProgress, 0)
                    if IsObject(progressGui)
                    progressGui.Destroy()
                }

                CheckProgress() {
                    if !isDownloading
                    return

                    if FileExist(destPath) {
                        currentSize := FileGetSize(destPath)
                        percent := Round((currentSize / expectedSize) * 100, 1)

                        progressGui["ProgressBar"].Value := Min(percent, 100)
                        progressGui["PercentText"].Text := percent "% complete"
                        progressGui["SizeText"].Text := Round(currentSize / (1024*1024), 2) " MB / " Round(expectedSize / (1024*1024), 2) " MB"
                    }
                }
            }

            ; ============================================================================
            ; Example 5: Download with Status Log
            ; ============================================================================

            /**
            * Downloads file with detailed logging of download events
            *
            * Creates a comprehensive log of download progress and events.
            * Demonstrates event logging and status tracking.
            *
            * @example
            * DownloadWithStatusLog()
            */
            DownloadWithStatusLog() {
                url := "https://www.example.com/data.zip"
                destPath := A_Desktop "\data.zip"

                ; Create logging GUI
                logGui := Gui("+Resize +AlwaysOnTop", "Download Status Log")
                logGui.Add("Text", "w500", "Download URL: " url)
                logGui.Add("Edit", "w500 h200 vLogText ReadOnly +Multi")
                logGui.Add("Progress", "w500 h20 vProgress", "0")
                logGui.Add("Button", "w100", "Start Download").OnEvent("Click", StartDownload)
                logGui.Show()

                downloadLog := []

                AddLog(message) {
                    timestamp := FormatTime(, "HH:mm:ss")
                    logEntry := "[" timestamp "] " message
                    downloadLog.Push(logEntry)
                    logGui["LogText"].Value := ""
                    for entry in downloadLog {
                        logGui["LogText"].Value .= entry "`n"
                    }
                }

                StartDownload(*) {
                    logGui["Button1"].Enabled := false
                    AddLog("Initiating download...")
                    AddLog("URL: " url)
                    AddLog("Destination: " destPath)

                    startTime := A_TickCount
                    isActive := true

                    SetTimer(LogProgress, 500)

                    try {
                        AddLog("Connecting to server...")
                        Download(url, destPath)
                        isActive := false

                        AddLog("Download completed successfully!")

                        if FileExist(destPath) {
                            fileSize := FileGetSize(destPath)
                            elapsed := (A_TickCount - startTime) / 1000
                            speed := fileSize / elapsed

                            AddLog("File size: " Round(fileSize / (1024*1024), 2) " MB")
                            AddLog("Download time: " FormatTime(elapsed))
                            AddLog("Average speed: " FormatSpeed(speed))
                        }

                        logGui["Progress"].Value := 100
                    } catch as err {
                        isActive := false
                        AddLog("ERROR: Download failed - " err.Message)
                    } finally {
                        SetTimer(LogProgress, 0)
                    }

                    LogProgress() {
                        if !isActive
                        return

                        if FileExist(destPath) {
                            currentSize := FileGetSize(destPath)
                            AddLog("Downloaded: " Round(currentSize / 1024, 1) " KB")
                        }
                    }
                }
            }

            ; ============================================================================
            ; Example 6: Download with Visual Feedback
            ; ============================================================================

            /**
            * Downloads file with rich visual feedback and animations
            *
            * Provides engaging visual feedback during download.
            * Demonstrates GUI enhancements for user experience.
            *
            * @example
            * DownloadWithVisualFeedback()
            */
            DownloadWithVisualFeedback() {
                url := "https://www.example.com/package.zip"
                destPath := A_Desktop "\package.zip"

                ; Create visual feedback GUI
                feedbackGui := Gui("+AlwaysOnTop -Caption +Border", "Download")
                feedbackGui.BackColor := "0x1E1E1E"
                feedbackGui.SetFont("s10 cWhite", "Segoe UI")

                feedbackGui.Add("Text", "w400 Center", "Downloading File")
                feedbackGui.Add("Text", "w400 vFileName Center", "package.zip")
                feedbackGui.Add("Progress", "w400 h30 vProgressBar BackgroundBlack c00FF00", "0")
                feedbackGui.Add("Text", "w200 vStatus", "Status: Initializing...")
                feedbackGui.Add("Text", "w200 x+0 vSpeed", "Speed: --- KB/s")
                feedbackGui.Add("Text", "w400 vDetails Center", "Please wait...")

                feedbackGui.Show("w420 h200")

                startTime := A_TickCount
                lastSize := 0
                lastTime := startTime

                isDownloading := true
                SetTimer(UpdateVisuals, 200)

                try {
                    Download(url, destPath)
                    isDownloading := false

                    feedbackGui["ProgressBar"].Value := 100
                    feedbackGui["Status"].Text := "Status: Complete!"
                    feedbackGui["Details"].Text := "Download finished successfully"

                    if FileExist(destPath) {
                        fileSize := FileGetSize(destPath)
                        totalTime := (A_TickCount - startTime) / 1000
                        avgSpeed := fileSize / totalTime

                        feedbackGui["Speed"].Text := "Avg: " FormatSpeed(avgSpeed)
                    }

                    Sleep(2000)
                } catch as err {
                    isDownloading := false
                    feedbackGui["Status"].Text := "Status: Failed"
                    feedbackGui["Details"].Text := "Error: " err.Message
                    Sleep(3000)
                } finally {
                    SetTimer(UpdateVisuals, 0)
                    if IsObject(feedbackGui)
                    feedbackGui.Destroy()
                }

                UpdateVisuals() {
                    if !isDownloading
                    return

                    if FileExist(destPath) {
                        currentSize := FileGetSize(destPath)
                        currentTime := A_TickCount
                        elapsed := (currentTime - lastTime) / 1000

                        if elapsed > 0 && currentSize > lastSize {
                            speed := (currentSize - lastSize) / elapsed
                            feedbackGui["Speed"].Text := "Speed: " FormatSpeed(speed)
                            lastSize := currentSize
                            lastTime := currentTime
                        }

                        ; Simulate progress (0-90% during download)
                        elapsedTotal := (currentTime - startTime) / 1000
                        simulatedProgress := Min((elapsedTotal / 10) * 100, 90)
                        feedbackGui["ProgressBar"].Value := simulatedProgress
                        feedbackGui["Details"].Text := Round(currentSize / 1024, 1) " KB downloaded..."
                    }
                }
            }

            ; ============================================================================
            ; Example 7: Download with Completion Callback
            ; ============================================================================

            /**
            * Downloads file and executes callback on completion
            *
            * Demonstrates callback-based download handling.
            * Shows post-download processing patterns.
            *
            * @example
            * DownloadWithCallback()
            */
            DownloadWithCallback() {
                url := "https://www.example.com/report.pdf"
                destPath := A_Desktop "\report.pdf"

                ; Create simple progress GUI
                progressGui := Gui("+AlwaysOnTop", "Download in Progress")
                progressGui.Add("Text", "w300", "Downloading report.pdf...")
                progressGui.Add("Progress", "w300 h20 vProgress", "0")
                progressGui.Add("Text", "w300 vStatus", "Please wait...")
                progressGui.Show()

                ; Define completion callback
                OnDownloadComplete(success, filePath, errorMsg := "") {
                    if IsObject(progressGui)
                    progressGui.Destroy()

                    if success {
                        MsgBox("Download completed successfully!`n`nFile saved to:`n" filePath, "Success", "Icon!")

                        ; Ask if user wants to open the file
                        result := MsgBox("Would you like to open the downloaded file?", "Open File", "YesNo Icon?")
                        if (result = "Yes")
                        Run(filePath)
                    } else {
                        MsgBox("Download failed!`n`nError: " errorMsg, "Error", "Icon!")
                    }
                }

                ; Start download
                try {
                    Download(url, destPath)
                    progressGui["Progress"].Value := 100
                    progressGui["Status"].Text := "Download complete!"
                    Sleep(500)

                    ; Call success callback
                    OnDownloadComplete(true, destPath)
                } catch as err {
                    ; Call error callback
                    OnDownloadComplete(false, destPath, err.Message)
                }
            }

            ; ============================================================================
            ; Test Runner - Uncomment to run individual examples
            ; ============================================================================

            ; Run Example 1: Basic progress bar download
            ; DownloadWithProgressBar()

            ; Run Example 2: Download with time estimation
            ; DownloadWithTimeEstimation()

            ; Run Example 3: Multiple downloads with dashboard
            ; DownloadDashboard()

            ; Run Example 4: Download with percentage tracking
            ; DownloadWithPercentage()

            ; Run Example 5: Download with status log
            ; DownloadWithStatusLog()

            ; Run Example 6: Download with visual feedback
            ; DownloadWithVisualFeedback()

            ; Run Example 7: Download with completion callback
            ; DownloadWithCallback()
