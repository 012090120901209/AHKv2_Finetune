#Requires AutoHotkey v2.0

/**
* BuiltIn_FileGetSize_06.ahk
*
* DESCRIPTION:
* Advanced byte formatting and size display techniques
*
* FEATURES:
* - Multiple formatting styles
* - Precision control
* - Binary vs decimal units
* - Progress bar sizing
* - Size statistics
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/FileGetSize.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - FileGetSize() with formatting
* - Number rounding and precision
* - String formatting
* - Mathematical calculations
* - Custom formatting functions
*
* LEARNING POINTS:
* 1. Binary (1024) vs Decimal (1000) units
* 2. IEC (KiB) vs SI (KB) notation
* 3. Precision control in formatting
* 4. Context-appropriate formatting
* 5. Performance considerations
* 6. Localization support
*/

; ============================================================
; Example 1: Binary vs Decimal Formatting
; ============================================================

/**
* Format size using binary units (1024-based)
*
* @param {Integer} bytes - Size in bytes
* @param {Integer} decimals - Decimal places
* @returns {String} - Formatted size (IEC notation)
*/
FormatBinarySize(bytes, decimals := 2) {
    units := ["B", "KiB", "MiB", "GiB", "TiB"]
    index := 1
    size := bytes

    while (size >= 1024 && index < units.Length) {
        size := size / 1024.0
        index++
    }

    if (index = 1)
    return size " " units[index]

    return Round(size, decimals) " " units[index]
}

/**
* Format size using decimal units (1000-based)
*
* @param {Integer} bytes - Size in bytes
* @param {Integer} decimals - Decimal places
* @returns {String} - Formatted size (SI notation)
*/
FormatDecimalSize(bytes, decimals := 2) {
    units := ["B", "KB", "MB", "GB", "TB"]
    index := 1
    size := bytes

    while (size >= 1000 && index < units.Length) {
        size := size / 1000.0
        index++
    }

    if (index = 1)
    return size " " units[index]

    return Round(size, decimals) " " units[index]
}

; Create test file
testFile := A_ScriptDir "\sizingtest.dat"
content := ""
Loop 5000
content .= "Data line " A_Index " with content`n"
FileAppend(content, testFile)

; Get size and format both ways
bytes := FileGetSize(testFile)

output := "BINARY vs DECIMAL UNITS:`n`n"
output .= "Raw Bytes: " bytes " B`n`n"
output .= "Binary (IEC - Base 1024):`n"
output .= "  " FormatBinarySize(bytes, 2) "`n`n"
output .= "Decimal (SI - Base 1000):`n"
output .= "  " FormatDecimalSize(bytes, 2) "`n`n"
output .= "Difference: Binary units show smaller numbers"

MsgBox(output, "Unit Systems", "Icon!")

; ============================================================
; Example 2: Precision-Controlled Formatting
; ============================================================

/**
* Format size with configurable precision
*
* @param {Integer} bytes - Size in bytes
* @param {Object} options - Formatting options
* @returns {String} - Formatted size
*/
FormatSizeAdvanced(bytes, options := "") {
    if (!options)
    options := {decimals: 2, showBytes: false, separator: " ", style: "binary"}

    ; Choose unit system
    base := options.style = "decimal" ? 1000 : 1024
    units := options.style = "decimal"
    ? ["B", "KB", "MB", "GB", "TB"]
    : ["B", "KiB", "MiB", "GiB", "TiB"]

    ; Calculate unit
    index := 1
    size := bytes

    while (size >= base && index < units.Length) {
        size := size / Float(base)
        index++
    }

    ; Format number
    if (index = 1) {
        formatted := size
    } else {
        formatted := Round(size, options.decimals)
    }

    ; Build result
    result := formatted . options.separator . units[index]

    ; Add raw bytes if requested
    if (options.showBytes && index > 1)
    result .= " (" bytes " bytes)"

    return result
}

; Test different precision levels
output := "PRECISION CONTROL:`n`n"
output .= "File Size: " bytes " bytes`n`n"

precisions := [0, 1, 2, 3]
for precision in precisions {
    opts := {decimals: precision, showBytes: false, separator: " ", style: "binary"}
    output .= precision " decimals: " FormatSizeAdvanced(bytes, opts) "`n"
}

output .= "`nWith raw bytes:"
opts := {decimals: 2, showBytes: true, separator: " ", style: "binary"}
output .= "`n" FormatSizeAdvanced(bytes, opts)

MsgBox(output, "Precision Formatting", "Icon!")

; ============================================================
; Example 3: Context-Aware Formatting
; ============================================================

