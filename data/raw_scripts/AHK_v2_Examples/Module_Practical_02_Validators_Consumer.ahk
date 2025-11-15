#Requires AutoHotkey v2.1-alpha.17
/**
 * Practical Module Example 02: Using Validators Module
 *
 * Demonstrates real-world form and data validation
 *
 * USAGE: Run this file directly
 *
 * @requires Module_Practical_01_Validators.ahk
 */

#SingleInstance Force

Import { Validator, Validate, Rule, FormValidator, Rules } from Validators

; ============================================================
; Example 1: Simple Email Validation
; ============================================================

emails := [
    "user@example.com",
    "invalid.email",
    "test@domain.co.uk",
    "@nodomain.com",
    "valid.email+tag@test.com"
]

output := "Email Validation:`n`n"
for email in emails {
    isValid := Validator.IsEmail(email)
    output .= email " → " (isValid ? "✓ Valid" : "✗ Invalid") "`n"
}

MsgBox(output, "Email Validation", "Icon!")

; ============================================================
; Example 2: Password Strength Check
; ============================================================

passwords := [
    "weak",
    "Password123",
    "Str0ng!Pass",
    "VeryS3cure!@#Password"
]

passOutput := "Password Strength Analysis:`n`n"
for password in passwords {
    result := Validator.PasswordStrength(password)
    passOutput .= "'" password "' → " result.level " (" result.strength "%)`n"

    if result.feedback.Length > 0 {
        for tip in result.feedback
            passOutput .= "  • " tip "`n"
    }
    passOutput .= "`n"
}

MsgBox(passOutput, "Password Strength", "Icon!")

; ============================================================
; Example 3: Using Validation Rules
; ============================================================

; Test username with custom rules
username := "ab"

result := Validate(username,
    Rule((v) => Validator.MinLength(v, 3), "Username must be at least 3 characters"),
    Rule((v) => Validator.MaxLength(v, 20), "Username must be no more than 20 characters"),
    Rule((v) => Validator.Matches(v, "^[a-zA-Z0-9_]+$"), "Username can only contain letters, numbers, and underscores")
)

if result.isValid {
    MsgBox("Username '" username "' is valid!", "Validation Success", "Icon!")
} else {
    errMsg := "Username '" username "' is invalid:`n`n"
    for error in result.errors
        errMsg .= "• " error "`n"
    MsgBox(errMsg, "Validation Failed", "Icon!")
}

; ============================================================
; Example 4: Form Validation
; ============================================================

; Create form validator
form := FormValidator()

; Add fields with validation rules
form.AddField("email",
    "invalid.email",
    Rules.Required(),
    Rules.Email()
)

form.AddField("password",
    "weak",
    Rules.Required(),
    Rules.MinLength(8),
    Rules.StrongPassword()
)

form.AddField("username",
    "validuser123",
    Rules.Required(),
    Rules.MinLength(3),
    Rules.MaxLength(20)
)

form.AddField("age",
    "150",
    Rules.Required(),
    Rules.Range(1, 120)
)

; Validate all fields
isValid := form.ValidateAll()

if isValid {
    MsgBox("Form is valid!", "Form Validation", "Icon!")
} else {
    formErrors := "Form has errors:`n`n"

    for fieldName, errors in form.GetAllErrors() {
        formErrors .= fieldName ":`n"
        for error in errors
            formErrors .= "  • " error "`n"
        formErrors .= "`n"
    }

    MsgBox(formErrors, "Form Validation Failed", "Icon!")
}

; ============================================================
; Example 5: Real-World Registration Form
; ============================================================

class RegistrationForm {
    validator := ""

    __New() {
        this.validator := FormValidator()
    }

