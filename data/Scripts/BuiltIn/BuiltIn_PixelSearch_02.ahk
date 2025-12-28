#Requires AutoHotkey v2.0

/**
 * BuiltIn_PixelSearch_02.ahk
 * 
 * DESCRIPTION:
 * Advanced PixelSearch usage for screen automation, game bots, and complex detection
 * 
 * FEATURES:
 * - Multi-pixel pattern recognition
 * - Screen change detection
 * - Game automation helpers
 * - Color tracking and monitoring
 * - Advanced search strategies
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/PixelSearch.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Advanced PixelSearch patterns
 * - Multi-region scanning
 * - Color pattern matching
 * - Real-time monitoring
 * - Game bot techniques
 * 
 * LEARNING POINTS:
 * 1. Combine multiple pixel checks for pattern recognition
 * 2. Use pixel monitoring for screen change detection
 * 3. Implement game automation with pixel searches
 * 4. Create robust color-based triggers
 * 5. Build intelligent screen scanners
 * 6. Handle dynamic screen content
 */

; ============================================================
; Example 1: Multi-Pixel Pattern Matching
; ============================================================

/**
 * Match multiple pixel patterns for robust detection
 */
class PixelPattern {
    /**
     * Check if a specific pattern of colors exists
     * 
     * @param {Array} pattern - Array of {x, y, color} objects
     * @param {Integer} variation - Color tolerance
     * @returns {Boolean} - True if all pixels match
     */
    static MatchPattern(pattern, variation := 10) {
        matches := 0
        total := pattern.Length

        for point in pattern {
            actualColor := PixelGetColor(point.x, point.y)

            ; Check if colors match within variation
            if this.ColorsMatch(actualColor, point.color, variation) {
                matches++
            }
        }

        matchRate := Round((matches / total) * 100, 1)

        MsgBox("Pattern Match Results:`n`n"
            . "Total points: " total "`n"
            . "Matches: " matches "`n"
            . "Match rate: " matchRate "%`n"
            . "Variation: " variation,
            "Pattern Match", "Iconi")

        return matches = total
    }

    /**
     * Check if two colors match within variation
     * 
     * @param {Integer} color1 - First color
     * @param {Integer} color2 - Second color
     * @param {Integer} variation - Tolerance
     * @returns {Boolean} - True if colors match
     */
    static ColorsMatch(color1, color2, variation) {
        ; Extract RGB components
        r1 := (color1 >> 16) & 0xFF
        g1 := (color1 >> 8) & 0xFF
        b1 := color1 & 0xFF

        r2 := (color2 >> 16) & 0xFF
        g2 := (color2 >> 8) & 0xFF
        b2 := color2 & 0xFF

        ; Check if each component is within variation
        return (Abs(r1 - r2) <= variation and
            Abs(g1 - g2) <= variation and
            Abs(b1 - b2) <= variation)
    }

    /**
     * Find a button by checking corner pixels
     * 
     * @param {Integer} x - Button top-left X
     * @param {Integer} y - Button top-left Y
     * @param {Integer} width - Button width
     * @param {Integer} height - Button height
     * @param {Integer} borderColor - Expected border color
     */
    static FindButton(x, y, width, height, borderColor) {
        ; Check corners for border color
        pattern := [{
            x: x, y: y, color: borderColor },                      ; Top-left
            {
                x: x + width, y: y, color: borderColor },              ; Top-right
            {
                x: x, y: y + height, color: borderColor },             ; Bottom-left
            {
                x: x + width, y: y + height, color: borderColor }      ; Bottom-right
        ]

        isButton := this.MatchPattern(pattern, 20)

        if isButton {
            MsgBox("Button detected at: " x ", " y,
                "Button Found", "Iconi T2")
        } else {
            MsgBox("No button found at: " x ", " y,
                "Not Found", "Icon! T2")
        }

        return isButton
    }

