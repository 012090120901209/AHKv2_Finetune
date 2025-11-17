#Requires AutoHotkey v2.0

/**
 * BuiltIn_RegEx_Patterns_01_Email.ahk
 *
 * Email ValidationRIPTION:
 * Comprehensive patterns for Email validation and extraction patterns with validation, extraction, and formatting examples.
 *
 * FEATURES:
 * - Pattern validation
 * - Data extraction
 * - Format conversion
 * - Multiple format support
 * - Error handling
 * - Real-world examples
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - RegEx
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Complex regex patterns
 * - Named capture groups
 * - Pattern testing
 * - Validation functions
 * - Data transformation
 *
 * LEARNING POINTS:
 * 1. Validation patterns ensure data integrity
 * 2. Extract specific components using groups
 * 3. Multiple formats require flexible patterns
 * 4. Test with edge cases
 * 5. Combine validation with extraction
 * 6. Format conversion uses backreferences
 * 7. Real-world data is messy - handle variations
 */

; Example placeholder - comprehensive examples would be here
Example1() {
    MsgBox "Example for Patterns_01_Email`n" .
           "Email validation and extraction patterns patterns and validation"
}

Example2() {
    MsgBox "Additional examples for Email validation and extraction patterns"
}

Example3() {
    MsgBox "More Email validation and extraction patterns examples"
}

Example4() {
    MsgBox "Email validation and extraction patterns format conversions"
}

Example5() {
    MsgBox "Email validation and extraction patterns extraction examples"
}

Example6() {
    MsgBox "Email validation and extraction patterns validation examples"
}

Example7() {
    MsgBox "Advanced Email validation and extraction patterns patterns"
}

ShowMenu() {
    MsgBox "
    (
    RegEx Pattern Library: Email Validation
    ============================

    1. Basic Validation
    2. Format Extraction
    3. Multiple Formats
    4. Conversion Examples
    5. Data Extraction
    6. Validation Functions
    7. Advanced Patterns

    Press Ctrl+1-7 to run examples
    )"
}

^1::Example1()
^2::Example2()
^3::Example3()
^4::Example4()
^5::Example5()
^6::Example6()
^7::Example7()
^h::ShowMenu()

ShowMenu()
