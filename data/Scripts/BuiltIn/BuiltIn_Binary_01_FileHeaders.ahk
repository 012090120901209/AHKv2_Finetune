#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Binary_01_FileHeaders.ahk
 * 
 * DESCRIPTION:
 * Reading and parsing binary file headers using Buffer, NumGet, and StrGet.
 * Demonstrates practical binary data analysis with common file formats.
 * 
 * FEATURES:
 * - Reading binary file headers
 * - Magic number verification
 * - Structure parsing from files
 * - File type detection
 * - Header metadata extraction
 * - Endianness handling
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Binary Operations
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - FileRead with "RAW" option
 * - Buffer object with file data
 * - NumGet for multi-field parsing
 * - Practical file format analysis
 * - Binary data interpretation
 * 
 * LEARNING POINTS:
 * 1. File headers contain metadata about file contents
 * 2. Magic numbers identify file types
 * 3. Headers follow specific structure layouts
 * 4. Binary parsing requires precise offset calculation
 * 5. Different file formats use different byte orders
 */

; ================================================================================================
; EXAMPLE 1: PNG File Header Parsing
; ================================================================================================

Example1_PNGHeader() {
    ; PNG header structure (first 33 bytes)
    buf := Buffer(33)

    ; PNG signature: 89 50 4E 47 0D 0A 1A 0A
    NumPut("UChar", 0x89, buf, 0)
    NumPut("UChar", 0x50, buf, 1)
    NumPut("UChar", 0x4E, buf, 2)
    NumPut("UChar", 0x47, buf, 3)
    NumPut("UChar", 0x0D, buf, 4)
    NumPut("UChar", 0x0A, buf, 5)
    NumPut("UChar", 0x1A, buf, 6)
    NumPut("UChar", 0x0A, buf, 7)

    ; IHDR chunk (width: 800, height: 600, bit depth: 8)
    NumPut("UInt", 0x0000000D, buf, 8)   ; Length (big-endian)
    NumPut("UChar", 0x49, buf, 12)  ; 'I'
    NumPut("UChar", 0x48, buf, 13)  ; 'H'
    NumPut("UChar", 0x44, buf, 14)  ; 'D'
    NumPut("UChar", 0x52, buf, 15)  ; 'R'
    NumPut("UInt", 0x00000320, buf, 16)  ; Width: 800 (big-endian)
    NumPut("UInt", 0x00000258, buf, 20)  ; Height: 600 (big-endian)
    NumPut("UChar", 8, buf, 24)     ; Bit depth
    NumPut("UChar", 2, buf, 25)     ; Color type (RGB)

    ; Parse PNG header
    sig1 := NumGet(buf, 0, "UChar")
    sig2 := NumGet(buf, 1, "UChar")
    sig3 := NumGet(buf, 2, "UChar")
    sig4 := NumGet(buf, 3, "UChar")

    isPNG := (sig1 = 0x89 && sig2 = 0x50 && sig3 = 0x4E && sig4 = 0x47)

    ; Read dimensions (big-endian)
    width := SwapEndian32(NumGet(buf, 16, "UInt"))
    height := SwapEndian32(NumGet(buf, 20, "UInt"))
    bitDepth := NumGet(buf, 24, "UChar")
    colorType := NumGet(buf, 25, "UChar")

    SwapEndian32(value) {
        return ((value & 0xFF) << 24)
        | ((value & 0xFF00) << 8)
        | ((value & 0xFF0000) >> 8)
        | ((value >> 24) & 0xFF)
    }

    result := "PNG File Header Parsing:`n`n"
    result .= "Signature: " . Format("{:02X} {:02X} {:02X} {:02X}", sig1, sig2, sig3, sig4) . "`n"
    result .= "Valid PNG: " . (isPNG ? "Yes ✓" : "No") . "`n`n"

    result .= "IHDR Chunk:`n"
    result .= "  Width: " . width . " pixels`n"
    result .= "  Height: " . height . " pixels`n"
    result .= "  Bit Depth: " . bitDepth . "`n"
    result .= "  Color Type: " . (colorType = 2 ? "RGB" : colorType)

    MsgBox(result, "Example 1: PNG Header", "Icon!")
}

; ================================================================================================
; EXAMPLE 2: BMP File Header
; ================================================================================================

