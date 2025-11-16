#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Get_03_DataRetrieval.ahk
 *
 * @description Safe data retrieval patterns using Map.Get()
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 *
 * @overview
 * Demonstrates safe patterns for retrieving data from Maps, including
 * null-safe access, error handling, data validation, and retrieval pipelines.
 */

;=============================================================================
; Example 1: Null-Safe Navigation
;=============================================================================

/**
 * @class SafeNavigator
 * @description Navigate nested Maps safely without errors
 */
class SafeNavigator {
    /**
     * @method GetPath
     * @description Safely navigate nested path (e.g., "user.profile.name")
     * @param {Map} data - Root data map
     * @param {String} path - Dot-notation path
     * @param {Any} defaultValue - Default if path doesn't exist
     * @returns {Any} Value at path or default
     */
    static GetPath(data, path, defaultValue := "") {
        parts := StrSplit(path, ".")
        current := data

        for part in parts {
            if (!IsObject(current) || !current.Has(part))
                return defaultValue

            current := current.Get(part)
        }

        return current
    }

    /**
     * @method GetPathSafe
     * @description Get path with validation at each level
     * @param {Map} data - Root data map
     * @param {Array} pathArray - Array of keys to navigate
     * @param {Any} defaultValue - Default value
     * @returns {Any} Value or default
     */
    static GetPathSafe(data, pathArray, defaultValue := "") {
        current := data

        for key in pathArray {
            ; Validate current is a Map
            if (Type(current) != "Map" && !IsObject(current))
                return defaultValue

            ; Check if key exists
            if (!current.Has(key))
                return defaultValue

            current := current.Get(key)
        }

        return current
    }
}

Example1_NullSafeNavigation() {
    ; Create nested data structure
    data := Map(
        "user", Map(
            "id", 123,
            "profile", Map(
                "name", "John Doe",
                "email", "john@example.com",
                "address", Map(
                    "city", "New York",
                    "country", "USA"
                )
            ),
            "settings", Map(
                "theme", "dark"
            )
        )
    )

    output := "=== Null-Safe Navigation Example ===`n`n"

    ; Safe navigation - existing paths
    output .= "Name: " SafeNavigator.GetPath(data, "user.profile.name") "`n"
    output .= "City: " SafeNavigator.GetPath(data, "user.profile.address.city") "`n"
    output .= "Theme: " SafeNavigator.GetPath(data, "user.settings.theme") "`n`n"

    ; Safe navigation - non-existing paths
    output .= "Phone (missing): " SafeNavigator.GetPath(data, "user.profile.phone", "N/A") "`n"
    output .= "Language (missing): " SafeNavigator.GetPath(data, "user.settings.language", "en") "`n"
    output .= "Deep missing: " SafeNavigator.GetPath(data, "user.profile.social.twitter", "Not set") "`n"

    MsgBox(output, "Null-Safe Navigation")
}

;=============================================================================
; Example 2: Validated Retrieval
;=============================================================================

/**
 * @class ValidatedRetriever
 * @description Retrieve data with validation
 */
class ValidatedRetriever {
    data := Map()
    validators := Map()

    /**
     * @method SetValidator
     * @description Register validator for a key
     * @param {String} key - Data key
     * @param {Func} validatorFunc - Validation function
     */
    SetValidator(key, validatorFunc) {
        this.validators.Set(key, validatorFunc)
    }

    /**
     * @method GetValidated
     * @description Get value with validation
     * @param {String} key - Data key
     * @param {Any} defaultValue - Default value
     * @returns {Object} {value, valid, error}
     */
    GetValidated(key, defaultValue := "") {
        value := this.data.Get(key, defaultValue)

        ; Check if validator exists
        if (!this.validators.Has(key)) {
            return {value: value, valid: true, error: ""}
        }

        ; Validate
        validator := this.validators.Get(key)
        validationResult := validator.Call(value)

        if (Type(validationResult) = "Integer" && validationResult) {
            return {value: value, valid: true, error: ""}
        }

        if (IsObject(validationResult) && validationResult.HasProp("valid")) {
            return validationResult.HasProp("error")
                ? {value: value, valid: validationResult.valid, error: validationResult.error}
                : {value: value, valid: validationResult.valid, error: "Validation failed"}
        }

        return {value: defaultValue, valid: false, error: "Validation failed"}
    }

