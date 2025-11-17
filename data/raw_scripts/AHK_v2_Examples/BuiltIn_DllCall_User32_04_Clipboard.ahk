#Requires AutoHotkey v2.0
/**
 * BuiltIn_DllCall_User32_04_Clipboard.ahk
 *
 * DESCRIPTION:
 * Demonstrates clipboard operations using Windows API through DllCall.
 * Shows how to open/close clipboard, get/set various data formats, enumerate
 * formats, and handle complex clipboard data types.
 *
 * FEATURES:
 * - Opening and closing clipboard safely
 * - Setting and getting clipboard text (ANSI and Unicode)
 * - Working with multiple clipboard formats
 * - Custom clipboard formats
 * - Clipboard format enumeration
 * - HTML and RTF clipboard data
 * - Clipboard monitoring and change detection
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft Clipboard API
 * https://docs.microsoft.com/en-us/windows/win32/dataxchg/clipboard
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with clipboard functions
 * - Global memory allocation (GlobalAlloc, GlobalLock)
 * - Memory manipulation for clipboard data
 * - Custom clipboard format registration
 * - Clipboard sequence number tracking
 *
 * LEARNING POINTS:
 * 1. Proper clipboard opening and closing sequences
 * 2. Working with global memory handles
 * 3. Converting between clipboard formats
 * 4. Registering custom clipboard formats
 * 5. Enumerating available clipboard formats
 * 6. Setting HTML and RTF formatted text
 * 7. Monitoring clipboard changes
 */

;==============================================================================
; EXAMPLE 1: Basic Clipboard Text Operations
;==============================================================================
; Demonstrates setting and getting clipboard text using Windows API

Example1_BasicClipboardText() {
    ; Clipboard format constants
    CF_TEXT := 1           ; ANSI text
    CF_UNICODETEXT := 13   ; Unicode text

    ; Global memory flags
    GMEM_MOVEABLE := 0x0002
    GMEM_ZEROINIT := 0x0040
    GHND := GMEM_MOVEABLE | GMEM_ZEROINIT

    ; Text to set
    textToSet := "Hello from Windows API!`nThis is line 2.`nAnd line 3."

    ; Open clipboard
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int") {
        MsgBox("Failed to open clipboard!", "Error")
        return
    }

    ; Empty clipboard
    DllCall("User32.dll\EmptyClipboard", "Int")

    ; Calculate size needed (characters + null terminator) * 2 bytes
    strLen := StrLen(textToSet) + 1
    bufSize := strLen * 2

    ; Allocate global memory
    hMem := DllCall("Kernel32.dll\GlobalAlloc"
        , "UInt", GHND
        , "UPtr", bufSize
        , "Ptr")

    if (!hMem) {
        DllCall("User32.dll\CloseClipboard", "Int")
        MsgBox("Failed to allocate memory!", "Error")
        return
    }

    ; Lock memory and get pointer
    pMem := DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")

    ; Copy string to global memory
    StrPut(textToSet, pMem, strLen, "UTF-16")

    ; Unlock memory
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "Int")

    ; Set clipboard data
    if !DllCall("User32.dll\SetClipboardData"
        , "UInt", CF_UNICODETEXT
        , "Ptr", hMem
        , "Ptr") {
        DllCall("Kernel32.dll\GlobalFree", "Ptr", hMem, "Ptr")
        DllCall("User32.dll\CloseClipboard", "Int")
        MsgBox("Failed to set clipboard data!", "Error")
        return
    }

    ; Close clipboard (clipboard now owns the memory)
    DllCall("User32.dll\CloseClipboard", "Int")

    MsgBox("Text set to clipboard successfully!`n`nNow retrieving it back...", "Success")

    ; ===== Now retrieve the data =====

    ; Open clipboard for reading
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int") {
        MsgBox("Failed to open clipboard for reading!", "Error")
        return
    }

    ; Get clipboard data handle
    hClipData := DllCall("User32.dll\GetClipboardData", "UInt", CF_UNICODETEXT, "Ptr")

    if (!hClipData) {
        DllCall("User32.dll\CloseClipboard", "Int")
        MsgBox("No Unicode text on clipboard!", "Error")
        return
    }

    ; Lock and get pointer
    pClipData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hClipData, "Ptr")

    ; Read string from memory
    retrievedText := StrGet(pClipData, "UTF-16")

    ; Unlock (but don't free - clipboard owns it)
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hClipData, "Int")

    ; Close clipboard
    DllCall("User32.dll\CloseClipboard", "Int")

    MsgBox("Retrieved text:`n`n" . retrievedText, "Retrieved from Clipboard")
}

