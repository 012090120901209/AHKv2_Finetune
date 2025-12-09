#Requires AutoHotkey v2.0
#Include JSON.ahk

; Library: thqby/ahk2_lib/WinHttpRequest
; Function: HTTP requests using WinHTTP
; Category: Networking
; Use Case: API calls, web scraping, data fetching

; Example: Make HTTP GET request
; Note: Uses built-in ComObject, no external library required

DemoHTTPRequest() {
    ; Example API URL (free, no auth required)
    url := "https://api.github.com/zen"

    try {
        ; Create WinHttpRequest object
        whr := ComObject("WinHttp.WinHttpRequest.5.1")

        ; Open GET request
        whr.Open("GET", url, true)

        ; Set headers
        whr.SetRequestHeader("User-Agent", "AutoHotkey/2.0")

        ; Send request
        whr.Send()

        ; Wait for response
        whr.WaitForResponse()

        ; Get response text
        response := whr.ResponseText

        ; Display result
        result := "HTTP GET Request Demo`n`n"
        result .= "URL: " url "`n"
        result .= "Status: " whr.Status " " whr.StatusText "`n`n"
        result .= "Response:`n" response "`n`n"

        result .= "For advanced features, see thqby/ahk2_lib:`n"
        result .= "- JSON response parsing`n"
        result .= "- POST/PUT/DELETE methods`n"
        result .= "- Headers management`n"
        result .= "- Async requests`n"
        result .= "- Upload/download progress"

        MsgBox(result, "HTTP Request Demo")

    } catch as err {
        MsgBox("Error: " err.Message, "HTTP Request Error")
    }
}

; More advanced example (commented out):
/*
PostJSONData(url, data) {
    ; Convert Map to JSON
    ; jsonData := JSON.Dump(data)

    ; Create request
    whr := ComObject("WinHttp.WinHttpRequest.5.1")
    whr.Open("POST", url, true)

    ; Set headers for JSON
    whr.SetRequestHeader("Content-Type", "application/json")
    whr.SetRequestHeader("User-Agent", "AutoHotkey/2.0")

    ; Send JSON data
    whr.Send(jsonData)
    whr.WaitForResponse()

    ; Parse JSON response
    ; response := JSON.Load(whr.ResponseText)

    return whr.ResponseText
}
*/

; Run demonstration
DemoHTTPRequest()
