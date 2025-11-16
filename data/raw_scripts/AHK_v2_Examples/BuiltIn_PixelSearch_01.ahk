#Requires AutoHotkey v2.0
/**
 * BuiltIn_PixelSearch_01.ahk
 *
 * DESCRIPTION:
 * Basic usage of PixelGetColor() and PixelSearch() for screen color detection
 *
 * FEATURES:
 * - Get pixel color at specific coordinates
 * - Search for pixels by color
 * - Color comparison and matching
 * - Screen region scanning
 * - Coordinate handling
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/PixelGetColor.htm
 * https://www.autohotkey.com/docs/v2/lib/PixelSearch.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - PixelGetColor() function
 * - PixelSearch() with output variables
 * - Color format conversion (RGB/BGR)
 * - Coordinate systems
 * - Variation tolerance
 *
 * LEARNING POINTS:
 * 1. PixelGetColor(X, Y) returns color in 0xRRGGBB format
 * 2. PixelSearch() finds first pixel matching color in region
 * 3. Variation parameter allows fuzzy color matching (0-255)
 * 4. Coordinates are screen-relative by default
 * 5. Fast mode (0x2) for speed, RGB mode (0x1) for color format
 * 6. Returns coordinates via ByRef parameters
 */

; ============================================================
; Example 1: Get Pixel Color at Mouse Position
; ============================================================

/**
 * Get color of pixel under mouse cursor
 */
GetPixelUnderMouse() {
    ; Get current mouse position
    MouseGetPos(&x, &y)

    ; Get color at that position
    color := PixelGetColor(x, y)

    ; Convert to RGB components
    red := (color >> 16) & 0xFF
    green := (color >> 8) & 0xFF
    blue := color & 0xFF

    MsgBox("Pixel Color at Mouse Position`n`n"
         . "Position: " x ", " y "`n"
         . "Color (Hex): " Format("0x{:06X}", color) "`n"
         . "Color (Dec): " color "`n`n"
         . "Red: " red "`n"
         . "Green: " green "`n"
         . "Blue: " blue,
         "Pixel Color", "Iconi")

    return color
}

; Uncomment to test:
; GetPixelUnderMouse()

; Hotkey to get pixel color: Ctrl+Shift+P
; ^+p::GetPixelUnderMouse()

; ============================================================
; Example 2: Basic PixelSearch in Region
; ============================================================

/**
 * Search for a specific color in screen region
 *
 * @param {Integer} x1 - Left coordinate
 * @param {Integer} y1 - Top coordinate
 * @param {Integer} x2 - Right coordinate
 * @param {Integer} y2 - Bottom coordinate
 * @param {Integer} color - Color to search for (0xRRGGBB)
 * @returns {Object} - {found: bool, x: int, y: int}
 */
SearchPixelInRegion(x1, y1, x2, y2, color) {
    try {
        ; PixelSearch returns 1 if found, 0 if not
        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, color, 0) {
            MsgBox("Pixel Found!`n`n"
                 . "Color: " Format("0x{:06X}", color) "`n"
                 . "Position: " foundX ", " foundY "`n"
                 . "Search Region: (" x1 "," y1 ") to (" x2 "," y2 ")",
                 "Found", "Iconi")

            return {found: true, x: foundX, y: foundY}
        } else {
            MsgBox("Pixel Not Found`n`n"
                 . "Color: " Format("0x{:06X}", color) "`n"
                 . "Search Region: (" x1 "," y1 ") to (" x2 "," y2 ")",
                 "Not Found", "Icon!")

            return {found: false, x: 0, y: 0}
        }

    } catch as err {
        MsgBox("Error during pixel search:`n" err.Message,
               "Error", "Iconx")
        return {found: false, x: 0, y: 0}
    }
}