;==============================================================================
; EXAMPLE 2: Multiple Clipboard Formats
;==============================================================================
; Shows how to work with different clipboard formats simultaneously

Example2_MultipleFormats() {
    ; Clipboard formats
    CF_TEXT := 1
    CF_UNICODETEXT := 13

    textData := "This text is in multiple formats!"

    ; Open clipboard
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int") {
        MsgBox("Failed to open clipboard!", "Error")
        return
    }

    DllCall("User32.dll\EmptyClipboard", "Int")

    ; Set Unicode text
    SetClipboardUnicode(textData)

    ; Set ANSI text
    SetClipboardAnsi(textData)

    ; Close clipboard
    DllCall("User32.dll\CloseClipboard", "Int")

    MsgBox("Set clipboard data in multiple formats!", "Success")

    ; Now check what formats are available
    Sleep(500)
    ListClipboardFormats()
}

; Helper function to set Unicode text
SetClipboardUnicode(text) {
    CF_UNICODETEXT := 13
    GHND := 0x0042

    strLen := StrLen(text) + 1
    hMem := DllCall("Kernel32.dll\GlobalAlloc", "UInt", GHND, "UPtr", strLen * 2, "Ptr")
    pMem := DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")
    StrPut(text, pMem, strLen, "UTF-16")
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "Int")
    DllCall("User32.dll\SetClipboardData", "UInt", CF_UNICODETEXT, "Ptr", hMem, "Ptr")
}

; Helper function to set ANSI text
SetClipboardAnsi(text) {
    CF_TEXT := 1
    GHND := 0x0042

    strLen := StrLen(text) + 1
    hMem := DllCall("Kernel32.dll\GlobalAlloc", "UInt", GHND, "UPtr", strLen, "Ptr")
    pMem := DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")
    StrPut(text, pMem, strLen, "CP0")
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "Int")
    DllCall("User32.dll\SetClipboardData", "UInt", CF_TEXT, "Ptr", hMem, "Ptr")
}

; List all available clipboard formats
ListClipboardFormats() {
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
        return

    formats := []
    format := 0

    Loop {
        format := DllCall("User32.dll\EnumClipboardFormats", "UInt", format, "UInt")
        if (!format)
            break

        ; Get format name
        nameBuf := Buffer(256, 0)
        DllCall("User32.dll\GetClipboardFormatNameW"
            , "UInt", format
            , "Ptr", nameBuf.Ptr
            , "Int", 128
            , "Int")

        formatName := StrGet(nameBuf.Ptr, "UTF-16")
        if (formatName = "")
            formatName := GetStandardFormatName(format)

        formats.Push(Format("Format {}: {}", format, formatName))
    }

    DllCall("User32.dll\CloseClipboard", "Int")

    result := "Available Clipboard Formats:`n`n"
    for item in formats
        result .= item . "`n"

    MsgBox(result, "Clipboard Formats")
}

; Get standard format names
GetStandardFormatName(format) {
    static names := Map(
        1, "CF_TEXT",
        2, "CF_BITMAP",
        3, "CF_METAFILEPICT",
        4, "CF_SYLK",
        5, "CF_DIF",
        6, "CF_TIFF",
        7, "CF_OEMTEXT",
        8, "CF_DIB",
        9, "CF_PALETTE",
        10, "CF_PENDATA",
        11, "CF_RIFF",
        12, "CF_WAVE",
        13, "CF_UNICODETEXT",
        14, "CF_ENHMETAFILE",
        15, "CF_HDROP",
        16, "CF_LOCALE",
        17, "CF_DIBV5"
    )
    return names.Has(format) ? names[format] : "Unknown"
}

