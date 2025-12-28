#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Deep Clone - Object Deep Cloning
 * 
 * Demonstrates deep cloning of objects with nested properties
 * and circular reference handling.
 * 
 * Source: AHK_Notes/Snippets/deep-cloning-objects.md
 */

; Test basic deep clone
original := {
    name: "Config",
    settings: {
        theme: "dark",
        fontSize: 12,
        window: {
            width: 800,
            height: 600
        }
    },
    items: [1, 2, { nested: "value" }]
}

clone := DeepClone(original)
clone.settings.theme := "light"
clone.settings.window.width := 1024

MsgBox("Deep Clone Test:`n`n"
    . "Original theme: " original.settings.theme "`n"
    . "Clone theme: " clone.settings.theme "`n`n"
    . "Original width: " original.settings.window.width "`n"
    . "Clone width: " clone.settings.window.width "`n`n"
    . "Objects are independent: " (original != clone), , "T5")

; Test circular reference handling
circular := { name: "Parent" }
circular.self := circular  ; Circular reference
circular.child := { name: "Child", parent: circular }  ; Back reference

circClone := DeepClone(circular)
MsgBox("Circular Reference Test:`n`n"
    . "Original name: " circular.name "`n"
    . "Clone name: " circClone.name "`n`n"
    . "Original self === original: " (circular.self == circular) "`n"
    . "Clone self === clone: " (circClone.self == circClone) "`n`n"
    . "Circular refs preserved correctly", , "T5")

/**
 * DeepClone - Create fully independent copy of object
 * @param {object} obj - Object to clone
 * @param {map} seen - Circular reference tracker (internal)
 * @return {object} Deep cloned object
 */
DeepClone(obj, seen := unset) {
    ; Initialize seen map on first call
    if (!IsSet(seen))
        seen := Map()

    ; Return primitives directly
    if (!IsObject(obj))
        return obj

    ; Handle circular references
    if (seen.Has(obj))
        return seen[obj]

    ; Handle arrays
    if (obj is Array) {
        clone := []
        seen[obj] := clone

        for value in obj {
            clone.Push(DeepClone(value, seen))
        }
        return clone
    }

    ; Handle maps
    if (obj is Map) {
        clone := Map()
        seen[obj] := clone

        for key, value in obj {
            clone[DeepClone(key, seen)] := DeepClone(value, seen)
        }
        return clone
    }

    ; Handle regular objects
    clone := {}
    seen[obj] := clone

    ; Clone all properties
    for key, value in obj.OwnProps() {
        try {
            clone.%key% := DeepClone(value, seen)
        }
    }

    return clone
}

/*
* Key Concepts:
*
* 1. Deep vs Shallow Copy:
*    Shallow: obj2 := obj1  ; Reference copy
*    Deep: obj2 := DeepClone(obj1)  ; Independent copy
*
* 2. Circular Reference Handling:
*    seen := Map()  ; Track cloned objects
*    if (seen.Has(obj)) return seen[obj]
*    Prevents infinite recursion
*
* 3. Type Preservation:
*    Arrays remain arrays
*    Maps remain maps
*    Objects remain objects
*
* 4. Recursive Cloning:
*    Clone nested objects deeply
*    DeepClone(value, seen)
*    Preserves structure at all levels
*
* 5. Use Cases:
*    ✅ Configuration snapshots
*    ✅ Undo/redo systems
*    ✅ State management
*    ✅ Testing with fixtures
*
* 6. Limitations:
*    ⚠ Doesn't clone functions
*    ⚠ Doesn't preserve prototypes
*    ⚠ May be slow for large objects
*/