; Test pixel search
; Search for white color (0xFFFFFF) in top-left quadrant
; SearchPixelInRegion(0, 0, A_ScreenWidth // 2, A_ScreenHeight // 2, 0xFFFFFF)

; ============================================================
; Example 3: Color Variation and Tolerance
; ============================================================

/**
 * Search with color variation for fuzzy matching
 */
class ColorMatcher {
    /**
     * Search with variation tolerance
     *
     * @param {Integer} x1 - Left coordinate
     * @param {Integer} y1 - Top coordinate
     * @param {Integer} x2 - Right coordinate
     * @param {Integer} y2 - Bottom coordinate
     * @param {Integer} color - Target color
     * @param {Integer} variation - Tolerance (0-255)
     */
    static SearchWithVariation(x1, y1, x2, y2, color, variation := 0) {
        MsgBox("Searching for color with variation:`n`n"
             . "Color: " Format("0x{:06X}", color) "`n"
             . "Variation: " variation "`n"
             . "Region: (" x1 "," y1 ") to (" x2 "," y2 ")",
             "Searching", "T1")

        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, color, variation) {
            actualColor := PixelGetColor(foundX, foundY)

            MsgBox("Match Found!`n`n"
                 . "Target Color: " Format("0x{:06X}", color) "`n"
                 . "Found Color: " Format("0x{:06X}", actualColor) "`n"
                 . "Position: " foundX ", " foundY "`n"
                 . "Variation Used: " variation,
                 "Found", "Iconi")

            return {found: true, x: foundX, y: foundY}
        }

        MsgBox("No match found within variation tolerance",
               "Not Found", "Icon!")
        return {found: false, x: 0, y: 0}
    }

    /**
     * Demonstrate different variation levels
     */
    static DemonstrateVariation() {
        ; Get color at mouse position
        MouseGetPos(&x, &y)
        targetColor := PixelGetColor(x, y)

        MsgBox("Target color captured at: " x ", " y "`n"
             . "Color: " Format("0x{:06X}", targetColor) "`n`n"
             . "Will search with different variations...",
             "Demo", "Iconi T2")

        ; Search region (200x200 around mouse)
        x1 := Max(0, x - 100)
        y1 := Max(0, y - 100)
        x2 := Min(A_ScreenWidth, x + 100)
        y2 := Min(A_ScreenHeight, y + 100)

        variations := [0, 10, 30, 50]

        for variation in variations {
            if PixelSearch(&foundX, &foundY, x1, y1, x2, y2,
                          targetColor, variation) {
                MsgBox("Variation " variation ": Found at "
                     . foundX ", " foundY,
                     "Result", "T1")
            } else {
                MsgBox("Variation " variation ": Not found",
                     "Result", "T1")
            }
            Sleep(500)
        }
    }
}

; Test color matching
; ColorMatcher.DemonstrateVariation()
; ColorMatcher.SearchWithVariation(0, 0, 500, 500, 0xFF0000, 30)  ; Red with tolerance

; ============================================================
; Example 4: Screen Color Scanner
; ============================================================

/**
 * Scan screen regions and analyze colors
 */
class ColorScanner {
    /**
     * Scan a grid and report dominant colors
     *
     * @param {Integer} x1 - Left coordinate
     * @param {Integer} y1 - Top coordinate
     * @param {Integer} x2 - Right coordinate
     * @param {Integer} y2 - Bottom coordinate
     * @param {Integer} gridSize - Grid spacing
     */
    static ScanGrid(x1, y1, x2, y2, gridSize := 50) {
        colorMap := Map()
        totalPixels := 0

        MsgBox("Scanning grid region:`n"
             . "Region: (" x1 "," y1 ") to (" x2 "," y2 ")`n"
             . "Grid size: " gridSize "px",
             "Scanning", "T1")

        ; Scan grid points
        y := y1
        while y <= y2 {
            x := x1
            while x <= x2 {
                color := PixelGetColor(x, y)

                ; Count color occurrences
                if colorMap.Has(color)
                    colorMap[color] := colorMap[color] + 1
                else
                    colorMap[color] := 1

                totalPixels++

                x += gridSize
            }
            y += gridSize
        }

        ; Find most common colors
        output := "GRID SCAN RESULTS:`n`n"
        output .= "Total sampled: " totalPixels " pixels`n"
        output .= "Unique colors: " colorMap.Count "`n`n"
        output .= "Top colors:`n"

        ; Convert map to array for sorting
        colors := []
        for color, count in colorMap {
            colors.Push({color: color, count: count})
        }

        ; Sort by count (descending)
        colors := this.SortByCount(colors)

        ; Show top 5
        Loop Min(5, colors.Length) {
            item := colors[A_Index]
            percent := Round((item.count / totalPixels) * 100, 1)
            output .= A_Index ". " Format("0x{:06X}", item.color)
            output .= " (" percent "%)`n"
        }

        MsgBox(output, "Scan Results", "Iconi")
    }