    ValidateRegistration(data) {
        this.validator := FormValidator()

        ; Email validation
        this.validator.AddField("email",
            data.email,
            Rules.Required(),
            Rules.Email()
        )

        ; Password validation
        this.validator.AddField("password",
            data.password,
            Rules.Required(),
            Rules.MinLength(8),
            Rule(
                (v) => Validator.Matches(v, "[A-Z]"),
                "Password must contain uppercase letter"
            ),
            Rule(
                (v) => Validator.Matches(v, "[a-z]"),
                "Password must contain lowercase letter"
            ),
            Rule(
                (v) => Validator.Matches(v, "\d"),
                "Password must contain number"
            )
        )

        ; Password confirmation
        this.validator.AddField("passwordConfirm",
            data.passwordConfirm,
            Rules.Required(),
            Rule(
                (v) => v = data.password,
                "Passwords must match"
            )
        )

        ; Username validation
        this.validator.AddField("username",
            data.username,
            Rules.Required(),
            Rules.MinLength(3),
            Rules.MaxLength(20),
            Rule(
                (v) => Validator.Matches(v, "^[a-zA-Z0-9_]+$"),
                "Username can only contain letters, numbers, and underscores"
            ),
            Rule(
                (v) => !Validator.Matches(v, "^_"),
                "Username cannot start with underscore"
            )
        )

        ; Age validation
        this.validator.AddField("age",
            data.age,
            Rules.Required(),
            Rule(
                (v) => Validator.IsInteger(v),
                "Age must be a number"
            ),
            Rules.Range(13, 120)
        )

        ; Phone validation (optional)
        if data.phone != "" {
            this.validator.AddField("phone",
                data.phone,
                Rules.Phone()
            )
        }

        return this.validator.ValidateAll()
    }

    GetErrors() {
        return this.validator.GetAllErrors()
    }

    GetFieldErrors(fieldName) {
        return this.validator.GetFieldErrors(fieldName)
    }
}

; Test registration form
regForm := RegistrationForm()

; Test case 1: Invalid data
testData1 := {
    email: "invalid",
    password: "weak",
    passwordConfirm: "different",
    username: "_bad",
    age: "15",
    phone: ""
}

if !regForm.ValidateRegistration(testData1) {
    msg := "Registration failed (expected):`n`n"
    for field, errors in regForm.GetErrors() {
        msg .= field ":`n"
        for error in errors
            msg .= "  • " error "`n"
    }
    MsgBox(msg, "Test Case 1 - Invalid Data", "Icon!")
}

; Test case 2: Valid data
testData2 := {
    email: "user@example.com",
    password: "SecurePass123!",
    passwordConfirm: "SecurePass123!",
    username: "validuser",
    age: "25",
    phone: "(555) 123-4567"
}

if regForm.ValidateRegistration(testData2) {
    MsgBox("Registration successful!`n`nAll fields are valid.",
           "Test Case 2 - Valid Data", "Icon!")
}

; ============================================================
; Example 6: Inline Validation
; ============================================================

class QuickValidation {
    static ValidateEmail(email) {
        if !Validator.IsEmail(email)
            return {success: false, message: "Invalid email address"}
        return {success: true, message: "Email is valid"}
    }

    static ValidateURL(url) {
        if !Validator.IsURL(url)
            return {success: false, message: "Invalid URL"}
        return {success: true, message: "URL is valid"}
    }

    static ValidateAge(age) {
        if !Validator.IsNumeric(age)
            return {success: false, message: "Age must be a number"}
        if !Validator.IsInRange(age, 1, 120)
            return {success: false, message: "Age must be between 1 and 120"}
        return {success: true, message: "Age is valid"}
    }
}

; Quick validation tests
emailCheck := QuickValidation.ValidateEmail("test@example.com")
urlCheck := QuickValidation.ValidateURL("https://example.com")
ageCheck := QuickValidation.ValidateAge(25)

MsgBox("Quick Validations:`n`n"
     . "Email: " (emailCheck.success ? "✓" : "✗") " " emailCheck.message "`n"
     . "URL: " (urlCheck.success ? "✓" : "✗") " " urlCheck.message "`n"
     . "Age: " (ageCheck.success ? "✓" : "✗") " " ageCheck.message,
     "Quick Validation", "Icon!")

; ============================================================
; Summary
; ============================================================

summary := "
(
VALIDATORS MODULE USAGE:

1. SIMPLE VALIDATION
   Validator.IsEmail(email)
   Validator.IsURL(url)
   Validator.IsPhone(phone)

2. VALIDATION RULES
   Rule(testFunc, message)
   Validate(value, rule1, rule2, ...)

3. FORM VALIDATION
   form := FormValidator()
   form.AddField(name, value, rules*)
   form.ValidateAll()

4. PRESET RULES
   Rules.Required()
   Rules.Email()
   Rules.MinLength(8)
   Rules.StrongPassword()

5. PASSWORD STRENGTH
   result := Validator.PasswordStrength(pass)
   → {strength, level, feedback}

BENEFITS:
✓ Reusable validation logic
✓ Consistent error messages
✓ Easy to test
✓ Composable rules
✓ Type-safe validation
)"

MsgBox(summary, "Validators Module Summary", "Icon!")
