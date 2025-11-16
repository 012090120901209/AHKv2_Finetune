#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * InputBox Practical Applications - Part 3
 * ============================================================================
 *
 * Practical InputBox applications and real-world scenarios in AutoHotkey v2.
 *
 * @description This file covers practical InputBox applications including:
 *              - Interactive calculators
 *              - Data entry automation
 *              - Search and filter interfaces
 *              - Quick launchers and shortcuts
 *              - Configuration wizards
 *              - Batch processing input
 *
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/InputBox.htm
 *
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Interactive Calculator
; ============================================================================
/**
 * Creates an interactive calculator using InputBox.
 *
 * @description Demonstrates mathematical operations with input validation
 *              and result display.
 */
Example1_InteractiveCalculator() {
    ; Basic calculator
    Loop {
        operation := MsgBox("Select operation:`n`n"
                          . "Yes - Continue calculating`n"
                          . "No - Exit calculator",
                          "Calculator",
                          "YesNo Iconi")

        if (operation = "No")
            break

        ; Get operation type
        op := MsgBox("Choose operation:`n`n"
                   . "Yes - Add/Subtract/Multiply/Divide`n"
                   . "No - Advanced (Power/Root/Percentage)",
                   "Operation Type",
                   "YesNo")

        if (op = "Yes") {
            PerformBasicOperation()
        } else {
            PerformAdvancedOperation()
        }
    }

    ; Unit converter
    UnitConverter()

    ; Percentage calculator
    PercentageCalculator()

    ; Tip calculator
    TipCalculator()

    ; Loan calculator
    LoanCalculator()
}

/**
 * Performs basic math operations.
 */
PerformBasicOperation() {
    num1 := GetValidFloat("Enter first number:", "Calculator")
    if (num1 = "")
        return

    operators := ["+", "-", "*", "/"]
    operator := InputBox("Enter operator (+, -, *, /):", "Operator").Value

    if (!HasValue(operators, operator)) {
        MsgBox "Invalid operator!", "Error", "Iconx"
        return
    }

    num2 := GetValidFloat("Enter second number:", "Calculator")
    if (num2 = "")
        return

    ; Prevent division by zero
    if (operator = "/" && num2 = 0) {
        MsgBox "Cannot divide by zero!", "Error", "Iconx"
        return
    }

    ; Calculate result
    result := 0
    Switch operator {
        Case "+": result := num1 + num2
        Case "-": result := num1 - num2
        Case "*": result := num1 * num2
        Case "/": result := num1 / num2
    }

    MsgBox Format("{1} {2} {3} = {4}",
                 num1, operator, num2, Round(result, 6)),
           "Result",
           "Iconi"
}

/**
 * Performs advanced math operations.
 */
PerformAdvancedOperation() {
    opType := MsgBox("Select operation:`n`n"
                   . "Yes - Power (x^y)`n"
                   . "No - Square Root",
                   "Advanced Operation",
                   "YesNoCancel")

    Switch opType {
        Case "Yes":
            base := GetValidFloat("Enter base number:", "Power")
            if (base = "")
                return

            exponent := GetValidFloat("Enter exponent:", "Power")
            if (exponent = "")
                return

            result := base ** exponent
            MsgBox Format("{1}^{2} = {3}",
                         base, exponent, Round(result, 6)),
                   "Result",
                   "Iconi"

        Case "No":
            num := GetPositiveNumber("Enter number:", "Square Root")
            if (num = "")
                return

            result := Sqrt(num)
            MsgBox Format("√{1} = {2}",
                         num, Round(result, 6)),
                   "Result",
                   "Iconi"
    }
}

/**
 * Unit converter.
 */
