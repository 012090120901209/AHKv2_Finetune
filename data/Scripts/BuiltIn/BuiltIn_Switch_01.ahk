#Requires AutoHotkey v2.0
#Include JSON.ahk

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Basic Switch Statements
 * ============================================================================
 * 
 * This script demonstrates basic switch statement usage in AutoHotkey v2.
 * It covers simple case matching, default clauses, and when to use switch
 * versus if/else chains.
 * 
 * @file BuiltIn_Switch_01.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples included:
 * 1. Basic switch statement syntax
 * 2. Switch with string matching
 * 3. Switch with numeric values
 * 4. Default case handling
 * 5. Switch vs if/else performance
 * 6. Multiple statements per case
 * 7. Real-world switch applications
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Basic Switch Statement Syntax
; ============================================================================

/**
 * Demonstrates fundamental switch statement structure.
 * Shows basic case matching and default handling.
 */
Example1_BasicSwitchSyntax() {
    OutputDebug("=== Example 1: Basic Switch Syntax ===`n")

    ; Simple switch with strings
    dayOfWeek := "Monday"

    switch dayOfWeek {
        case "Monday":
            OutputDebug("Start of the work week`n")
        case "Friday":
            OutputDebug("Almost weekend!`n")
        case "Saturday", "Sunday":
            OutputDebug("Weekend! Time to relax`n")
        default:
            OutputDebug("Middle of the week: " dayOfWeek "`n")
    }

    ; Switch with numeric values
    priority := 2

    switch priority {
        case 1:
            OutputDebug("Priority: Critical - Immediate action required`n")
        case 2:
            OutputDebug("Priority: High - Address today`n")
        case 3:
            OutputDebug("Priority: Medium - This week`n")
        case 4:
            OutputDebug("Priority: Low - When possible`n")
        default:
            OutputDebug("Priority: Unknown level`n")
    }

    ; Switch with variable assignment
    status := "active"
    message := ""

    switch status {
        case "active":
            message := "Account is active"
        case "pending":
            message := "Account activation pending"
        case "suspended":
            message := "Account temporarily suspended"
        case "closed":
            message := "Account is closed"
        default:
            message := "Unknown account status"
    }

    OutputDebug("Status message: " message "`n")

    ; Switch with return values (in function)
    result := GetStatusColor("warning")
    OutputDebug("Status color: " result "`n")

    OutputDebug("`n")
}

/**
 * Function using switch to return values.
 */
GetStatusColor(status) {
    switch status {
        case "success":
            return "green"
        case "warning":
            return "yellow"
        case "error":
            return "red"
        case "info":
            return "blue"
        default:
            return "gray"
    }
}

; ============================================================================
; Example 2: Switch with String Matching
; ============================================================================

/**
 * Demonstrates switch statements for string-based decisions.
 * Shows case-insensitive matching and string patterns.
 */
