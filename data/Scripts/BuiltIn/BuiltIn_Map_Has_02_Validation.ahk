#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Has_02_Validation.ahk
 * 
 * @description Map.Has() for data validation and required field checking
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Advanced validation patterns using Map.Has() for checking required fields,
 * data completeness, schema validation, and integrity checks.
 */

;=============================================================================
; Example 1: Required Fields Validator
;=============================================================================

/**
 * @class RequiredFieldsValidator
 * @description Validate that all required fields exist
 */
class RequiredFieldsValidator {
    /**
     * @method Validate
     * @description Check if all required fields are present
     * @param {Map} data - Data to validate
     * @param {Array} requiredFields - List of required field names
     * @returns {Object} Validation result with details
     */
    static Validate(data, requiredFields) {
        missing := []
        present := []

        for field in requiredFields {
            if (data.Has(field))
                present.Push(field)
            else
                missing.Push(field)
        }

        return {
            valid: missing.Length = 0,
            missing: missing,
            present: present,
            message: missing.Length = 0
                ? "All required fields present"
                : "Missing required fields: " this.ArrayToString(missing)
        }
    }

    /**
     * @method ValidateNested
     * @description Validate nested required fields
     * @param {Map} data - Data to validate
     * @param {Array} paths - Array of dot-notation paths
     * @returns {Object} Validation result
     */
    static ValidateNested(data, paths) {
        missing := []
        present := []

        for path in paths {
            if (this.HasPath(data, path))
                present.Push(path)
            else
                missing.Push(path)
        }

        return {
            valid: missing.Length = 0,
            missing: missing,
            present: present
        }
    }

    /**
     * @method HasPath
     * @description Check if nested path exists
     */
    static HasPath(data, path) {
        parts := StrSplit(path, ".")
        current := data

        for part in parts {
            if (!IsObject(current) || !current.Has(part))
                return false
            current := current[part]
        }

        return true
    }

    static ArrayToString(arr) {
        result := ""
        for item in arr {
            result .= (result ? ", " : "") . item
        }
        return result
    }
}

Example1_RequiredFields() {
    ; Test data - user registration
    validUser := Map(
        "username", "johndoe",
        "email", "john@example.com",
        "password", "secret123",
        "age", 25
    )

    invalidUser := Map(
        "username", "janedoe",
        "email", "jane@example.com"
        ; Missing password and age
    )

    requiredFields := ["username", "email", "password", "age"]

    output := "=== Required Fields Validation ===`n`n"

    ; Validate valid user
    result1 := RequiredFieldsValidator.Validate(validUser, requiredFields)
    output .= "Valid User:`n"
    output .= "  Status: " (result1.valid ? "VALID" : "INVALID") "`n"
    output .= "  Message: " result1.message "`n`n"

    ; Validate invalid user
    result2 := RequiredFieldsValidator.Validate(invalidUser, requiredFields)
    output .= "Invalid User:`n"
    output .= "  Status: " (result2.valid ? "VALID" : "INVALID") "`n"
    output .= "  Message: " result2.message "`n"

    MsgBox(output, "Required Fields")
}

;=============================================================================
; Example 2: Schema Validator
;=============================================================================

/**
 * @class SchemaValidator
 * @description Validate data against a schema definition
 */
class SchemaValidator {
    schema := Map()

    /**
     * @method DefineField
     * @description Define a field in the schema
     */
    DefineField(name, required := true, type := "", validator := "") {
        this.schema.Set(name, Map(
            "required", required,
            "type", type,
            "validator", validator
        ))
    }