;==============================================================================
; EXAMPLE 3: Custom Clipboard Formats
;==============================================================================
; Demonstrates registering and using custom clipboard formats

Example3_CustomFormats() {
    ; Register custom format
    customFormat := DllCall("User32.dll\RegisterClipboardFormatW"
        , "Str", "MyApp.CustomData"
        , "UInt")

    if (!customFormat) {
        MsgBox("Failed to register custom format!", "Error")
        return
    }

    MsgBox(Format("Registered custom format 'MyApp.CustomData'`nFormat ID: {}", customFormat), "Info")

    ; Create custom data structure
    customData := "HEADER|" . A_Now . "|" . A_UserName . "|Some custom data here"

    ; Open clipboard
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
        return

    DllCall("User32.dll\EmptyClipboard", "Int")

    ; Allocate and set custom data
    GHND := 0x0042
    dataSize := StrLen(customData) + 1

    hMem := DllCall("Kernel32.dll\GlobalAlloc", "UInt", GHND, "UPtr", dataSize, "Ptr")
    pMem := DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")
    StrPut(customData, pMem, dataSize, "UTF-8")
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "Int")

    DllCall("User32.dll\SetClipboardData", "UInt", customFormat, "Ptr", hMem, "Ptr")

    ; Also set regular text
    SetClipboardUnicode("This clipboard has custom format data too!")

    DllCall("User32.dll\CloseClipboard", "Int")

    MsgBox("Custom format data set!`n`nData: " . customData, "Success")

    ; Retrieve custom data
    Sleep(500)

    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
        return

    hData := DllCall("User32.dll\GetClipboardData", "UInt", customFormat, "Ptr")

    if (hData) {
        pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "Ptr")
        retrievedData := StrGet(pData, "UTF-8")
        DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData, "Int")

        MsgBox("Retrieved custom data:`n`n" . retrievedData, "Custom Format Retrieved")
    }

    DllCall("User32.dll\CloseClipboard", "Int")
}

;==============================================================================
; EXAMPLE 4: HTML Clipboard Format
;==============================================================================
; Shows how to set HTML formatted data on clipboard

Example4_HTMLClipboard() {
    ; Register HTML format
    CF_HTML := DllCall("User32.dll\RegisterClipboardFormatW", "Str", "HTML Format", "UInt")

    ; Create HTML clipboard data (requires special header)
    htmlContent := "<html><body><h1>Hello from API!</h1><p>This is <b>formatted</b> HTML.</p></body></html>"

    ; HTML clipboard format requires specific header
    header := "Version:0.9`r`nStartHTML:0000000000`r`nEndHTML:0000000000`r`nStartFragment:0000000000`r`nEndFragment:0000000000`r`n"
    htmlPrefix := "<html><body><!--StartFragment-->"
    htmlSuffix := "<!--EndFragment--></body></html>"

    fullHTML := htmlPrefix . htmlContent . htmlSuffix

    ; Calculate offsets
    startHTML := StrLen(header)
    endHTML := startHTML + StrLen(fullHTML)
    startFragment := startHTML + StrLen(htmlPrefix)
    endFragment := startFragment + StrLen(htmlContent)

    ; Format header with proper offsets
    header := Format("Version:0.9`r`nStartHTML:{:010d}`r`nEndHTML:{:010d}`r`nStartFragment:{:010d}`r`nEndFragment:{:010d}`r`n",
        startHTML, endHTML, startFragment, endFragment)

    finalData := header . fullHTML

    ; Set to clipboard
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
        return

    DllCall("User32.dll\EmptyClipboard", "Int")

    ; Allocate and copy data
    GHND := 0x0042
    dataSize := StrLen(finalData) + 1

    hMem := DllCall("Kernel32.dll\GlobalAlloc", "UInt", GHND, "UPtr", dataSize, "Ptr")
    pMem := DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")
    StrPut(finalData, pMem, dataSize, "UTF-8")
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "Int")

    DllCall("User32.dll\SetClipboardData", "UInt", CF_HTML, "Ptr", hMem, "Ptr")

    ; Also set plain text
    SetClipboardUnicode(htmlContent)

    DllCall("User32.dll\CloseClipboard", "Int")

    MsgBox("HTML formatted data set to clipboard!`n`nTry pasting into a rich text editor or email client.", "Success")
}

