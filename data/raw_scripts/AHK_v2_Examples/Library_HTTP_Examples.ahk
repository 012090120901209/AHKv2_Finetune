#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * WinHttpRequest & DownloadAsync Examples - thqby/ahk2_lib
 *
 * HTTP requests, async downloads, and API interactions
 * Libraries:
 * - https://github.com/thqby/ahk2_lib/blob/master/WinHttpRequest.ahk
 * - https://github.com/thqby/ahk2_lib/blob/master/DownloadAsync.ahk
 */

/**
 * Example 1: Simple GET Request
 */
SimpleGETExample() {
    ; Note: You need to include the WinHttpRequest library
    ; This is a conceptual example

    MsgBox("Simple GET Request Example`n`n"
        . "Usage:`n"
        . "req := WinHttpRequest()`n"
        . 'response := req.request("https://api.example.com/data")`n'
        . "MsgBox(response)")
}

/**
 * Example 2: GET with Parameters
 */
GETWithParametersExample() {
    MsgBox("GET with URL Parameters`n`n"
        . "url := `"https://api.example.com/search?q=ahk&limit=10`"`n"
        . "req := WinHttpRequest()`n"
        . "response := req.request(url)`n`n"
        . "Or build dynamically:`n"
        . 'base := "https://api.example.com/search"`n'
        . 'params := "?q=" UrlEncode("autohotkey") "&limit=10"`n'
        . "url := base . params")
}

/**
 * Example 3: POST Request with JSON
 */
POSTWithJSONExample() {
    MsgBox("POST Request with JSON Body`n`n"
        . "data := Map()`n"
        . 'data["name"] := "Alice"`n'
        . 'data["email"] := "alice@example.com"`n`n'
        . "jsonBody := JSON.stringify(data)`n`n"
        . "req := WinHttpRequest()`n"
        . 'headers := Map("Content-Type", "application/json")`n'
        . 'response := req.request("https://api.example.com/users", "POST", jsonBody, headers)')
}

/**
 * Example 4: Custom Headers
 */
CustomHeadersExample() {
    MsgBox("Request with Custom Headers`n`n"
        . "headers := Map()`n"
        . 'headers["Authorization"] := "Bearer YOUR_TOKEN"`n'
        . 'headers["User-Agent"] := "AHK-Script/1.0"`n'
        . 'headers["Accept"] := "application/json"`n`n'
        . "req := WinHttpRequest()`n"
        . 'response := req.request("https://api.example.com/protected", "GET", "", headers)')
}

/**
 * Example 5: Download File Synchronously
 */
DownloadFileSyncExample() {
    outputPath := A_ScriptDir "\downloaded_file.txt"

    MsgBox("Downloading file synchronously...")

    try {
        ; Simulate synchronous download
        ; req := WinHttpRequest()
        ; req.Open("GET", "https://example.com/file.txt", false)
        ; req.Send()
        ; FileDelete(outputPath)
        ; FileAppend(req.ResponseText, outputPath)

        MsgBox("File would be downloaded to:`n" outputPath)
    } catch Error as e {
        MsgBox("Download error: " e.Message)
    }
}

/**
 * Example 6: Async Download with Progress
 */
AsyncDownloadProgressExample() {
    url := "https://example.com/largefile.zip"
    savePath := A_ScriptDir "\download.zip"

    MsgBox("Async Download with Progress`n`n"
        . "url := `"" url "`"`n"
        . "savePath := `"" savePath "`"`n`n"
        . "DownloadAsync(url, savePath,`n"
        . "    (*) => MsgBox(`"Download complete!`"),`n"
        . "    (current, total) => ToolTip(`"Downloaded: `" current `"/`" total))`n`n"
        . "This shows real-time progress in a tooltip!")
}

/**
 * Example 7: API Request with Error Handling
 */
APIWithErrorHandlingExample() {
    MsgBox("API Request with Error Handling`n`n"
        . "try {`n"
        . "    req := WinHttpRequest()`n"
        . '    response := req.request("https://api.example.com/data")`n'
        . "    data := JSON.parse(response)`n"
        . "    MsgBox(data.Has(`"status`") ? data.status : `"No status`")`n"
        . "} catch Error as e {`n"
        . '    MsgBox("API Error: " e.Message)`n'
        . "}")
}