    /**
     * Sort color array by count
     *
     * @param {Array} arr - Array of {color, count} objects
     * @returns {Array} - Sorted array
     */
    static SortByCount(arr) {
        ; Simple bubble sort (good enough for small arrays)
        n := arr.Length
        Loop n - 1 {
            i := A_Index
            Loop n - i {
                j := A_Index
                if arr[j].count < arr[j + 1].count {
                    temp := arr[j]
                    arr[j] := arr[j + 1]
                    arr[j + 1] := temp
                }
            }
        }
        return arr
    }

    /**
     * Check if region is mostly one color
     *
     * @param {Integer} x1 - Left coordinate
     * @param {Integer} y1 - Top coordinate
     * @param {Integer} x2 - Right coordinate
     * @param {Integer} y2 - Bottom coordinate
     * @param {Integer} targetColor - Color to check for
     * @param {Integer} threshold - Percentage threshold (0-100)
     */
    static IsRegionColor(x1, y1, x2, y2, targetColor, threshold := 80) {
        sampleSize := 20
        matches := 0
        total := 0

        stepX := (x2 - x1) / sampleSize
        stepY := (y2 - y1) / sampleSize

        Loop sampleSize {
            x := Round(x1 + (A_Index * stepX))
            Loop sampleSize {
                y := Round(y1 + (A_Index * stepY))

                color := PixelGetColor(x, y)
                if color = targetColor
                    matches++

                total++
            }
        }

        percentage := (matches / total) * 100

        MsgBox("Region Color Check:`n`n"
             . "Target Color: " Format("0x{:06X}", targetColor) "`n"
             . "Match Rate: " Round(percentage, 1) "%`n"
             . "Threshold: " threshold "%`n"
             . "Result: " (percentage >= threshold ? "MATCH" : "NO MATCH"),
             "Region Check", "Iconi")

        return percentage >= threshold
    }
}

; Test color scanner
; ColorScanner.ScanGrid(0, 0, 400, 400, 40)
; ColorScanner.IsRegionColor(0, 0, 100, 100, 0xFFFFFF, 80)  ; Check if mostly white

; ============================================================
; Example 5: Color Picker Tool
; ============================================================

/**
 * Interactive color picker with real-time display
 */
class ColorPicker {
    static isActive := false
    static pickedColors := []

    /**
     * Start color picker mode
     */
    static Start() {
        if this.isActive {
            MsgBox("Color picker already active", "Info", "Iconi T1")
            return
        }

        this.isActive := true

        MsgBox("Color Picker Started`n`n"
             . "Move mouse to see colors`n"
             . "Click to pick color`n"
             . "Press ESC to exit",
             "Color Picker", "Iconi")

        ; Start tracking
        SetTimer(() => this.TrackMouse(), 100)

        ; Setup click to pick
        ~LButton::ColorPicker.PickColor()

        ; Setup ESC to exit
        Esc::ColorPicker.Stop()
    }

    /**
     * Track mouse and show color
     */
    static TrackMouse() {
        if !this.isActive
            return

        MouseGetPos(&x, &y)
        color := PixelGetColor(x, y)

        red := (color >> 16) & 0xFF
        green := (color >> 8) & 0xFF
        blue := color & 0xFF

        ToolTip("Position: " x ", " y "`n"
              . "Color: " Format("0x{:06X}", color) "`n"
              . "RGB: " red ", " green ", " blue)
    }

    /**
     * Pick current color
     */
    static PickColor() {
        if !this.isActive
            return

        MouseGetPos(&x, &y)
        color := PixelGetColor(x, y)

        this.pickedColors.Push({
            x: x,
            y: y,
            color: color
        })

        SoundBeep(1000, 100)

        MsgBox("Color Picked!`n`n"
             . "Position: " x ", " y "`n"
             . "Color: " Format("0x{:06X}", color) "`n`n"
             . "Total picked: " this.pickedColors.Length,
             "Picked", "Iconi T2")
    }

    /**
     * Stop color picker
     */
    static Stop() {
        if !this.isActive
            return

        this.isActive := false
        SetTimer(() => this.TrackMouse(), 0)
        ToolTip()

        ; Remove hotkeys
        Hotkey("~LButton", "Off")
        Hotkey("Esc", "Off")

        this.ShowPicked()
    }

