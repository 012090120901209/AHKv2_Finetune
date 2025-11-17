#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Basic If/Else Statements
 * ============================================================================
 *
 * This script demonstrates basic if/else statement usage in AutoHotkey v2.
 * It covers simple conditions, else clauses, else if chains, and common
 * comparison operators.
 *
 * @file BuiltIn_IfElse_01.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 *
 * @description
 * Examples included:
 * 1. Simple if statements with single conditions
 * 2. If/else dual branching
 * 3. If/else if/else chains for multiple conditions
 * 4. Comparison operators (=, !=, <, >, <=, >=)
 * 5. Logical operators (and, or, not)
 * 6. String comparisons and case sensitivity
 * 7. Numeric vs string comparison behaviors
 *
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Simple If Statements
; ============================================================================

/**
 * Demonstrates basic if statement syntax with single conditions.
 * Shows both single-line and block formats.
 */
Example1_SimpleIf() {
    OutputDebug("=== Example 1: Simple If Statements ===`n")

    ; Simple if with single statement
    temperature := 75
    if (temperature > 70)
        OutputDebug("It's warm outside!`n")

    ; If with block (recommended for clarity)
    age := 25
    if (age >= 18) {
        OutputDebug("You are an adult.`n")
        OutputDebug("Age: " age "`n")
    }

    ; If with expression evaluation
    score := 85
    if (score >= 60) {
        OutputDebug("Passing grade: " score "`n")
    }

    ; If with variable existence check
    userName := "Alice"
    if (userName) {
        OutputDebug("User name is set: " userName "`n")
    }

    ; If with empty string check
    emptyStr := ""
    if (!emptyStr) {
        OutputDebug("String is empty`n")
    }

    ; If with numeric zero check
    counter := 0
    if (counter = 0) {
        OutputDebug("Counter is zero`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: If/Else Dual Branching
; ============================================================================

/**
 * Demonstrates if/else statements for binary decision making.
 * Shows how to handle true and false cases.
 */
Example2_IfElse() {
    OutputDebug("=== Example 2: If/Else Dual Branching ===`n")

    ; Basic if/else
    isLoggedIn := true
    if (isLoggedIn) {
        OutputDebug("Welcome back!`n")
    } else {
        OutputDebug("Please log in.`n")
    }

    ; If/else with calculations
    balance := 150
    withdrawal := 200
    if (balance >= withdrawal) {
        balance -= withdrawal
        OutputDebug("Withdrawal successful. New balance: $" balance "`n")
    } else {
        OutputDebug("Insufficient funds. Balance: $" balance "`n")
    }

    ; If/else with string comparison
    userRole := "admin"
    if (userRole = "admin") {
        OutputDebug("Admin access granted`n")
    } else {
        OutputDebug("Regular user access`n")
    }

    ; If/else with modulo operation
    number := 42
    if (Mod(number, 2) = 0) {
        OutputDebug(number " is even`n")
    } else {
        OutputDebug(number " is odd`n")
    }

    ; If/else with ternary-like behavior
    points := 1250
    level := (points >= 1000) ? "Gold" : "Silver"
    OutputDebug("Membership level: " level "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 3: If/Else If/Else Chains
; ============================================================================

/**
 * Demonstrates chained if/else if/else statements for multiple conditions.
 * Shows how to handle more than two possible outcomes.
 */
Example3_IfElseIfChains() {
    OutputDebug("=== Example 3: If/Else If/Else Chains ===`n")

    ; Grade classification
    score := 85
    if (score >= 90) {
        grade := "A"
        OutputDebug("Excellent! Grade: " grade "`n")
    } else if (score >= 80) {
        grade := "B"
        OutputDebug("Good job! Grade: " grade "`n")
    } else if (score >= 70) {
        grade := "C"
        OutputDebug("Satisfactory. Grade: " grade "`n")
    } else if (score >= 60) {
        grade := "D"
        OutputDebug("Needs improvement. Grade: " grade "`n")
    } else {
        grade := "F"
        OutputDebug("Failed. Grade: " grade "`n")
    }

    ; Time-based greeting
    hour := A_Hour
    if (hour < 12) {
        greeting := "Good morning"
    } else if (hour < 18) {
        greeting := "Good afternoon"
    } else if (hour < 22) {
        greeting := "Good evening"
    } else {
        greeting := "Good night"
    }
    OutputDebug(greeting "! Current hour: " hour "`n")

    ; Price tier determination
    quantity := 75
    if (quantity >= 100) {
        discount := 0.20
        tier := "Platinum"
    } else if (quantity >= 50) {
        discount := 0.15
        tier := "Gold"
    } else if (quantity >= 25) {
        discount := 0.10
        tier := "Silver"
    } else if (quantity >= 10) {
        discount := 0.05
        tier := "Bronze"
    } else {
        discount := 0
        tier := "Regular"
    }
    OutputDebug("Quantity: " quantity " | Tier: " tier " | Discount: " (discount * 100) "%`n")

    ; User permission level
    permissionLevel := 3
    if (permissionLevel = 1) {
        OutputDebug("Read-only access`n")
    } else if (permissionLevel = 2) {
        OutputDebug("Read and write access`n")
    } else if (permissionLevel = 3) {
        OutputDebug("Read, write, and delete access`n")
    } else if (permissionLevel = 4) {
        OutputDebug("Administrator access`n")
    } else {
        OutputDebug("Invalid permission level`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Comparison Operators
; ============================================================================

/**
 * Demonstrates all comparison operators in AHK v2.
 * Shows equality, inequality, and relational comparisons.
 */
Example4_ComparisonOperators() {
    OutputDebug("=== Example 4: Comparison Operators ===`n")

    ; Equality operator (=)
    value1 := 10
    value2 := 10
    if (value1 = value2) {
        OutputDebug(value1 " equals " value2 "`n")
    }

    ; Inequality operator (!=)
    value3 := 20
    if (value1 != value3) {
        OutputDebug(value1 " does not equal " value3 "`n")
    }

    ; Less than (<)
    if (value1 < value3) {
        OutputDebug(value1 " is less than " value3 "`n")
    }

    ; Greater than (>)
    if (value3 > value1) {
        OutputDebug(value3 " is greater than " value1 "`n")
    }

    ; Less than or equal to (<=)
    if (value1 <= value2) {
        OutputDebug(value1 " is less than or equal to " value2 "`n")
    }

    ; Greater than or equal to (>=)
    if (value1 >= value2) {
        OutputDebug(value1 " is greater than or equal to " value2 "`n")
    }

    ; Case-insensitive string comparison
    str1 := "Hello"
    str2 := "hello"
    if (str1 = str2) {
        OutputDebug("`"" str1 "`" equals `"" str2 "`" (case-insensitive by default)`n")
    }

    ; Case-sensitive string comparison
    if (str1 == str2) {
        OutputDebug("Case-sensitive: strings are equal`n")
    } else {
        OutputDebug("Case-sensitive: `"" str1 "`" does not equal `"" str2 "`"`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Logical Operators (AND, OR, NOT)
; ============================================================================

/**
 * Demonstrates logical operators for combining conditions.
 * Shows AND, OR, and NOT operations.
 */
Example5_LogicalOperators() {
    OutputDebug("=== Example 5: Logical Operators ===`n")

    ; AND operator - both conditions must be true
    age := 25
    hasLicense := true
    if (age >= 18 and hasLicense) {
        OutputDebug("Can drive: age=" age ", has license=" hasLicense "`n")
    }

    ; OR operator - at least one condition must be true
    isWeekend := true
    isHoliday := false
    if (isWeekend or isHoliday) {
        OutputDebug("Day off! Weekend: " isWeekend ", Holiday: " isHoliday "`n")
    }

    ; NOT operator - inverts condition
    isRaining := false
    if (not isRaining) {
        OutputDebug("Go for a walk! No rain.`n")
    }

    ; Combining multiple logical operators
    temperature := 75
    humidity := 60
    if ((temperature >= 70 and temperature <= 85) and humidity < 70) {
        OutputDebug("Perfect weather! Temp: " temperature "°F, Humidity: " humidity "%`n")
    }

    ; Complex condition with parentheses for clarity
    userAge := 30
    isPremium := true
    hasSubscription := false
    if ((userAge >= 18 and isPremium) or hasSubscription) {
        OutputDebug("Access granted`n")
    }

    ; Using ! for NOT
    isEmpty := false
    if (!isEmpty) {
        OutputDebug("Container has items`n")
    }

    ; Multiple NOT operations
    isLocked := false
    isExpired := false
    if (!isLocked and !isExpired) {
        OutputDebug("Account is active and accessible`n")
    }

    ; Range checking with AND
    score := 75
    if (score >= 0 and score <= 100) {
        OutputDebug("Valid score: " score "`n")
    }

    ; Either/or with OR
    fileExt := ".txt"
    if (fileExt = ".txt" or fileExt = ".log" or fileExt = ".md") {
        OutputDebug("Text-based file format: " fileExt "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: String Comparisons and Case Sensitivity
; ============================================================================

/**
 * Demonstrates string comparison behaviors in AHK v2.
 * Shows case sensitivity, substring checks, and string validation.
 */
Example6_StringComparisons() {
    OutputDebug("=== Example 6: String Comparisons ===`n")

    ; Case-insensitive comparison (default)
    username := "JohnDoe"
    input := "johndoe"
    if (username = input) {
        OutputDebug("Username match (case-insensitive): " username " = " input "`n")
    }

    ; Case-sensitive comparison
    if (username == input) {
        OutputDebug("Exact match (case-sensitive)`n")
    } else {
        OutputDebug("Case-sensitive mismatch: `"" username "`" != `"" input "`"`n")
    }

    ; String contains check with InStr
    email := "user@example.com"
    if (InStr(email, "@")) {
        OutputDebug("Valid email format (contains @): " email "`n")
    }

    ; StartsWith pattern
    url := "https://www.example.com"
    if (SubStr(url, 1, 8) = "https://") {
        OutputDebug("Secure URL: " url "`n")
    }

    ; EndsWith pattern
    filename := "document.pdf"
    if (SubStr(filename, -3) = ".pdf") {
        OutputDebug("PDF file: " filename "`n")
    }

    ; Empty string check
    value := ""
    if (value = "") {
        OutputDebug("Value is empty string`n")
    }

    ; String length comparison
    password := "myP@ssw0rd"
    if (StrLen(password) >= 8) {
        OutputDebug("Password meets minimum length: " StrLen(password) " characters`n")
    }

    ; Multiple string comparisons
    status := "active"
    if (status = "active" or status = "pending") {
        OutputDebug("Status is valid: " status "`n")
    }

    ; String pattern matching with RegEx
    phoneNumber := "555-1234"
    if (RegExMatch(phoneNumber, "\d{3}-\d{4}")) {
        OutputDebug("Valid phone format: " phoneNumber "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Numeric vs String Comparison Behaviors
; ============================================================================

/**
 * Demonstrates the differences between numeric and string comparisons.
 * Shows type coercion and best practices.
 */
Example7_NumericVsStringComparison() {
    OutputDebug("=== Example 7: Numeric vs String Comparison ===`n")

    ; Numeric comparison
    num1 := 10
    num2 := 5
    if (num1 > num2) {
        OutputDebug("Numeric: " num1 " > " num2 "`n")
    }

    ; String that looks like number
    str1 := "10"
    str2 := "5"
    if (str1 > str2) {
        OutputDebug("String comparison: `"" str1 "`" > `"" str2 "`"`n")
    }

    ; Mixed comparison (auto-conversion)
    numValue := 100
    strValue := "100"
    if (numValue = strValue) {
        OutputDebug("Mixed comparison works: " numValue " = `"" strValue "`"`n")
    }

    ; Leading zeros in strings
    code1 := "007"
    code2 := "7"
    if (code1 = code2) {
        OutputDebug("Numeric comparison treats `"" code1 "`" = `"" code2 "`"`n")
    }
    if (code1 == code2) {
        OutputDebug("String comparison: exact match`n")
    } else {
        OutputDebug("String comparison: `"" code1 "`" != `"" code2 "`"`n")
    }

    ; Floating point comparison
    price1 := 19.99
    price2 := 19.99
    if (price1 = price2) {
        OutputDebug("Prices match: $" price1 "`n")
    }

    ; Comparison with tolerance for floating point
    value1 := 0.1 + 0.2
    value2 := 0.3
    tolerance := 0.0001
    if (Abs(value1 - value2) < tolerance) {
        OutputDebug("Floating point values approximately equal`n")
    }

    ; Hexadecimal comparison
    hexValue := 0xFF
    decValue := 255
    if (hexValue = decValue) {
        OutputDebug("Hex " hexValue " equals decimal " decValue "`n")
    }

    ; Negative number comparison
    temp1 := -5
    temp2 := 0
    if (temp1 < temp2) {
        OutputDebug("Temperature " temp1 "° is below freezing`n")
    }

    ; Very large number comparison
    bigNum1 := 1000000000
    bigNum2 := 999999999
    if (bigNum1 > bigNum2) {
        OutputDebug("Large number comparison: " bigNum1 " > " bigNum2 "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Main Execution
; ============================================================================

/**
 * Runs all examples in sequence.
 */
Main() {
    OutputDebug("`n" "=" * 70 "`n")
    OutputDebug("AutoHotkey v2 - Basic If/Else Statements Examples`n")
    OutputDebug("=" * 70 "`n`n")

    Example1_SimpleIf()
    Example2_IfElse()
    Example3_IfElseIfChains()
    Example4_ComparisonOperators()
    Example5_LogicalOperators()
    Example6_StringComparisons()
    Example7_NumericVsStringComparison()

    OutputDebug("=" * 70 "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug("=" * 70 "`n")
}

; Run main function
Main()