    /**
     * Detect UI element by sampling pattern
     */
    static DetectUIElement(x, y, width, height, sampleColor) {
        ; Sample center and mid-points
        pattern := [{
            x: x + width // 2, y: y + height // 2, color: sampleColor },  ; Center
            {
                x: x + width // 4, y: y + height // 2, color: sampleColor },  ; Left-mid
            {
                x: x + 3 * width // 4, y: y + height // 2, color: sampleColor } ; Right-mid
        ]

        return this.MatchPattern(pattern, 30)
    }
}

; Test pattern matching
; Define a button pattern (example coordinates)
; buttonPattern := [
;     {x: 100, y: 100, color: 0x0078D7},
;     {x: 200, y: 100, color: 0x0078D7},
;     {x: 100, y: 130, color: 0x0078D7},
;     {x: 200, y: 130, color: 0x0078D7}
; ]
; PixelPattern.MatchPattern(buttonPattern, 10)

; ============================================================
; Example 2: Screen Change Detector
; ============================================================

/**
 * Monitor screen regions for changes
 */
class ScreenChangeDetector {
    /**
     * Initialize detector
     */
    __New() {
        this.isMonitoring := false
        this.regions := []
        this.lastColors := Map()
    }

    /**
     * Add region to monitor
     * 
     * @param {String} name - Region name
     * @param {Integer} x - X coordinate
     * @param {Integer} y - Y coordinate
     */
    AddRegion(name, x, y) {
        this.regions.Push({ name: name, x: x, y: y })
        this.lastColors[name] := PixelGetColor(x, y)

        MsgBox("Region added:`n`n"
            . "Name: " name "`n"
            . "Position: " x ", " y "`n"
            . "Initial color: " Format("0x{:06X}", this.lastColors[name]),
            "Region Added", "Iconi T2")
    }

    /**
     * Start monitoring for changes
     */
    StartMonitoring() {
        if this.isMonitoring {
            MsgBox("Already monitoring", "Info", "Iconi T1")
            return
        }

        this.isMonitoring := true

        MsgBox("Screen change monitoring started`n`n"
            . "Regions: " this.regions.Length "`n"
            . "Check interval: 500ms",
            "Monitoring Active", "Iconi")

        SetTimer(() => this.CheckRegions(), 500)
    }

    /**
     * Stop monitoring
     */
    StopMonitoring() {
        this.isMonitoring := false
        SetTimer(() => this.CheckRegions(), 0)

        MsgBox("Monitoring stopped", "Monitor", "Iconi T2")
    }

    /**
     * Check all regions for changes
     */
    CheckRegions() {
        if !this.isMonitoring
            return

        for region in this.regions {
            currentColor := PixelGetColor(region.x, region.y)
            lastColor := this.lastColors[region.name]

            if currentColor != lastColor {
                this.OnColorChange(region.name, region.x, region.y,
                    lastColor, currentColor)

                this.lastColors[region.name] := currentColor
            }
        }
    }

    /**
     * Called when color changes
     */
    OnColorChange(name, x, y, oldColor, newColor) {
        SoundBeep(1000, 100)

        ToolTip("Change Detected!`n"
            . "Region: " name "`n"
            . "Old: " Format("0x{:06X}", oldColor) "`n"
            . "New: " Format("0x{:06X}", newColor))

        SetTimer(() => ToolTip(), -3000)
    }

    /**
     * Wait for any region to change
     * 
     * @param {Integer} timeoutSec - Timeout in seconds
     */
    WaitForAnyChange(timeoutSec := 30) {
        MsgBox("Waiting for any region to change...",
            "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            for region in this.regions {
                currentColor := PixelGetColor(region.x, region.y)
                lastColor := this.lastColors[region.name]

                if currentColor != lastColor {
                    MsgBox("Change detected in: " region.name,
                        "Changed", "Iconi")
                    return region.name
                }
            }

            if (A_TickCount - startTime) > timeout {
                MsgBox("Timeout - no changes detected", "Timeout", "Icon!")
                return ""
            }

            Sleep(100)
        }
    }
}

; Test screen change detector
; detector := ScreenChangeDetector()
; detector.AddRegion("TopLeft", 10, 10)
; detector.AddRegion("TopRight", A_ScreenWidth - 10, 10)
; detector.StartMonitoring()

; ============================================================
; Example 3: Game Automation Helper
; ============================================================

/**
 * Helper functions for game automation
 */
class GameBot {
    /**
     * Find and click on health potion (by color)
     * 
     * @param {Integer} x1 - Inventory left
     * @param {Integer} y1 - Inventory top
     * @param {Integer} x2 - Inventory right
     * @param {Integer} y2 - Inventory bottom
     * @param {Integer} potionColor - Potion color (e.g., red)
     */
    static UseHealthPotion(x1, y1, x2, y2, potionColor := 0xFF0000) {
        ; Search for red potion
        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, potionColor, 30) {
            ; Click on potion
            Click(foundX, foundY)

            MsgBox("Health potion used!`n"
                . "Position: " foundX ", " foundY,
                "Game Bot", "Iconi T1")

            return true
        }

        MsgBox("No health potion found in inventory",
            "Game Bot", "Icon! T1")
        return false
    }

    /**
     * Wait for enemy to appear (by color)
     * 
     * @param {Integer} x1 - Search area left
     * @param {Integer} y1 - Search area top
     * @param {Integer} x2 - Search area right
     * @param {Integer} y2 - Search area bottom
     * @param {Integer} enemyColor - Enemy indicator color
     * @param {Integer} timeoutSec - Max wait time
     */
    static WaitForEnemy(x1, y1, x2, y2, enemyColor, timeoutSec := 10) {
        MsgBox("Waiting for enemy to appear...", "Game Bot", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, enemyColor, 20) {
                MsgBox("Enemy detected at: " foundX ", " foundY,
                    "Enemy Found", "Icon! T1")
                return { found: true, x: foundX, y: foundY }
            }

            if (A_TickCount - startTime) > timeout {
                MsgBox("No enemy appeared", "Timeout", "T1")
                return { found: false, x: 0, y: 0 }
            }

            Sleep(100)
        }
    }