UnitConverter() {
    convType := MsgBox("Convert:`n`n"
                     . "Yes - Temperature (F ↔ C)`n"
                     . "No - Distance (mi ↔ km)",
                     "Unit Converter",
                     "YesNoCancel")

    Switch convType {
        Case "Yes":
            temp := GetValidFloat("Enter temperature:", "Temperature")
            if (temp = "")
                return

            dir := MsgBox("Convert:`n`nYes - F to C`nNo - C to F",
                        "Direction",
                        "YesNo")

            if (dir = "Yes") {
                celsius := (temp - 32) * 5 / 9
                MsgBox Format("{1}°F = {2}°C",
                            temp, Round(celsius, 2)),
                       "Result",
                       "Iconi"
            } else {
                fahrenheit := (temp * 9 / 5) + 32
                MsgBox Format("{1}°C = {2}°F",
                            temp, Round(fahrenheit, 2)),
                       "Result",
                       "Iconi"
            }

        Case "No":
            dist := GetPositiveNumber("Enter distance:", "Distance")
            if (dist = "")
                return

            dir := MsgBox("Convert:`n`nYes - mi to km`nNo - km to mi",
                        "Direction",
                        "YesNo")

            if (dir = "Yes") {
                km := dist * 1.60934
                MsgBox Format("{1} mi = {2} km",
                            dist, Round(km, 2)),
                       "Result",
                       "Iconi"
            } else {
                mi := dist / 1.60934
                MsgBox Format("{1} km = {2} mi",
                            dist, Round(mi, 2)),
                       "Result",
                       "Iconi"
            }
    }
}

/**
 * Percentage calculator.
 */
PercentageCalculator() {
    amount := GetValidFloat("Enter amount:", "Percentage")
    if (amount = "")
        return

    percent := GetValidPercentage("Enter percentage:", "Percentage")
    if (percent = "")
        return

    result := amount * (percent / 100)
    MsgBox Format("{1}% of {2} = {3}",
                 percent, amount, Round(result, 2)),
           "Result",
           "Iconi"
}

/**
 * Tip calculator.
 */
TipCalculator() {
    billAmount := GetValidFloat("Enter bill amount:", "Tip Calculator")
    if (billAmount = "")
        return

    tipPercent := GetValidFloat("Enter tip percentage (15, 18, 20):", "Tip %", 0, 100)
    if (tipPercent = "")
        return

    tip := billAmount * (tipPercent / 100)
    total := billAmount + tip

    MsgBox Format("Bill: ${1}`n"
                . "Tip ({2}%): ${3}`n"
                . "Total: ${4}",
                Round(billAmount, 2),
                tipPercent,
                Round(tip, 2),
                Round(total, 2)),
           "Tip Calculation",
           "Iconi"
}

/**
 * Simple loan calculator.
 */
LoanCalculator() {
    principal := GetValidFloat("Enter loan amount:", "Loan Calculator")
    if (principal = "")
        return

    rate := GetValidFloat("Enter annual interest rate (%):", "Interest Rate", 0, 100)
    if (rate = "")
        return

    years := GetValidInteger("Enter loan term (years):", "Loan Term", 1, 30)
    if (years = "")
        return

    ; Simple monthly payment calculation
    monthlyRate := rate / 100 / 12
    months := years * 12
    monthlyPayment := principal * (monthlyRate * (1 + monthlyRate)**months) / ((1 + monthlyRate)**months - 1)

    totalPaid := monthlyPayment * months
    totalInterest := totalPaid - principal

    MsgBox Format("Loan Details:`n`n"
                . "Principal: ${1}`n"
                . "Rate: {2}% annually`n"
                . "Term: {3} years`n`n"
                . "Monthly Payment: ${4}`n"
                . "Total Paid: ${5}`n"
                . "Total Interest: ${6}",
                Round(principal, 2),
                rate,
                years,
                Round(monthlyPayment, 2),
                Round(totalPaid, 2),
                Round(totalInterest, 2)),
           "Loan Calculation",
           "Iconi"
}

/**
 * Helper: Check if array has value.
 */
HasValue(haystack, needle) {
    for value in haystack {
        if (value = needle)
            return true
    }
    return false
}

; ============================================================================
; EXAMPLE 2: Quick Search and Launch
; ============================================================================
/**
 * Creates a quick launcher using InputBox.
 *
 * @description Demonstrates search functionality and application launching.
 */
