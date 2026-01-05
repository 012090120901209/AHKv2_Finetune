#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Has_04_DataIntegrity.ahk
 * 
 * @description Map.Has() for data integrity and consistency checks
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Using Map.Has() to ensure data integrity, validate consistency,
 * check referential integrity, and maintain data quality.
 */

;=============================================================================
; Example 1: Referential Integrity Checker
;=============================================================================

/**
 * @class ReferentialIntegrityChecker
 * @description Check references between related data
 */
class ReferentialIntegrityChecker {
    /**
     * @method CheckReferences
     * @description Verify all foreign keys exist in parent table
     */
    static CheckReferences(childData, parentData, foreignKey) {
        orphaned := []
        valid := []

        for childId, childRecord in childData {
            if (!childRecord.Has(foreignKey)) {
                orphaned.Push({ id: childId, reason: "Missing foreign key" })
                continue
            }

            parentId := childRecord[foreignKey]
            if (parentData.Has(parentId))
                valid.Push(childId)
            else
                orphaned.Push({ id: childId, reason: "Parent not found: " parentId })
        }

        return {
            valid: orphaned.Length = 0,
            validCount: valid.Length,
            orphanedCount: orphaned.Length,
            orphaned: orphaned
        }
    }
}

Example1_ReferentialIntegrity() {
    ; Parent table - users
    users := Map(
        "U001", Map("name", "Alice"),
        "U002", Map("name", "Bob"),
        "U003", Map("name", "Carol")
    )

    ; Child table - orders
    orders := Map(
        "O001", Map("userId", "U001", "amount", 100),
        "O002", Map("userId", "U002", "amount", 200),
        "O003", Map("userId", "U999", "amount", 150),  ; Orphaned
        "O004", Map("amount", 75)  ; Missing userId
    )

    result := ReferentialIntegrityChecker.CheckReferences(orders, users, "userId")

    output := "=== Referential Integrity Check ===`n`n"
    output .= "Valid references: " result.validCount "`n"
    output .= "Orphaned records: " result.orphanedCount "`n`n"

    if (result.orphanedCount > 0) {
        output .= "Orphaned records:`n"
        for orphan in result.orphaned {
            output .= "  " orphan.id ": " orphan.reason "`n"
        }
    }

    MsgBox(output, "Referential Integrity")
}

;=============================================================================
; Example 2: Data Consistency Validator
;=============================================================================

Example2_DataConsistency() {
    ; Check if related fields are consistent
    ValidateConsistency(data) {
        errors := []

        ; If shipping is true, address must exist
        if (data.Has("shipping") && data["shipping"]) {
            if (!data.Has("address"))
                errors.Push("Shipping enabled but no address provided")
        }

        ; If discounted, must have both price and discount
        if (data.Has("discounted") && data["discounted"]) {
            if (!data.Has("originalPrice"))
                errors.Push("Discounted item missing original price")
            if (!data.Has("discountPercent"))
                errors.Push("Discounted item missing discount percent")
        }

        ; If payment method is credit card, need card details
        if (data.Has("paymentMethod") && data["paymentMethod"] = "card") {
            if (!data.Has("cardNumber"))
                errors.Push("Card payment missing card number")
        }

        return {
            consistent: errors.Length = 0,
            errors: errors
        }
    }

    output := "=== Data Consistency ===`n`n"

    ; Test 1: Inconsistent data
    order1 := Map(
        "id", "O001",
        "shipping", true,
        "discounted", true,
        "paymentMethod", "card"
    )

    result1 := ValidateConsistency(order1)
    output .= "Order 1:`n"
    output .= "  Consistent: " (result1.consistent ? "Yes" : "No") "`n"
    if (!result1.consistent) {
        for err in result1.errors {
            output .= "  - " err "`n"
        }
    }
    output .= "`n"

    ; Test 2: Consistent data
    order2 := Map(
        "id", "O002",
        "shipping", true,
        "address", "123 Main St",
        "paymentMethod", "cash"
    )

    result2 := ValidateConsistency(order2)
    output .= "Order 2:`n"
    output .= "  Consistent: " (result2.consistent ? "Yes" : "No") "`n"

    MsgBox(output, "Data Consistency")
}

