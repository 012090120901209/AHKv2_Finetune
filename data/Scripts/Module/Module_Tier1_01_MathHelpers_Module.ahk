#Requires AutoHotkey v2.1-alpha.17

/**
 * Module Tier 1 Example 01: Basic Math Helpers Module
 * 
 * This example demonstrates:
 * - Basic #Module declaration
 * - Exporting functions
 * - Private (non-exported) helper functions
 * - Module file organization
 * 
 * USAGE: This is a module file. Import it from another script.
 * See Module_Tier1_02_MathHelpers_Consumer.ahk for usage example.
 * 
 * @module MathHelpers
 */

; CRITICAL: Declare #Module BEFORE defining exports
#Module MathHelpers

/**
 * Add two numbers
 * @param a {Number} - First number
 * @param b {Number} - Second number
 * @returns {Number} - Sum of a and b
 */
Export Add(a, b) {
    return a + b
}

/**
 * Subtract b from a
 * @param a {Number} - Number to subtract from
 * @param b {Number} - Number to subtract
 * @returns {Number} - Difference
 */
Export Subtract(a, b) {
    return a - b
}

/**
 * Multiply two numbers
 * @param a {Number} - First number
 * @param b {Number} - Second number
 * @returns {Number} - Product
 */
Export Multiply(a, b) {
    return a * b
}

/**
 * Divide a by b
 * @param a {Number} - Dividend
 * @param b {Number} - Divisor
 * @returns {Number} - Quotient
 * @throws {Error} - If b is zero
 */
Export Divide(a, b) {
    if b = 0
        throw Error("Division by zero")
    return a / b
}

/**
 * Calculate power (a to the power of b)
 * @param a {Number} - Base
 * @param b {Number} - Exponent
 * @returns {Number} - Result
 */
Export Power(a, b) {
    return a ** b
}

/**
 * Calculate square of a number
 * @param n {Number} - Number to square
 * @returns {Number} - Square of n
 */
Export Square(n) {
    return Power(n, 2)  ; Uses Power function
}

/**
 * Calculate cube of a number
 * @param n {Number} - Number to cube
 * @returns {Number} - Cube of n
 */
Export Cube(n) {
    return Power(n, 3)
}

/**
 * Calculate square root
 * @param n {Number} - Number
 * @returns {Number} - Square root
 */
Export Sqrt(n) {
    return Sqrt(n)
}

/**
 * Check if number is even
 * @param n {Number} - Number to check
 * @returns {Boolean} - True if even
 */
Export IsEven(n) {
    return Mod(n, 2) = 0
}

/**
 * Check if number is odd
 * @param n {Number} - Number to check
 * @returns {Boolean} - True if odd
 */
Export IsOdd(n) {
    return !IsEven(n)
}

/**
 * Private helper function (NOT exported)
 * This function is only available within this module
 * @param n {Number} - Number to format
 * @returns {String} - Formatted number
 */
FormatNumber(n) {
    ; This is a private helper - consumers cannot access it
    return Format("{:.2f}", n)
}

/**
 * Get absolute value
 * @param n {Number} - Number
 * @returns {Number} - Absolute value
 */
Export Abs(n) {
    return Abs(n)
}

/**
 * Clamp a value between min and max
 * @param value {Number} - Value to clamp
 * @param min {Number} - Minimum value
 * @param max {Number} - Maximum value
 * @returns {Number} - Clamped value
 */
Export Clamp(value, min, max) {
    if value < min
        return min
    if value > max
        return max
    return value
}

/**
 * Linear interpolation between two values
 * @param a {Number} - Start value
 * @param b {Number} - End value
 * @param t {Number} - Interpolation factor (0-1)
 * @returns {Number} - Interpolated value
 */
Export Lerp(a, b, t) {
    return a + (b - a) * Clamp(t, 0, 1)
}