;==============================================================================
; EXAMPLE 5: Clipboard Monitoring
;==============================================================================
; Demonstrates monitoring clipboard changes using sequence numbers

Example5_ClipboardMonitoring() {
    MsgBox("This will monitor clipboard changes for 30 seconds.`n`nTry copying different things!", "Info")

    ; Get initial clipboard sequence number
    lastSequence := DllCall("User32.dll\GetClipboardSequenceNumber", "UInt")

    startTime := A_TickCount
    changes := []

    Loop {
        currentSequence := DllCall("User32.dll\GetClipboardSequenceNumber", "UInt")

        if (currentSequence != lastSequence) {
            ; Clipboard changed
            timestamp := FormatTime(, "HH:mm:ss")

            ; Try to get clipboard content
            content := GetClipboardPreview()

            changes.Push(Format("[{}] Sequence: {} -> {} | {}",
                timestamp, lastSequence, currentSequence, content))

            lastSequence := currentSequence
        }

        ; Check timeout
        if (A_TickCount - startTime > 30000)
            break

        Sleep(250)
    }

    ; Show results
    if (changes.Length = 0) {
        MsgBox("No clipboard changes detected in 30 seconds.", "Monitoring Complete")
    } else {
        result := "Clipboard Changes Detected:`n`n"
        for change in changes
            result .= change . "`n`n"

        MsgBox(result, "Monitoring Results")
    }
}

; Helper to get clipboard content preview
GetClipboardPreview() {
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
        return "Failed to open"

    CF_UNICODETEXT := 13
    hData := DllCall("User32.dll\GetClipboardData", "UInt", CF_UNICODETEXT, "Ptr")

    preview := "No text"
    if (hData) {
        pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "Ptr")
        text := StrGet(pData, "UTF-16")
        DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData, "Int")

        ; Get first 50 chars
        preview := SubStr(text, 1, 50)
        if (StrLen(text) > 50)
            preview .= "..."
    }

    DllCall("User32.dll\CloseClipboard", "Int")
    return preview
}

;==============================================================================
; EXAMPLE 6: Clipboard Owner and Priority
;==============================================================================
; Shows clipboard ownership and delayed rendering

Example6_ClipboardOwnership() {
    ; Get clipboard owner
    if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
        return

    ownerHwnd := DllCall("User32.dll\GetClipboardOwner", "Ptr")

    info := Format("Clipboard Owner HWND: 0x{:X}`n`n", ownerHwnd)

    if (ownerHwnd) {
        ; Get owner window title
        titleBuf := Buffer(512, 0)
        DllCall("User32.dll\GetWindowTextW", "Ptr", ownerHwnd, "Ptr", titleBuf.Ptr, "Int", 256, "Int")
        title := StrGet(titleBuf.Ptr, "UTF-16")

        ; Get owner process ID
        pidBuf := Buffer(4, 0)
        DllCall("User32.dll\GetWindowThreadProcessId", "Ptr", ownerHwnd, "Ptr", pidBuf.Ptr, "UInt")
        pid := NumGet(pidBuf, 0, "UInt")

        info .= "Owner Window Title: " . title . "`n"
        info .= "Owner Process ID: " . pid . "`n"
    } else {
        info .= "No owner (clipboard is empty or owner closed)"
    }

    ; Get clipboard sequence number
    sequence := DllCall("User32.dll\GetClipboardSequenceNumber", "UInt")
    info .= "`nClipboard Sequence: " . sequence

    ; Count formats
    formatCount := DllCall("User32.dll\CountClipboardFormats", "Int")
    info .= "`nFormat Count: " . formatCount

    DllCall("User32.dll\CloseClipboard", "Int")

    MsgBox(info, "Clipboard Information")
}