    /**
     * Check if player is low health (by HP bar color)
     * 
     * @param {Integer} hpBarX - HP bar X position
     * @param {Integer} hpBarY - HP bar Y position
     * @param {Integer} lowHPColor - Color indicating low health
     */
    static IsLowHealth(hpBarX, hpBarY, lowHPColor := 0xFF0000) {
        currentColor := PixelGetColor(hpBarX, hpBarY)
        isLow := currentColor = lowHPColor

        if isLow {
            SoundBeep(500, 200)  ; Warning beep
            ToolTip("LOW HEALTH!")
            SetTimer(() => ToolTip(), -2000)
        }

        return isLow
    }

    /**
     * Auto-farm loop (simplified example)
     */
    static AutoFarm(farmX, farmY, resourceColor) {
        MsgBox("Starting auto-farm...`n`n"
            . "Farm position: " farmX ", " farmY "`n"
            . "Resource color: " Format("0x{:06X}", resourceColor) "`n`n"
            . "Press ESC to stop",
            "Auto-Farm", "T2")

        Loop 10 {  ; Farm 10 times
            ; Check if resource is available
            color := PixelGetColor(farmX, farmY)

            if this.ColorsMatch(color, resourceColor, 30) {
                Click(farmX, farmY)
                ToolTip("Farming... (" A_Index " / 10)")
                Sleep(2000)  ; Wait for respawn
            } else {
                ToolTip("Waiting for resource...")
                Sleep(500)
            }

            ; Check for ESC key
            if GetKeyState("Esc", "P")
                break
        }

        ToolTip()
        MsgBox("Auto-farm complete!", "Done", "Iconi")
    }

    /**
     * Helper to check color match
     */
    static ColorsMatch(color1, color2, variation) {
        return PixelPattern.ColorsMatch(color1, color2, variation)
    }

    /**
     * Find nearest target by color
     * 
     * @param {Integer} centerX - Center X (player position)
     * @param {Integer} centerY - Center Y (player position)
     * @param {Integer} searchRadius - Search radius in pixels
     * @param {Integer} targetColor - Target color
     */
    static FindNearestTarget(centerX, centerY, searchRadius, targetColor) {
        x1 := Max(0, centerX - searchRadius)
        y1 := Max(0, centerY - searchRadius)
        x2 := Min(A_ScreenWidth, centerX + searchRadius)
        y2 := Min(A_ScreenHeight, centerY + searchRadius)

        closestDist := 999999
        closestX := 0
        closestY := 0
        found := false

        ; Search in expanding rings for nearest
        step := 10
        y := y1
        while y <= y2 {
            x := x1
            while x <= x2 {
                color := PixelGetColor(x, y)

                if this.ColorsMatch(color, targetColor, 20) {
                    dist := Sqrt((x - centerX) ** 2 + (y - centerY) ** 2)

                    if dist < closestDist {
                        closestDist := dist
                        closestX := x
                        closestY := y
                        found := true
                    }
                }

                x += step
            }
            y += step
        }

        if found {
            MsgBox("Nearest target found:`n`n"
                . "Position: " closestX ", " closestY "`n"
                . "Distance: " Round(closestDist) " pixels",
                "Target Found", "Iconi")

            return { found: true, x: closestX, y: closestY, distance: closestDist }
        }

        MsgBox("No targets found in search radius", "Not Found", "Icon!")
        return { found: false, x: 0, y: 0, distance: 0 }
    }
}

