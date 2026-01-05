#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * GitHub_HTTP_02_WinHttpRequest_POST.ahk
 * 
 * DESCRIPTION:
 * Demonstrates HTTP POST requests with JSON data using WinHttpRequest
 * 
 * FEATURES:
 * - HTTP POST with JSON payload
 * - Content-Type headers
 * - Request/Response handling
 * - API interaction patterns
 * 
 * SOURCE:
 * Based on: thqby/ahk2_lib - WinHttpRequest.ahk
 * URL: https://github.com/thqby/ahk2_lib
 * Author: thqby
 * License: MIT
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - ComObject for HTTP requests
 * - Map() for headers and data
 * - JSON string construction
 * - POST body transmission
 * - Response parsing
 * 
 * USAGE:
 * data := Map("title", "Test", "body", "Content")
 * response := HttpPost("https://api.example.com/posts", data)
 * 
 * LEARNING POINTS:
 * 1. POST requires Content-Type header (usually application/json)
 * 2. Send() method accepts body parameter for POST data
 * 3. JSON data must be properly formatted string
 * 4. Response handling is same as GET
 */

/**
 * Perform HTTP POST request with JSON data
 * 
 * @param {String} url - URL to post to
 * @param {String|Map} data - Data to send (JSON string or Map)
 * @param {Map} headers - Optional additional headers
 * @returns {Map} - Response object
 * @throws {Error} - Network or HTTP errors
 * 
 * @example
 * data := Map("name", "John", "email", "john@example.com")
 * response := HttpPost("https://api.example.com/users", data)
 */
HttpPost(url, data, headers := unset) {
    try {
        http := ComObject("WinHttp.WinHttpRequest.5.1")
        http.Open("POST", url, false)

        ; Set default headers for JSON
        http.SetRequestHeader("Content-Type", "application/json")
        http.SetRequestHeader("User-Agent", "AutoHotkey-v2-Script")

        ; Add custom headers
        if IsSet(headers) {
            for name, value in headers
                http.SetRequestHeader(name, value)
        }

        ; Convert Map to JSON string if needed
        if (Type(data) = "Map")
            data := MapToJson(data)

        ; Send request with body
        http.Send(data)

        return Map(
            "status", http.Status,
            "statusText", http.StatusText,
            "text", http.ResponseText
        )

    } catch as err {
        throw Error("HTTP POST failed: " err.Message)
    }
}

/**
 * Simple Map to JSON converter
 * Note: For production use, consider thqby's JSON library
 * 
 * @param {Map} map - Map to convert
 * @returns {String} - JSON string
 */
MapToJson(map) {
    json := "{"
    first := true

    for key, value in map {
        if !first
            json .= ","
        first := false

        json .= '"' key '":"' EscapeJson(value) '"'
    }

    json .= "}"
    return json
}

/**
 * Escape special characters for JSON
 * 
 * @param {String} text - Text to escape
 * @returns {String} - Escaped text
 */