Example2_QuickLauncher() {
    ; Application launcher
    applications := Map(
        "notepad", "notepad.exe",
        "calc", "calc.exe",
        "paint", "mspaint.exe",
        "cmd", "cmd.exe",
        "explorer", "explorer.exe"
    )

    query := InputBox("Enter application name:`n`n"
                    . "Available: notepad, calc, paint, cmd, explorer",
                    "Quick Launch",
                    "W400").Value

    query := StrLower(query)

    if (applications.Has(query)) {
        MsgBox "Launching: " . query, "Launch", "Iconi T1"
        ; Run applications[query]
    } else {
        MsgBox "Application '" . query . "' not found!", "Error", "Iconx"
    }

    ; Web search launcher
    searchEngine := MsgBox("Select search engine:`n`n"
                          . "Yes - Google`n"
                          . "No - Bing",
                          "Search Engine",
                          "YesNo")

    searchTerm := InputBox("Enter search term:", "Web Search").Value

    if (searchTerm != "") {
        url := (searchEngine = "Yes")
             ? "https://www.google.com/search?q=" . searchTerm
             : "https://www.bing.com/search?q=" . searchTerm

        MsgBox "Opening search for: " . searchTerm, "Search", "Iconi T1"
        ; Run url
    }

    ; File/folder quick access
    location := InputBox("Enter location:`n`n"
                       . "desktop - Open Desktop`n"
                       . "downloads - Open Downloads`n"
                       . "documents - Open Documents`n"
                       . "Or enter custom path",
                       "Quick Access",
                       "W400").Value

    location := StrLower(location)

    Switch location {
        Case "desktop":
            path := A_Desktop
        Case "downloads":
            path := A_MyDocuments . "\..\Downloads"
        Case "documents":
            path := A_MyDocuments
        Default:
            path := location
    }

    if (path != "") {
        MsgBox "Opening: " . path, "Access", "Iconi T1"
        ; Run path
    }
}

; ============================================================================
; EXAMPLE 3: Data Entry Templates
; ============================================================================
/**
 * Creates data entry templates for common tasks.
 *
 * @description Shows structured data collection patterns.
 */
Example3_DataEntryTemplates() {
    ; Meeting notes template
    CollectMeetingNotes()

    ; Task entry template
    CollectTask()

    ; Contact information template
    CollectContact()

    ; Expense entry template
    CollectExpense()
}

/**
 * Collects meeting notes.
 */
CollectMeetingNotes() {
    notes := Map()

    notes["date"] := InputBox("Meeting date:", "Meeting Notes", , FormatTime(, "yyyy-MM-dd")).Value
    if (notes["date"] = "")
        return

    notes["title"] := InputBox("Meeting title:", "Meeting Notes").Value
    if (notes["title"] = "")
        return

    notes["attendees"] := InputBox("Attendees (comma-separated):", "Meeting Notes").Value

    notes["agenda"] := InputBox("Agenda/Topics:", "Meeting Notes", "W500").Value

    notes["notes"] := InputBox("Key notes:", "Meeting Notes", "W500 H150").Value

    notes["action"] := InputBox("Action items:", "Meeting Notes", "W500").Value

    ; Format and display
    output := Format("=== Meeting Notes ===`n`n"
                   . "Date: {1}`n"
                   . "Title: {2}`n"
                   . "Attendees: {3}`n`n"
                   . "Agenda:`n{4}`n`n"
                   . "Notes:`n{5}`n`n"
                   . "Action Items:`n{6}",
                   notes["date"],
                   notes["title"],
                   notes["attendees"],
                   notes["agenda"],
                   notes["notes"],
                   notes["action"])

    MsgBox output, "Meeting Summary", "Iconi"
}

/**
 * Collects task information.
 */
CollectTask() {
    task := Map()

    task["title"] := InputBox("Task title:", "New Task").Value
    if (task["title"] = "")
        return

    task["priority"] := MsgBox("Priority:`n`nYes - High`nNo - Normal`nCancel - Low",
                               "Priority",
                               "YesNoCancel")

    Switch task["priority"] {
        Case "Yes": priorityText := "HIGH"
        Case "No": priorityText := "NORMAL"
        Case "Cancel": priorityText := "LOW"
    }

    task["due"] := InputBox("Due date (YYYY-MM-DD):", "Due Date", , FormatTime(, "yyyy-MM-dd")).Value

    task["notes"] := InputBox("Notes/Details:", "Task Notes", "W500").Value

    output := Format("Task Created:`n`n"
                   . "Title: {1}`n"
                   . "Priority: {2}`n"
                   . "Due: {3}`n"
                   . "Notes: {4}",
                   task["title"],
                   priorityText,
                   task["due"],
                   task["notes"])

    MsgBox output, "Task Summary", "Iconi"
}

/**
 * Collects contact information.
 */