    /**
     * @method Set
     * @description Set data value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example2_ValidatedRetrieval() {
    retriever := ValidatedRetriever()

    ; Set up validators
    retriever.SetValidator("age", (v) => (v >= 0 && v <= 150
        ? {valid: true}
        : {valid: false, error: "Age must be 0-150"}))

    retriever.SetValidator("email", (v) => (InStr(v, "@")
        ? {valid: true}
        : {valid: false, error: "Invalid email format"}))

    retriever.SetValidator("username", (v) => (StrLen(v) >= 3
        ? {valid: true}
        : {valid: false, error: "Username must be 3+ characters"}))

    ; Set data
    retriever.Set("age", 25)
    retriever.Set("email", "user@example.com")
    retriever.Set("username", "jo")  ; Too short

    output := "=== Validated Retrieval Example ===`n`n"

    ; Retrieve and validate
    ageResult := retriever.GetValidated("age")
    output .= "Age: " ageResult.value
    output .= " - " (ageResult.valid ? "Valid" : "Invalid: " ageResult.error) "`n"

    emailResult := retriever.GetValidated("email")
    output .= "Email: " emailResult.value
    output .= " - " (emailResult.valid ? "Valid" : "Invalid: " emailResult.error) "`n"

    userResult := retriever.GetValidated("username")
    output .= "Username: " userResult.value
    output .= " - " (userResult.valid ? "Valid" : "Invalid: " userResult.error) "`n"

    MsgBox(output, "Validated Retrieval")
}

;=============================================================================
; Example 3: Conditional Retrieval
;=============================================================================

/**
 * @class ConditionalGetter
 * @description Get data based on conditions
 */
class ConditionalGetter {
    data := Map()

    /**
     * @method GetIf
     * @description Get value only if condition is met
     * @param {String} key - Data key
     * @param {Func} condition - Condition function
     * @param {Any} defaultValue - Default if condition fails
     * @returns {Any} Value if condition met, otherwise default
     */
    GetIf(key, condition, defaultValue := "") {
        if (!this.data.Has(key))
            return defaultValue

        value := this.data.Get(key)

        return condition.Call(value) ? value : defaultValue
    }

    /**
     * @method GetWhere
     * @description Get first value matching condition
     * @param {Func} condition - Condition function(key, value)
     * @returns {Any} First matching value or empty string
     */
    GetWhere(condition) {
        for key, value in this.data {
            if (condition.Call(key, value))
                return value
        }
        return ""
    }

    /**
     * @method GetAllWhere
     * @description Get all values matching condition
     * @param {Func} condition - Condition function(key, value)
     * @returns {Array} Array of matching values
     */
    GetAllWhere(condition) {
        results := []
        for key, value in this.data {
            if (condition.Call(key, value))
                results.Push({key: key, value: value})
        }
        return results
    }

    /**
     * @method Set
     * @description Set value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example3_ConditionalRetrieval() {
    getter := ConditionalGetter()

    getter.Set("price1", 50)
    getter.Set("price2", 150)
    getter.Set("price3", 75)
    getter.Set("name1", "Item A")
    getter.Set("name2", "Item B")

    output := "=== Conditional Retrieval Example ===`n`n"

    ; Get if value is numeric
    price := getter.GetIf("price1", (v) => (Type(v) = "Integer" || Type(v) = "Float"), 0)
    output .= "Price (if numeric): " price "`n"

    ; Get first price over 100
    highPrice := getter.GetWhere((k, v) => (Type(v) = "Integer" && v > 100))
    output .= "First price > 100: " highPrice "`n`n"

    ; Get all prices
    allPrices := getter.GetAllWhere((k, v) => InStr(k, "price"))
    output .= "All prices:`n"
    for item in allPrices {
        output .= "  " item.key ": " item.value "`n"
    }

    MsgBox(output, "Conditional Retrieval")
}

;=============================================================================
; Example 4: Batch Retrieval with Error Handling
;=============================================================================

/**
 * @class BatchRetriever
 * @description Retrieve multiple values with error handling
 */
class BatchRetriever {
    data := Map()

