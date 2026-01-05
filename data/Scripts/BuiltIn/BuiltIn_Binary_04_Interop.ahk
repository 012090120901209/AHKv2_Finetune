#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Binary_04_Interop.ahk
 * 
 * DESCRIPTION:
 * DLL interoperability and Windows API integration using binary data.
 * Demonstrates calling external functions with binary structures.
 * 
 * FEATURES:
 * - Windows API structure creation
 * - DllCall with binary buffers
 * - Structure marshaling
 * - API result parsing
 * - Platform-specific handling
 * - Real-world API usage
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall, Binary Operations
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall with Buffer parameters
 * - Structure passing to APIs
 * - Returned structure parsing
 * - Multi-API call sequences
 * - Error handling with binary data
 * 
 * LEARNING POINTS:
 * 1. Windows APIs expect specific structure layouts
 * 2. DllCall can pass Buffer.Ptr directly
 * 3. API documentation defines structure requirements
 * 4. Some APIs modify buffers in-place
 * 5. Platform differences affect structure sizes
 */

; ================================================================================================
; EXAMPLE 1: SYSTEMTIME Windows API
; ================================================================================================

Example1_SYSTEMTIME() {
    ; Create SYSTEMTIME structure (16 bytes)
    buf := Buffer(16)

    ; Get system time
    DllCall("GetSystemTime", "Ptr", buf.Ptr)

    ; Parse structure
    year := NumGet(buf, 0, "UShort")
    month := NumGet(buf, 2, "UShort")
    dayOfWeek := NumGet(buf, 4, "UShort")
    day := NumGet(buf, 6, "UShort")
    hour := NumGet(buf, 8, "UShort")
    minute := NumGet(buf, 10, "UShort")
    second := NumGet(buf, 12, "UShort")
    ms := NumGet(buf, 14, "UShort")

    ; Format
    dayNames := ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
    monthNames := ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    result := "Windows SYSTEMTIME API:`n`n"
    result .= "Current UTC Time:`n"
    result .= "  Date: " . monthNames[month] . " " . day . ", " . year . "`n"
    result .= "  Day: " . dayNames[dayOfWeek + 1] . "`n"
    result .= "  Time: " . Format("{:02}:{:02}:{:02}.{:03}", hour, minute, second, ms)

    MsgBox(result, "Example 1: SYSTEMTIME", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: POINT Structure
; ================================================================================================

Example2_POINTStructure() {
    ; Create POINT structure (8 bytes)
    buf := Buffer(8)

    ; Get cursor position
    DllCall("GetCursorPos", "Ptr", buf.Ptr)

    ; Parse structure
    x := NumGet(buf, 0, "Int")
    y := NumGet(buf, 4, "Int")

    ; Modify and set cursor
    newBuf := Buffer(8)
    NumPut("Int", x + 10, newBuf, 0)
    NumPut("Int", y + 10, newBuf, 4)

    ; Note: SetCursorPos takes direct values not structure
    ; This is just demonstration

    result := "POINT Structure API:`n`n"
    result .= "Current Cursor Position:`n"
    result .= "  X: " . x . "`n"
    result .= "  Y: " . y . "`n`n"

    result .= "Modified Position (not applied):`n"
    result .= "  X: " . NumGet(newBuf, 0, "Int") . "`n"
    result .= "  Y: " . NumGet(newBuf, 4, "Int")

    MsgBox(result, "Example 2: POINT Structure", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: MEMORYSTATUSEX
; ================================================================================================

Example3_MEMORYSTATUSEX() {
    ; Create MEMORYSTATUSEX structure (64 bytes)
    buf := Buffer(64)

    ; Set structure size (required by API)
    NumPut("UInt", 64, buf, 0)

    ; Call API
    DllCall("GlobalMemoryStatusEx", "Ptr", buf.Ptr)

    ; Parse structure
    memoryLoad := NumGet(buf, 4, "UInt")
    totalPhys := NumGet(buf, 8, "UInt64")
    availPhys := NumGet(buf, 16, "UInt64")
    totalPage := NumGet(buf, 24, "UInt64")
    availPage := NumGet(buf, 32, "UInt64")
    totalVirtual := NumGet(buf, 40, "UInt64")
    availVirtual := NumGet(buf, 48, "UInt64")

    ; Convert to GB
    toGB := 1024 * 1024 * 1024

    result := "Memory Status API:`n`n"
    result .= "System Memory:`n"
    result .= "  Load: " . memoryLoad . "%`n"
    result .= "  Total Physical: " . Format("{:.2f}", totalPhys / toGB) . " GB`n"
    result .= "  Available Physical: " . Format("{:.2f}", availPhys / toGB) . " GB`n"
    result .= "  Total Page File: " . Format("{:.2f}", totalPage / toGB) . " GB`n"
    result .= "  Available Page: " . Format("{:.2f}", availPage / toGB) . " GB`n"
    result .= "  Total Virtual: " . Format("{:.2f}", totalVirtual / toGB) . " GB`n"
    result .= "  Available Virtual: " . Format("{:.2f}", availVirtual / toGB) . " GB"

    MsgBox(result, "Example 3: MEMORYSTATUSEX", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    Binary Interop Examples

    1. SYSTEMTIME Windows API
    2. POINT Structure
    3. MEMORYSTATUSEX Structure

    Select an example (1-3) or press Cancel to exit:
    )"

    choice := InputBox(menu, "Binary Interop", "w450 h250")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_SYSTEMTIME()
        case "2": Example2_POINTStructure()
        case "3": Example3_MEMORYSTATUSEX()
        default: MsgBox("Invalid selection. Please choose 1-3.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
