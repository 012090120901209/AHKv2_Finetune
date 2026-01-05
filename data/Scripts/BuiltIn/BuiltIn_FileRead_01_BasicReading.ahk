#Requires AutoHotkey v2.0
#SingleInstance Force
#Include ../JSON.ahk

/**
 * ============================================================================
 * FileRead - Basic Reading Operations
 * ============================================================================
 * 
 * Demonstrates fundamental FileRead usage patterns including:
 * - Basic text file reading
 * - Reading binary data
 * - Memory-efficient reading techniques
 * - Error handling and validation
 * - Performance considerations
 * 
 * @description Basic examples of reading files with FileRead function
 * @author AutoHotkey Foundation
 * @version 1.0.0
 * @see https://www.autohotkey.com/docs/v2/lib/FileRead.htm
 */

; ============================================================================
; Example 1: Simple Text File Reading
; ============================================================================
; Basic read operation for small to medium text files

Example1_SimpleRead() {
    ; Create a sample file first
    testFile := A_Temp "\test_simple_read.txt"
    sampleContent := "
    (
    This is line 1
    This is line 2
    This is line 3
    End of file
    )"

    try {
        ; Write sample content
        FileAppend(sampleContent, testFile)

        ; Read the entire file content into a variable
        content := FileRead(testFile)

        ; Display the content
        MsgBox("File Contents:`n`n" content, "Simple Read Example")

        ; Process line by line
        lines := StrSplit(content, "`n")
        result := "Total Lines: " lines.Length "`n`n"

        for index, line in lines {
            if Trim(line)  ; Skip empty lines
                result .= "Line " index ": " Trim(line) "`n"
        }

        MsgBox(result, "Line by Line Processing")

    } catch as err {
        MsgBox("Error reading file: " err.Message, "Error", 16)
    } finally {
        ; Cleanup
        if FileExist(testFile)
            FileDelete(testFile)
    }
}

; ============================================================================
; Example 2: Reading with Encoding Specification
; ============================================================================
; Demonstrates reading files with specific character encodings

Example2_EncodingRead() {
    testFile := A_Temp "\test_encoding.txt"

    ; Test different encodings
    encodings := ["UTF-8", "UTF-16", "CP1252"]
    results := Map()

    for encoding in encodings {
        try {
            ; Write with specific encoding
            FileDelete(testFile)  ; Clear previous

            content := "Special characters: é ñ ü ö ß 中文 日本語 한글"
            FileAppend(content, testFile, encoding)

            ; Read with same encoding
            readContent := FileRead(testFile, encoding)

            ; Store result
            results[encoding] := readContent

        } catch as err {
            results[encoding] := "Error: " err.Message
        }
    }

    ; Display results
    output := "Encoding Test Results:`n`n"
    for encoding, content in results {
        output .= encoding ": " content "`n`n"
    }

    MsgBox(output, "Encoding Comparison")

    ; Cleanup
    if FileExist(testFile)
        FileDelete(testFile)
}

; ============================================================================
; Example 3: Reading Configuration Files
; ============================================================================
; Practical example of reading and parsing configuration files

Example3_ConfigFileRead() {
    configFile := A_Temp "\app_config.ini"

    ; Create sample configuration
    configContent := "
    (
    [General]
    AppName=MyApplication
    Version=1.0.0
    AutoStart=true

    [Database]
    Host=localhost
    Port=3306
    Username=admin

    [UI]
    Theme=dark
    Language=en
    FontSize=12
    )"

    try {
        ; Write config file
        FileAppend(configContent, configFile)

        ; Read entire config
        content := FileRead(configFile)

        ; Parse configuration into structured data
        config := ParseConfig(content)

        ; Display parsed configuration
        output := "Parsed Configuration:`n`n"

        for section, values in config {
            output .= "[" section "]`n"
            for key, value in values {
                output .= "  " key " = " value "`n"
            }
            output .= "`n"
        }

        MsgBox(output, "Configuration File Reader")

        ; Access specific values
        appName := config["General"]["AppName"]
        theme := config["UI"]["Theme"]

        MsgBox("App: " appName "`nTheme: " theme, "Specific Values")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if FileExist(configFile)
            FileDelete(configFile)
    }

    ; Helper function to parse INI-style config
    ParseConfig(content) {
        config := Map()
        currentSection := ""

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)

            ; Skip empty lines and comments
            if !line || SubStr(line, 1, 1) = ";"
                continue

            ; Check for section header
            if RegExMatch(line, "^\[(.*)\]$", &match) {
                currentSection := match[1]
                config[currentSection] := Map()
            }
            ; Check for key=value pair
            else if RegExMatch(line, "^([^=]+)=(.*)$", &match) && currentSection {
                key := Trim(match[1])
                value := Trim(match[2])
                config[currentSection][key] := value
            }
        }

        return config
    }
}

