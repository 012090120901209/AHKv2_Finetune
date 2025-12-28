#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Has_01_BasicUsage.ahk
 * 
 * @description Comprehensive examples of Map.Has() method for basic usage
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * The Map.Has() method checks if a key exists in a Map object.
 * Syntax: MapObject.Has(Key)
 * Returns: Boolean (true if key exists, false otherwise)
 * 
 * Key Features:
 * - Check key existence
 * - Validate data presence
 * - Conditional logic based on key existence
 * - Safe data access patterns
 */

;=============================================================================
; Example 1: Basic Key Existence Check
;=============================================================================

/**
 * @function Example1_BasicHas
 * @description Demonstrates fundamental Map.Has() operations
 * @returns {void}
 */
Example1_BasicHas() {
    ; Create and populate map
    userProfile := Map(
        "username", "john_doe",
        "email", "john@example.com",
        "age", 30,
        "verified", true
    )

    output := "=== Example 1: Basic Has Operations ===`n`n"

    ; Check existing keys
    output .= "Has 'username': " (userProfile.Has("username") ? "Yes" : "No") "`n"
    output .= "Has 'email': " (userProfile.Has("email") ? "Yes" : "No") "`n"
    output .= "Has 'age': " (userProfile.Has("age") ? "Yes" : "No") "`n`n"

    ; Check non-existing keys
    output .= "Has 'phone': " (userProfile.Has("phone") ? "Yes" : "No") "`n"
    output .= "Has 'address': " (userProfile.Has("address") ? "Yes" : "No") "`n"
    output .= "Has 'middleName': " (userProfile.Has("middleName") ? "Yes" : "No") "`n`n"

    ; Count existing vs missing
    testKeys := ["username", "email", "phone", "age", "address", "verified"]
    existing := 0
    missing := 0

    for key in testKeys {
        if (userProfile.Has(key))
            existing++
        else
            missing++
    }

    output .= "Summary:`n"
    output .= "  Existing keys: " existing "`n"
    output .= "  Missing keys: " missing "`n"
    output .= "  Total tested: " testKeys.Length "`n"

    MsgBox(output, "Example 1 Results")
}

;=============================================================================
; Example 2: Conditional Data Access
;=============================================================================

/**
 * @function Example2_ConditionalAccess
 * @description Using Has() for safe conditional data access
 * @returns {void}
 */
Example2_ConditionalAccess() {
    settings := Map(
        "theme", "dark",
        "fontSize", 14,
        "autoSave", true
    )

    output := "=== Example 2: Conditional Access ===`n`n"

    ; Safe access pattern
    output .= "Settings:`n"

    if (settings.Has("theme"))
        output .= "  Theme: " settings["theme"] "`n"
    else
        output .= "  Theme: Not set (using default)`n"

    if (settings.Has("fontSize"))
        output .= "  Font Size: " settings["fontSize"] "`n"
    else
        output .= "  Font Size: Not set (using default)`n"

    if (settings.Has("language"))
        output .= "  Language: " settings["language"] "`n"
    else
        output .= "  Language: Not set (using default: en-US)`n"

    output .= "`n"

    ; Conditional update
    if (!settings.Has("language")) {
        settings.Set("language", "en-US")
        output .= "Language was not set, added default value`n"
    }

    if (!settings.Has("lineNumbers")) {
        settings.Set("lineNumbers", true)
        output .= "Line numbers was not set, added default value`n"
    }

    output .= "`nTotal settings: " settings.Count

    MsgBox(output, "Example 2 Results")
}

;=============================================================================
; Example 3: Validation and Required Fields
;=============================================================================

/**
 * @class FormValidator
 * @description Validate form data using Has()
 */
class FormValidator {
    data := Map()
    requiredFields := []
    optionalFields := []

    /**
     * @method SetRequired
     * @description Set required field names
     */
    SetRequired(fields) {
        this.requiredFields := fields
    }

    /**
     * @method SetOptional
     * @description Set optional field names
     */
    SetOptional(fields) {
        this.optionalFields := fields
    }

