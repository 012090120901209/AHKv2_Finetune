#Requires AutoHotkey v2.0
/**
 * BuiltIn_StrLen_02_Validation.ahk
 *
 * DESCRIPTION:
 * Using StrLen() for input validation and data verification
 *
 * FEATURES:
 * - Form field validation
 * - Username/password requirements
 * - Text length limits
 * - Dynamic validation feedback
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - StrLen()
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - StrLen() in validation functions
 * - Class-based validators
 * - Map for validation rules
 * - Try/Catch error handling
 *
 * LEARNING POINTS:
 * 1. StrLen() is essential for validation
 * 2. Combine with other checks for robust validation
 * 3. Provide clear error messages with length info
 * 4. Use in class methods for reusable validators
 */

; ============================================================
; Example 1: Simple Field Validators
; ============================================================

/**
 * Validate username length
 *
 * @param {String} username - Username to validate
 * @returns {Boolean} - True if valid
 */
ValidateUsername(username) {
    length := StrLen(username)

    if (length < 3) {
        MsgBox("Username too short (minimum 3 characters)`n"
             . "Current length: " length,
             "Validation Error", "Icon!")
        return false
    }

    if (length > 20) {
        MsgBox("Username too long (maximum 20 characters)`n"
             . "Current length: " length,
             "Validation Error", "Icon!")
        return false
    }

    return true
}

; Test various usernames
testUsernames := ["ab", "validuser", "ThisUsernameIsWayTooLongForOurSystem"]

for username in testUsernames {
    isValid := ValidateUsername(username)
    result := isValid ? "✓ Valid" : "✗ Invalid"
    MsgBox("Username: '" username "'`n"
         . "Length: " StrLen(username) "`n"
         . "Status: " result,
         "Username Validation", "Icon!")
}

; ============================================================
; Example 2: Form Validation Class
; ============================================================

/**
 * Comprehensive form validator
 */
class FormValidator {
    static rules := Map(
        "username", {min: 3, max: 20},
        "password", {min: 8, max: 50},
        "email", {min: 5, max: 100},
        "bio", {min: 0, max: 500}
    )

    /**
     * Validate field against rules
     *
     * @param {String} fieldName - Field identifier
     * @param {String} value - Field value
     * @returns {Map} - Validation result
     */
    static Validate(fieldName, value) {
        if (!this.rules.Has(fieldName))
            throw Error("Unknown field: " fieldName)

        rule := this.rules[fieldName]
        length := StrLen(value)

        result := Map(
            "valid", true,
            "length", length,
            "message", ""
        )

        if (length < rule.min) {
            result["valid"] := false
            result["message"] := "Minimum " rule.min " characters required (current: " length ")"
        } else if (length > rule.max) {
            result["valid"] := false
            result["message"] := "Maximum " rule.max " characters allowed (current: " length ")"
        } else {
            result["message"] := "Valid (" length " characters)"
        }

        return result
    }

    /**
     * Validate all form fields
     *
     * @param {Map} formData - Field names and values
     * @returns {Map} - Validation results
     */
    static ValidateForm(formData) {
        results := Map()

        for fieldName, value in formData {
            results[fieldName] := this.Validate(fieldName, value)
        }

        return results
    }
}

; Test form validation
formData := Map(
    "username", "john",
    "password", "secret123",
    "email", "john@example.com",
    "bio", "Software developer passionate about automation"
)

results := FormValidator.ValidateForm(formData)

output := "FORM VALIDATION RESULTS:`n`n"
allValid := true

for fieldName, result in results {
    status := result["valid"] ? "✓" : "✗"
    output .= status " " fieldName ": " result["message"] "`n"

    if (!result["valid"])
        allValid := false
}

output .= "`n" (allValid ? "Form is valid!" : "Form has errors!")

MsgBox(output, "Form Validation", "Icon!")

; ============================================================
; Example 3: Text Truncation Helper
; ============================================================

/**
 * Truncate text to specified length
 *
 * @param {String} text - Text to truncate
 * @param {Integer} maxLength - Maximum length
 * @param {String} ellipsis - Suffix for truncated text
 * @returns {String} - Truncated text
 */
TruncateText(text, maxLength := 50, ellipsis := "...") {
    if (StrLen(text) <= maxLength)
        return text

    ; Account for ellipsis length
    truncateAt := maxLength - StrLen(ellipsis)

    if (truncateAt <= 0)
        return SubStr(text, 1, maxLength)

    return SubStr(text, 1, truncateAt) . ellipsis
}

