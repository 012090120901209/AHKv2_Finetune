#Requires AutoHotkey v2.0

/**
 * BuiltIn_Download_03.ahk - Download Error Handling
 *
 * This file demonstrates comprehensive error handling for download operations
 * in AutoHotkey v2, including retry logic, validation, and recovery strategies.
 *
 * Features Demonstrated:
 * - Try-catch error handling
 * - Automatic retry mechanisms
 * - Network error detection
 * - URL validation
 * - Download verification
 * - Fallback strategies
 * - Error logging and reporting
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024-11-16
 */

; ============================================================================
; Example 1: Basic Error Handling with Try-Catch
; ============================================================================

/**
 * Downloads file with comprehensive error handling
 *
 * Demonstrates proper try-catch usage for download operations.
 * Shows detailed error message handling.
 *
 * @example
 * DownloadWithErrorHandling()
 */
DownloadWithErrorHandling() {
    url := "https://www.example.com/file.zip"
    destPath := A_Desktop "\file.zip"

    MsgBox("Attempting to download file...`n`nURL: " url, "Download", "Icon!")

    try {
        ; Attempt download
        Download(url, destPath)

        ; Verify download success
        if FileExist(destPath) {
            fileSize := FileGetSize(destPath)
            MsgBox("Download successful!`n`n"
                 . "File: " destPath "`n"
                 . "Size: " FormatBytes(fileSize), "Success", "Icon!")
        } else {
            throw Error("File was not created after download")
        }

    } catch Error as err {
        ; Handle different types of errors
        errorMessage := "Download failed!`n`n"
        errorMessage .= "Error Type: " Type(err) "`n"
        errorMessage .= "Message: " err.Message "`n"

        if err.Extra
            errorMessage .= "Extra Info: " err.Extra "`n"

        errorMessage .= "`nWhat: " err.What "`n"
        errorMessage .= "File: " err.File "`n"
        errorMessage .= "Line: " err.Line

        MsgBox(errorMessage, "Download Error", "IconX")

        ; Log error to file
        LogError(url, err)
    }
}

/**
 * Formats bytes to human-readable size
 *
 * @param {Integer} bytes - Size in bytes
 * @return {String} Formatted size string
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

/**
 * Logs error to file
 *
 * @param {String} url - Failed URL
 * @param {Error} err - Error object
 */
LogError(url, err) {
    logFile := A_ScriptDir "\download_errors.log"
    timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")

    logEntry := "`n[" timestamp "]`n"
    logEntry .= "URL: " url "`n"
    logEntry .= "Error: " err.Message "`n"
    logEntry .= "File: " err.File " (Line " err.Line ")`n"
    logEntry .= "---`n"

    try {
        FileAppend(logEntry, logFile)
    }
}

; ============================================================================
; Example 2: Download with Automatic Retry
; ============================================================================

/**
 * Downloads file with automatic retry on failure
 *
 * Implements retry logic with exponential backoff.
 * Demonstrates resilient download patterns.
 *
 * @example
 * DownloadWithRetry()
 */