/**
 * Example 8: Multiple Concurrent Downloads
 */
MultipleConcurrentDownloadsExample() {
    MsgBox("Multiple Concurrent Downloads`n`n"
        . "downloads := [`n"
        . '    "https://example.com/file1.zip",`n'
        . '    "https://example.com/file2.zip",`n'
        . '    "https://example.com/file3.zip"`n'
        . "]`n`n"
        . "completed := 0`n"
        . "for url in downloads {`n"
        . "    savePath := A_ScriptDir `"\\`" A_Index `".zip`"`n"
        . "    DownloadAsync(url, savePath, (*) => {`n"
        . "        completed++`n"
        . "        if (completed = downloads.Length)`n"
        . '            MsgBox("All downloads complete!")`n'
        . "    })`n"
        . "}")
}

/**
 * Example 9: Check URL Availability
 */
CheckURLAvailabilityExample() {
    urls := [
        "https://www.google.com",
        "https://www.github.com",
        "https://invalid-url-that-does-not-exist.com"
    ]

    results := "URL Availability Check:`n`n"

    for url in urls {
        try {
            ; In real implementation:
            ; req := WinHttpRequest()
            ; req.Open("HEAD", url, false)
            ; req.Send()
            ; status := req.Status

            results .= url " - Would check here`n"
        } catch {
            results .= url " - Unavailable`n"
        }
    }

    MsgBox(results)
}

/**
 * Example 10: API Client Class
 */
APIClientExample() {
    MsgBox("API Client Class Example`n`n"
        . "class APIClient {`n"
        . "    baseURL := `"`"`n"
        . "    token := `"`"`n`n"
        . "    __New(baseURL, token := `"`") {`n"
        . "        this.baseURL := baseURL`n"
        . "        this.token := token`n"
        . "    }`n`n"
        . "    Request(endpoint, method := `"GET`", data := `"`") {`n"
        . "        url := this.baseURL . endpoint`n"
        . "        headers := Map()`n"
        . "        if (this.token)`n"
        . '            headers["Authorization"] := "Bearer " this.token`n'
        . "        req := WinHttpRequest()`n"
        . "        return req.request(url, method, data, headers)`n"
        . "    }`n"
        . "}`n`n"
        . 'api := APIClient("https://api.example.com")`n'
        . 'response := api.Request("/users")')
}

/**
 * Example 11: Download with Retry Logic
 */
DownloadWithRetryExample() {
    MsgBox("Download with Retry Logic`n`n"
        . "DownloadWithRetry(url, savePath, maxRetries := 3) {`n"
        . "    attempt := 1`n"
        . "    while (attempt <= maxRetries) {`n"
        . "        try {`n"
        . "            req := WinHttpRequest()`n"
        . '            req.Open("GET", url, false)`n'
        . "            req.Send()`n"
        . "            FileDelete(savePath)`n"
        . "            FileAppend(req.ResponseText, savePath)`n"
        . "            return true`n"
        . "        } catch {`n"
        . "            attempt++`n"
        . "            if (attempt <= maxRetries)`n"
        . "                Sleep(1000 * attempt)  ; Exponential backoff`n"
        . "        }`n"
        . "    }`n"
        . "    return false`n"
        . "}")
}

/**
 * Example 12: Rate-Limited API Requests
 */
RateLimitedRequestsExample() {
    MsgBox("Rate-Limited API Requests`n`n"
        . "class RateLimiter {`n"
        . "    requests := []`n"
        . "    maxRequests := 10`n"
        . "    timeWindow := 60000  ; 1 minute`n`n"
        . "    CanRequest() {`n"
        . "        now := A_TickCount`n"
        . "        ; Remove old requests`n"
        . "        this.requests := this.requests.Filter(`n"
        . "            (t) => (now - t) < this.timeWindow)`n"
        . "        return this.requests.Length < this.maxRequests`n"
        . "    }`n`n"
        . "    Request(url) {`n"
        . "        if (!this.CanRequest())`n"
        . '            throw Error("Rate limit exceeded")`n'
        . "        this.requests.Push(A_TickCount)`n"
        . "        req := WinHttpRequest()`n"
        . "        return req.request(url)`n"
        . "    }`n"
        . "}")
}

