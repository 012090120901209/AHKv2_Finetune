#Requires AutoHotkey v2.0

/**
 * BuiltIn_Download_01.ahk - Basic Download Operations
 *
 * This file demonstrates fundamental file download operations in AutoHotkey v2,
 * covering basic usage of the Download function for retrieving files from URLs.
 *
 * Features Demonstrated:
 * - Simple file downloads
 * - Download to specific paths
 * - Basic URL handling
 * - File existence checking
 * - Download verification
 * - Synchronous downloads
 * - Common download patterns
 *
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024-11-16
 */

; ============================================================================
; Example 1: Simple Text File Download
; ============================================================================

/**
 * Downloads a simple text file from a URL
 *
 * The Download function retrieves content from a URL and saves it to a local file.
 * This is a synchronous operation that blocks until the download completes.
 *
 * @example
 * DownloadSimpleTextFile()
 */
DownloadSimpleTextFile() {
    ; Define source URL and destination path
    sourceURL := "https://www.example.com/sample.txt"
    destPath := A_Desktop "\downloaded_sample.txt"

    ; Display download information
    MsgBox("Starting download...`n`nURL: " sourceURL "`nDestination: " destPath, "Download", "Icon!")

    ; Perform the download
    try {
        Download(sourceURL, destPath)

        ; Verify the download
        if FileExist(destPath) {
            fileSize := FileGetSize(destPath)
            MsgBox("Download successful!`n`nFile: " destPath "`nSize: " fileSize " bytes", "Success", "Icon!")
        }
    } catch as err {
        MsgBox("Download failed!`n`nError: " err.Message, "Error", "Icon!")
    }
}

; ============================================================================
; Example 2: Download Image File
; ============================================================================

/**
 * Downloads an image file from a URL
 *
 * Demonstrates downloading binary files such as images.
 * The Download function handles all file types transparently.
 *
 * @example
 * DownloadImageFile()
 */
DownloadImageFile() {
    ; Define image URL and destination
    imageURL := "https://www.example.com/images/logo.png"
    destPath := A_Desktop "\downloaded_logo.png"

    MsgBox("Downloading image...`n`nURL: " imageURL, "Image Download", "Icon!")

    try {
        ; Download the image
        Download(imageURL, destPath)

        ; Check if file was created
        if FileExist(destPath) {
            fileSize := FileGetSize(destPath)

            ; Display success with file info
            MsgBox("Image downloaded successfully!`n`n"
                 . "File: " destPath "`n"
                 . "Size: " FormatFileSize(fileSize), "Success", "Icon!")

            ; Optional: Open the image
            result := MsgBox("Would you like to open the image?", "Open Image", "YesNo Icon?")
            if (result = "Yes")
                Run(destPath)
        }
    } catch as err {
        MsgBox("Image download failed!`n`nError: " err.Message, "Error", "Icon!")
    }
}

/**
 * Formats file size for human-readable display
 *
 * @param {Integer} bytes - File size in bytes
 * @return {String} Formatted file size string
 */
FormatFileSize(bytes) {
    if (bytes < 1024)
        return bytes " bytes"
    else if (bytes < 1024 * 1024)
        return Round(bytes / 1024, 2) " KB"
    else if (bytes < 1024 * 1024 * 1024)
        return Round(bytes / (1024 * 1024), 2) " MB"
    else
        return Round(bytes / (1024 * 1024 * 1024), 2) " GB"
}

; ============================================================================
; Example 3: Download with Overwrite Protection
; ============================================================================

/**
 * Downloads a file with protection against overwriting existing files
 *
 * Checks if destination file exists before downloading and prompts user.
 * Demonstrates safe download practices.
 *
 * @example
 * DownloadWithOverwriteProtection()
 */
