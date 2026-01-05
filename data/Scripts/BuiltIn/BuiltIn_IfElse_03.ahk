#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Complex Conditions
 * ============================================================================
 * 
 * This script demonstrates complex conditional expressions in AutoHotkey v2.
 * It covers advanced boolean logic, multiple condition combinations, and
 * optimization techniques for complex decision making.
 * 
 * @file BuiltIn_IfElse_03.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples included:
 * 1. Complex boolean expressions with multiple operators
 * 2. Parentheses for precedence control
 * 3. De Morgan's laws and logical simplification
 * 4. Short-circuit evaluation
 * 5. Complex range checks and boundaries
 * 6. Multi-condition validation patterns
 * 7. Performance optimization for complex conditions
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Complex Boolean Expressions
; ============================================================================

/**
 * Demonstrates complex boolean expressions combining multiple operators.
 * Shows AND, OR, NOT in various combinations.
 */
Example1_ComplexBooleanExpressions() {
    OutputDebug("=== Example 1: Complex Boolean Expressions ===`n")

    ; Complex user permission check
    isAdmin := false
    isManager := true
    department := "IT"
    yearsOfService := 5
    hasSpecialClearance := true

    if ((isAdmin or (isManager and yearsOfService >= 3)) and (department = "IT" or hasSpecialClearance)) {
        OutputDebug("Access granted to secure systems`n")
        OutputDebug("Criteria: Admin=" isAdmin ", Manager=" isManager ", YOS=" yearsOfService "`n")
    } else {
        OutputDebug("Access denied to secure systems`n")
    }

    ; Complex eligibility calculation
    age := 28
    income := 55000
    creditScore := 720
    hasCoSigner := false
    employmentYears := 3

    eligible := (age >= 21 and age <= 65) and
        (income >= 30000 or hasCoSigner) and
        (creditScore >= 650 or (creditScore >= 600 and employmentYears >= 2))

    if (eligible) {
        OutputDebug("Loan eligible: Age=" age ", Income=$" income ", Score=" creditScore "`n")
    } else {
        OutputDebug("Loan not eligible`n")
    }

    ; Multi-factor authentication check
    hasPassword := true
    hasBiometric := false
    hasToken := true
    hasBackupCodes := true
    isTrustedDevice := false

    mfaPassed := hasPassword and
        ((hasBiometric or hasToken) or
            (hasBackupCodes and isTrustedDevice))

    if (mfaPassed) {
        OutputDebug("MFA authentication successful`n")
    } else {
        OutputDebug("MFA authentication failed - additional verification needed`n")
    }

    ; Complex shipping qualification
    orderValue := 75
    isPrimeM := false
    quantity := 3
    weightPerItem := 2
    isFragile := false
    destination := "domestic"

    freeShipping := (orderValue >= 50 and !isFragile) or
        (isPrimeM and destination = "domestic") or
        (quantity >= 5 and weightPerItem <= 5)

    if (freeShipping) {
        OutputDebug("Qualifies for free shipping!`n")
    } else {
        OutputDebug("Shipping charges apply`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Parentheses for Precedence Control
; ============================================================================

/**
 * Demonstrates using parentheses to control evaluation order.
 * Shows how precedence affects boolean logic results.
 */
Example2_PrecedenceControl() {
    OutputDebug("=== Example 2: Parentheses for Precedence ===`n")

    ; Without explicit parentheses (relying on default precedence)
    a := true
    b := false
    c := true

    ; AND has higher precedence than OR
    result1 := a or b and c
    OutputDebug("a=" a ", b=" b ", c=" c "`n")
    OutputDebug("a or b and c = " result1 " (evaluates as: a or (b and c))`n")

    ; With explicit parentheses
    result2 := (a or b) and c
    OutputDebug("(a or b) and c = " result2 "`n`n")

    ; Practical example: Discount eligibility
    isMember := true
    purchaseAmount := 80
    hasPromoCode := false

    ; Without parentheses - confusing
    discount1 := isMember and purchaseAmount >= 100 or hasPromoCode
    OutputDebug("Member=" isMember ", Amount=$" purchaseAmount ", Promo=" hasPromoCode "`n")
    OutputDebug("Confusing: " discount1 "`n")

    ; With parentheses - clear intent
    discount2 := (isMember and purchaseAmount >= 100) or hasPromoCode
    OutputDebug("Clear intent: " discount2 "`n`n")

    ; Complex nested parentheses
    temperature := 75
    humidity := 55
    windSpeed := 10
    precipitation := 0

    goodWeather := ((temperature >= 65 and temperature <= 85) and
        (humidity >= 30 and humidity <= 70)) and
        ((windSpeed < 15) and (precipitation = 0))

    OutputDebug("Weather conditions: Temp=" temperature "°F, Humidity=" humidity "%`n")
    OutputDebug("Wind=" windSpeed "mph, Rain=" precipitation "in`n")
    OutputDebug("Good weather: " goodWeather "`n`n")

    ; Multiple condition grouping
    userAge := 25
    hasLicense := true
    hasInsurance := true
    carAge := 3
    violations := 0

    canRentCar := (userAge >= 21 and hasLicense and hasInsurance) and
        ((carAge <= 5 and violations = 0) or userAge >= 25)

    OutputDebug("Rental eligibility: " canRentCar "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 3: De Morgan's Laws and Logical Simplification
; ============================================================================

/**
 * Demonstrates De Morgan's laws for simplifying complex conditions.
 * Shows equivalent expressions and optimization opportunities.
 */
Example3_DeMorganLaws() {
    OutputDebug("=== Example 3: De Morgan's Laws ===`n")

    ; De Morgan's Law: not(A and B) = (not A) or (not B)
    isWeekend := false
    isHoliday := false

    ; Original complex form
    notWorkDay1 := !(isWeekend and isHoliday)
    OutputDebug("!(weekend AND holiday) = " notWorkDay1 "`n")

    ; De Morgan's simplified form
    notWorkDay2 := !isWeekend or !isHoliday
    OutputDebug("!weekend OR !holiday = " notWorkDay2 "`n")
    OutputDebug("Both expressions equal: " (notWorkDay1 = notWorkDay2) "`n`n")

    ; De Morgan's Law: not(A or B) = (not A) and (not B)
    hasError := false
    hasWarning := false

    ; Original form
    isClean1 := !(hasError or hasWarning)
    OutputDebug("!(error OR warning) = " isClean1 "`n")

    ; Simplified form
    isClean2 := !hasError and !hasWarning
    OutputDebug("!error AND !warning = " isClean2 "`n")
    OutputDebug("Both expressions equal: " (isClean1 = isClean2) "`n`n")

    ; Practical simplification example
    doorLocked := true
    alarmOn := true
    motionDetected := false

    ; Complex form
    isSecure1 := !(!doorLocked or !alarmOn)
    OutputDebug("Complex security check: " isSecure1 "`n")

    ; Simplified form
    isSecure2 := doorLocked and alarmOn
    OutputDebug("Simplified security check: " isSecure2 "`n`n")

    ; Multiple negations
    productInStock := true
    productDiscontinued := false
    productReserved := false

    ; Can we sell? Original
    canSell1 := !(!(productInStock and !productDiscontinued) or productReserved)
    OutputDebug("Complex can sell: " canSell1 "`n")

    ; Simplified step by step
    canSell2 := productInStock and !productDiscontinued and !productReserved
    OutputDebug("Simplified can sell: " canSell2 "`n")

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Short-Circuit Evaluation
; ============================================================================

/**
 * Demonstrates short-circuit evaluation in boolean expressions.
 * Shows performance benefits and safe access patterns.
 */
Example4_ShortCircuitEvaluation() {
    OutputDebug("=== Example 4: Short-Circuit Evaluation ===`n")

    ; AND short-circuit: Second condition not evaluated if first is false
    safeMode := false
    dangerousOperation := false

    if (safeMode and PerformComplexCheck()) {
        OutputDebug("This won't execute - PerformComplexCheck() not called`n")
    } else {
        OutputDebug("Short-circuit prevented expensive check (safeMode=false)`n")
    }

    ; OR short-circuit: Second condition not evaluated if first is true
    hasCache := true
    if (hasCache or LoadFromDatabase()) {
        OutputDebug("Used cache - database not accessed (short-circuit)`n")
    }

    ; Safe null/existence checking
    userData := Map("name", "John", "age", 30)

    if (userData.Has("email") and StrLen(userData["email"]) > 0) {
        OutputDebug("Email: " userData["email"] "`n")
    } else {
        OutputDebug("No email in user data (safe check prevented error)`n")
    }

    ; Avoiding division by zero
    numerator := 100
    denominator := 0

    if (denominator != 0 and (numerator / denominator) > 10) {
        OutputDebug("Result is greater than 10`n")
    } else {
        OutputDebug("Division skipped safely (denominator=" denominator ")`n")
    }

    ; Ordered checking for performance
    quickCheck := true
    mediumCheck := true
    expensiveCheck := false

    ; Fast checks first
    if (quickCheck and mediumCheck and PerformExpensiveOperation()) {
        OutputDebug("All checks passed`n")
    } else {
        OutputDebug("Failed at cheap checks - expensive operation avoided`n")
    }

    ; Array bounds checking
    numbers := [10, 20, 30, 40, 50]
    index := 10

    if (index <= numbers.Length and numbers[index] > 25) {
        OutputDebug("Value at index " index ": " numbers[index] "`n")
    } else {
        OutputDebug("Index out of bounds or condition not met`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Complex Range Checks and Boundaries
; ============================================================================

/**
 * Demonstrates complex range validation and boundary checking.
 * Shows inclusive/exclusive ranges and multi-dimensional bounds.
 */
Example5_RangeChecks() {
    OutputDebug("=== Example 5: Complex Range Checks ===`n")

    ; Inclusive range check
    temperature := 72
    if (temperature >= 68 and temperature <= 78) {
        OutputDebug(temperature "°F is in comfort range [68-78]`n")
    }

    ; Exclusive range check
    percentage := 50
    if (percentage > 0 and percentage < 100) {
        OutputDebug(percentage "% is in valid range (0-100)`n")
    }

    ; Multiple non-overlapping ranges
    priority := 7
    if (priority >= 1 and priority <= 3) {
        level := "Critical"
    } else if (priority >= 4 and priority <= 6) {
        level := "High"
    } else if (priority >= 7 and priority <= 9) {
        level := "Medium"
    } else {
        level := "Low"
    }
    OutputDebug("Priority " priority " = " level " level`n")

    ; Outside range check
    value := 150
    if (value < 0 or value > 100) {
        OutputDebug(value " is outside normal range [0-100]`n")
    }

    ; Multiple range intersection
    x := 50
    y := 75
    if ((x >= 0 and x <= 100) and (y >= 0 and y <= 100)) {
        if ((x >= 25 and x <= 75) and (y >= 50 and y <= 100)) {
            OutputDebug("Point (" x "," y ") is in intersection zone`n")
        }
    }

    ; Time range checking
    hour := A_Hour
    minute := A_Min
    currentTime := hour * 60 + minute

    businessStart := 9 * 60  ; 9:00 AM in minutes
    businessEnd := 17 * 60   ; 5:00 PM in minutes

    if (currentTime >= businessStart and currentTime <= businessEnd) {
        OutputDebug("Currently within business hours`n")
    } else {
        OutputDebug("Outside business hours`n")
    }

    ; Age bracket with multiple conditions
    age := 35
    if (age >= 0 and age <= 12) {
        bracket := "Child"
    } else if (age >= 13 and age <= 19) {
        bracket := "Teenager"
    } else if (age >= 20 and age <= 39) {
        bracket := "Young Adult"
    } else if (age >= 40 and age <= 59) {
        bracket := "Middle Age"
    } else {
        bracket := "Senior"
    }
    OutputDebug("Age " age " -> " bracket "`n")

    ; Bounded random number validation
    randomNum := Random(1, 100)
    if (randomNum >= 1 and randomNum <= 100) {
        if (randomNum <= 25) {
            tier := "Q1"
        } else if (randomNum <= 50) {
            tier := "Q2"
        } else if (randomNum <= 75) {
            tier := "Q3"
        } else {
            tier := "Q4"
        }
        OutputDebug("Random " randomNum " -> Quartile " tier "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Multi-Condition Validation Patterns
; ============================================================================

/**
 * Demonstrates comprehensive validation patterns for complex scenarios.
 * Shows real-world multi-factor validation.
 */
Example6_ValidationPatterns() {
    OutputDebug("=== Example 6: Multi-Condition Validation ===`n")

    ; Password strength validation
    password := "MyP@ssw0rd123"
    hasLength := StrLen(password) >= 8 and StrLen(password) <= 128
    hasUpper := RegExMatch(password, "[A-Z]")
    hasLower := RegExMatch(password, "[a-z]")
    hasDigit := RegExMatch(password, "\d")
    hasSpecial := RegExMatch(password, "[!@#$%^&*(),.?`":{}<>]")

    strength := 0
    if (hasLength) strength++
        if (hasUpper) strength++
            if (hasLower) strength++
                if (hasDigit) strength++
                    if (hasSpecial) strength++
                        OutputDebug("Password validation:`n")
    OutputDebug("  Length OK: " hasLength "`n")
    OutputDebug("  Uppercase: " hasUpper "`n")
    OutputDebug("  Lowercase: " hasLower "`n")
    OutputDebug("  Digits: " hasDigit "`n")
    OutputDebug("  Special: " hasSpecial "`n")

    if (strength >= 4 and hasLength and hasUpper and hasLower) {
        OutputDebug("  Strength: Strong (" strength "/5)`n")
    } else if (strength >= 3) {
        OutputDebug("  Strength: Medium (" strength "/5)`n")
    } else {
        OutputDebug("  Strength: Weak (" strength "/5)`n")
    }

    ; File upload validation
    fileName := "document.pdf"
    fileSize := 2048576  ; bytes
    allowedExts := [".pdf", ".doc", ".docx", ".txt"]
    maxSize := 5242880  ; 5MB in bytes

    fileExt := SubStr(fileName, -4)
    isAllowedType := false
    for ext in allowedExts {
        if (fileExt = ext) {
            isAllowedType := true
            break
        }
    }

    validName := StrLen(fileName) > 0 and StrLen(fileName) <= 255
    validSize := fileSize > 0 and fileSize <= maxSize
    noSpecialChars := !RegExMatch(fileName, "[<>:`"/\\|?*]")

    OutputDebug("`nFile upload validation:`n")
    OutputDebug("  Name: " fileName "`n")
    OutputDebug("  Size: " Round(fileSize / 1024 / 1024, 2) " MB`n")
    OutputDebug("  Valid name: " validName "`n")
    OutputDebug("  Valid size: " validSize "`n")
    OutputDebug("  Allowed type: " isAllowedType "`n")
    OutputDebug("  No special chars: " noSpecialChars "`n")

    if (validName and validSize and isAllowedType and noSpecialChars) {
        OutputDebug("  Result: Upload APPROVED`n")
    } else {
        OutputDebug("  Result: Upload REJECTED`n")
    }

    ; Credit card transaction validation
    cardBalance := 5000
    transactionAmount := 250
    dailyLimit := 1000
    dailySpent := 600
    isForeignTransaction := false
    foreignFee := 0.03

    hasBalance := cardBalance >= transactionAmount
    withinDaily := (dailySpent + transactionAmount) <= dailyLimit
    notBlocked := true
    validMerchant := true

    OutputDebug("`nTransaction validation:`n")
    OutputDebug("  Amount: $" transactionAmount "`n")
    OutputDebug("  Balance sufficient: " hasBalance "`n")
    OutputDebug("  Within daily limit: " withinDaily "`n")
    OutputDebug("  Card not blocked: " notBlocked "`n")
    OutputDebug("  Valid merchant: " validMerchant "`n")

    if (hasBalance and withinDaily and notBlocked and validMerchant) {
        finalAmount := transactionAmount
        if (isForeignTransaction) {
            finalAmount += transactionAmount * foreignFee
            OutputDebug("  Foreign fee: $" Round(transactionAmount * foreignFee, 2) "`n")
        }
        OutputDebug("  Final amount: $" Round(finalAmount, 2) "`n")
        OutputDebug("  Result: APPROVED`n")
    } else {
        OutputDebug("  Result: DECLINED`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Performance Optimization for Complex Conditions
; ============================================================================

/**
 * Demonstrates optimization techniques for complex conditions.
 * Shows caching, reordering, and efficient evaluation patterns.
 */
Example7_PerformanceOptimization() {
    OutputDebug("=== Example 7: Performance Optimization ===`n")

    ; Cache expensive computations
    largeList := []
    Loop 1000 {
        largeList.Push(A_Index)
    }

    ; Bad: Repeated expensive calculation
    OutputDebug("Without caching:`n")
    startTime := A_TickCount
    if (largeList.Length > 100 and largeList.Length < 2000) {
        OutputDebug("  List size valid (checked twice)`n")
    }
    elapsed1 := A_TickCount - startTime

    ; Good: Cache the value
    OutputDebug("With caching:`n")
    startTime := A_TickCount
    listSize := largeList.Length
    if (listSize > 100 and listSize < 2000) {
        OutputDebug("  List size valid (checked once)`n")
    }
    elapsed2 := A_TickCount - startTime
    OutputDebug("  Performance improvement achieved`n`n")

    ; Order conditions by likelihood (fail-fast)
    userExists := true
    userActive := true
    userVerified := false  ; Most likely to fail
    userPremium := true

    ; Bad: Check unlikely conditions last
    if (userExists and userActive and userPremium and userVerified) {
        OutputDebug("User has full access`n")
    } else {
        OutputDebug("Inefficient: Checked 3 true conditions before failing`n")
    }

    ; Good: Check most likely to fail first
    if (userVerified and userExists and userActive and userPremium) {
        OutputDebug("User has full access`n")
    } else {
        OutputDebug("Efficient: Failed fast on first check`n")
    }

    ; Use early returns instead of deep nesting
    ProcessRequest("user@email.com", true, 100)
    ProcessRequest("invalid-email", true, 100)

    ; Combine related checks
    min := 10
    max := 100
    testValue := 50

    ; Less efficient
    if (testValue >= min) {
        if (testValue <= max) {
            OutputDebug("`n" testValue " is in range (nested check)`n")
        }
    }

    ; More efficient
    if (testValue >= min and testValue <= max) {
        OutputDebug(testValue " is in range (combined check)`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Simulates a complex check that should be avoided via short-circuit.
 */
PerformComplexCheck() {
    OutputDebug("  [This expensive check should not execute]`n")
    return true
}

/**
 * Simulates loading data from database (expensive operation).
 */
LoadFromDatabase() {
    OutputDebug("  [Database access avoided via short-circuit]`n")
    return false
}

/**
 * Simulates an expensive operation.
 */
PerformExpensiveOperation() {
    OutputDebug("  [Expensive operation avoided]`n")
    return true
}

/**
 * Demonstrates early return pattern for better performance.
 */
ProcessRequest(email, isValid, amount) {
    ; Early returns avoid deep nesting
    if (!InStr(email, "@")) {
        OutputDebug("`nRequest rejected: Invalid email format`n")
        return
    }

    if (!isValid) {
        OutputDebug("`nRequest rejected: Not validated`n")
        return
    }

    if (amount <= 0) {
        OutputDebug("`nRequest rejected: Invalid amount`n")
        return
    }

    OutputDebug("`nRequest approved: " email " for $" amount "`n")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Complex Conditions Examples`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_ComplexBooleanExpressions()
    Example2_PrecedenceControl()
    Example3_DeMorganLaws()
    Example4_ShortCircuitEvaluation()
    Example5_RangeChecks()
    Example6_ValidationPatterns()
    Example7_PerformanceOptimization()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