DownloadWithRetry() {
    url := "https://www.example.com/important.zip"
    destPath := A_Desktop "\important.zip"
    maxRetries := 3
    retryDelay := 2000  ; milliseconds

    ; Create status GUI
    statusGui := Gui("+AlwaysOnTop", "Download with Retry")
    statusGui.Add("Text", "w400", "Downloading with automatic retry...")
    statusGui.Add("Text", "w400 vStatus", "Attempt 1 of " (maxRetries + 1))
    statusGui.Add("Progress", "w400 h20 vProgress", "0")
    statusGui.Add("Edit", "w400 h150 vLog ReadOnly +Multi")
    statusGui.Show()

    AddLog(message) {
        timestamp := FormatTime(, "HH:mm:ss")
        currentLog := statusGui["Log"].Value
        statusGui["Log"].Value := currentLog "[" timestamp "] " message "`n"
    }

    AddLog("Starting download process...")
    AddLog("URL: " url)
    AddLog("Maximum retries: " maxRetries)

    attempt := 1
    success := false

    while (attempt <= maxRetries + 1 && !success) {
        statusGui["Status"].Text := "Attempt " attempt " of " (maxRetries + 1)
        statusGui["Progress"].Value := ((attempt - 1) / (maxRetries + 1)) * 100

        AddLog("Attempt #" attempt " - Connecting...")

        try {
            Download(url, destPath)

            ; Verify download
            if FileExist(destPath) && FileGetSize(destPath) > 0 {
                success := true
                statusGui["Progress"].Value := 100
                AddLog("SUCCESS: Download completed!")
                AddLog("File size: " FormatBytes(FileGetSize(destPath)))

                MsgBox("Download successful on attempt " attempt "!`n`n"
                     . "File: " destPath, "Success", "Icon!")
            } else {
                throw Error("Downloaded file is empty or missing")
            }

        } catch Error as err {
            AddLog("ERROR: " err.Message)

            if (attempt <= maxRetries) {
                waitTime := retryDelay * (2 ^ (attempt - 1))  ; Exponential backoff
                AddLog("Waiting " (waitTime / 1000) " seconds before retry...")
                Sleep(waitTime)
                attempt++
            } else {
                AddLog("FAILED: Maximum retries exceeded")
                MsgBox("Download failed after " attempt " attempts!`n`n"
                     . "Last error: " err.Message, "Failed", "IconX")
                break
            }
        }
    }

    Sleep(2000)
    statusGui.Destroy()
}

; ============================================================================
; Example 3: URL Validation Before Download
; ============================================================================

/**
 * Validates URL before attempting download
 *
 * Checks URL format and accessibility before downloading.
 * Demonstrates pre-download validation.
 *
 * @example
 * DownloadWithURLValidation()
 */
DownloadWithURLValidation() {
    ; Test with various URLs
    testURLs := [
        "https://www.example.com/valid.zip",
        "http://invalid-url",
        "ftp://example.com/file.txt",
        "not-a-url",
        ""
    ]

    results := []

    for index, url in testURLs {
        result := ValidateAndDownload(url)
        results.Push(result)
    }

    ; Display results
    summary := "URL Validation Results:`n`n"
    for index, result in results {
        summary .= "URL " index ": " result.status "`n"
        summary .= "  Message: " result.message "`n`n"
    }

    MsgBox(summary, "Validation Results", "Icon!")
}

/**
 * Validates URL and attempts download
 *
 * @param {String} url - URL to validate and download
 * @return {Object} Result object with status and message
 */
ValidateAndDownload(url) {
    result := {status: "Unknown", message: "Not processed", url: url}

    ; Check if URL is empty
    if (url = "") {
        result.status := "Invalid"
        result.message := "URL is empty"
        return result
    }

    ; Check URL format
    if !RegExMatch(url, "i)^https?://") {
        result.status := "Invalid"
        result.message := "URL must start with http:// or https://"
        return result
    }

    ; Check URL length
    if (StrLen(url) < 10) {
        result.status := "Invalid"
        result.message := "URL is too short"
        return result
    }

    ; Extract domain
    if RegExMatch(url, "i)^https?://([^/]+)", &match) {
        result.domain := match[1]
    } else {
        result.status := "Invalid"
        result.message := "Cannot extract domain from URL"
        return result
    }

    ; Attempt download
    destPath := A_Temp "\validated_download_" A_TickCount ".tmp"

    try {
        Download(url, destPath)

        if FileExist(destPath) {
            result.status := "Success"
            result.message := "Downloaded successfully (" FormatBytes(FileGetSize(destPath)) ")"
            FileDelete(destPath)  ; Clean up
        } else {
            result.status := "Failed"
            result.message := "File not created after download"
        }
    } catch Error as err {
        result.status := "Failed"
        result.message := "Download error: " err.Message
    }

    return result
}

