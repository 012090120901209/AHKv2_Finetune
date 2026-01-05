#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Prototype Extension - Map Methods
 * 
 * Extends Map with Keys, Values, GetOrDefault methods.
 * Provides convenient access to Map contents.
 * 
 * Source: AHK_Notes/Snippets/extending-builtin-objects.md
 */

; Define Map prototype extensions
Map.Prototype.DefineProp("Keys", { Call: map_keys })
Map.Prototype.DefineProp("Values", { Call: map_values })
Map.Prototype.DefineProp("GetOrDefault", { Call: map_get_or_default })

; Test map methods
myMap := Map("name", "John", "age", 30, "city", "New York")

keys := myMap.Keys()
values := myMap.Values()

MsgBox("Map: {name: John, age: 30, city: New York}`n`n"
    . "Keys: [" keys.Join(", ") "]`n"
    . "Values: [" values.Join(", ") "]`n`n"
    . "GetOrDefault('name', 'Unknown'): " myMap.GetOrDefault("name", "Unknown") "`n"
    . "GetOrDefault('country', 'USA'): " myMap.GetOrDefault("country", "USA"), , "T5")

/**
 * Map.Keys Implementation
 * @return {array} Array of all keys
 */
map_keys(mp) {
    keyArray := []
    for k, v in mp {
        if IsSet(k)
            keyArray.Push(k)
    }
    return keyArray
}

/**
 * Map.Values Implementation
 * @return {array} Array of all values
 */
map_values(mp) {
    valueArray := []
    for k, v in mp {
        if IsSet(v)
            valueArray.Push(v)
    }
    return valueArray
}

/**
 * Map.GetOrDefault Implementation
 * @param {any} key - Key to retrieve
 * @param {any} defaultValue - Value if key doesn't exist
 * @return {any} Value or default
 */
map_get_or_default(mp, key, defaultValue := "") {
    return mp.Has(key) ? mp[key] : defaultValue
}

/*
* Key Concepts:
*
* 1. Map Extensions:
*    - Keys(): Get all keys as array
*    - Values(): Get all values as array
*    - GetOrDefault(): Safe key access
*
* 2. Chaining:
*    myMap.Keys().Join(", ")
*    Extension methods work with Array methods
*
* 3. Safe Access:
*    GetOrDefault avoids errors for missing keys
*
* 4. Benefits:
*    ✅ Convenient key/value iteration
*    ✅ Safe default values
*    ✅ Functional programming style
*/