CollectContact() {
    contact := Map()

    contact["name"] := InputBox("Full name:", "New Contact").Value
    if (contact["name"] = "")
        return

    contact["company"] := InputBox("Company (optional):", "New Contact").Value

    contact["email"] := InputBox("Email:", "New Contact").Value

    contact["phone"] := InputBox("Phone:", "New Contact").Value

    contact["notes"] := InputBox("Notes:", "New Contact", "W500").Value

    output := Format("Contact Added:`n`n"
                   . "Name: {1}`n"
                   . "Company: {2}`n"
                   . "Email: {3}`n"
                   . "Phone: {4}`n"
                   . "Notes: {5}",
                   contact["name"],
                   contact["company"],
                   contact["email"],
                   contact["phone"],
                   contact["notes"])

    MsgBox output, "Contact Summary", "Iconi"
}

/**
 * Collects expense information.
 */
CollectExpense() {
    expense := Map()

    expense["date"] := InputBox("Expense date:", "New Expense", , FormatTime(, "yyyy-MM-dd")).Value
    if (expense["date"] = "")
        return

    expense["amount"] := GetCurrencyInput("Amount:", "New Expense")
    if (expense["amount"] = "")
        return

    expense["category"] := InputBox("Category (food, travel, supplies, etc):", "New Expense").Value

    expense["vendor"] := InputBox("Vendor/Merchant:", "New Expense").Value

    expense["notes"] := InputBox("Notes/Description:", "New Expense", "W500").Value

    output := Format("Expense Recorded:`n`n"
                   . "Date: {1}`n"
                   . "Amount: ${2}`n"
                   . "Category: {3}`n"
                   . "Vendor: {4}`n"
                   . "Notes: {5}",
                   expense["date"],
                   Format("{:.2f}", expense["amount"]),
                   expense["category"],
                   expense["vendor"],
                   expense["notes"])

    MsgBox output, "Expense Summary", "Iconi"
}

; ============================================================================
; EXAMPLE 4: Text Processing Utilities
; ============================================================================
/**
 * Text processing utilities using InputBox.
 *
 * @description Demonstrates text manipulation and transformation.
 */
Example4_TextProcessing() {
    ; Text case converter
    text := InputBox("Enter text to convert:", "Case Converter", "W500").Value
    if (text != "") {
        caseType := MsgBox("Convert to:`n`n"
                          . "Yes - UPPERCASE`n"
                          . "No - lowercase`n"
                          . "Cancel - Title Case",
                          "Case Type",
                          "YesNoCancel")

        Switch caseType {
            Case "Yes": result := StrUpper(text)
            Case "No": result := StrLower(text)
            Case "Cancel": result := GetTitleCaseString("", "", text)
        }

        MsgBox "Result:`n`n" . result, "Converted", "Iconi"
    }

    ; Word counter
    text := InputBox("Enter text to analyze:", "Word Counter", "W500 H150").Value
    if (text != "") {
        words := StrSplit(text, [" ", "`n", "`r", "`t"])
        wordCount := 0

        for word in words {
            if (Trim(word) != "")
                wordCount++
        }

        charCount := StrLen(text)
        charNoSpace := StrLen(StrReplace(text, " "))

        MsgBox Format("Text Analysis:`n`n"
                    . "Characters: {1}`n"
                    . "Characters (no spaces): {2}`n"
                    . "Words: {3}",
                    charCount,
                    charNoSpace,
                    wordCount),
               "Analysis",
               "Iconi"
    }

    ; Find and replace
    FindAndReplace()

    ; Text reverser
    text := InputBox("Enter text to reverse:", "Text Reverser").Value
    if (text != "") {
        reversed := ReverseString(text)
        MsgBox Format("Original: {1}`nReversed: {2}", text, reversed),
               "Reversed",
               "Iconi"
    }

    ; Line sorter
    text := InputBox("Enter lines to sort (one per line):", "Line Sorter", "W500 H150").Value
    if (text != "") {
        lines := StrSplit(text, "`n")
        sorted := SortArray(lines)
        result := ""

        for line in sorted {
            result .= Trim(line) . "`n"
        }

        MsgBox "Sorted:`n`n" . result, "Sorted Lines", "Iconi"
    }
}

/**
 * Find and replace text.
 */
