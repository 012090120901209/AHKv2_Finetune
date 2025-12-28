#Requires AutoHotkey v2.0

/**
 * BuiltIn_Download_09.ahk - File Synchronization Systems
 * 
 * This file demonstrates file synchronization and mirroring systems in AutoHotkey v2,
 * showing how to sync files between local and remote locations.
 * 
 * Features Demonstrated:
 * - Bidirectional sync
 * - Change detection
 * - Conflict resolution
 * - Sync scheduling
 * - Incremental sync
 * - Mirror mode
 * - Sync profiles
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024-11-16
 */

; ============================================================================
; File Sync Manager Class
; ============================================================================

/**
 * Manages file synchronization operations
 */
class FileSyncManager {
    syncPairs := []
    syncHistory := []
    conflictPolicy := "ask"  ; ask, newer, local, remote

    /**
     * Adds sync pair
     */
    AddSyncPair(local, remote, bidirectional := true) {
        this.syncPairs.Push({
            local: local,
            remote: remote,
            bidirectional: bidirectional,
            lastSync: "",
            status: "pending"
        })
    }

    /**
     * Compares file timestamps
     */
    CompareFiles(file1, file2) {
        if !FileExist(file1) && !FileExist(file2)
            return 0  ; Both missing

        if !FileExist(file1)
            return -1  ; File1 missing

        if !FileExist(file2)
            return 1   ; File2 missing

        time1 := FileGetTime(file1)
        time2 := FileGetTime(file2)

        if (time1 > time2)
            return 1   ; File1 newer
        if (time1 < time2)
            return -1  ; File2 newer

        return 0  ; Same timestamp
    }

    /**
     * Gets file hash for comparison
     */
    GetFileHash(filePath) {
        ; Simplified hash - in production use proper hashing
        if !FileExist(filePath)
            return ""

        size := FileGetSize(filePath)
        time := FileGetTime(filePath)
        return size . "_" . time
    }
}

; ============================================================================
; Example 1: Basic File Synchronization
; ============================================================================

/**
 * Synchronizes files between two directories
 * 
 * Demonstrates basic sync functionality.
 * Shows one-way file synchronization.
 * 
 * @example
 * BasicFileSync()
 */
BasicFileSync() {
    localDir := A_Desktop "\LocalFiles"
    remoteDir := A_Desktop "\RemoteFiles"

    ; Create directories if they don't exist
    if !FileExist(localDir)
        DirCreate(localDir)
    if !FileExist(remoteDir)
        DirCreate(remoteDir)

    ; Create sync GUI
    syncGui := Gui("+Resize +AlwaysOnTop", "Basic File Synchronization")
    syncGui.Add("Text", "w500", "One-Way File Sync")

    syncGui.Add("GroupBox", "w500 h80", "Sync Locations")
    syncGui.Add("Text", "x20 y35", "Source:")
    syncGui.Add("Edit", "x100 y32 w380 vSource ReadOnly", localDir)
    syncGui.Add("Text", "x20 y60", "Destination:")
    syncGui.Add("Edit", "x100 y57 w380 vDest ReadOnly", remoteDir)

    syncGui.Add("ListView", "w500 h200 vSyncList", ["File", "Action", "Status"])

    syncGui.Add("Progress", "w500 h20 vSyncProgress", "0")
    syncGui.Add("Text", "w500 vSyncStatus", "Ready to sync")

    syncGui.Add("Button", "w100", "Scan").OnEvent("Click", ScanFiles)
    syncGui.Add("Button", "x+10 w100 vSyncBtn Disabled", "Synchronize").OnEvent("Click", DoSync)
    syncGui.Add("Button", "x+10 w100", "Close").OnEvent("Click", (*) => syncGui.Destroy())

    syncGui.Show("w520 h410")

    filesToSync := []

    ScanFiles(*) {
        syncGui["SyncList"].Delete()
        filesToSync := []

        syncGui["SyncStatus"].Text := "Scanning files..."

        ; Scan local directory
        loop files, localDir "\*.*", "F" {
            localFile := A_LoopFilePath
            SplitPath(localFile, &fileName)
            remoteFile := remoteDir "\" fileName

            if !FileExist(remoteFile) {
                action := "Copy to destination"
                filesToSync.Push({ local: localFile, remote: remoteFile, action: "copy" })
                syncGui["SyncList"].Add("", fileName, action, "Pending")
            } else {
                ; Compare timestamps
                localTime := FileGetTime(localFile)
                remoteTime := FileGetTime(remoteFile)

                if (localTime > remoteTime) {
                    action := "Update destination"
                    filesToSync.Push({ local: localFile, remote: remoteFile, action: "update" })
                    syncGui["SyncList"].Add("", fileName, action, "Pending")
                }
            }
        }

        syncGui["SyncStatus"].Text := "Found " filesToSync.Length " files to sync"

        if (filesToSync.Length > 0)
            syncGui["SyncBtn"].Enabled := true
        else
            MsgBox("All files are up to date!", "Sync", "Icon!")
    }

    DoSync(*) {
        syncGui["SyncBtn"].Enabled := false
        total := filesToSync.Length
        processed := 0

        for index, file in filesToSync {
            syncGui["SyncList"].Modify(index, "Col3", "Syncing")
            syncGui["SyncStatus"].Text := "Syncing file " index " of " total "..."

            try {
                ; Simulate sync (in reality, use Download for remote or FileCopy for local)
                FileCopy(file.local, file.remote, 1)

                syncGui["SyncList"].Modify(index, "Col3", "Complete")
                processed++
            } catch {
                syncGui["SyncList"].Modify(index, "Col3", "Failed")
            }

            syncGui["SyncProgress"].Value := (processed / total) * 100
        }

        syncGui["SyncStatus"].Text := "Sync complete: " processed " files synchronized"

        MsgBox("Synchronization complete!`n`nProcessed: " processed " files", "Complete", "Icon!")
    }
}

