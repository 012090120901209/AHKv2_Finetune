#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * InputBox Basic Examples - Part 1
 * ============================================================================
 *
 * Comprehensive examples demonstrating basic InputBox usage in AutoHotkey v2.
 *
 * @description This file covers fundamental InputBox functionality including:
 *              - Simple text input collection
 *              - Password input with masking
 *              - Default values and prompts
 *              - Input validation
 *              - Error handling
 *
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/InputBox.htm
 *
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Basic Text Input
; ============================================================================
/**
 * Demonstrates simple text input collection.
 *
 * @description Shows how to collect basic text input from users
 *              and handle the returned value.
 *
 * @returns {Object} Object with Value and Result properties
 */
Example1_BasicTextInput() {
    ; Simple input request
    ib := InputBox("Enter your name:", "Name Input")

    if (ib.Result = "OK") {
        MsgBox "Hello, " . ib.Value . "!"
    } else {
        MsgBox "Input was cancelled."
    }

    ; Input with longer prompt
    ib := InputBox("Please enter the path to your documents folder:`n`n"
                 . "Example: C:\Users\YourName\Documents",
                 "Path Input")

    if (ib.Result = "OK" && ib.Value != "") {
        MsgBox "Path entered: " . ib.Value
    } else {
        MsgBox "No path was entered."
    }

    ; Multiple sequential inputs
    name := InputBox("Enter your first name:", "Step 1 of 3").Value
    if (name = "") {
        MsgBox "Setup cancelled."
        return
    }

    email := InputBox("Enter your email:", "Step 2 of 3").Value
    if (email = "") {
        MsgBox "Setup cancelled."
        return
    }

    phone := InputBox("Enter your phone number:", "Step 3 of 3").Value
    if (phone = "") {
        MsgBox "Setup cancelled."
        return
    }

    ; Show collected data
    MsgBox Format("Information collected:`n`n"
                . "Name: {1}`n"
                . "Email: {2}`n"
                . "Phone: {3}",
                name, email, phone),
           "Registration Complete"

    ; Empty input handling
    ib := InputBox("Enter a description (optional):", "Optional Input")

    if (ib.Result = "OK") {
        if (ib.Value = "")
            MsgBox "No description provided."
        else
            MsgBox "Description: " . ib.Value
    }

    ; Immediate use of input
    searchTerm := InputBox("Enter search term:", "Search").Value
    if (searchTerm != "") {
        MsgBox "Searching for: " . searchTerm . "`n`nPlease wait..."
        ; Perform search operation
    }
}

; ============================================================================
; EXAMPLE 2: Default Values
; ============================================================================
/**
 * Shows how to use default values in InputBox.
 *
 * @description Demonstrates pre-filling input fields with default
 *              values for user convenience.
 */
Example2_DefaultValues() {
    ; Simple default value
    ib := InputBox("Enter your country:", "Location", , "United States")

    if (ib.Result = "OK") {
        MsgBox "Country: " . ib.Value
    }

    ; Default from variable
    userName := "JohnDoe"
    ib := InputBox("Confirm your username:", "Username", , userName)

    if (ib.Result = "OK") {
        if (ib.Value = userName)
            MsgBox "Username confirmed."
        else
            MsgBox "Username changed to: " . ib.Value
    }

    ; Default current date/time
    currentDate := FormatTime(, "yyyy-MM-dd")
    ib := InputBox("Enter date:", "Date Input", , currentDate)

    if (ib.Result = "OK") {
        MsgBox "Date selected: " . ib.Value
    }

    ; Default calculated value
    quantity := 10
    unitPrice := 29.99
    total := quantity * unitPrice

    ib := InputBox("Enter total amount:", "Payment", , Format("{1:.2f}", total))

    if (ib.Result = "OK") {
        MsgBox "Amount: $" . ib.Value
    }

    ; Default from configuration
    defaultLanguage := "English"
    defaultTheme := "Light"

    language := InputBox("Select language:", "Language", , defaultLanguage).Value
    theme := InputBox("Select theme:", "Theme", , defaultTheme).Value

    MsgBox Format("Settings:`n`nLanguage: {1}`nTheme: {2}",
                 language, theme)

    ; Incremental default values
    basePort := 8080
    portNumber := InputBox("Enter port number:", "Port Configuration", , basePort).Value

    if (portNumber = "")
        portNumber := basePort

    MsgBox "Using port: " . portNumber
}

; ============================================================================
; EXAMPLE 3: Password Input
; ============================================================================
/**
 * Demonstrates password input with character masking.
 *
 * @description Shows how to securely collect passwords and sensitive
 *              information using the Password option.
 */