DownloadWithOverwriteProtection() {
    sourceURL := "https://www.example.com/document.pdf"
    destPath := A_Desktop "\document.pdf"

    ; Check if file already exists
    if FileExist(destPath) {
        ; Get existing file info
        existingSize := FileGetSize(destPath)
        existingTime := FileGetTime(destPath)

        ; Ask user what to do
        result := MsgBox("File already exists!`n`n"
                       . "Existing file: " destPath "`n"
                       . "Size: " FormatFileSize(existingSize) "`n"
                       . "Modified: " existingTime "`n`n"
                       . "Do you want to replace it?", "File Exists", "YesNo Icon? Default2")

        if (result = "No") {
            MsgBox("Download cancelled by user.", "Cancelled", "Icon!")
            return
        }

        ; Delete existing file
        try {
            FileDelete(destPath)
        } catch {
            MsgBox("Could not delete existing file!`n`nPath: " destPath, "Error", "Icon!")
            return
        }
    }

    ; Proceed with download
    try {
        Download(sourceURL, destPath)
        MsgBox("Download completed successfully!`n`nFile: " destPath, "Success", "Icon!")
    } catch as err {
        MsgBox("Download failed!`n`nError: " err.Message, "Error", "Icon!")
    }
}

; ============================================================================
; Example 4: Download to Custom Directory
; ============================================================================

/**
 * Downloads files to a custom directory structure
 *
 * Demonstrates creating directories and organizing downloads.
 * Shows proper path handling and directory creation.
 *
 * @example
 * DownloadToCustomDirectory()
 */
DownloadToCustomDirectory() {
    ; Define custom download directory
    downloadDir := A_MyDocuments "\AHK_Downloads"

    ; Create directory if it doesn't exist
    if !FileExist(downloadDir) {
        try {
            DirCreate(downloadDir)
            MsgBox("Created download directory:`n`n" downloadDir, "Directory Created", "Icon!")
        } catch as err {
            MsgBox("Failed to create directory!`n`nError: " err.Message, "Error", "Icon!")
            return
        }
    }

    ; Define files to download
    files := Map(
        "readme.txt", "https://www.example.com/readme.txt",
        "config.ini", "https://www.example.com/config.ini",
        "data.json", "https://www.example.com/data.json"
    )

    ; Download each file
    successCount := 0
    failCount := 0

    for filename, url in files {
        destPath := downloadDir "\" filename

        try {
            Download(url, destPath)
            successCount++
        } catch {
            failCount++
        }
    }

    ; Display results
    MsgBox("Download Summary`n`n"
         . "Success: " successCount " files`n"
         . "Failed: " failCount " files`n`n"
         . "Directory: " downloadDir, "Download Complete", "Icon!")
}

; ============================================================================
; Example 5: Download with Extension Verification
; ============================================================================

/**
 * Downloads files and verifies the file extension matches expected type
 *
 * Ensures downloaded files have the correct extension.
 * Useful for validating download integrity.
 *
 * @example
 * DownloadWithExtensionCheck()
 */
DownloadWithExtensionCheck() {
    ; Define download parameters
    url := "https://www.example.com/archive.zip"
    expectedExt := ".zip"
    destPath := A_Temp "\downloaded_archive.zip"

    MsgBox("Downloading file...`n`nURL: " url "`nExpected extension: " expectedExt, "Download", "Icon!")

    try {
        ; Download the file
        Download(url, destPath)

        ; Verify file exists
        if !FileExist(destPath) {
            throw Error("File not found after download")
        }

        ; Extract and verify extension
        SplitPath(destPath, &fileName, &fileDir, &fileExt)

        if ("." fileExt != expectedExt) {
            MsgBox("Warning: File extension mismatch!`n`n"
                 . "Expected: " expectedExt "`n"
                 . "Actual: ." fileExt, "Extension Mismatch", "Icon!")
        } else {
            fileSize := FileGetSize(destPath)
            MsgBox("Download verified successfully!`n`n"
                 . "File: " fileName "`n"
                 . "Extension: ." fileExt "`n"
                 . "Size: " FormatFileSize(fileSize), "Success", "Icon!")
        }
    } catch as err {
        MsgBox("Download failed!`n`nError: " err.Message, "Error", "Icon!")
    }
}

; ============================================================================
; Example 6: Download Multiple Resource Types
; ============================================================================

