#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Switch with Multiple Cases
 * ============================================================================
 *
 * This script demonstrates advanced switch patterns with multiple cases.
 * It covers combining cases, grouping related values, and handling
 * multiple conditions elegantly.
 *
 * @file BuiltIn_Switch_02.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 *
 * @description
 * Examples included:
 * 1. Multiple case values with comma separation
 * 2. Grouping similar cases
 * 3. Day type classification (weekday/weekend)
 * 4. Season determination
 * 5. Character classification
 * 6. HTTP method routing
 * 7. File category management
 *
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Multiple Case Values
; ============================================================================

/**
 * Demonstrates using comma-separated values in case statements.
 * Shows how to handle multiple inputs with same logic.
 */
Example1_MultipleCaseValues() {
    OutputDebug("=== Example 1: Multiple Case Values ===`n")

    ; Weekend vs weekday
    day := "Saturday"

    switch day {
        case "Monday", "Tuesday", "Wednesday", "Thursday", "Friday":
            OutputDebug(day " is a weekday - Work day`n")
            isWorkDay := true
            alarmTime := "6:30 AM"

        case "Saturday", "Sunday":
            OutputDebug(day " is a weekend - Rest day`n")
            isWorkDay := false
            alarmTime := "9:00 AM"

        default:
            OutputDebug("Invalid day: " day "`n")
            isWorkDay := false
            alarmTime := "N/A"
    }

    OutputDebug("Alarm set for: " alarmTime "`n")

    ; Vowel detection
    OutputDebug("`n")
    letter := "A"

    switch letter {
        case "a", "e", "i", "o", "u", "A", "E", "I", "O", "U":
            OutputDebug(letter " is a vowel`n")
            letterType := "vowel"

        default:
            OutputDebug(letter " is a consonant`n")
            letterType := "consonant"
    }

    ; Traffic light actions
    OutputDebug("`n")
    lightColor := "yellow"

    switch lightColor {
        case "red":
            action := "STOP"
            duration := "Wait"
            OutputDebug("Red light: " action "`n")

        case "yellow", "amber":
            action := "SLOW DOWN"
            duration := "Prepare to stop"
            OutputDebug("Yellow light: " action "`n")

        case "green":
            action := "GO"
            duration := "Proceed"
            OutputDebug("Green light: " action "`n")

        default:
            action := "CAUTION"
            OutputDebug("Unknown signal`n")
    }

    ; Boolean-like string values
    OutputDebug("`n")
    userInput := "yes"

    switch userInput {
        case "yes", "y", "true", "1", "ok":
            result := true
            OutputDebug("User confirmed: " userInput " -> true`n")

        case "no", "n", "false", "0", "cancel":
            result := false
            OutputDebug("User declined: " userInput " -> false`n")

        default:
            result := false
            OutputDebug("Unknown input, defaulting to false`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Grouping Similar Cases
; ============================================================================

/**
 * Demonstrates grouping semantically related cases.
 * Shows organizational patterns for clearer code.
 */
Example2_GroupingSimilarCases() {
    OutputDebug("=== Example 2: Grouping Similar Cases ===`n")

    ; Number classification
    number := 7

    switch number {
        case 2, 3, 5, 7:
            OutputDebug(number " is a single-digit prime`n")
            category := "prime"

        case 4, 6, 8, 9:
            OutputDebug(number " is a single-digit composite`n")
            category := "composite"

        case 0, 1:
            OutputDebug(number " is special (neither prime nor composite)`n")
            category := "special"

        default:
            OutputDebug(number " is outside single-digit range`n")
            category := "unknown"
    }

    ; HTTP success codes
    OutputDebug("`n")
    statusCode := 201

    switch statusCode {
        case 200, 201, 202, 204:
            OutputDebug("Success: " statusCode "`n")
            category := "success"
            shouldRetry := false

        case 301, 302, 303, 307, 308:
            OutputDebug("Redirect: " statusCode "`n")
            category := "redirect"
            shouldRetry := false

        case 400, 401, 403, 404:
            OutputDebug("Client Error: " statusCode "`n")
            category := "client_error"
            shouldRetry := false

        case 500, 502, 503, 504:
            OutputDebug("Server Error: " statusCode "`n")
            category := "server_error"
            shouldRetry := true

        default:
            OutputDebug("Unknown status: " statusCode "`n")
            category := "unknown"
            shouldRetry := false
    }

    ; Card suit classification
    OutputDebug("`n")
    suit := "hearts"

    switch suit {
        case "hearts", "diamonds":
            OutputDebug(suit " is a red suit`n")
            color := "red"
            points := 0

        case "clubs", "spades":
            OutputDebug(suit " is a black suit`n")
            color := "black"
            points := 0

        default:
            OutputDebug("Invalid suit: " suit "`n")
            color := "unknown"
    }

    ; Programming language paradigms
    OutputDebug("`n")
    language := "Python"

    switch language {
        case "Java", "C#", "C++":
            OutputDebug(language " is object-oriented and compiled/JIT`n")
            paradigm := "OOP"
            execution := "compiled"

        case "Python", "Ruby", "JavaScript":
            OutputDebug(language " is multi-paradigm and interpreted`n")
            paradigm := "multi"
            execution := "interpreted"

        case "Haskell", "Erlang", "Elixir":
            OutputDebug(language " is functional`n")
            paradigm := "functional"
            execution := "varies"

        default:
            OutputDebug(language " - classification unknown`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Day Type Classification
; ============================================================================

/**
 * Demonstrates comprehensive day classification logic.
 * Shows business logic with multiple day categories.
 */
Example3_DayTypeClassification() {
    OutputDebug("=== Example 3: Day Type Classification ===`n")

    ; Standard weekday/weekend
    ProcessDaySchedule("Monday")
    ProcessDaySchedule("Saturday")
    ProcessDaySchedule("Wednesday")

    OutputDebug("`n")
}

/**
 * Processes schedule based on day type.
 */
ProcessDaySchedule(dayName) {
    switch dayName {
        case "Monday", "Tuesday", "Wednesday", "Thursday":
            dayType := "Regular Weekday"
            workHours := "9:00 AM - 5:00 PM"
            staffRequired := 10
            specialNotes := "Normal operations"

        case "Friday":
            dayType := "End of Week"
            workHours := "9:00 AM - 4:00 PM"
            staffRequired := 8
            specialNotes := "Early closure"

        case "Saturday":
            dayType := "Weekend"
            workHours := "10:00 AM - 2:00 PM"
            staffRequired := 3
            specialNotes := "Limited hours"

        case "Sunday":
            dayType := "Weekend - Closed"
            workHours := "Closed"
            staffRequired := 0
            specialNotes := "No operations"

        default:
            dayType := "Unknown"
            workHours := "N/A"
            staffRequired := 0
            specialNotes := "Invalid day"
    }

    OutputDebug("Day: " dayName "`n")
    OutputDebug("  Type: " dayType "`n")
    OutputDebug("  Hours: " workHours "`n")
    OutputDebug("  Staff: " staffRequired "`n")
    OutputDebug("  Notes: " specialNotes "`n`n")
}

; ============================================================================
; Example 4: Season Determination
; ============================================================================

/**
 * Demonstrates month grouping for seasons.
 * Shows temporal classification patterns.
 */
Example4_SeasonDetermination() {
    OutputDebug("=== Example 4: Season Determination ===`n")

    ; Test different months
    DetermineSeasonInfo(3)   ; March
    DetermineSeasonInfo(7)   ; July
    DetermineSeasonInfo(10)  ; October
    DetermineSeasonInfo(12)  ; December

    OutputDebug("`n")
}

/**
 * Determines season and related information from month number.
 */
DetermineSeasonInfo(monthNum) {
    switch monthNum {
        case 3, 4, 5:
            season := "Spring"
            temperature := "Mild"
            activities := "Gardening, Hiking"
            holidays := "Easter (varies)"

        case 6, 7, 8:
            season := "Summer"
            temperature := "Hot"
            activities := "Swimming, Beach, BBQ"
            holidays := "Independence Day (July)"

        case 9, 10, 11:
            season := "Fall/Autumn"
            temperature := "Cool"
            activities := "Leaf watching, Harvest"
            holidays := "Thanksgiving (November)"

        case 12, 1, 2:
            season := "Winter"
            temperature := "Cold"
            activities := "Skiing, Ice skating"
            holidays := "Christmas, New Year"

        default:
            season := "Invalid"
            temperature := "N/A"
            activities := "None"
            holidays := "None"
    }

    OutputDebug("Month " monthNum " -> Season: " season "`n")
    OutputDebug("  Temperature: " temperature "`n")
    OutputDebug("  Activities: " activities "`n")
    OutputDebug("  Holidays: " holidays "`n`n")
}

; ============================================================================
; Example 5: Character Classification
; ============================================================================

/**
 * Demonstrates character type detection.
 * Shows pattern for input validation and parsing.
 */
Example5_CharacterClassification() {
    OutputDebug("=== Example 5: Character Classification ===`n")

    ; Test various characters
    ClassifyCharacter("A")
    ClassifyCharacter("5")
    ClassifyCharacter("@")
    ClassifyCharacter(" ")

    OutputDebug("`n")
}

/**
 * Classifies a single character.
 */
ClassifyCharacter(char) {
    switch char {
        case "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
             "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z":
            charType := "Lowercase Letter"
            isAlpha := true
            isNumeric := false

        case "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
             "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z":
            charType := "Uppercase Letter"
            isAlpha := true
            isNumeric := false

        case "0", "1", "2", "3", "4", "5", "6", "7", "8", "9":
            charType := "Digit"
            isAlpha := false
            isNumeric := true

        case " ", "`t", "`n", "`r":
            charType := "Whitespace"
            isAlpha := false
            isNumeric := false

        case "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "=", "+":
            charType := "Special Character"
            isAlpha := false
            isNumeric := false

        default:
            charType := "Other"
            isAlpha := false
            isNumeric := false
    }

    OutputDebug("Character '" char "': " charType "`n")
    OutputDebug("  Alpha: " isAlpha ", Numeric: " isNumeric "`n`n")
}

; ============================================================================
; Example 6: HTTP Method Routing
; ============================================================================

/**
 * Demonstrates HTTP method handling like in web frameworks.
 * Shows request routing patterns.
 */
Example6_HTTPMethodRouting() {
    OutputDebug("=== Example 6: HTTP Method Routing ===`n")

    ; Simulate different HTTP requests
    HandleRequest("GET", "/users", "")
    HandleRequest("POST", "/users", "name=John")
    HandleRequest("DELETE", "/users/123", "")
    HandleRequest("PATCH", "/users/123", "status=active")

    OutputDebug("`n")
}

/**
 * Routes HTTP requests based on method.
 */
HandleRequest(method, path, data) {
    OutputDebug("Request: " method " " path "`n")

    switch method {
        case "GET", "HEAD":
            action := "Retrieve"
            allowsBody := false
            isSafe := true
            isIdempotent := true
            OutputDebug("  Action: Fetching resource`n")

        case "POST":
            action := "Create"
            allowsBody := true
            isSafe := false
            isIdempotent := false
            OutputDebug("  Action: Creating new resource`n")
            OutputDebug("  Data: " data "`n")

        case "PUT":
            action := "Replace"
            allowsBody := true
            isSafe := false
            isIdempotent := true
            OutputDebug("  Action: Replacing resource`n")
            OutputDebug("  Data: " data "`n")

        case "PATCH":
            action := "Update"
            allowsBody := true
            isSafe := false
            isIdempotent := false
            OutputDebug("  Action: Updating resource`n")
            OutputDebug("  Data: " data "`n")

        case "DELETE":
            action := "Remove"
            allowsBody := false
            isSafe := false
            isIdempotent := true
            OutputDebug("  Action: Deleting resource`n")

        case "OPTIONS", "TRACE":
            action := "Meta"
            allowsBody := false
            isSafe := true
            isIdempotent := true
            OutputDebug("  Action: Metadata operation`n")

        default:
            action := "Unknown"
            OutputDebug("  ERROR: Unsupported method`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: File Category Management
; ============================================================================

/**
 * Demonstrates file categorization by extension.
 * Shows document management patterns.
 */
Example7_FileCategoryManagement() {
    OutputDebug("=== Example 7: File Category Management ===`n")

    ; Test various file types
    CategorizeFile("document.pdf")
    CategorizeFile("photo.jpg")
    CategorizeFile("song.mp3")
    CategorizeFile("script.ahk")
    CategorizeFile("data.csv")

    OutputDebug("`n")
}

/**
 * Categorizes file and suggests appropriate action.
 */
CategorizeFile(fileName) {
    ; Extract extension
    dotPos := InStr(fileName, ".", , -1)
    if (dotPos) {
        extension := SubStr(fileName, dotPos)
    } else {
        extension := ""
    }

    OutputDebug("File: " fileName "`n")

    switch extension {
        case ".doc", ".docx", ".odt", ".rtf":
            category := "Document"
            icon := "📄"
            defaultApp := "Word Processor"
            canEdit := true

        case ".pdf":
            category := "Document"
            icon := "📕"
            defaultApp := "PDF Reader"
            canEdit := false

        case ".jpg", ".jpeg", ".png", ".gif", ".bmp", ".svg":
            category := "Image"
            icon := "🖼️"
            defaultApp := "Image Viewer"
            canEdit := true

        case ".mp3", ".wav", ".flac", ".aac", ".ogg":
            category := "Audio"
            icon := "🎵"
            defaultApp := "Media Player"
            canEdit := false

        case ".mp4", ".avi", ".mkv", ".mov", ".wmv":
            category := "Video"
            icon := "🎬"
            defaultApp := "Video Player"
            canEdit := false

        case ".txt", ".log", ".md":
            category := "Text"
            icon := "📝"
            defaultApp := "Text Editor"
            canEdit := true

        case ".ahk", ".py", ".js", ".cpp", ".java":
            category := "Source Code"
            icon := "💻"
            defaultApp := "Code Editor"
            canEdit := true

        case ".zip", ".rar", ".7z", ".tar", ".gz":
            category := "Archive"
            icon := "📦"
            defaultApp := "Archive Manager"
            canEdit := false

        case ".exe", ".msi", ".dll":
            category := "Executable"
            icon := "⚙️"
            defaultApp := "System"
            canEdit := false

        case ".xls", ".xlsx", ".csv":
            category := "Spreadsheet"
            icon := "📊"
            defaultApp := "Spreadsheet App"
            canEdit := true

        default:
            category := "Unknown"
            icon := "❓"
            defaultApp := "System Default"
            canEdit := false
    }

    OutputDebug("  Category: " icon " " category "`n")
    OutputDebug("  Default App: " defaultApp "`n")
    OutputDebug("  Editable: " canEdit "`n`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" "=" * 70 "`n")
    OutputDebug("AutoHotkey v2 - Switch with Multiple Cases Examples`n")
    OutputDebug("=" * 70 "`n`n")

    Example1_MultipleCaseValues()
    Example2_GroupingSimilarCases()
    Example3_DayTypeClassification()
    Example4_SeasonDetermination()
    Example5_CharacterClassification()
    Example6_HTTPMethodRouting()
    Example7_FileCategoryManagement()

    OutputDebug("=" * 70 "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug("=" * 70 "`n")
}

Main()
