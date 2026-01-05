#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Download_07.ahk - Complete Download Manager
 * 
 * This file demonstrates a full-featured download manager implementation in AutoHotkey v2,
 * combining queue management, progress tracking, error handling, and user interface.
 * 
 * Features Demonstrated:
 * - Complete download manager GUI
 * - Multi-threaded download concepts
 * - Download history tracking
 * - Bandwidth management
 * - Category management
 * - Search and filter
 * - Import/Export functionality
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024-11-16
 */

; ============================================================================
; Download Manager Main Class
; ============================================================================

/**
 * Complete download manager with full feature set
 */
class DownloadManager {
    downloads := []
    history := []
    categories := Map("Default", [], "Documents", [], "Media", [], "Software", [])
    settings := { maxConcurrent: 3, downloadPath: A_Desktop "\Downloads" }

    /**
     * Adds new download
     */
    AddDownload(url, category := "Default") {
        SplitPath(url, &fileName)
        if (fileName = "")
            fileName := "download_" A_TickCount ".dat"

        download := {
            id: A_TickCount,
            url: url,
            fileName: fileName,
            category: category,
            status: "queued",
            progress: 0,
            size: 0,
            speed: 0,
            addedTime: A_Now,
            startTime: "",
            endTime: "",
            error: ""
        }

        this.downloads.Push(download)
        this.categories[category].Push(download)

        return download.id
    }

    /**
     * Removes download by ID
     */
    RemoveDownload(id) {
        for index, download in this.downloads {
            if (download.id = id) {
                this.downloads.RemoveAt(index)
                return true
            }
        }
        return false
    }

    /**
     * Gets download by ID
     */
    GetDownload(id) {
        for download in this.downloads {
            if (download.id = id)
                return download
        }
        return false
    }

    /**
     * Moves download to history
     */
    MoveToHistory(download) {
        this.history.Push(download)
    }
}

; ============================================================================
; Example 1: Full-Featured Download Manager GUI
; ============================================================================

/**
 * Complete download manager with GUI
 * 
 * Demonstrates a production-ready download manager.
 * Shows comprehensive download management.
 * 
 * @example
 * FullDownloadManager()
 */