/**
 * Downloads different types of resources (text, images, archives, documents)
 *
 * Demonstrates handling various file types in a single download session.
 * Shows organizing downloads by type.
 *
 * @example
 * DownloadMultipleResourceTypes()
 */
DownloadMultipleResourceTypes() {
    ; Create base download directory
    baseDir := A_Desktop "\Downloads"

    ; Define resource categories and their files
    resources := Map(
        "documents", ["https://example.com/manual.pdf", "https://example.com/guide.docx"],
        "images", ["https://example.com/photo1.jpg", "https://example.com/photo2.png"],
        "archives", ["https://example.com/data.zip", "https://example.com/backup.7z"],
        "text", ["https://example.com/notes.txt", "https://example.com/log.csv"]
    )

    ; Track download statistics
    stats := Map("total", 0, "success", 0, "failed", 0)
    downloadLog := ""

    ; Process each category
    for category, urls in resources {
        ; Create category directory
        categoryDir := baseDir "\" category
        if !FileExist(categoryDir) {
            try {
                DirCreate(categoryDir)
            } catch {
                continue
            }
        }

        ; Download files in category
        for index, url in urls {
            stats["total"]++

            ; Extract filename from URL
            SplitPath(url, &filename)
            destPath := categoryDir "\" filename

            ; Attempt download
            try {
                Download(url, destPath)
                stats["success"]++
                downloadLog .= "[OK] " category "\" filename "`n"
            } catch as err {
                stats["failed"]++
                downloadLog .= "[FAIL] " category "\" filename " - " err.Message "`n"
            }
        }
    }

    ; Display comprehensive results
    MsgBox("Download Session Complete`n`n"
         . "Total Files: " stats["total"] "`n"
         . "Successful: " stats["success"] "`n"
         . "Failed: " stats["failed"] "`n`n"
         . "Download Log:`n" downloadLog, "Session Complete", "Icon!")
}

; ============================================================================
; Example 7: Download with Temporary File Handling
; ============================================================================

/**
 * Downloads files to temporary location and processes them
 *
 * Demonstrates using temporary files for download operations.
 * Shows proper cleanup of temporary resources.
 *
 * @example
 * DownloadWithTempFile()
 */
DownloadWithTempFile() {
    ; Generate unique temporary filename
    tempFile := A_Temp "\ahk_download_" A_TickCount ".tmp"
    url := "https://www.example.com/data.json"

    MsgBox("Downloading to temporary location...`n`nTemp file: " tempFile, "Download", "Icon!")

    try {
        ; Download to temporary location
        Download(url, tempFile)

        ; Verify download
        if !FileExist(tempFile) {
            throw Error("Temporary file not created")
        }

        fileSize := FileGetSize(tempFile)

        ; Read and process file content
        content := FileRead(tempFile)
        lineCount := StrSplit(content, "`n").Length

        ; Display processing results
        MsgBox("File downloaded and processed!`n`n"
             . "Size: " FormatFileSize(fileSize) "`n"
             . "Lines: " lineCount "`n`n"
             . "Temporary file will be deleted.", "Processing Complete", "Icon!")

        ; Clean up temporary file
        FileDelete(tempFile)

    } catch as err {
        MsgBox("Operation failed!`n`nError: " err.Message, "Error", "Icon!")

        ; Clean up on error
        if FileExist(tempFile) {
            try {
                FileDelete(tempFile)
            }
        }
    }
}

; ============================================================================
; Test Runner - Uncomment to run individual examples
; ============================================================================

; Run Example 1: Simple text file download
; DownloadSimpleTextFile()

; Run Example 2: Download image file
; DownloadImageFile()

; Run Example 3: Download with overwrite protection
; DownloadWithOverwriteProtection()

; Run Example 4: Download to custom directory
; DownloadToCustomDirectory()

; Run Example 5: Download with extension verification
; DownloadWithExtensionCheck()

; Run Example 6: Download multiple resource types
; DownloadMultipleResourceTypes()

; Run Example 7: Download with temporary file handling
; DownloadWithTempFile()
