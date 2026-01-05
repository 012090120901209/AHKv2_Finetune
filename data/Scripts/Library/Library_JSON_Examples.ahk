#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
 * JSON Library Examples - thqby/ahk2_lib
 * 
 * Comprehensive examples for JSON parsing and stringification
 * Library: https://github.com/thqby/ahk2_lib/blob/master/JSON.ahk
 */

/**
 * Example 1: Basic JSON Parsing
 * Convert JSON string to AHK object
 */
BasicParsingExample() {
    jsonString := '{"name": "Alice", "age": 30, "active": true}'

    ; Parse JSON to object
    obj := JSON.parse(jsonString)

    MsgBox("Name: " obj.name "`nAge: " obj.age "`nActive: " obj.active)
}

/**
 * Example 2: Parse JSON Array
 */
ParseArrayExample() {
    jsonArray := '["apple", "banana", "cherry", "date"]'

    arr := JSON.parse(jsonArray)

    output := "Fruits:`n"
    for index, fruit in arr
        output .= index ". " fruit "`n"

    MsgBox(output)
}

/**
 * Example 3: Parse Nested JSON
 */
ParseNestedExample() {
    jsonNested := '
    (
    {
        "user": {
            "name": "Bob Smith",
            "email": "bob@example.com",
            "address": {
                "street": "123 Main St",
                "city": "Springfield",
                "zip": "12345"
            }
        }
    }
    )'

    obj := JSON.parse(jsonNested)

    MsgBox("User: " obj.user.name
        . "`nEmail: " obj.user.email
        . "`nAddress: " obj.user.address.street ", " obj.user.address.city " " obj.user.address.zip)
}

/**
 * Example 4: Parse JSON with Arrays of Objects
 */
ParseArrayObjectsExample() {
    jsonData := '
    (
    {
        "employees": [
        {
            "id": 1, "name": "Alice", "role": "Developer"},
            {
                "id": 2, "name": "Bob", "role": "Designer"},
                {
                    "id": 3, "name": "Charlie", "role": "Manager"
                }
                ]
            }
            )'

    data := JSON.parse(jsonData)

    output := "Employees:`n`n"
    for employee in data.employees
        output .= "ID: " employee.id " | Name: " employee.name " | Role: " employee.role "`n"

    MsgBox(output)
}

/**
 * Example 5: Convert AHK Object to JSON
 */
StringifyObjectExample() {
    ; Create AHK object
    person := Map()
    person["name"] := "Alice Johnson"
    person["age"] := 30
    person["email"] := "alice@example.com"
    person["active"] := true

    ; Convert to JSON
    jsonString := JSON.stringify(person)

    MsgBox("JSON Output:`n`n" jsonString)
}

/**
 * Example 6: Stringify with Formatting
 */
StringifyFormattedExample() {
    data := Map()
    data["user"] := Map()
    data["user"]["name"] := "Bob Smith"
    data["user"]["age"] := 25
    data["user"]["hobbies"] := ["reading", "gaming", "coding"]

    ; Stringify with indentation (2 spaces)
    formattedJSON := JSON.stringify(data, , 2)

    MsgBox("Formatted JSON:`n`n" formattedJSON)
}

/**
 * Example 7: Convert Array to JSON
 */
StringifyArrayExample() {
    fruits := ["apple", "banana", "cherry", "date", "elderberry"]

    jsonArray := JSON.stringify(fruits)

    MsgBox("Array as JSON:`n`n" jsonArray)
}

/**
 * Example 8: Complex Data Structure
 */
ComplexDataExample() {
    ; Build complex data structure
    company := Map()
    company["name"] := "Tech Corp"
    company["founded"] := 2010

    ; Departments array
    departments := []

    ; Engineering department
    eng := Map()
    eng["name"] := "Engineering"
    eng["head"] := "Alice Johnson"
    eng["employees"] := 15
    departments.Push(eng)

    ; Sales department
    sales := Map()
    sales["name"] := "Sales"
    sales["head"] := "Bob Smith"
    sales["employees"] := 10
    departments.Push(sales)

    company["departments"] := departments

    ; Convert to formatted JSON
    json := JSON.stringify(company, , 2)

    MsgBox("Company Data:`n`n" json)
}

/**
 * Example 9: Save and Load JSON File
 */
SaveLoadJSONFileExample() {
    filePath := A_ScriptDir "\test_data.json"

    ; Create data
    config := Map()
    config["appName"] := "MyApp"
    config["version"] := "1.0.0"
    config["settings"] := Map()
    config["settings"]["theme"] := "dark"
    config["settings"]["language"] := "en"

    ; Save to file
    jsonString := JSON.stringify(config, , 2)
    FileDelete(filePath)  ; Remove if exists
    FileAppend(jsonString, filePath)
    MsgBox("Data saved to: " filePath)

    Sleep(1000)

    ; Load from file
    loadedJSON := FileRead(filePath)
    loadedConfig := JSON.parse(loadedJSON)

    MsgBox("Loaded Config:`n`n"
        . "App: " loadedConfig["appName"] "`n"
        . "Version: " loadedConfig["version"] "`n"
        . "Theme: " loadedConfig["settings"]["theme"])

    ; Cleanup
    FileDelete(filePath)
}

/**
 * Example 10: Parse JSON with Comments
 */