    /**
     * Show all picked colors
     */
    static ShowPicked() {
        if this.pickedColors.Length = 0 {
            MsgBox("No colors picked", "Info", "Iconi")
            return
        }

        output := "PICKED COLORS:`n`n"

        for index, item in this.pickedColors {
            output .= index ". " Format("0x{:06X}", item.color)
            output .= " at (" item.x ", " item.y ")`n"
        }

        MsgBox(output, "Picked Colors", "Iconi")
    }

    /**
     * Clear picked colors
     */
    static Clear() {
        this.pickedColors := []
        MsgBox("Picked colors cleared", "Cleared", "Iconi T1")
    }
}

; Uncomment to start color picker:
; ColorPicker.Start()

; ============================================================
; Example 6: Wait for Pixel Color
; ============================================================

/**
 * Wait for a specific color to appear or disappear
 */
class PixelWaiter {
    /**
     * Wait for color to appear at position
     *
     * @param {Integer} x - X coordinate
     * @param {Integer} y - Y coordinate
     * @param {Integer} color - Target color
     * @param {Integer} timeoutSec - Timeout in seconds (0 = infinite)
     * @returns {Boolean} - True if found, false if timeout
     */
    static WaitForColor(x, y, color, timeoutSec := 10) {
        MsgBox("Waiting for color to appear:`n`n"
             . "Position: " x ", " y "`n"
             . "Color: " Format("0x{:06X}", color) "`n"
             . "Timeout: " (timeoutSec > 0 ? timeoutSec " sec" : "None"),
             "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            currentColor := PixelGetColor(x, y)

            if currentColor = color {
                elapsed := (A_TickCount - startTime) / 1000
                MsgBox("Color appeared!`n`n"
                     . "Time elapsed: " Round(elapsed, 1) " seconds",
                     "Found", "Iconi")
                return true
            }

            ; Check timeout
            if timeoutSec > 0 and (A_TickCount - startTime) > timeout {
                MsgBox("Timeout reached`n`n"
                     . "Color did not appear within " timeoutSec " seconds",
                     "Timeout", "Icon!")
                return false
            }

            Sleep(100)  ; Check every 100ms
        }
    }

    /**
     * Wait for color to disappear from position
     *
     * @param {Integer} x - X coordinate
     * @param {Integer} y - Y coordinate
     * @param {Integer} color - Color to wait for disappearance
     * @param {Integer} timeoutSec - Timeout in seconds
     */
    static WaitForColorChange(x, y, color, timeoutSec := 10) {
        MsgBox("Waiting for color to change:`n`n"
             . "Position: " x ", " y "`n"
             . "Current: " Format("0x{:06X}", color) "`n"
             . "Timeout: " timeoutSec " sec",
             "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            currentColor := PixelGetColor(x, y)

            if currentColor != color {
                elapsed := (A_TickCount - startTime) / 1000
                MsgBox("Color changed!`n`n"
                     . "New color: " Format("0x{:06X}", currentColor) "`n"
                     . "Time elapsed: " Round(elapsed, 1) " seconds",
                     "Changed", "Iconi")
                return true
            }

            if timeoutSec > 0 and (A_TickCount - startTime) > timeout {
                MsgBox("Timeout - color did not change", "Timeout", "Icon!")
                return false
            }

            Sleep(100)
        }
    }
}

; Test pixel waiter
; Get color at position 100, 100 first
; testColor := PixelGetColor(100, 100)
; PixelWaiter.WaitForColor(100, 100, testColor, 5)
; PixelWaiter.WaitForColorChange(100, 100, testColor, 5)

; ============================================================
; Example 7: Practical Applications
; ============================================================

/**
 * Practical pixel detection examples
 */
class PracticalPixelExamples {
    /**
     * Detect if button is enabled/disabled by color
     *
     * @param {Integer} x - Button center X
     * @param {Integer} y - Button center Y
     * @param {Integer} enabledColor - Color when enabled
     */
    static IsButtonEnabled(x, y, enabledColor) {
        currentColor := PixelGetColor(x, y)
        isEnabled := currentColor = enabledColor

        MsgBox("Button Status:`n`n"
             . "Position: " x ", " y "`n"
             . "Current Color: " Format("0x{:06X}", currentColor) "`n"
             . "Enabled Color: " Format("0x{:06X}", enabledColor) "`n"
             . "Status: " (isEnabled ? "ENABLED" : "DISABLED"),
             "Button Check", "Iconi")

        return isEnabled
    }

