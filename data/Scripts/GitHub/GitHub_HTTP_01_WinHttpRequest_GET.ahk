#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
* GitHub_HTTP_01_WinHttpRequest_GET.ahk
*
* DESCRIPTION:
* Demonstrates HTTP GET requests using WinHttpRequest COM object
*
* FEATURES:
* - HTTP GET request to web APIs
* - Response status and headers
* - JSON response handling
* - Error handling for network requests
*
* SOURCE:
* Based on: thqby/ahk2_lib - WinHttpRequest.ahk
* URL: https://github.com/thqby/ahk2_lib
* Author: thqby
* License: MIT
*
* KEY V2 FEATURES DEMONSTRATED:
* - ComObject() for creating COM objects
* - Method chaining with COM objects
* - Try/catch error handling
* - Map() for response data
* - String interpolation
*
* USAGE:
* response := HttpGet("https://api.github.com")
* MsgBox(response.text)
*
* LEARNING POINTS:
* 1. WinHttp.WinHttpRequest.5.1 is the COM ProgID
* 2. Open() initializes the request (method, URL, async flag)
* 3. Send() transmits the request
* 4. ResponseText contains the response body as string
* 5. Status is HTTP status code (200 = OK, 404 = Not Found, etc.)
*/

/**
* Perform HTTP GET request
*
* @param {String} url - URL to request
* @param {Map} headers - Optional request headers
* @returns {Map} - Response object with status, text, headers
* @throws {Error} - Network or HTTP errors
*
* @example
* response := HttpGet("https://api.github.com")
* MsgBox("Status: " response.status "`n" response.text)
*/
HttpGet(url, headers := unset) {
    try {
        ; Create WinHttpRequest COM object
        http := ComObject("WinHttp.WinHttpRequest.5.1")

        ; Open connection (method, URL, async=false)
        http.Open("GET", url, false)

        ; Set custom headers if provided
        if IsSet(headers) {
            for name, value in headers
            http.SetRequestHeader(name, value)
        }

        ; Set default User-Agent if not provided
        if !IsSet(headers) || !headers.Has("User-Agent")
        http.SetRequestHeader("User-Agent", "AutoHotkey-v2-Script")

        ; Send request
        http.Send()

        ; Return response data
        return Map(
        "status", http.Status,
        "statusText", http.StatusText,
        "text", http.ResponseText,
        "headers", http.GetAllResponseHeaders()
        )

    } catch as err {
        throw Error("HTTP GET failed: " err.Message)
    }
}

; ============================================================
; Example 1: Simple GET Request
; ============================================================

try {
    response := HttpGet("https://api.github.com")

    MsgBox("GitHub API Response:`n`n"
    . "Status: " response.status " " response.statusText "`n"
    . "Response Length: " StrLen(response.text) " characters`n`n"
    . "First 200 chars:`n" SubStr(response.text, 1, 200),
    "Simple GET", "Icon!")

} catch as err {
    MsgBox("Error: " err.Message, "Error", "Icon!")
}

; ============================================================
; Example 2: GET with Custom Headers
; ============================================================

try {
    headers := Map(
    "User-Agent", "My-AHK-Script/1.0",
    "Accept", "application/json"
    )

    response := HttpGet("https://api.github.com/users/github", headers)

    MsgBox("GitHub User Info:`n`n"
    . "Status: " response.status "`n`n"
    . "Response:`n" response.text,
    "Custom Headers", "Icon!")

} catch as err {
    MsgBox("Error: " err.Message, "Error", "Icon!")
}

; ============================================================
; Example 3: Check Website Availability
; ============================================================

/**
* Check if website is accessible
*
* @param {String} url - URL to check
* @returns {Boolean} - True if accessible (status 200-299)
*/
CheckWebsite(url) {
    try {
        response := HttpGet(url)
        return response.status >= 200 && response.status < 300
    } catch {
        return false
    }
}

; Test multiple websites
websites := [
"https://www.google.com",
"https://www.github.com",
"https://www.autohotkey.com"
]

output := "Website Status Check:`n`n"
for url in websites {
    status := CheckWebsite(url) ? "✓ Online" : "✗ Offline"
    output .= status " - " url "`n"
}

MsgBox(output, "Website Check", "Icon!")

; ============================================================
; Example 4: Download Text Content
; ============================================================

/**
* Download text content from URL
*
* @param {String} url - URL to download
* @param {String} savePath - File path to save
* @returns {Boolean} - True if successful
*/
DownloadText(url, savePath) {
    try {
        response := HttpGet(url)

        if (response.status = 200) {
            FileDelete(savePath)
            FileAppend(response.text, savePath, "UTF-8")
            return true
        }
        return false
    } catch {
        return false
    }
}

; Example: Download a public text file
; testUrl := "https://raw.githubusercontent.com/AutoHotkey/AutoHotkey/main/README.md"
; savePath := A_ScriptDir "\downloaded_readme.md"

; if (DownloadText(testUrl, savePath))
;     MsgBox("Downloaded successfully to:`n" savePath, "Download Complete", "Icon!")
; else
;     MsgBox("Download failed", "Error", "Icon!")

; ============================================================
; Example 5: Parse Response Headers
; ============================================================

try {
    response := HttpGet("https://www.google.com")

    ; Parse headers
    headers := StrSplit(response.headers, "`n", "`r")

    output := "Response Headers:`n`n"
    count := 0
    for header in headers {
        if (header != "" && count < 10) {
            output .= header "`n"
            count++
        }
    }

    MsgBox(output, "HTTP Headers", "Icon!")

} catch as err {
    MsgBox("Error: " err.Message, "Error", "Icon!")
}

; ============================================================
; Example 6: Error Handling
; ============================================================

/**
* Safe HTTP GET with error handling
*
* @param {String} url - URL to request
* @returns {Map} - Response or error information
*/
SafeHttpGet(url) {
    result := Map(
    "success", false,
    "status", 0,
    "data", "",
    "error", ""
    )

    try {
        response := HttpGet(url)
        result["success"] := true
        result["status"] := response.status
        result["data"] := response.text
    } catch as err {
        result["error"] := err.Message
    }

    return result
}

; Test with valid and invalid URLs
testUrls := [
"https://api.github.com",
"https://invalid-domain-xyz123.com"
]

for url in testUrls {
    result := SafeHttpGet(url)

    if (result["success"])
    MsgBox("✓ Success: " url "`nStatus: " result["status"], "Safe GET", "Icon!")
    else
    MsgBox("✗ Failed: " url "`nError: " result["error"], "Safe GET", "Icon!")
}

; ============================================================
; HTTP Status Code Reference
; ============================================================

statusInfo := "
(
COMMON HTTP STATUS CODES:

2xx - Success
200 OK - Request successful
201 Created - Resource created
204 No Content - Success, no response body

3xx - Redirection
301 Moved Permanently - URL changed permanently
302 Found - Temporary redirect
304 Not Modified - Cached version is current

4xx - Client Error
400 Bad Request - Invalid request
401 Unauthorized - Authentication required
403 Forbidden - Access denied
404 Not Found - Resource doesn't exist
429 Too Many Requests - Rate limited

5xx - Server Error
500 Internal Server Error - Server error
502 Bad Gateway - Invalid upstream response
503 Service Unavailable - Server overloaded
)"

MsgBox(statusInfo, "HTTP Status Codes", "Icon!")
