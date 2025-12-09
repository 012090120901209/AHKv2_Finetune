#Requires AutoHotkey v2.0

/**
* GitHub_DllCall_02_SystemProcessorInfo.ahk
*
* DESCRIPTION:
* Retrieves detailed processor information using Windows Native API
*
* FEATURES:
* - Uses NtQuerySystemInformation (Windows Native API)
* - Demonstrates buffer resizing for variable-length data
* - Shows NumGet for reading binary data structures
* - Proper error handling with status codes
*
* SOURCE:
* Repository: jNizM/ahk-scripts-v2
* File: src/SystemInformation/SystemProcessorInformation.ahk
* URL: https://github.com/jNizM/ahk-scripts-v2
* Author: jNizM
* License: MIT
*
* KEY V2 FEATURES DEMONSTRATED:
* - DllLoad directive for loading DLLs
* - Buffer() for dynamic memory management
* - NumGet() for reading binary structures
* - Map() for returning structured data
* - Output variable syntax (&variable)
* - While loop for buffer resizing
*
* USAGE:
* info := SystemProcessorInformation()
* MsgBox("CPU Count: " info["MaximumProcessors"])
*
* LEARNING POINTS:
* 1. Native API calls require precise buffer sizing
* 2. STATUS_INFO_LENGTH_MISMATCH means retry with larger buffer
* 3. NumGet reads data at specific offsets in binary structures
* 4. Map() is ideal for returning structured system information
* 5. OSError() throws error with Windows error code
*/

/**
* Get detailed system processor information
*
* @returns {Map} - Map containing processor details:
*   - ProcessorArchitecture: CPU architecture (0=x86, 9=x64, 12=ARM64)
*   - ProcessorLevel: CPU family (e.g., 6 for Intel/AMD)
*   - ProcessorRevision: Model and stepping
*   - MaximumProcessors: Number of logical processors
*   - ProcessorFeatureBits: CPU feature flags
*
* @throws {OSError} - If Windows API call fails
*
* @example
* info := SystemProcessorInformation()
* MsgBox("Processor Count: " info["MaximumProcessors"])
* MsgBox("Architecture: " info["ProcessorArchitecture"])
*/
SystemProcessorInformation() {
    ; Load ntdll.dll (Windows Native API)
    #DllLoad "ntdll.dll"

    ; Windows NT Status Codes
    static STATUS_SUCCESS               := 0x00000000
    static STATUS_INFO_LENGTH_MISMATCH  := 0xC0000004
    static STATUS_BUFFER_TOO_SMALL      := 0xC0000023

    ; System Information Class
    static SYSTEM_PROCESSOR_INFORMATION := 0x00000001

    ; Initial buffer size (12 bytes for SYSTEM_PROCESSOR_INFORMATION)
    Buf := Buffer(0x000C)

    ; First API call to get required buffer size
    NT_STATUS := DllCall("ntdll\NtQuerySystemInformation",
    "Int", SYSTEM_PROCESSOR_INFORMATION,  ; Information class
    "Ptr", Buf.Ptr,                       ; Buffer pointer
    "UInt", Buf.Size,                     ; Buffer size
    "UInt*", &Size := 0,                  ; Returns required size
    "UInt")                               ; Return value

    ; Retry with larger buffer if needed
    while (NT_STATUS = STATUS_INFO_LENGTH_MISMATCH) || (NT_STATUS = STATUS_BUFFER_TOO_SMALL) {
        Buf := Buffer(Size)
        NT_STATUS := DllCall("ntdll\NtQuerySystemInformation",
        "Int", SYSTEM_PROCESSOR_INFORMATION,
        "Ptr", Buf.Ptr,
        "UInt", Buf.Size,
        "UInt*", &Size := 0,
        "UInt")
    }

    ; If successful, parse the binary structure
    if (NT_STATUS = STATUS_SUCCESS) {
        PROCESSOR_INFORMATION := Map()

        ; Read binary structure at specific offsets
        PROCESSOR_INFORMATION["ProcessorArchitecture"] := NumGet(Buf, 0x0000, "UShort")
        PROCESSOR_INFORMATION["ProcessorLevel"]        := NumGet(Buf, 0x0002, "UShort")
        PROCESSOR_INFORMATION["ProcessorRevision"]     := NumGet(Buf, 0x0004, "UShort")
        PROCESSOR_INFORMATION["MaximumProcessors"]     := NumGet(Buf, 0x0006, "UShort")
        PROCESSOR_INFORMATION["ProcessorFeatureBits"]  := NumGet(Buf, 0x0008, "UInt")

        return PROCESSOR_INFORMATION
    }

    ; Throw error if API call failed
    throw OSError()
}

