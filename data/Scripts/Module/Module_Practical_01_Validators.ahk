#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

/**
 * Practical Module Example 01: Validation Module
 * 
 * This demonstrates a real-world validation module for:
 * - Email validation
 * - URL validation
 * - Password strength
 * - Form field validation
 * - Custom validation rules
 * 
 * @module Validators
 */

#Module Validators

/**
 * Main Validator class with common validation methods
 * @class Validator
 * @export
 */
Export class Validator {
    /**
     * Validate email address
     * @param email {String} - Email to validate
     * @returns {Boolean} - True if valid
     */
    static IsEmail(email) {
        pattern := "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$"
        return RegExMatch(email, pattern) > 0
    }

    /**
     * Validate URL
     * @param url {String} - URL to validate
     * @returns {Boolean} - True if valid
     */
    static IsURL(url) {
        pattern := "^https?://[^\s/$.?#].[^\s]*$"
        return RegExMatch(url, pattern) > 0
    }

    /**
     * Validate numeric value
     * @param value {Any} - Value to check
     * @returns {Boolean} - True if numeric
     */
    static IsNumeric(value) {
        return IsNumber(value)
    }

    /**
     * Validate integer
     * @param value {Any} - Value to check
     * @returns {Boolean} - True if integer
     */
    static IsInteger(value) {
        return IsInteger(value)
    }

    /**
     * Check if value is in range
     * @param value {Number} - Value to check
     * @param min {Number} - Minimum value (inclusive)
     * @param max {Number} - Maximum value (inclusive)
     * @returns {Boolean} - True if in range
     */
    static IsInRange(value, min, max) {
        if !IsNumber(value)
            return false
        return value >= min && value <= max
    }

    /**
     * Validate minimum length
     * @param text {String} - Text to validate
     * @param length {Number} - Minimum length
     * @returns {Boolean} - True if meets minimum
     */
    static MinLength(text, length) {
        return StrLen(text) >= length
    }

    /**
     * Validate maximum length
     * @param text {String} - Text to validate
     * @param length {Number} - Maximum length
     * @returns {Boolean} - True if under maximum
     */
    static MaxLength(text, length) {
        return StrLen(text) <= length
    }

    /**
     * Validate pattern match
     * @param text {String} - Text to validate
     * @param pattern {String} - RegEx pattern
     * @returns {Boolean} - True if matches
     */
    static Matches(text, pattern) {
        return RegExMatch(text, pattern) > 0
    }

    /**
     * Validate required field (not empty)
     * @param value {String} - Value to check
     * @returns {Boolean} - True if not empty
     */
    static Required(value) {
        return value != "" && value != unset
    }

    /**
     * Validate phone number (US format)
     * @param phone {String} - Phone number
     * @returns {Boolean} - True if valid
     */
    static IsPhone(phone) {
        ; Accepts: (123) 456-7890, 123-456-7890, 1234567890
        pattern := "^(\(?\d{3}\)?[\s.-]?)?\d{3}[\s.-]?\d{4}$"
        return RegExMatch(phone, pattern) > 0
    }

    /**
     * Validate credit card number (basic)
     * @param number {String} - Card number
     * @returns {Boolean} - True if valid format
     */
    static IsCreditCard(number) {
        ; Remove spaces and dashes
        number := StrReplace(StrReplace(number, " ", ""), "-", "")
        ; Check if 13-19 digits
        return RegExMatch(number, "^\d{13,19}$") > 0
    }

    /**
     * Validate date format (YYYY-MM-DD)
     * @param date {String} - Date string
     * @returns {Boolean} - True if valid format
     */
    static IsDate(date) {
        pattern := "^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$"
        return RegExMatch(date, pattern) > 0
    }

    /**
     * Check password strength
     * @param password {String} - Password to check
     * @returns {Object} - Strength analysis
     */
    static PasswordStrength(password) {
        strength := 0
        feedback := []

        ; Length check
        if StrLen(password) >= 8 {
            strength += 25
        } else {
            feedback.Push("At least 8 characters needed")
        }

        ; Uppercase check
        if RegExMatch(password, "[A-Z]") {
            strength += 25
        } else {
            feedback.Push("Add uppercase letters")
        }

        ; Lowercase check
        if RegExMatch(password, "[a-z]") {
            strength += 25
        } else {
            feedback.Push("Add lowercase letters")
        }

        ; Number check
        if RegExMatch(password, "\d") {
            strength += 15
        } else {
            feedback.Push("Add numbers")
        }

        ; Special character check
        if RegExMatch(password, "[!@#$%^&*(),.?:{}|<>]") {
            strength += 10
        } else {
            feedback.Push("Add special characters")
        }

        ; Determine level
        level := "Weak"
        if strength >= 75
            level := "Strong"
        else if strength >= 50
            level := "Medium"

        return {
            strength: strength,
            level: level,
            feedback: feedback
        }
    }
}

