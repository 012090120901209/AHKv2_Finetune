#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Map Best Practices
 * 
 * Demonstrates proper Map usage patterns, common pitfalls to avoid,
 * and optimization techniques for key-value storage.
 * 
 * Source: AHK_Notes/Concepts/map-usage-best-practices.md
 */

; Pattern 1: Creating and populating Maps
config := Map(
    "width", 800,
    "height", 600,
    "title", "My Application",
    "darkMode", true
)

MsgBox("Map Creation:`n`n"
    . "Width: " config["width"] "`n"
    . "Height: " config["height"] "`n"
    . "Title: " config["title"] "`n"
    . "Dark Mode: " config["darkMode"], , "T3")

; Pattern 2: Safe key access with Has()
key := "fontSize"
value := config.Has(key) ? config[key] : "Not set"

MsgBox("Safe Access:`n`n"
    . "Key 'fontSize' exists: " config.Has(key) "`n"
    . "Value: " value, , "T3")

; Pattern 3: Iterating Maps
result := "Map Iteration:`n`n"
for key, value in config {
    result .= key ": " value "`n"
}
MsgBox(result, , "T5")

; Pattern 4: Common pitfall - Using objects instead of Maps
badConfig := { width: 800, height: 600 }  ; DON'T do this for data!
goodConfig := Map("width", 800, "height", 600)  ; DO this instead

MsgBox("Map vs Object:`n`n"
    . "Object (bad): " Type(badConfig) "`n"
    . "Map (good): " Type(goodConfig) "`n`n"
    . "Use Maps for data storage!", , "T5")

; Pattern 5: Static class Maps for configuration
Settings.Set("theme", "dark")
Settings.Set("language", "en")

MsgBox("Static Class Map:`n`n"
    . "Theme: " Settings.Get("theme") "`n"
    . "Language: " Settings.Get("language") "`n"
    . "Count: " Settings.Count(), , "T3")

; Pattern 6: Nested Maps for complex data
users := Map()
users["user1"] := Map("name", "Alice", "age", 30, "role", "Admin")
users["user2"] := Map("name", "Bob", "age", 25, "role", "User")

MsgBox("Nested Maps:`n`n"
    . "User1 name: " users["user1"]["name"] "`n"
    . "User1 role: " users["user1"]["role"] "`n"
    . "User2 name: " users["user2"]["name"], , "T3")

; Pattern 7: Map methods
testMap := Map("a", 1, "b", 2, "c", 3)
clone := testMap.Clone()
testMap.Delete("b")

MsgBox("Map Methods:`n`n"
    . "Original count: " clone.Count "`n"
    . "After Delete('b'): " testMap.Count "`n"
    . "Has('a'): " testMap.Has("a") "`n"
    . "Has('b'): " testMap.Has("b"), , "T5")

/**
 * Settings - Static class with Map storage
 */
class Settings {
    static _config := Map()

    /**
     * Get setting value
     */
    static Get(key, defaultValue := "") {
        return this._config.Has(key) ? this._config[key] : defaultValue
    }

    /**
     * Set setting value
     */
    static Set(key, value) {
        this._config[key] := value
    }

    /**
     * Check if setting exists
     */
    static Has(key) {
        return this._config.Has(key)
    }

    /**
     * Get setting count
     */
    static Count() {
        return this._config.Count
    }

    /**
     * Clear all settings
     */
    static Clear() {
        this._config := Map()
    }
}

/*
* Key Concepts:
*
* 1. Map Creation:
*    map := Map()                    ; Empty
*    map := Map("k1", "v1", "k2", "v2")  ; With values
*
* 2. Access Patterns:
*    value := map["key"]             ; Get value
*    map["key"] := value             ; Set value
*    exists := map.Has("key")        ; Check existence
*
* 3. Safe Access:
*    if (map.Has(key))
*        value := map[key]
*    Or:
*    value := map.Has(key) ? map[key] : defaultValue
*
* 4. Iteration:
*    for key, value in map {
    *        ; Process each pair
    *    }
    *
    * 5. Map Methods:
    *    map.Has(key)        ; Check existence
    *    map.Delete(key)     ; Remove key
    *    map.Clear()         ; Remove all
    *    map.Clone()         ; Shallow copy
    *    map.Count           ; Number of items
    *
    * 6. Common Pitfalls:
    *    ✗ config := {key: value}  ; DON'T use objects!
    *    ✓ config := Map("key", value)  ; DO use Maps
    *
    *    ✗ value := map[key]  ; Throws if missing
    *    ✓ value := map.Has(key) ? map[key] : default
    *
    * 7. Static Maps Pattern:
    *    class Config {
        *        static _data := Map()
        *        static Get(key) => this._data[key]
        *    }
        *    Centralized configuration
        *
        * 8. Nested Maps:
        *    users := Map()
        *    users["id1"] := Map("name", "Alice")
        *    name := users["id1"]["name"]
        *
        * 9. Key Types:
        *    ✓ Strings: map["key"]
        *    ✓ Numbers: map[123]
        *    ✗ Objects: Don't use objects as keys
        *
        * 10. Benefits Over Objects:
        *     ✅ Clearer intent (data storage)
        *     ✅ Better key validation
        *     ✅ Count property
        *     ✅ Has() method
        *     ✅ Clone() method
        *     ✅ More consistent behavior
        *
        * 11. Performance:
        *     ✅ Fast lookups
        *     ✅ Efficient for large datasets
        *     ✅ Clone is shallow (fast)
*/