    /**
     * @method SetData
     * @description Set form data
     */
    SetData(formData) {
        this.data := formData
    }

    /**
     * @method Validate
     * @description Validate that all required fields exist
     * @returns {Object} Validation result
     */
    Validate() {
        missing := []
        present := []

        for field in this.requiredFields {
            if (this.data.Has(field))
                present.Push(field)
            else
                missing.Push(field)
        }

        return {
            valid: missing.Length = 0,
            missing: missing,
            present: present,
            total: this.requiredFields.Length
        }
    }

    /**
     * @method GetCompleteness
     * @description Get form completeness percentage
     * @returns {Integer} Percentage complete
     */
    GetCompleteness() {
        allFields := []
        allFields.Push(this.requiredFields*)
        allFields.Push(this.optionalFields*)

        filled := 0
        for field in allFields {
            if (this.data.Has(field))
                filled++
        }

        return allFields.Length > 0 ? Round((filled / allFields.Length) * 100) : 0
    }
}

Example3_Validation() {
    validator := FormValidator()

    ; Define fields
    validator.SetRequired(["name", "email", "password"])
    validator.SetOptional(["phone", "address", "company"])

    ; Test with incomplete data
    formData1 := Map(
        "name", "John Doe",
        "email", "john@example.com"
        ; Missing password
    )

    validator.SetData(formData1)
    result := validator.Validate()

    output := "=== Example 3: Validation ===`n`n"
    output .= "Test 1 - Incomplete form:`n"
    output .= "  Valid: " (result.valid ? "Yes" : "No") "`n"
    output .= "  Missing: " ArrayJoin(result.missing, ", ") "`n"
    output .= "  Completeness: " validator.GetCompleteness() "%`n`n"

    ; Test with complete data
    formData2 := Map(
        "name", "Jane Smith",
        "email", "jane@example.com",
        "password", "secret123",
        "phone", "555-1234",
        "company", "Acme Corp"
    )

    validator.SetData(formData2)
    result := validator.Validate()

    output .= "Test 2 - Complete form:`n"
    output .= "  Valid: " (result.valid ? "Yes" : "No") "`n"
    output .= "  Present: " ArrayJoin(result.present, ", ") "`n"
    output .= "  Completeness: " validator.GetCompleteness() "%`n"

    MsgBox(output, "Example 3 Results")
}

ArrayJoin(arr, delimiter) {
    result := ""
    for item in arr {
        result .= (result ? delimiter : "") . item
    }
    return result
}

;=============================================================================
; Example 4: Property Detection Pattern
;=============================================================================

/**
 * @function Example4_PropertyDetection
 * @description Detect available properties/features
 * @returns {void}
 */
Example4_PropertyDetection() {
    ; Simulate different device capabilities
    device1 := Map(
        "camera", true,
        "gps", true,
        "nfc", false,
        "fingerprint", true
    )

    device2 := Map(
        "camera", true,
        "gps", false
        ; Missing nfc and fingerprint
    )

    /**
     * @function DetectFeatures
     * @description Detect which features are available
     */
    DetectFeatures(device) {
        features := ["camera", "gps", "nfc", "fingerprint", "bluetooth"]
        available := []
        unavailable := []

        for feature in features {
            if (device.Has(feature) && device[feature])
                available.Push(feature)
            else
                unavailable.Push(feature)
        }

        return { available: available, unavailable: unavailable }
    }

    output := "=== Example 4: Property Detection ===`n`n"

    ; Device 1
    result1 := DetectFeatures(device1)
    output .= "Device 1:`n"
    output .= "  Available: " ArrayJoin(result1.available, ", ") "`n"
    output .= "  Unavailable: " ArrayJoin(result1.unavailable, ", ") "`n`n"

    ; Device 2
    result2 := DetectFeatures(device2)
    output .= "Device 2:`n"
    output .= "  Available: " ArrayJoin(result2.available, ", ") "`n"
    output .= "  Unavailable: " ArrayJoin(result2.unavailable, ", ") "`n"

    MsgBox(output, "Example 4 Results")
}