ParseWithCommentsExample() {
    ; JSON with comments (supported by this library)
    jsonWithComments := '
            (
            {
                // User information
                "name": "Charlie",
                "age": 35,  // Age in years
                /* Contact details */
                "email": "charlie@example.com"
            }
            )'

    obj := JSON.parse(jsonWithComments)

    MsgBox("Parsed (ignoring comments):`n`n"
        . "Name: " obj.name "`n"
        . "Age: " obj.age "`n"
        . "Email: " obj.email)
}

/**
 * Example 11: API Response Simulation
 */
APIResponseExample() {
    ; Simulate API response
    apiResponse := '
            (
            {
                "status": "success",
                "data": {
                    "users": [
                    {
                        "id": 1, "username": "alice", "email": "alice@example.com"},
                        {
                            "id": 2, "username": "bob", "email": "bob@example.com"
                        }
                        ],
                        "total": 2
                    },
                    "timestamp": "2025-01-05T10:30:00Z"
                }
                )'

    response := JSON.parse(apiResponse)

    if (response.status = "success") {
        output := "API Response Successful`n`n"
        output .= "Total Users: " response.data.total "`n`n"

        for user in response.data.users
            output .= "User #" user.id ": " user.username " (" user.email ")`n"

        output .= "`nTimestamp: " response.timestamp

        MsgBox(output)
    }
}

/**
 * Example 12: Configuration Manager
 */
ConfigManagerExample() {

    ; Use the config manager
    configPath := A_ScriptDir "\app_config.json"
    cm := ConfigManager(configPath)

    ; Set some values
    cm.Set("windowX", 100)
    cm.Set("windowY", 200)
    cm.Set("theme", "dark")
    cm.Set("language", "en")
    cm.Save()

    MsgBox("Config saved!")

    ; Load and display
    cm2 := ConfigManager(configPath)
    MsgBox("Loaded Config:`n`n"
        . "Window X: " cm2.Get("windowX") "`n"
        . "Window Y: " cm2.Get("windowY") "`n"
        . "Theme: " cm2.Get("theme") "`n"
        . "Language: " cm2.Get("language"))

    ; Cleanup
    FileDelete(configPath)
}

/**
 * Example 13: Data Transformation
 */
DataTransformationExample() {
    ; Original data (CSV-like)
    csvData := "Name,Age,City`nAlice,30,NYC`nBob,25,LA`nCharlie,35,Chicago"

    ; Convert to JSON
    lines := StrSplit(csvData, "`n")
    headers := StrSplit(lines[1], ",")

    dataArray := []
    loop lines.Length - 1 {
        values := StrSplit(lines[A_Index + 1], ",")
        row := Map()

        loop headers.Length
            row[headers[A_Index]] := values[A_Index]

        dataArray.Push(row)
    }

    result := Map()
    result["data"] := dataArray
    result["count"] := dataArray.Length

    jsonOutput := JSON.stringify(result, , 2)

    MsgBox("CSV converted to JSON:`n`n" jsonOutput)
}

/**
 * Example 14: Error Handling
 */
ErrorHandlingExample() {
    ; Invalid JSON
    invalidJSON := '{"name": "Alice", "age": invalid}'

    try {
        obj := JSON.parse(invalidJSON)
        MsgBox("Parsed successfully: " obj.name)
    } catch Error as e {
        MsgBox("JSON Parse Error:`n`n" e.Message, "Error")
    }
}

/**
 * Example 15: Performance Test
 */
PerformanceTestExample() {
    ; Generate large dataset
    largeData := []
    loop 1000 {
        item := Map()
        item["id"] := A_Index
        item["name"] := "User" A_Index
        item["value"] := Random(1, 100)
        largeData.Push(item)
    }

    ; Test stringify performance
    startTime := A_TickCount
    jsonString := JSON.stringify(largeData)
    stringifyTime := A_TickCount - startTime

    ; Test parse performance
    startTime := A_TickCount
    parsedData := JSON.parse(jsonString)
    parseTime := A_TickCount - startTime

    MsgBox("Performance Test (1000 objects):`n`n"
        . "Stringify: " stringifyTime " ms`n"
        . "Parse: " parseTime " ms`n"
        . "JSON Size: " Round(StrLen(jsonString) / 1024, 2) " KB")
}

MsgBox("JSON Library Examples Loaded`n`n"
    . "Available Examples:`n"
    . "- BasicParsingExample()`n"
    . "- ParseArrayExample()`n"
    . "- ParseNestedExample()`n"
    . "- StringifyObjectExample()`n"
    . "- StringifyFormattedExample()`n"
    . "- ComplexDataExample()`n"
    . "- SaveLoadJSONFileExample()`n"
    . "- APIResponseExample()`n"
    . "- ConfigManagerExample()`n"
    . "- DataTransformationExample()`n"
    . "- PerformanceTestExample()")

; Uncomment to test:
; BasicParsingExample()
; ParseArrayExample()
; StringifyFormattedExample()
; SaveLoadJSONFileExample()
; ConfigManagerExample()
; Moved class ConfigManager from nested scope
class ConfigManager {
    configFile := ""
    config := Map()

    __New(filePath) {
        this.configFile := filePath
        this.Load()
    }

    Load() {
        if FileExist(this.configFile) {
            jsonText := FileRead(this.configFile)
            this.config := JSON.parse(jsonText)
        } else {
            this.config := Map()
        }
    }

    Save() {
        jsonText := JSON.stringify(this.config, , 2)
        FileDelete(this.configFile)
        FileAppend(jsonText, this.configFile)
    }

    Get(key, default := "") {
        return this.config.Has(key) ? this.config[key] : default
    }

    Set(key, value) {
        this.config[key] := value
        return this
    }
}