; Test game bot functions
; GameBot.UseHealthPotion(500, 500, 600, 600, 0xFF0000)
; GameBot.WaitForEnemy(0, 0, 800, 600, 0xFF0000, 5)
; GameBot.IsLowHealth(50, 50, 0xFF0000)
; GameBot.FindNearestTarget(400, 300, 200, 0xFF0000)

; ============================================================
; Example 4: Smart Click Finder
; ============================================================

/**
 * Find clickable elements by color patterns
 */
class SmartClickFinder {
    /**
     * Find all instances of a color in region
     * 
     * @param {Integer} x1 - Search left
     * @param {Integer} y1 - Search top
     * @param {Integer} x2 - Search right
     * @param {Integer} y2 - Search bottom
     * @param {Integer} color - Target color
     * @param {Integer} variation - Color tolerance
     * @returns {Array} - Array of {x, y} coordinates
     */
    static FindAllColors(x1, y1, x2, y2, color, variation := 10) {
        found := []
        step := 5  ; Search every 5 pixels

        MsgBox("Searching for all instances...`n"
            . "This may take a moment",
            "Searching", "T1")

        y := y1
        while y <= y2 {
            x := x1
            while x <= x2 {
                currentColor := PixelGetColor(x, y)

                if PixelPattern.ColorsMatch(currentColor, color, variation) {
                    ; Avoid duplicates close together
                    isDuplicate := false
                    for item in found {
                        if Abs(item.x - x) < 10 and Abs(item.y - y) < 10 {
                            isDuplicate := true
                            break
                        }
                    }

                    if !isDuplicate
                        found.Push({ x: x, y: y })
                }

                x += step
            }
            y += step
        }

        MsgBox("Search complete!`n`n"
            . "Found " found.Length " instances",
            "Results", "Iconi")

        return found
    }

    /**
     * Click on all found instances
     * 
     * @param {Array} instances - Array from FindAllColors
     * @param {Integer} delayMs - Delay between clicks
     */
    static ClickAll(instances, delayMs := 500) {
        if instances.Length = 0 {
            MsgBox("No instances to click", "Info", "Iconi T1")
            return
        }

        MsgBox("Clicking " instances.Length " instances`n"
            . "Delay: " delayMs "ms between clicks",
            "Clicking", "T1")

        for index, item in instances {
            Click(item.x, item.y)
            ToolTip("Clicked " index " / " instances.Length)
            Sleep(delayMs)
        }

        ToolTip()
        MsgBox("All clicks complete!", "Done", "Iconi")
    }

    /**
     * Find and click nearest instance
     * 
     * @param {Integer} x1 - Search left
     * @param {Integer} y1 - Search top
     * @param {Integer} x2 - Search right
     * @param {Integer} y2 - Search bottom
     * @param {Integer} color - Target color
     */
    static ClickNearest(x1, y1, x2, y2, color) {
        if PixelSearch(&foundX, &foundY, x1, y1, x2, y2, color, 20) {
            Click(foundX, foundY)

            MsgBox("Clicked at: " foundX ", " foundY,
                "Clicked", "Iconi T1")
            return true
        }

        MsgBox("Target color not found", "Not Found", "Icon! T1")
        return false
    }
}

; Test smart click finder
; instances := SmartClickFinder.FindAllColors(0, 0, 500, 500, 0x0078D7, 20)
; SmartClickFinder.ClickAll(instances, 500)

; ============================================================
; Example 5: Color Tracker
; ============================================================

/**
 * Track moving colors on screen
 */
class ColorTracker {
    /**
     * Track a color's movement
     * 
     * @param {Integer} color - Color to track
     * @param {Integer} durationSec - Tracking duration
     */
    static TrackColor(color, durationSec := 10) {
        positions := []
        startTime := A_TickCount
        timeout := durationSec * 1000

        MsgBox("Tracking color: " Format("0x{:06X}", color) "`n"
            . "Duration: " durationSec " seconds`n`n"
            . "Move the colored object around!",
            "Tracking", "T2")

        Loop {
            ; Search full screen
            if PixelSearch(&x, &y, 0, 0, A_ScreenWidth, A_ScreenHeight,
                color, 30) {
                positions.Push({
                    time: A_TickCount - startTime,
                    x: x,
                    y: y
                })

                ToolTip("Tracking: " x ", " y)
            }

            if (A_TickCount - startTime) > timeout
                break

            Sleep(100)
        }

        ToolTip()
        this.ShowTrackingResults(positions)
    }