;=============================================================================
; Example 5: Cache Key Existence Check
;=============================================================================

/**
 * @class SimpleCache
 * @description Cache with existence checking
 */
class SimpleCache {
    cache := Map()

    /**
     * @method IsCached
     * @description Check if key is in cache
     */
    IsCached(key) {
        return this.cache.Has(key)
    }

    /**
     * @method GetOrCompute
     * @description Get from cache or compute
     */
    GetOrCompute(key, computeFunc) {
        if (this.IsCached(key)) {
            return { value: this.cache[key], fromCache: true }
        }

        value := computeFunc.Call()
        this.cache.Set(key, value)

        return { value: value, fromCache: false }
    }

    /**
     * @method GetCacheInfo
     * @description Get cache information
     */
    GetCacheInfo(keys) {
        cached := 0
        notCached := 0

        for key in keys {
            if (this.IsCached(key))
                cached++
            else
                notCached++
        }

        return { cached: cached, notCached: notCached, hitRate: Round((cached / keys.Length) * 100) }
    }
}

Example5_CacheCheck() {
    cache := SimpleCache()

    output := "=== Example 5: Cache Existence ===`n`n"

    ; Pre-populate some cache entries
    cache.cache.Set("user:1", "Alice")
    cache.cache.Set("user:2", "Bob")

    ; Test cache existence
    testKeys := ["user:1", "user:2", "user:3", "user:4"]

    output .= "Cache status:`n"
    for key in testKeys {
        status := cache.IsCached(key) ? "HIT" : "MISS"
        output .= "  " key ": " status "`n"
    }

    ; Get cache info
    info := cache.GetCacheInfo(testKeys)
    output .= "`nCache statistics:`n"
    output .= "  Cached: " info.cached "`n"
    output .= "  Not cached: " info.notCached "`n"
    output .= "  Hit rate: " info.hitRate "%`n"

    MsgBox(output, "Example 5 Results")
}

;=============================================================================
; Example 6: Multi-Key Existence Check
;=============================================================================

/**
 * @function Example6_MultiKeyCheck
 * @description Check multiple keys at once
 * @returns {void}
 */
Example6_MultiKeyCheck() {
    data := Map(
        "id", 123,
        "name", "Product A",
        "price", 99.99,
        "category", "Electronics"
    )

    /**
     * @function HasAll
     * @description Check if all keys exist
     */
    HasAll(mapObj, keys) {
        for key in keys {
            if (!mapObj.Has(key))
                return false
        }
        return true
    }

    /**
     * @function HasAny
     * @description Check if any key exists
     */
    HasAny(mapObj, keys) {
        for key in keys {
            if (mapObj.Has(key))
                return true
        }
        return false
    }

    /**
     * @function CountExisting
     * @description Count how many keys exist
     */
    CountExisting(mapObj, keys) {
        count := 0
        for key in keys {
            if (mapObj.Has(key))
                count++
        }
        return count
    }

    output := "=== Example 6: Multi-Key Check ===`n`n"

    requiredKeys := ["id", "name", "price"]
    optionalKeys := ["description", "image", "category"]
    missingKeys := ["weight", "dimensions"]

    output .= "Has all required keys: " (HasAll(data, requiredKeys) ? "Yes" : "No") "`n"
    output .= "Has any optional keys: " (HasAny(data, optionalKeys) ? "Yes" : "No") "`n"
    output .= "Has any missing keys: " (HasAny(data, missingKeys) ? "Yes" : "No") "`n`n"

    output .= "Count of optional keys present: "
    output .= CountExisting(data, optionalKeys) "/" optionalKeys.Length "`n"

    MsgBox(output, "Example 6 Results")
}

;=============================================================================
; Example 7: Dynamic Key Generation and Checking
;=============================================================================

/**
 * @function Example7_DynamicKeys
 * @description Check dynamically generated keys
 * @returns {void}
 */