    /**
     * Wait for loading spinner to disappear
     *
     * @param {Integer} x - Spinner X position
     * @param {Integer} y - Spinner Y position
     * @param {Integer} spinnerColor - Color of spinner
     * @param {Integer} timeoutSec - Maximum wait time
     */
    static WaitForLoadingComplete(x, y, spinnerColor, timeoutSec := 30) {
        MsgBox("Waiting for loading to complete...",
               "Loading", "T1")

        return PixelWaiter.WaitForColorChange(x, y, spinnerColor, timeoutSec)
    }

    /**
     * Detect status indicator color
     *
     * @param {Integer} x - Indicator X position
     * @param {Integer} y - Indicator Y position
     */
    static GetStatusByColor(x, y) {
        color := PixelGetColor(x, y)

        ; Common status colors
        status := ""
        if color = 0x00FF00
            status := "Online/Active (Green)"
        else if color = 0xFF0000
            status := "Offline/Error (Red)"
        else if color = 0xFFFF00
            status := "Busy/Warning (Yellow)"
        else if color = 0x808080
            status := "Idle/Disabled (Gray)"
        else
            status := "Unknown (" Format("0x{:06X}", color) ")"

        MsgBox("Status Indicator:`n`n"
             . "Position: " x ", " y "`n"
             . "Color: " Format("0x{:06X}", color) "`n"
             . "Status: " status,
             "Status", "Iconi")

        return status
    }
}

; Test practical examples
; PracticalPixelExamples.IsButtonEnabled(100, 100, 0x0078D7)
; PracticalPixelExamples.GetStatusByColor(50, 50)

; ============================================================
; Reference Information
; ============================================================

info := "
(
PIXEL FUNCTIONS REFERENCE:

PixelGetColor():
  Syntax: Color := PixelGetColor(X, Y [, Mode])
  Returns: Color in 0xRRGGBB format
  Mode: 'Alt' for alternate method, 'Slow' for slow method

PixelSearch():
  Syntax: Found := PixelSearch(&X, &Y, X1, Y1, X2, Y2, Color [, Variation])
  Returns: 1 if found, 0 if not found
  X, Y: Output coordinates (ByRef)
  X1, Y1: Top-left corner of search region
  X2, Y2: Bottom-right corner of search region
  Color: Target color (0xRRGGBB)
  Variation: Tolerance (0-255, default 0)

Color Format:
  0xRRGGBB where:
    RR = Red (00-FF)
    GG = Green (00-FF)
    BB = Blue (00-FF)
  Example: 0xFF0000 = Red

Variation Parameter:
  0   = Exact match only
  10  = Very close match
  30  = Close match
  50  = Similar colors
  100 = Broad match
  255 = Maximum tolerance

Common Colors:
  0x000000 = Black
  0xFFFFFF = White
  0xFF0000 = Red
  0x00FF00 = Green
  0x0000FF = Blue
  0xFFFF00 = Yellow
  0xFF00FF = Magenta
  0x00FFFF = Cyan
  0x808080 = Gray

Performance Tips:
  ✓ Use smaller search regions
  ✓ Use Fast mode when possible
  ✓ Minimize variation when not needed
  ✓ Cache colors instead of repeated calls
  ✓ Use PixelGetColor for single pixels
  ✓ Use PixelSearch for finding pixels

Common Uses:
  • Detect UI state changes
  • Wait for loading completion
  • Find buttons/controls
  • Screen automation
  • Game automation
  • Status monitoring
  • Color-based triggers

Best Practices:
  1. Always validate coordinates
  2. Use Try/Catch for reliability
  3. Account for screen scaling
  4. Test on different displays
  5. Use variation for robustness
  6. Provide timeout limits
  7. Handle color variations

Limitations:
  • Screen scaling affects coordinates
  • Different displays may have different colors
  • DPI awareness can cause issues
  • Some apps block pixel reading
  • Performance impact on large regions
)"

MsgBox(info, "Pixel Functions Reference", "Icon!")
