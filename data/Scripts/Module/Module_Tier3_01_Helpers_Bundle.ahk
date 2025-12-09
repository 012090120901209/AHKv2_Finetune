#Requires AutoHotkey v2.1-alpha.17

/**
* Module Tier 3 Example 01: Helpers Bundle (Re-exports)
*
* This example demonstrates:
* - Re-exporting modules
* - Creating aggregate/bundle modules
* - Providing convenient API
* - Module composition
*
* This is a "barrel" or "bundle" module that aggregates
* multiple related modules into one convenient import.
*
* @module Helpers
*/

#Module Helpers

; Import sub-modules
Import StringHelpers
Import ArrayHelpers
Import MathHelpers

; Initialize any setup needed
ArrayHelpers.EnsureArrayHelpers()

/**
* Get ready-to-use helpers bundle
* Returns an object with convenient access to all helpers
*
* @returns {Object} - Bundle of helper functions
* @export
*/
Export HelpersReady() {
    return {
        ; String helpers
        String: {
            Title: StringHelpers.ToTitleCase,
            Snake: StringHelpers.ToSnakeCase,
            Camel: StringHelpers.ToCamelCase,
            Pascal: StringHelpers.ToPascalCase,
            Kebab: StringHelpers.ToKebabCase,
            Clean: StringHelpers.CollapseWhitespace,
            Truncate: StringHelpers.Truncate,
            Reverse: StringHelpers.Reverse,
            WordCount: StringHelpers.WordCount
        },

        ; Array helpers
        Array: {
            Join: ArrayHelpers.Join,
            Chunk: ArrayHelpers.Chunk,
            Flatten: ArrayHelpers.Flatten,
            Unique: ArrayHelpers.Unique,
            Reverse: ArrayHelpers.Reverse,
            First: ArrayHelpers.First,
            Last: ArrayHelpers.Last,
            Sum: ArrayHelpers.Sum,
            Min: ArrayHelpers.Min,
            Max: ArrayHelpers.Max
        },

        ; Math helpers
        Math: {
            Add: MathHelpers.Add,
            Subtract: MathHelpers.Subtract,
            Multiply: MathHelpers.Multiply,
            Divide: MathHelpers.Divide,
            Square: MathHelpers.Square,
            Sqrt: MathHelpers.Sqrt,
            Clamp: MathHelpers.Clamp
        }
    }
}

/**
* Get quick access functions (most commonly used)
* @returns {Object} - Quick access bundle
* @export
*/
Export QuickHelpers() {
    return {
        ; Most common string operations
        Title: StringHelpers.ToTitleCase,
        Snake: StringHelpers.ToSnakeCase,
        Clean: StringHelpers.CollapseWhitespace,

        ; Most common array operations
        Join: ArrayHelpers.Join,
        Chunk: ArrayHelpers.Chunk,
        Unique: ArrayHelpers.Unique,

        ; Most common math operations
        Add: MathHelpers.Add,
        Multiply: MathHelpers.Multiply,
        Square: MathHelpers.Square
    }
}

/**
* Re-export entire sub-modules for direct access
* This allows: Helpers.StringHelpers.ToTitleCase()
*
* @export
*/
Export { StringHelpers, ArrayHelpers, MathHelpers }

/**
* Get module info
* @returns {Object} - Module information
* @export
*/
Export GetModuleInfo() {
    return {
        name: "Helpers",
        version: "1.0.0",
        description: "Aggregate module providing string, array, and math utilities",
        submodules: ["StringHelpers", "ArrayHelpers", "MathHelpers"]
    }
}