Example7_DynamicKeys() {
    permissions := Map(
        "user.read", true,
        "user.write", true,
        "admin.read", false,
        "admin.write", false
    )

    /**
     * @function HasPermission
     * @description Check if user has specific permission
     */
    HasPermission(permMap, resource, action) {
        key := resource "." action
        return permMap.Has(key) && permMap[key]
    }

    /**
     * @function GetUserPermissions
     * @description Get all permissions for a resource
     */
    GetUserPermissions(permMap, resource) {
        actions := ["read", "write", "delete", "execute"]
        granted := []
        denied := []

        for action in actions {
            if (HasPermission(permMap, resource, action))
                granted.Push(action)
            else
                denied.Push(action)
        }

        return { granted: granted, denied: denied }
    }

    output := "=== Example 7: Dynamic Keys ===`n`n"

    ; Check specific permissions
    output .= "Permission checks:`n"
    output .= "  user.read: " (HasPermission(permissions, "user", "read") ? "Granted" : "Denied") "`n"
    output .= "  user.write: " (HasPermission(permissions, "user", "write") ? "Granted" : "Denied") "`n"
    output .= "  admin.write: " (HasPermission(permissions, "admin", "write") ? "Granted" : "Denied") "`n"
    output .= "  user.delete: " (HasPermission(permissions, "user", "delete") ? "Granted" : "Denied") "`n`n"

    ; Get all user permissions
    userPerms := GetUserPermissions(permissions, "user")
    output .= "User permissions:`n"
    output .= "  Granted: " ArrayJoin(userPerms.granted, ", ") "`n"
    output .= "  Denied: " ArrayJoin(userPerms.denied, ", ") "`n"

    MsgBox(output, "Example 7 Results")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Has() Method - Basic Usage Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center",
        "Check key existence with Map.Has()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Basic Has")
        .OnEvent("Click", (*) => Example1_BasicHas())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Conditional")
        .OnEvent("Click", (*) => Example2_ConditionalAccess())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Validation")
        .OnEvent("Click", (*) => Example3_Validation())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Detection")
        .OnEvent("Click", (*) => Example4_PropertyDetection())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Cache Check")
        .OnEvent("Click", (*) => Example5_CacheCheck())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Multi-Key")
        .OnEvent("Click", (*) => Example6_MultiKeyCheck())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Dynamic Keys")
        .OnEvent("Click", (*) => Example7_DynamicKeys())

    ; Interactive tester
    demoGui.Add("GroupBox", "x10 y200 w470 h100", "Interactive Has Tester")

    testMap := Map(
        "name", "John",
        "age", 30,
        "city", "New York"
    )

    demoGui.Add("Text", "x20 y225", "Check key:")
    keyInput := demoGui.Add("Edit", "x90 y222 w180")

    demoGui.Add("Button", "x280 y222 w90 h25", "Check")
        .OnEvent("Click", CheckKey)

    resultDisplay := demoGui.Add("Edit", "x20 y255 w450 h35 ReadOnly")

    demoGui.testMap := testMap
    demoGui.keyInput := keyInput
    demoGui.resultDisplay := resultDisplay

    CheckKey(*) {
        key := demoGui.keyInput.Value
        if (key = "") {
            demoGui.resultDisplay.Value := "Please enter a key to check"
            return
        }

        exists := demoGui.testMap.Has(key)
        result := exists ? "EXISTS" : "DOES NOT EXIST"
        value := exists ? " (Value: " demoGui.testMap[key] ")" : ""

        demoGui.resultDisplay.Value := "Key '" key "' " result value
    }

    demoGui.Add("Button", "x380 y222 w90 h25", "Show Keys")
        .OnEvent("Click", ShowKeys)

    ShowKeys(*) {
        keys := []
        for key in demoGui.testMap {
            keys.Push(key)
        }
        MsgBox("Available keys: " ArrayJoin(keys, ", "), "Test Map")
    }

    demoGui.Add("Button", "x10 y310 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_BasicHas()
        Example2_ConditionalAccess()
        Example3_Validation()
        Example4_PropertyDetection()
        Example5_CacheCheck()
        Example6_MultiKeyCheck()
        Example7_DynamicKeys()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h350")
}

CreateDemoGUI()