; ============================================================================
; Example 4: Reading JSON Data Files
; ============================================================================
; Reading and parsing JSON files for data exchange

Example4_JSONRead() {
    jsonFile := A_Temp "\data.json"

    ; Create sample JSON data
    jsonContent := '
    (
    {
        "users": [
        {
            "id": 1,
            "name": "John Doe",
            "email": "john@example.com",
            "active": true
        },
        {
            "id": 2,
            "name": "Jane Smith",
            "email": "jane@example.com",
            "active": false
        }
        ],
        "settings": {
            "maxUsers": 100,
            "timeout": 30,
            "debugMode": false
        }
    }
    )'

    try {
        ; Write JSON file
        FileAppend(jsonContent, jsonFile, "UTF-8")

        ; Read JSON file
        content := FileRead(jsonFile, "UTF-8")

        ; Parse JSON (using built-in JSON parser)
        data := Jxon_Load(&content)

        ; Display parsed data
        output := "JSON Data:`n`n"
        output .= "Total Users: " data["users"].Length "`n`n"

        for user in data["users"] {
            output .= "User #" user["id"] "`n"
            output .= "  Name: " user["name"] "`n"
            output .= "  Email: " user["email"] "`n"
            output .= "  Active: " (user["active"] ? "Yes" : "No") "`n`n"
        }

        output .= "Settings:`n"
        output .= "  Max Users: " data["settings"]["maxUsers"] "`n"
        output .= "  Timeout: " data["settings"]["timeout"] "s`n"
        output .= "  Debug Mode: " (data["settings"]["debugMode"] ? "On" : "Off")

        MsgBox(output, "JSON File Reader")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if FileExist(jsonFile)
            FileDelete(jsonFile)
    }

    ; Simple JSON parser (basic implementation)
    Jxon_Load(&src) {
        ; This is a simplified version - in production use a robust JSON library
        static q := Chr(34)  ; Quote character

        ; Remove whitespace
        src := StrReplace(src, "`r`n", "")
        src := StrReplace(src, "`n", "")

        ; Basic parsing
        obj := Map()

        ; Parse users array
        if RegExMatch(src, '"users"\s*:\s*\[(.*?)\](?=,|\})', &match) {
            usersStr := match[1]
            users := []

            ; Simple user object extraction
            pos := 1
            while pos := RegExMatch(usersStr, '\{([^}]+)\}', &userMatch, pos) {
                user := Map()
                userStr := userMatch[1]

                ; Extract fields
                if RegExMatch(userStr, '"id"\s*:\s*(\d+)', &m)
                    user["id"] := Integer(m[1])
                if RegExMatch(userStr, '"name"\s*:\s*"([^"]+)"', &m)
                    user["name"] := m[1]
                if RegExMatch(userStr, '"email"\s*:\s*"([^"]+)"', &m)
                    user["email"] := m[1]
                if RegExMatch(userStr, '"active"\s*:\s*(true|false)', &m)
                    user["active"] := (m[1] = "true")

                users.Push(user)
                pos += StrLen(userMatch[0])
            }
            obj["users"] := users
        }

        ; Parse settings object
        if RegExMatch(src, '"settings"\s*:\s*\{([^}]+)\}', &match) {
            settingsStr := match[1]
            settings := Map()

            if RegExMatch(settingsStr, '"maxUsers"\s*:\s*(\d+)', &m)
                settings["maxUsers"] := Integer(m[1])
            if RegExMatch(settingsStr, '"timeout"\s*:\s*(\d+)', &m)
                settings["timeout"] := Integer(m[1])
            if RegExMatch(settingsStr, '"debugMode"\s*:\s*(true|false)', &m)
                settings["debugMode"] := (m[1] = "true")

            obj["settings"] := settings
        }

        return obj
    }
}