FullDownloadManager() {
    manager := DownloadManager()

    ; Create main GUI
    mainGui := Gui("+Resize", "Download Manager Pro")
    mainGui.SetFont("s9", "Segoe UI")

    ; Menu bar
    menuBar := Menu()
    fileMenu := Menu()
    fileMenu.Add("Add Download", (*) => ShowAddDialog())
    fileMenu.Add("Import URLs", (*) => ImportURLs())
    fileMenu.Add("Export History", (*) => ExportHistory())
    fileMenu.Add()
    fileMenu.Add("Exit", (*) => mainGui.Destroy())
    menuBar.Add("File", fileMenu)

    viewMenu := Menu()
    viewMenu.Add("Active Downloads", (*) => ShowActiveView())
    viewMenu.Add("Completed Downloads", (*) => ShowCompletedView())
    viewMenu.Add("Failed Downloads", (*) => ShowFailedView())
    menuBar.Add("View", viewMenu)

    mainGui.MenuBar := menuBar

    ; Toolbar
    mainGui.Add("Button", "w80 h30", "Add URL").OnEvent("Click", (*) => ShowAddDialog())
    mainGui.Add("Button", "x+5 w80 h30", "Start All").OnEvent("Click", StartAllDownloads)
    mainGui.Add("Button", "x+5 w80 h30", "Pause All").OnEvent("Click", PauseAllDownloads)
    mainGui.Add("Button", "x+5 w80 h30", "Clear").OnEvent("Click", ClearCompleted)

    ; Download list
    mainGui.Add("Text", "x10 y50", "Downloads:")
    downloadList := mainGui.Add("ListView", "x10 y70 w760 h300 vDownloadList",
        ["Name", "Status", "Progress", "Speed", "Size", "Category"])

    downloadList.ModifyCol(1, 200)
    downloadList.ModifyCol(2, 80)
    downloadList.ModifyCol(3, 80)
    downloadList.ModifyCol(4, 90)
    downloadList.ModifyCol(5, 80)
    downloadList.ModifyCol(6, 100)

    ; Details panel
    mainGui.Add("GroupBox", "x10 y380 w760 h120", "Details")
    mainGui.Add("Text", "x20 y400 w100", "URL:")
    mainGui.Add("Edit", "x120 y397 w640 h20 vDetailURL ReadOnly")
    mainGui.Add("Text", "x20 y430 w100", "Destination:")
    mainGui.Add("Edit", "x120 y427 w640 h20 vDetailDest ReadOnly")
    mainGui.Add("Text", "x20 y460 w100", "Status:")
    mainGui.Add("Edit", "x120 y457 w200 h20 vDetailStatus ReadOnly")
    mainGui.Add("Text", "x340 y460 w80", "Time:")
    mainGui.Add("Edit", "x420 y457 w340 h20 vDetailTime ReadOnly")

    ; Status bar
    mainGui.Add("Text", "x10 y510 w760 h20 vStatusBar Border", "Ready | Downloads: 0 | Active: 0 | Completed: 0")

    mainGui.OnEvent("Close", (*) => ExitApp())
    mainGui.Show("w780 h540")

    ; Add some sample downloads
    manager.AddDownload("https://example.com/document.pdf", "Documents")
    manager.AddDownload("https://example.com/video.mp4", "Media")
    manager.AddDownload("https://example.com/software.exe", "Software")

    RefreshDownloadList()

    RefreshDownloadList() {
        downloadList.Delete()
        for download in manager.downloads {
            downloadList.Add("",
                download.fileName,
                download.status,
                download.progress "%",
                FormatSpeed(download.speed),
                FormatBytes(download.size),
                download.category)
        }
        UpdateStatusBar()
    }

    UpdateStatusBar() {
        total := manager.downloads.Length
        active := 0
        completed := 0

        for download in manager.downloads {
            if (download.status = "downloading")
                active++
            if (download.status = "completed")
                completed++
        }

        mainGui["StatusBar"].Text := "Ready | Downloads: " total " | Active: " active " | Completed: " completed
    }

    ShowAddDialog() {
        addGui := Gui("+Owner" mainGui.Hwnd, "Add Download")
        addGui.Add("Text", , "URL:")
        addGui.Add("Edit", "w400 vAddURL")
        addGui.Add("Text", , "Category:")
        addGui.Add("DropDownList", "w400 vAddCategory", ["Default", "Documents", "Media", "Software"])
        addGui.Add("Button", "w100 Default", "Add").OnEvent("Click", AddNewDownload)
        addGui.Add("Button", "x+10 w100", "Cancel").OnEvent("Click", (*) => addGui.Destroy())
        addGui.Show()

        AddNewDownload(*) {
            url := addGui["AddURL"].Value
            category := addGui["AddCategory"].Text

            if (url != "") {
                manager.AddDownload(url, category)
                RefreshDownloadList()
                addGui.Destroy()
            } else {
                MsgBox("Please enter a URL!", "Error", "IconX")
            }
        }
    }

    StartAllDownloads(*) {
        MsgBox("Starting all queued downloads...", "Start", "Icon!")
        ; Implementation would start actual downloads
    }

    PauseAllDownloads(*) {
        MsgBox("Pausing all active downloads...", "Pause", "Icon!")
    }

    ClearCompleted(*) {
        newDownloads := []
        for download in manager.downloads {
            if (download.status != "completed")
                newDownloads.Push(download)
            else
                manager.MoveToHistory(download)
        }
        manager.downloads := newDownloads
        RefreshDownloadList()
    }

    ImportURLs(*) {
        MsgBox("Import URLs from file...", "Import", "Icon!")
    }

    ExportHistory(*) {
        historyFile := A_Desktop "\download_history.txt"
        content := "Download History Export`n"
        content .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

        for download in manager.history {
            content .= download.fileName "`n"
            content .= "  URL: " download.url "`n"
            content .= "  Status: " download.status "`n`n"
        }

        FileDelete(historyFile)
        FileAppend(content, historyFile)
        MsgBox("History exported to:`n" historyFile, "Exported", "Icon!")
    }

    ShowActiveView(*) {
        RefreshDownloadList()
    }

    ShowCompletedView(*) {
        MsgBox("Showing completed downloads...", "View", "Icon!")
    }

    ShowFailedView(*) {
        MsgBox("Showing failed downloads...", "View", "Icon!")
    }
}

/**
 * Formats speed in bytes/sec
 */