; ============================================================================
; Example 4: Download Verification and Integrity Check
; ============================================================================

/**
 * Downloads file and verifies integrity
 *
 * Checks file size and basic integrity after download.
 * Demonstrates post-download verification.
 *
 * @example
 * DownloadWithVerification()
 */
DownloadWithVerification() {
    url := "https://www.example.com/package.zip"
    destPath := A_Desktop "\package.zip"
    expectedSize := 1024 * 1024  ; 1 MB expected
    tolerance := 0.1  ; 10% tolerance

    MsgBox("Downloading with verification...`n`nURL: " url, "Download", "Icon!")

    try {
        Download(url, destPath)

        ; Verify file exists
        if !FileExist(destPath) {
            throw Error("Downloaded file does not exist")
        }

        ; Check file size
        actualSize := FileGetSize(destPath)

        if (actualSize = 0) {
            throw Error("Downloaded file is empty")
        }

        ; Check size against expected (with tolerance)
        minSize := expectedSize * (1 - tolerance)
        maxSize := expectedSize * (1 + tolerance)

        if (actualSize < minSize || actualSize > maxSize) {
            MsgBox("Warning: File size mismatch!`n`n"
                 . "Expected: " FormatBytes(expectedSize) "`n"
                 . "Actual: " FormatBytes(actualSize) "`n"
                 . "Difference: " Round(Abs(actualSize - expectedSize) / expectedSize * 100, 1) "%",
                 "Size Mismatch", "Icon!")
        }

        ; Verify file can be read
        try {
            FileOpen(destPath, "r").Close()
        } catch {
            throw Error("File cannot be opened for reading")
        }

        ; All checks passed
        MsgBox("Download verified successfully!`n`n"
             . "File: " destPath "`n"
             . "Size: " FormatBytes(actualSize) "`n"
             . "Status: All integrity checks passed", "Verified", "Icon!")

    } catch Error as err {
        MsgBox("Download or verification failed!`n`nError: " err.Message, "Error", "IconX")

        ; Clean up failed download
        if FileExist(destPath) {
            try {
                FileDelete(destPath)
            }
        }
    }
}

; ============================================================================
; Example 5: Download with Fallback URLs
; ============================================================================

/**
 * Downloads from primary URL with fallback options
 *
 * Tries multiple URLs until one succeeds.
 * Demonstrates failover strategies.
 *
 * @example
 * DownloadWithFallback()
 */
DownloadWithFallback() {
    ; Define primary and fallback URLs
    urls := [
        "https://primary.example.com/file.zip",
        "https://mirror1.example.com/file.zip",
        "https://mirror2.example.com/file.zip",
        "https://backup.example.com/file.zip"
    ]

    destPath := A_Desktop "\file.zip"

    ; Create progress GUI
    fallbackGui := Gui("+AlwaysOnTop", "Download with Fallback")
    fallbackGui.Add("Text", "w400", "Attempting download from multiple sources...")
    fallbackGui.Add("ListView", "w400 h150 vSourceList", ["#", "URL", "Status"])

    ; Add URLs to list
    for index, url in urls {
        fallbackGui["SourceList"].Add("", index, url, "Pending")
    }

    fallbackGui.Add("Text", "w400 vStatus", "Status: Starting...")
    fallbackGui.Show()

    success := false
    successURL := ""

    for index, url in urls {
        fallbackGui["Status"].Text := "Status: Trying source " index " of " urls.Length "..."
        fallbackGui["SourceList"].Modify(index, "Col3", "Trying")

        try {
            Download(url, destPath)

            ; Verify download
            if FileExist(destPath) && FileGetSize(destPath) > 0 {
                success := true
                successURL := url
                fallbackGui["SourceList"].Modify(index, "Col3", "Success")
                fallbackGui["Status"].Text := "Status: Download successful from source " index
                break
            } else {
                throw Error("File verification failed")
            }

        } catch Error as err {
            fallbackGui["SourceList"].Modify(index, "Col3", "Failed")
            Sleep(500)  ; Brief pause before trying next URL
        }
    }

    if success {
        MsgBox("Download completed successfully!`n`n"
             . "Source: " successURL "`n"
             . "File: " destPath "`n"
             . "Size: " FormatBytes(FileGetSize(destPath)), "Success", "Icon!")
    } else {
        MsgBox("Download failed!`n`nAll " urls.Length " sources failed.", "Failed", "IconX")
    }

    Sleep(2000)
    fallbackGui.Destroy()
}

