#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* CreateGUID() - Generate Globally Unique Identifier
* Source: github.com/jNizM/ahk-scripts-v2
*
* Demonstrates:
* - DllCall to Windows API (ole32.dll)
* - Buffer() for memory allocation
* - Static variables
* - VarSetStrCapacity for string buffers
* - Error handling with return values
*/

CreateGUID() {
    static S_OK := 0

    ; Allocate 16 bytes for 128-bit GUID
    GUID := Buffer(16, 0)

    ; Create GUID using Windows API
    if (DllCall("ole32\CoCreateGuid", "Ptr", GUID) != S_OK) {
        return ""
    }

    ; Allocate string buffer (39 chars for GUID format)
    VarSetStrCapacity(&sGUID := "", 39)

    ; Convert binary GUID to string format
    if (DllCall("ole32\StringFromGUID2", "Ptr", GUID, "Str", sGUID, "Int", 39) != 39) {
        return ""
    }

    return sGUID
}

; Examples - generate multiple GUIDs
guid1 := CreateGUID()
guid2 := CreateGUID()
guid3 := CreateGUID()

MsgBox("GUID 1: " guid1 "`n"
. "GUID 2: " guid2 "`n"
. "GUID 3: " guid3 "`n`n"
. "Format: {XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX}")
