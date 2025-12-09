#Requires AutoHotkey v2.0
#Include JSON.ahk

; Library: G33kDude/cJson.ahk
; Function: JSON.Dump - Convert Map/Array to JSON string
; Category: Data Serialization
; Use Case: API requests, config saving, data export

; Example: Create object and serialize to JSON
; Note: Requires cJSON.ahk library from G33kDude/cJson.ahk

; #Include <cJSON>

DemoJSONDump() {
    ; Create data structure using Map and Array
    data := Map(
    "name", "My Script",
    "version", "1.0.0",
    "settings", Map(
    "theme", "dark",
    "autoSave", true,
    "maxItems", 100
    ),
    "tags", ["automation", "productivity", "v2"]
    )

    ; Using cJson library (commented out):
    ; jsonString := JSON.Dump(data, 2)  ; 2 = indent spaces

    ; Demonstrate the concept
    conceptJSON := '
    (
    {
        "name": "My Script",
        "version": "1.0.0",
        "settings": {
            "theme": "dark",
            "autoSave": true,
            "maxItems": 100
        },
        "tags": ["automation", "productivity", "v2"]
    }
    )'

    MsgBox("JSON Dump Demonstration`n`n"
    "With cJson library:`n"
    "data := Map('key', 'value')`n"
    "jsonString := JSON.Dump(data, 2)  ; Indent=2`n`n"
    "Example Output:`n" conceptJSON "`n`n"
    "Perfect for:`n"
    "- Saving config files`n"
    "- API POST requests`n"
    "- Data export",
    "cJson Dump Demo")
}

; Real implementation example (commented out, requires library):
/*
SaveConfig(filename, configData) {
    ; Convert Map to JSON with indentation
    jsonString := JSON.Dump(configData, 2)

    ; Save to file
    try {
        FileObj := FileOpen(filename, "w")
        FileObj.Write(jsonString)
        FileObj.Close()
        MsgBox("Config saved: " filename)
    } catch as err {
        MsgBox("Error saving config: " err.Message)
    }
}

; Usage:
; config := Map("theme", "dark", "fontSize", 14)
; SaveConfig("settings.json", config)
*/

; Run demonstration
DemoJSONDump()
