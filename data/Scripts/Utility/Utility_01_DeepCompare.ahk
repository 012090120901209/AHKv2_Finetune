#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* Deep Object Comparison Utility
*
* Compares two objects recursively for structural equality.
* Unlike reference equality (==), this checks if objects have
* identical structure and values.
*
* Source: AHK_Notes/Methods/deep-compare.md
*/

; Example 1: Comparing Configuration Objects
obj1 := {
    name: "Configuration",
    settings: {
        darkMode: true,
        fontSize: 12,
        colors: ["#000000", "#FFFFFF", "#FF0000"]
    },
    enabled: true
}

obj2 := {
    name: "Configuration",
    settings: {
        darkMode: true,
        fontSize: 12,
        colors: ["#000000", "#FFFFFF", "#FF0000"]
    },
    enabled: true
}

obj3 := {
    name: "Configuration",
    settings: {
        darkMode: false,  ; Different value
        fontSize: 12,
        colors: ["#000000", "#FFFFFF", "#FF0000"]
    },
    enabled: true
}

; Compare objects
result1 := DeepCompare(obj1, obj2)
result2 := DeepCompare(obj1, obj3)

MsgBox("obj1 == obj2 (reference): " (obj1 == obj2) "`n"
. "DeepCompare(obj1, obj2): " result1 "`n`n"
. "obj1 == obj3 (reference): " (obj1 == obj3) "`n"
. "DeepCompare(obj1, obj3): " result2, , "T5")

; Example 2: Comparing Arrays
arr1 := [1, [2, 3], [4, [5, 6]]]
arr2 := [1, [2, 3], [4, [5, 6]]]
arr3 := [1, [2, 3], [4, [5, 7]]]  ; Different nested value

MsgBox("Array comparison:`n`n"
. "arr1 vs arr2: " DeepCompare(arr1, arr2) "`n"
. "arr1 vs arr3: " DeepCompare(arr1, arr3), , "T5")

; Example 3: Comparing Maps
map1 := Map("key1", "value1", "key2", Map("nested", "data"))
map2 := Map("key1", "value1", "key2", Map("nested", "data"))
map3 := Map("key1", "value1", "key2", Map("nested", "different"))

MsgBox("Map comparison:`n`n"
. "map1 vs map2: " DeepCompare(map1, map2) "`n"
. "map1 vs map3: " DeepCompare(map1, map3), , "T5")

/**
* DeepCompare Function
*
* Recursively compares two values for structural equality.
*
* @param a - First value to compare
* @param b - Second value to compare
* @param seen - Map to track circular references (internal use)
* @return true if structurally equal, false otherwise
*/
DeepCompare(a, b, seen := Map()) {
    ; If either is not an object, use simple comparison
    if (!IsObject(a) || !IsObject(b))
    return a = b

    ; Different object types can't be equal
    if (Type(a) != Type(b))
    return false

    ; Check for circular references
    if seen.Has(a) && seen[a].Has(b)
    return true  ; Already compared this pair

    ; Track this comparison
    if !seen.Has(a)
    seen[a] := Map()
    seen[a][b] := true

    ; For arrays, check length then elements
    if (a is Array) {
        if (a.Length != b.Length)
        return false

        loop a.Length {
            if !DeepCompare(a[A_Index], b[A_Index], seen)
            return false
        }
        return true
    }

    ; For maps, check count then key-value pairs
    if (a is Map) {
        if (a.Count != b.Count)
        return false

        for key, val in a {
            if (!b.Has(key) || !DeepCompare(val, b[key], seen))
            return false
        }
        return true
    }

    ; For objects, compare all properties
    aKeys := GetObjKeys(a)
    bKeys := GetObjKeys(b)

    if (aKeys.Length != bKeys.Length)
    return false

    for key in aKeys {
        if (!HasProp(b, key) || !DeepCompare(a.%key%, b.%key%, seen))
        return false
    }

    return true
}

/**
* Helper: Get all property names from an object
*/
GetObjKeys(obj) {
    result := []
    for prop in obj.OwnProps()
    result.Push(prop)
    return result
}

/**
* Helper: Check if object has a property
*/
HasProp(obj, propName) {
    try return obj.HasOwnProp(propName)
    catch
    return false
}

/*
* Key Concepts:
*
* 1. Reference vs Structural Equality:
*
*    Reference (==):
*    obj1 == obj2  ; false (different objects)
*
*    Structural (DeepCompare):
*    DeepCompare(obj1, obj2)  ; true (same content)
*
* 2. Recursive Comparison:
*    - Handles nested objects, arrays, maps
*    - Checks all levels of nesting
*    - Circular reference detection prevents infinite loops
*
* 3. Type Checking:
*    - Arrays compared element-by-element
*    - Maps compared key-value by key-value
*    - Objects compared property by property
*    - Primitives compared by value
*
* 4. Circular Reference Handling:
*    obj := {}
*    obj.self := obj  ; Circular reference
*    DeepCompare handles this without infinite loop
*
* 5. Use Cases:
*    - Configuration validation
*    - Test assertions
*    - State comparison (before/after)
*    - Cache invalidation
*    - Data synchronization
*
* 6. Performance Considerations:
*    ⚠️  Recursive algorithm - slow for deep structures
*    ⚠️  O(n) where n = total elements
*    ✅  Early exit on first difference
*    ✅  Circular reference tracking
*
* 7. Extension as Method:
*    Object.Prototype.DefineProp("DeepCompare", {
    *        call: (this, obj) => DeepCompare(this, obj)
    *    })
    *    Then: obj1.DeepCompare(obj2)
    */