/**
 * Validation rule builder
 * @param test {Func} - Test function
 * @param message {String} - Error message
 * @returns {Object} - Validation rule
 * @export
 */
Export Rule(test, message) {
    return {
        test: test,
        message: message
    }
}

/**
 * Validate value against multiple rules
 * @param value {Any} - Value to validate
 * @param rules* {Object} - Validation rules
 * @returns {Object} - Validation result
 * @export
 */
Export Validate(value, rules*) {
    errors := []

    for rule in rules {
        if !rule.test(value)
            errors.Push(rule.message)
    }

    return {
        isValid: errors.Length = 0,
        errors: errors,
        value: value
    }
}

/**
 * Form validator class for multiple fields
 * @class FormValidator
 * @export
 */
Export class FormValidator {
    fields := Map()
    errors := Map()

    /**
     * Add field with validation rules
     * @param name {String} - Field name
     * @param value {Any} - Field value
     * @param rules* {Object} - Validation rules
     */
    AddField(name, value, rules*) {
        this.fields[name] := {
            value: value,
            rules: rules
        }
    }

    /**
     * Validate all fields
     * @returns {Boolean} - True if all valid
     */
    ValidateAll() {
        this.errors := Map()
        isValid := true

        for name, field in this.fields {
            fieldErrors := []

            for rule in field.rules {
                if !rule.test(field.value)
                    fieldErrors.Push(rule.message)
            }

            if fieldErrors.Length > 0 {
                this.errors[name] := fieldErrors
                isValid := false
            }
        }

        return isValid
    }

    /**
     * Get errors for specific field
     * @param name {String} - Field name
     * @returns {Array} - Array of error messages
     */
    GetFieldErrors(name) {
        return this.errors.Has(name) ? this.errors[name] : []
    }

    /**
     * Get all errors
     * @returns {Map} - Map of field names to error arrays
     */
    GetAllErrors() {
        return this.errors
    }

    /**
     * Check if field has errors
     * @param name {String} - Field name
     * @returns {Boolean} - True if has errors
     */
    HasErrors(name) {
        return this.errors.Has(name) && this.errors[name].Length > 0
    }
}

/**
 * Common validation rule presets
 * @class Rules
 * @export
 */
Export class Rules {
    /**
     * Required field rule
     * @returns {Object} - Validation rule
     */
    static Required() {
        return Rule(
            (v) => Validator.Required(v),
            "This field is required"
        )
    }

    /**
     * Email validation rule
     * @returns {Object} - Validation rule
     */
    static Email() {
        return Rule(
            (v) => Validator.IsEmail(v),
            "Must be a valid email address"
        )
    }

    /**
     * Minimum length rule
     * @param length {Number} - Minimum length
     * @returns {Object} - Validation rule
     */
    static MinLength(length) {
        return Rule(
            (v) => Validator.MinLength(v, length),
            "Must be at least " length " characters"
        )
    }

    /**
     * Maximum length rule
     * @param length {Number} - Maximum length
     * @returns {Object} - Validation rule
     */
    static MaxLength(length) {
        return Rule(
            (v) => Validator.MaxLength(v, length),
            "Must be no more than " length " characters"
        )
    }

    /**
     * Strong password rule
     * @returns {Object} - Validation rule
     */
    static StrongPassword() {
        return Rule(
            (v) => Validator.PasswordStrength(v).strength >= 75,
            "Password must be strong (8+ chars, uppercase, lowercase, number, special)"
        )
    }

    /**
     * Phone number rule
     * @returns {Object} - Validation rule
     */
    static Phone() {
        return Rule(
            (v) => Validator.IsPhone(v),
            "Must be a valid phone number"
        )
    }

    /**
     * Range validation rule
     * @param min {Number} - Minimum value
     * @param max {Number} - Maximum value
     * @returns {Object} - Validation rule
     */
    static Range(min, max) {
        return Rule(
            (v) => Validator.IsInRange(v, min, max),
            "Must be between " min " and " max
        )
    }
}