/**
 * Example 13: Download Progress Bar
 */
DownloadProgressBarExample() {
    MsgBox("Download with Progress Bar`n`n"
        . "progressGui := Gui()`n"
        . 'progressBar := progressGui.Add("Progress", "w300 h20")`n'
        . "progressGui.Show()`n`n"
        . "DownloadAsync(url, savePath,`n"
        . "    (*) => {`n"
        . "        progressGui.Destroy()`n"
        . '        MsgBox("Download complete!")`n'
        . "    },`n"
        . "    (current, total) => {`n"
        . "        percent := Round((current / total) * 100)`n"
        . "        progressBar.Value := percent`n"
        . "    })")
}

/**
 * Example 14: REST API CRUD Operations
 */
RESTCRUDExample() {
    MsgBox("REST API CRUD Operations`n`n"
        . "class UserAPI {`n"
        . '    static baseURL := "https://api.example.com/users"`n'
        . "    static req := WinHttpRequest()`n`n"
        . "    static Create(userData) {`n"
        . "        body := JSON.stringify(userData)`n"
        . "        headers := Map(`"Content-Type`", `"application/json`")`n"
        . "        return this.req.request(this.baseURL, `"POST`", body, headers)`n"
        . "    }`n`n"
        . "    static Read(userId) {`n"
        . "        url := this.baseURL `"/`" userId`n"
        . "        return this.req.request(url, `"GET`")`n"
        . "    }`n`n"
        . "    static Update(userId, userData) {`n"
        . "        url := this.baseURL `"/`" userId`n"
        . "        body := JSON.stringify(userData)`n"
        . "        headers := Map(`"Content-Type`", `"application/json`")`n"
        . "        return this.req.request(url, `"PUT`", body, headers)`n"
        . "    }`n`n"
        . "    static Delete(userId) {`n"
        . "        url := this.baseURL `"/`" userId`n"
        . "        return this.req.request(url, `"DELETE`")`n"
        . "    }`n"
        . "}")
}

/**
 * Example 15: Batch Download Manager
 */
BatchDownloadManagerExample() {
    MsgBox("Batch Download Manager`n`n"
        . "class DownloadManager {`n"
        . "    downloads := Map()`n"
        . "    completed := 0`n`n"
        . "    AddDownload(url, savePath) {`n"
        . "        id := url`n"
        . "        this.downloads[id] := {url: url, path: savePath, status: `"pending`"}`n"
        . "    }`n`n"
        . "    StartAll() {`n"
        . "        for id, download in this.downloads {`n"
        . "            DownloadAsync(download.url, download.path,`n"
        . "                (id) => this.OnComplete(id),`n"
        . "                (id, cur, tot) => this.OnProgress(id, cur, tot))`n"
        . "        }`n"
        . "    }`n`n"
        . "    OnComplete(id) {`n"
        . '        this.downloads[id].status := "completed"`n'
        . "        this.completed++`n"
        . "        if (this.completed = this.downloads.Count)`n"
        . '            MsgBox("All downloads finished!")`n'
        . "    }`n"
        . "}")
}

MsgBox("HTTP & Download Library Examples Loaded`n`n"
    . "Note: These are conceptual examples.`n"
    . "To use, you need to include:`n"
    . "#Include <WinHttpRequest>`n"
    . "#Include <DownloadAsync>`n"
    . "#Include <JSON>`n`n"
    . "Available Examples:`n"
    . "- SimpleGETExample()`n"
    . "- POSTWithJSONExample()`n"
    . "- AsyncDownloadProgressExample()`n"
    . "- APIClientExample()`n"
    . "- RESTCRUDExample()")

; Uncomment to view examples:
; SimpleGETExample()
; GETWithParametersExample()
; POSTWithJSONExample()
; AsyncDownloadProgressExample()
; APIClientExample()