    /**
     * @method Validate
     * @description Validate data against schema
     */
    Validate(data) {
        errors := []
        warnings := []

        ; Check each schema field
        for fieldName, fieldDef in this.schema {
            ; Check existence
            if (fieldDef["required"] && !data.Has(fieldName)) {
                errors.Push("Required field '" fieldName "' is missing")
                continue
            }

            if (!data.Has(fieldName))
                continue  ; Optional field not provided

            value := data[fieldName]

            ; Type validation (basic)
            if (fieldDef["type"] != "") {
                expectedType := fieldDef["type"]
                actualType := Type(value)

                if (actualType != expectedType)
                    errors.Push("Field '" fieldName "' should be " expectedType ", got " actualType)
            }

            ; Custom validator
            if (Type(fieldDef["validator"]) = "Func") {
                validator := fieldDef["validator"]
                result := validator.Call(value)

                if (Type(result) = "String" && result != "")
                    errors.Push("Field '" fieldName "': " result)
                else if (Type(result) = "Integer" && !result)
                    errors.Push("Field '" fieldName "' validation failed")
            }
        }

        ; Check for extra fields
        for fieldName in data {
            if (!this.schema.Has(fieldName))
                warnings.Push("Unexpected field: " fieldName)
        }

        return {
            valid: errors.Length = 0,
            errors: errors,
            warnings: warnings
        }
    }
}

Example2_SchemaValidation() {
    validator := SchemaValidator()

    ; Define schema
    validator.DefineField("username", true, "String", (v) => (StrLen(v) >= 3 ? "" : "Must be at least 3 characters"))
    validator.DefineField("email", true, "String", (v) => (InStr(v, "@") ? "" : "Invalid email format"))
    validator.DefineField("age", true, "Integer", (v) => (v >= 18 && v <= 120 ? "" : "Must be between 18 and 120"))
    validator.DefineField("phone", false, "String")  ; Optional

    output := "=== Schema Validation ===`n`n"

    ; Test 1: Valid data
    validData := Map(
        "username", "johndoe",
        "email", "john@example.com",
        "age", 25
    )

    result1 := validator.Validate(validData)
    output .= "Test 1 - Valid data:`n"
    output .= "  Valid: " (result1.valid ? "Yes" : "No") "`n"
    if (result1.errors.Length > 0)
        output .= "  Errors: " ArrayJoin(result1.errors, "; ") "`n"
    output .= "`n"

    ; Test 2: Invalid data
    invalidData := Map(
        "username", "ab",  ; Too short
        "email", "invalid-email",  ; No @
        "age", 15,  ; Too young
        "extra", "field"  ; Unexpected
    )

    result2 := validator.Validate(invalidData)
    output .= "Test 2 - Invalid data:`n"
    output .= "  Valid: " (result2.valid ? "Yes" : "No") "`n"
    output .= "  Errors: " ArrayJoin(result2.errors, "; ") "`n"
    output .= "  Warnings: " ArrayJoin(result2.warnings, "; ") "`n"

    MsgBox(output, "Schema Validation")
}

ArrayJoin(arr, delimiter) {
    result := ""
    for item in arr {
        result .= (result ? delimiter : "") . item
    }
    return result
}

;=============================================================================
; Example 3: Conditional Field Validator
;=============================================================================

/**
 * @class ConditionalValidator
 * @description Validate fields with conditional requirements
 */
class ConditionalValidator {
    data := Map()
    rules := []

    /**
     * @method SetData
     * @description Set data to validate
     */
    SetData(data) {
        this.data := data
    }

    /**
     * @method AddRule
     * @description Add conditional validation rule
     * @param {String} condition - Condition description
     * @param {Func} conditionFunc - Function returning true if rule applies
     * @param {Array} requiredFields - Fields required when condition is true
     */
    AddRule(condition, conditionFunc, requiredFields) {
        this.rules.Push(Map(
            "condition", condition,
            "conditionFunc", conditionFunc,
            "requiredFields", requiredFields
        ))
    }

    /**
     * @method Validate
     * @description Validate all conditional rules
     */
    Validate() {
        errors := []

        for rule in this.rules {
            ; Check if condition applies
            if (!rule["conditionFunc"].Call(this.data))
                continue

            ; Condition applies - check required fields
            for field in rule["requiredFields"] {
                if (!this.data.Has(field))
                    errors.Push("When " rule["condition"] ", field '" field "' is required")
            }
        }

        return {
            valid: errors.Length = 0,
            errors: errors
        }
    }
}

