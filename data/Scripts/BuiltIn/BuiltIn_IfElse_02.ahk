#Requires AutoHotkey v2.0

/**
 * ============================================================================
 * AutoHotkey v2 Control Flow - Nested If Statements
 * ============================================================================
 * 
 * This script demonstrates nested if statements in AutoHotkey v2.
 * It covers multi-level nesting, complex decision trees, and best practices
 * for maintaining readable nested conditions.
 * 
 * @file BuiltIn_IfElse_02.ahk
 * @author AHK v2 Examples Collection
 * @version 2.0.0
 * @date 2024-01-15
 * 
 * @description
 * Examples included:
 * 1. Basic nested if statements (2 levels)
 * 2. Deep nesting with multiple levels (3+ levels)
 * 3. Nested if with else clauses
 * 4. Mixed nested conditions with logical operators
 * 5. Nested loops with conditional breaks
 * 6. Refactoring nested ifs for better readability
 * 7. Real-world nested decision scenarios
 * 
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Basic Two-Level Nesting
; ============================================================================

/**
 * Demonstrates simple two-level nested if statements.
 * Shows how to check multiple related conditions.
 */
Example1_BasicNesting() {
    OutputDebug("=== Example 1: Basic Two-Level Nesting ===`n")

    ; User authentication with nested checks
    username := "admin"
    password := "secret123"

    if (username = "admin") {
        OutputDebug("Username validated`n")
        if (password = "secret123") {
            OutputDebug("Password correct - Access granted!`n")
        } else {
            OutputDebug("Password incorrect - Access denied`n")
        }
    } else {
        OutputDebug("Unknown username`n")
    }

    ; Age and income verification
    age := 25
    income := 50000

    if (age >= 18) {
        OutputDebug("Applicant is an adult (age: " age ")`n")
        if (income >= 30000) {
            OutputDebug("Income requirement met ($" income ") - Loan approved`n")
        } else {
            OutputDebug("Income too low ($" income ") - Loan denied`n")
        }
    } else {
        OutputDebug("Applicant is a minor - Loan denied`n")
    }

    ; File validation
    fileExists := true
    fileSize := 1024

    if (fileExists) {
        OutputDebug("File found`n")
        if (fileSize > 0) {
            OutputDebug("File has content (" fileSize " bytes)`n")
        } else {
            OutputDebug("File is empty`n")
        }
    } else {
        OutputDebug("File not found`n")
    }

    ; Temperature and humidity check
    temperature := 72
    humidity := 45

    if (temperature >= 68 and temperature <= 78) {
        OutputDebug("Temperature is comfortable (" temperature "°F)`n")
        if (humidity >= 30 and humidity <= 60) {
            OutputDebug("Humidity is ideal (" humidity "%) - Perfect conditions!`n")
        } else {
            OutputDebug("Humidity is outside ideal range (" humidity "%)`n")
        }
    } else {
        OutputDebug("Temperature is not comfortable (" temperature "°F)`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 2: Deep Nesting (3+ Levels)
; ============================================================================

/**
 * Demonstrates deep nesting with three or more levels.
 * Shows complexity management in multi-level decisions.
 */
Example2_DeepNesting() {
    OutputDebug("=== Example 2: Deep Nesting (3+ Levels) ===`n")

    ; Multi-tier access control
    isLoggedIn := true
    userRole := "manager"
    department := "sales"
    seniority := 5

    if (isLoggedIn) {
        OutputDebug("User authenticated`n")
        if (userRole = "manager") {
            OutputDebug("Manager role confirmed`n")
            if (department = "sales") {
                OutputDebug("Sales department verified`n")
                if (seniority >= 3) {
                    OutputDebug("Senior manager - Full access granted`n")
                } else {
                    OutputDebug("Junior manager - Limited access`n")
                }
            } else {
                OutputDebug("Not in sales department - Department access only`n")
            }
        } else {
            OutputDebug("Regular user - Basic access`n")
        }
    } else {
        OutputDebug("Not logged in - Access denied`n")
    }

    ; Shipping cost calculation
    weight := 15
    distance := 500
    isPremium := true
    isFragile := false

    if (weight <= 20) {
        OutputDebug("Weight acceptable (" weight " lbs)`n")
        if (distance <= 1000) {
            OutputDebug("Distance within range (" distance " miles)`n")
            if (isPremium) {
                OutputDebug("Premium customer - Free shipping!`n")
                if (isFragile) {
                    OutputDebug("Fragile item - Special handling fee: $5`n")
                }
            } else {
                OutputDebug("Standard shipping: $" (distance * 0.01 + weight * 0.5) "`n")
            }
        } else {
            OutputDebug("Long distance - Additional charges apply`n")
        }
    } else {
        OutputDebug("Overweight package - Special handling required`n")
    }

    ; Game character advancement
    level := 15
    experience := 12500
    hasCompletedQuest := true
    inventorySpace := 50

    if (level >= 10) {
        if (experience >= 10000) {
            if (hasCompletedQuest) {
                if (inventorySpace >= 30) {
                    OutputDebug("Level up available! New abilities unlocked.`n")
                } else {
                    OutputDebug("Clear inventory space before leveling up`n")
                }
            } else {
                OutputDebug("Complete the main quest first`n")
            }
        } else {
            OutputDebug("Need more experience: " experience "/10000`n")
        }
    } else {
        OutputDebug("Reach level 10 to unlock advancement`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 3: Nested If with Else Clauses
; ============================================================================

/**
 * Demonstrates nested if statements with else branches at each level.
 * Shows complete decision trees with all paths covered.
 */
Example3_NestedIfElse() {
    OutputDebug("=== Example 3: Nested If with Else Clauses ===`n")

    ; Complete decision tree for discount calculation
    isMember := true
    yearsAsMember := 3
    purchaseAmount := 150

    if (isMember) {
        OutputDebug("Member status verified`n")
        if (yearsAsMember >= 5) {
            discount := 0.25
            OutputDebug("Platinum member (5+ years) - 25% discount`n")
        } else if (yearsAsMember >= 2) {
            discount := 0.15
            OutputDebug("Gold member (2-4 years) - 15% discount`n")
        } else {
            discount := 0.10
            OutputDebug("Silver member (<2 years) - 10% discount`n")
        }

        if (purchaseAmount >= 100) {
            discount += 0.05
            OutputDebug("Purchase bonus - Additional 5% discount`n")
        }

        finalPrice := purchaseAmount * (1 - discount)
        OutputDebug("Final price: $" Round(finalPrice, 2) " (Original: $" purchaseAmount ")`n")
    } else {
        OutputDebug("Non-member pricing`n")
        if (purchaseAmount >= 200) {
            discount := 0.05
            finalPrice := purchaseAmount * 0.95
            OutputDebug("New customer bonus - 5% discount`n")
            OutputDebug("Final price: $" Round(finalPrice, 2) "`n")
        } else {
            OutputDebug("Final price: $" purchaseAmount " (No discounts)`n")
        }
    }

    ; Weather-based activity recommendation
    temperature := 85
    isRaining := false
    windSpeed := 15

    if (temperature >= 80) {
        OutputDebug("Hot weather (" temperature "°F)`n")
        if (isRaining) {
            OutputDebug("Indoor activities recommended (hot and rainy)`n")
        } else {
            if (windSpeed < 20) {
                OutputDebug("Perfect for swimming or water sports!`n")
            } else {
                OutputDebug("Too windy for water activities (wind: " windSpeed " mph)`n")
            }
        }
    } else if (temperature >= 60) {
        OutputDebug("Mild weather (" temperature "°F)`n")
        if (isRaining) {
            OutputDebug("Light outdoor activities with rain gear`n")
        } else {
            OutputDebug("Great for hiking or cycling!`n")
        }
    } else {
        OutputDebug("Cold weather (" temperature "°F)`n")
        if (isRaining) {
            OutputDebug("Stay indoors - cold and wet`n")
        } else {
            OutputDebug("Bundle up for outdoor activities`n")
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 4: Mixed Nested Conditions with Logical Operators
; ============================================================================

/**
 * Demonstrates combining nested ifs with logical operators.
 * Shows when to nest vs when to use AND/OR.
 */
Example4_MixedNestedConditions() {
    OutputDebug("=== Example 4: Mixed Nested Conditions ===`n")

    ; Complex validation scenario
    userAge := 22
    hasID := true
    hasTicket := true
    eventCapacity := 95
    currentAttendees := 90
    isVIP := false

    if (userAge >= 18 and hasID) {
        OutputDebug("Age and ID verified (Age: " userAge ")`n")
        if (hasTicket or isVIP) {
            OutputDebug("Valid entry credentials`n")
            if (currentAttendees < eventCapacity or isVIP) {
                OutputDebug("Entry granted! Welcome to the event.`n")
                currentAttendees++
            } else {
                OutputDebug("Event at capacity - Entry denied`n")
            }
        } else {
            OutputDebug("No ticket or VIP status - Purchase ticket first`n")
        }
    } else {
        if (!hasID) {
            OutputDebug("ID required for entry`n")
        }
        if (userAge < 18) {
            OutputDebug("Must be 18+ to attend`n")
        }
    }

    ; System resource check
    cpuUsage := 75
    memoryUsage := 60
    diskSpace := 15
    isSystemCritical := false

    if (cpuUsage < 80 and memoryUsage < 80) {
        OutputDebug("System resources normal (CPU: " cpuUsage "%, RAM: " memoryUsage "%)`n")
        if (diskSpace > 20 or !isSystemCritical) {
            OutputDebug("Can proceed with operation`n")
        } else {
            OutputDebug("Critical system - insufficient disk space`n")
        }
    } else {
        OutputDebug("High resource usage detected`n")
        if (cpuUsage >= 80) {
            OutputDebug("High CPU usage: " cpuUsage "%`n")
        }
        if (memoryUsage >= 80) {
            OutputDebug("High memory usage: " memoryUsage "%`n")
        }
        OutputDebug("Defer non-critical operations`n")
    }

    ; Email validation and processing
    emailAddress := "user@example.com"
    hasSubject := true
    bodyLength := 150
    hasAttachments := true
    attachmentSize := 5
    maxAttachmentSize := 10

    if (InStr(emailAddress, "@") and InStr(emailAddress, ".")) {
        OutputDebug("Email address format valid`n")
        if (hasSubject and bodyLength > 0) {
            OutputDebug("Email has subject and content`n")
            if (hasAttachments) {
                if (attachmentSize <= maxAttachmentSize) {
                    OutputDebug("Email ready to send (with attachments)`n")
                } else {
                    OutputDebug("Attachments too large (" attachmentSize "MB > " maxAttachmentSize "MB)`n")
                }
            } else {
                OutputDebug("Email ready to send (no attachments)`n")
            }
        } else {
            OutputDebug("Email missing subject or content`n")
        }
    } else {
        OutputDebug("Invalid email address format: " emailAddress "`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 5: Nested Validation Chains
; ============================================================================

/**
 * Demonstrates using nested ifs for sequential validation.
 * Shows early exit patterns and validation chains.
 */
Example5_NestedValidation() {
    OutputDebug("=== Example 5: Nested Validation Chains ===`n")

    ; Form validation
    formData := Map(
        "username", "john_doe",
        "email", "john@example.com",
        "password", "P@ssw0rd123",
        "age", "25",
        "country", "USA"
    )

    isValid := true

    if (formData.Has("username") and formData["username"] != "") {
        if (StrLen(formData["username"]) >= 3) {
            OutputDebug("✓ Username valid: " formData["username"] "`n")

            if (formData.Has("email") and InStr(formData["email"], "@")) {
                OutputDebug("✓ Email valid: " formData["email"] "`n")

                if (formData.Has("password") and StrLen(formData["password"]) >= 8) {
                    if (RegExMatch(formData["password"], "[A-Z]") and RegExMatch(formData["password"], "[0-9]")) {
                        OutputDebug("✓ Password meets requirements`n")

                        if (formData.Has("age") and Integer(formData["age"]) >= 18) {
                            OutputDebug("✓ Age verified: " formData["age"] "`n")
                            OutputDebug("✓✓✓ Form validation passed! ✓✓✓`n")
                        } else {
                            OutputDebug("✗ Age must be 18 or older`n")
                            isValid := false
                        }
                    } else {
                        OutputDebug("✗ Password must contain uppercase and numbers`n")
                        isValid := false
                    }
                } else {
                    OutputDebug("✗ Password must be at least 8 characters`n")
                    isValid := false
                }
            } else {
                OutputDebug("✗ Invalid email address`n")
                isValid := false
            }
        } else {
            OutputDebug("✗ Username must be at least 3 characters`n")
            isValid := false
        }
    } else {
        OutputDebug("✗ Username is required`n")
        isValid := false
    }

    ; Credit card validation
    cardNumber := "4532123456789012"
    expiryMonth := 12
    expiryYear := 2025
    cvv := "123"
    currentYear := 2024

    if (StrLen(cardNumber) = 16 and IsNumber(cardNumber)) {
        OutputDebug("Card number format valid`n")
        if (expiryYear > currentYear or (expiryYear = currentYear and expiryMonth >= A_Mon)) {
            OutputDebug("Card not expired (" expiryMonth "/" expiryYear ")`n")
            if (StrLen(cvv) = 3 and IsNumber(cvv)) {
                OutputDebug("CVV valid - Payment authorized`n")
            } else {
                OutputDebug("Invalid CVV`n")
            }
        } else {
            OutputDebug("Card has expired`n")
        }
    } else {
        OutputDebug("Invalid card number`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 6: Refactoring Nested Ifs
; ============================================================================

/**
 * Demonstrates refactoring deeply nested ifs for better readability.
 * Shows before and after patterns.
 */
Example6_RefactoringNestedIfs() {
    OutputDebug("=== Example 6: Refactoring Nested Ifs ===`n")

    OutputDebug("--- Before Refactoring (Deep Nesting) ---`n")

    ; Original deeply nested version
    score := 85
    attendance := 90
    homeworkComplete := true

    if (score >= 60) {
        if (attendance >= 80) {
            if (homeworkComplete) {
                OutputDebug("Student passes (nested approach)`n")
            }
        }
    }

    OutputDebug("`n--- After Refactoring (Guard Clauses) ---`n")

    ; Refactored with guard clauses (early returns)
    if (score < 60) {
        OutputDebug("Failed: Score too low (" score ")`n")
    } else if (attendance < 80) {
        OutputDebug("Failed: Poor attendance (" attendance "%)`n")
    } else if (!homeworkComplete) {
        OutputDebug("Failed: Incomplete homework`n")
    } else {
        OutputDebug("Student passes (guard clause approach)`n")
    }

    OutputDebug("`n--- Before: Complex Nested Logic ---`n")

    ; Complex nested original
    userType := "premium"
    balance := 1000
    requestedAmount := 500
    hasOverdraft := true

    if (userType = "premium" or userType = "business") {
        if (balance >= requestedAmount) {
            OutputDebug("Withdrawal approved (sufficient balance)`n")
        } else {
            if (hasOverdraft) {
                if (balance + 1000 >= requestedAmount) {
                    OutputDebug("Withdrawal approved (using overdraft)`n")
                } else {
                    OutputDebug("Withdrawal denied (exceeds overdraft)`n")
                }
            } else {
                OutputDebug("Withdrawal denied (insufficient balance, no overdraft)`n")
            }
        }
    } else {
        OutputDebug("Withdrawal denied (account type not eligible)`n")
    }

    OutputDebug("`n--- After: Flattened with Early Exits ---`n")

    ; Flattened version
    if (userType != "premium" and userType != "business") {
        OutputDebug("Denied: Account type not eligible`n")
    } else if (balance >= requestedAmount) {
        OutputDebug("Approved: Sufficient balance`n")
    } else if (!hasOverdraft) {
        OutputDebug("Denied: Insufficient balance, no overdraft`n")
    } else if (balance + 1000 >= requestedAmount) {
        OutputDebug("Approved: Using overdraft protection`n")
    } else {
        OutputDebug("Denied: Exceeds overdraft limit`n")
    }

    OutputDebug("`n")
}

; ============================================================================
; Example 7: Real-World Nested Decision Scenarios
; ============================================================================

/**
 * Demonstrates practical real-world nested decision scenarios.
 * Shows complex business logic implementations.
 */
Example7_RealWorldScenarios() {
    OutputDebug("=== Example 7: Real-World Scenarios ===`n")

    ; E-commerce order processing
    orderTotal := 250
    customerTier := "gold"
    isInStock := true
    deliveryRegion := "local"
    paymentMethod := "credit"

    if (isInStock) {
        OutputDebug("Items in stock - Processing order`n")
        if (paymentMethod = "credit" or paymentMethod = "debit") {
            OutputDebug("Payment method accepted`n")
            if (customerTier = "platinum") {
                discount := 0.20
                shipping := 0
                OutputDebug("Platinum tier: 20% discount, free shipping`n")
            } else if (customerTier = "gold") {
                discount := 0.15
                if (deliveryRegion = "local") {
                    shipping := 0
                    OutputDebug("Gold tier: 15% discount, free local shipping`n")
                } else {
                    shipping := 10
                    OutputDebug("Gold tier: 15% discount, $10 shipping`n")
                }
            } else {
                discount := 0
                if (orderTotal >= 100) {
                    shipping := 0
                    OutputDebug("Standard tier: Free shipping on $100+ orders`n")
                } else {
                    shipping := 15
                    OutputDebug("Standard tier: $15 shipping`n")
                }
            }

            finalTotal := (orderTotal * (1 - discount)) + shipping
            OutputDebug("Order total: $" Round(finalTotal, 2) "`n")
        } else {
            OutputDebug("Payment method not supported`n")
        }
    } else {
        OutputDebug("Out of stock - Cannot process order`n")
    }

    ; Healthcare appointment scheduling
    patientAge := 65
    isEmergency := false
    hasInsurance := true
    preferredDoctor := "Dr. Smith"
    doctorAvailable := true

    if (isEmergency) {
        OutputDebug("EMERGENCY - Immediate care required`n")
    } else {
        if (hasInsurance) {
            OutputDebug("Insurance verified`n")
            if (patientAge >= 65) {
                OutputDebug("Senior patient - Priority scheduling`n")
                if (doctorAvailable) {
                    OutputDebug("Appointment with " preferredDoctor " - Tomorrow 9 AM`n")
                } else {
                    OutputDebug("Appointment with available specialist - Tomorrow 10 AM`n")
                }
            } else {
                if (doctorAvailable) {
                    OutputDebug("Standard appointment - Next week`n")
                } else {
                    OutputDebug("Next available appointment - 2 weeks`n")
                }
            }
        } else {
            OutputDebug("No insurance - Please contact billing`n")
        }
    }

    OutputDebug("`n")
}

; ============================================================================
; Helper Functions
; ============================================================================

/**
 * Checks if a string contains only numeric characters.
 */
IsNumber(str) {
    return RegExMatch(str, "^\d+$")
}

; ============================================================================
; Main Execution
; ============================================================================

Main() {
    OutputDebug("`n" Format("{:=<70}", "") "`n")
    OutputDebug("AutoHotkey v2 - Nested If Statements Examples`n")
    OutputDebug(Format("{:=<70}", "") "`n`n")

    Example1_BasicNesting()
    Example2_DeepNesting()
    Example3_NestedIfElse()
    Example4_MixedNestedConditions()
    Example5_NestedValidation()
    Example6_RefactoringNestedIfs()
    Example7_RealWorldScenarios()

    OutputDebug(Format("{:=<70}", "") "`n")
    OutputDebug("All examples completed!`n")
    OutputDebug(Format("{:=<70}", "") "`n")
}

Main()
