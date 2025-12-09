#Requires AutoHotkey v2.0

/**
* ============================================================================
* AutoHotkey v2 Control Flow - Guard Clauses
* ============================================================================
*
* This script demonstrates guard clause patterns in AutoHotkey v2.
* It covers early returns, defensive programming, input validation,
* and refactoring techniques to improve code readability.
*
* @file BuiltIn_IfElse_04.ahk
* @author AHK v2 Examples Collection
* @version 2.0.0
* @date 2024-01-15
*
* @description
* Examples included:
* 1. Basic guard clause pattern with early returns
* 2. Input validation using guard clauses
* 3. Precondition checking
* 4. Error handling with guard clauses
* 5. Refactoring nested ifs to guard clauses
* 6. Multi-level validation chains
* 7. Guard clauses in real-world scenarios
*
* @requires AutoHotkey v2.0+
*/

; ============================================================================
; Example 1: Basic Guard Clause Pattern
; ============================================================================

/**
* Demonstrates the fundamental guard clause pattern.
* Shows how early returns improve code readability.
*/
Example1_BasicGuardClauses() {
    OutputDebug("=== Example 1: Basic Guard Clauses ===`n")

    ; Without guard clauses (nested)
    OutputDebug("--- Without Guard Clauses ---`n")
    ProcessUserNested("john_doe", "valid@email.com", 25)

    ; With guard clauses (flat)
    OutputDebug("`n--- With Guard Clauses ---`n")
    ProcessUserGuarded("john_doe", "valid@email.com", 25)

    OutputDebug("`n--- Testing Invalid Input ---`n")
    ProcessUserGuarded("", "valid@email.com", 25)
    ProcessUserGuarded("john_doe", "invalid-email", 25)
    ProcessUserGuarded("john_doe", "valid@email.com", 15)

    OutputDebug("`n")
}

/**
* Traditional nested if approach.
*/
ProcessUserNested(username, email, age) {
    if (username != "") {
        if (InStr(email, "@")) {
            if (age >= 18) {
                OutputDebug("User processed: " username "`n")
            } else {
                OutputDebug("Error: Must be 18+`n")
            }
        } else {
            OutputDebug("Error: Invalid email`n")
        }
    } else {
        OutputDebug("Error: Username required`n")
    }
}

/**
* Guard clause approach (recommended).
*/
ProcessUserGuarded(username, email, age) {
    ; Guard: Check username
    if (username = "") {
        OutputDebug("Error: Username required`n")
        return
    }

    ; Guard: Check email
    if (!InStr(email, "@")) {
        OutputDebug("Error: Invalid email`n")
        return
    }

    ; Guard: Check age
    if (age < 18) {
        OutputDebug("Error: Must be 18+`n")
        return
    }

    ; Happy path - no nesting required
    OutputDebug("User processed: " username "`n")
}

; ============================================================================
; Example 2: Input Validation with Guard Clauses
; ============================================================================

/**
* Demonstrates comprehensive input validation using guard clauses.
* Shows how to validate multiple parameters efficiently.
*/
Example2_InputValidation() {
    OutputDebug("=== Example 2: Input Validation ===`n")

    ; Test valid input
    CreateAccount("alice", "alice@example.com", "P@ssw0rd123", 30)

    ; Test invalid inputs
    OutputDebug("`n")
    CreateAccount("", "alice@example.com", "P@ssw0rd123", 30)  ; Empty username
    CreateAccount("ab", "alice@example.com", "P@ssw0rd123", 30)  ; Short username
    CreateAccount("alice", "invalid", "P@ssw0rd123", 30)  ; Bad email
    CreateAccount("alice", "alice@example.com", "weak", 30)  ; Weak password
    CreateAccount("alice", "alice@example.com", "P@ssw0rd123", 15)  ; Underage

    OutputDebug("`n")
}