Example3_PasswordInput() {
    ; Basic password input
    ib := InputBox("Enter your password:", "Login", "Password")

    if (ib.Result = "OK") {
        if (ib.Value != "")
            MsgBox "Password accepted (length: " . StrLen(ib.Value) . " characters)"
        else
            MsgBox "Password cannot be empty!"
    }

    ; Password with confirmation
    password1 := InputBox("Create a password:", "New Password", "Password").Value

    if (password1 = "") {
        MsgBox "Password creation cancelled."
        return
    }

    password2 := InputBox("Confirm your password:", "Confirm Password", "Password").Value

    if (password1 = password2) {
        MsgBox "Password created successfully!`n`nLength: " . StrLen(password1) . " characters"
    } else {
        MsgBox "Passwords do not match!", "Error", "Iconx"
    }

    ; Password with validation
    Loop {
        pwd := InputBox("Enter password (min 8 characters):", "Password", "Password").Value

        if (pwd = "") {
            MsgBox "Password creation cancelled."
            break
        }

        if (StrLen(pwd) < 8) {
            retry := MsgBox("Password too short!`n`nMinimum length: 8 characters`nYour length: "
                          . StrLen(pwd) . "`n`nTry again?",
                          "Validation Error",
                          "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        MsgBox "Password meets requirements."
        break
    }

    ; PIN input
    pin := InputBox("Enter 4-digit PIN:", "Security PIN", "Password").Value

    if (RegExMatch(pin, "^\d{4}$")) {
        MsgBox "PIN accepted."
    } else {
        MsgBox "Invalid PIN! Must be exactly 4 digits.", "Error", "Iconx"
    }

    ; API key input
    apiKey := InputBox("Enter your API key:", "API Configuration", "Password").Value

    if (apiKey != "") {
        ; Mask the key in display
        maskedKey := SubStr(apiKey, 1, 4) . "****" . SubStr(apiKey, -4)
        MsgBox "API Key saved: " . maskedKey
    }

    ; Multi-factor authentication
    username := InputBox("Enter username:", "Login").Value
    password := InputBox("Enter password:", "Login", "Password").Value
    code := InputBox("Enter 2FA code:", "Two-Factor Auth", "Password").Value

    if (username != "" && password != "" && code != "") {
        MsgBox "Authentication successful!`n`nUser: " . username
    } else {
        MsgBox "Authentication failed - missing credentials.", "Error", "Iconx"
    }
}

; ============================================================================
; EXAMPLE 4: Input Dimensions and Positioning
; ============================================================================
/**
 * Shows InputBox size and position customization.
 *
 * @description Demonstrates controlling InputBox dimensions.
 *
 * Syntax: InputBox(Prompt, Title, Options, Default)
 * Width and Height are specified in the Options parameter.
 */
Example4_DimensionsAndPositioning() {
    ; Standard width (default)
    ib := InputBox("Enter a short text:", "Normal Input")
    if (ib.Result = "OK")
        MsgBox "Input: " . ib.Value

    ; Wide input box for longer text
    ib := InputBox("Enter a long description or paragraph:", "Wide Input", "W500")
    if (ib.Result = "OK")
        MsgBox "Input: " . ib.Value

    ; Tall input box (note: InputBox doesn't support multi-line)
    ib := InputBox("Enter your comment:", "Tall Input", "H200")
    if (ib.Result = "OK")
        MsgBox "Comment: " . ib.Value

    ; Custom dimensions
    ib := InputBox("Enter data:", "Custom Size", "W400 H150")
    if (ib.Result = "OK")
        MsgBox "Data: " . ib.Value

    ; Password with custom width
    ib := InputBox("Enter password:", "Login", "Password W350")
    if (ib.Result = "OK")
        MsgBox "Password length: " . StrLen(ib.Value)

    ; Narrow input for short codes
    code := InputBox("Enter code:", "Activation", "W200").Value
    if (code != "")
        MsgBox "Code: " . code
}

; ============================================================================
; EXAMPLE 5: Input Validation Patterns
; ============================================================================
/**
 * Demonstrates common input validation patterns.
 *
 * @description Shows how to validate various input formats including
 *              numbers, emails, URLs, and custom patterns.
 */
Example5_ValidationPatterns() {
    ; Numeric input validation
    Loop {
        ib := InputBox("Enter your age (1-120):", "Age Input")

        if (ib.Result = "Cancel")
            break

        age := ib.Value

        if (!IsNumber(age)) {
            MsgBox "Please enter a valid number!", "Error", "Iconx"
            continue
        }

        age := Integer(age)

        if (age < 1 || age > 120) {
            MsgBox "Age must be between 1 and 120!", "Error", "Iconx"
            continue
        }

        MsgBox "Age accepted: " . age
        break
    }

    ; Email validation
    Loop {
        email := InputBox("Enter your email address:", "Email").Value

        if (email = "")
            break

        if (!RegExMatch(email, "^[\w\.-]+@[\w\.-]+\.\w{2,}$")) {
            retry := MsgBox("Invalid email format!`n`nExample: user@example.com`n`nTry again?",
                          "Validation Error",
                          "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        MsgBox "Email accepted: " . email
        break
    }

    ; URL validation
    Loop {
        url := InputBox("Enter website URL:", "URL Input").Value

        if (url = "")
            break

        if (!RegExMatch(url, "^https?://[\w\.-]+\.\w{2,}")) {
            retry := MsgBox("Invalid URL format!`n`nExample: https://www.example.com`n`nTry again?",
                          "Validation Error",
                          "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        MsgBox "URL accepted: " . url
        break
    }

    ; Phone number validation
    Loop {
        phone := InputBox("Enter phone number (10 digits):", "Phone").Value

        if (phone = "")
            break

        ; Remove common separators
        cleanPhone := StrReplace(phone, "-")
        cleanPhone := StrReplace(cleanPhone, " ")
        cleanPhone := StrReplace(cleanPhone, "(")
        cleanPhone := StrReplace(cleanPhone, ")")

        if (!RegExMatch(cleanPhone, "^\d{10}$")) {
            retry := MsgBox("Invalid phone number!`n`nPlease enter 10 digits.`n`nTry again?",
                          "Validation Error",
                          "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        MsgBox "Phone accepted: " . phone
        break
    }

    ; ZIP code validation
    Loop {
        zip := InputBox("Enter ZIP code:", "ZIP Code").Value

        if (zip = "")
            break

        if (!RegExMatch(zip, "^\d{5}(-\d{4})?$")) {
            retry := MsgBox("Invalid ZIP code!`n`nFormat: 12345 or 12345-6789`n`nTry again?",
                          "Validation Error",
                          "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        MsgBox "ZIP code accepted: " . zip
        break
    }

    ; Date validation (YYYY-MM-DD)
    Loop {
        dateStr := InputBox("Enter date (YYYY-MM-DD):", "Date", , FormatTime(, "yyyy-MM-dd")).Value

        if (dateStr = "")
            break

        if (!RegExMatch(dateStr, "^\d{4}-\d{2}-\d{2}$")) {
            retry := MsgBox("Invalid date format!`n`nFormat: YYYY-MM-DD`nExample: 2024-01-15`n`nTry again?",
                          "Validation Error",
                          "RetryCancel Iconx")
            if (retry = "Cancel")
                break
            continue
        }

        MsgBox "Date accepted: " . dateStr
        break
    }
}

; ============================================================================
; EXAMPLE 6: Error Handling and Edge Cases
; ============================================================================
/**
 * Shows proper error handling with InputBox.
 *
 * @description Demonstrates handling cancellation, empty input,
 *              and other edge cases.
 */
Example6_ErrorHandling() {
    ; Handle cancellation gracefully
    ib := InputBox("Enter project name:", "New Project")

    if (ib.Result = "Cancel") {
        MsgBox "Project creation cancelled by user.", "Cancelled", "Iconi"
        return
    }

    if (ib.Value = "") {
        MsgBox "Project name cannot be empty!", "Error", "Iconx"
        return
    }

    MsgBox "Project '" . ib.Value . "' created successfully!"

    ; Empty input with default fallback
    ib := InputBox("Enter server name (or leave blank for default):", "Server")

    serverName := (ib.Value = "") ? "localhost" : ib.Value
    MsgBox "Connecting to: " . serverName

    ; Required vs Optional input
    requiredField := InputBox("Enter username (required):", "Login").Value

    if (requiredField = "") {
        MsgBox "Username is required to continue!", "Error", "Iconx"
        return
    }

    optionalField := InputBox("Enter middle name (optional):", "Profile").Value

    if (optionalField = "")
        MsgBox "Middle name skipped."
    else
        MsgBox "Middle name: " . optionalField

    ; Maximum attempts with retry
    maxAttempts := 3
    attempts := 0

    Loop {
        attempts++

        ib := InputBox(Format("Enter access code (Attempt {1}/{2}):", attempts, maxAttempts),
                      "Access Code",
                      "Password")

        if (ib.Result = "Cancel") {
            MsgBox "Access denied - cancelled by user.", "Access Denied", "Iconx"
            break
        }

        if (ib.Value = "SECRET123") {
            MsgBox "Access granted!", "Success", "Iconi"
            break
        }

        if (attempts >= maxAttempts) {
            MsgBox "Access denied - maximum attempts exceeded!", "Access Denied", "Iconx"
            break
        }

        MsgBox "Incorrect code. Try again.", "Error", "Iconx"
    }

    ; Timeout simulation (user has limited time)
    MsgBox "You have 10 seconds to enter the code in the next dialog.", "Warning", "Icon!"

    ; In practice, you'd use SetTimer for actual timeout
    ib := InputBox("Enter code quickly:", "Quick Input")

    if (ib.Result = "OK") {
        MsgBox "Code entered: " . ib.Value
    } else {
        MsgBox "Timeout or cancelled.", "Error", "Iconx"
    }
}

; ============================================================================
; EXAMPLE 7: Practical Application Scenarios
; ============================================================================
/**
 * Real-world scenarios using InputBox.
 *
 * @description Practical examples showing common use cases.
 */
Example7_PracticalScenarios() {
    ; Scenario 1: Quick note taking
    note := InputBox("Quick note:", "Note Taker", "W500").Value

    if (note != "") {
        timestamp := FormatTime(, "yyyy-MM-dd HH:mm:ss")
        MsgBox "Note saved:`n`n[" . timestamp . "]`n" . note
        ; In practice: FileAppend timestamp . " - " . note . "`n", "notes.txt"
    }

    ; Scenario 2: Search and replace
    searchTerm := InputBox("Find text:", "Find and Replace").Value
    if (searchTerm = "")
        return

    replaceTerm := InputBox("Replace with:", "Find and Replace", , searchTerm).Value

    MsgBox Format("Replace all '{1}' with '{2}'?", searchTerm, replaceTerm),
           "Confirm", "YesNo"

    ; Scenario 3: File renaming
    currentName := "document.txt"
    newName := InputBox("Enter new filename:", "Rename File", , currentName).Value

    if (newName != "" && newName != currentName) {
        MsgBox Format("Rename '{1}' to '{2}'", currentName, newName)
        ; In practice: FileMove currentName, newName
    }

    ; Scenario 4: Calculation input
    num1 := InputBox("Enter first number:", "Calculator").Value
    if (!IsNumber(num1))
        return

    num2 := InputBox("Enter second number:", "Calculator").Value
    if (!IsNumber(num2))
        return

    result := Float(num1) + Float(num2)
    MsgBox Format("{1} + {2} = {3}", num1, num2, result)

    ; Scenario 5: Configuration update
    currentPort := 8080
    newPort := InputBox("Enter port number:", "Server Config", , currentPort).Value

    if (IsNumber(newPort)) {
        portNum := Integer(newPort)
        if (portNum >= 1024 && portNum <= 65535) {
            MsgBox "Port updated to: " . portNum
            ; Update configuration
        } else {
            MsgBox "Port must be between 1024 and 65535!", "Error", "Iconx"
        }
    }

    ; Scenario 6: API endpoint configuration
    apiBase := "https://api.example.com"
    endpoint := InputBox("Enter API endpoint:", "API Config", , "/v1/users").Value

    if (endpoint != "") {
        fullUrl := apiBase . endpoint
        MsgBox "Full URL: " . fullUrl
    }

    ; Scenario 7: Batch naming
    baseName := InputBox("Enter base name for files:", "Batch Naming").Value

    if (baseName != "") {
        Loop 5 {
            fileName := baseName . "_" . A_Index . ".txt"
            MsgBox "File " . A_Index . ": " . fileName, "Preview", "T1"
        }
        MsgBox "5 files would be created with base name: " . baseName
    }
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1::Example1_BasicTextInput()
^2::Example2_DefaultValues()
^3::Example3_PasswordInput()
^4::Example4_DimensionsAndPositioning()
^5::Example5_ValidationPatterns()
^6::Example6_ErrorHandling()
^7::Example7_PracticalScenarios()
^0::ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 *
 * InputBox fundamentals covered:
 * 1. Basic text input collection and value handling
 * 2. Default values for pre-filled inputs
 * 3. Password input with character masking
 * 4. Dimensions and positioning customization
 * 5. Input validation patterns (numbers, email, URL, phone, etc.)
 * 6. Error handling and edge cases
 * 7. Practical real-world application scenarios
 *
 * Key Points:
 * - InputBox returns an object with Value and Result properties
 * - Result can be "OK" or "Cancel"
 * - Password option masks input characters
 * - Always validate user input
 * - Handle cancellation gracefully
 * - Provide meaningful prompts and defaults
 *
 * ============================================================================
 */