; ============================================================================
; Example 5: Reading CSV Data Files
; ============================================================================
; Reading and parsing CSV files for spreadsheet-style data

Example5_CSVRead() {
    csvFile := A_Temp "\data.csv"

    ; Create sample CSV data
    csvContent := "
    (
    Name,Age,Department,Salary
    John Doe,35,Engineering,75000
    Jane Smith,28,Marketing,65000
    Bob Johnson,42,Sales,70000
    Alice Brown,31,Engineering,80000
    Charlie Wilson,39,HR,60000
    )"

    try {
        ; Write CSV file
        FileAppend(csvContent, csvFile)

        ; Read CSV file
        content := FileRead(csvFile)

        ; Parse CSV
        data := ParseCSV(content)

        ; Display data in formatted table
        output := "CSV Data (5 records):`n`n"

        ; Header
        output .= Format("{:-20} {:-6} {:-15} {:-10}`n",
            "Name", "Age", "Department", "Salary")
        output .= StrReplace(Format("{:-63}", ""), " ", "-") "`n"

        ; Data rows (skip header)
        for index, row in data {
            if index = 1
                continue  ; Skip header row

            output .= Format("{:-20} {:-6} {:-15} ${:-9}`n",
                row[1], row[2], row[3], row[4])
        }

        MsgBox(output, "CSV File Reader")

        ; Calculate statistics
        totalSalary := 0
        engineeringCount := 0

        for index, row in data {
            if index = 1
                continue

            totalSalary += row[4]
            if row[3] = "Engineering"
                engineeringCount++
        }

        avgSalary := Round(totalSalary / (data.Length - 1))

        stats := "Statistics:`n`n"
        stats .= "Total Employees: " (data.Length - 1) "`n"
        stats .= "Average Salary: $" avgSalary "`n"
        stats .= "Engineering Staff: " engineeringCount

        MsgBox(stats, "CSV Statistics")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if FileExist(csvFile)
            FileDelete(csvFile)
    }

    ; CSV parser helper function
    ParseCSV(content) {
        rows := []

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)
            if !line
                continue

            ; Split by comma
            fields := StrSplit(line, ",")

            ; Trim each field
            row := []
            for field in fields {
                row.Push(Trim(field))
            }

            rows.Push(row)
        }

        return rows
    }
}

; ============================================================================
; Example 6: Reading Log Files with Filtering
; ============================================================================
; Reading and filtering log files for specific information