    /**
     * @method GetMultiple
     * @description Get multiple keys at once
     * @param {Array} keys - Array of keys to retrieve
     * @param {Any} defaultValue - Default for missing keys
     * @returns {Map} Map of results
     */
    GetMultiple(keys, defaultValue := "") {
        results := Map()
        for key in keys {
            results.Set(key, this.data.Get(key, defaultValue))
        }
        return results
    }

    /**
     * @method GetMultipleSafe
     * @description Get multiple with success/error info
     * @param {Array} keys - Array of keys
     * @returns {Object} {success: Map, errors: Array}
     */
    GetMultipleSafe(keys) {
        success := Map()
        errors := []

        for key in keys {
            if (this.data.Has(key)) {
                success.Set(key, this.data.Get(key))
            } else {
                errors.Push(key)
            }
        }

        return {success: success, errors: errors}
    }

    /**
     * @method GetRequired
     * @description Get required keys or return error
     * @param {Array} requiredKeys - Keys that must exist
     * @returns {Object} {success: Boolean, data: Map, missing: Array}
     */
    GetRequired(requiredKeys) {
        data := Map()
        missing := []

        for key in requiredKeys {
            if (this.data.Has(key)) {
                data.Set(key, this.data.Get(key))
            } else {
                missing.Push(key)
            }
        }

        return {
            success: missing.Length = 0,
            data: data,
            missing: missing
        }
    }

    /**
     * @method Set
     * @description Set value
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example4_BatchRetrieval() {
    retriever := BatchRetriever()

    retriever.Set("name", "John Doe")
    retriever.Set("email", "john@example.com")
    retriever.Set("age", 30)

    output := "=== Batch Retrieval Example ===`n`n"

    ; Get multiple values
    keys := ["name", "email", "age", "phone"]
    results := retriever.GetMultiple(keys, "N/A")

    output .= "GetMultiple results:`n"
    for key, value in results {
        output .= "  " key ": " value "`n"
    }
    output .= "`n"

    ; Get multiple with error tracking
    safeResults := retriever.GetMultipleSafe(keys)

    output .= "GetMultipleSafe:`n"
    output .= "Success:`n"
    for key, value in safeResults.success {
        output .= "  " key ": " value "`n"
    }
    output .= "Errors: " ArrayJoin(safeResults.errors, ", ") "`n`n"

    ; Get required fields
    required := retriever.GetRequired(["name", "email", "phone"])

    output .= "GetRequired:`n"
    output .= "Success: " (required.success ? "Yes" : "No") "`n"
    if (!required.success)
        output .= "Missing: " ArrayJoin(required.missing, ", ") "`n"

    MsgBox(output, "Batch Retrieval")
}

ArrayJoin(arr, delimiter) {
    result := ""
    for item in arr {
        result .= (result ? delimiter : "") . item
    }
    return result
}

;=============================================================================
; Example 5: Cached Retrieval
;=============================================================================

/**
 * @class CachedRetriever
 * @description Retrieve with automatic caching
 */
class CachedRetriever {
    storage := Map()  ; Simulated slow storage
    cache := Map()    ; Fast cache
    stats := Map("hits", 0, "misses", 0)

    /**
     * @method Get
     * @description Get with automatic caching
     * @param {String} key - Data key
     * @param {Any} defaultValue - Default value
     * @returns {Any} Value
     */
    Get(key, defaultValue := "") {
        ; Check cache first
        if (this.cache.Has(key)) {
            this.stats["hits"]++
            return this.cache.Get(key)
        }

        ; Check storage
        if (this.storage.Has(key)) {
            this.stats["misses"]++
            value := this.storage.Get(key)

            ; Cache it
            this.cache.Set(key, value)

            return value
        }

        return defaultValue
    }