; ============================================================================
; Example 6: Download with Timeout Protection
; ============================================================================

/**
 * Downloads file with timeout protection
 *
 * Implements timeout mechanism to prevent hanging downloads.
 * Demonstrates time-based error handling.
 *
 * @example
 * DownloadWithTimeout()
 */
DownloadWithTimeout() {
    url := "https://www.example.com/largefile.zip"
    destPath := A_Desktop "\largefile.zip"
    timeoutSeconds := 30

    ; Create timeout GUI
    timeoutGui := Gui("+AlwaysOnTop", "Download with Timeout")
    timeoutGui.Add("Text", "w350", "Downloading with " timeoutSeconds "s timeout...")
    timeoutGui.Add("Progress", "w350 h20 vProgress Range0-" timeoutSeconds, "0")
    timeoutGui.Add("Text", "w350 vStatus", "Time elapsed: 0s / " timeoutSeconds "s")
    timeoutGui.Show()

    startTime := A_TickCount
    downloadComplete := false
    timedOut := false

    ; Start timeout monitor
    SetTimer(CheckTimeout, 100)

    try {
        Download(url, destPath)
        downloadComplete := true

        if !timedOut {
            elapsedTime := (A_TickCount - startTime) / 1000
            MsgBox("Download completed in " Round(elapsedTime, 1) " seconds!`n`n"
                 . "File: " destPath, "Success", "Icon!")
        }

    } catch Error as err {
        downloadComplete := true

        if timedOut {
            MsgBox("Download timed out after " timeoutSeconds " seconds!", "Timeout", "IconX")
        } else {
            MsgBox("Download failed!`n`nError: " err.Message, "Error", "IconX")
        }
    } finally {
        SetTimer(CheckTimeout, 0)
        if IsObject(timeoutGui)
            timeoutGui.Destroy()
    }

    CheckTimeout() {
        if downloadComplete
            return

        elapsed := (A_TickCount - startTime) / 1000

        if (elapsed >= timeoutSeconds) {
            timedOut := true
            downloadComplete := true
            SetTimer(CheckTimeout, 0)
            return
        }

        timeoutGui["Progress"].Value := Floor(elapsed)
        timeoutGui["Status"].Text := "Time elapsed: " Floor(elapsed) "s / " timeoutSeconds "s"
    }
}

; ============================================================================
; Example 7: Comprehensive Error Recovery System
; ============================================================================

/**
 * Complete error recovery system with logging and recovery
 *
 * Implements full error handling with recovery strategies.
 * Demonstrates production-ready error handling.
 *
 * @example
 * ComprehensiveErrorRecovery()
 */