Example6_LogFileRead() {
    logFile := A_Temp "\application.log"

    ; Create sample log file
    logContent := "
    (
    2024-01-15 10:30:15 [INFO] Application started
    2024-01-15 10:30:16 [INFO] Loading configuration
    2024-01-15 10:30:17 [WARNING] Config file missing, using defaults
    2024-01-15 10:30:18 [INFO] Database connection established
    2024-01-15 10:31:22 [ERROR] Failed to load user data: Connection timeout
    2024-01-15 10:31:25 [INFO] Retrying connection...
    2024-01-15 10:31:30 [INFO] Connection successful
    2024-01-15 10:32:45 [WARNING] High memory usage detected: 85%
    2024-01-15 10:33:10 [ERROR] Database query failed: Syntax error
    2024-01-15 10:33:15 [INFO] Error logged to database
    2024-01-15 10:34:00 [INFO] User login: admin
    2024-01-15 10:35:30 [WARNING] Multiple failed login attempts detected
    )"

    try {
        ; Write log file
        FileAppend(logContent, logFile)

        ; Read log file
        content := FileRead(logFile)

        ; Parse and filter logs
        logs := ParseLogs(content)

        ; Show all logs
        DisplayLogs(logs, "all", "All Logs")

        ; Show only errors
        DisplayLogs(logs, "ERROR", "Error Logs Only")

        ; Show warnings and errors
        DisplayLogs(logs, "WARNING|ERROR", "Warnings and Errors")

        ; Generate summary
        summary := GenerateLogSummary(logs)
        MsgBox(summary, "Log Summary")

    } catch as err {
        MsgBox("Error: " err.Message, "Error", 16)
    } finally {
        if FileExist(logFile)
            FileDelete(logFile)
    }

    ; Parse log entries
    ParseLogs(content) {
        logs := []

        for line in StrSplit(content, "`n", "`r") {
            line := Trim(line)
            if !line
                continue

            ; Parse log entry
            if RegExMatch(line, "^(\S+ \S+) \[(\w+)\] (.+)$", &match) {
                log := Map()
                log["timestamp"] := match[1]
                log["level"] := match[2]
                log["message"] := match[3]
                logs.Push(log)
            }
        }

        return logs
    }

    ; Display filtered logs
    DisplayLogs(logs, filter, title) {
        output := title ":`n`n"
        count := 0

        for log in logs {
            if filter = "all" || RegExMatch(log["level"], filter) {
                output .= log["timestamp"] " [" log["level"] "] " log["message"] "`n"
                count++
            }
        }

        output .= "`nTotal entries: " count
        MsgBox(output, title)
    }

    ; Generate log summary
    GenerateLogSummary(logs) {
        stats := Map("INFO", 0, "WARNING", 0, "ERROR", 0)

        for log in logs {
            level := log["level"]
            if stats.Has(level)
                stats[level]++
        }

        summary := "Log File Summary:`n`n"
        summary .= "Total Entries: " logs.Length "`n`n"
        summary .= "INFO: " stats["INFO"] "`n"
        summary .= "WARNING: " stats["WARNING"] "`n"
        summary .= "ERROR: " stats["ERROR"] "`n`n"

        errorRate := Round((stats["ERROR"] / logs.Length) * 100, 2)
        summary .= "Error Rate: " errorRate "%"

        return summary
    }
}

; ============================================================================
; Example 7: Safe File Reading with Validation
; ============================================================================
; Demonstrates robust file reading with proper error handling and validation

Example7_SafeFileRead() {
    testFile := A_Temp "\test_safe_read.txt"

    ; Create test file
    FileAppend("Sample content for safe reading test.", testFile)

    ; Demonstrate safe reading
    result1 := SafeFileRead(testFile)
    MsgBox("Reading existing file:`n`n" result1, "Safe Read - Success")

    ; Try reading non-existent file
    result2 := SafeFileRead(A_Temp "\nonexistent.txt")
    MsgBox("Reading non-existent file:`n`n" result2, "Safe Read - File Not Found")

    ; Cleanup
    if FileExist(testFile)
        FileDelete(testFile)

    ; Safe file reading function with validation
    SafeFileRead(filePath, encoding := "UTF-8") {
        ; Validate file path
        if !filePath
            return "Error: No file path provided"

        ; Check if file exists
        if !FileExist(filePath)
            return "Error: File does not exist - " filePath

        ; Check if it's a file (not directory)
        if InStr(FileExist(filePath), "D")
            return "Error: Path is a directory, not a file"

        ; Try to read the file
        try {
            content := FileRead(filePath, encoding)

            ; Validate content
            if !content
                return "Warning: File is empty"

            return content

        } catch as err {
            return "Error reading file: " err.Message
        }
    }
}

; ============================================================================
; Run Examples
; ============================================================================

; Uncomment to run individual examples:
; Example1_SimpleRead()
; Example2_EncodingRead()
; Example3_ConfigFileRead()
; Example4_JSONRead()
; Example5_CSVRead()
; Example6_LogFileRead()
; Example7_SafeFileRead()

; Run all examples
RunAllExamples() {
    examples := [{
        name: "Simple Text Reading", func: Example1_SimpleRead }, {
            name: "Encoding Specification", func: Example2_EncodingRead }, {
                name: "Config File Reading", func: Example3_ConfigFileRead }, {
                    name: "JSON Data Reading", func: Example4_JSONRead }, {
                        name: "CSV Data Reading", func: Example5_CSVRead }, {
                            name: "Log File Reading", func: Example6_LogFileRead }, {
                                name: "Safe File Reading", func: Example7_SafeFileRead
                            }
    ]

    for example in examples {
        result := MsgBox("Run: " example.name "?", "FileRead Examples", 4)
        if result = "Yes"
            example.func.Call()
    }
}

; Uncomment to run all examples interactively:
; RunAllExamples()

