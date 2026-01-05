#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Practical JSON Library Examples - Using thqby/ahk2_lib JSON.ahk
 * 
 * Real-world examples demonstrating JSON parsing and serialization
 * Library: https://github.com/thqby/ahk2_lib/blob/master/JSON.ahk
 * 
 * To use these examples, you need to include the JSON library:
 * #Include <JSON>
 */

/**
 * Example 1: Parse API Response
 * Common use case: Parsing JSON response from web APIs
 */
ParseAPIResponseExample() {
    apiResponse := '
    (
    {
        "status": "success",
        "data": {
            "user": {
                "id": 12345,
                "username": "johndoe",
                "email": "john@example.com",
                "verified": true
            },
            "permissions": ["read", "write", "delete"]
        }
    }
    )'

    ; Parse JSON to Map object
    response := JSON.parse(apiResponse)

    ; Access nested data
    user := response["data"]["user"]
    username := user["username"]
    email := user["email"]
    verified := user["verified"]
    permissions := response["data"]["permissions"]

    output := "API Response Data:`n`n"
    output .= "Username: " username "`n"
    output .= "Email: " email "`n"
    output .= "Verified: " (verified ? "Yes" : "No") "`n"
    output .= "Permissions: " permissions[1] ", " permissions[2] ", " permissions[3]

    MsgBox(output)
}

/**
 * Example 2: Create and Save Configuration File
 * Practical use: Application settings storage
 */
SaveConfigExample() {
    ; Create configuration object
    config := Map()
    config["app"] := Map()
    config["app"]["name"] := "My Application"
    config["app"]["version"] := "2.5.1"
    config["app"]["debug"] := false

    config["window"] := Map()
    config["window"]["width"] := 1280
    config["window"]["height"] := 720
    config["window"]["maximized"] := false

    config["paths"] := Map()
    config["paths"]["data"] := A_AppData "\MyApp\data"
    config["paths"]["logs"] := A_AppData "\MyApp\logs"

    config["features"] := ["auto-save", "spell-check", "dark-mode"]

    ; Convert to formatted JSON
    jsonString := JSON.stringify(config, 10, "  ")

    ; Save to file
    configPath := A_ScriptDir "\app_config.json"
    try {
        FileDelete(configPath)
    }
    FileAppend(jsonString, configPath, "UTF-8")

    MsgBox("Configuration saved to:`n" configPath "`n`nContent:`n" jsonString)
}

/**
 * Example 3: Load and Validate User Data
 * Practical use: Loading user profiles with validation
 */
LoadUserDataExample() {
    userJson := '
    (
    {
        "profile": {
            "name": "Alice Smith",
            "age": 28,
            "email": "alice@example.com"
        },
        "preferences": {
            "theme": "dark",
            "notifications": true,
            "language": "en"
        },
        "stats": {
            "loginCount": 342,
            "lastLogin": "2024-11-05T15:30:00Z"
        }
    }
    )'

    ; Parse user data
    userData := JSON.parse(userJson)

    ; Validate required fields
    if (!userData.Has("profile") || !userData["profile"].Has("email")) {
        MsgBox("Error: Invalid user data - missing email")
        return
    }

    ; Extract profile info
    profile := userData["profile"]
    prefs := userData["preferences"]
    stats := userData["stats"]

    output := "User Profile:`n`n"
    output .= "Name: " profile["name"] "`n"
    output .= "Age: " profile["age"] "`n"
    output .= "Email: " profile["email"] "`n`n"
    output .= "Preferences:`n"
    output .= "Theme: " prefs["theme"] "`n"
    output .= "Notifications: " (prefs["notifications"] ? "Enabled" : "Disabled") "`n`n"
    output .= "Statistics:`n"
    output .= "Total Logins: " stats["loginCount"] "`n"
    output .= "Last Login: " stats["lastLogin"]

    MsgBox(output)
}

/**
 * Example 4: Work with Arrays and Nested Objects
 * Practical use: Managing product catalog
 */
