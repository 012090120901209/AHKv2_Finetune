#Requires AutoHotkey v2.0

/**
* BuiltIn_Download_08.ahk - Update Checker Systems
*
* This file demonstrates update checking and automatic update systems in AutoHotkey v2,
* showing how to check for software updates and download new versions.
*
* Features Demonstrated:
* - Version checking
* - Update detection
* - Automatic updates
* - Release notes display
* - Update scheduling
* - Delta updates
* - Rollback capabilities
*
* @author AutoHotkey Community
* @version 2.0
* @date 2024-11-16
*/

; ============================================================================
; Example 1: Basic Version Checker
; ============================================================================

/**
* Checks for software updates by comparing versions
*
* Demonstrates basic version comparison and update detection.
* Shows simple update checking logic.
*
* @example
* BasicVersionChecker()
*/
BasicVersionChecker() {
    currentVersion := "1.0.0"
    updateURL := "https://example.com/version.txt"

    ; Create version checker GUI
    versionGui := Gui("+AlwaysOnTop", "Version Checker")
    versionGui.Add("Text", "w400", "Software Update Checker")
    versionGui.Add("GroupBox", "w400 h80", "Current Version")
    versionGui.Add("Text", "x20 y35 w150", "Installed Version:")
    versionGui.Add("Edit", "x170 y32 w200 ReadOnly", currentVersion)
    versionGui.Add("Text", "x20 y60 w150", "Latest Version:")
    versionGui.Add("Edit", "x170 y57 w200 vLatestVersion ReadOnly", "Checking...")

    versionGui.Add("Button", "y110 w100", "Check for Updates").OnEvent("Click", CheckUpdates)
    versionGui.Add("Button", "x+10 w100 vDownloadBtn Disabled", "Download Update").OnEvent("Click", DownloadUpdate)
    versionGui.Add("Text", "y+10 w400 vStatus", "Ready to check for updates")

    versionGui.Show("w420 h180")

    CheckUpdates(*) {
        versionGui["Status"].Text := "Checking for updates..."
        versionGui["Button1"].Enabled := false

        try {
            ; Simulate downloading version file
            ; In reality: Download(updateURL, A_Temp "\version.txt")
            latestVersion := "1.2.0"  ; Simulated

            versionGui["LatestVersion"].Value := latestVersion

            ; Compare versions
            if CompareVersions(latestVersion, currentVersion) > 0 {
                versionGui["Status"].Text := "New version available!"
                versionGui["DownloadBtn"].Enabled := true

                MsgBox("A new version is available!`n`n"
                . "Current: " currentVersion "`n"
                . "Latest: " latestVersion, "Update Available", "Icon!")
            } else {
                versionGui["Status"].Text := "You have the latest version"
                MsgBox("You are running the latest version!", "Up to Date", "Icon!")
            }
        } catch as err {
            versionGui["Status"].Text := "Failed to check for updates"
            versionGui["LatestVersion"].Value := "Error"
            MsgBox("Update check failed!`n`n" err.Message, "Error", "IconX")
        }

        versionGui["Button1"].Enabled := true
    }

    DownloadUpdate(*) {
        MsgBox("Downloading update...", "Download", "Icon!")
    }

    /**
    * Compares two version strings
    * @return 1 if v1 > v2, -1 if v1 < v2, 0 if equal
    */
    CompareVersions(v1, v2) {
        parts1 := StrSplit(v1, ".")
        parts2 := StrSplit(v2, ".")

        loop Min(parts1.Length, parts2.Length) {
            n1 := Integer(parts1[A_Index])
            n2 := Integer(parts2[A_Index])

            if (n1 > n2)
            return 1
            if (n1 < n2)
            return -1
        }

        if (parts1.Length > parts2.Length)
        return 1
        if (parts1.Length < parts2.Length)
        return -1

        return 0
    }
}

; ============================================================================
; Example 2: Auto-Update System
; ============================================================================