/**
* Account creation with comprehensive guard clauses.
*/
CreateAccount(username, email, password, age) {
    ; Guard: Username existence
    if (username = "") {
        OutputDebug("✗ Username cannot be empty`n")
        return false
    }

    ; Guard: Username length
    if (StrLen(username) < 3) {
        OutputDebug("✗ Username must be at least 3 characters`n")
        return false
    }

    ; Guard: Username format
    if (!RegExMatch(username, "^[a-zA-Z0-9_]+$")) {
        OutputDebug("✗ Username can only contain letters, numbers, and underscores`n")
        return false
    }

    ; Guard: Email format
    if (!InStr(email, "@") or !InStr(email, ".")) {
        OutputDebug("✗ Invalid email format`n")
        return false
    }

    ; Guard: Password strength
    if (StrLen(password) < 8) {
        OutputDebug("✗ Password must be at least 8 characters`n")
        return false
    }

    ; Guard: Password complexity
    if (!RegExMatch(password, "[A-Z]") or !RegExMatch(password, "[0-9]")) {
        OutputDebug("✗ Password must contain uppercase and numbers`n")
        return false
    }

    ; Guard: Age requirement
    if (age < 18) {
        OutputDebug("✗ Must be 18 or older`n")
        return false
    }

    ; All guards passed - create account
    OutputDebug("✓ Account created successfully for " username "`n")
    return true
}

; ============================================================================
; Example 3: Precondition Checking
; ============================================================================

/**
* Demonstrates using guard clauses for precondition validation.
* Shows system state and resource availability checks.
*/
Example3_PreconditionChecking() {
    OutputDebug("=== Example 3: Precondition Checking ===`n")

    ; Test various scenarios
    state1 := Map("initialized", true, "connected", true, "hasData", true, "diskSpace", 500)
    ProcessData(state1, 100)

    OutputDebug("`n")
    state2 := Map("initialized", false, "connected", true, "hasData", true, "diskSpace", 500)
    ProcessData(state2, 100)

    OutputDebug("`n")
    state3 := Map("initialized", true, "connected", false, "hasData", true, "diskSpace", 500)
    ProcessData(state3, 100)

    OutputDebug("`n")
}

/**
* Processes data with multiple precondition checks.
*/
ProcessData(systemState, dataSize) {
    ; Guard: System initialized
    if (!systemState.Has("initialized") or !systemState["initialized"]) {
        OutputDebug("✗ System not initialized`n")
        return
    }

    ; Guard: Connection available
    if (!systemState.Has("connected") or !systemState["connected"]) {
        OutputDebug("✗ No connection available`n")
        return
    }

    ; Guard: Data exists
    if (!systemState.Has("hasData") or !systemState["hasData"]) {
        OutputDebug("✗ No data to process`n")
        return
    }

    ; Guard: Sufficient disk space
    requiredSpace := dataSize * 2
    if (!systemState.Has("diskSpace") or systemState["diskSpace"] < requiredSpace) {
        OutputDebug("✗ Insufficient disk space (need " requiredSpace "MB)`n")
        return
    }

    ; Guard: Valid data size
    if (dataSize <= 0) {
        OutputDebug("✗ Invalid data size`n")
        return
    }

    ; All preconditions met
    OutputDebug("✓ Processing " dataSize "MB of data...`n")
    OutputDebug("✓ Data processed successfully`n")
}

; ============================================================================
; Example 4: Error Handling with Guard Clauses
; ============================================================================

/**
* Demonstrates error handling patterns using guard clauses.
* Shows how to fail fast and provide clear error messages.
*/
Example4_ErrorHandling() {
    OutputDebug("=== Example 4: Error Handling ===`n")

    ; Test file operations
    PerformFileOperation("document.txt", "read", 1024)
    OutputDebug("`n")
    PerformFileOperation("", "read", 1024)
    OutputDebug("`n")
    PerformFileOperation("document.txt", "delete", 1024)
    OutputDebug("`n")

    ; Test transaction
    ExecuteTransaction(5000, 1000, true, false)
    OutputDebug("`n")
    ExecuteTransaction(500, 1000, true, false)

    OutputDebug("`n")
}