ProductCatalogExample() {
    ; Create product catalog
    catalog := Map()
    catalog["categories"] := []

    ; Electronics category
    electronics := Map()
    electronics["name"] := "Electronics"
    electronics["products"] := []

    laptop := Map()
    laptop["id"] := "PROD001"
    laptop["name"] := "Gaming Laptop"
    laptop["price"] := 1299.99
    laptop["inStock"] := true
    laptop["tags"] := ["gaming", "high-performance", "portable"]

    phone := Map()
    phone["id"] := "PROD002"
    phone["name"] := "Smartphone X"
    phone["price"] := 899.50
    phone["inStock"] := false
    phone["tags"] := ["mobile", "5G", "flagship"]

    electronics["products"].Push(laptop)
    electronics["products"].Push(phone)
    catalog["categories"].Push(electronics)

    ; Convert to JSON
    jsonOutput := JSON.stringify(catalog, 10, "  ")

    ; Parse back to verify
    parsed := JSON.parse(jsonOutput)
    firstProduct := parsed["categories"][1]["products"][1]

    output := "Product Catalog JSON:`n`n" jsonOutput "`n`n"
    output .= "First Product: " firstProduct["name"] "`n"
    output .= "Price: $" firstProduct["price"] "`n"
    output .= "Stock: " (firstProduct["inStock"] ? "Available" : "Out of Stock")

    MsgBox(output)
}

/**
 * Example 5: Handle Null and Boolean Values
 * Practical use: Working with optional fields
 */
HandleSpecialValuesExample() {
    ; Create data with special values
    data := Map()
    data["name"] := "Test User"
    data["middleName"] := JSON.null  ; Optional field
    data["active"] := JSON.true
    data["suspended"] := JSON.false
    data["loginDate"] := "2024-11-05"
    data["logoutDate"] := JSON.null  ; User still logged in

    ; Convert to JSON
    jsonString := JSON.stringify(data)
    MsgBox("JSON with special values:`n`n" jsonString)

    ; Parse with keepbooltype option
    parsed := JSON.parse(jsonString, true)  ; Keep boolean types

    ; Check values
    output := "Parsed Values:`n`n"
    output .= "Name: " parsed["name"] "`n"
    output .= "Middle Name: " (parsed["middleName"] == JSON.null ? "Not provided" : parsed["middleName"]) "`n"
    output .= "Active: " (parsed["active"] == JSON.true ? "Yes" : "No") "`n"
    output .= "Suspended: " (parsed["suspended"] == JSON.true ? "Yes" : "No") "`n"
    output .= "Logout Date: " (parsed["logoutDate"] == JSON.null ? "Still logged in" : parsed["logoutDate"])

    MsgBox(output)
}

/**
 * Example 6: Convert CSV to JSON
 * Practical use: Data transformation and export
 */
CSVtoJSONExample() {
    ; Sample CSV data
    csvData := "
    (
    Name,Age,Department,Salary
    John Doe,35,Engineering,95000
    Jane Smith,28,Marketing,72000
    Bob Johnson,42,Sales,85000
    )"

    ; Parse CSV and convert to JSON
    lines := StrSplit(Trim(csvData), "`n")
    headers := StrSplit(Trim(lines[1]), ",")

    employees := []

    ; Process each data row
    Loop lines.Length - 1 {
        if (A_Index = 1)
            continue

        values := StrSplit(Trim(lines[A_Index + 1]), ",")
        employee := Map()

        Loop headers.Length {
            header := Trim(headers[A_Index])
            value := Trim(values[A_Index])

            ; Convert numeric values
            if (header = "Age" || header = "Salary")
                employee[header] := Integer(value)
            else
                employee[header] := value
        }

        employees.Push(employee)
    }

    ; Create final structure
    result := Map()
    result["employees"] := employees
    result["count"] := employees.Length

    ; Convert to formatted JSON
    jsonOutput := JSON.stringify(result, 10, "  ")

    MsgBox("CSV to JSON Conversion:`n`n" jsonOutput)
}

/**
 * Example 7: Merge Multiple JSON Files
 * Practical use: Combining configuration from multiple sources
 */