FindAndReplace() {
    original := InputBox("Enter original text:", "Find and Replace", "W500 H150").Value
    if (original = "")
        return

    find := InputBox("Find what:", "Find").Value
    if (find = "")
        return

    replace := InputBox("Replace with:", "Replace").Value

    result := StrReplace(original, find, replace, , &count)

    MsgBox Format("Replaced {1} occurrence(s).`n`nResult:`n{2}",
                 count,
                 result),
           "Result",
           "Iconi"
}

/**
 * Reverses a string.
 */
ReverseString(str) {
    result := ""
    Loop Parse str {
        result := A_LoopField . result
    }
    return result
}

/**
 * Sorts an array (simple bubble sort).
 */
SortArray(arr) {
    n := arr.Length
    Loop n - 1 {
        i := A_Index
        Loop n - i {
            j := A_Index
            if (arr[j] > arr[j + 1]) {
                temp := arr[j]
                arr[j] := arr[j + 1]
                arr[j + 1] := temp
            }
        }
    }
    return arr
}

; ============================================================================
; EXAMPLE 5: File and Path Utilities
; ============================================================================
/**
 * File and path utilities using InputBox.
 *
 * @description Demonstrates file path manipulation.
 */
Example5_FilePathUtilities() {
    ; Path validator
    path := InputBox("Enter file/folder path:", "Path Validator", "W500").Value
    if (path != "") {
        if (FileExist(path)) {
            MsgBox "Path exists!", "Valid", "Iconi"
        } else {
            create := MsgBox("Path does not exist.`n`nWould you like to create it?",
                           "Not Found",
                           "YesNo Icon?")
            if (create = "Yes") {
                MsgBox "Would create: " . path, "Create", "Iconi"
                ; DirCreate path or FileAppend "", path
            }
        }
    }

    ; File extension extractor
    fileName := InputBox("Enter filename:", "Extension Extractor").Value
    if (fileName != "") {
        SplitPath fileName, &name, &dir, &ext, &nameNoExt

        MsgBox Format("File: {1}`n"
                    . "Name only: {2}`n"
                    . "Extension: {3}`n"
                    . "Name without ext: {4}`n"
                    . "Directory: {5}",
                    fileName,
                    name,
                    ext,
                    nameNoExt,
                    dir),
               "File Info",
               "Iconi"
    }

    ; Path combiner
    basePath := InputBox("Enter base path:", "Path Combiner").Value
    if (basePath = "")
        return

    fileName := InputBox("Enter filename:", "Path Combiner").Value
    if (fileName != "") {
        combined := basePath . "\" . fileName
        MsgBox "Combined path:`n`n" . combined, "Result", "Iconi"
    }

    ; File renamer (simulation)
    currentName := InputBox("Current filename:", "Rename File").Value
    if (currentName = "")
        return

    newName := InputBox("New filename:", "Rename File", , currentName).Value
    if (newName != "" && newName != currentName) {
        MsgBox Format("Rename:`n`n{1}`n↓`n{2}", currentName, newName),
               "Rename Preview",
               "Iconi"
    }
}

; ============================================================================
; EXAMPLE 6: Configuration Builder
; ============================================================================
/**
 * Interactive configuration builder.
 *
 * @description Creates configuration files from user input.
 */
Example6_ConfigurationBuilder() {
    config := Map()

    MsgBox "Configuration Builder`n`nLet's create your configuration file.",
           "Welcome",
           "Iconi"

    ; Server configuration
    config["server_host"] := InputBox("Server host:", "Server Config", , "localhost").Value
    config["server_port"] := GetValidInteger("Server port:", "Server Config", 1024, 65535)

    ; Database configuration
    config["db_host"] := InputBox("Database host:", "Database Config", , "localhost").Value
    config["db_name"] := InputBox("Database name:", "Database Config").Value
    config["db_user"] := InputBox("Database user:", "Database Config").Value
    config["db_pass"] := InputBox("Database password:", "Database Config", "Password").Value

    ; Application settings
    config["app_name"] := InputBox("Application name:", "App Config").Value
    config["app_env"] := MsgBox("Environment:`n`nYes - Production`nNo - Development",
                                "Environment",
                                "YesNo")
    config["app_env"] := (config["app_env"] = "Yes") ? "production" : "development"

    config["debug"] := MsgBox("Enable debug mode?", "Debug", "YesNo")
    config["debug"] := (config["debug"] = "Yes") ? "true" : "false"

    ; Generate configuration output
    output := "; Configuration File`n"
            . "; Generated: " . FormatTime(, "yyyy-MM-dd HH:mm:ss") . "`n`n"

    output .= "[Server]`n"
    output .= "host = " . config["server_host"] . "`n"
    output .= "port = " . config["server_port"] . "`n`n"

    output .= "[Database]`n"
    output .= "host = " . config["db_host"] . "`n"
    output .= "name = " . config["db_name"] . "`n"
    output .= "user = " . config["db_user"] . "`n"
    output .= "password = ********`n`n"

    output .= "[Application]`n"
    output .= "name = " . config["app_name"] . "`n"
    output .= "environment = " . config["app_env"] . "`n"
    output .= "debug = " . config["debug"] . "`n"

    MsgBox output, "Configuration Preview", "Iconi"

    save := MsgBox("Save configuration?", "Save", "YesNo")
    if (save = "Yes") {
        fileName := InputBox("Enter filename:", "Save Config", , "config.ini").Value
        if (fileName != "") {
            MsgBox "Configuration saved to: " . fileName, "Saved", "Iconi"
            ; FileAppend output, fileName
        }
    }
}

