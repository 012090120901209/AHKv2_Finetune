#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Set_01_BasicUsage.ahk
 * 
 * @description Comprehensive examples of Map.Set() method for basic usage
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * The Map.Set() method adds or updates key-value pairs in a Map object.
 * Syntax: MapObject.Set(Key, Value [, Key2, Value2, ...])
 * Returns: The Map object itself (for method chaining)
 * 
 * Key Features:
 * - Add new key-value pairs
 * - Update existing values
 * - Chain multiple Set operations
 * - Support multiple key-value pairs in single call
 * - Works with any data type as key or value
 */

;=============================================================================
; Example 1: Basic Set Operations
;=============================================================================

/**
 * @function Example1_BasicSet
 * @description Demonstrates fundamental Map.Set() operations
 * @returns {void}
 */
Example1_BasicSet() {
    ; Create empty map
    userInfo := Map()

    ; Add single key-value pairs
    userInfo.Set("name", "John Doe")
    userInfo.Set("age", 30)
    userInfo.Set("email", "john@example.com")
    userInfo.Set("active", true)

    ; Display the map
    output := "=== Example 1: Basic Set Operations ===`n`n"
    output .= "Name: " userInfo["name"] "`n"
    output .= "Age: " userInfo["age"] "`n"
    output .= "Email: " userInfo["email"] "`n"
    output .= "Active: " (userInfo["active"] ? "Yes" : "No") "`n"
    output .= "`nTotal entries: " userInfo.Count "`n"

    MsgBox(output, "Example 1 Results")
}

;=============================================================================
; Example 2: Multiple Key-Value Pairs in Single Set
;=============================================================================

/**
 * @function Example2_MultipleSet
 * @description Shows how to set multiple key-value pairs at once
 * @returns {void}
 */
Example2_MultipleSet() {
    ; Create map with multiple entries in one Set() call
    settings := Map()
    settings.Set(
        "theme", "dark",
        "fontSize", 14,
        "autoSave", true,
        "language", "en-US",
        "maxHistory", 50
    )

    output := "=== Example 2: Multiple Set ===`n`n"
    output .= "Settings configured:`n`n"

    for key, value in settings {
        output .= "  " key ": " value "`n"
    }

    MsgBox(output, "Example 2 Results")
}

;=============================================================================
; Example 3: Updating Existing Values
;=============================================================================

/**
 * @function Example3_UpdateValues
 * @description Demonstrates updating existing map values with Set()
 * @returns {void}
 */
Example3_UpdateValues() {
    ; Initial map
    product := Map(
        "id", "PROD001",
        "name", "Wireless Mouse",
        "price", 29.99,
        "stock", 100
    )

    output := "=== Example 3: Update Values ===`n`n"
    output .= "Initial state:`n"
    output .= "  Price: $" product["price"] "`n"
    output .= "  Stock: " product["stock"] " units`n`n"

    ; Simulate a sale - update price and stock
    product.Set("price", 24.99)  ; Update price
    product.Set("stock", 95)      ; Update stock
    product.Set("onSale", true)   ; Add new field

    output .= "After sale:`n"
    output .= "  Price: $" product["price"] "`n"
    output .= "  Stock: " product["stock"] " units`n"
    output .= "  On Sale: " (product["onSale"] ? "Yes" : "No") "`n"

    MsgBox(output, "Example 3 Results")
}

;=============================================================================
; Example 4: Method Chaining with Set
;=============================================================================

/**
 * @function Example4_MethodChaining
 * @description Shows how to chain Set() methods for fluent syntax
 * @returns {void}
 */
Example4_MethodChaining() {
    ; Create and populate map using method chaining
    ; Set() returns the map object, allowing chaining
    config := Map()
        .Set("host", "localhost")
        .Set("port", 8080)
        .Set("protocol", "https")
        .Set("timeout", 30)
        .Set("retries", 3)
        .Set("debug", false)

    output := "=== Example 4: Method Chaining ===`n`n"
    output .= "Connection configuration:`n`n"
    output .= "  URL: " config["protocol"] "://" config["host"] ":" config["port"] "`n"
    output .= "  Timeout: " config["timeout"] " seconds`n"
    output .= "  Max retries: " config["retries"] "`n"
    output .= "  Debug mode: " (config["debug"] ? "On" : "Off") "`n"

    MsgBox(output, "Example 4 Results")
}

