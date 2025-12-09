#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* CLR - HTTP Web Requests
*
* Demonstrates making HTTP requests using .NET WebClient and HttpClient
* for downloading data, calling APIs, and handling responses.
*
* Library: https://github.com/Lexikos/CLR.ahk
*/

MsgBox("CLR - HTTP Requests Example`n`n"
. "Demonstrates web requests with .NET`n"
. "Requires: CLR.ahk and .NET Framework 4.0+", , "T3")

/*
; Uncomment to run (requires CLR.ahk):

#Include <CLR>

; Initialize CLR
CLR_Start("v4.0.30319")

; Compile HTTP Helper Class
httpCode := "
(
using System;
using System.Net;
using System.Text;
using System.Collections.Specialized;

public class HttpHelper {
    public static string Get(string url) {
        using (WebClient client = new WebClient()) {
            client.Headers[HttpRequestHeader.UserAgent] = ""AutoHotkey/2.0"";
            return client.DownloadString(url);
        }
    }

    public static string Post(string url, string data) {
        using (WebClient client = new WebClient()) {
            client.Headers[HttpRequestHeader.UserAgent] = ""AutoHotkey/2.0"";
            client.Headers[HttpRequestHeader.ContentType] = ""application/json"";
            return client.UploadString(url, ""POST"", data);
        }
    }

    public static byte[] DownloadData(string url) {
        using (WebClient client = new WebClient()) {
            return client.DownloadData(url);
        }
    }

    public static void DownloadFile(string url, string filename) {
        using (WebClient client = new WebClient()) {
            client.DownloadFile(url, filename);
        }
    }

    public static string GetWithHeaders(string url, string headerName, string headerValue) {
        using (WebClient client = new WebClient()) {
            client.Headers.Add(headerName, headerValue);
            return client.DownloadString(url);
        }
    }
}
)"

refs := "System.dll"
asm := CLR_CompileCS(httpCode, refs)
Http := asm.GetType("HttpHelper")

; Example 1: Simple GET request
MsgBox("Example 1: Making GET request...", , "T2")

try {
    ; Use a reliable test API
    response := Http.Get("https://api.github.com/zen")
    MsgBox("GitHub Zen Quote:`n`n" response, , "T5")
} catch as e {
    MsgBox("Request failed (check internet connection)", , "T3")
}

; Example 2: GET JSON API
MsgBox("Example 2: Fetching JSON from API...", , "T2")

try {
    jsonResponse := Http.Get("https://api.github.com/users/github")

    ; Parse with JScript
    #Include <ActiveScript>

    js := ActiveScript("JScript")
    js.Exec("var data = JSON.parse('" StrReplace(jsonResponse, "'", "\'") "')")

    login := js.Eval("data.login")
    name := js.Eval("data.name")
    repos := js.Eval("data.public_repos")

    MsgBox("GitHub User Info:`n`n"
    . "Login: " login "`n"
    . "Name: " name "`n"
    . "Public Repos: " repos, , "T5")
} catch {
    MsgBox("API request example (requires internet)", , "T3")
}

; Example 3: POST request
MsgBox("Example 3: POST Request Example", , "T2")

postData := '{"title":"Test","body":"Testing POST","userId":1}'
MsgBox("Would POST to API:`n`n" postData "`n`n(Skipped to avoid side effects)", , "T3")

; Example 4: Download file
MsgBox("Example 4: File Download Example", , "T2")

try {
    ; Download small text file
    outputFile := A_ScriptDir "\downloaded.txt"
    Http.DownloadFile("https://raw.githubusercontent.com/github/gitignore/main/Global/VisualStudioCode.gitignore", outputFile)

    if FileExist(outputFile) {
        content := FileRead(outputFile)
        lines := StrSplit(content, "`n").Length
        MsgBox("Downloaded file:`n`n"
        . "Path: " outputFile "`n"
        . "Lines: " lines, , "T3")
        FileDelete(outputFile)
    }
} catch {
    MsgBox("Download example (requires internet)", , "T3")
}

; Example 5: Custom headers
MsgBox("Example 5: Request with Custom Headers", , "T2")

try {
    response := Http.GetWithHeaders("https://api.github.com/zen", "Accept", "application/json")
    MsgBox("Request with custom headers:`n`n" response, , "T3")
} catch {
    MsgBox("Custom headers example", , "T3")
}
*/

/*
* Key Concepts:
*
* 1. WebClient Class:
*    Simple, high-level HTTP client
*    DownloadString(url) - GET text
*    UploadString(url, method, data) - POST
*    DownloadFile(url, path) - Save file
*
* 2. Headers:
*    client.Headers.Add(name, value)
*    Common: UserAgent, ContentType, Authorization
*
* 3. HTTP Methods:
*    GET - Retrieve data
*    POST - Submit data
*    PUT - Update resource
*    DELETE - Remove resource
*
* 4. Content Types:
*    application/json - JSON data
*    application/x-www-form-urlencoded - Form
*    text/plain - Plain text
*    multipart/form-data - File uploads
*
* 5. Using Statement:
*    using (WebClient client = new WebClient()) { }
*    Automatically disposes
*    Releases connections
*
* 6. Error Handling:
*    WebException for network errors
*    HttpWebResponse.StatusCode for HTTP errors
*    Timeout exceptions
*
* 7. Common Use Cases:
*    ✅ REST API calls
*    ✅ File downloads
*    ✅ Web scraping
*    ✅ Form submissions
*    ✅ OAuth authentication
*
* 8. HttpClient Alternative:
*    More features than WebClient
*    Async operations
*    Better for modern APIs
*    Requires .NET 4.5+
*
* 9. Best Practices:
*    ✅ Set User-Agent header
*    ✅ Use using statements
*    ✅ Handle exceptions
*    ✅ Check status codes
*    ✅ Respect rate limits
*
* 10. Authentication:
*     Basic: "Basic " Base64(user:pass)
*     Bearer: "Bearer " token
*     API Key: Custom header
*
* 11. Response Handling:
*     Text: DownloadString()
*     Binary: DownloadData()
*     File: DownloadFile()
*     Stream: OpenRead()
*
* 12. Advanced Features:
*     Proxy support
*     Cookie handling
*     Custom certificates
*     Compression (gzip)
*/