/**
* Automatically checks and downloads updates
*
* Implements automatic update checking with user prompts.
* Demonstrates auto-update functionality.
*
* @example
* AutoUpdateSystem()
*/
AutoUpdateSystem() {
    appName := "MyApplication"
    currentVersion := "2.1.0"
    updateCheckURL := "https://example.com/update.json"

    ; Create auto-update GUI
    autoGui := Gui("+AlwaysOnTop", "Auto-Update System")
    autoGui.Add("Text", "w500", appName " - Automatic Update System")

    autoGui.Add("GroupBox", "w500 h120", "Update Information")
    autoGui.Add("Text", "x20 y35", "Current Version:")
    autoGui.Add("Text", "x150 y35", currentVersion)
    autoGui.Add("Text", "x20 y60", "Status:")
    autoGui.Add("Text", "x150 y60 w300 vUpdateStatus", "Checking for updates...")
    autoGui.Add("Progress", "x20 y85 w460 h20 vUpdateProgress", "0")

    autoGui.Add("Edit", "x10 y140 w500 h150 vUpdateLog ReadOnly +Multi")

    autoGui.Add("Checkbox", "x10 y300 vAutoCheck Checked", "Automatically check for updates on startup")
    autoGui.Add("Button", "y330 w100", "Check Now").OnEvent("Click", CheckForUpdates)
    autoGui.Add("Button", "x+10 w100 vInstallBtn Disabled", "Install Update").OnEvent("Click", InstallUpdate)
    autoGui.Add("Button", "x+10 w100", "Close").OnEvent("Click", (*) => autoGui.Destroy())

    autoGui.Show("w520 h370")

    updateLog := []
    availableUpdate := false

    AddLog(message) {
        timestamp := FormatTime(, "HH:mm:ss")
        logEntry := "[" timestamp "] " message
        updateLog.Push(logEntry)

        logText := ""
        for entry in updateLog
        logText .= entry "`n"

        autoGui["UpdateLog"].Value := logText
    }

    CheckForUpdates(*) {
        autoGui["Button1"].Enabled := false
        autoGui["UpdateStatus"].Text := "Checking for updates..."
        autoGui["UpdateProgress"].Value := 0

        AddLog("Starting update check...")
        AddLog("Update URL: " updateCheckURL)

        try {
            ; Simulate update check
            autoGui["UpdateProgress"].Value := 25
            Sleep(500)

            AddLog("Connecting to update server...")
            autoGui["UpdateProgress"].Value := 50

            ; Simulate download of update manifest
            updateInfo := {
                version: "2.2.0",
                size: 5242880,  ; 5 MB
                url: "https://example.com/app_2.2.0.exe",
                releaseDate: "2024-11-16",
                critical: false,
                changelog: "- Bug fixes`n- Performance improvements`n- New features"
            }

            autoGui["UpdateProgress"].Value := 75
            AddLog("Retrieved update information")

            if CompareVersions(updateInfo.version, currentVersion) > 0 {
                autoGui["UpdateProgress"].Value := 100
                autoGui["UpdateStatus"].Text := "Update available: v" updateInfo.version

                AddLog("Update found: Version " updateInfo.version)
                AddLog("Size: " FormatBytes(updateInfo.size))
                AddLog("Released: " updateInfo.releaseDate)

                availableUpdate := true
                autoGui["InstallBtn"].Enabled := true

                ; Show update dialog
                result := MsgBox("Update Available!`n`n"
                . "New Version: " updateInfo.version "`n"
                . "Current Version: " currentVersion "`n"
                . "Size: " FormatBytes(updateInfo.size) "`n`n"
                . "Changelog:`n" updateInfo.changelog "`n`n"
                . "Would you like to download and install?",
                "Update Available",
                "YesNo Icon!")

                if (result = "Yes")
                InstallUpdate()
            } else {
                autoGui["UpdateProgress"].Value := 100
                autoGui["UpdateStatus"].Text := "You have the latest version"
                AddLog("No updates available")

                MsgBox("You are running the latest version!", "Up to Date", "Icon!")
            }

        } catch as err {
            autoGui["UpdateStatus"].Text := "Update check failed"
            AddLog("ERROR: " err.Message)
            MsgBox("Failed to check for updates!`n`n" err.Message, "Error", "IconX")
        }

        autoGui["Button1"].Enabled := true
    }

    InstallUpdate(*) {
        if !availableUpdate {
            MsgBox("No update available!", "Error", "IconX")
            return
        }

        AddLog("Starting update download...")
        autoGui["UpdateStatus"].Text := "Downloading update..."

        ; Simulate download
        loop 100 {
            autoGui["UpdateProgress"].Value := A_Index
            Sleep(20)
        }

        AddLog("Download complete")
        AddLog("Preparing to install...")

        MsgBox("Update downloaded successfully!`n`n"
        . "The application will now close and install the update.",
        "Update Ready", "Icon!")
    }

    CompareVersions(v1, v2) {
        parts1 := StrSplit(v1, ".")
        parts2 := StrSplit(v2, ".")

        loop Min(parts1.Length, parts2.Length) {
            n1 := Integer(parts1[A_Index])
            n2 := Integer(parts2[A_Index])

            if (n1 > n2)
            return 1
            if (n1 < n2)
            return -1
        }

        return 0
    }
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
; Example 3: Release Notes Viewer
; ============================================================================

/**
* Displays release notes for available updates
*
* Shows detailed changelog and release information.
* Demonstrates release notes presentation.
*
* @example
* ReleaseNotesViewer()
*/
ReleaseNotesViewer() {
    releases := [
    {
        version: "2.0.0",
        date: "2024-11-16",
        type: "Major Release",
        notes: "• Complete UI redesign`n• New download engine`n• Improved performance`n• Bug fixes"
    },
    {
        version: "1.9.5",
        date: "2024-10-15",
        type: "Bug Fix",
        notes: "• Fixed crash on startup`n• Resolved memory leak`n• Updated dependencies"
    },
    {
        version: "1.9.0",
        date: "2024-09-01",
        type: "Feature Update",
        notes: "• Added dark mode`n• New file manager`n• Enhanced search`n• Performance tweaks"
    }
    ]

    ; Create release notes GUI
    notesGui := Gui("+Resize", "Release Notes")
    notesGui.Add("Text", "w600", "Version History and Release Notes")

    notesGui.Add("ListView", "w600 h150 vReleaseList", ["Version", "Date", "Type"])

    for release in releases {
        notesGui["ReleaseList"].Add("", release.version, release.date, release.type)
    }

    notesGui.Add("Edit", "w600 h250 vReleaseNotes ReadOnly +Multi")

    notesGui.Add("Button", "w100", "Download").OnEvent("Click", DownloadRelease)
    notesGui.Add("Button", "x+10 w100", "Close").OnEvent("Click", (*) => notesGui.Destroy())

    notesGui.Show("w620 h480")

    ; Show first release notes
    notesGui["ReleaseNotes"].Value := "Version: " releases[1].version "`n"
    . "Date: " releases[1].date "`n"
    . "Type: " releases[1].type "`n`n"
    . "Changes:`n" releases[1].notes

    ; Handle selection change
    notesGui["ReleaseList"].OnEvent("ItemSelect", ShowReleaseNotes)

    ShowReleaseNotes(ctrl, row, *) {
        if (row > 0 && row <= releases.Length) {
            release := releases[row]
            notesGui["ReleaseNotes"].Value := "Version: " release.version "`n"
            . "Date: " release.date "`n"
            . "Type: " release.type "`n`n"
            . "Changes:`n" release.notes
        }
    }

    DownloadRelease(*) {
        row := notesGui["ReleaseList"].GetNext()
        if (row > 0) {
            release := releases[row]
            MsgBox("Downloading version " release.version "...", "Download", "Icon!")
        }
    }
}

; ============================================================================
; Example 4: Update Scheduler
; ============================================================================

/**
* Schedules automatic update checks
*
* Configures when to check for updates.
* Demonstrates update scheduling.
*
* @example
* UpdateScheduler()
*/
UpdateScheduler() {
    settings := {
        autoCheck: true,
        checkInterval: "Daily",
        lastCheck: FormatTime(, "yyyy-MM-dd HH:mm:ss"),
        nextCheck: ""
    }

    ; Create scheduler GUI
    schedGui := Gui(, "Update Scheduler")
    schedGui.Add("Text", "w400", "Configure Automatic Update Checks")

    schedGui.Add("GroupBox", "w400 h140", "Schedule Settings")
    schedGui.Add("Checkbox", "x20 y35 vAutoCheck Checked" settings.autoCheck, "Enable automatic update checks")

    schedGui.Add("Text", "x20 y65", "Check Frequency:")
    schedGui.Add("DropDownList", "x140 y62 w200 vCheckInterval", ["Hourly", "Daily", "Weekly", "Monthly"])
    schedGui.SetControl("CheckInterval", settings.checkInterval)

    schedGui.Add("Text", "x20 y95", "Last Check:")
    schedGui.Add("Edit", "x140 y92 w200 vLastCheck ReadOnly", settings.lastCheck)

    schedGui.Add("Text", "x20 y125", "Next Check:")
    schedGui.Add("Edit", "x140 y122 w200 vNextCheck ReadOnly", CalculateNextCheck())

    schedGui.Add("GroupBox", "w400 h100 y160", "Update Behavior")
    schedGui.Add("Checkbox", "x20 y185 vAutoDownload", "Automatically download updates")
    schedGui.Add("Checkbox", "x20 y210 vNotifyOnly", "Notify only, don't auto-install")
    schedGui.Add("Checkbox", "x20 y235 vCheckBeta", "Include beta versions")

    schedGui.Add("Button", "y270 w100 Default", "Save").OnEvent("Click", SaveSchedule)
    schedGui.Add("Button", "x+10 w100", "Check Now").OnEvent("Click", CheckNow)
    schedGui.Add("Button", "x+10 w100", "Cancel").OnEvent("Click", (*) => schedGui.Destroy())

    schedGui.Show("w420 h310")

    CalculateNextCheck() {
        interval := settings.checkInterval
        hours := (interval = "Hourly") ? 1 : (interval = "Daily") ? 24 : (interval = "Weekly") ? 168 : 720

        nextTime := DateAdd(A_Now, hours, "Hours")
        return FormatTime(nextTime, "yyyy-MM-dd HH:mm:ss")
    }

    SaveSchedule(*) {
        settings.autoCheck := schedGui["AutoCheck"].Value
        settings.checkInterval := schedGui["CheckInterval"].Text

        MsgBox("Schedule settings saved!`n`n"
        . "Auto-check: " (settings.autoCheck ? "Enabled" : "Disabled") "`n"
        . "Interval: " settings.checkInterval "`n"
        . "Next check: " CalculateNextCheck(), "Saved", "Icon!")

        schedGui.Destroy()
    }

    CheckNow(*) {
        MsgBox("Checking for updates now...", "Update Check", "Icon!")
    }
}

; ============================================================================
; Example 5: Delta Update System
; ============================================================================

/**
* Implements delta updates (only changed files)
*
* Downloads only changed files instead of full package.
* Demonstrates efficient update system.
*
* @example
* DeltaUpdateSystem()
*/
DeltaUpdateSystem() {
    currentFiles := Map(
    "app.exe", {version: "1.0", size: 1024000, hash: "abc123"},
    "config.ini", {version: "1.0", size: 2048, hash: "def456"},
    "lib.dll", {version: "1.0", size: 512000, hash: "ghi789"}
    )

    updateFiles := Map(
    "app.exe", {version: "1.1", size: 1030000, hash: "abc124", changed: true},
    "config.ini", {version: "1.0", size: 2048, hash: "def456", changed: false},
    "lib.dll", {version: "1.1", size: 515000, hash: "ghi790", changed: true}
    )

    ; Create delta update GUI
    deltaGui := Gui("+AlwaysOnTop", "Delta Update System")
    deltaGui.Add("Text", "w500", "Smart Delta Updates - Download Only Changed Files")

    deltaGui.Add("ListView", "w500 h200 vDeltaList",
    ["File", "Current Ver", "New Ver", "Status", "Size"])

    totalSize := 0
    changedCount := 0

    for fileName, fileInfo in updateFiles {
        currentInfo := currentFiles[fileName]
        status := fileInfo.changed ? "Update Required" : "Up to Date"
        sizeDiff := fileInfo.changed ? fileInfo.size : 0

        if fileInfo.changed {
            changedCount++
            totalSize += sizeDiff
        }

        deltaGui["DeltaList"].Add("",
        fileName,
        currentInfo.version,
        fileInfo.version,
        status,
        FormatBytes(sizeDiff))
    }

    deltaGui.Add("Text", "w500 vSummary",
    "Files to update: " changedCount " | Total download: " FormatBytes(totalSize))

    deltaGui.Add("Progress", "w500 h20 vDeltaProgress", "0")
    deltaGui.Add("Button", "w100", "Apply Updates").OnEvent("Click", ApplyDelta)
    deltaGui.Add("Button", "x+10 w100", "Cancel").OnEvent("Click", (*) => deltaGui.Destroy())

    deltaGui.Show("w520 h320")

    ApplyDelta(*) {
        deltaGui["Button1"].Enabled := false

        processed := 0
        for fileName, fileInfo in updateFiles {
            if fileInfo.changed {
                processed++
                deltaGui["DeltaProgress"].Value := (processed / changedCount) * 100

                ; Simulate download
                Sleep(500)
            }
        }

        MsgBox("Delta update complete!`n`n"
        . "Updated " changedCount " files`n"
        . "Downloaded: " FormatBytes(totalSize), "Complete", "Icon!")

        deltaGui.Destroy()
    }
}

; ============================================================================
; Example 6: Update Rollback System
; ============================================================================

/**
* Allows rolling back to previous versions
*
* Maintains version history and allows rollback.
* Demonstrates version rollback functionality.
*
* @example
* UpdateRollbackSystem()
*/
UpdateRollbackSystem() {
    versionHistory := [
    {
        version: "2.0.0", date: "2024-11-16", status: "Current", backupPath: ""},
        {
            version: "1.9.5", date: "2024-10-15", status: "Backup Available", backupPath: "C:\Backups\1.9.5"},
            {
                version: "1.9.0", date: "2024-09-01", status: "Backup Available", backupPath: "C:\Backups\1.9.0"},
                {
                    version: "1.8.5", date: "2024-08-01", status: "Archived", backupPath: ""
                }
                ]

                ; Create rollback GUI
                rollbackGui := Gui("+Resize", "Version Rollback System")
                rollbackGui.Add("Text", "w500", "Version History and Rollback")

                rollbackGui.Add("ListView", "w500 h200 vVersionList",
                ["Version", "Date", "Status", "Backup"])

                for ver in versionHistory {
                    backup := ver.backupPath != "" ? "Available" : "None"
                    rollbackGui["VersionList"].Add("", ver.version, ver.date, ver.status, backup)
                }

                rollbackGui.Add("Text", "w500 vRollbackInfo",
                "Select a version to view details or rollback")

                rollbackGui.Add("Button", "w100 vRollbackBtn Disabled", "Rollback to This").OnEvent("Click", DoRollback)
                rollbackGui.Add("Button", "x+10 w100", "Create Backup").OnEvent("Click", CreateBackup)
                rollbackGui.Add("Button", "x+10 w100", "Delete Backup").OnEvent("Click", DeleteBackup)

                rollbackGui.Show("w520 h300")

                rollbackGui["VersionList"].OnEvent("ItemSelect", ShowVersionInfo)

                ShowVersionInfo(ctrl, row, *) {
                    if (row > 0 && row <= versionHistory.Length) {
                        ver := versionHistory[row]

                        rollbackGui["RollbackInfo"].Text := "Version: " ver.version
                        . " | Date: " ver.date
                        . " | Status: " ver.status

                        ; Enable rollback only for backup versions
                        if (ver.backupPath != "" && ver.status != "Current")
                        rollbackGui["RollbackBtn"].Enabled := true
                        else
                        rollbackGui["RollbackBtn"].Enabled := false
                    }
                }

                DoRollback(*) {
                    row := rollbackGui["VersionList"].GetNext()
                    if (row > 0) {
                        ver := versionHistory[row]

                        result := MsgBox("Rollback to version " ver.version "?`n`n"
                        . "Current data will be backed up first.`n"
                        . "This operation cannot be undone.",
                        "Confirm Rollback", "YesNo Icon!")

                        if (result = "Yes") {
                            MsgBox("Rolling back to version " ver.version "...", "Rollback", "Icon!")
                        }
                    }
                }

                CreateBackup(*) {
                    MsgBox("Creating backup of current version...", "Backup", "Icon!")
                }

                DeleteBackup(*) {
                    row := rollbackGui["VersionList"].GetNext()
                    if (row > 0) {
                        ver := versionHistory[row]
                        if (ver.backupPath != "") {
                            result := MsgBox("Delete backup for version " ver.version "?",
                            "Confirm Delete", "YesNo Icon?")
                            if (result = "Yes") {
                                MsgBox("Backup deleted!", "Deleted", "Icon!")
                            }
                        }
                    }
                }
            }

            ; ============================================================================
            ; Example 7: Multi-Channel Update System
            ; ============================================================================

            /**
            * Supports multiple update channels (stable, beta, dev)
            *
            * Allows switching between update channels.
            * Demonstrates channel-based updates.
            *
            * @example
            * MultiChannelUpdateSystem()
            */
            MultiChannelUpdateSystem() {
                channels := Map(
                "Stable", {
                    version: "1.0.0",
                    description: "Stable release - Recommended for most users",
                    updateURL: "https://example.com/stable"
                },
                "Beta", {
                    version: "1.1.0-beta",
                    description: "Beta testing - New features, may have bugs",
                    updateURL: "https://example.com/beta"
                },
                "Development", {
                    version: "1.2.0-dev",
                    description: "Development builds - Latest features, unstable",
                    updateURL: "https://example.com/dev"
                }
                )

                currentChannel := "Stable"

                ; Create channel GUI
                channelGui := Gui(, "Update Channel Manager")
                channelGui.Add("Text", "w500", "Select Update Channel")

                channelGui.Add("ListView", "w500 h150 vChannelList",
                ["Channel", "Version", "Description"])

                for name, info in channels {
                    channelGui["ChannelList"].Add("", name, info.version, info.description)
                }

                channelGui.Add("Text", "w500 vCurrentChannel", "Current Channel: " currentChannel)

                channelGui.Add("Button", "w100", "Switch Channel").OnEvent("Click", SwitchChannel)
                channelGui.Add("Button", "x+10 w100", "Check Updates").OnEvent("Click", CheckChannel)
                channelGui.Add("Button", "x+10 w100", "Close").OnEvent("Click", (*) => channelGui.Destroy())

                channelGui.Show("w520 h250")

                SwitchChannel(*) {
                    row := channelGui["ChannelList"].GetNext()
                    if (row > 0) {
                        channelName := channelGui["ChannelList"].GetText(row, 1)

                        result := MsgBox("Switch to " channelName " channel?`n`n"
                        . "Version: " channels[channelName].version "`n"
                        . channels[channelName].description,
                        "Switch Channel", "YesNo Icon?")

                        if (result = "Yes") {
                            currentChannel := channelName
                            channelGui["CurrentChannel"].Text := "Current Channel: " currentChannel
                            MsgBox("Switched to " channelName " channel!", "Success", "Icon!")
                        }
                    }
                }

                CheckChannel(*) {
                    MsgBox("Checking " currentChannel " channel for updates...", "Check", "Icon!")
                }
            }

            ; ============================================================================
            ; Test Runner - Uncomment to run individual examples
            ; ============================================================================

            ; Run Example 1: Basic version checker
            ; BasicVersionChecker()

            ; Run Example 2: Auto-update system
            ; AutoUpdateSystem()

            ; Run Example 3: Release notes viewer
            ; ReleaseNotesViewer()

            ; Run Example 4: Update scheduler
            ; UpdateScheduler()

            ; Run Example 5: Delta update system
            ; DeltaUpdateSystem()

            ; Run Example 6: Update rollback system
            ; UpdateRollbackSystem()

            ; Run Example 7: Multi-channel update system
            ; MultiChannelUpdateSystem()