Example3_ConditionalValidation() {
    validator := ConditionalValidator()

    ; Define rules
    ; If shipping is true, address is required
    validator.AddRule(
        "shipping is required",
        (data) => data.Has("shipping") && data["shipping"],
        ["address", "city", "zipCode"]
    )

    ; If payment method is credit card, card details required
    validator.AddRule(
        "payment method is 'credit_card'",
        (data) => data.Has("paymentMethod") && data["paymentMethod"] = "credit_card",
        ["cardNumber", "cardExpiry", "cardCVV"]
    )

    output := "=== Conditional Validation ===`n`n"

    ; Test 1: Shipping required but address missing
    order1 := Map(
        "items", ["item1", "item2"],
        "shipping", true
        ; Missing address, city, zipCode
    )

    validator.SetData(order1)
    result1 := validator.Validate()

    output .= "Test 1 - Shipping without address:`n"
    output .= "  Valid: " (result1.valid ? "Yes" : "No") "`n"
    if (!result1.valid)
        output .= "  Errors: " ArrayJoin(result1.errors, "; ") "`n"
    output .= "`n"

    ; Test 2: Credit card payment without details
    order2 := Map(
        "items", ["item1"],
        "paymentMethod", "credit_card"
        ; Missing card details
    )

    validator.SetData(order2)
    result2 := validator.Validate()

    output .= "Test 2 - Credit card without details:`n"
    output .= "  Valid: " (result2.valid ? "Yes" : "No") "`n"
    if (!result2.valid)
        output .= "  Errors: " ArrayJoin(result2.errors, "; ") "`n"

    MsgBox(output, "Conditional Validation")
}

;=============================================================================
; Example 4: Data Completeness Checker
;=============================================================================

/**
 * @class CompletenessChecker
 * @description Check data completeness percentage
 */
class CompletenessChecker {
    /**
     * @method CheckCompleteness
     * @description Calculate completeness percentage
     * @param {Map} data - Data to check
     * @param {Array} allFields - All possible fields
     * @returns {Object} Completeness information
     */
    static CheckCompleteness(data, allFields) {
        present := []
        missing := []

        for field in allFields {
            if (data.Has(field))
                present.Push(field)
            else
                missing.Push(field)
        }

        percentage := Round((present.Length / allFields.Length) * 100)

        return {
            percentage: percentage,
            present: present,
            missing: missing,
            total: allFields.Length,
            status: this.GetCompletenessStatus(percentage)
        }
    }

    /**
     * @method GetCompletenessStatus
     * @description Get status description based on percentage
     */
    static GetCompletenessStatus(percentage) {
        if (percentage = 100)
            return "Complete"
        if (percentage >= 75)
            return "Mostly Complete"
        if (percentage >= 50)
            return "Partially Complete"
        if (percentage >= 25)
            return "Incomplete"
        return "Barely Started"
    }
}

Example4_CompletenessCheck() {
    allFields := ["name", "email", "phone", "address", "city", "state", "zipCode", "country"]

    profiles := [
        Map("name", "John", "email", "john@example.com", "phone", "555-1234",
            "address", "123 Main St", "city", "New York", "state", "NY",
            "zipCode", "10001", "country", "USA"),
        Map("name", "Jane", "email", "jane@example.com", "phone", "555-5678"),
        Map("name", "Bob")
    ]

    output := "=== Data Completeness Check ===`n`n"

    Loop profiles.Length {
        profile := profiles[A_Index]
        result := CompletenessChecker.CheckCompleteness(profile, allFields)

        output .= "Profile " A_Index ":`n"
        output .= "  Completeness: " result.percentage "% (" result.status ")`n"
        output .= "  Present: " result.present.Length "/" result.total " fields`n"
        output .= "  Missing: " ArrayJoin(result.missing, ", ") "`n`n"
    }

    MsgBox(output, "Completeness Check")
}