    /**
     * Show tracking results
     */
    static ShowTrackingResults(positions) {
        if positions.Length = 0 {
            MsgBox("No tracking data", "Results", "Icon!")
            return
        }

        ; Calculate statistics
        totalDist := 0
        for index, pos in positions {
            if index > 1 {
                prev := positions[index - 1]
                dist := Sqrt((pos.x - prev.x) ** 2 + (pos.y - prev.y) ** 2)
                totalDist += dist
            }
        }

        avgSpeed := totalDist / (positions[positions.Length].time / 1000)

        output := "TRACKING RESULTS:`n`n"
        output .= "Data points: " positions.Length "`n"
        output .= "Total distance: " Round(totalDist) " px`n"
        output .= "Avg speed: " Round(avgSpeed, 1) " px/s`n`n"
        output .= "First 5 positions:`n"

        Loop Min(5, positions.Length) {
            pos := positions[A_Index]
            output .= A_Index ". (" pos.x ", " pos.y ")`n"
        }

        MsgBox(output, "Tracking Results", "Iconi")
    }
}

; Test color tracker
; ColorTracker.TrackColor(0xFF0000, 10)  ; Track red color for 10 seconds

; ============================================================
; Example 6: Screen Region Analyzer
; ============================================================

/**
 * Analyze screen regions for color distribution
 */
class RegionAnalyzer {
    /**
     * Analyze color distribution in region
     * 
     * @param {Integer} x1 - Left
     * @param {Integer} y1 - Top
     * @param {Integer} x2 - Right
     * @param {Integer} y2 - Bottom
     * @param {Integer} sampleRate - Pixel sampling rate
     */
    static AnalyzeRegion(x1, y1, x2, y2, sampleRate := 10) {
        colors := Map()
        totalSamples := 0

        MsgBox("Analyzing region...`n"
            . "Sample rate: every " sampleRate " pixels",
            "Analyzing", "T1")

        y := y1
        while y <= y2 {
            x := x1
            while x <= x2 {
                color := PixelGetColor(x, y)

                if colors.Has(color)
                    colors[color] := colors[color] + 1
                else
                    colors[color] := 1

                totalSamples++
                x += sampleRate
            }
            y += sampleRate
        }

        this.ShowAnalysis(colors, totalSamples)
    }

    /**
     * Show analysis results
     */
    static ShowAnalysis(colors, totalSamples) {
        output := "REGION ANALYSIS:`n`n"
        output .= "Total samples: " totalSamples "`n"
        output .= "Unique colors: " colors.Count "`n`n"
        output .= "Top 10 colors:`n"

        ; Convert to array and sort
        colorArray := []
        for color, count in colors {
            colorArray.Push({ color: color, count: count })
        }

        ; Sort by count
        colorArray := this.SortColors(colorArray)

        ; Show top 10
        Loop Min(10, colorArray.Length) {
            item := colorArray[A_Index]
            percent := Round((item.count / totalSamples) * 100, 1)
            output .= A_Index ". " Format("0x{:06X}", item.color)
            output .= " - " percent "%`n"
        }

        MsgBox(output, "Analysis Results", "Iconi")
    }

    /**
     * Sort colors by count
     */
    static SortColors(arr) {
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
     * Check if region is uniform color
     */
    static IsUniformColor(x1, y1, x2, y2, threshold := 90) {
        colors := Map()
        totalSamples := 0

        y := y1
        while y <= y2 {
            x := x1
            while x <= x2 {
                color := PixelGetColor(x, y)

                if colors.Has(color)
                    colors[color] := colors[color] + 1
                else
                    colors[color] := 1

                totalSamples++
                x += 10
            }
            y += 10
        }

        ; Find most common color
        maxCount := 0
        maxColor := 0
        for color, count in colors {
            if count > maxCount {
                maxCount := count
                maxColor := color
            }
        }

        uniformity := (maxCount / totalSamples) * 100

        MsgBox("Uniformity Check:`n`n"
            . "Most common color: " Format("0x{:06X}", maxColor) "`n"
            . "Uniformity: " Round(uniformity, 1) "%`n"
            . "Threshold: " threshold "%`n"
            . "Result: " (uniformity >= threshold ? "UNIFORM" : "VARIED"),
            "Uniformity", "Iconi")

        return uniformity >= threshold
    }
}

; Test region analyzer
; RegionAnalyzer.AnalyzeRegion(0, 0, 300, 300, 15)
; RegionAnalyzer.IsUniformColor(0, 0, 100, 100, 90)

; ============================================================
; Example 7: Automated Testing Helper
; ============================================================

/**
 * Helper for UI automation testing
 */
class UITestHelper {
    /**
     * Wait for button to become active
     */
    static WaitForButton(x, y, activeColor, timeoutSec := 10) {
        MsgBox("Waiting for button to become active...",
            "Waiting", "T1")

        startTime := A_TickCount
        timeout := timeoutSec * 1000

        Loop {
            color := PixelGetColor(x, y)

            if PixelPattern.ColorsMatch(color, activeColor, 20) {
                MsgBox("Button is active!", "Ready", "Iconi T1")
                return true
            }

            if (A_TickCount - startTime) > timeout {
                MsgBox("Timeout waiting for button", "Timeout", "Icon!")
                return false
            }

            Sleep(100)
        }
    }