    /**
     * @method Set
     * @description Set in storage and cache
     */
    Set(key, value) {
        this.storage.Set(key, value)
        this.cache.Set(key, value)
    }

    /**
     * @method Invalidate
     * @description Invalidate cache entry
     */
    Invalidate(key) {
        this.cache.Delete(key)
    }

    /**
     * @method GetStats
     * @description Get cache statistics
     */
    GetStats() {
        total := this.stats["hits"] + this.stats["misses"]
        hitRate := total > 0 ? Round((this.stats["hits"] / total) * 100, 2) : 0

        return "Cache hits: " this.stats["hits"]
            . "`nCache misses: " this.stats["misses"]
            . "`nHit rate: " hitRate "%"
            . "`nCache size: " this.cache.Count
            . "`nStorage size: " this.storage.Count
    }
}

Example5_CachedRetrieval() {
    retriever := CachedRetriever()

    ; Add data
    retriever.Set("user1", "Alice")
    retriever.Set("user2", "Bob")
    retriever.Set("user3", "Carol")

    output := "=== Cached Retrieval Example ===`n`n"

    ; First access - cache miss
    retriever.Get("user1")
    retriever.Get("user2")

    ; Second access - cache hit
    retriever.Get("user1")
    retriever.Get("user1")
    retriever.Get("user2")

    output .= retriever.GetStats() "`n`n"

    ; Invalidate and re-access
    retriever.Invalidate("user1")
    retriever.Get("user1")  ; Cache miss again

    output .= "After invalidation:`n"
    output .= retriever.GetStats()

    MsgBox(output, "Cached Retrieval")
}

;=============================================================================
; Example 6: Transform on Retrieval
;=============================================================================

/**
 * @class TransformingGetter
 * @description Apply transformations when retrieving
 */
class TransformingGetter {
    data := Map()
    transformers := Map()

    /**
     * @method RegisterTransformer
     * @description Register transformer for a key
     */
    RegisterTransformer(key, transformFunc) {
        this.transformers.Set(key, transformFunc)
    }

    /**
     * @method Get
     * @description Get with automatic transformation
     */
    Get(key, defaultValue := "") {
        value := this.data.Get(key, defaultValue)

        if (this.transformers.Has(key)) {
            transformer := this.transformers.Get(key)
            return transformer.Call(value)
        }

        return value
    }

    /**
     * @method Set
     * @description Set value (stored untransformed)
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example6_TransformRetrieval() {
    getter := TransformingGetter()

    ; Set data
    getter.Set("firstName", "john")
    getter.Set("lastName", "doe")
    getter.Set("price", "19.99")
    getter.Set("timestamp", "20250116120000")

    ; Register transformers
    getter.RegisterTransformer("firstName", (v) => StrUpper(SubStr(v, 1, 1)) . SubStr(v, 2))
    getter.RegisterTransformer("lastName", (v) => StrUpper(SubStr(v, 1, 1)) . SubStr(v, 2))
    getter.RegisterTransformer("price", (v) => "$" . v)
    getter.RegisterTransformer("timestamp", (v) => FormatTime(v, "yyyy-MM-dd HH:mm:ss"))

    output := "=== Transform on Retrieval Example ===`n`n"

    output .= "First Name: " getter.Get("firstName") "`n"
    output .= "Last Name: " getter.Get("lastName") "`n"
    output .= "Price: " getter.Get("price") "`n"
    output .= "Timestamp: " getter.Get("timestamp") "`n"

    MsgBox(output, "Transform Retrieval")
}

;=============================================================================
; Example 7: Query Builder Pattern
;=============================================================================

/**
 * @class QueryBuilder
 * @description Build complex queries for data retrieval
 */
class QueryBuilder {
    data := Map()
    filters := []
    sortKey := ""
    sortAsc := true
    limitCount := 0

