#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Get_01_BasicUsage.ahk
 * 
 * @description Comprehensive examples of Map.Get() method for basic usage
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * The Map.Get() method retrieves values from a Map object.
 * Syntax: MapObject.Get(Key [, DefaultValue])
 * Returns: The value associated with the key, or default value if key doesn't exist
 * 
 * Key Features:
 * - Retrieve values by key
 * - Provide default values for missing keys
 * - Safe value retrieval without exceptions
 * - Type-safe data access
 */

;=============================================================================
; Example 1: Basic Value Retrieval
;=============================================================================

/**
 * @function Example1_BasicGet
 * @description Demonstrates fundamental Map.Get() operations
 * @returns {void}
 */
Example1_BasicGet() {
    ; Create and populate a map
    userInfo := Map(
        "firstName", "John",
        "lastName", "Doe",
        "age", 30,
        "email", "john.doe@example.com",
        "active", true
    )

    output := "=== Example 1: Basic Get Operations ===`n`n"

    ; Retrieve values using Get()
    output .= "First Name: " userInfo.Get("firstName") "`n"
    output .= "Last Name: " userInfo.Get("lastName") "`n"
    output .= "Age: " userInfo.Get("age") "`n"
    output .= "Email: " userInfo.Get("email") "`n"
    output .= "Active: " (userInfo.Get("active") ? "Yes" : "No") "`n`n"

    ; Alternative: Direct indexing (throws error if key doesn't exist)
    output .= "Using direct indexing:`n"
    output .= "First Name: " userInfo["firstName"] "`n"

    MsgBox(output, "Example 1 Results")
}

;=============================================================================
; Example 2: Default Values for Missing Keys
;=============================================================================

/**
 * @function Example2_DefaultValues
 * @description Shows how to use default values with Get()
 * @returns {void}
 */
Example2_DefaultValues() {
    config := Map(
        "theme", "dark",
        "fontSize", 12
    )

    output := "=== Example 2: Default Values ===`n`n"

    ; Get existing keys
    output .= "Theme: " config.Get("theme", "light") "`n"
    output .= "Font Size: " config.Get("fontSize", 14) "`n`n"

    ; Get non-existing keys with defaults
    output .= "Language (not set): " config.Get("language", "en-US") "`n"
    output .= "Auto Save (not set): " config.Get("autoSave", true) "`n"
    output .= "Max Undo (not set): " config.Get("maxUndo", 50) "`n`n"

    ; Without default value - returns empty string
    output .= "Non-existent key without default: '"
    output .= config.Get("nonExistent") "' (empty string)`n"

    MsgBox(output, "Example 2 Results")
}

;=============================================================================
; Example 3: Safe Data Access Pattern
;=============================================================================

/**
 * @function Example3_SafeAccess
 * @description Demonstrates safe data access patterns
 * @returns {void}
 */
Example3_SafeAccess() {
    ; Simulate incomplete user data
    users := Map(
        "user1", Map("name", "Alice", "email", "alice@example.com", "phone", "555-1234"),
        "user2", Map("name", "Bob", "email", "bob@example.com"),  ; No phone
        "user3", Map("name", "Carol")  ; Only name
    )

    output := "=== Example 3: Safe Access ===`n`n"

    for userId, userData in users {
        output .= userId ":`n"
        output .= "  Name: " userData.Get("name", "Unknown") "`n"
        output .= "  Email: " userData.Get("email", "Not provided") "`n"
        output .= "  Phone: " userData.Get("phone", "Not provided") "`n"
        output .= "`n"
    }

    MsgBox(output, "Example 3 Results")
}

;=============================================================================
; Example 4: Type-Specific Getters
;=============================================================================

/**
 * @class TypedMapReader
 * @description Helper class for type-safe Map reading
 */
class TypedMapReader {
    data := Map()

    __New(initialData := "") {
        if (IsObject(initialData)) {
            for key, value in initialData {
                this.data.Set(key, value)
            }
        }
    }

    /**
     * @method GetString
     * @description Get value as string with default
     */
    GetString(key, defaultValue := "") {
        value := this.data.Get(key, defaultValue)
        return String(value)
    }

    /**
     * @method GetInteger
     * @description Get value as integer with default
     */
    GetInteger(key, defaultValue := 0) {
        value := this.data.Get(key, defaultValue)
        return Integer(value)
    }

    /**
     * @method GetFloat
     * @description Get value as float with default
     */
    GetFloat(key, defaultValue := 0.0) {
        value := this.data.Get(key, defaultValue)
        return Float(value)
    }

    /**
     * @method GetBool
     * @description Get value as boolean with default
     */
    GetBool(key, defaultValue := false) {
        value := this.data.Get(key, defaultValue)
        return value ? true : false
    }

    /**
     * @method GetArray
     * @description Get value as array with default
     */
    GetArray(key, defaultValue := "") {
        value := this.data.Get(key, defaultValue)
        return IsObject(value) ? value : (defaultValue != "" ? defaultValue : [])
    }
}

Example4_TypedGetters() {
    reader := TypedMapReader(Map(
        "count", "42",
        "price", "19.99",
        "enabled", 1,
        "tags", ["red", "blue", "green"]
    ))

    output := "=== Example 4: Type-Specific Getters ===`n`n"

    output .= "Count (as integer): " reader.GetInteger("count") "`n"
    output .= "Price (as float): " reader.GetFloat("price") "`n"
    output .= "Enabled (as bool): " (reader.GetBool("enabled") ? "true" : "false") "`n"

    tags := reader.GetArray("tags")
    output .= "Tags (as array): " ArrayToString(tags) "`n`n"

    ; Using defaults for missing keys
    output .= "Missing integer with default: " reader.GetInteger("missing", 100) "`n"
    output .= "Missing string with default: " reader.GetString("missing", "N/A") "`n"
    output .= "Missing array with default: " ArrayToString(reader.GetArray("missing", ["default"])) "`n"

    MsgBox(output, "Example 4 Results")
}

/**
 * @function ArrayToString
 * @description Convert array to string representation
 */
ArrayToString(arr) {
    if (!IsObject(arr) || arr.Length = 0)
        return "[]"

    result := ""
    for item in arr {
        result .= (result ? ", " : "") . item
    }
    return "[" result "]"
}

;=============================================================================
; Example 5: Nested Map Navigation
;=============================================================================

/**
 * @function Example5_NestedAccess
 * @description Accessing nested Map structures safely
 * @returns {void}
 */
Example5_NestedAccess() {
    ; Create nested structure
    database := Map(
        "users", Map(
            "john", Map(
                "profile", Map(
                    "name", "John Doe",
                    "age", 30
                ),
                "settings", Map(
                    "theme", "dark",
                    "notifications", true
                )
            )
        )
    )

    output := "=== Example 5: Nested Access ===`n`n"

    ; Safe nested access
    users := database.Get("users", Map())
    john := users.Get("john", Map())
    profile := john.Get("profile", Map())
    settings := john.Get("settings", Map())

    output .= "Name: " profile.Get("name", "Unknown") "`n"
    output .= "Age: " profile.Get("age", 0) "`n"
    output .= "Theme: " settings.Get("theme", "light") "`n"
    output .= "Notifications: " (settings.Get("notifications", false) ? "On" : "Off") "`n`n"

    ; Try accessing non-existent user
    jane := users.Get("jane", Map())
    janeProfile := jane.Get("profile", Map())

    output .= "Jane's name: " janeProfile.Get("name", "User not found") "`n"

    MsgBox(output, "Example 5 Results")
}

;=============================================================================
; Example 6: Get with Computation
;=============================================================================

/**
 * @class ComputedMapReader
 * @description Map reader with computed defaults
 */
class ComputedMapReader {
    data := Map()

    __New(initialData) {
        this.data := initialData
    }

    /**
     * @method GetOrCompute
     * @description Get value or compute it if missing
     */
    GetOrCompute(key, computeFunc) {
        if (this.data.Has(key)) {
            return this.data.Get(key)
        }

        ; Compute the value
        value := computeFunc.Call()
        this.data.Set(key, value)

        return value
    }

    /**
     * @method GetWithFallback
     * @description Try multiple keys, return first found
     */
    GetWithFallback(keys, defaultValue := "") {
        for key in keys {
            if (this.data.Has(key)) {
                return this.data.Get(key)
            }
        }
        return defaultValue
    }
}

Example6_ComputedGet() {
    reader := ComputedMapReader(Map(
        "width", 800,
        "height", 600
    ))

    output := "=== Example 6: Get with Computation ===`n`n"

    ; Get existing value
    width := reader.data.Get("width")
    output .= "Width: " width "`n"

    ; Compute area if not exists
    area := reader.GetOrCompute("area", () => reader.data.Get("width") * reader.data.Get("height"))
    output .= "Area (computed): " area "`n"

    ; Second call returns cached value
    area2 := reader.GetOrCompute("area", () => "This won't be called")
    output .= "Area (cached): " area2 "`n`n"

    ; Fallback example
    reader2 := ComputedMapReader(Map(
        "colour", "red"  ; British spelling
    ))

    color := reader2.GetWithFallback(["color", "colour"], "black")
    output .= "Color (with fallback): " color "`n"

    MsgBox(output, "Example 6 Results")
}

;=============================================================================
; Example 7: Batch Get Operations
;=============================================================================

/**
 * @function Example7_BatchGet
 * @description Retrieve multiple values at once
 * @returns {void}
 */
Example7_BatchGet() {
    settings := Map(
        "app.name", "MyApp",
        "app.version", "1.0.0",
        "window.width", 1024,
        "window.height", 768,
        "theme.primary", "#0078D7",
        "theme.secondary", "#005A9E"
    )

    /**
     * @function GetMultiple
     * @description Get multiple values and return as Map
     */
    GetMultiple(sourceMap, keys) {
        result := Map()
        for key in keys {
            result.Set(key, sourceMap.Get(key, ""))
        }
        return result
    }

    /**
     * @function GetByPrefix
     * @description Get all keys with specific prefix
     */
    GetByPrefix(sourceMap, prefix) {
        result := Map()
        for key, value in sourceMap {
            if (InStr(key, prefix) = 1) {
                result.Set(key, value)
            }
        }
        return result
    }

    output := "=== Example 7: Batch Get ===`n`n"

    ; Get specific keys
    appSettings := GetMultiple(settings, ["app.name", "app.version"])
    output .= "App Settings:`n"
    for key, value in appSettings {
        output .= "  " key ": " value "`n"
    }
    output .= "`n"

    ; Get by prefix
    themeSettings := GetByPrefix(settings, "theme.")
    output .= "Theme Settings:`n"
    for key, value in themeSettings {
        output .= "  " key ": " value "`n"
    }

    MsgBox(output, "Example 7 Results")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Get() Method - Basic Usage Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center",
        "Click buttons to see different Map.Get() examples")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Basic Get")
        .OnEvent("Click", (*) => Example1_BasicGet())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Default Values")
        .OnEvent("Click", (*) => Example2_DefaultValues())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Safe Access")
        .OnEvent("Click", (*) => Example3_SafeAccess())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Typed Getters")
        .OnEvent("Click", (*) => Example4_TypedGetters())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Nested Access")
        .OnEvent("Click", (*) => Example5_NestedAccess())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Computed Get")
        .OnEvent("Click", (*) => Example6_ComputedGet())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Batch Get")
        .OnEvent("Click", (*) => Example7_BatchGet())

    ; Interactive section
    demoGui.Add("GroupBox", "x10 y200 w470 h110", "Interactive Get Tester")

    demoGui.Add("Text", "x20 y225", "Key:")
    keyInput := demoGui.Add("Edit", "x70 y222 w150")

    demoGui.Add("Text", "x240 y225", "Default:")
    defaultInput := demoGui.Add("Edit", "x300 y222 w170")

    demoGui.Add("Button", "x20 y255 w200 h25", "Get Value")
        .OnEvent("Click", GetValue)

    resultDisplay := demoGui.Add("Edit", "x20 y285 w450 h20 ReadOnly")

    ; Store controls
    demoGui.keyInput := keyInput
    demoGui.defaultInput := defaultInput
    demoGui.resultDisplay := resultDisplay
    demoGui.testMap := Map(
        "name", "John Doe",
        "age", 30,
        "city", "New York"
    )

    GetValue(*) {
        key := demoGui.keyInput.Value
        defaultVal := demoGui.defaultInput.Value

        if (key = "") {
            demoGui.resultDisplay.Value := "Please enter a key"
            return
        }

        result := demoGui.testMap.Get(key, defaultVal)
        demoGui.resultDisplay.Value := "Result: " result
    }

    demoGui.Add("Button", "x230 y255 w240 h25", "Show Available Keys")
        .OnEvent("Click", ShowKeys)

    ShowKeys(*) {
        keys := ""
        for key, value in demoGui.testMap {
            keys .= (keys ? ", " : "") . key
        }
        MsgBox("Available keys: " keys, "Test Map")
    }

    demoGui.Add("Button", "x10 y320 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_BasicGet()
        Example2_DefaultValues()
        Example3_SafeAccess()
        Example4_TypedGetters()
        Example5_NestedAccess()
        Example6_ComputedGet()
        Example7_BatchGet()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h360")
}

CreateDemoGUI()