Example2_StringMatching() {
    OutputDebug("=== Example 2: String Matching ===`n")

    ; File extension handling
    fileName := "document.pdf"
    extension := SubStr(fileName, InStr(fileName, ".", , -1))

    switch extension {
        case ".txt":
            OutputDebug("Text file - Open in editor`n")
            fileType := "text"
        case ".pdf":
            OutputDebug("PDF file - Open in PDF reader`n")
            fileType := "document"
        case ".jpg", ".png", ".gif":
            OutputDebug("Image file - Open in image viewer`n")
            fileType := "image"
        case ".mp3", ".wav", ".flac":
            OutputDebug("Audio file - Open in media player`n")
            fileType := "audio"
        case ".mp4", ".avi", ".mkv":
            OutputDebug("Video file - Open in video player`n")
            fileType := "video"
        default:
            OutputDebug("Unknown file type: " extension "`n")
            fileType := "unknown"
    }

    ; HTTP status code interpretation
    statusCode := "404"

    switch statusCode {
        case "200":
            OutputDebug("OK - Request successful`n")
        case "201":
            OutputDebug("Created - Resource created`n")
        case "301":
            OutputDebug("Moved Permanently`n")
        case "400":
            OutputDebug("Bad Request - Client error`n")
        case "401":
            OutputDebug("Unauthorized - Authentication required`n")
        case "403":
            OutputDebug("Forbidden - Access denied`n")
        case "404":
            OutputDebug("Not Found - Resource not found`n")
        case "500":
            OutputDebug("Internal Server Error`n")
        default:
            OutputDebug("HTTP Status: " statusCode "`n")
    }

    ; Command parser
    command := "save"

    switch command {
        case "new":
            OutputDebug("Creating new document...`n")
        case "open":
            OutputDebug("Opening file dialog...`n")
        case "save":
            OutputDebug("Saving current document...`n")
        case "saveas":
            OutputDebug("Save as dialog...`n")
        case "print":
            OutputDebug("Printing document...`n")
        case "exit", "quit":
            OutputDebug("Exiting application...`n")
        default:
            OutputDebug("Unknown command: " command "`n")
    }

    ; User role permissions
    userRole := "editor"

    switch userRole {
        case "admin":
            OutputDebug("Full access granted`n")
            canRead := true
            canWrite := true
            canDelete := true
        case "editor":
            OutputDebug("Edit access granted`n")
            canRead := true
            canWrite := true
            canDelete := false
        case "viewer":
            OutputDebug("Read-only access`n")
            canRead := true
            canWrite := false
            canDelete := false
        default:
            OutputDebug("No access`n")
            canRead := false
            canWrite := false
            canDelete := false
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Switch with Numeric Values
; ============================================================================

/**
 * Demonstrates switch statements with numbers.
 * Shows integer matching and numeric ranges.
 */
Example3_NumericValues() {
    OutputDebug("=== Example 3: Numeric Values ===`n")

    ; Menu selection
    menuChoice := 3

    switch menuChoice {
        case 1:
            OutputDebug("Selected: New Project`n")
        case 2:
            OutputDebug("Selected: Open Project`n")
        case 3:
            OutputDebug("Selected: Save Project`n")
        case 4:
            OutputDebug("Selected: Settings`n")
        case 5:
            OutputDebug("Selected: Exit`n")
        default:
            OutputDebug("Invalid menu selection`n")
    }

    ; Grade conversion
    score := 85
    grade := ""

    ; Note: Switch doesn't do ranges directly, but we can use it with calculated values
    gradeLevel := (score >= 90) ? 5 : (score >= 80) ? 4 : (score >= 70) ? 3 : (score >= 60) ? 2 : 1

    switch gradeLevel {
        case 5:
            grade := "A"
        case 4:
            grade := "B"
        case 3:
            grade := "C"
        case 2:
            grade := "D"
        case 1:
            grade := "F"
    }

    OutputDebug("Score " score " = Grade " grade "`n")

    ; Error code handling
    errorCode := 2

    switch errorCode {
        case 0:
            OutputDebug("No error`n")
        case 1:
            OutputDebug("Error: File not found`n")
        case 2:
            OutputDebug("Error: Access denied`n")
        case 3:
            OutputDebug("Error: Invalid format`n")
        case 4:
            OutputDebug("Error: Network timeout`n")
        default:
            OutputDebug("Error: Unknown error code " errorCode "`n")
    }

    ; Month name from number
    monthNum := 7

    switch monthNum {
        case 1:
            monthName := "January"
        case 2:
            monthName := "February"
        case 3:
            monthName := "March"
        case 4:
            monthName := "April"
        case 5:
            monthName := "May"
        case 6:
            monthName := "June"
        case 7:
            monthName := "July"
        case 8:
            monthName := "August"
        case 9:
            monthName := "September"
        case 10:
            monthName := "October"
        case 11:
            monthName := "November"
        case 12:
            monthName := "December"
        default:
            monthName := "Invalid month"
    }

    OutputDebug("Month " monthNum " = " monthName "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Default Case Handling
; ============================================================================

/**
 * Demonstrates proper use of default cases.
 * Shows when and why to include default handling.
 */
Example4_DefaultCaseHandling() {
    OutputDebug("=== Example 4: Default Case Handling ===`n")

    ; Always include default for user input
    userInput := "unknown_command"

    switch userInput {
        case "start":
            OutputDebug("Starting service...`n")
        case "stop":
            OutputDebug("Stopping service...`n")
        case "restart":
            OutputDebug("Restarting service...`n")
        default:
            OutputDebug("Error: Unknown command '" userInput "'`n")
            OutputDebug("Valid commands: start, stop, restart`n")
    }

    ; Default for validation
    direction := "diagonal"

    switch direction {
        case "up", "down", "left", "right":
            OutputDebug("Valid direction: " direction "`n")
            isValid := true
        default:
            OutputDebug("Invalid direction: " direction "`n")
            isValid := false
    }

    ; Default with logging
    operation := "delete_all"

    switch operation {
        case "read":
            OutputDebug("Performing read operation`n")
        case "write":
            OutputDebug("Performing write operation`n")
        case "update":
            OutputDebug("Performing update operation`n")
        default:
            OutputDebug("WARNING: Unrecognized operation '" operation "'`n")
            LogUnknownOperation(operation)
    }

    ; Default with fallback behavior
    theme := "custom"

    switch theme {
        case "light":
            backgroundColor := "white"
            textColor := "black"
        case "dark":
            backgroundColor := "black"
            textColor := "white"
        case "blue":
            backgroundColor := "navy"
            textColor := "white"
        default:
            OutputDebug("Unknown theme '" theme "', using default`n")
            backgroundColor := "white"
            textColor := "black"
    }

    OutputDebug("Theme colors - BG: " backgroundColor ", Text: " textColor "`n")

    OutputDebug("`n")
}

/**
 * Helper function to log unknown operations.
 */
LogUnknownOperation(operation) {
    OutputDebug("  [LOG] Unknown operation logged: " operation "`n")
}

; ============================================================================
; Example 5: Switch vs If/Else Performance
; ============================================================================

/**
 * Demonstrates when to use switch vs if/else.
 * Shows readability and performance considerations.
 */
Example5_SwitchVsIfElse() {
    OutputDebug("=== Example 5: Switch vs If/Else ===`n")

    value := "option2"

    ; Using if/else chain (less readable for many options)
    OutputDebug("--- Using If/Else ---`n")
    if (value = "option1") {
        OutputDebug("Selected option 1`n")
    } else if (value = "option2") {
        OutputDebug("Selected option 2`n")
    } else if (value = "option3") {
        OutputDebug("Selected option 3`n")
    } else if (value = "option4") {
        OutputDebug("Selected option 4`n")
    } else {
        OutputDebug("Unknown option`n")
    }

    ; Using switch (more readable for many options)
    OutputDebug("`n--- Using Switch ---`n")
    switch value {
        case "option1":
            OutputDebug("Selected option 1`n")
        case "option2":
            OutputDebug("Selected option 2`n")
        case "option3":
            OutputDebug("Selected option 3`n")
        case "option4":
            OutputDebug("Selected option 4`n")
        default:
            OutputDebug("Unknown option`n")
    }

    ; When if/else is better (complex conditions)
    age := 25
    income := 50000

    OutputDebug("`n--- If/Else Better for Complex Conditions ---`n")
    if (age >= 18 and age <= 25) {
        OutputDebug("Young adult category`n")
    } else if (age > 25 and income >= 40000) {
        OutputDebug("Professional category`n")
    } else if (age >= 65) {
        OutputDebug("Senior category`n")
    } else {
        OutputDebug("General category`n")
    }

    ; Switch better for exact matching
    OutputDebug("`n--- Switch Better for Exact Matching ---`n")
    productCode := "PRD-B"

    switch productCode {
        case "PRD-A":
            price := 29.99
        case "PRD-B":
            price := 49.99
        case "PRD-C":
            price := 79.99
        case "PRD-D":
            price := 99.99
        default:
            price := 0
    }

    OutputDebug("Product " productCode " price: $" price "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Multiple Statements Per Case
; ============================================================================

/**
 * Demonstrates executing multiple statements in each case.
 * Shows complex logic within case blocks.
 */
Example6_MultipleStatements() {
    OutputDebug("=== Example 6: Multiple Statements Per Case ===`n")

    ; Complex case handling
    accountType := "premium"

    switch accountType {
        case "free":
            maxStorage := 5
            maxUsers := 1
            features := "Basic"
            monthlyCost := 0
            OutputDebug("Account: Free Tier`n")
            OutputDebug("  Storage: " maxStorage "GB`n")
            OutputDebug("  Users: " maxUsers "`n")
            OutputDebug("  Features: " features "`n")
            OutputDebug("  Cost: $" monthlyCost "/month`n")

        case "standard":
            maxStorage := 50
            maxUsers := 5
            features := "Standard + Priority Support"
            monthlyCost := 9.99
            OutputDebug("Account: Standard Tier`n")
            OutputDebug("  Storage: " maxStorage "GB`n")
            OutputDebug("  Users: " maxUsers "`n")
            OutputDebug("  Features: " features "`n")
            OutputDebug("  Cost: $" monthlyCost "/month`n")

        case "premium":
            maxStorage := 500
            maxUsers := 25
            features := "All Features + 24/7 Support"
            monthlyCost := 29.99
            discount := 0.10
            OutputDebug("Account: Premium Tier`n")
            OutputDebug("  Storage: " maxStorage "GB`n")
            OutputDebug("  Users: " maxUsers "`n")
            OutputDebug("  Features: " features "`n")
            OutputDebug("  Cost: $" monthlyCost "/month`n")
            OutputDebug("  Annual discount: " (discount * 100) "%`n")

        case "enterprise":
            maxStorage := "Unlimited"
            maxUsers := "Unlimited"
            features := "Custom Features + Dedicated Support"
            monthlyCost := "Custom"
            OutputDebug("Account: Enterprise Tier`n")
            OutputDebug("  Storage: " maxStorage "`n")
            OutputDebug("  Users: " maxUsers "`n")
            OutputDebug("  Features: " features "`n")
            OutputDebug("  Cost: " monthlyCost " pricing`n")

        default:
            OutputDebug("Unknown account type`n")
    }

    ; Transaction processing
    OutputDebug("`n")
    transactionType := "withdrawal"
    amount := 500

    switch transactionType {
        case "deposit":
            balance := 1000
            balance += amount
            fee := 0
            OutputDebug("Deposit processed: $" amount "`n")
            OutputDebug("New balance: $" balance "`n")
            OutputDebug("Fee: $" fee "`n")

        case "withdrawal":
            balance := 1000
            fee := 2.50
            if (balance >= amount + fee) {
                balance -= (amount + fee)
                OutputDebug("Withdrawal processed: $" amount "`n")
                OutputDebug("Fee: $" fee "`n")
                OutputDebug("New balance: $" balance "`n")
            } else {
                OutputDebug("Insufficient funds`n")
            }

        case "transfer":
            balance := 1000
            fee := 1.00
            if (balance >= amount + fee) {
                balance -= (amount + fee)
                OutputDebug("Transfer processed: $" amount "`n")
                OutputDebug("Fee: $" fee "`n")
                OutputDebug("New balance: $" balance "`n")
            } else {
                OutputDebug("Insufficient funds for transfer`n")
            }

        default:
            OutputDebug("Invalid transaction type`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Real-World Switch Applications
; ============================================================================

/**
 * Demonstrates practical real-world switch statement usage.
 * Shows common patterns in real applications.
 */
Example7_RealWorldApplications() {
    OutputDebug("=== Example 7: Real-World Applications ===`n")

    ; Email handler
    emailAction := "reply"

    switch emailAction {
        case "reply":
            OutputDebug("Opening reply window...`n")
            recipient := "sender@example.com"
            subject := "Re: Original Subject"
            OutputDebug("To: " recipient "`n")

        case "replyall":
            OutputDebug("Opening reply all window...`n")
            recipients := "sender@example.com; cc@example.com"
            subject := "Re: Original Subject"
            OutputDebug("To: " recipients "`n")

        case "forward":
            OutputDebug("Opening forward window...`n")
            subject := "Fwd: Original Subject"
            OutputDebug("Subject: " subject "`n")

        case "delete":
            OutputDebug("Moving to trash...`n")
            location := "Trash"

        case "archive":
            OutputDebug("Archiving email...`n")
            location := "Archive"

        default:
            OutputDebug("Unknown email action`n")
    }

    ; Game state machine
    OutputDebug("`n")
    gameState := "playing"

    switch gameState {
        case "menu":
            OutputDebug("Game State: Main Menu`n")
            ShowMenu()

        case "playing":
            OutputDebug("Game State: Active Gameplay`n")
            UpdateGame()

        case "paused":
            OutputDebug("Game State: Paused`n")
            ShowPauseMenu()

        case "gameover":
            OutputDebug("Game State: Game Over`n")
            ShowGameOverScreen()

        case "victory":
            OutputDebug("Game State: Victory!`n")
            ShowVictoryScreen()

        default:
            OutputDebug("Unknown game state`n")
    }

    ; Content type handler
    OutputDebug("`n")
    contentType := "application/json"

    switch contentType {
        case "text/html":
            parser := "HTMLParser"
            encoding := "UTF-8"
            OutputDebug("Parsing HTML content`n")

        case "application/json":
            parser := "JSONParser"
            encoding := "UTF-8"
            OutputDebug("Parsing JSON content`n")

        case "application/xml", "text/xml":
            parser := "XMLParser"
            encoding := "UTF-8"
            OutputDebug("Parsing XML content`n")

        case "text/plain":
            parser := "TextParser"
            encoding := "UTF-8"
            OutputDebug("Parsing plain text`n")

        default:
            parser := "BinaryParser"
            OutputDebug("Unknown content type, using binary parser`n")
    }

    OutputDebug("`n")
}

/**
 * Helper functions for game state example.
 */
ShowMenu() {
    OutputDebug("  Displaying main menu options`n")
}

UpdateGame() {
    OutputDebug("  Running game loop`n")
}

ShowPauseMenu() {
    OutputDebug("  Showing pause menu`n")
}

ShowGameOverScreen() {
    OutputDebug("  Displaying game over screen`n")
}

ShowVictoryScreen() {
    OutputDebug("  Celebrating victory!`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Basic Switch Statements Examples`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_BasicSwitchSyntax()
    Example2_StringMatching()
    Example3_NumericValues()
    Example4_DefaultCaseHandling()
    Example5_SwitchVsIfElse()
    Example6_MultipleStatements()
    Example7_RealWorldApplications()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