; ============================================================================
; EXAMPLE 7: Batch Operations with Progress
; ============================================================================
/**
 * Batch operations with user input.
 *
 * @description Shows batch processing patterns.
 */
Example7_BatchOperations() {
    ; Batch file renaming
    BatchFileRename()

    ; Bulk URL generator
    BulkURLGenerator()

    ; Serial number generator
    SerialNumberGenerator()
}

/**
 * Simulates batch file renaming.
 */
BatchFileRename() {
    prefix := InputBox("Enter prefix for files:", "Batch Rename").Value
    if (prefix = "")
        return

    fileCount := GetValidInteger("How many files:", "Batch Rename", 1, 100)
    if (fileCount = "")
        return

    extension := InputBox("File extension:", "Batch Rename", , "txt").Value

    preview := "Preview:`n`n"
    Loop fileCount {
        fileName := Format("{1}_{2:03}.{3}", prefix, A_Index, extension)
        preview .= fileName . "`n"

        if (A_Index = 10 && fileCount > 10) {
            preview .= "... and " . (fileCount - 10) . " more`n"
            break
        }
    }

    MsgBox preview, "Batch Rename Preview", "Iconi"
}

/**
 * Generates multiple URLs.
 */
BulkURLGenerator() {
    baseURL := InputBox("Enter base URL:", "URL Generator", , "https://example.com/page").Value
    if (baseURL = "")
        return

    count := GetValidInteger("How many URLs:", "URL Generator", 1, 50)
    if (count = "")
        return

    urls := ""
    Loop count {
        url := baseURL . A_Index
        urls .= url . "`n"
    }

    MsgBox urls, "Generated URLs", "Iconi"
}

/**
 * Generates serial numbers.
 */
SerialNumberGenerator() {
    prefix := InputBox("Enter prefix (e.g., SN):", "Serial Generator", , "SN").Value

    count := GetValidInteger("How many serial numbers:", "Serial Generator", 1, 100)
    if (count = "")
        return

    startNum := GetValidInteger("Starting number:", "Serial Generator", 1, 99999, 1)
    if (startNum = "")
        return

    serials := ""
    Loop count {
        serial := Format("{1}-{2:05}", prefix, startNum + A_Index - 1)
        serials .= serial . "`n"

        if (A_Index = 20 && count > 20) {
            serials .= "... and " . (count - 20) . " more`n"
            break
        }
    }

    MsgBox serials, "Generated Serial Numbers", "Iconi"
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1::Example1_InteractiveCalculator()
^2::Example2_QuickLauncher()
^3::Example3_DataEntryTemplates()
^4::Example4_TextProcessing()
^5::Example5_FilePathUtilities()
^6::Example6_ConfigurationBuilder()
^7::Example7_BatchOperations()
^0::ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 *
 * Practical InputBox applications:
 * 1. Interactive calculators (basic, unit conversion, financial)
 * 2. Quick search and launch utilities
 * 3. Data entry templates (meetings, tasks, contacts, expenses)
 * 4. Text processing utilities (case conversion, word count, find/replace)
 * 5. File and path utilities (validation, manipulation)
 * 6. Configuration builders and generators
 * 7. Batch operations (file renaming, URL generation, serial numbers)
 *
 * ============================================================================
 */
