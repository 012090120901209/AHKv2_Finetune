#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* DirectoryWatcher Library Examples - thqby/ahk2_lib
*
* File system monitoring, change detection, event handling
* Library: https://github.com/thqby/ahk2_lib/blob/master/DirectoryWatcher.ahk
*/

/**
* Example 1: Basic Directory Monitoring
*/
BasicDirectoryWatcherExample() {
    MsgBox("Basic Directory Monitoring`n`n"
    . 'watchPath := A_ScriptDir "\\\\watched"`n'
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    MsgBox('File changed: ' info.name '`nAction: ' info.action)`n"
    . "})`n`n"
    . "; Start monitoring`n"
    . "watcher.Start()")
}

/**
* Example 2: Monitor Specific File Types
*/
MonitorSpecificFilesExample() {
    MsgBox("Monitor Specific File Types`n`n"
    . 'watchPath := A_ScriptDir "\\\\documents"`n'
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    ; Only process .txt files`n"
    . "    if (InStr(info.name, '.txt')) {`n"
    . "        switch info.action {`n"
    . "            case 'ADDED':`n"
    . "                MsgBox('New text file: ' info.name)`n"
    . "            case 'MODIFIED':`n"
    . "                MsgBox('Text file modified: ' info.name)`n"
    . "            case 'REMOVED':`n"
    . "                MsgBox('Text file deleted: ' info.name)`n"
    . "        }`n"
    . "    }`n"
    . "})`n"
    . "watcher.Start()")
}