MergeJSONExample() {
    ; Base configuration
    baseConfig := '
    (
    {
        "app": {
            "name": "MyApp",
            "version": "1.0.0"
        },
        "server": {
            "host": "localhost",
            "port": 8080
        }
    }
    )'

    ; User overrides
    userConfig := '
    (
    {
        "server": {
            "port": 9000,
            "ssl": true
        },
        "logging": {
            "level": "debug",
            "file": "app.log"
        }
    }
    )'

    ; Parse both configs
    base := JSON.parse(baseConfig)
    user := JSON.parse(userConfig)

    ; Deep merge function
    DeepMerge(target, source) {
        for key, value in source {
            if (target.Has(key) && Type(target[key]) = "Map" && Type(value) = "Map")
                DeepMerge(target[key], value)
            else
                target[key] := value
        }
        return target
    }

    ; Merge configurations
    merged := DeepMerge(base, user)

    ; Output result
    mergedJson := JSON.stringify(merged, 10, "  ")

    output := "Merged Configuration:`n`n" mergedJson "`n`n"
    output .= "Final server port: " merged["server"]["port"] "`n"
    output .= "SSL enabled: " (merged["server"]["ssl"] ? "Yes" : "No")

    MsgBox(output)
}

/**
 * Example 8: Create REST API Request Body
 * Practical use: Preparing data for HTTP requests
 */
CreateAPIRequestExample() {
    ; Create new user request body
    requestBody := Map()
    requestBody["user"] := Map()
    requestBody["user"]["username"] := "newuser123"
    requestBody["user"]["email"] := "newuser@example.com"
    requestBody["user"]["password"] := "hashed_password_here"
    requestBody["user"]["profile"] := Map()
    requestBody["user"]["profile"]["firstName"] := "John"
    requestBody["user"]["profile"]["lastName"] := "Doe"
    requestBody["user"]["profile"]["age"] := 25
    requestBody["user"]["preferences"] := Map()
    requestBody["user"]["preferences"]["newsletter"] := true
    requestBody["user"]["preferences"]["notifications"] := Map()
    requestBody["user"]["preferences"]["notifications"]["email"] := true
    requestBody["user"]["preferences"]["notifications"]["sms"] := false

    ; Convert to compact JSON (no formatting)
    compactJson := JSON.stringify(requestBody, 0)

    ; Convert to formatted JSON (for display)
    formattedJson := JSON.stringify(requestBody, 10, "  ")

    output := "API Request Body (Compact):`n" compactJson "`n`n"
    output .= "API Request Body (Formatted):`n" formattedJson "`n`n"
    output .= "Ready to send via HTTP POST request"

    MsgBox(output)
}

/**
 * Example 9: Log Structured Data
 * Practical use: Application logging with JSON format
 */
JSONLoggingExample() {
    ; Create log entry
    CreateLogEntry(level, message, data := "") {
        logEntry := Map()
        logEntry["timestamp"] := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")
        logEntry["level"] := level
        logEntry["message"] := message
        logEntry["thread"] := A_ScriptName

        if (data != "")
            logEntry["data"] := data

        return logEntry
    }

    ; Create different log entries
    logs := []

    ; Info log
    logs.Push(CreateLogEntry("INFO", "Application started"))

    ; Warning log with data
    warningData := Map()
    warningData["memoryUsage"] := "85%"
    warningData["threshold"] := "80%"
    logs.Push(CreateLogEntry("WARNING", "High memory usage detected", warningData))

    ; Error log with data
    errorData := Map()
    errorData["errorCode"] := "DB_001"
    errorData["query"] := "SELECT * FROM users"
    errorData["details"] := "Connection timeout after 30s"
    logs.Push(CreateLogEntry("ERROR", "Database query failed", errorData))

    ; Convert logs to JSON
    logOutput := ""
    for entry in logs {
        logOutput .= JSON.stringify(entry) "`n"
    }

    MsgBox("JSON Log Entries:`n`n" logOutput)

    ; Write to file
    logFile := A_ScriptDir "\application.log"
    FileAppend(logOutput, logFile, "UTF-8")
    MsgBox("Logs written to: " logFile)
}

/**
 * Example 10: Complex Data Structure - Game Save File
 * Practical use: Saving game state or complex application state
 */