;=============================================================================
; Example 5: Dependency Validator
;=============================================================================

/**
 * @class DependencyValidator
 * @description Validate field dependencies
 */
class DependencyValidator {
    dependencies := Map()

    /**
     * @method AddDependency
     * @description Define that field A depends on field B
     */
    AddDependency(field, dependsOn) {
        if (!this.dependencies.Has(field))
            this.dependencies.Set(field, [])

        this.dependencies[field].Push(dependsOn)
    }

    /**
     * @method Validate
     * @description Validate all dependencies
     */
    Validate(data) {
        errors := []

        for field, deps in this.dependencies {
            ; Only check if field is present
            if (!data.Has(field))
                continue

            ; Check all dependencies
            for dep in deps {
                if (!data.Has(dep))
                    errors.Push("Field '" field "' requires '" dep "' to be present")
            }
        }

        return {
            valid: errors.Length = 0,
            errors: errors
        }
    }
}

Example5_DependencyValidation() {
    validator := DependencyValidator()

    ; Define dependencies
    validator.AddDependency("city", "address")
    validator.AddDependency("zipCode", "address")
    validator.AddDependency("apartmentNumber", "address")
    validator.AddDependency("cardExpiry", "cardNumber")
    validator.AddDependency("cardCVV", "cardNumber")

    output := "=== Dependency Validation ===`n`n"

    ; Test 1: City without address
    data1 := Map(
        "name", "John",
        "city", "New York"
        ; Missing address
    )

    result1 := validator.Validate(data1)
    output .= "Test 1 - City without address:`n"
    output .= "  Valid: " (result1.valid ? "Yes" : "No") "`n"
    if (!result1.valid)
        output .= "  Errors: " ArrayJoin(result1.errors, "; ") "`n"
    output .= "`n"

    ; Test 2: All dependencies satisfied
    data2 := Map(
        "name", "Jane",
        "address", "123 Main St",
        "city", "Boston",
        "zipCode", "02101"
    )

    result2 := validator.Validate(data2)
    output .= "Test 2 - All dependencies satisfied:`n"
    output .= "  Valid: " (result2.valid ? "Yes" : "No") "`n"

    MsgBox(output, "Dependency Validation")
}

;=============================================================================
; Example 6: Multi-Language Field Validator
;=============================================================================

/**
 * @class MultiLanguageValidator
 * @description Validate multi-language content
 */
class MultiLanguageValidator {
    requiredLanguages := []
    optionalLanguages := []

    /**
     * @method SetRequiredLanguages
     * @description Set required language codes
     */
    SetRequiredLanguages(languages) {
        this.requiredLanguages := languages
    }

    /**
     * @method SetOptionalLanguages
     * @description Set optional language codes
     */
    SetOptionalLanguages(languages) {
        this.optionalLanguages := languages
    }

    /**
     * @method Validate
     * @description Validate multilingual data
     */
    Validate(data, field) {
        missing := []
        present := []

        ; Check required languages
        for lang in this.requiredLanguages {
            key := field "." lang

            if (data.Has(key))
                present.Push(lang)
            else
                missing.Push(lang)
        }

        ; Check optional languages
        optional := []
        for lang in this.optionalLanguages {
            key := field "." lang
            if (data.Has(key))
                optional.Push(lang)
        }

        return {
            valid: missing.Length = 0,
            missing: missing,
            present: present,
            optional: optional,
            coverage: Round((present.Length / this.requiredLanguages.Length) * 100)
        }
    }
}