; ============================================================================
; Example 2: Bidirectional Sync
; ============================================================================

/**
 * Two-way file synchronization with conflict detection
 * 
 * Syncs files in both directions.
 * Demonstrates bidirectional sync and conflict handling.
 * 
 * @example
 * BidirectionalSync()
 */
BidirectionalSync() {
    dir1 := A_Desktop "\Folder1"
    dir2 := A_Desktop "\Folder2"

    ; Create directories
    if !FileExist(dir1)
        DirCreate(dir1)
    if !FileExist(dir2)
        DirCreate(dir2)

    ; Create bidirectional sync GUI
    biGui := Gui("+Resize", "Bidirectional Synchronization")
    biGui.Add("Text", "w550", "Two-Way File Sync with Conflict Resolution")

    biGui.Add("GroupBox", "w550 h80", "Sync Folders")
    biGui.Add("Text", "x20 y35", "Folder 1:")
    biGui.Add("Edit", "x100 y32 w420 vFolder1 ReadOnly", dir1)
    biGui.Add("Text", "x20 y60", "Folder 2:")
    biGui.Add("Edit", "x100 y57 w420 vFolder2 ReadOnly", dir2)

    biGui.Add("ListView", "w550 h220 vBiList",
        ["File", "Folder 1", "Folder 2", "Action", "Status"])

    biGui.Add("Text", , "Conflict Resolution:")
    biGui.Add("DropDownList", "w150 vConflictPolicy", ["Ask Each Time", "Newest Wins", "Keep Both"])

    biGui.Add("Progress", "w550 h20 vBiProgress", "0")

    biGui.Add("Button", "w100", "Analyze").OnEvent("Click", AnalyzeFolders)
    biGui.Add("Button", "x+10 w100 vBiSyncBtn Disabled", "Sync").OnEvent("Click", DoBiSync)

    biGui.Show("w570 h450")

    syncActions := []

    AnalyzeFolders(*) {
        biGui["BiList"].Delete()
        syncActions := []

        ; Scan folder 1
        loop files, dir1 "\*.*", "F" {
            file1 := A_LoopFilePath
            SplitPath(file1, &fileName)
            file2 := dir2 "\" fileName

            if !FileExist(file2) {
                ; File only in folder 1
                syncActions.Push({
                    file: fileName,
                    action: "Copy 1->2",
                    source: file1,
                    dest: file2
                })
                biGui["BiList"].Add("", fileName, "Exists", "Missing", "Copy 1->2", "Pending")
            } else {
                ; File in both folders - check which is newer
                time1 := FileGetTime(file1)
                time2 := FileGetTime(file2)

                if (time1 > time2) {
                    syncActions.Push({ file: fileName, action: "Update 2", source: file1, dest: file2 })
                    biGui["BiList"].Add("", fileName, FormatTime(time1), FormatTime(time2), "Update 2", "Pending")
                } else if (time2 > time1) {
                    syncActions.Push({ file: fileName, action: "Update 1", source: file2, dest: file1 })
                    biGui["BiList"].Add("", fileName, FormatTime(time1), FormatTime(time2), "Update 1", "Pending")
                } else {
                    biGui["BiList"].Add("", fileName, FormatTime(time1), FormatTime(time2), "In Sync", "OK")
                }
            }
        }

        ; Scan folder 2 for files not in folder 1
        loop files, dir2 "\*.*", "F" {
            file2 := A_LoopFilePath
            SplitPath(file2, &fileName)
            file1 := dir1 "\" fileName

            if !FileExist(file1) {
                syncActions.Push({
                    file: fileName,
                    action: "Copy 2->1",
                    source: file2,
                    dest: file1
                })
                biGui["BiList"].Add("", fileName, "Missing", "Exists", "Copy 2->1", "Pending")
            }
        }

        if (syncActions.Length > 0)
            biGui["BiSyncBtn"].Enabled := true
        else
            MsgBox("Folders are already in sync!", "In Sync", "Icon!")
    }

    DoBiSync(*) {
        biGui["BiSyncBtn"].Enabled := false
        total := syncActions.Length
        processed := 0

        for index, action in syncActions {
            row := biGui["BiList"].GetCount() - syncActions.Length + index
            biGui["BiList"].Modify(row, "Col5", "Syncing")

            try {
                FileCopy(action.source, action.dest, 1)
                biGui["BiList"].Modify(row, "Col5", "Complete")
                processed++
            } catch {
                biGui["BiList"].Modify(row, "Col5", "Failed")
            }

            biGui["BiProgress"].Value := (processed / total) * 100
        }

        MsgBox("Bidirectional sync complete!`n`nSynced: " processed " files", "Complete", "Icon!")
    }
}