;==============================================================================
; EXAMPLE 7: Advanced Clipboard Operations
;==============================================================================
; Comprehensive clipboard management

Example7_AdvancedOperations() {
    ; Check if clipboard contains specific format
    CheckFormat := (formatName) {
        format := DllCall("User32.dll\RegisterClipboardFormatW", "Str", formatName, "UInt")
        isAvail := DllCall("User32.dll\IsClipboardFormatAvailable", "UInt", format, "Int")
        return isAvail
    }

    ; Check various formats
    formats := [
        "HTML Format",
        "Rich Text Format",
        "CSV",
        "XML"
    ]

    results := "Checking clipboard for various formats:`n`n"
    for formatName in formats {
        available := CheckFormat(formatName)
        results .= formatName . ": " . (available ? "YES" : "NO") . "`n"
    }

    ; Check standard formats
    CF_UNICODETEXT := 13
    CF_BITMAP := 2
    CF_HDROP := 15

    results .= "`nStandard Formats:`n"
    results .= "Unicode Text: " . (DllCall("User32.dll\IsClipboardFormatAvailable", "UInt", CF_UNICODETEXT, "Int") ? "YES" : "NO") . "`n"
    results .= "Bitmap: " . (DllCall("User32.dll\IsClipboardFormatAvailable", "UInt", CF_BITMAP, "Int") ? "YES" : "NO") . "`n"
    results .= "Files (HDROP): " . (DllCall("User32.dll\IsClipboardFormatAvailable", "UInt", CF_HDROP, "Int") ? "YES" : "NO") . "`n"

    MsgBox(results, "Format Detection")

    ; Demonstrate adding priority clipboard data
    if MsgBox("Set multi-format clipboard data with priority?", "Question", "YesNo") = "Yes" {
        if !DllCall("User32.dll\OpenClipboard", "Ptr", 0, "Int")
            return

        DllCall("User32.dll\EmptyClipboard", "Int")

        ; Set data in priority order (most preferred first)
        ; 1. HTML Format (highest priority)
        CF_HTML := DllCall("User32.dll\RegisterClipboardFormatW", "Str", "HTML Format", "UInt")
        SetClipboardFormat(CF_HTML, "HTML formatted data")

        ; 2. Unicode text
        SetClipboardUnicode("Unicode text version")

        ; 3. Plain text (lowest priority)
        SetClipboardAnsi("ANSI text version")

        DllCall("User32.dll\CloseClipboard", "Int")

        MsgBox("Multi-format clipboard data set with priority!", "Success")
    }
}

; Helper to set any format
SetClipboardFormat(format, data) {
    GHND := 0x0042
    dataSize := StrLen(data) + 1

    hMem := DllCall("Kernel32.dll\GlobalAlloc", "UInt", GHND, "UPtr", dataSize, "Ptr")
    pMem := DllCall("Kernel32.dll\GlobalLock", "Ptr", hMem, "Ptr")
    StrPut(data, pMem, dataSize, "UTF-8")
    DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hMem, "Int")
    DllCall("User32.dll\SetClipboardData", "UInt", format, "Ptr", hMem, "Ptr")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    Clipboard Operations DllCall Examples
    ======================================

    1. Basic Clipboard Text
    2. Multiple Formats
    3. Custom Clipboard Formats
    4. HTML Clipboard Format
    5. Clipboard Monitoring
    6. Clipboard Ownership Info
    7. Advanced Operations

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "Clipboard Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_BasicClipboardText()
            case "2": Example2_MultipleFormats()
            case "3": Example3_CustomFormats()
            case "4": Example4_HTMLClipboard()
            case "5": Example5_ClipboardMonitoring()
            case "6": Example6_ClipboardOwnership()
            case "7": Example7_AdvancedOperations()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
