#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Validator - Fluent field validation with composable rules
; Demonstrates builder pattern for validation chains

class FieldValidator {
    __New() => this.rules := []

    Required(msg := "Field is required") {
        this.rules.Push(Map("type", "required", "msg", msg))
        return this
    }

    MinLength(len, msg := "") {
        if !msg
            msg := "Minimum length is " len
        this.rules.Push(Map("type", "minLength", "value", len, "msg", msg))
        return this
    }

    MaxLength(len, msg := "") {
        if !msg
            msg := "Maximum length is " len
        this.rules.Push(Map("type", "maxLength", "value", len, "msg", msg))
        return this
    }

    Pattern(regex, msg := "Invalid format") {
        this.rules.Push(Map("type", "pattern", "value", regex, "msg", msg))
        return this
    }
    
    Email(msg := "Invalid email format") {
        return this.Pattern("^\w+@\w+\.\w+$", msg)
    }
    
    Numeric(msg := "Must be a number") {
        return this.Pattern("^\d+$", msg)
    }
    
    Custom(fn, msg := "Validation failed") {
        this.rules.Push(Map("type", "custom", "fn", fn, "msg", msg))
        return this
    }

    Validate(value) {
        errors := []
        for rule in this.rules {
            switch rule["type"] {
                case "required":
                    if value = ""
                        errors.Push(rule["msg"])
                case "minLength":
                    if StrLen(value) < rule["value"]
                        errors.Push(rule["msg"])
                case "maxLength":
                    if StrLen(value) > rule["value"]
                        errors.Push(rule["msg"])
                case "pattern":
                    if !RegExMatch(value, rule["value"])
                        errors.Push(rule["msg"])
                case "custom":
                    if !rule["fn"](value)
                        errors.Push(rule["msg"])
            }
        }
        return errors
    }
}

; Schema - validates multiple fields
class Schema {
    __New() => this.fields := Map()

    Field(name) {
        validator := FieldValidator()
        this.fields[name] := validator
        return validator
    }

    Validate(data) {
        errors := Map()
        valid := true

        for name, validator in this.fields {
            value := data.Has(name) ? data[name] : ""
            fieldErrors := validator.Validate(value)
            if fieldErrors.Length {
                errors[name] := fieldErrors
                valid := false
            }
        }

        return Map("valid", valid, "errors", errors)
    }
}

; Demo - user registration validation
userSchema := Schema()

userSchema.Field("username")
    .Required()
    .MinLength(3, "Username must be at least 3 characters")
    .MaxLength(20, "Username cannot exceed 20 characters")
    .Pattern("^[a-zA-Z0-9_]+$", "Username can only contain letters, numbers, and underscores")

userSchema.Field("email")
    .Required()
    .Email()

userSchema.Field("age")
    .Required()
    .Numeric("Age must be a number")
    .Custom((v) => Integer(v) >= 18, "Must be 18 or older")

; Test validation
testData := Map("username", "ab", "email", "invalid", "age", "15")
result := userSchema.Validate(testData)

output := "Validation Result: " (result["valid"] ? "PASSED" : "FAILED") "`n`n"

if !result["valid"] {
    for field, fieldErrors in result["errors"] {
        output .= field ":`n"
        for err in fieldErrors
            output .= "  - " err "`n"
    }
}

MsgBox(output)