; ============================================================
; Helper Functions
; ============================================================

/**
* Get human-readable processor architecture name
*
* @param {Number} arch - Architecture code
* @returns {String} - Architecture name
*/
GetArchitectureName(arch) {
    switch arch {
        case 0: return "x86 (Intel/AMD 32-bit)"
        case 5: return "ARM"
        case 6: return "IA-64 (Itanium)"
        case 9: return "x64 (AMD64/Intel64)"
        case 12: return "ARM64"
        default: return "Unknown (" arch ")"
    }
}

/**
* Get processor level description
*
* @param {Number} level - Processor level
* @returns {String} - Level description
*/
GetProcessorLevelDescription(level) {
    switch level {
        case 3: return "80386"
        case 4: return "80486"
        case 5: return "Pentium"
        case 6: return "Pentium Pro/II/III or equivalent"
        default: return "Family " level
    }
}

; ============================================================
; Example Usage
; ============================================================

try {
    ; Get processor information
    info := SystemProcessorInformation()

    ; Display basic information
    output := "SYSTEM PROCESSOR INFORMATION`n`n"
    output .= "Architecture: " GetArchitectureName(info["ProcessorArchitecture"]) "`n"
    output .= "Processor Level: " info["ProcessorLevel"] " (" GetProcessorLevelDescription(info["ProcessorLevel"]) ")`n"
    output .= "Processor Revision: " Format("{:#04x}", info["ProcessorRevision"]) "`n"
    output .= "Maximum Processors: " info["MaximumProcessors"] "`n"
    output .= "Feature Bits: " Format("{:#010x}", info["ProcessorFeatureBits"]) "`n"

    MsgBox(output, "Processor Information", "Icon!")

    ; Display just CPU count (common use case)
    cpuCount := info["MaximumProcessors"]
    MsgBox("This system has " cpuCount " logical processor(s).",
    "CPU Count", "Icon!")

    ; Check architecture
    arch := info["ProcessorArchitecture"]
    if (arch = 9) {
        MsgBox("Running on 64-bit (x64) architecture", "64-bit Detected", "Icon!")
    } else if (arch = 0) {
        MsgBox("Running on 32-bit (x86) architecture", "32-bit Detected", "Icon!")
    }

} catch as err {
    MsgBox("Error retrieving processor information:`n" err.Message,
    "Error", "Icon!")
}

; ============================================================
; Practical Use Cases
; ============================================================

/**
* Example: Determine if system can run 64-bit applications
*/
CanRun64Bit() {
    info := SystemProcessorInformation()
    return info["ProcessorArchitecture"] = 9  ; x64
}

if (CanRun64Bit()) {
    MsgBox("This system supports 64-bit applications", "64-bit Support", "Icon!")
}

/**
* Example: Optimize thread count for parallel processing
*/
GetOptimalThreadCount() {
    info := SystemProcessorInformation()
    cpuCount := info["MaximumProcessors"]

    ; Use CPU count - 1 for background tasks (leave one for OS)
    return Max(1, cpuCount - 1)
}

threads := GetOptimalThreadCount()
MsgBox("Optimal thread count for background tasks: " threads,
"Thread Optimization", "Icon!")

; ============================================================
; Technical Information
; ============================================================

techInfo := "
(
SYSTEM_PROCESSOR_INFORMATION STRUCTURE:

Offset  | Size   | Field
--------|--------|----------------------------
0x0000  | UShort | ProcessorArchitecture
0x0002  | UShort | ProcessorLevel
0x0004  | UShort | ProcessorRevision
0x0006  | UShort | MaximumProcessors
0x0008  | UInt   | ProcessorFeatureBits

Total Size: 12 bytes (0x000C)

ARCHITECTURE CODES:
0  = x86 (Intel 32-bit)
5  = ARM
6  = IA-64 (Itanium)
9  = x64 (AMD64/Intel64)
12 = ARM64

PROCESSOR LEVEL:
Indicates CPU family:
3 = 80386
4 = 80486
5 = Pentium
6 = Pentium Pro or later

REVISION:
High byte = Model
Low byte  = Stepping
)"

MsgBox(techInfo, "Technical Details", "Icon!")