    /**
     * @method Where
     * @description Add filter condition
     */
    Where(filterFunc) {
        this.filters.Push(filterFunc)
        return this  ; For chaining
    }

    /**
     * @method OrderBy
     * @description Set sort order
     */
    OrderBy(key, ascending := true) {
        this.sortKey := key
        this.sortAsc := ascending
        return this
    }

    /**
     * @method Limit
     * @description Limit results
     */
    Limit(count) {
        this.limitCount := count
        return this
    }

    /**
     * @method Execute
     * @description Execute query and return results
     */
    Execute() {
        results := []

        ; Apply filters
        for key, value in this.data {
            include := true

            for filter in this.filters {
                if (!filter.Call(key, value)) {
                    include := false
                    break
                }
            }

            if (include)
                results.Push({key: key, value: value})
        }

        ; Sort if needed
        if (this.sortKey != "") {
            ; Simple bubble sort
            Loop results.Length {
                i := A_Index
                Loop results.Length - i {
                    j := A_Index
                    val1 := results[j].value.HasProp(this.sortKey) ? results[j].value.%this.sortKey% : ""
                    val2 := results[j + 1].value.HasProp(this.sortKey) ? results[j + 1].value.%this.sortKey% : ""

                    shouldSwap := this.sortAsc ? (val1 > val2) : (val1 < val2)

                    if (shouldSwap) {
                        temp := results[j]
                        results[j] := results[j + 1]
                        results[j + 1] := temp
                    }
                }
            }
        }

        ; Apply limit
        if (this.limitCount > 0 && results.Length > this.limitCount) {
            limited := []
            Loop this.limitCount {
                limited.Push(results[A_Index])
            }
            results := limited
        }

        return results
    }

    /**
     * @method Reset
     * @description Reset query
     */
    Reset() {
        this.filters := []
        this.sortKey := ""
        this.sortAsc := true
        this.limitCount := 0
        return this
    }

    /**
     * @method Set
     * @description Add data
     */
    Set(key, value) {
        this.data.Set(key, value)
    }
}

Example7_QueryBuilder() {
    qb := QueryBuilder()

    ; Add sample data
    qb.Set("emp1", {name: "Alice", dept: "Engineering", salary: 80000})
    qb.Set("emp2", {name: "Bob", dept: "Sales", salary: 60000})
    qb.Set("emp3", {name: "Carol", dept: "Engineering", salary: 95000})
    qb.Set("emp4", {name: "David", dept: "Marketing", salary: 65000})
    qb.Set("emp5", {name: "Eve", dept: "Engineering", salary: 75000})

    output := "=== Query Builder Example ===`n`n"

    ; Query: Engineering dept, salary > 70000, limit 2
    results := qb.Reset()
        .Where((k, v) => v.dept = "Engineering")
        .Where((k, v) => v.salary > 70000)
        .OrderBy("salary", false)
        .Limit(2)
        .Execute()

    output .= "Engineering employees with salary > 70000:`n"
    for item in results {
        output .= "  " item.value.name ": $" item.value.salary "`n"
    }

    MsgBox(output, "Query Builder")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Get() - Safe Data Retrieval Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Safe Data Retrieval Patterns")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Null-Safe")
        .OnEvent("Click", (*) => Example1_NullSafeNavigation())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Validated")
        .OnEvent("Click", (*) => Example2_ValidatedRetrieval())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Conditional")
        .OnEvent("Click", (*) => Example3_ConditionalRetrieval())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Batch")
        .OnEvent("Click", (*) => Example4_BatchRetrieval())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Cached")
        .OnEvent("Click", (*) => Example5_CachedRetrieval())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Transform")
        .OnEvent("Click", (*) => Example6_TransformRetrieval())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Query Builder")
        .OnEvent("Click", (*) => Example7_QueryBuilder())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_NullSafeNavigation()
        Example2_ValidatedRetrieval()
        Example3_ConditionalRetrieval()
        Example4_BatchRetrieval()
        Example5_CachedRetrieval()
        Example6_TransformRetrieval()
        Example7_QueryBuilder()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