; ============================================================================
; Example 3: Incremental Sync
; ============================================================================

/**
 * Incremental synchronization (only changed files)
 * 
 * Syncs only files that have changed since last sync.
 * Demonstrates efficient incremental sync.
 * 
 * @example
 * IncrementalSync()
 */
IncrementalSync() {
    sourceDir := A_Desktop "\Source"
    targetDir := A_Desktop "\Target"
    stateFile := A_ScriptDir "\sync_state.txt"

    ; Create GUI
    incGui := Gui("+AlwaysOnTop", "Incremental Sync")
    incGui.Add("Text", "w500", "Incremental File Synchronization")

    incGui.Add("GroupBox", "w500 h100", "Sync Information")
    incGui.Add("Text", "x20 y35", "Last Sync:")
    incGui.Add("Edit", "x120 y32 w360 vLastSync ReadOnly", GetLastSyncTime())
    incGui.Add("Text", "x20 y65", "Files Changed:")
    incGui.Add("Edit", "x120 y62 w100 vChangedCount ReadOnly", "0")
    incGui.Add("Text", "x240 y65", "Total Files:")
    incGui.Add("Edit", "x330 y62 w100 vTotalCount ReadOnly", "0")

    incGui.Add("ListView", "w500 h200 vIncList", ["File", "Change Type", "Date Modified"])

    incGui.Add("Button", "w100", "Detect Changes").OnEvent("Click", DetectChanges)
    incGui.Add("Button", "x+10 w100 vIncSyncBtn Disabled", "Sync Changes").OnEvent("Click", SyncChanges)

    incGui.Show("w520 h390")

    changedFiles := []
    lastSyncState := Map()

    GetLastSyncTime() {
        if FileExist(stateFile) {
            content := FileRead(stateFile)
            lines := StrSplit(content, "`n")
            if (lines.Length > 0)
                return lines[1]
        }
        return "Never"
    }

    LoadSyncState() {
        lastSyncState := Map()

        if !FileExist(stateFile)
            return

        content := FileRead(stateFile)
        loop parse, content, "`n", "`r" {
            if (A_Index = 1)  ; Skip timestamp line
                continue

            if (A_LoopField = "")
                continue

            parts := StrSplit(A_LoopField, "|")
            if (parts.Length >= 2)
                lastSyncState[parts[1]] := parts[2]
        }
    }

    DetectChanges(*) {
        LoadSyncState()
        changedFiles := []
        totalFiles := 0

        if !FileExist(sourceDir)
            DirCreate(sourceDir)

        incGui["IncList"].Delete()

        ; Scan for changes
        loop files, sourceDir "\*.*", "FR" {
            totalFiles++
            filePath := A_LoopFilePath
            relativePath := StrReplace(filePath, sourceDir "\", "")
            modTime := FileGetTime(filePath)

            ; Check if file is new or modified
            if !lastSyncState.Has(relativePath) {
                changedFiles.Push({ path: relativePath, type: "New", time: modTime })
                incGui["IncList"].Add("", relativePath, "New", FormatTime(modTime))
            } else if (lastSyncState[relativePath] != modTime) {
                changedFiles.Push({ path: relativePath, type: "Modified", time: modTime })
                incGui["IncList"].Add("", relativePath, "Modified", FormatTime(modTime))
            }
        }

        incGui["ChangedCount"].Value := changedFiles.Length
        incGui["TotalCount"].Value := totalFiles

        if (changedFiles.Length > 0)
            incGui["IncSyncBtn"].Enabled := true
        else
            MsgBox("No changes detected!", "Up to Date", "Icon!")
    }

    SyncChanges(*) {
        if !FileExist(targetDir)
            DirCreate(targetDir)

        for file in changedFiles {
            sourcePath := sourceDir "\" file.path
            targetPath := targetDir "\" file.path

            ; Create target directory if needed
            SplitPath(targetPath, , &targetFolder)
            if !FileExist(targetFolder)
                DirCreate(targetFolder)

            try {
                FileCopy(sourcePath, targetPath, 1)
            }
        }

        ; Update sync state
        SaveSyncState()

        MsgBox("Incremental sync complete!`n`nSynced " changedFiles.Length " changed files",
            "Complete", "Icon!")

        incGui["LastSync"].Value := FormatTime(, "yyyy-MM-dd HH:mm:ss")
    }

    SaveSyncState() {
        stateContent := FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n"

        loop files, sourceDir "\*.*", "FR" {
            relativePath := StrReplace(A_LoopFilePath, sourceDir "\", "")
            modTime := FileGetTime(A_LoopFilePath)
            stateContent .= relativePath "|" modTime "`n"
        }

        FileDelete(stateFile)
        FileAppend(stateContent, stateFile)
    }
}

; ============================================================================
; Example 4: Sync Profiles Manager
; ============================================================================

/**
 * Manages multiple sync profiles
 * 
 * Saves and loads different sync configurations.
 * Demonstrates profile-based synchronization.
 * 
 * @example
 * SyncProfilesManager()
 */
SyncProfilesManager() {
    profiles := Map(
        "Documents", { source: A_MyDocuments, target: "\\server\backup\docs", enabled: true },
        "Pictures", { source: A_MyDocuments "\Pictures", target: "\\server\backup\pics", enabled: true },
        "Projects", { source: "C:\Projects", target: "D:\Backup\Projects", enabled: false }
    )

    ; Create profiles GUI
    profilesGui := Gui("+Resize", "Sync Profiles Manager")
    profilesGui.Add("Text", "w600", "Manage Synchronization Profiles")

    profilesGui.Add("ListView", "w600 h200 vProfileList Checked",
        ["Profile", "Source", "Target", "Enabled"])

    for name, profile in profiles {
        row := profilesGui["ProfileList"].Add("", name, profile.source, profile.target,
            profile.enabled ? "Yes" : "No")
        if profile.enabled
            profilesGui["ProfileList"].Modify(row, "Check")
    }

    profilesGui.Add("Button", "w100", "New Profile").OnEvent("Click", NewProfile)
    profilesGui.Add("Button", "x+10 w100", "Edit Profile").OnEvent("Click", EditProfile)
    profilesGui.Add("Button", "x+10 w100", "Delete Profile").OnEvent("Click", DeleteProfile)
    profilesGui.Add("Button", "x+10 w100", "Sync All").OnEvent("Click", SyncAll)

    profilesGui.Show("w620 h280")

    NewProfile(*) {
        MsgBox("Create new sync profile...", "New Profile", "Icon!")
    }

    EditProfile(*) {
        row := profilesGui["ProfileList"].GetNext()
        if (row > 0) {
            profileName := profilesGui["ProfileList"].GetText(row, 1)
            MsgBox("Edit profile: " profileName, "Edit", "Icon!")
        }
    }

    DeleteProfile(*) {
        row := profilesGui["ProfileList"].GetNext()
        if (row > 0) {
            result := MsgBox("Delete this profile?", "Confirm", "YesNo Icon?")
            if (result = "Yes")
                profilesGui["ProfileList"].Delete(row)
        }
    }

    SyncAll(*) {
        synced := 0
        loop profilesGui["ProfileList"].GetCount() {
            if profilesGui["ProfileList"].GetNext(A_Index - 1, "Checked") = A_Index {
                synced++
            }
        }

        MsgBox("Syncing " synced " enabled profiles...", "Sync All", "Icon!")
    }
}

; ============================================================================
; Example 5: Real-Time Folder Monitor
; ============================================================================

/**
 * Monitors folder for changes and auto-syncs
 * 
 * Watches folder for changes and triggers sync.
 * Demonstrates real-time monitoring.
 * 
 * @example
 * RealTimeFolderMonitor()
 */
RealTimeFolderMonitor() {
    watchedFolder := A_Desktop "\Watched"
    syncTarget := A_Desktop "\Synced"

    if !FileExist(watchedFolder)
        DirCreate(watchedFolder)
    if !FileExist(syncTarget)
        DirCreate(syncTarget)

    ; Create monitor GUI
    monitorGui := Gui("+AlwaysOnTop", "Real-Time Folder Monitor")
    monitorGui.Add("Text", "w500", "Auto-Sync Folder Monitor")

    monitorGui.Add("GroupBox", "w500 h80", "Monitoring")
    monitorGui.Add("Text", "x20 y35", "Watched:")
    monitorGui.Add("Edit", "x100 y32 w380 ReadOnly", watchedFolder)
    monitorGui.Add("Text", "x20 y60", "Target:")
    monitorGui.Add("Edit", "x100 y57 w380 ReadOnly", syncTarget)

    monitorGui.Add("Edit", "w500 h200 vEventLog ReadOnly +Multi")

    monitorGui.Add("Checkbox", "vAutoSync Checked", "Enable Auto-Sync")
    monitorGui.Add("Button", "x+10 w100", "Start Monitor").OnEvent("Click", StartMonitor)
    monitorGui.Add("Button", "x+10 w100", "Stop Monitor").OnEvent("Click", StopMonitor)

    monitorGui.Show("w520 h370")

    eventLog := []
    isMonitoring := false

    AddEvent(message) {
        timestamp := FormatTime(, "HH:mm:ss")
        eventLog.Push("[" timestamp "] " message)

        logText := ""
        for event in eventLog
            logText .= event "`n"

        monitorGui["EventLog"].Value := logText
    }

    StartMonitor(*) {
        isMonitoring := true
        AddEvent("Monitoring started")
        AddEvent("Watching: " watchedFolder)

        ; In real implementation, would use file system watcher
        SetTimer(CheckForChanges, 5000)
    }

    StopMonitor(*) {
        isMonitoring := false
        SetTimer(CheckForChanges, 0)
        AddEvent("Monitoring stopped")
    }

    CheckForChanges() {
        if !isMonitoring
            return

        ; Simplified change detection
        static lastCheck := A_Now

        loop files, watchedFolder "\*.*", "F" {
            modTime := FileGetTime(A_LoopFilePath)
            if (modTime > lastCheck) {
                SplitPath(A_LoopFilePath, &fileName)
                AddEvent("Change detected: " fileName)

                if monitorGui["AutoSync"].Value {
                    AddEvent("Auto-syncing: " fileName)
                    ; Perform sync
                }
            }
        }

        lastCheck := A_Now
    }
}

; ============================================================================
; Example 6: Sync Statistics Dashboard
; ============================================================================

/**
 * Displays sync statistics and history
 * 
 * Shows detailed sync metrics and history.
 * Demonstrates analytics for sync operations.
 * 
 * @example
 * SyncStatisticsDashboard()
 */
SyncStatisticsDashboard() {
    ; Create stats GUI
    statsGui := Gui("+Resize", "Sync Statistics Dashboard")
    statsGui.Add("Text", "w600", "Synchronization Statistics")

    ; Overall stats
    statsGui.Add("GroupBox", "w600 h100", "Overall Statistics")
    statsGui.Add("Text", "x20 y35 w150", "Total Syncs:")
    statsGui.Add("Text", "x170 y35 w100", "127")
    statsGui.Add("Text", "x290 y35 w150", "Files Synced:")
    statsGui.Add("Text", "x440 y35 w100", "4,523")

    statsGui.Add("Text", "x20 y60 w150", "Data Transferred:")
    statsGui.Add("Text", "x170 y60 w100", "2.4 GB")
    statsGui.Add("Text", "x290 y60 w150", "Success Rate:")
    statsGui.Add("Text", "x440 y60 w100", "98.7%")

    ; Recent syncs
    statsGui.Add("ListView", "w600 h200", ["Date/Time", "Profile", "Files", "Size", "Duration"])
    statsGui["ListView1"].Add("", "2024-11-16 14:30", "Documents", "25", "45 MB", "2m 15s")
    statsGui["ListView1"].Add("", "2024-11-16 12:00", "Pictures", "12", "120 MB", "5m 30s")
    statsGui["ListView1"].Add("", "2024-11-15 18:00", "Projects", "156", "340 MB", "12m 45s")

    statsGui.Add("Button", "w100", "Export Report").OnEvent("Click", ExportReport)
    statsGui.Add("Button", "x+10 w100", "Clear History").OnEvent("Click", ClearHistory)

    statsGui.Show("w620 h380")

    ExportReport(*) {
        reportFile := A_Desktop "\sync_report.txt"
        report := "Sync Statistics Report`n"
        report .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"
        report .= "Total Syncs: 127`n"
        report .= "Files Synced: 4,523`n"
        report .= "Data Transferred: 2.4 GB`n"

        FileDelete(reportFile)
        FileAppend(report, reportFile)
        MsgBox("Report exported to:`n" reportFile, "Exported", "Icon!")
    }

    ClearHistory(*) {
        result := MsgBox("Clear sync history?", "Confirm", "YesNo Icon?")
        if (result = "Yes")
            MsgBox("History cleared!", "Cleared", "Icon!")
    }
}

; ============================================================================
; Example 7: Cloud Sync Manager
; ============================================================================

/**
 * Synchronizes with cloud storage services
 * 
 * Integrates with cloud providers for sync.
 * Demonstrates cloud synchronization.
 * 
 * @example
 * CloudSyncManager()
 */
CloudSyncManager() {
    ; Create cloud sync GUI
    cloudGui := Gui("+Resize", "Cloud Sync Manager")
    cloudGui.Add("Text", "w600", "Cloud Storage Synchronization")

    ; Cloud services
    cloudGui.Add("ListView", "w600 h150 vCloudList",
        ["Service", "Status", "Last Sync", "Files", "Size"])

    cloudGui["CloudList"].Add("", "Dropbox", "Connected", "2024-11-16 14:30", "523", "1.2 GB")
    cloudGui["CloudList"].Add("", "Google Drive", "Connected", "2024-11-16 12:00", "892", "3.4 GB")
    cloudGui["CloudList"].Add("", "OneDrive", "Disconnected", "---", "---", "---")

    cloudGui.Add("GroupBox", "w600 h120 y170", "Sync Settings")
    cloudGui.Add("Checkbox", "x20 y195 Checked", "Sync on startup")
    cloudGui.Add("Checkbox", "x20 y220", "Sync on file change")
    cloudGui.Add("Checkbox", "x20 y245", "Sync on schedule")
    cloudGui.Add("Text", "x200 y247", "Every:")
    cloudGui.Add("Edit", "x250 y244 w50 Number", "1")
    cloudGui.Add("DropDownList", "x310 y244 w100", ["Hours", "Days", "Weeks"])

    cloudGui.Add("Button", "y300 w100", "Connect Service").OnEvent("Click", ConnectService)
    cloudGui.Add("Button", "x+10 w100", "Sync Now").OnEvent("Click", SyncNow)
    cloudGui.Add("Button", "x+10 w100", "Settings").OnEvent("Click", ShowSettings)

    cloudGui.Show("w620 h350")

    ConnectService(*) {
        MsgBox("Connect to cloud service...", "Connect", "Icon!")
    }

    SyncNow(*) {
        row := cloudGui["CloudList"].GetNext()
        if (row > 0) {
            service := cloudGui["CloudList"].GetText(row, 1)
            MsgBox("Syncing with " service "...", "Sync", "Icon!")
        }
    }

    ShowSettings(*) {
        MsgBox("Cloud sync settings...", "Settings", "Icon!")
    }
}

; ============================================================================
; Test Runner - Uncomment to run individual examples
; ============================================================================

; Run Example 1: Basic file sync
; BasicFileSync()

; Run Example 2: Bidirectional sync
; BidirectionalSync()

; Run Example 3: Incremental sync
; IncrementalSync()

; Run Example 4: Sync profiles manager
; SyncProfilesManager()

; Run Example 5: Real-time folder monitor
; RealTimeFolderMonitor()

; Run Example 6: Sync statistics dashboard
; SyncStatisticsDashboard()

; Run Example 7: Cloud sync manager
; CloudSyncManager()

