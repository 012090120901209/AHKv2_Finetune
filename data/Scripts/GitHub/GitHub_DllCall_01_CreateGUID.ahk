#Requires AutoHotkey v2.0

/**
 * GitHub_DllCall_01_CreateGUID.ahk
 * 
 * DESCRIPTION:
 * Creates a Globally Unique Identifier (GUID) using Windows COM API
 * 
 * FEATURES:
 * - Uses DllCall to call Windows ole32.dll
 * - Demonstrates Buffer management
 * - Shows string conversion from GUID
 * - Static variable usage for constants
 * 
 * SOURCE:
 * Repository: jNizM/ahk-scripts-v2
 * File: src/Others/CreateGUID.ahk
 * URL: https://github.com/jNizM/ahk-scripts-v2
 * Author: jNizM
 * License: MIT
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall syntax with explicit types
 * - Buffer() for memory allocation
 * - VarSetStrCapacity for string buffers
 * - Static variables in functions
 * - Error handling with return values
 * 
 * USAGE:
 * guid := CreateGUID()
 * MsgBox(guid)  ; Shows something like: {550e8400-e29b-41d4-a716-446655440000}
 * 
 * LEARNING POINTS:
 * 1. DllCall requires explicit type specifications (Ptr, Str, Int)
 * 2. Buffer() replaces VarSetCapacity from v1
 * 3. CoCreateGuid creates new GUID, StringFromGUID2 converts to string
 * 4. GUIDs are 16 bytes (128 bits) in binary form
 * 5. String representation needs 38 characters (with braces and hyphens)
 */

/**
 * Create a new GUID (Globally Unique Identifier)
 * 
 * @returns {String} - GUID in format: {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}
 * @throws {Error} - Returns empty string if GUID creation fails
 * 
 * @example
 * guid := CreateGUID()
 * MsgBox("New GUID: " guid)
 */
CreateGUID() {
    ; Windows API success code
    static S_OK := 0

    ; Allocate 16-byte buffer for GUID (128 bits)
    pGUID := Buffer(16)

    ; Call CoCreateGuid to generate new GUID
    ; Returns S_OK (0) on success
    if (DllCall("ole32\CoCreateGuid", "Ptr", pGUID) = S_OK) {

        ; Prepare string buffer for GUID text representation
        ; GUIDs need 38 characters: {8-4-4-4-12} format plus null terminator
        GUID := ""
        Size := VarSetStrCapacity(&GUID, 38)

        ; Convert binary GUID to string format
        ; StringFromGUID2 returns number of characters written
        if (DllCall("ole32\StringFromGUID2", "Ptr", pGUID, "Str", GUID, "Int", Size + 1)) {
            return GUID
        }
    }

    ; Return empty string if failed
    return ""
}

; ============================================================
; Example Usage
; ============================================================

; Generate and display a single GUID
guid1 := CreateGUID()
MsgBox("Generated GUID:`n" guid1, "GUID Example 1", "Icon!")

; Generate multiple GUIDs (they should all be unique)
guids := []
Loop 5
    guids.Push(CreateGUID())

output := "Generated 5 Unique GUIDs:`n`n"
for index, guid in guids
    output .= index ". " guid "`n"

MsgBox(output, "GUID Example 2 - Multiple GUIDs", "Icon!")

; ============================================================
; Practical Use Cases
; ============================================================

/**
 * Example: Generate unique file names
 */
CreateUniqueFileName(extension := "txt") {
    guid := CreateGUID()
    ; Remove braces and dashes for filename
    guid := StrReplace(StrReplace(guid, "{", ""), "}", "")
    guid := StrReplace(guid, "-", "")
    return guid "." extension
}

filename := CreateUniqueFileName("log")
MsgBox("Unique filename: " filename, "Practical Example", "Icon!")

/**
 * Example: Create database-friendly GUID (no braces)
 */
CreateGuidNoBraces() {
    guid := CreateGUID()
    return SubStr(guid, 2, 36)  ; Remove { and }
}

dbGuid := CreateGuidNoBraces()
MsgBox("Database GUID (no braces):`n" dbGuid, "Database Format", "Icon!")

; ============================================================
; GUID Format Information
; ============================================================

info := "
(
GUID FORMAT BREAKDOWN:

Standard Format: {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}

Example: {550e8400-e29b-41d4-a716-446655440000}

Structure:
{
    550e8400    -    8 hex digits (32 bits)
    e29b        -    4 hex digits (16 bits)
    41d4        -    4 hex digits (16 bits)
    a716        -    4 hex digits (16 bits)
    446655440000}    12 hex digits (48 bits)

    Total: 128 bits of uniqueness

    Uses:
    - COM objects identification
    - Database primary keys
    - Unique file naming
    - Session identifiers
    - License keys
    )"

MsgBox(info, "GUID Information", "Icon!")