    /**
     * Verify UI state by color
     */
    static VerifyState(checkPoints) {
        allPassed := true
        results := []

        for check in checkPoints {
            color := PixelGetColor(check.x, check.y)
            passed := PixelPattern.ColorsMatch(color, check.expectedColor, check.variation ?? 10)

            results.Push({
                name: check.name,
                passed: passed,
                expected: check.expectedColor,
                actual: color
            })

            if !passed
                allPassed := false
        }

        this.ShowTestResults(results, allPassed)
        return allPassed
    }

    /**
     * Show test results
     */
    static ShowTestResults(results, allPassed) {
        output := "UI TEST RESULTS:`n`n"
        output .= "Overall: " (allPassed ? "PASS" : "FAIL") "`n`n"

        for result in results {
            status := result.passed ? "✓ PASS" : "✗ FAIL"
            output .= status " - " result.name "`n"
            if !result.passed {
                output .= "  Expected: " Format("0x{:06X}", result.expected) "`n"
                output .= "  Actual: " Format("0x{:06X}", result.actual) "`n"
            }
        }

        icon := allPassed ? "Iconi" : "Iconx"
        MsgBox(output, "Test Results", icon)
    }
}

; Test UI helper
; checkPoints := [
;     {name: "Button1", x: 100, y: 100, expectedColor: 0x0078D7, variation: 20},
;     {name: "Button2", x: 200, y: 100, expectedColor: 0x00FF00, variation: 15}
; ]
; UITestHelper.VerifyState(checkPoints)

; ============================================================
; Reference Information
; ============================================================

info := "
                        (
                        ADVANCED PIXELSEARCH TECHNIQUES:

                        Multi-Pixel Patterns:
                        • Check multiple pixels for shapes
                        • Verify UI elements by corners
                        • Pattern matching for reliability
                        • Fuzzy matching with variation

                        Screen Change Detection:
                        • Monitor specific regions
                        • Real-time change alerts
                        • Wait for UI updates
                        • Trigger on color changes

                        Game Automation:
                        • Find items by color
                        • Track health/resources
                        • Auto-farming routines
                        • Enemy detection
                        • Nearest target finding

                        Smart Clicking:
                        • Find all color instances
                        • Click multiple targets
                        • Sequential clicking
                        • Distance-based targeting

                        Color Tracking:
                        • Track moving objects
                        • Calculate movement speed
                        • Path recording
                        • Motion analysis

                        Region Analysis:
                        • Color distribution
                        • Uniformity checking
                        • Dominant color detection
                        • Statistical analysis

                        UI Testing:
                        • State verification
                        • Button readiness
                        • Visual regression testing
                        • Automated checks

                        Best Practices:
                        ✓ Use variation for robustness
                        ✓ Minimize search regions
                        ✓ Add appropriate delays
                        ✓ Handle edge cases
                        ✓ Provide timeouts
                        ✓ Test on different screens
                        ✓ Account for DPI scaling

                        Performance Tips:
                        • Reduce search area size
                        • Increase step size for faster scans
                        • Use Fast mode when applicable
                        • Cache results when possible
                        • Minimize repeated searches

                        Game Bot Ethics:
                        ⚠ Check game ToS before automating
                        ⚠ Some games prohibit bots
                        ⚠ Use responsibly
                        ⚠ Consider fairness to other players
                        ⚠ Educational purposes only

                        Common Patterns:
                        • Health check → Color match
                        • Wait for ready → Color appear
                        • Find target → Region search
                        • Auto-click → Find + Click
                        • State verify → Multi-pixel check
                        )"

MsgBox(info, "Advanced PixelSearch Reference", "Icon!")