GameSaveExample() {
    ; Create complex game save structure
    saveData := Map()
    saveData["version"] := "1.0.0"
    saveData["saveDate"] := FormatTime(A_Now, "yyyy-MM-dd HH:mm:ss")

    ; Player data
    saveData["player"] := Map()
    saveData["player"]["name"] := "HeroPlayer"
    saveData["player"]["level"] := 42
    saveData["player"]["experience"] := 125750
    saveData["player"]["health"] := 450
    saveData["player"]["maxHealth"] := 500
    saveData["player"]["mana"] := 280
    saveData["player"]["maxMana"] := 300

    ; Position
    saveData["player"]["position"] := Map()
    saveData["player"]["position"]["x"] := 1523.5
    saveData["player"]["position"]["y"] := -423.8
    saveData["player"]["position"]["z"] := 67.2
    saveData["player"]["position"]["map"] := "dungeon_level_5"

    ; Inventory
    saveData["inventory"] := []

    item1 := Map()
    item1["id"] := "SWORD_001"
    item1["name"] := "Legendary Sword"
    item1["quantity"] := 1
    item1["equipped"] := true
    item1["stats"] := Map("damage", 125, "durability", 98)

    item2 := Map()
    item2["id"] := "POTION_HP"
    item2["name"] := "Health Potion"
    item2["quantity"] := 15
    item2["equipped"] := false

    saveData["inventory"].Push(item1)
    saveData["inventory"].Push(item2)

    ; Quests
    saveData["quests"] := Map()
    saveData["quests"]["active"] := ["QUEST_001", "QUEST_005", "QUEST_012"]
    saveData["quests"]["completed"] := ["QUEST_000", "QUEST_002", "QUEST_003", "QUEST_004"]

    ; Game flags
    saveData["flags"] := Map()
    saveData["flags"]["dragonDefeated"] := true
    saveData["flags"]["castleDiscovered"] := true
    saveData["flags"]["allianceMade"] := false

    ; Convert to formatted JSON
    saveJson := JSON.stringify(saveData, 10, "  ")

    ; Save to file
    saveFile := A_ScriptDir "\game_save.json"
    try {
        FileDelete(saveFile)
    }
    FileAppend(saveJson, saveFile, "UTF-8")

    ; Display summary
    output := "Game Save Created:`n`n"
    output .= "Player: " saveData["player"]["name"] " (Level " saveData["player"]["level"] ")`n"
    output .= "Location: " saveData["player"]["position"]["map"] "`n"
    output .= "Health: " saveData["player"]["health"] "/" saveData["player"]["maxHealth"] "`n"
    output .= "Inventory Items: " saveData["inventory"].Length "`n"
    output .= "Active Quests: " saveData["quests"]["active"].Length "`n"
    output .= "Completed Quests: " saveData["quests"]["completed"].Length "`n`n"
    output .= "Saved to: " saveFile

    MsgBox(output)

    ; Test loading
    loadedJson := FileRead(saveFile)
    loadedData := JSON.parse(loadedJson)
    MsgBox("Successfully loaded save file!`nPlayer name: " loadedData["player"]["name"])
}

; Display menu
MsgBox("JSON Practical Examples Loaded`n`n"
    . "Available Examples:`n`n"
    . "1. ParseAPIResponseExample() - Parse web API responses`n"
    . "2. SaveConfigExample() - Save app configuration`n"
    . "3. LoadUserDataExample() - Load and validate user data`n"
    . "4. ProductCatalogExample() - Work with nested arrays`n"
    . "5. HandleSpecialValuesExample() - Null and boolean handling`n"
    . "6. CSVtoJSONExample() - Convert CSV to JSON`n"
    . "7. MergeJSONExample() - Merge multiple JSON files`n"
    . "8. CreateAPIRequestExample() - Create REST API requests`n"
    . "9. JSONLoggingExample() - Structured logging`n"
    . "10. GameSaveExample() - Complex game save data`n`n"
    . "Uncomment any function call below to run examples")

; Uncomment to run examples:
; ParseAPIResponseExample()
; SaveConfigExample()
; LoadUserDataExample()
; ProductCatalogExample()
; HandleSpecialValuesExample()
; CSVtoJSONExample()
; MergeJSONExample()
; CreateAPIRequestExample()
; JSONLoggingExample()
; GameSaveExample()