;=============================================================================
; Example 5: Different Data Types as Keys and Values
;=============================================================================

/**
 * @function Example5_DataTypes
 * @description Demonstrates using various data types with Set()
 * @returns {void}
 */
Example5_DataTypes() {
    mixedMap := Map()

    ; String keys with different value types
    mixedMap.Set("string", "Hello World")
    mixedMap.Set("number", 42)
    mixedMap.Set("float", 3.14159)
    mixedMap.Set("boolean", true)
    mixedMap.Set("array", [1, 2, 3, 4, 5])
    mixedMap.Set("object", Map("nested", "value"))

    ; Numeric keys
    mixedMap.Set(1, "Number key 1")
    mixedMap.Set(100, "Number key 100")

    output := "=== Example 5: Data Types ===`n`n"
    output .= "String key with string value: " mixedMap["string"] "`n"
    output .= "String key with number value: " mixedMap["number"] "`n"
    output .= "String key with float value: " mixedMap["float"] "`n"
    output .= "String key with boolean value: " mixedMap["boolean"] "`n"
    output .= "String key with array value: " ArrayToString(mixedMap["array"]) "`n"
    output .= "String key with object value: Nested=" mixedMap["object"]["nested"] "`n"
    output .= "Numeric key 1: " mixedMap[1] "`n"
    output .= "Numeric key 100: " mixedMap[100] "`n"

    MsgBox(output, "Example 5 Results")
}

;=============================================================================
; Example 6: Building Map from Array Data
;=============================================================================

/**
 * @function Example6_FromArrayData
 * @description Shows how to populate a Map from array data using Set()
 * @returns {void}
 */
Example6_FromArrayData() {
    ; Sample data: array of user information
    users := [{
        id: "U001", name: "Alice Johnson", role: "Admin" }, {
            id: "U002", name: "Bob Smith", role: "User" }, {
                id: "U003", name: "Carol White", role: "Moderator" }, {
                    id: "U004", name: "David Brown", role: "User"
                }
    ]

    ; Build map indexed by user ID
    userMap := Map()
    for user in users {
        userMap.Set(user.id, Map(
            "name", user.name,
            "role", user.role
        ))
    }

    output := "=== Example 6: From Array Data ===`n`n"
    output .= "User directory:`n`n"

    for userId, userData in userMap {
        output .= userId ": " userData["name"] " (" userData["role"] ")`n"
    }

    output .= "`nTotal users: " userMap.Count "`n"

    MsgBox(output, "Example 6 Results")
}

;=============================================================================
; Example 7: Dynamic Map Building with Computed Values
;=============================================================================

/**
 * @function Example7_ComputedValues
 * @description Demonstrates setting values based on computations
 * @returns {void}
 */
Example7_ComputedValues() {
    ; Create multiplication table using Set()
    multiplicationTable := Map()

    baseNumber := 7
    for i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10] {
        key := baseNumber " x " i
        value := baseNumber * i
        multiplicationTable.Set(key, value)
    }

    output := "=== Example 7: Computed Values ===`n`n"
    output .= "Multiplication Table for " baseNumber ":`n`n"

    for equation, result in multiplicationTable {
        output .= equation " = " result "`n"
    }

    ; Add summary statistics
    total := 0
    for equation, result in multiplicationTable {
        total += result
    }

    multiplicationTable.Set("_sum", total)
    multiplicationTable.Set("_count", 10)
    multiplicationTable.Set("_average", total / 10)

    output .= "`nStatistics:`n"
    output .= "  Sum: " multiplicationTable["_sum"] "`n"
    output .= "  Count: " multiplicationTable["_count"] "`n"
    output .= "  Average: " multiplicationTable["_average"] "`n"

    MsgBox(output, "Example 7 Results")
}

;=============================================================================
; Helper Functions
;=============================================================================

/**
 * @function ArrayToString
 * @description Converts an array to a readable string representation
 * @param {Array} arr - The array to convert
 * @returns {String} String representation of the array
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
; GUI Interface for Interactive Testing
;=============================================================================

/**
 * @class MapSetDemoGUI
 * @description Interactive GUI for testing Map.Set() operations
 */
CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Set() Method - Basic Usage Examples"

    ; Title
    demoGui.Add("Text", "x10 y10 w480 h30 +Center",
        "Click buttons below to see different Map.Set() examples")

    ; Example buttons
    demoGui.Add("Button", "x10 y50 w230 h35", "Example 1: Basic Set")
        .OnEvent("Click", (*) => Example1_BasicSet())

    demoGui.Add("Button", "x250 y50 w230 h35", "Example 2: Multiple Set")
        .OnEvent("Click", (*) => Example2_MultipleSet())

    demoGui.Add("Button", "x10 y95 w230 h35", "Example 3: Update Values")
        .OnEvent("Click", (*) => Example3_UpdateValues())

    demoGui.Add("Button", "x250 y95 w230 h35", "Example 4: Method Chaining")
        .OnEvent("Click", (*) => Example4_MethodChaining())

    demoGui.Add("Button", "x10 y140 w230 h35", "Example 5: Data Types")
        .OnEvent("Click", (*) => Example5_DataTypes())

    demoGui.Add("Button", "x250 y140 w230 h35", "Example 6: From Array Data")
        .OnEvent("Click", (*) => Example6_FromArrayData())

    demoGui.Add("Button", "x10 y185 w470 h35", "Example 7: Computed Values")
        .OnEvent("Click", (*) => Example7_ComputedValues())

    ; Interactive section
    demoGui.Add("GroupBox", "x10 y230 w470 h140", "Interactive Map.Set() Tester")

    demoGui.Add("Text", "x20 y255", "Key:")
    keyInput := demoGui.Add("Edit", "x70 y252 w150")

    demoGui.Add("Text", "x240 y255", "Value:")
    valueInput := demoGui.Add("Edit", "x290 y252 w180")

    demoGui.Add("Button", "x20 y285 w150 h30", "Set Key-Value")
        .OnEvent("Click", SetInteractive)

    demoGui.Add("Button", "x180 y285 w140 h30", "Show Map")
        .OnEvent("Click", ShowInteractive)

    demoGui.Add("Button", "x330 y285 w140 h30", "Clear Map")
        .OnEvent("Click", ClearInteractive)

    resultDisplay := demoGui.Add("Edit", "x20 y325 w450 h35 ReadOnly")
    resultDisplay.Value := "Map is empty"

    ; Store controls in GUI object
    demoGui.keyInput := keyInput
    demoGui.valueInput := valueInput
    demoGui.resultDisplay := resultDisplay
    demoGui.interactiveMap := Map()

    ; Event handlers
    SetInteractive(*) {
        key := demoGui.keyInput.Value
        value := demoGui.valueInput.Value

        if (key = "") {
            MsgBox("Please enter a key!", "Error")
            return
        }

        demoGui.interactiveMap.Set(key, value)
        demoGui.resultDisplay.Value := "Added: " key " = " value " (Total: " demoGui.interactiveMap.Count " entries)"

        ; Clear inputs
        demoGui.keyInput.Value := ""
        demoGui.valueInput.Value := ""
    }

    ShowInteractive(*) {
        if (demoGui.interactiveMap.Count = 0) {
            MsgBox("Map is empty!", "Info")
            return
        }

        output := "=== Interactive Map Contents ===`n`n"
        for key, value in demoGui.interactiveMap {
            output .= key " => " value "`n"
        }
        output .= "`nTotal entries: " demoGui.interactiveMap.Count

        MsgBox(output, "Map Contents")
    }

    ClearInteractive(*) {
        demoGui.interactiveMap := Map()
        demoGui.resultDisplay.Value := "Map cleared"
    }

    ; Run all examples button
    demoGui.Add("Button", "x10 y380 w470 h30", "Run All Examples Sequentially")
        .OnEvent("Click", RunAllExamples)

    RunAllExamples(*) {
        Example1_BasicSet()
        Example2_MultipleSet()
        Example3_UpdateValues()
        Example4_MethodChaining()
        Example5_DataTypes()
        Example6_FromArrayData()
        Example7_ComputedValues()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w500 h420")
}

; Launch the demo GUI
CreateDemoGUI()