Example6_MultiLanguageValidation() {
    validator := MultiLanguageValidator()
    validator.SetRequiredLanguages(["en", "es", "fr"])
    validator.SetOptionalLanguages(["de", "it", "pt"])

    product := Map(
        "name.en", "Product Name",
        "name.es", "Nombre del Producto",
        "name.de", "Produktname",
        "description.en", "Product description",
        "description.fr", "Description du produit"
        ; Missing: name.fr, description.es, description.de
    )

    output := "=== Multi-Language Validation ===`n`n"

    ; Validate name field
    nameResult := validator.Validate(product, "name")
    output .= "Name field:`n"
    output .= "  Valid: " (nameResult.valid ? "Yes" : "No") "`n"
    output .= "  Coverage: " nameResult.coverage "%`n"
    output .= "  Present: " ArrayJoin(nameResult.present, ", ") "`n"
    output .= "  Missing: " ArrayJoin(nameResult.missing, ", ") "`n"
    output .= "  Optional: " ArrayJoin(nameResult.optional, ", ") "`n`n"

    ; Validate description field
    descResult := validator.Validate(product, "description")
    output .= "Description field:`n"
    output .= "  Valid: " (descResult.valid ? "Yes" : "No") "`n"
    output .= "  Coverage: " descResult.coverage "%`n"
    output .= "  Missing: " ArrayJoin(descResult.missing, ", ") "`n"

    MsgBox(output, "Multi-Language Validation")
}

;=============================================================================
; Example 7: Batch Validation
;=============================================================================

/**
 * @class BatchValidator
 * @description Validate multiple records at once
 */
class BatchValidator {
    requiredFields := []

    SetRequiredFields(fields) {
        this.requiredFields := fields
    }

    /**
     * @method ValidateBatch
     * @description Validate array of records
     */
    ValidateBatch(records) {
        results := []
        validCount := 0
        invalidCount := 0

        for index, record in records {
            missing := []

            for field in this.requiredFields {
                if (!record.Has(field))
                    missing.Push(field)
            }

            valid := missing.Length = 0
            if (valid)
                validCount++
            else
                invalidCount++

            results.Push(Map(
                "index", index,
                "valid", valid,
                "missing", missing
            ))
        }

        return {
            results: results,
            validCount: validCount,
            invalidCount: invalidCount,
            total: records.Length,
            successRate: Round((validCount / records.Length) * 100)
        }
    }
}

Example7_BatchValidation() {
    validator := BatchValidator()
    validator.SetRequiredFields(["id", "name", "email"])

    records := [
        Map("id", 1, "name", "John", "email", "john@example.com"),
        Map("id", 2, "name", "Jane"),  ; Missing email
        Map("id", 3, "email", "bob@example.com"),  ; Missing name
        Map("id", 4, "name", "Alice", "email", "alice@example.com")
    ]

    result := validator.ValidateBatch(records)

    output := "=== Batch Validation ===`n`n"
    output .= "Summary:`n"
    output .= "  Total records: " result.total "`n"
    output .= "  Valid: " result.validCount "`n"
    output .= "  Invalid: " result.invalidCount "`n"
    output .= "  Success rate: " result.successRate "%`n`n"

    output .= "Details:`n"
    for res in result.results {
        output .= "  Record " res["index"] ": " (res["valid"] ? "Valid" : "Invalid")
        if (!res["valid"])
            output .= " (Missing: " ArrayJoin(res["missing"], ", ") ")"
        output .= "`n"
    }

    MsgBox(output, "Batch Validation")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Has() - Validation Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Validation Patterns with Map.Has()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Required Fields")
        .OnEvent("Click", (*) => Example1_RequiredFields())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Schema")
        .OnEvent("Click", (*) => Example2_SchemaValidation())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Conditional")
        .OnEvent("Click", (*) => Example3_ConditionalValidation())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Completeness")
        .OnEvent("Click", (*) => Example4_CompletenessCheck())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Dependencies")
        .OnEvent("Click", (*) => Example5_DependencyValidation())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Multi-Language")
        .OnEvent("Click", (*) => Example6_MultiLanguageValidation())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Batch Validation")
        .OnEvent("Click", (*) => Example7_BatchValidation())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_RequiredFields()
        Example2_SchemaValidation()
        Example3_ConditionalValidation()
        Example4_CompletenessCheck()
        Example5_DependencyValidation()
        Example6_MultiLanguageValidation()
        Example7_BatchValidation()
        MsgBox("All validation examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
