#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* GetObjectFromString - Dynamic Object Resolution
*
* Demonstrates resolving object references from dot-notation string paths,
* enabling dynamic property access and navigation.
*
* Source: AHK_Notes/Methods/get-object-from-string.md
*/

; Create test objects
global Config := {
    App: {
        Name: "MyApp",
        Version: "1.0",
        Settings: {
            Theme: "dark",
            Language: "en"
        }
    },
    Server: {
        Host: "localhost",
        Port: 8080
    }
}

; Test basic path resolution
appName := GetObjectFromString("Config.App.Name")
theme := GetObjectFromString("Config.App.Settings.Theme")
port := GetObjectFromString("Config.Server.Port")

MsgBox("Object Path Resolution:`n`n"
. "Config.App.Name: " appName "`n"
. "Config.App.Settings.Theme: " theme "`n"
. "Config.Server.Port: " port, , "T5")

; Test invalid paths
invalid := GetObjectFromString("Config.NonExistent.Path")
MsgBox("Invalid path test:`n"
. "Config.NonExistent.Path: " (invalid == "" ? "(empty - not found)" : invalid), , "T3")

; Test dynamic config getter
value := GetConfig("App.Settings.Language")
MsgBox("Dynamic Config Getter:`n"
. "App.Settings.Language: " value, , "T3")

; Test path builder pattern
paths := [
"Config.App.Name",
"Config.App.Version",
"Config.Server.Host"
]

result := "Batch Resolution:`n`n"
for path in paths {
    value := GetObjectFromString(path)
    result .= path ": " value "`n"
}
MsgBox(result, , "T5")

/**
* GetObjectFromString - Resolve object from dot-notation path
* @param {string} path - Dot-separated path (e.g. "Object.Property.SubProperty")
* @return {any} Resolved value or empty string if not found
*/
GetObjectFromString(path) {
    parts := StrSplit(path, ".")

    ; Start with global object
    try {
        obj := %parts[1]%  ; Get root object
    } catch {
        return ""
    }

    ; Navigate through remaining path segments
    for index, part in parts {
        if (index == 1)
        continue

        ; Check if property exists
        if (!obj.HasOwnProp(part))
        return ""

        obj := obj.%part%
    }

    return obj
}

/**
* GetConfig - Helper for getting config values
* @param {string} path - Path relative to Config object
* @return {any} Config value or empty string
*/
GetConfig(path) {
    return GetObjectFromString("Config." path)
}

/**
* SetByPath - Set value using dot-notation path
* @param {string} path - Dot-separated path
* @param {any} value - Value to set
*/
SetByPath(path, value) {
    parts := StrSplit(path, ".")

    ; Navigate to parent object
    try {
        obj := %parts[1]%
    } catch {
        return
    }

    ; Navigate to parent of target property
    for index, part in parts {
        if (index == 1 || index == parts.Length)
        continue

        if (!obj.HasOwnProp(part))
        return

        obj := obj.%part%
    }

    ; Set the final property
    lastProp := parts[parts.Length]
    obj.%lastProp% := value
}

/*
* Key Concepts:
*
* 1. Dot Notation:
*    "Config.App.Settings.Theme"
*    Navigate nested objects dynamically
*    String-based property access
*
* 2. Implementation:
*    parts := StrSplit(path, ".")
*    Start with root: obj := %parts[1]%
*    Navigate: obj := obj.%part%
*
* 3. Dynamic Access:
*    obj.%varName%  ; Access property by variable
*    %varName%      ; Get global object by name
*
* 4. Error Handling:
*    try/catch for non-existent objects
*    HasOwnProp() for property checking
*    Return "" for invalid paths
*
* 5. Use Cases:
*    ✅ Configuration systems
*    ✅ Dynamic property access
*    ✅ Generic getters/setters
*    ✅ Path-based data binding
*    ✅ API responses navigation
*
* 6. Limitations:
*    ⚠ Only works with global objects
*    ⚠ Can't access instance properties directly
*    ⚠ Doesn't create missing objects
*    ⚠ String parsing overhead
*
* 7. Helper Patterns:
*    GetConfig("App.Name")  ; Shorthand
*    SetByPath("Config.App.Name", "NewName")
*    Batch resolution with array of paths
*
* 8. Performance:
*    ⚠ Not suitable for tight loops
*    ✅ Cache results when possible
*    ✅ Use direct access if path is known
*/