/**
* Format size based on context (small, medium, large)
*
* @param {Integer} bytes - Size in bytes
* @param {String} context - Context hint
* @returns {String} - Context-appropriate formatting
*/
FormatSizeContext(bytes, context := "auto") {
    ; Auto-detect context
    if (context = "auto") {
        if (bytes < 1024)
        context := "small"
        else if (bytes < 1024 * 1024)
        context := "medium"
        else
        context := "large"
    }

    ; Format based on context
    switch context {
        case "small":
        ; Show exact bytes for small files
        return bytes " bytes"

        case "medium":
        ; Show KB with 1 decimal
        kb := Round(bytes / 1024.0, 1)
        return kb " KB (" bytes " bytes)"

        case "large":
        ; Show MB/GB with 2 decimals
        if (bytes < 1024 * 1024 * 1024) {
            mb := Round(bytes / (1024.0 * 1024), 2)
            return mb " MB"
        } else {
            gb := Round(bytes / (1024.0 * 1024 * 1024), 2)
            return gb " GB"
        }
    }
}

; Test context-aware formatting
testSizes := [
{
    bytes: 523, desc: "Small file"},
    {
        bytes: 45678, desc: "Medium file"},
        {
            bytes: 5234567, desc: "Large file"},
            {
                bytes: 1234567890, desc: "Very large file"
            }
            ]

            output := "CONTEXT-AWARE FORMATTING:`n`n"
            for item in testSizes {
                output .= item.desc ":`n"
                output .= "  " FormatSizeContext(item.bytes) "`n`n"
            }

            MsgBox(output, "Context Formatting", "Icon!")

            ; ============================================================
            ; Example 4: Progress Bar Size Display
            ; ============================================================

            /**
            * Create text-based progress bar for file size
            *
            * @param {Integer} currentBytes - Current size
            * @param {Integer} maxBytes - Maximum size
            * @param {Integer} width - Progress bar width
            * @returns {String} - Progress bar display
            */
            FormatSizeProgress(currentBytes, maxBytes, width := 30) {
                percent := (currentBytes / Float(maxBytes)) * 100
                filled := Round((currentBytes / Float(maxBytes)) * width)

                bar := "["
                Loop width {
                    bar .= (A_Index <= filled) ? "█" : "░"
                }
                bar .= "]"

                return bar " " Round(percent, 1) "%`n"
                . FormatBinarySize(currentBytes) " / " FormatBinarySize(maxBytes)
            }

            ; Simulate download progress
            totalSize := 1024 * 1024 * 50  ; 50 MB
            currentSize := 1024 * 1024 * 32  ; 32 MB downloaded

            output := "SIZE PROGRESS DISPLAY:`n`n"
            output .= "Download Progress:`n`n"
            output .= FormatSizeProgress(currentSize, totalSize, 40) "`n`n"
            output .= "Remaining: " FormatBinarySize(totalSize - currentSize)

            MsgBox(output, "Progress Display", "Icon!")

            ; ============================================================
            ; Example 5: Comparative Size Display
            ; ============================================================

            /**
            * Display size comparison chart
            *
            * @param {Array} files - Array of file paths
            * @returns {String} - Comparison chart
            */
            CreateSizeChart(files) {
                ; Get all sizes
                fileData := []
                maxSize := 0

                for filePath in files {
                    if (!FileExist(filePath))
                    continue

                    size := FileGetSize(filePath)
                    SplitPath(filePath, &name)

                    fileData.Push({
                        name: name,
                        size: size,
                        formatted: FormatBinarySize(size)
                    })

                    if (size > maxSize)
                    maxSize := size
                }

                ; Create chart
                chart := "FILE SIZE COMPARISON:`n`n"

                for item in fileData {
                    barWidth := Round((item.size / Float(maxSize)) * 40)
                    bar := ""
                    Loop barWidth
                    bar .= "█"

                    chart .= SubStr(item.name . "                    ", 1, 20)
                    chart .= " " bar " " item.formatted "`n"
                }

                return chart
            }

            ; Create test files of different sizes
            testFiles := []
            Loop 5 {
                file := A_ScriptDir "\file" A_Index ".txt"
                content := ""
                Loop (A_Index * 500)
                content .= "Line " A_Index "`n"
                FileAppend(content, file)
                testFiles.Push(file)
            }

            ; Create chart
            chart := CreateSizeChart(testFiles)
            MsgBox(chart, "Size Chart", "Icon!")

            ; ============================================================
            ; Example 6: Statistical Size Formatting
            ; ============================================================

            /**
            * Calculate size statistics for multiple files
            *
            * @param {Array} files - Array of file paths
            * @returns {Object} - Size statistics
            */
            CalculateSizeStats(files) {
                sizes := []

                for filePath in files {
                    if (FileExist(filePath) && !InStr(FileExist(filePath), "D"))
                    sizes.Push(FileGetSize(filePath))
                }

                if (sizes.Length = 0)
                return {valid: false}

                ; Calculate statistics
                total := 0
                min := sizes[1]
                max := sizes[1]

                for size in sizes {
                    total += size
                    if (size < min)
                    min := size
                    if (size > max)
                    max := size
                }

                average := total / sizes.Length

                return {
                    valid: true,
                    count: sizes.Length,
                    total: total,
                    min: min,
                    max: max,
                    average: average,
                    range: max - min
                }
            }

            ; Calculate stats for test files
            stats := CalculateSizeStats(testFiles)

            if (stats.valid) {
                output := "SIZE STATISTICS:`n`n"
                output .= "Files Analyzed: " stats.count "`n`n"
                output .= "Total Size: " FormatBinarySize(stats.total) "`n"
                output .= "Average Size: " FormatBinarySize(Round(stats.average)) "`n"
                output .= "Smallest: " FormatBinarySize(stats.min) "`n"
                output .= "Largest: " FormatBinarySize(stats.max) "`n"
                output .= "Range: " FormatBinarySize(stats.range)

                MsgBox(output, "Size Statistics", "Icon!")
            }

            ; ============================================================
            ; Example 7: Localized Size Formatting
            ; ============================================================

            /**
            * Format size with locale-specific number formatting
            *
            * @param {Integer} bytes - Size in bytes
            * @param {String} locale - Locale code (en, de, fr, etc.)
            * @returns {String} - Localized size string
            */
            FormatSizeLocalized(bytes, locale := "en") {
                ; Determine separators based on locale
                separators := Map(
                "en", {thousand: ",", decimal: "."},
                "de", {thousand: ".", decimal: ","},
                "fr", {thousand: " ", decimal: ","}
                )

                sep := separators.Has(locale) ? separators[locale] : separators["en"]

                ; Calculate size in KB/MB/GB
                if (bytes < 1024)
                return bytes " B"

                if (bytes < 1024 * 1024) {
                    kb := Round(bytes / 1024.0, 2)
                    return FormatNumber(kb, sep.decimal, sep.thousand) " KB"
                }

                if (bytes < 1024 * 1024 * 1024) {
                    mb := Round(bytes / (1024.0 * 1024), 2)
                    return FormatNumber(mb, sep.decimal, sep.thousand) " MB"
                }

                gb := Round(bytes / (1024.0 * 1024 * 1024), 2)
                return FormatNumber(gb, sep.decimal, sep.thousand) " GB"

                FormatNumber(num, decSep, thouSep) {
                    ; Simple number formatting
                    str := String(num)
                    str := StrReplace(str, ".", decSep)
                    return str
                }
            }

            ; Test localized formatting
            largeSize := 1234567890  ; ~1.15 GB

            output := "LOCALIZED FORMATTING:`n`n"
            output .= "Size: " largeSize " bytes`n`n"
            output .= "English (en): " FormatSizeLocalized(largeSize, "en") "`n"
            output .= "German (de): " FormatSizeLocalized(largeSize, "de") "`n"
            output .= "French (fr): " FormatSizeLocalized(largeSize, "fr")

            MsgBox(output, "Localized Sizes", "Icon!")

            ; ============================================================
            ; Reference Information
            ; ============================================================

            info := "
            (
            ADVANCED SIZE FORMATTING:

            Unit Systems:
            1. Binary (IEC - Base 1024):
            B, KiB, MiB, GiB, TiB
            1 KiB = 1,024 bytes
            More accurate for computer storage

            2. Decimal (SI - Base 1000):
            B, KB, MB, GB, TB
            1 KB = 1,000 bytes
            Common in marketing, networking

            Formatting Guidelines:

            Small Files (< 1 KB):
            • Show exact bytes
            • Example: '843 bytes'

            Medium Files (< 1 MB):
            • Show KB with 1-2 decimals
            • Include bytes in parentheses
            • Example: '45.6 KB (46,698 bytes)'

            Large Files (>= 1 MB):
            • Show MB/GB with 2 decimals
            • Example: '3.14 MB' or '1.52 GB'

            Precision Tips:
            • 0 decimals: Progress indicators
            • 1 decimal: General file listings
            • 2 decimals: Detailed comparisons
            • 3+ decimals: Scientific/technical use

            Context Matters:
            ✓ File managers: 1-2 decimals
            ✓ Download progress: 0-1 decimals
            ✓ Storage analysis: 2 decimals
            ✓ Technical logs: Raw bytes

            Best Practices:
            • Be consistent within application
            • Choose appropriate unit system
            • Consider your audience
            • Document which system used
            • Use context-appropriate precision
            )"

            MsgBox(info, "Formatting Reference", "Icon!")

            ; Cleanup
            FileDelete(testFile)
            Loop 5
            FileDelete(A_ScriptDir "\file" A_Index ".txt")