/**
* File operation with error guards.
*/
PerformFileOperation(filePath, operation, size) {
    ; Guard: File path provided
    if (filePath = "") {
        LogError("File path cannot be empty")
        return false
    }

    ; Guard: Valid operation
    validOps := ["read", "write", "append"]
    isValidOp := false
    for op in validOps {
        if (operation = op) {
            isValidOp := true
            break
        }
    }

    if (!isValidOp) {
        LogError("Invalid operation: " operation)
        return false
    }

    ; Guard: Valid size for write operations
    if ((operation = "write" or operation = "append") and size <= 0) {
        LogError("Invalid size for write operation")
        return false
    }

    ; Simulate file exists check
    fileExists := (filePath = "document.txt")

    ; Guard: File exists for read
    if (operation = "read" and !fileExists) {
        LogError("File not found: " filePath)
        return false
    }

    ; Success path
    OutputDebug("✓ File operation successful: " operation " on " filePath "`n")
    return true
}

/**
* Transaction execution with guards.
*/
ExecuteTransaction(balance, amount, isAuthorized, isBlocked) {
    ; Guard: Account not blocked
    if (isBlocked) {
        LogError("Account is blocked")
        return false
    }

    ; Guard: Authorization
    if (!isAuthorized) {
        LogError("Transaction not authorized")
        return false
    }

    ; Guard: Positive amount
    if (amount <= 0) {
        LogError("Amount must be positive")
        return false
    }

    ; Guard: Sufficient balance
    if (balance < amount) {
        LogError("Insufficient funds (balance: $" balance ", needed: $" amount ")")
        return false
    }

    ; Success
    newBalance := balance - amount
    OutputDebug("✓ Transaction successful! New balance: $" newBalance "`n")
    return true
}

/**
* Helper function to log errors.
*/
LogError(message) {
    OutputDebug("✗ ERROR: " message "`n")
}

; ============================================================================
; Example 5: Refactoring Nested Ifs to Guard Clauses
; ============================================================================

/**
* Demonstrates before/after refactoring of nested ifs.
* Shows dramatic readability improvements.
*/
Example5_RefactoringExamples() {
    OutputDebug("=== Example 5: Refactoring to Guard Clauses ===`n")

    OutputDebug("--- BEFORE: Nested Ifs ---`n")
    CalculateShippingNested(100, "USA", true, 5)

    OutputDebug("`n--- AFTER: Guard Clauses ---`n")
    CalculateShippingGuarded(100, "USA", true, 5)

    OutputDebug("`n--- Testing Edge Cases ---`n")
    CalculateShippingGuarded(0, "USA", true, 5)
    CalculateShippingGuarded(100, "INVALID", true, 5)
    CalculateShippingGuarded(100, "USA", true, 50)

    OutputDebug("`n")
}

/**
* Before: Deeply nested shipping calculation.
*/
CalculateShippingNested(orderValue, country, inStock, weight) {
    if (orderValue > 0) {
        if (country = "USA" or country = "Canada") {
            if (inStock) {
                if (weight <= 20) {
                    if (orderValue >= 50) {
                        cost := 0
                        OutputDebug("Free shipping! (order: $" orderValue ")`n")
                    } else {
                        cost := 5.99
                        OutputDebug("Shipping: $" cost " (order: $" orderValue ")`n")
                    }
                } else {
                    OutputDebug("Oversized package - special handling`n")
                }
            } else {
                OutputDebug("Item out of stock`n")
            }
        } else {
            OutputDebug("International shipping not available`n")
        }
    } else {
        OutputDebug("Invalid order value`n")
    }
}

/**
* After: Flattened with guard clauses.
*/
CalculateShippingGuarded(orderValue, country, inStock, weight) {
    ; Guards handle error cases first
    if (orderValue <= 0) {
        OutputDebug("Invalid order value`n")
        return 0
    }

    if (country != "USA" and country != "Canada") {
        OutputDebug("International shipping not available`n")
        return 0
    }

    if (!inStock) {
        OutputDebug("Item out of stock`n")
        return 0
    }

    if (weight > 20) {
        OutputDebug("Oversized package - special handling`n")
        return 25.00
    }

    ; Happy path is clear and at the end
    if (orderValue >= 50) {
        OutputDebug("Free shipping! (order: $" orderValue ")`n")
        return 0
    }

    cost := 5.99
    OutputDebug("Shipping: $" cost " (order: $" orderValue ")`n")
    return cost
}

; ============================================================================
; Example 6: Multi-Level Validation Chains
; ============================================================================