;=============================================================================
; Example 3: Duplicate Detection
;=============================================================================

Example3_DuplicateDetection() {
    records := Map(
        "R001", Map("email", "john@example.com", "name", "John"),
        "R002", Map("email", "jane@example.com", "name", "Jane"),
        "R003", Map("email", "john@example.com", "name", "Johnny"),  ; Duplicate email
        "R004", Map("email", "bob@example.com", "name", "Bob")
    )

    DetectDuplicates(data, field) {
        seen := Map()
        duplicates := []

        for id, record in data {
            if (!record.Has(field))
                continue

            value := record[field]

            if (seen.Has(value)) {
                duplicates.Push({
                    id: id,
                    value: value,
                    original: seen[value]
                })
            } else {
                seen.Set(value, id)
            }
        }

        return duplicates
    }

    output := "=== Duplicate Detection ===`n`n"

    duplicates := DetectDuplicates(records, "email")

    output .= "Found " duplicates.Length " duplicate(s)`n`n"

    for dup in duplicates {
        output .= dup.value "`n"
        output .= "  Original: " dup.original "`n"
        output .= "  Duplicate: " dup.id "`n`n"
    }

    MsgBox(output, "Duplicate Detection")
}

;=============================================================================
; Example 4: Completeness Auditor
;=============================================================================

Example4_CompletenessAudit() {
    AuditCompleteness(records, mandatoryFields) {
        report := []

        for id, record in records {
            missing := []
            present := []

            for field in mandatoryFields {
                if (record.Has(field))
                    present.Push(field)
                else
                    missing.Push(field)
            }

            completeness := Round((present.Length / mandatoryFields.Length) * 100)

            report.Push({
                id: id,
                completeness: completeness,
                missing: missing,
                quality: completeness = 100 ? "Perfect" :
                    completeness >= 75 ? "Good" :
                    completeness >= 50 ? "Fair" : "Poor"
            })
        }

        return report
    }

    records := Map(
        "P001", Map("name", "Product A", "price", 99.99, "stock", 100, "category", "Electronics"),
        "P002", Map("name", "Product B", "price", 49.99),
        "P003", Map("name", "Product C")
    )

    mandatoryFields := ["name", "price", "stock", "category", "description"]

    report := AuditCompleteness(records, mandatoryFields)

    output := "=== Completeness Audit ===`n`n"

    for item in report {
        output .= item.id " - " item.completeness "% (" item.quality ")`n"
        if (item.missing.Length > 0) {
            output .= "  Missing: "
            for field in item.missing {
                output .= field " "
            }
            output .= "`n"
        }
        output .= "`n"
    }

    MsgBox(output, "Completeness Audit")
}

;=============================================================================
; Example 5: Cross-Field Validation
;=============================================================================

Example5_CrossFieldValidation() {
    ValidateCrossFields(data) {
        errors := []

        ; End date must exist if start date exists
        if (data.Has("startDate") && !data.Has("endDate"))
            errors.Push("Start date without end date")

        ; Max must be greater than min
        if (data.Has("minValue") && data.Has("maxValue")) {
            if (data["minValue"] >= data["maxValue"])
                errors.Push("Min value must be less than max value")
        }

        ; Confirm password must match password
        if (data.Has("password") && data.Has("confirmPassword")) {
            if (data["password"] != data["confirmPassword"])
                errors.Push("Passwords do not match")
        }

        return {
            valid: errors.Length = 0,
            errors: errors
        }
    }

    output := "=== Cross-Field Validation ===`n`n"

    ; Test cases
    testData := [
        Map("startDate", "2025-01-01"),  ; Missing endDate
        Map("minValue", 100, "maxValue", 50),  ; Invalid range
        Map("password", "abc123", "confirmPassword", "xyz789"),  ; Mismatch
        Map("minValue", 10, "maxValue", 100, "startDate", "2025-01-01", "endDate", "2025-12-31")  ; Valid
    ]

    Loop testData.Length {
        result := ValidateCrossFields(testData[A_Index])
        output .= "Test " A_Index ": " (result.valid ? "Valid" : "Invalid") "`n"
        if (!result.valid) {
            for err in result.errors {
                output .= "  - " err "`n"
            }
        }
        output .= "`n"
    }

    MsgBox(output, "Cross-Field Validation")
}