longText := "This is a very long text that needs to be truncated because it exceeds the maximum allowed length for display purposes"

MsgBox("Original (" StrLen(longText) " chars):`n"
     . longText "`n`n"
     . "Truncated to 50:`n"
     . TruncateText(longText, 50) "`n`n"
     . "Truncated to 30:`n"
     . TruncateText(longText, 30),
     "Text Truncation", "Icon!")

; ============================================================
; Example 4: Real-time Character Counter
; ============================================================

/**
 * Character counter with limit
 */
class CharacterCounter {
    static ShowCounter(text, limit) {
        length := StrLen(text)
        remaining := limit - length
        percentage := Round((length / limit) * 100, 1)

        if (remaining < 0) {
            status := "⚠ EXCEEDED LIMIT"
            color := "Red"
        } else if (remaining < limit * 0.1) {
            status := "⚠ Almost at limit"
            color := "Orange"
        } else {
            status := "✓ Within limit"
            color := "Green"
        }

        return "Characters: " length " / " limit "`n"
             . "Remaining: " remaining "`n"
             . "Usage: " percentage "%`n"
             . "Status: " status
    }
}

; Simulate tweet composer (280 character limit)
tweet := "Just discovered AutoHotkey v2! The syntax improvements and new features are amazing. Can't wait to automate all my workflows! #AutoHotkey #Automation"

MsgBox("Tweet Draft:`n'" tweet "'`n`n"
     . CharacterCounter.ShowCounter(tweet, 280),
     "Tweet Character Counter", "Icon!")

; Simulate SMS (160 character limit)
sms := "Meeting at 3pm today. Don't forget to bring the documents!"

MsgBox("SMS Draft:`n'" sms "'`n`n"
     . CharacterCounter.ShowCounter(sms, 160),
     "SMS Character Counter", "Icon!")

; ============================================================
; Example 5: Multi-Field Validation
; ============================================================

/**
 * Validate multiple related fields
 *
 * @param {Map} data - Form data
 * @returns {Array} - Array of error messages
 */
ValidateRegistrationForm(data) {
    errors := []

    ; Username validation
    if (StrLen(data["username"]) < 3)
        errors.Push("Username must be at least 3 characters")
    else if (StrLen(data["username"]) > 20)
        errors.Push("Username must not exceed 20 characters")

    ; Password validation
    if (StrLen(data["password"]) < 8)
        errors.Push("Password must be at least 8 characters")

    ; Password confirmation
    if (data["password"] != data["confirmPassword"])
        errors.Push("Passwords do not match")

    ; Email validation (basic length check)
    if (StrLen(data["email"]) < 5)
        errors.Push("Email address is too short")

    ; First name
    if (StrLen(data["firstName"]) < 1)
        errors.Push("First name is required")

    ; Last name
    if (StrLen(data["lastName"]) < 1)
        errors.Push("Last name is required")

    return errors
}

; Test registration form
registration := Map(
    "username", "jd",
    "password", "pass",
    "confirmPassword", "pass",
    "email", "j@e",
    "firstName", "John",
    "lastName", "Doe"
)

errors := ValidateRegistrationForm(registration)

if (errors.Length > 0) {
    output := "VALIDATION ERRORS:`n`n"
    for error in errors
        output .= "• " error "`n"
} else {
    output := "✓ All fields are valid!"
}

MsgBox(output, "Registration Validation", "Icon!")

; ============================================================
; Reference Information
; ============================================================

info := "
(
VALIDATION WITH STRLEN():

Common Validation Patterns:

1. Minimum Length:
   if (StrLen(text) < minLength)
       return false

2. Maximum Length:
   if (StrLen(text) > maxLength)
       return false

3. Range Validation:
   length := StrLen(text)
   if (length < min || length > max)
       return false

4. Empty Check:
   if (StrLen(text) = 0)
       return false

Best Practices:
• Always provide clear error messages
• Include current length in feedback
• Use constants for magic numbers
• Validate early and often
• Combine with other validation checks
• Consider Unicode characters

Validation Use Cases:
✓ Form field validation
✓ Password requirements
✓ Username constraints
✓ Text area limits
✓ API payload size checks
✓ Database field constraints
)"

MsgBox(info, "Validation Reference", "Icon!")