/**
* Demonstrates complex validation chains using guard clauses.
* Shows how to validate related data in sequence.
*/
Example6_ValidationChains() {
    OutputDebug("=== Example 6: Validation Chains ===`n")

    ; Create test order
    order := Map(
    "orderId", "ORD-12345",
    "customerId", "CUST-001",
    "items", [
    Map("id", "ITEM-1", "quantity", 2, "price", 50),
    Map("id", "ITEM-2", "quantity", 1, "price", 75)
    ],
    "shippingAddress", Map(
    "street", "123 Main St",
    "city", "Springfield",
    "state", "IL",
    "zip", "62701"
    ),
    "paymentMethod", Map(
    "type", "credit",
    "cardNumber", "4532123456789012",
    "cvv", "123"
    )
    )

    ValidateOrder(order)

    OutputDebug("`n--- Testing Invalid Order ---`n")
    invalidOrder := Map("orderId", "")
    ValidateOrder(invalidOrder)

    OutputDebug("`n")
}

/**
* Complex order validation with chained guards.
*/
ValidateOrder(order) {
    ; Level 1: Order basics
    if (!order.Has("orderId") or order["orderId"] = "") {
        OutputDebug("✗ Order ID required`n")
        return false
    }

    if (!order.Has("customerId") or order["customerId"] = "") {
        OutputDebug("✗ Customer ID required`n")
        return false
    }

    ; Level 2: Items validation
    if (!order.Has("items") or order["items"].Length = 0) {
        OutputDebug("✗ Order must contain items`n")
        return false
    }

    ; Validate each item
    totalAmount := 0
    for item in order["items"] {
        if (!item.Has("quantity") or item["quantity"] <= 0) {
            OutputDebug("✗ Invalid item quantity`n")
            return false
        }
        if (!item.Has("price") or item["price"] <= 0) {
            OutputDebug("✗ Invalid item price`n")
            return false
        }
        totalAmount += item["quantity"] * item["price"]
    }

    ; Level 3: Shipping address validation
    if (!order.Has("shippingAddress")) {
        OutputDebug("✗ Shipping address required`n")
        return false
    }

    address := order["shippingAddress"]
    if (!address.Has("street") or address["street"] = "") {
        OutputDebug("✗ Street address required`n")
        return false
    }

    if (!address.Has("city") or address["city"] = "") {
        OutputDebug("✗ City required`n")
        return false
    }

    if (!address.Has("state") or StrLen(address["state"]) != 2) {
        OutputDebug("✗ Valid state code required`n")
        return false
    }

    if (!address.Has("zip") or !RegExMatch(address["zip"], "^\d{5}$")) {
        OutputDebug("✗ Valid ZIP code required`n")
        return false
    }

    ; Level 4: Payment validation
    if (!order.Has("paymentMethod")) {
        OutputDebug("✗ Payment method required`n")
        return false
    }

    payment := order["paymentMethod"]
    if (!payment.Has("type") or (payment["type"] != "credit" and payment["type"] != "debit")) {
        OutputDebug("✗ Valid payment type required`n")
        return false
    }

    if (!payment.Has("cardNumber") or StrLen(payment["cardNumber"]) != 16) {
        OutputDebug("✗ Valid card number required`n")
        return false
    }

    if (!payment.Has("cvv") or StrLen(payment["cvv"]) != 3) {
        OutputDebug("✗ Valid CVV required`n")
        return false
    }

    ; All validations passed
    OutputDebug("✓ Order validation successful!`n")
    OutputDebug("  Order ID: " order["orderId"] "`n")
    OutputDebug("  Customer: " order["customerId"] "`n")
    OutputDebug("  Items: " order["items"].Length "`n")
    OutputDebug("  Total: $" totalAmount "`n")
    return true
}

; ============================================================================
; Example 7: Real-World Guard Clause Scenarios
; ============================================================================