;=============================================================================
; Example 6: Orphan Record Finder
;=============================================================================

Example6_OrphanRecords() {
    FindOrphans(mainData, relatedData, linkField) {
        orphans := []

        for id, record in mainData {
            hasRelated := false

            for relId, relRecord in relatedData {
                if (relRecord.Has(linkField) && relRecord[linkField] = id) {
                    hasRelated := true
                    break
                }
            }

            if (!hasRelated)
                orphans.Push(id)
        }

        return orphans
    }

    categories := Map(
        "C001", Map("name", "Electronics"),
        "C002", Map("name", "Books"),
        "C003", Map("name", "Clothing")
    )

    products := Map(
        "P001", Map("name", "Laptop", "categoryId", "C001"),
        "P002", Map("name", "Novel", "categoryId", "C002")
        ; No products in C003
    )

    orphanCategories := FindOrphans(categories, products, "categoryId")

    output := "=== Orphan Record Finder ===`n`n"
    output .= "Categories without products:`n"

    for catId in orphanCategories {
        output .= "  " catId ": " categories[catId]["name"] "`n"
    }

    MsgBox(output, "Orphan Records")
}

;=============================================================================
; Example 7: Data Quality Score
;=============================================================================

Example7_DataQualityScore() {
    CalculateQualityScore(data, requiredFields, optionalFields, validators) {
        score := 0
        maxScore := 0
        details := []

        ; Required fields (50 points each)
        for field in requiredFields {
            maxScore += 50
            if (data.Has(field)) {
                score += 50
                details.Push(field ": +50 (required)")
            } else {
                details.Push(field ": +0 (missing required)")
            }
        }

        ; Optional fields (25 points each)
        for field in optionalFields {
            maxScore += 25
            if (data.Has(field)) {
                score += 25
                details.Push(field ": +25 (optional)")
            }
        }

        ; Validators (apply penalties)
        if (validators.Has("length") && data.Has(validators["length"]["field"])) {
            field := validators["length"]["field"]
            minLen := validators["length"]["min"]
            if (StrLen(data[field]) < minLen) {
                score -= 10
                details.Push(field ": -10 (too short)")
            }
        }

        percentage := maxScore > 0 ? Round((score / maxScore) * 100) : 0

        return {
            score: score,
            maxScore: maxScore,
            percentage: percentage,
            grade: percentage >= 90 ? "A" :
                percentage >= 80 ? "B" :
                percentage >= 70 ? "C" :
                percentage >= 60 ? "D" : "F",
            details: details
        }
    }

    record := Map(
        "name", "John Doe",
        "email", "john@example.com",
        "age", 30,
        "phone", "555-1234"
    )

    requiredFields := ["name", "email", "age"]
    optionalFields := ["phone", "address", "city"]
    validators := Map("length", Map("field", "name", "min", 5))

    result := CalculateQualityScore(record, requiredFields, optionalFields, validators)

    output := "=== Data Quality Score ===`n`n"
    output .= "Score: " result.score "/" result.maxScore " (" result.percentage "%)`n"
    output .= "Grade: " result.grade "`n`n"
    output .= "Details:`n"

    for detail in result.details {
        output .= "  " detail "`n"
    }

    MsgBox(output, "Data Quality Score")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Has() - Data Integrity Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Data Integrity with Map.Has()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Referential")
        .OnEvent("Click", (*) => Example1_ReferentialIntegrity())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Consistency")
        .OnEvent("Click", (*) => Example2_DataConsistency())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Duplicates")
        .OnEvent("Click", (*) => Example3_DuplicateDetection())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Completeness")
        .OnEvent("Click", (*) => Example4_CompletenessAudit())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Cross-Field")
        .OnEvent("Click", (*) => Example5_CrossFieldValidation())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Orphans")
        .OnEvent("Click", (*) => Example6_OrphanRecords())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Quality Score")
        .OnEvent("Click", (*) => Example7_DataQualityScore())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_ReferentialIntegrity()
        Example2_DataConsistency()
        Example3_DuplicateDetection()
        Example4_CompletenessAudit()
        Example5_CrossFieldValidation()
        Example6_OrphanRecords()
        Example7_DataQualityScore()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
