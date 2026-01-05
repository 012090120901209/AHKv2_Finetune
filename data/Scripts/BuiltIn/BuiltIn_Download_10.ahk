#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Download_10.ahk - Advanced Download Patterns
 * 
 * This file demonstrates advanced download patterns and techniques in AutoHotkey v2,
 * showcasing complex scenarios and professional-grade implementations.
 * 
 * Features Demonstrated:
 * - Adaptive downloads
 * - Download pooling
 * - Smart caching
 * - API integration
 * - Content negotiation
 * - Download pipelines
 * - Advanced orchestration
 * 
 * @author AutoHotkey Community
 * @version 2.0
 * @date 2024-11-16
 */

; ============================================================================
; Example 1: Adaptive Download Manager
; ============================================================================

/**
 * Adapts download strategy based on file size and connection
 * 
 * Automatically chooses optimal download method.
 * Demonstrates intelligent download adaptation.
 * 
 * @example
 * AdaptiveDownloadManager()
 */
AdaptiveDownloadManager() {
    ; Create adaptive manager GUI
    adaptiveGui := Gui("+AlwaysOnTop", "Adaptive Download Manager")
    adaptiveGui.Add("Text", "w550", "Intelligent Download Strategy Selection")

    adaptiveGui.Add("GroupBox", "w550 h120", "Download Analysis")
    adaptiveGui.Add("Text", "x20 y35", "File Size:")
    adaptiveGui.Add("Edit", "x120 y32 w100 vFileSize ReadOnly", "Unknown")
    adaptiveGui.Add("Text", "x240 y35", "Connection:")
    adaptiveGui.Add("Edit", "x330 y32 w180 vConnectionSpeed ReadOnly", "Detecting...")

    adaptiveGui.Add("Text", "x20 y65", "Strategy:")
    adaptiveGui.Add("Edit", "x120 y62 w400 vStrategy ReadOnly", "Analyzing...")

    adaptiveGui.Add("Text", "x20 y95", "Estimated Time:")
    adaptiveGui.Add("Edit", "x120 y92 w100 vEstTime ReadOnly", "Calculating...")

    adaptiveGui.Add("ListView", "w550 h200 vAdaptiveList",
        ["File", "Size", "Method", "Priority", "Status"])

    ; Sample files
    files := [{
        url: "https://example.com/tiny.txt", size: 1024, name: "tiny.txt" }, {
            url: "https://example.com/medium.pdf", size: 5242880, name: "medium.pdf" }, {
                url: "https://example.com/large.zip", size: 104857600, name: "large.zip" }, {
                    url: "https://example.com/huge.iso", size: 4294967296, name: "huge.iso"
                }
    ]

    for file in files {
        method := DetermineMethod(file.size)
        priority := DeterminePriority(file.size)

        adaptiveGui["AdaptiveList"].Add("",
            file.name,
            FormatBytes(file.size),
            method,
            priority,
            "Queued")
    }

    adaptiveGui.Add("Button", "w100", "Start Adaptive").OnEvent("Click", StartAdaptive)
    adaptiveGui.Add("Button", "x+10 w100", "Analyze").OnEvent("Click", AnalyzeConnection)

    adaptiveGui.Show("w570 h410")

    DetermineMethod(size) {
        if (size < 10240)  ; < 10 KB
            return "Direct"
        else if (size < 10485760)  ; < 10 MB
            return "Standard"
        else if (size < 104857600)  ; < 100 MB
            return "Chunked"
        else
            return "Multi-Part"
    }

    DeterminePriority(size) {
        if (size < 1048576)  ; < 1 MB
            return "High"
        else if (size < 10485760)  ; < 10 MB
            return "Normal"
        else
            return "Low"
    }

    AnalyzeConnection(*) {
        adaptiveGui["ConnectionSpeed"].Value := "Analyzing..."

        ; Simulate connection test
        Sleep(500)

        speed := Random(100, 1000)
        adaptiveGui["ConnectionSpeed"].Value := speed " KB/s"

        ; Update strategy based on speed
        if (speed < 200)
            adaptiveGui["Strategy"].Value := "Slow connection: Sequential, Small chunks"
        else if (speed < 500)
            adaptiveGui["Strategy"].Value := "Medium connection: Parallel (2), Standard chunks"
        else
            adaptiveGui["Strategy"].Value := "Fast connection: Parallel (4), Large chunks"
    }

    StartAdaptive(*) {
        MsgBox("Starting adaptive downloads with optimal strategies...", "Adaptive", "Icon!")
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
; Example 2: Download Pool Manager
; ============================================================================

/**
 * Manages pool of reusable download connections
 * 
 * Maintains connection pool for efficiency.
 * Demonstrates connection pooling pattern.
 * 
 * @example
 * DownloadPoolManager()
 */
DownloadPoolManager() {
    poolSize := 5
    activeConnections := 0
    queuedDownloads := []

    ; Create pool GUI
    poolGui := Gui("+AlwaysOnTop", "Download Pool Manager")
    poolGui.Add("Text", "w550", "Connection Pool Management")

    poolGui.Add("GroupBox", "w550 h100", "Pool Status")
    poolGui.Add("Text", "x20 y35", "Pool Size:")
    poolGui.Add("Edit", "x120 y32 w50 vPoolSize Number ReadOnly", poolSize)
    poolGui.Add("Text", "x190 y35", "Active:")
    poolGui.Add("Edit", "x250 y32 w50 vActiveConns ReadOnly", activeConnections)
    poolGui.Add("Text", "x320 y35", "Available:")
    poolGui.Add("Edit", "x400 y32 w50 vAvailConns ReadOnly", poolSize)

    poolGui.Add("Progress", "x20 y65 w510 h20 vPoolProgress cGreen Range0-" poolSize, "0")

    poolGui.Add("ListView", "w550 h200 vPoolList",
        ["Download", "Connection", "Status", "Progress", "Speed"])

    poolGui.Add("Button", "w100", "Add Download").OnEvent("Click", AddDownload)
    poolGui.Add("Button", "x+10 w100", "Start Pool").OnEvent("Click", StartPool)
    poolGui.Add("Button", "x+10 w100", "Reset Pool").OnEvent("Click", ResetPool)

    poolGui.Show("w570 h400")

    connectionPool := []

    ; Initialize pool
    loop poolSize {
        connectionPool.Push({
            id: A_Index,
            status: "idle",
            currentDownload: ""
        })
    }

    AddDownload(*) {
        static counter := 1
        queuedDownloads.Push({
            id: counter,
            url: "https://example.com/file" counter ".zip",
            status: "queued"
        })

        poolGui["PoolList"].Add("", "file" counter ".zip", "Waiting", "Queued", "0%", "---")
        counter++
    }

    StartPool(*) {
        if (queuedDownloads.Length = 0) {
            MsgBox("No downloads queued!", "Pool", "Icon!")
            return
        }

        ; Simulate pool processing
        for download in queuedDownloads {
            ; Find available connection
            for conn in connectionPool {
                if (conn.status = "idle") {
                    conn.status := "active"
                    conn.currentDownload := download.id
                    activeConnections++

                    poolGui["ActiveConns"].Value := activeConnections
                    poolGui["AvailConns"].Value := poolSize - activeConnections
                    poolGui["PoolProgress"].Value := activeConnections

                    break
                }
            }
        }

        MsgBox("Pool started with " activeConnections " active connections!", "Pool", "Icon!")
    }

    ResetPool(*) {
        activeConnections := 0
        queuedDownloads := []

        for conn in connectionPool {
            conn.status := "idle"
            conn.currentDownload := ""
        }

        poolGui["ActiveConns"].Value := 0
        poolGui["AvailConns"].Value := poolSize
        poolGui["PoolProgress"].Value := 0
        poolGui["PoolList"].Delete()

        MsgBox("Pool reset!", "Pool", "Icon!")
    }
}

; ============================================================================
; Example 3: Smart Caching System
; ============================================================================

/**
 * Implements intelligent download caching
 * 
 * Caches downloads to avoid redundant transfers.
 * Demonstrates smart caching strategies.
 * 
 * @example
 * SmartCachingSystem()
 */
SmartCachingSystem() {
    cacheDir := A_Temp "\AHK_DownloadCache"
    if !FileExist(cacheDir)
        DirCreate(cacheDir)

    cache := Map()

    ; Create cache GUI
    cacheGui := Gui("+Resize", "Smart Download Cache")
    cacheGui.Add("Text", "w550", "Intelligent Download Caching System")

    cacheGui.Add("GroupBox", "w550 h100", "Cache Statistics")
    cacheGui.Add("Text", "x20 y35", "Cache Size:")
    cacheGui.Add("Edit", "x120 y32 w100 vCacheSize ReadOnly", "0 MB")
    cacheGui.Add("Text", "x240 y35", "Items:")
    cacheGui.Add("Edit", "x300 y32 w100 vCacheItems ReadOnly", "0")

    cacheGui.Add("Text", "x20 y65", "Hit Rate:")
    cacheGui.Add("Edit", "x120 y62 w100 vHitRate ReadOnly", "0%")
    cacheGui.Add("Text", "x240 y65", "Bandwidth Saved:")
    cacheGui.Add("Edit", "x340 y62 w160 vBandwidthSaved ReadOnly", "0 MB")

    cacheGui.Add("ListView", "w550 h200 vCacheList",
        ["URL", "Cached", "Size", "Hits", "Last Access"])

    cacheGui.Add("Button", "w100", "Clear Cache").OnEvent("Click", ClearCache)
    cacheGui.Add("Button", "x+10 w100", "View Stats").OnEvent("Click", ViewStats)
    cacheGui.Add("Button", "x+10 w100", "Settings").OnEvent("Click", CacheSettings)

    cacheGui.Show("w570 h400")

    ; Add sample cache entries
    cache["example.com/file1.pdf"] := {
        size: 524288,
        hits: 3,
        lastAccess: A_Now,
        cachePath: cacheDir "\file1.pdf"
    }

    cache["example.com/image.jpg"] := {
        size: 102400,
        hits: 7,
        lastAccess: A_Now,
        cachePath: cacheDir "\image.jpg"
    }

    UpdateCacheDisplay()

    UpdateCacheDisplay() {
        cacheGui["CacheList"].Delete()

        totalSize := 0
        totalHits := 0

        for url, entry in cache {
            cacheGui["CacheList"].Add("",
                url,
                "Yes",
                FormatBytes(entry.size),
                entry.hits,
                FormatTime(entry.lastAccess, "yyyy-MM-dd HH:mm"))

            totalSize += entry.size
            totalHits += entry.hits
        }

        cacheGui["CacheSize"].Value := Round(totalSize / (1024 * 1024), 2) " MB"
        cacheGui["CacheItems"].Value := cache.Count
        cacheGui["HitRate"].Value := Round((totalHits / (cache.Count + totalHits)) * 100, 1) "%"
    }

    ClearCache(*) {
        result := MsgBox("Clear all cached downloads?", "Confirm", "YesNo Icon?")
        if (result = "Yes") {
            cache := Map()
            UpdateCacheDisplay()
            MsgBox("Cache cleared!", "Cache", "Icon!")
        }
    }

    ViewStats(*) {
        stats := "Cache Statistics Report`n`n"
        stats .= "Total Items: " cache.Count "`n"
        stats .= "Total Size: " cacheGui["CacheSize"].Value "`n"
        stats .= "Hit Rate: " cacheGui["HitRate"].Value "`n"

        MsgBox(stats, "Cache Stats", "Icon!")
    }

    CacheSettings(*) {
        settingsGui := Gui("+Owner" cacheGui.Hwnd, "Cache Settings")
        settingsGui.Add("Text", , "Max Cache Size (MB):")
        settingsGui.Add("Edit", "w100 Number", "1000")
        settingsGui.Add("Text", , "Cache Location:")
        settingsGui.Add("Edit", "w300 ReadOnly", cacheDir)
        settingsGui.Add("Checkbox", , "Auto-clean old entries")
        settingsGui.Add("Button", "Default", "Save").OnEvent("Click", (*) => settingsGui.Destroy())
        settingsGui.Show()
    }
}

; ============================================================================
; Example 4: API Download Orchestrator
; ============================================================================

/**
 * Orchestrates downloads from various APIs
 * 
 * Manages downloads from different API sources.
 * Demonstrates API integration patterns.
 * 
 * @example
 * APIDownloadOrchestrator()
 */
APIDownloadOrchestrator() {
    apis := Map(
        "GitHub", { endpoint: "api.github.com", auth: "token", status: "ready" },
        "AWS S3", { endpoint: "s3.amazonaws.com", auth: "key", status: "ready" },
        "Google Drive", { endpoint: "drive.google.com", auth: "oauth", status: "ready" }
    )

    ; Create orchestrator GUI
    apiGui := Gui("+Resize", "API Download Orchestrator")
    apiGui.Add("Text", "w600", "Multi-API Download Management")

    apiGui.Add("ListView", "w600 h150 vAPIList",
        ["API", "Endpoint", "Auth Type", "Status", "Downloads"])

    for name, api in apis {
        apiGui["APIList"].Add("", name, api.endpoint, api.auth, api.status, "0")
    }

    apiGui.Add("GroupBox", "w600 h120 y170", "Queue Download")
    apiGui.Add("Text", "x20 y195", "API:")
    apiGui.Add("DropDownList", "x80 y192 w200 vAPISelect", ["GitHub", "AWS S3", "Google Drive"])

    apiGui.Add("Text", "x20 y225", "Resource:")
    apiGui.Add("Edit", "x80 y222 w500 vResource")

    apiGui.Add("Button", "x290 y255 w100", "Add to Queue").OnEvent("Click", QueueDownload)

    apiGui.Add("ListView", "w600 h150 y300 vQueueList",
        ["API", "Resource", "Status", "Progress"])

    apiGui.Add("Button", "y460 w100", "Process Queue").OnEvent("Click", ProcessQueue)

    apiGui.Show("w620 h500")

    downloadQueue := []

    QueueDownload(*) {
        apiName := apiGui["APISelect"].Text
        resource := apiGui["Resource"].Value

        if (apiName != "" && resource != "") {
            downloadQueue.Push({
                api: apiName,
                resource: resource,
                status: "queued"
            })

            apiGui["QueueList"].Add("", apiName, resource, "Queued", "0%")
            apiGui["Resource"].Value := ""
        }
    }

    ProcessQueue(*) {
        if (downloadQueue.Length = 0) {
            MsgBox("Queue is empty!", "Queue", "Icon!")
            return
        }

        for index, download in downloadQueue {
            apiGui["QueueList"].Modify(index, "Col3", "Downloading")
            Sleep(500)
            apiGui["QueueList"].Modify(index, "Col3", "Complete")
            apiGui["QueueList"].Modify(index, "Col4", "100%")
        }

        MsgBox("Queue processing complete!", "Complete", "Icon!")
    }
}

; ============================================================================
; Example 5: Content Negotiation System
; ============================================================================

/**
 * Negotiates content format and quality
 * 
 * Selects optimal format based on preferences.
 * Demonstrates content negotiation.
 * 
 * @example
 * ContentNegotiationSystem()
 */
ContentNegotiationSystem() {
    ; Create negotiation GUI
    negGui := Gui(, "Content Negotiation System")
    negGui.Add("Text", "w500", "Automatic Format and Quality Selection")

    negGui.Add("GroupBox", "w500 h140", "Content Preferences")
    negGui.Add("Text", "x20 y35", "Video Quality:")
    negGui.Add("DropDownList", "x150 y32 w200 vVideoQuality", ["Auto", "1080p", "720p", "480p", "360p"])

    negGui.Add("Text", "x20 y65", "Audio Format:")
    negGui.Add("DropDownList", "x150 y62 w200 vAudioFormat", ["Auto", "MP3", "AAC", "FLAC", "WAV"])

    negGui.Add("Text", "x20 y95", "Image Format:")
    negGui.Add("DropDownList", "x150 y92 w200 vImageFormat", ["Auto", "JPEG", "PNG", "WebP", "AVIF"])

    negGui.Add("Checkbox", "x20 y125 vPreferSize", "Prefer smaller file size")
    negGui.Add("Checkbox", "x250 y125 vPreferQuality", "Prefer higher quality")

    negGui.Add("ListView", "w500 h200 vNegList",
        ["URL", "Type", "Available Formats", "Selected", "Size"])

    ; Sample content with multiple formats
    negGui["NegList"].Add("", "video.example.com/clip", "Video",
        "1080p, 720p, 480p", "Auto (720p)", "45 MB")
    negGui["NegList"].Add("", "audio.example.com/song", "Audio",
        "MP3, AAC, FLAC", "Auto (AAC)", "4.2 MB")
    negGui["NegList"].Add("", "img.example.com/photo", "Image",
        "JPEG, PNG, WebP", "Auto (WebP)", "1.8 MB")

    negGui.Add("Button", "w100", "Apply Preferences").OnEvent("Click", ApplyPrefs)
    negGui.Add("Button", "x+10 w100", "Download Selected").OnEvent("Click", DownloadSelected)

    negGui.Show("w520 h460")

    ApplyPrefs(*) {
        MsgBox("Applying content negotiation preferences...", "Preferences", "Icon!")
    }

    DownloadSelected(*) {
        MsgBox("Downloading content with negotiated formats...", "Download", "Icon!")
    }
}

; ============================================================================
; Example 6: Download Pipeline System
; ============================================================================

/**
 * Implements download processing pipeline
 * 
 * Chains download operations with processors.
 * Demonstrates pipeline pattern.
 * 
 * @example
 * DownloadPipelineSystem()
 */
DownloadPipelineSystem() {
    ; Create pipeline GUI
    pipelineGui := Gui("+Resize", "Download Pipeline")
    pipelineGui.Add("Text", "w600", "Download Processing Pipeline")

    ; Pipeline stages
    pipelineGui.Add("ListView", "w600 h200 vPipelineStages",
        ["Stage", "Type", "Status", "Processed", "Output"])

    stages := [{
        name: "1. Download", type: "Fetch", status: "Ready", processed: "0" }, {
            name: "2. Validate", type: "Verify", status: "Waiting", processed: "0" }, {
                name: "3. Extract", type: "Decompress", status: "Waiting", processed: "0" }, {
                    name: "4. Transform", type: "Convert", status: "Waiting", processed: "0" }, {
                        name: "5. Store", type: "Save", status: "Waiting", processed: "0"
                    }
    ]

    for stage in stages {
        pipelineGui["PipelineStages"].Add("",
            stage.name,
            stage.type,
            stage.status,
            stage.processed,
            "---")
    }

    pipelineGui.Add("GroupBox", "w600 h100 y220", "Pipeline Configuration")
    pipelineGui.Add("Checkbox", "x20 y245 Checked", "Enable validation")
    pipelineGui.Add("Checkbox", "x20 y270 Checked", "Auto-extract archives")
    pipelineGui.Add("Checkbox", "x250 y245 Checked", "Convert formats")
    pipelineGui.Add("Checkbox", "x250 y270", "Generate thumbnails")

    pipelineGui.Add("Button", "y330 w100", "Start Pipeline").OnEvent("Click", StartPipeline)
    pipelineGui.Add("Button", "x+10 w100", "Configure").OnEvent("Click", ConfigurePipeline)

    pipelineGui.Show("w620 h380")

    StartPipeline(*) {
        ; Simulate pipeline execution
        for index, stage in stages {
            pipelineGui["PipelineStages"].Modify(index, "Col3", "Processing")
            Sleep(500)
            pipelineGui["PipelineStages"].Modify(index, "Col3", "Complete")
            pipelineGui["PipelineStages"].Modify(index, "Col4", "1")
        }

        MsgBox("Pipeline execution complete!", "Pipeline", "Icon!")
    }

    ConfigurePipeline(*) {
        MsgBox("Configure pipeline stages and processors...", "Configure", "Icon!")
    }
}

; ============================================================================
; Example 7: Enterprise Download Orchestration
; ============================================================================

/**
 * Complete enterprise download orchestration system
 * 
 * Full-featured enterprise-grade download management.
 * Demonstrates production deployment patterns.
 * 
 * @example
 * EnterpriseDownloadOrchestration()
 */
EnterpriseDownloadOrchestration() {
    ; Create enterprise GUI
    enterpriseGui := Gui("+Resize", "Enterprise Download Orchestration")
    enterpriseGui.SetFont("s9", "Segoe UI")

    ; Tab control for different sections
    enterpriseGui.Add("Tab3", "w800 h500 vMainTabs",
        ["Dashboard", "Queue", "Monitoring", "Reports", "Settings"])

    ; Dashboard tab
    enterpriseGui["MainTabs"].UseTab("Dashboard")
    enterpriseGui.Add("Text", "x20 y40", "System Status: Operational")
    enterpriseGui.Add("ListView", "x20 y70 w760 h200",
        ["Metric", "Current", "Average", "Peak"])

    metrics := [
        ["Active Downloads", "12", "8", "25"],
        ["Queue Size", "45", "30", "120"],
        ["Bandwidth Usage", "5.2 MB/s", "3.8 MB/s", "10.5 MB/s"],
        ["Success Rate", "98.7%", "97.5%", "99.2%"],
        ["Avg Speed", "1.2 MB/s", "950 KB/s", "2.1 MB/s"]
    ]

    for metric in metrics {
        enterpriseGui["ListView1"].Add("", metric[1], metric[2], metric[3], metric[4])
    }

    ; Queue tab
    enterpriseGui["MainTabs"].UseTab("Queue")
    enterpriseGui.Add("ListView", "x20 y70 w760 h400",
        ["ID", "URL", "Priority", "Status", "Progress", "ETA"])

    ; Monitoring tab
    enterpriseGui["MainTabs"].UseTab("Monitoring")
    enterpriseGui.Add("Text", "x20 y40", "Real-Time System Monitoring")
    enterpriseGui.Add("Edit", "x20 y70 w760 h400 ReadOnly +Multi", "System log output here...")

    ; Reports tab
    enterpriseGui["MainTabs"].UseTab("Reports")
    enterpriseGui.Add("Text", "x20 y40", "Download Reports and Analytics")
    enterpriseGui.Add("ListView", "x20 y70 w760 h300",
        ["Date", "Total Downloads", "Success", "Failed", "Data"])

    enterpriseGui.Add("Button", "x20 y380 w100", "Generate Report")
    enterpriseGui.Add("Button", "x+10 w100", "Export Data")

    ; Settings tab
    enterpriseGui["MainTabs"].UseTab("Settings")
    enterpriseGui.Add("Text", "x20 y40", "System Configuration")
    enterpriseGui.Add("GroupBox", "x20 y70 w760 h180", "Performance Settings")
    enterpriseGui.Add("Text", "x40 y95", "Max Concurrent Downloads:")
    enterpriseGui.Add("Edit", "x200 y92 w50 Number", "10")
    enterpriseGui.Add("Text", "x40 y125", "Connection Timeout (s):")
    enterpriseGui.Add("Edit", "x200 y122 w50 Number", "30")
    enterpriseGui.Add("Text", "x40 y155", "Retry Attempts:")
    enterpriseGui.Add("Edit", "x200 y152 w50 Number", "3")

    enterpriseGui["MainTabs"].UseTab()

    ; Status bar
    enterpriseGui.Add("Text", "x10 y520 w800 h20 Border",
        "Enterprise Download Orchestration v2.0 | Status: Online | Active Users: 5")

    enterpriseGui.Show("w820 h550")
}

; ============================================================================
; Test Runner - Uncomment to run individual examples
; ============================================================================

; Run Example 1: Adaptive download manager
; AdaptiveDownloadManager()

; Run Example 2: Download pool manager
; DownloadPoolManager()

; Run Example 3: Smart caching system
; SmartCachingSystem()

; Run Example 4: API download orchestrator
; APIDownloadOrchestrator()

; Run Example 5: Content negotiation system
; ContentNegotiationSystem()

; Run Example 6: Download pipeline system
; DownloadPipelineSystem()

; Run Example 7: Enterprise download orchestration
; EnterpriseDownloadOrchestration()