EscapeJson(text) {
    text := StrReplace(text, "\", "\\")
    text := StrReplace(text, '"', '\"')
    text := StrReplace(text, "`n", "\n")
    text := StrReplace(text, "`r", "\r")
    text := StrReplace(text, "`t", "\t")
    return text
}

; ============================================================
; Example 1: Simple POST Request
; ============================================================

try {
    ; Create test data
    postData := Map(
        "title", "Test Post",
        "body", "This is a test post from AutoHotkey v2",
        "userId", "1"
    )

    ; Send POST request to JSONPlaceholder (test API)
    response := HttpPost("https://jsonplaceholder.typicode.com/posts", postData)

    MsgBox("POST Response:`n`n"
        . "Status: " response.status " " response.statusText "`n`n"
        . "Response:`n" response.text,
        "Simple POST", "Icon!")

} catch as err {
    MsgBox("Error: " err.Message, "Error", "Icon!")
}

; ============================================================
; Example 2: POST with Custom Headers
; ============================================================

try {
    data := Map(
        "name", "John Doe",
        "email", "john@example.com"
    )

    headers := Map(
        "Authorization", "Bearer YOUR_TOKEN_HERE",
        "X-Custom-Header", "CustomValue"
    )

    ; Note: This will fail without valid token, just demonstrating syntax
    ; response := HttpPost("https://api.example.com/users", data, headers)

    MsgBox("POST with custom headers demonstrated`n`n"
        . "Headers added:`n"
        . "- Authorization`n"
        . "- X-Custom-Header",
        "Custom Headers", "Icon!")

} catch as err {
    MsgBox("Expected error (demo only): " err.Message, "Demo", "Icon!")
}

; ============================================================
; Example 3: Form Submission Simulation
; ============================================================

/**
 * Submit form data via POST
 * 
 * @param {String} url - Form submission URL
 * @param {Map} formData - Form fields
 * @returns {Map} - Response
 */
SubmitForm(url, formData) {
    return HttpPost(url, formData)
}

; Simulate contact form submission
contactData := Map(
    "name", "Jane Smith",
    "email", "jane@example.com",
    "message", "Hello from AutoHotkey!"
)

try {
    response := SubmitForm("https://jsonplaceholder.typicode.com/posts", contactData)

    MsgBox("Form Submitted Successfully!`n`n"
        . "Status: " response.status "`n"
        . "Response ID: " SubStr(response.text, 1, 100),
        "Form Submission", "Icon!")

} catch as err {
    MsgBox("Submission failed: " err.Message, "Error", "Icon!")
}

; ============================================================
; Example 4: API Client Class
; ============================================================

/**
 * Simple API client class
 */
class ApiClient {
    baseUrl := ""
    defaultHeaders := Map()

    __New(baseUrl) {
        this.baseUrl := baseUrl
        this.defaultHeaders["User-Agent"] := "AHK-ApiClient/1.0"
    }

    Post(endpoint, data) {
        url := this.baseUrl "/" endpoint
        return HttpPost(url, data, this.defaultHeaders)
    }

    SetHeader(name, value) {
        this.defaultHeaders[name] := value
    }
}

; Use the API client
api := ApiClient("https://jsonplaceholder.typicode.com")
api.SetHeader("X-App-Version", "1.0")

try {
    response := api.Post("posts", Map(
        "title", "API Client Test",
        "body", "Testing the API client class"
    ))

    MsgBox("API Client Response:`n`n"
        . "Status: " response.status,
        "API Client", "Icon!")

} catch as err {
    MsgBox("Error: " err.Message, "Error", "Icon!")
}

; ============================================================
; Example 5: Webhook Notification
; ============================================================

/**
 * Send webhook notification
 * 
 * @param {String} webhookUrl - Webhook URL
 * @param {String} message - Message to send
 * @returns {Boolean} - Success status
 */
SendWebhook(webhookUrl, message) {
    try {
        data := Map("text", message)
        response := HttpPost(webhookUrl, data)
        return response.status >= 200 && response.status < 300
    } catch {
        return false
    }
}

; Example webhook call (replace with real webhook URL)
; webhookUrl := "https://hooks.example.com/your-webhook"
; if (SendWebhook(webhookUrl, "Script executed successfully!"))
;     MsgBox("Webhook sent!", "Success", "Icon!")

; ============================================================
; Example 6: Multiple POST Requests
; ============================================================

/**
 * Batch create items via POST
 * 
 * @param {String} url - API endpoint
 * @param {Array} items - Array of items to create
 * @returns {Array} - Array of responses
 */
BatchPost(url, items) {
    results := []

    for item in items {
        try {
            response := HttpPost(url, item)
            results.Push(Map(
                "success", true,
                "status", response.status,
                "data", response.text
            ))
        } catch as err {
            results.Push(Map(
                "success", false,
                "error", err.Message
            ))
        }
    }

    return results
}

; Create multiple posts
posts := [
    Map("title", "Post 1", "body", "Content 1"),
    Map("title", "Post 2", "body", "Content 2"),
    Map("title", "Post 3", "body", "Content 3")
]

results := BatchPost("https://jsonplaceholder.typicode.com/posts", posts)

output := "Batch POST Results:`n`n"
for index, result in results {
    if (result["success"])
        output .= index ". ✓ Success (Status: " result["status"] ")`n"
    else
        output .= index ". ✗ Failed: " result["error"] "`n"
}

MsgBox(output, "Batch POST", "Icon!")

; ============================================================
; POST vs GET Reference
; ============================================================

info := "
(
HTTP POST vs GET:

POST:
✓ Sends data in request body
✓ Not cached by browsers
✓ No size limits (practical limit ~2GB)
✓ Used for creating/updating data
✓ Requires Content-Type header

GET:
✓ Sends data in URL parameters
✓ Can be cached
✓ URL length limited (~2000 chars)
✓ Used for retrieving data
✓ Idempotent (safe to retry)

When to use POST:
- Creating new resources
- Submitting forms
- Uploading files
- Sending sensitive data
- Large data payloads

Common Content-Types:
- application/json (JSON data)
- application/x-www-form-urlencoded (forms)
- multipart/form-data (file uploads)
- text/plain (plain text)
)"

MsgBox(info, "POST vs GET", "Icon!")