/**
* Demonstrates guard clauses in practical real-world scenarios.
* Shows authentication, authorization, and business logic.
*/
Example7_RealWorldScenarios() {
    OutputDebug("=== Example 7: Real-World Scenarios ===`n")

    ; User authentication flow
    OutputDebug("--- Authentication Flow ---`n")
    AuthenticateUser("john_doe", "P@ssw0rd123", false, true)
    OutputDebug("`n")
    AuthenticateUser("john_doe", "wrong_password", false, true)

    ; Resource access control
    OutputDebug("`n--- Access Control ---`n")
    AccessResource("user123", "admin", "/admin/settings", true)
    OutputDebug("`n")
    AccessResource("user456", "user", "/admin/settings", true)

    ; Business rule validation
    OutputDebug("`n--- Business Rules ---`n")
    ApplyDiscount(1500, "GOLD", 3, false)
    OutputDebug("`n")
    ApplyDiscount(50, "BRONZE", 1, false)

    OutputDebug("`n")
}

/**
* User authentication with security guards.
*/
AuthenticateUser(username, password, accountLocked, accountActive) {
    ; Guard: Username provided
    if (username = "") {
        OutputDebug("✗ Username required`n")
        return false
    }

    ; Guard: Password provided
    if (password = "") {
        OutputDebug("✗ Password required`n")
        return false
    }

    ; Guard: Account not locked
    if (accountLocked) {
        OutputDebug("✗ Account is locked. Contact support.`n")
        return false
    }

    ; Guard: Account active
    if (!accountActive) {
        OutputDebug("✗ Account is inactive`n")
        return false
    }

    ; Simulate password check
    validPassword := (password = "P@ssw0rd123")

    ; Guard: Password correct
    if (!validPassword) {
        OutputDebug("✗ Invalid password`n")
        return false
    }

    ; Authentication successful
    OutputDebug("✓ Authentication successful for " username "`n")
    return true
}

/**
* Resource access control.
*/
AccessResource(userId, userRole, resourcePath, isLoggedIn) {
    ; Guard: User logged in
    if (!isLoggedIn) {
        OutputDebug("✗ Must be logged in`n")
        return false
    }

    ; Guard: Valid user ID
    if (userId = "") {
        OutputDebug("✗ Invalid user ID`n")
        return false
    }

    ; Guard: Admin resources require admin role
    if (InStr(resourcePath, "/admin/") and userRole != "admin") {
        OutputDebug("✗ Insufficient permissions (requires admin)`n")
        return false
    }

    ; Guard: Check resource exists
    if (resourcePath = "") {
        OutputDebug("✗ Resource path required`n")
        return false
    }

    ; Access granted
    OutputDebug("✓ Access granted to " resourcePath " for " userId "`n")
    return true
}

/**
* Business discount rules.
*/
ApplyDiscount(orderValue, memberTier, yearsAsMember, hasPromoCode) {
    ; Guard: Minimum order value
    if (orderValue < 100) {
        OutputDebug("✗ Minimum order value $100 required for discounts`n")
        return 0
    }

    ; Guard: Valid member tier
    validTiers := ["BRONZE", "SILVER", "GOLD", "PLATINUM"]
    isValidTier := false
    for tier in validTiers {
        if (memberTier = tier) {
            isValidTier := true
            break
        }
    }

    if (!isValidTier) {
        OutputDebug("✗ Invalid member tier`n")
        return 0
    }

    ; Calculate tier discount
    discount := 0
    if (memberTier = "PLATINUM") {
        discount := 0.20
    } else if (memberTier = "GOLD") {
        discount := 0.15
    } else if (memberTier = "SILVER") {
        discount := 0.10
    } else if (memberTier = "BRONZE") {
        discount := 0.05
    }

    ; Loyalty bonus
    if (yearsAsMember >= 5) {
        discount += 0.05
    }

    ; Promo code bonus
    if (hasPromoCode) {
        discount += 0.05
    }

    ; Cap discount at 30%
    if (discount > 0.30) {
        discount := 0.30
    }

    finalPrice := orderValue * (1 - discount)
    OutputDebug("✓ Discount applied: " Round(discount * 100) "%`n")
    OutputDebug("  Original: $" orderValue " -> Final: $" Round(finalPrice, 2) "`n")
    return discount
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Guard Clauses Examples`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_BasicGuardClauses()
    Example2_InputValidation()
    Example3_PreconditionChecking()
    Example4_ErrorHandling()
    Example5_RefactoringExamples()
    Example6_ValidationChains()
    Example7_RealWorldScenarios()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