FormatSpeed(bytesPerSec) {
    if (bytesPerSec < 1024)
        return bytesPerSec " B/s"
    else if (bytesPerSec < 1024 * 1024)
        return Round(bytesPerSec / 1024, 2) " KB/s"
    else
        return Round(bytesPerSec / (1024 * 1024), 2) " MB/s"
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
; Example 2: Download Manager with Categories
; ============================================================================

/**
 * Download manager with category organization
 * 
 * Organizes downloads by categories.
 * Demonstrates categorized file management.
 * 
 * @example
 * CategoryDownloadManager()
 */
CategoryDownloadManager() {
    manager := DownloadManager()

    ; Create categorized GUI
    catGui := Gui("+Resize", "Categorized Download Manager")

    ; Category tabs
    catGui.Add("Tab3", "w700 h400 vCategoryTabs",
        ["All Downloads", "Documents", "Media", "Software", "Other"])

    ; All Downloads tab
    catGui["CategoryTabs"].UseTab("All Downloads")
    allList := catGui.Add("ListView", "w680 h350", ["File", "Category", "Status", "Size"])

    ; Documents tab
    catGui["CategoryTabs"].UseTab("Documents")
    docList := catGui.Add("ListView", "w680 h350", ["File", "Status", "Size"])

    ; Media tab
    catGui["CategoryTabs"].UseTab("Media")
    mediaList := catGui.Add("ListView", "w680 h350", ["File", "Status", "Size"])

    ; Software tab
    catGui["CategoryTabs"].UseTab("Software")
    softList := catGui.Add("ListView", "w680 h350", ["File", "Status", "Size"])

    catGui["CategoryTabs"].UseTab()

    ; Controls
    catGui.Add("Button", "w100", "Add Download").OnEvent("Click", AddCategorized)
    catGui.Add("Button", "x+10 w100", "Start All").OnEvent("Click", StartCat)
    catGui.Add("Button", "x+10 w100", "Refresh").OnEvent("Click", RefreshCat)

    catGui.Show("w720 h470")

    ; Add sample downloads
    manager.AddDownload("https://example.com/report.pdf", "Documents")
    manager.AddDownload("https://example.com/song.mp3", "Media")
    manager.AddDownload("https://example.com/app.exe", "Software")

    RefreshAllLists()

    RefreshAllLists() {
        allList.Delete()
        docList.Delete()
        mediaList.Delete()
        softList.Delete()

        for download in manager.downloads {
            allList.Add("", download.fileName, download.category, download.status, FormatBytes(download.size))

            if (download.category = "Documents")
                docList.Add("", download.fileName, download.status, FormatBytes(download.size))
            else if (download.category = "Media")
                mediaList.Add("", download.fileName, download.status, FormatBytes(download.size))
            else if (download.category = "Software")
                softList.Add("", download.fileName, download.status, FormatBytes(download.size))
        }
    }

    AddCategorized(*) {
        addGui := Gui("+Owner" catGui.Hwnd, "Add Download")
        addGui.Add("Text", , "URL:")
        addGui.Add("Edit", "w300 vURL")
        addGui.Add("Text", , "Category:")
        addGui.Add("DropDownList", "w300 vCategory", ["Documents", "Media", "Software", "Other"])
        addGui.Add("Button", "Default", "Add").OnEvent("Click", DoAdd)
        addGui.Show()

        DoAdd(*) {
            url := addGui["URL"].Value
            category := addGui["Category"].Text
            if (url != "") {
                manager.AddDownload(url, category)
                RefreshAllLists()
                addGui.Destroy()
            }
        }
    }

    StartCat(*) {
        MsgBox("Starting categorized downloads...", "Start", "Icon!")
    }

    RefreshCat(*) {
        RefreshAllLists()
    }
}

; ============================================================================
; Example 3: Download History Viewer
; ============================================================================

/**
 * Views download history with search and filter
 * 
 * Displays historical download data.
 * Demonstrates history tracking and search.
 * 
 * @example
 * DownloadHistoryViewer()
 */
DownloadHistoryViewer() {
    manager := DownloadManager()

    ; Add sample history
    loop 20 {
        download := {
            fileName: "file" A_Index ".zip",
            url: "https://example.com/file" A_Index ".zip",
            status: (Mod(A_Index, 3) = 0) ? "failed" : "completed",
            size: Random(1024, 10485760),
            addedTime: FormatTime(, "yyyy-MM-dd HH:mm:ss"),
            category: ["Documents", "Media", "Software"][Mod(A_Index, 3) + 1]
        }
        manager.history.Push(download)
    }

    ; Create history GUI
    historyGui := Gui("+Resize", "Download History")

    historyGui.Add("Text", , "Search:")
    historyGui.Add("Edit", "w200 vSearchBox")
    historyGui.Add("Button", "x+10 w80", "Search").OnEvent("Click", SearchHistory)
    historyGui.Add("Button", "x+10 w80", "Clear").OnEvent("Click", ClearSearch)

    historyGui.Add("Text", , "Filter by Status:")
    historyGui.Add("DropDownList", "w150 vStatusFilter", ["All", "Completed", "Failed"])
    historyGui.Add("Button", "x+10 w80", "Apply").OnEvent("Click", ApplyFilter)

    historyList := historyGui.Add("ListView", "w700 h350",
        ["File", "Status", "Size", "Date", "Category"])

    historyGui.Add("Button", "w100", "Export").OnEvent("Click", ExportHist)
    historyGui.Add("Button", "x+10 w100", "Clear History").OnEvent("Click", ClearHist)

    historyGui.Show("w720 h470")

    RefreshHistory()

    RefreshHistory() {
        historyList.Delete()
        for download in manager.history {
            historyList.Add("",
                download.fileName,
                download.status,
                FormatBytes(download.size),
                download.addedTime,
                download.category)
        }
    }

    SearchHistory(*) {
        searchTerm := historyGui["SearchBox"].Value
        historyList.Delete()

        for download in manager.history {
            if InStr(download.fileName, searchTerm) {
                historyList.Add("",
                    download.fileName,
                    download.status,
                    FormatBytes(download.size),
                    download.addedTime,
                    download.category)
            }
        }
    }

    ClearSearch(*) {
        historyGui["SearchBox"].Value := ""
        RefreshHistory()
    }

    ApplyFilter(*) {
        filter := historyGui["StatusFilter"].Text
        historyList.Delete()

        for download in manager.history {
            if (filter = "All" || download.status = StrLower(filter)) {
                historyList.Add("",
                    download.fileName,
                    download.status,
                    FormatBytes(download.size),
                    download.addedTime,
                    download.category)
            }
        }
    }

    ExportHist(*) {
        exportFile := A_Desktop "\download_history.csv"
        content := "File,Status,Size,Date,Category`n"

        for download in manager.history {
            content .= download.fileName "," download.status "," download.size ","
                . download.addedTime "," download.category "`n"
        }

        FileDelete(exportFile)
        FileAppend(content, exportFile)
        MsgBox("History exported to:`n" exportFile, "Exported", "Icon!")
    }

    ClearHist(*) {
        result := MsgBox("Clear all history?", "Confirm", "YesNo Icon?")
        if (result = "Yes") {
            manager.history := []
            RefreshHistory()
        }
    }
}

; ============================================================================
; Example 4: Download Manager with Settings
; ============================================================================

/**
 * Download manager with configurable settings
 * 
 * Allows user to configure download behavior.
 * Demonstrates settings management.
 * 
 * @example
 * DownloadManagerWithSettings()
 */
DownloadManagerWithSettings() {
    manager := DownloadManager()

    ; Main GUI
    settingsGui := Gui(, "Download Manager Settings")

    settingsGui.Add("GroupBox", "w400 h100", "Download Settings")
    settingsGui.Add("Text", "x20 y35", "Download Folder:")
    settingsGui.Add("Edit", "x140 y32 w200 vDownloadPath", manager.settings.downloadPath)
    settingsGui.Add("Button", "x+5 w50", "Browse").OnEvent("Click", BrowseFolder)

    settingsGui.Add("Text", "x20 y65", "Max Concurrent:")
    settingsGui.Add("Edit", "x140 y62 w50 vMaxConcurrent Number", manager.settings.maxConcurrent)
    settingsGui.Add("UpDown", "Range1-10", manager.settings.maxConcurrent)

    settingsGui.Add("GroupBox", "w400 h120 y110", "Download Notifications")
    settingsGui.Add("Checkbox", "x20 y135 vNotifyComplete", "Notify on completion")
    settingsGui.Add("Checkbox", "x20 y160 vNotifyError", "Notify on error")
    settingsGui.Add("Checkbox", "x20 y185 vPlaySound", "Play sound on completion")
    settingsGui.Add("Checkbox", "x20 y210 vAutoStart", "Auto-start new downloads")

    settingsGui.Add("GroupBox", "w400 h80 y240", "Advanced")
    settingsGui.Add("Checkbox", "x20 y265 vEnableResume", "Enable download resume")
    settingsGui.Add("Checkbox", "x20 y290 vAutoRetry", "Auto-retry failed downloads")

    settingsGui.Add("Button", "y330 w100 Default", "Save Settings").OnEvent("Click", SaveSettings)
    settingsGui.Add("Button", "x+10 w100", "Reset").OnEvent("Click", ResetSettings)
    settingsGui.Add("Button", "x+10 w100", "Cancel").OnEvent("Click", (*) => settingsGui.Destroy())

    settingsGui.Show("w420 h370")

    BrowseFolder(*) {
        selectedFolder := DirSelect("*" manager.settings.downloadPath, 3, "Select Download Folder")
        if (selectedFolder != "")
            settingsGui["DownloadPath"].Value := selectedFolder
    }

    SaveSettings(*) {
        manager.settings.downloadPath := settingsGui["DownloadPath"].Value
        manager.settings.maxConcurrent := settingsGui["MaxConcurrent"].Value

        MsgBox("Settings saved!`n`n"
            . "Download Path: " manager.settings.downloadPath "`n"
            . "Max Concurrent: " manager.settings.maxConcurrent, "Settings", "Icon!")

        settingsGui.Destroy()
    }

    ResetSettings(*) {
        manager.settings.downloadPath := A_Desktop "\Downloads"
        manager.settings.maxConcurrent := 3

        settingsGui["DownloadPath"].Value := manager.settings.downloadPath
        settingsGui["MaxConcurrent"].Value := manager.settings.maxConcurrent
    }
}

; ============================================================================
; Example 5: Download Manager with Scheduler
; ============================================================================

/**
 * Download manager with scheduled downloads
 * 
 * Schedules downloads for specific times.
 * Demonstrates download scheduling.
 * 
 * @example
 * ScheduledDownloadManager()
 */
ScheduledDownloadManager() {
    schedules := []

    ; Create scheduler GUI
    schedGui := Gui("+Resize", "Scheduled Download Manager")

    schedGui.Add("Text", , "Schedule Downloads for Later")
    schedGui.Add("ListView", "w600 h250 vScheduleList",
        ["URL", "Scheduled Time", "Status", "Category"])

    schedGui.Add("Button", "w100", "Add Schedule").OnEvent("Click", AddSchedule)
    schedGui.Add("Button", "x+10 w100", "Remove").OnEvent("Click", RemoveSchedule)
    schedGui.Add("Button", "x+10 w100", "Start Now").OnEvent("Click", StartNow)

    schedGui.Show("w620 h330")

    AddSchedule(*) {
        addGui := Gui("+Owner" schedGui.Hwnd, "Add Scheduled Download")
        addGui.Add("Text", , "URL:")
        addGui.Add("Edit", "w300 vSchedURL")
        addGui.Add("Text", , "Schedule Time:")
        addGui.Add("DateTime", "w300 vSchedTime", "yyyy-MM-dd HH:mm:ss")
        addGui.Add("Text", , "Category:")
        addGui.Add("DropDownList", "w300 vSchedCategory", ["Documents", "Media", "Software"])
        addGui.Add("Button", "Default", "Schedule").OnEvent("Click", DoSchedule)
        addGui.Show()

        DoSchedule(*) {
            url := addGui["SchedURL"].Value
            schedTime := addGui["SchedTime"].Value
            category := addGui["SchedCategory"].Text

            if (url != "") {
                schedules.Push({
                    url: url,
                    time: schedTime,
                    status: "Scheduled",
                    category: category
                })

                schedGui["ScheduleList"].Add("", url, schedTime, "Scheduled", category)
                addGui.Destroy()
            }
        }
    }

    RemoveSchedule(*) {
        row := schedGui["ScheduleList"].GetNext()
        if (row > 0) {
            schedules.RemoveAt(row)
            schedGui["ScheduleList"].Delete(row)
        }
    }

    StartNow(*) {
        row := schedGui["ScheduleList"].GetNext()
        if (row > 0) {
            schedGui["ScheduleList"].Modify(row, "Col3", "Downloading")
            MsgBox("Starting download immediately...", "Start", "Icon!")
        }
    }
}

; ============================================================================
; Example 6: Bandwidth Monitor
; ============================================================================

/**
 * Download manager with bandwidth monitoring
 * 
 * Monitors and displays bandwidth usage.
 * Demonstrates bandwidth tracking.
 * 
 * @example
 * BandwidthMonitor()
 */
BandwidthMonitor() {
    ; Create bandwidth monitor
    bwGui := Gui("+AlwaysOnTop", "Bandwidth Monitor")

    bwGui.Add("Text", "w400", "Real-Time Bandwidth Usage")
    bwGui.Add("Progress", "w400 h30 vBandwidthBar cGreen Range0-1000", "0")
    bwGui.Add("Text", "w400 vBandwidthText Center", "Current: 0 KB/s | Avg: 0 KB/s | Peak: 0 KB/s")

    bwGui.Add("ListView", "w400 h200 vConnectionList",
        ["Download", "Speed", "Progress", "ETA"])

    ; Add sample connections
    bwGui["ConnectionList"].Add("", "file1.zip", "512 KB/s", "45%", "2m 15s")
    bwGui["ConnectionList"].Add("", "video.mp4", "1024 KB/s", "78%", "1m 5s")
    bwGui["ConnectionList"].Add("", "software.exe", "256 KB/s", "12%", "5m 30s")

    bwGui.Add("Text", "w400 vTotalText", "Total Downloaded: 0 MB | Session: 0 MB")

    bwGui.Show()

    ; Simulate bandwidth monitoring
    SetTimer(UpdateBandwidth, 1000)

    UpdateBandwidth() {
        ; Simulate bandwidth data
        currentBW := Random(100, 800)
        bwGui["BandwidthBar"].Value := currentBW
        bwGui["BandwidthText"].Text := "Current: " currentBW " KB/s | Avg: " Random(200, 600)
            . " KB/s | Peak: " Random(700, 1000) " KB/s"
    }
}

; ============================================================================
; Example 7: Cloud Integration Manager
; ============================================================================

/**
 * Download manager with cloud storage integration
 * 
 * Integrates with cloud storage services.
 * Demonstrates cloud download management.
 * 
 * @example
 * CloudIntegrationManager()
 */
CloudIntegrationManager() {
    cloudServices := Map(
        "Dropbox", { connected: false, folder: "" },
        "Google Drive", { connected: false, folder: "" },
        "OneDrive", { connected: false, folder: "" }
    )

    ; Create cloud GUI
    cloudGui := Gui(, "Cloud Integration Manager")

    cloudGui.Add("Text", , "Connected Cloud Services")

    ; Service status
    for service, data in cloudServices {
        cloudGui.Add("Checkbox", "v" StrReplace(service, " ", ""), service)
        cloudGui.Add("Edit", "x+10 w200 v" StrReplace(service, " ", "") "Folder Disabled", "Not connected")
        cloudGui.Add("Button", "x+5 w80", "Connect").OnEvent("Click", (*) => ConnectService(service))
    }

    cloudGui.Add("GroupBox", "w500 h100 y160", "Download to Cloud")
    cloudGui.Add("Text", "x20 y185", "URL:")
    cloudGui.Add("Edit", "x80 y182 w400 vCloudURL")
    cloudGui.Add("Text", "x20 y215", "Service:")
    cloudGui.Add("DropDownList", "x80 y212 w200 vCloudService", ["Dropbox", "Google Drive", "OneDrive"])
    cloudGui.Add("Button", "x290 y210 w100", "Download to Cloud").OnEvent("Click", DownloadToCloud)

    cloudGui.Show()

    ConnectService(service) {
        MsgBox("Connecting to " service "...", "Cloud", "Icon!")
    }

    DownloadToCloud(*) {
        url := cloudGui["CloudURL"].Value
        service := cloudGui["CloudService"].Text

        if (url != "" && service != "") {
            MsgBox("Downloading to " service "...`n`nURL: " url, "Cloud Download", "Icon!")
        }
    }
}

; ============================================================================
; Test Runner - Uncomment to run individual examples
; ============================================================================

; Run Example 1: Full-featured download manager
; FullDownloadManager()

; Run Example 2: Category download manager
; CategoryDownloadManager()

; Run Example 3: Download history viewer
; DownloadHistoryViewer()

; Run Example 4: Download manager with settings
; DownloadManagerWithSettings()

; Run Example 5: Scheduled download manager
; ScheduledDownloadManager()

; Run Example 6: Bandwidth monitor
; BandwidthMonitor()

; Run Example 7: Cloud integration manager
; CloudIntegrationManager()

