#Requires AutoHotkey v2.1-alpha.17
/**
 * Module Tier 2 Example 04: Array Helpers Module with Setup
 *
 * This example demonstrates:
 * - Idempotent setup patterns
 * - Prototype extensions with guards
 * - Exported setup function
 * - Safe module initialization
 *
 * @module ArrayHelpers
 */

#Module ArrayHelpers

; Call setup automatically when module is loaded
SetupArrayHelpers()

/**
 * Ensure array helpers are initialized
 * Safe to call multiple times (idempotent)
 *
 * @export
 */
Export EnsureArrayHelpers() {
    SetupArrayHelpers()
}

/**
 * Join array elements with separator
 * @param array {Array} - Array to join
 * @param sep {String} - Separator (default: ",")
 * @returns {String} - Joined string
 */
Export Join(array, sep := ",") {
    SetupArrayHelpers()  ; Ensure setup is done
    return array.Join(sep)
}

/**
 * Split string into array
 * @param text {String} - Text to split
 * @param sep {String} - Separator (default: ",")
 * @param target {Array} - Optional target array
 * @returns {Array} - Array of values
 */
Export Split(text, sep := ",", target := unset) {
    SetupArrayHelpers()
    if !IsSet(target)
        target := []
    target.Split(text, sep)
    return target
}

/**
 * Split array into chunks of specified size
 * @param array {Array} - Array to chunk
 * @param size {Number} - Chunk size
 * @returns {Array} - Array of chunks
 */
Export Chunk(array, size) {
    result := []
    Loop {
        start := (A_Index - 1) * size + 1
        if start > array.Length
            break
        chunk := []
        Loop size {
            idx := start + A_Index - 1
            if idx > array.Length
                break
            chunk.Push(array[idx])
        }
        result.Push(chunk)
    }
    return result
}

/**
 * Remove falsy values from array
 * @param array {Array} - Array to compact
 * @returns {Array} - Compacted array
 */
Export Compact(array) {
    result := []
    for value in array {
        if value  ; Truthy check
            result.Push(value)
    }
    return result
}

/**
 * Flatten array one level deep
 * @param array {Array} - Array to flatten
 * @returns {Array} - Flattened array
 */
Export Flatten(array) {
    result := []
    for value in array {
        if (IsObject(value) && value is Array) {
            for item in value
                result.Push(item)
        } else {
            result.Push(value)
        }
    }
    return result
}

/**
 * Get unique values from array
 * @param array {Array} - Array with potential duplicates
 * @returns {Array} - Array with unique values
 */
Export Unique(array) {
    seen := Map()
    result := []
    for value in array {
        key := String(value)
        if !seen.Has(key) {
            seen[key] := true
            result.Push(value)
        }
    }
    return result
}

/**
 * Reverse array
 * @param array {Array} - Array to reverse
 * @returns {Array} - Reversed array
 */
Export Reverse(array) {
    result := []
    Loop array.Length
        result.Push(array[array.Length - A_Index + 1])
    return result
}

/**
 * Get first element
 * @param array {Array} - Array
 * @returns {Any} - First element
 */
Export First(array) {
    return array.Length > 0 ? array[1] : ""
}

/**
 * Get last element
 * @param array {Array} - Array
 * @returns {Any} - Last element
 */
Export Last(array) {
    return array.Length > 0 ? array[array.Length] : ""
}

/**
 * Take first n elements
 * @param array {Array} - Array
 * @param count {Number} - Number of elements
 * @returns {Array} - New array with first n elements
 */
Export Take(array, count) {
    result := []
    Loop Min(count, array.Length)
        result.Push(array[A_Index])
    return result
}

/**
 * Drop first n elements
 * @param array {Array} - Array
 * @param count {Number} - Number to drop
 * @returns {Array} - New array without first n elements
 */
Export Drop(array, count) {
    result := []
    Loop array.Length - count
        result.Push(array[A_Index + count])
    return result
}

/**
 * Find index of value
 * @param array {Array} - Array to search
 * @param value {Any} - Value to find
 * @returns {Number} - Index (1-based) or 0 if not found
 */
Export IndexOf(array, value) {
    for index, item in array {
        if item = value
            return index
    }
    return 0
}

/**
 * Check if array includes value
 * @param array {Array} - Array to check
 * @param value {Any} - Value to find
 * @returns {Boolean} - True if found
 */
Export Includes(array, value) {
    return IndexOf(array, value) > 0
}

/**
 * Sum all numeric values in array
 * @param array {Array} - Array of numbers
 * @returns {Number} - Sum
 */
Export Sum(array) {
    total := 0
    for value in array {
        if IsNumber(value)
            total += value
    }
    return total
}

/**
 * Get minimum value
 * @param array {Array} - Array of numbers
 * @returns {Number} - Minimum value
 */
Export Min(array) {
    if array.Length = 0
        return 0

    minimum := array[1]
    for value in array {
        if IsNumber(value) && value < minimum
            minimum := value
    }
    return minimum
}

/**
 * Get maximum value
 * @param array {Array} - Array of numbers
 * @returns {Number} - Maximum value
 */
Export Max(array) {
    if array.Length = 0
        return 0

    maximum := array[1]
    for value in array {
        if IsNumber(value) && value > maximum
            maximum := value
    }
    return maximum
}

/**
 * Idempotent setup function
 * Adds prototype methods to Array class
 * Safe to call multiple times
 *
 * @private
 */
SetupArrayHelpers() {
    static initialized := false

    ; Guard: Only run once
    if initialized
        return

    initialized := true

    ; Add Join method to Array prototype
    if !ObjHasOwnProp(Array.Prototype, "Join") {
        Array.Prototype.DefineProp("Join", {
            call: (array, sep := ",") => {
                result := ""
                for index, value in array
                    result .= value (index < array.Length ? sep : "")
                return result
            }
        })
    }

    ; Add Split method to Array prototype
    if !ObjHasOwnProp(Array.Prototype, "Split") {
        Array.Prototype.DefineProp("Split", {
            call: (array, text, sep := ",") => {
                for value in StrSplit(text, sep)
                    array.Push(value)
                return array
            }
        })
    }

    ; Add Map method to Array prototype
    if !ObjHasOwnProp(Array.Prototype, "Map") {
        Array.Prototype.DefineProp("Map", {
            call: (array, callback) => {
                result := []
                for index, value in array
                    result.Push(callback(value, index))
                return result
            }
        })
    }

    ; Add Filter method to Array prototype
    if !ObjHasOwnProp(Array.Prototype, "Filter") {
        Array.Prototype.DefineProp("Filter", {
            call: (array, callback) => {
                result := []
                for index, value in array {
                    if callback(value, index)
                        result.Push(value)
                }
                return result
            }
        })
    }

    ; Add ForEach method to Array prototype
    if !ObjHasOwnProp(Array.Prototype, "ForEach") {
        Array.Prototype.DefineProp("ForEach", {
            call: (array, callback) => {
                for index, value in array
                    callback(value, index)
                return array
            }
        })
    }
}