Example2_BMPHeader() {
    ; BMP header (14 + 40 bytes)
    buf := Buffer(54)

    ; BITMAPFILEHEADER (14 bytes)
    NumPut("UShort", 0x4D42, buf, 0)  ; "BM" signature
    NumPut("UInt", 10054, buf, 2)      ; File size
    NumPut("UShort", 0, buf, 6)        ; Reserved
    NumPut("UShort", 0, buf, 8)        ; Reserved
    NumPut("UInt", 54, buf, 10)        ; Offset to image data

    ; BITMAPINFOHEADER (40 bytes)
    NumPut("UInt", 40, buf, 14)         ; Header size
    NumPut("Int", 640, buf, 18)         ; Width
    NumPut("Int", 480, buf, 22)         ; Height
    NumPut("UShort", 1, buf, 26)        ; Planes
    NumPut("UShort", 24, buf, 28)       ; Bits per pixel
    NumPut("UInt", 0, buf, 30)          ; Compression

    ; Parse header
    magic := NumGet(buf, 0, "UShort")
    isBMP := magic = 0x4D42

    fileSize := NumGet(buf, 2, "UInt")
    dataOffset := NumGet(buf, 10, "UInt")
    headerSize := NumGet(buf, 14, "UInt")
    width := NumGet(buf, 18, "Int")
    height := NumGet(buf, 22, "Int")
    bpp := NumGet(buf, 28, "UShort")

    result := "BMP File Header Parsing:`n`n"
    result .= "Magic: 0x" . Format("{:04X}", magic) . " ('"
        . Chr(magic & 0xFF) . Chr((magic >> 8) & 0xFF) . "')`n"
    result .= "Valid BMP: " . (isBMP ? "Yes ✓" : "No") . "`n`n"

    result .= "File Header:`n"
    result .= "  File Size: " . fileSize . " bytes`n"
    result .= "  Data Offset: " . dataOffset . "`n`n"

    result .= "Info Header:`n"
    result .= "  Header Size: " . headerSize . " bytes`n"
    result .= "  Dimensions: " . width . "x" . height . "`n"
    result .= "  Bits/Pixel: " . bpp

    MsgBox(result, "Example 2: BMP Header", "Icon!")
}

; ================================================================================================
; EXAMPLE 3: Custom Binary File Format
; ================================================================================================

Example3_CustomFormat() {
    ; Create custom file header
    buf := Buffer(64)

    ; Magic number: "AHKD"
    NumPut("UInt", 0x444B4841, buf, 0)

    ; Version: 2.0 (major.minor)
    NumPut("UShort", 2, buf, 4)
    NumPut("UShort", 0, buf, 6)

    ; Flags
    NumPut("UInt", 0x00000005, buf, 8)  ; Compressed + Encrypted

    ; File size
    NumPut("UInt64", 1048576, buf, 12)

    ; Creation timestamp
    NumPut("UInt64", 1700000000, buf, 20)

    ; Record count
    NumPut("UInt", 5000, buf, 28)

    ; Data offset
    NumPut("UInt", 1024, buf, 32)

    ; Reserved
    NumPut("UInt64", 0, buf, 36)
    NumPut("UInt64", 0, buf, 44)

    ; File name (16 bytes)
    fileName := "data.bin"
    StrPut(fileName, buf.Ptr + 48, 16, "UTF-8")

    ; Parse header
    magic := NumGet(buf, 0, "UInt")
    vMajor := NumGet(buf, 4, "UShort")
    vMinor := NumGet(buf, 6, "UShort")
    flags := NumGet(buf, 8, "UInt")
    fileSize := NumGet(buf, 12, "UInt64")
    timestamp := NumGet(buf, 20, "UInt64")
    recordCount := NumGet(buf, 28, "UInt")
    dataOffset := NumGet(buf, 32, "UInt")
    name := StrGet(buf.Ptr + 48, 16, "UTF-8")

    ; Parse flags
    isCompressed := (flags & 0x01) != 0
    isEncrypted := (flags & 0x04) != 0

    result := "Custom Binary Format:`n`n"
    result .= "Magic: 0x" . Format("{:08X}", magic) . "`n"
    result .= "Version: " . vMajor . "." . vMinor . "`n`n"

    result .= "Flags:`n"
    result .= "  Compressed: " . (isCompressed ? "Yes" : "No") . "`n"
    result .= "  Encrypted: " . (isEncrypted ? "Yes" : "No") . "`n`n"

    result .= "File Info:`n"
    result .= "  Name: '" . name . "'`n"
    result .= "  Size: " . Format("{:,}", fileSize) . " bytes`n"
    result .= "  Records: " . Format("{:,}", recordCount) . "`n"
    result .= "  Data Offset: " . dataOffset . " bytes`n"
    result .= "  Timestamp: " . timestamp

    MsgBox(result, "Example 3: Custom Format", "Icon!")
}

; ================================================================================================
; Main Menu
; ================================================================================================

ShowMenu() {
    menu := "
    (
    Binary File Header Examples

    1. PNG File Header Parsing
    2. BMP File Header Parsing
    3. Custom Binary File Format

    Select an example (1-3) or press Cancel to exit:
    )"

    choice := InputBox(menu, "Binary File Headers", "w450 h250")

    if choice.Result = "Cancel"
        return

    switch choice.Value {
        case "1": Example1_PNGHeader()
        case "2": Example2_BMPHeader()
        case "3": Example3_CustomFormat()
        default: MsgBox("Invalid selection. Please choose 1-3.", "Error", "Icon!")
    }

    SetTimer(() => ShowMenu(), -100)
}

ShowMenu()