/**
* Example 3: Handle All File Events
*/
HandleAllEventsExample() {
    MsgBox("Handle All File System Events`n`n"
    . 'watchPath := A_ScriptDir "\\\\data"`n'
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    switch info.action {`n"
    . "        case 'ADDED':`n"
    . "            ToolTip('Created: ' info.name)`n"
    . "        case 'REMOVED':`n"
    . "            ToolTip('Deleted: ' info.name)`n"
    . "        case 'MODIFIED':`n"
    . "            ToolTip('Modified: ' info.name)`n"
    . "        case 'RENAMED':`n"
    . "            ToolTip('Renamed: ' info.oldName ' -> ' info.name)`n"
    . "    }`n"
    . "    SetTimer(() => ToolTip(), -3000)`n"
    . "})`n"
    . "watcher.Start()")
}

/**
* Example 4: Recursive Directory Monitoring
*/
RecursiveWatcherExample() {
    MsgBox("Recursive Directory Monitoring`n`n"
    . 'watchPath := A_ScriptDir "\\\\project"`n'
    . "; Watch all subdirectories recursively`n"
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    MsgBox('Change detected: ' info.name '`nAction: ' info.action)`n"
    . "}, true)  ; true enables recursive watching`n`n"
    . "watcher.Start()")
}

/**
* Example 5: Log File Changes
*/
LogFileChangesExample() {
    MsgBox("Log All File System Changes`n`n"
    . 'watchPath := A_ScriptDir "\\\\monitored"`n'
    . 'logFile := A_ScriptDir "\\\\file_changes.log"`n`n'
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    timestamp := FormatTime(A_Now, 'yyyy-MM-dd HH:mm:ss')`n"
    . "    logEntry := timestamp ' - ' info.action ' - ' info.name '`n'`n"
    . "    FileAppend(logEntry, logFile)`n"
    . "})`n`n"
    . "watcher.Start()`n"
    . 'MsgBox("Logging file changes to: " logFile)')
}

/**
* Example 6: Auto-Backup on File Change
*/
AutoBackupExample() {
    MsgBox("Auto-Backup Modified Files`n`n"
    . 'watchPath := A_ScriptDir "\\\\work"`n'
    . 'backupPath := A_ScriptDir "\\\\backup"`n`n"
    . "; Create backup directory`n"
    . "if (!DirExist(backupPath))`n"
    . "    DirCreate(backupPath)`n`n"
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    if (info.action = 'MODIFIED') {`n"
    . "        sourcePath := watchPath '\\\' info.name`n"
    . "        timestamp := FormatTime(A_Now, 'yyyyMMdd_HHmmss')`n"
    . "        backupFile := backupPath '\\\' info.name '_' timestamp`n"
    . "        FileCopy(sourcePath, backupFile)`n"
    . "        ToolTip('Backed up: ' info.name)`n"
    . "        SetTimer(() => ToolTip(), -2000)`n"
    . "    }`n"
    . "})`n`n"
    . "watcher.Start()")
}

/**
* Example 7: Sync Folders
*/
SyncFoldersExample() {
    MsgBox("Sync Two Folders`n`n"
    . 'sourceFolder := A_ScriptDir "\\\\source"`n'
    . 'targetFolder := A_ScriptDir "\\\\target"`n`n'
    . "watcher := DirectoryWatcher(sourceFolder, (info) => {`n"
    . "    sourcePath := sourceFolder '\\\' info.name`n"
    . "    targetPath := targetFolder '\\\' info.name`n`n"
    . "    switch info.action {`n"
    . "        case 'ADDED', 'MODIFIED':`n"
    . "            if (FileExist(sourcePath))`n"
    . "                FileCopy(sourcePath, targetPath, true)`n"
    . "        case 'REMOVED':`n"
    . "            if (FileExist(targetPath))`n"
    . "                FileDelete(targetPath)`n"
    . "        case 'RENAMED':`n"
    . "            oldPath := targetFolder '\\\' info.oldName`n"
    . "            if (FileExist(oldPath))`n"
    . "                FileMove(oldPath, targetPath, true)`n"
    . "    }`n"
    . "})`n`n"
    . "watcher.Start()")
}

/**
* Example 8: Hot Reload Configuration
*/
HotReloadConfigExample() {
    MsgBox("Hot Reload Configuration File`n`n"
    . 'configPath := A_ScriptDir "\\\\config"`n'
    . 'configFile := "settings.ini"`n`n'
    . "LoadConfig() {`n"
    . "    global settings := Map()`n"
    . "    IniRead(settings, configPath '\\\' configFile)`n"
    . "    MsgBox('Configuration reloaded!')`n"
    . "}`n`n"
    . "watcher := DirectoryWatcher(configPath, (info) => {`n"
    . "    if (info.name = configFile && info.action = 'MODIFIED') {`n"
    . "        LoadConfig()`n"
    . "    }`n"
    . "})`n`n"
    . "watcher.Start()")
}

/**
* Example 9: File Processing Queue
*/
FileProcessingQueueExample() {
    MsgBox("File Processing Queue`n`n"
    . "class FileProcessor {`n"
    . "    queue := []`n"
    . "    processing := false`n`n"
    . "    Watch(path) {`n"
    . "        watcher := DirectoryWatcher(path, (info) => this.OnFileChange(info))`n"
    . "        watcher.Start()`n"
    . "    }`n`n"
    . "    OnFileChange(info) {`n"
    . "        if (info.action = 'ADDED') {`n"
    . "            this.queue.Push(info.name)`n"
    . "            if (!this.processing)`n"
    . "                this.ProcessQueue()`n"
    . "        }`n"
    . "    }`n`n"
    . "    ProcessQueue() {`n"
    . "        if (this.queue.Length = 0) {`n"
    . "            this.processing := false`n"
    . "            return`n"
    . "        }`n`n"
    . "        this.processing := true`n"
    . "        fileName := this.queue.RemoveAt(1)`n"
    . "        this.ProcessFile(fileName)`n"
    . "        SetTimer(() => this.ProcessQueue(), -1000)`n"
    . "    }`n`n"
    . "    ProcessFile(fileName) {`n"
    . "        MsgBox('Processing: ' fileName)`n"
    . "        ; Do actual processing here`n"
    . "    }`n"
    . "}`n`n"
    . "processor := FileProcessor()`n"
    . 'processor.Watch(A_ScriptDir "\\\\inbox")')
}

/**
* Example 10: Change Notification Manager
*/
ChangeNotificationExample() {
    MsgBox("Change Notification Manager`n`n"
    . "class ChangeNotifier {`n"
    . "    watchers := []`n`n"
    . "    AddWatch(path, callback) {`n"
    . "        watcher := DirectoryWatcher(path, callback)`n"
    . "        watcher.Start()`n"
    . "        this.watchers.Push(watcher)`n"
    . "    }`n`n"
    . "    StopAll() {`n"
    . "        for watcher in this.watchers`n"
    . "            watcher.Stop()`n"
    . "    }`n"
    . "}`n`n"
    . "notifier := ChangeNotifier()`n"
    . 'notifier.AddWatch(A_ScriptDir "\\\\folder1", (info) => MsgBox("F1: " info.name))`n'
    . 'notifier.AddWatch(A_ScriptDir "\\\\folder2", (info) => MsgBox("F2: " info.name))')
}

/**
* Example 11: Filter by File Size
*/
FilterBySizeExample() {
    MsgBox("Filter Changes by File Size`n`n"
    . 'watchPath := A_ScriptDir "\\\\downloads"`n'
    . "minSize := 1024 * 1024  ; 1 MB`n`n"
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    if (info.action = 'ADDED') {`n"
    . "        filePath := watchPath '\\\' info.name`n"
    . "        if (FileExist(filePath)) {`n"
    . "            size := FileGetSize(filePath)`n"
    . "            if (size >= minSize) {`n"
    . "                sizeMB := Round(size / 1024 / 1024, 2)`n"
    . "                MsgBox('Large file added: ' info.name ' (' sizeMB ' MB)')`n"
    . "            }`n"
    . "        }`n"
    . "    }`n"
    . "})`n`n"
    . "watcher.Start()")
}

/**
* Example 12: Rate Limiting
*/
RateLimitedWatcherExample() {
    MsgBox("Rate-Limited File Monitoring`n`n"
    . "class RateLimitedWatcher {`n"
    . "    lastNotification := Map()`n"
    . "    cooldown := 5000  ; 5 seconds`n`n"
    . "    Watch(path) {`n"
    . "        watcher := DirectoryWatcher(path, (info) => this.OnChange(info))`n"
    . "        watcher.Start()`n"
    . "    }`n`n"
    . "    OnChange(info) {`n"
    . "        now := A_TickCount`n"
    . "        key := info.action '_' info.name`n`n"
    . "        if (this.lastNotification.Has(key)) {`n"
    . "            elapsed := now - this.lastNotification[key]`n"
    . "            if (elapsed < this.cooldown)`n"
    . "                return  ; Skip notification`n"
    . "        }`n`n"
    . "        this.lastNotification[key] := now`n"
    . "        MsgBox('File event: ' info.action ' - ' info.name)`n"
    . "    }`n"
    . "}`n`n"
    . "watcher := RateLimitedWatcher()`n"
    . 'watcher.Watch(A_ScriptDir "\\\\temp")')
}

/**
* Example 13: Build System Watcher
*/
BuildSystemExample() {
    MsgBox("Auto-Build on Source Change`n`n"
    . 'sourceDir := A_ScriptDir "\\\\src"`n'
    . "building := false`n`n"
    . "Build() {`n"
    . "    if (building)`n"
    . "        return`n`n"
    . "    building := true`n"
    . "    MsgBox('Building project...')`n"
    . "    ; Run build command`n"
    . "    ; RunWait('npm run build', , 'Hide')`n"
    . "    building := false`n"
    . "    MsgBox('Build complete!')`n"
    . "}`n`n"
    . "watcher := DirectoryWatcher(sourceDir, (info) => {`n"
    . "    if (info.action = 'MODIFIED' && (InStr(info.name, '.js') || InStr(info.name, '.ts'))) {`n"
    . "        ToolTip('Source changed, rebuilding...')`n"
    . "        SetTimer(() => {`n"
    . "            ToolTip()`n"
    . "            Build()`n"
    . "        }, -1000)`n"
    . "    }`n"
    . "}, true)`n`n"
    . "watcher.Start()")
}

/**
* Example 14: File Integrity Monitor
*/
FileIntegrityExample() {
    MsgBox("File Integrity Monitoring`n`n"
    . "class IntegrityMonitor {`n"
    . "    hashes := Map()`n`n"
    . "    Watch(path) {`n"
    . "        ; Calculate initial hashes`n"
    . "        this.ScanDirectory(path)`n`n"
    . "        ; Monitor changes`n"
    . "        watcher := DirectoryWatcher(path, (info) => this.OnChange(info, path))`n"
    . "        watcher.Start()`n"
    . "    }`n`n"
    . "    ScanDirectory(path) {`n"
    . "        loop files path '\\\\*.*', 'F' {`n"
    . "            hash := this.CalculateHash(A_LoopFilePath)`n"
    . "            this.hashes[A_LoopFileName] := hash`n"
    . "        }`n"
    . "    }`n`n"
    . "    OnChange(info, basePath) {`n"
    . "        if (info.action = 'MODIFIED') {`n"
    . "            filePath := basePath '\\\' info.name`n"
    . "            newHash := this.CalculateHash(filePath)`n"
    . "            oldHash := this.hashes[info.name]`n`n"
    . "            if (newHash != oldHash) {`n"
    . "                MsgBox('File modified: ' info.name)`n"
    . "                this.hashes[info.name] := newHash`n"
    . "            }`n"
    . "        }`n"
    . "    }`n`n"
    . "    CalculateHash(filePath) {`n"
    . "        ; Simplified - use actual hash function in production`n"
    . "        return FileGetSize(filePath) . FileGetTime(filePath)`n"
    . "    }`n"
    . "}")
}

/**
* Example 15: Custom Notify Filters
*/
CustomNotifyFiltersExample() {
    MsgBox("Custom Notification Filters`n`n"
    . 'watchPath := A_ScriptDir "\\\\data"`n`n'
    . "; Monitor only file name and size changes`n"
    . "notifyFilter := 0x1 | 0x8  ; FILE_NAME | SIZE`n`n"
    . "watcher := DirectoryWatcher(watchPath, (info) => {`n"
    . "    MsgBox('Change detected: ' info.name '`nAction: ' info.action)`n"
    . "}, false, notifyFilter)`n`n"
    . "watcher.Start()`n`n"
    . "; Filter flags:`n"
    . "; FILE_NAME: 0x1`n"
    . "; DIR_NAME: 0x2`n"
    . "; ATTRIBUTES: 0x4`n"
    . "; SIZE: 0x8`n"
    . "; LAST_WRITE: 0x10`n"
    . "; LAST_ACCESS: 0x20`n"
    . "; CREATION: 0x40`n"
    . "; SECURITY: 0x100")
}

MsgBox("DirectoryWatcher Library Examples Loaded`n`n"
. "Note: These are conceptual examples.`n"
. "To use, you need to include:`n"
. "#Include <DirectoryWatcher>`n`n"
. "Available Examples:`n"
. "- BasicDirectoryWatcherExample()`n"
. "- MonitorSpecificFilesExample()`n"
. "- HandleAllEventsExample()`n"
. "- RecursiveWatcherExample()`n"
. "- LogFileChangesExample()`n"
. "- AutoBackupExample()`n"
. "- SyncFoldersExample()`n"
. "- HotReloadConfigExample()")

; Uncomment to view examples:
; BasicDirectoryWatcherExample()
; MonitorSpecificFilesExample()
; HandleAllEventsExample()
; RecursiveWatcherExample()
; LogFileChangesExample()