ComprehensiveErrorRecovery() {
    ; Download configuration
    config := {
        url: "https://www.example.com/critical.zip",
        destPath: A_Desktop "\critical.zip",
        maxRetries: 3,
        retryDelay: 2000,
        timeout: 30000,
        verifySize: true,
        expectedSize: 5 * 1024 * 1024,
        logErrors: true
    }

    ; Create recovery GUI
    recoveryGui := Gui("+AlwaysOnTop", "Error Recovery System")
    recoveryGui.Add("Text", "w450", "Advanced Download with Error Recovery")
    recoveryGui.Add("Edit", "w450 h200 vLog ReadOnly +Multi")
    recoveryGui.Add("Progress", "w450 h20 vProgress", "0")
    recoveryGui.Add("Button", "w100", "Start").OnEvent("Click", StartRecoveryDownload)
    recoveryGui.Show()

    Log(message, level := "INFO") {
        timestamp := FormatTime(, "HH:mm:ss")
        icon := (level = "ERROR") ? "[X]" : (level = "WARN") ? "[!]" : "[i]"
        logEntry := "[" timestamp "] " icon " " message "`n"

        currentLog := recoveryGui["Log"].Value
        recoveryGui["Log"].Value := currentLog logEntry

        ; Log to file if enabled
        if config.logErrors {
            logFile := A_ScriptDir "\download_recovery.log"
            try {
                FileAppend(logEntry, logFile)
            }
        }
    }

    StartRecoveryDownload(*) {
        recoveryGui["Button1"].Enabled := false

        Log("Starting download with error recovery", "INFO")
        Log("URL: " config.url)
        Log("Destination: " config.destPath)
        Log("Max retries: " config.maxRetries)

        attempt := 1
        success := false

        while (attempt <= config.maxRetries && !success) {
            Log("Attempt " attempt " of " config.maxRetries, "INFO")
            recoveryGui["Progress"].Value := ((attempt - 1) / config.maxRetries) * 100

            try {
                ; Pre-download checks
                Log("Performing pre-download validation...")

                ; Check destination writable
                if !TestFileWritable(config.destPath) {
                    throw Error("Destination path is not writable")
                }

                ; Perform download
                Log("Initiating download...")
                Download(config.url, config.destPath)

                ; Post-download verification
                Log("Verifying download...")

                if !FileExist(config.destPath) {
                    throw Error("File not created after download")
                }

                fileSize := FileGetSize(config.destPath)

                if (fileSize = 0) {
                    throw Error("Downloaded file is empty")
                }

                if config.verifySize && Abs(fileSize - config.expectedSize) > (config.expectedSize * 0.1) {
                    Log("Size mismatch detected: Expected " FormatBytes(config.expectedSize)
                        . ", Got " FormatBytes(fileSize), "WARN")
                }

                ; All checks passed
                success := true
                recoveryGui["Progress"].Value := 100
                Log("Download completed successfully!", "INFO")
                Log("File size: " FormatBytes(fileSize))

                MsgBox("Download successful!`n`nAttempts: " attempt "`nFile: " config.destPath,
                       "Success", "Icon!")

            } catch Error as err {
                Log("Download failed: " err.Message, "ERROR")

                if (attempt < config.maxRetries) {
                    waitTime := config.retryDelay * attempt
                    Log("Retrying in " (waitTime / 1000) " seconds...", "WARN")
                    Sleep(waitTime)
                    attempt++
                } else {
                    Log("Maximum retries exceeded. Download failed.", "ERROR")
                    MsgBox("Download failed after " attempt " attempts!`n`n"
                         . "Last error: " err.Message, "Failed", "IconX")
                    break
                }
            }
        }

        recoveryGui["Button1"].Enabled := true
    }

    /**
     * Tests if a file path is writable
     *
     * @param {String} filePath - Path to test
     * @return {Boolean} True if writable
     */
    TestFileWritable(filePath) {
        testFile := filePath ".test"
        try {
            FileAppend("test", testFile)
            FileDelete(testFile)
            return true
        } catch {
            return false
        }
    }
}

; ============================================================================
; Test Runner - Uncomment to run individual examples
; ============================================================================

; Run Example 1: Basic error handling
; DownloadWithErrorHandling()

; Run Example 2: Automatic retry
; DownloadWithRetry()

; Run Example 3: URL validation
; DownloadWithURLValidation()

; Run Example 4: Download verification
; DownloadWithVerification()

; Run Example 5: Fallback URLs
; DownloadWithFallback()

; Run Example 6: Timeout protection
; DownloadWithTimeout()

; Run Example 7: Comprehensive error recovery
; ComprehensiveErrorRecovery()
