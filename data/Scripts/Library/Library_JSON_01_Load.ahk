#Requires AutoHotkey v2.0
#Include JSON.ahk

; Library: G33kDude/cJson.ahk
; Function: JSON.Load - Parse JSON string to Map/Array
; Category: Data Serialization
; Use Case: API responses, config files, data interchange

; Example: Parse JSON and access data
; Note: Requires cJSON.ahk library from G33kDude/cJson.ahk

; Built-in JSON example (v2.1-alpha.14+ has native JSON support)
; For cJson library (10x faster for large datasets):
; #Include <cJSON>

DemoJSONParse() {
    ; Sample JSON data
    jsonString := '
    (
    {
        "name": "AutoHotkey",
        "version": 2.0,
        "features": ["OOP", "Async", "Unicode"],
        "metadata": {
            "author": "Lexikos",
            "license": "GPL"
        }
    }
    )'

    ; Using cJson library (commented out, requires library):
    ; data := JSON.Load(jsonString)

    ; Using native v2.1+ JSON (built-in):
    try {
        data := Jxon_Load(&jsonString)  ; If Jxon is available
    } catch {
        ; Fallback: Manual parsing demo
        MsgBox("JSON Parse Demonstration`n`n"
        "With cJson library:`n"
        "data := JSON.Load(jsonString)`n"
        "name := data['name']  ; 'AutoHotkey'`n"
        "version := data['version']  ; 2.0`n"
        "features := data['features']  ; Array`n`n"
        "10x faster than pure AHK parsers!`n`n"
        "Install: Download cJSON.ahk from G33kDude/cJson.ahk",
        "cJson Demo")
        return
    }

    ; Display parsed data
    result := "Parsed Data:`n"
    result .= "Name: " data.name "`n"
    result .= "Version: " data.version "`n"
    result .= "Features: " data.features.Join(", ") "`n"
    result .= "Author: " data.metadata.author

    MsgBox(result, "JSON Parse Result")
}

; Helper function for native JSON (simplified)
Jxon_Load(&src) {
    ; This is a placeholder - real implementation would use native JSON.parse in v2.1+
    ; or require the cJson/JXON library
    throw Error("Requires cJson or JXON library")
}

; Run demonstration
DemoJSONParse()
