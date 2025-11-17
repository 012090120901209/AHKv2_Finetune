#Requires AutoHotkey v2.0
/**
 * BuiltIn_SysGet_02_Colors.ahk
 *
 * DESCRIPTION:
 * Demonstrates retrieving Windows system colors using SysGet. Shows how to
 * query system color scheme values for creating theme-aware applications
 * that match the Windows interface.
 *
 * FEATURES:
 * - Retrieving system color values
 * - Color scheme detection
 * - Theme-aware UI design
 * - System color constants
 * - Color conversion utilities
 * - Dynamic theme adaptation
 * - Custom color palette creation
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SysGet.htm (Color section)
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - SysGet with color indices
 * - RGB color value handling
 * - Hexadecimal color formatting
 * - Dynamic UI theming
 * - System color integration
 *
 * LEARNING POINTS:
 * 1. System colors use COLOR_* constants
 * 2. Colors returned as BGR (not RGB) values
 * 3. System colors change with Windows theme
 * 4. Important for accessible, native-looking UIs
 * 5. High contrast mode affects system colors
 * 6. Colors should be queried dynamically
 * 7. Convert BGR to RGB for standard use
 */

;=============================================================================
; EXAMPLE 1: Basic System Colors
;=============================================================================
; Displays common Windows system colors
Example1_BasicSystemColors() {
    ; Get common system colors (note: these are hypothetical indices for demo)
    ; In AHKv2, system colors are typically accessed differently
    ; This example demonstrates the concept

    info := "WINDOWS SYSTEM COLORS`n"
    info .= "=====================`n`n"

    info .= "NOTE: In AutoHotkey v2, system colors are typically`n"
    info .= "accessed through DllCall to GetSysColor().`n`n"

    info .= "Common System Colors:`n"
    info .= "  COLOR_WINDOW (5)       - Window background`n"
    info .= "  COLOR_WINDOWTEXT (8)   - Window text`n"
    info .= "  COLOR_ACTIVECAPTION (2)- Active caption bar`n"
    info .= "  COLOR_BTNFACE (15)     - Button face`n"
    info .= "  COLOR_HIGHLIGHT (13)   - Selected item background`n"
    info .= "  COLOR_HIGHLIGHTTEXT (14) - Selected item text`n`n"

    info .= "USAGE:`n"
    info .= "Use DllCall for GetSysColor:`n"
    info .= "color := DllCall('GetSysColor', 'Int', colorIndex)"

    MsgBox(info, "Example 1: Basic System Colors", "Icon!")
}

;=============================================================================
; EXAMPLE 2: System Color Palette Viewer
;=============================================================================
; Creates visual palette of all system colors
Example2_ColorPaletteViewer() {
    ; Define system color constants
    colors := [
        {Index: 0, Name: "COLOR_SCROLLBAR", Desc: "Scroll bar"},
        {Index: 1, Name: "COLOR_BACKGROUND", Desc: "Desktop background"},
        {Index: 2, Name: "COLOR_ACTIVECAPTION", Desc: "Active window caption"},
        {Index: 3, Name: "COLOR_INACTIVECAPTION", Desc: "Inactive window caption"},
        {Index: 4, Name: "COLOR_MENU", Desc: "Menu background"},
        {Index: 5, Name: "COLOR_WINDOW", Desc: "Window background"},
        {Index: 6, Name: "COLOR_WINDOWFRAME", Desc: "Window frame"},
        {Index: 7, Name: "COLOR_MENUTEXT", Desc: "Menu text"},
        {Index: 8, Name: "COLOR_WINDOWTEXT", Desc: "Window text"},
        {Index: 9, Name: "COLOR_CAPTIONTEXT", Desc: "Caption text"},
        {Index: 10, Name: "COLOR_ACTIVEBORDER", Desc: "Active window border"},
        {Index: 11, Name: "COLOR_INACTIVEBORDER", Desc: "Inactive window border"},
        {Index: 13, Name: "COLOR_HIGHLIGHT", Desc: "Selected item background"},
        {Index: 14, Name: "COLOR_HIGHLIGHTTEXT", Desc: "Selected item text"},
        {Index: 15, Name: "COLOR_BTNFACE", Desc: "Button face"},
        {Index: 16, Name: "COLOR_BTNSHADOW", Desc: "Button shadow"},
        {Index: 17, Name: "COLOR_GRAYTEXT", Desc: "Disabled text"},
        {Index: 18, Name: "COLOR_BTNTEXT", Desc: "Button text"}
    ]

    ; Create GUI
    g := Gui("+Resize", "System Color Palette Viewer")
    g.SetFont("s9", "Consolas")

    g.Add("Text", "w700", "Windows System Color Palette")

    ; Create ListView
    lv := g.Add("ListView", "w750 h400", ["Index", "Name", "Hex", "RGB", "Description"])

    ; Populate colors
    for colorDef in colors {
        ; Get system color using DllCall
        colorValue := DllCall("GetSysColor", "Int", colorDef.Index, "UInt")

        ; Convert BGR to RGB
        r := colorValue & 0xFF
        g := (colorValue >> 8) & 0xFF
        b := (colorValue >> 16) & 0xFF

        hexColor := Format("#{:02X}{:02X}{:02X}", r, g, b)
        rgbColor := r "," g "," b

        lv.Add("", colorDef.Index, colorDef.Name, hexColor, rgbColor, colorDef.Desc)
    }

    ; Auto-size columns
    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    g.Add("Button", "xm w120", "Refresh Colors").OnEvent("Click", (*) => (g.Destroy(), Example2_ColorPaletteViewer()))
    g.Add("Button", "x+10 w120", "Export Palette").OnEvent("Click", ExportPalette)

    g.Show()

    ExportPalette(*) {
        export := "Windows System Color Palette`n"
        export .= "Generated: " FormatTime(, "yyyy-MM-dd HH:mm:ss") "`n`n"

        for colorDef in colors {
            colorValue := DllCall("GetSysColor", "Int", colorDef.Index, "UInt")
            r := colorValue & 0xFF
            g := (colorValue >> 8) & 0xFF
            b := (colorValue >> 16) & 0xFF
            hexColor := Format("#{:02X}{:02X}{:02X}", r, g, b)

            export .= colorDef.Name " = " hexColor " (" r "," g "," b ")`n"
        }

        A_Clipboard := export
        MsgBox("Color palette exported to clipboard!", "Export", "Icon! T2")
    }
}

;=============================================================================
; EXAMPLE 3: Theme-Aware GUI Builder
;=============================================================================
; Creates GUI that adapts to system color theme
Example3_ThemeAwareGUI() {
    ; Get system colors
    windowBG := DllCall("GetSysColor", "Int", 5, "UInt")  ; COLOR_WINDOW
    buttonFace := DllCall("GetSysColor", "Int", 15, "UInt")  ; COLOR_BTNFACE
    highlightBG := DllCall("GetSysColor", "Int", 13, "UInt")  ; COLOR_HIGHLIGHT

    ; Convert BGR to hex
    ConvertBGRToHex(bgr) {
        r := bgr & 0xFF
        g := (bgr >> 8) & 0xFF
        b := (bgr >> 16) & 0xFF
        return Format("0x{:02X}{:02X}{:02X}", r, g, b)
    }

    ; Create theme-aware GUI
    g := Gui(, "Theme-Aware Application")
    g.SetFont("s10")
    g.BackColor := ConvertBGRToHex(windowBG)

    g.Add("Text", "w400", "This GUI adapts to your Windows theme!")

    g.Add("GroupBox", "xm w400 h150 Section", "System Colors in Use")

    g.Add("Text", "xs+10 ys+25", "Window Background:")
    g.Add("Progress", "x+10 w100 h20 Background" ConvertBGRToHex(windowBG) " c" ConvertBGRToHex(windowBG), 100)

    g.Add("Text", "xs+10", "Button Face:")
    g.Add("Progress", "x+68 w100 h20 Background" ConvertBGRToHex(buttonFace) " c" ConvertBGRToHex(buttonFace), 100)

    g.Add("Text", "xs+10", "Highlight:")
    g.Add("Progress", "x+95 w100 h20 Background" ConvertBGRToHex(highlightBG) " c" ConvertBGRToHex(highlightBG), 100)

    info := "`nThis window uses:`n"
    info .= "  • System window color for background`n"
    info .= "  • System button color for controls`n"
    info .= "  • System highlight for selections`n`n"
    info .= "Change your Windows theme and restart`n"
    info .= "this script to see it adapt!"

    g.Add("Text", "xm", info)

    g.Add("Button", "xm w190", "Refresh Theme").OnEvent("Click", (*) => (g.Destroy(), Example3_ThemeAwareGUI()))
    g.Add("Button", "x+20 w190", "Show Color Values").OnEvent("Click", ShowColors)

    g.Show()

    ShowColors(*) {
        info := "Current Theme Colors:`n`n"
        info .= "Window BG: " ConvertBGRToHex(windowBG) "`n"
        info .= "Button Face: " ConvertBGRToHex(buttonFace) "`n"
        info .= "Highlight: " ConvertBGRToHex(highlightBG)

        MsgBox(info, "Theme Colors", "Icon!")
    }
}

;=============================================================================
; EXAMPLE 4: Color Contrast Checker
;=============================================================================
; Checks contrast ratios of system colors for accessibility
Example4_ContrastChecker() {
    ; Create GUI
    g := Gui(, "System Color Contrast Checker")
    g.SetFont("s10")

    g.Add("Text", "w450", "Accessibility: Color Contrast Analysis")

    ; Common color pairs to check
    pairs := [
        {BG: 5, Text: 8, Name: "Window Text on Window BG"},
        {BG: 15, Text: 18, Name: "Button Text on Button Face"},
        {BG: 13, Text: 14, Name: "Highlight Text on Highlight BG"},
        {BG: 4, Text: 7, Name: "Menu Text on Menu BG"}
    ]

    lv := g.Add("ListView", "w450 h200", ["Color Pair", "Contrast", "WCAG Level", "Status"])

    for pair in pairs {
        bgColor := DllCall("GetSysColor", "Int", pair.BG, "UInt")
        textColor := DllCall("GetSysColor", "Int", pair.Text, "UInt")

        ; Calculate luminance (simplified)
        CalcLuminance(color) {
            r := (color & 0xFF) / 255
            g := ((color >> 8) & 0xFF) / 255
            b := ((color >> 16) & 0xFF) / 255

            r := r <= 0.03928 ? r / 12.92 : ((r + 0.055) / 1.055) ** 2.4
            g := g <= 0.03928 ? g / 12.92 : ((g + 0.055) / 1.055) ** 2.4
            b := b <= 0.03928 ? b / 12.92 : ((b + 0.055) / 1.055) ** 2.4

            return 0.2126 * r + 0.7152 * g + 0.0722 * b
        }

        lumBG := CalcLuminance(bgColor)
        lumText := CalcLuminance(textColor)

        ; Calculate contrast ratio
        lighter := Max(lumBG, lumText)
        darker := Min(lumBG, lumText)
        contrast := (lighter + 0.05) / (darker + 0.05)

        ; Determine WCAG level
        if contrast >= 7
            level := "AAA", status := "✓ Excellent"
        else if contrast >= 4.5
            level := "AA", status := "✓ Good"
        else if contrast >= 3
            level := "AA Large", status := "⚠ Fair"
        else
            level := "Fail", status := "✗ Poor"

        lv.Add("", pair.Name, Round(contrast, 2) ":1", level, status)
    }

    Loop lv.GetCount("Column")
        lv.ModifyCol(A_Index, "AutoHdr")

    info := "`nWCAG 2.0 Standards:`n"
    info .= "  AAA: 7:1 or higher (best)`n"
    info .= "  AA:  4.5:1 or higher (good)`n"
    info .= "  AA Large: 3:1 for large text"

    g.Add("Text", "xm", info)

    g.Show()
}

;=============================================================================
; EXAMPLE 5: Dark/Light Mode Detector
;=============================================================================
; Detects if system is using dark or light theme
Example5_DarkModeDetector() {
    ; Get window background color
    windowBG := DllCall("GetSysColor", "Int", 5, "UInt")

    ; Extract RGB components
    r := windowBG & 0xFF
    g := (windowBG >> 8) & 0xFF
    b := (windowBG >> 16) & 0xFF

    ; Calculate perceived brightness (0-255)
    brightness := Round((r * 0.299 + g * 0.587 + b * 0.114))

    ; Determine theme
    isDark := brightness < 128

    ; Create GUI
    g := Gui(, "Dark/Light Mode Detector")
    g.SetFont("s10")

    result := "WINDOWS THEME DETECTION`n"
    result .= "=======================`n`n"

    result .= "Window Background Color:`n"
    result .= "  RGB: " r "," g "," b "`n"
    result .= "  Hex: " Format("#{:02X}{:02X}{:02X}", r, g, b) "`n"
    result .= "  Brightness: " brightness " / 255`n`n"

    result .= "DETECTED THEME:`n"
    result .= "  " (isDark ? "🌙 DARK MODE" : "☀ LIGHT MODE") "`n`n"

    result .= "RECOMMENDATIONS:`n"
    if isDark {
        result .= "  • Use light text on dark backgrounds`n"
        result .= "  • Reduce bright color intensity`n"
        result .= "  • Use subtle borders and accents"
    } else {
        result .= "  • Use dark text on light backgrounds`n"
        result .= "  • Standard color intensity is fine`n"
        result .= "  • Bold borders work well"
    }

    g.Add("Text", "w400", result)

    ; Demonstrate theme-appropriate colors
    g.Add("Text", "xm Section", "Theme-Appropriate Example:")

    if isDark {
        g.BackColor := "0x1E1E1E"
        exampleBox := g.Add("Text", "xs w400 h60 +Border Background0x2D2D2D c0xE0E0E0 +Center",
                            "Dark mode example text`nBackground: #2D2D2D`nText: #E0E0E0")
    } else {
        g.BackColor := "0xFFFFFF"
        exampleBox := g.Add("Text", "xs w400 h60 +Border Background0xF5F5F5 c0x000000 +Center",
                            "Light mode example text`nBackground: #F5F5F5`nText: #000000")
    }

    g.Show()
}

;=============================================================================
; EXAMPLE 6: Custom Theme Generator
;=============================================================================
; Generates custom color scheme based on system colors
Example6_ThemeGenerator() {
    ; Create GUI
    g := Gui(, "Custom Theme Generator")
    g.SetFont("s10")

    g.Add("Text", "w500", "Generate custom theme based on system colors")

    ; Get base system colors
    accentColor := DllCall("GetSysColor", "Int", 13, "UInt")  ; Highlight

    ; Extract RGB
    r := accentColor & 0xFF
    g := (accentColor >> 8) & 0xFF
    b := (accentColor >> 16) & 0xFF

    ; Generate color variations
    GenerateVariation(r, g, b, factor) {
        nr := Round(Min(255, r * factor))
        ng := Round(Min(255, g * factor))
        nb := Round(Min(255, b * factor))
        return Format("0x{:02X}{:02X}{:02X}", nr, ng, nb)
    }

    lighter := GenerateVariation(r, g, b, 1.3)
    base := Format("0x{:02X}{:02X}{:02X}", r, g, b)
    darker := GenerateVariation(r, g, b, 0.7)

    g.Add("GroupBox", "xm w500 h200 Section", "Generated Theme Palette")

    g.Add("Text", "xs+10 ys+30", "Lighter Accent:")
    g.Add("Progress", "x+20 w150 h30 Background" lighter " c" lighter, 100)
    g.Add("Text", "x+10", lighter)

    g.Add("Text", "xs+10", "Base Accent:")
    g.Add("Progress", "x+40 w150 h30 Background" base " c" base, 100)
    g.Add("Text", "x+10", base)

    g.Add("Text", "xs+10", "Darker Accent:")
    g.Add("Progress", "x+30 w150 h30 Background" darker " c" darker, 100)
    g.Add("Text", "x+10", darker)

    g.Add("Button", "xm w240", "Copy Theme to Clipboard").OnEvent("Click", CopyTheme)
    g.Add("Button", "x+20 w240", "Apply to Test Window").OnEvent("Click", ApplyTheme)

    g.Show()

    CopyTheme(*) {
        theme := "Custom Theme Colors:`n"
        theme .= "Lighter: " lighter "`n"
        theme .= "Base: " base "`n"
        theme .= "Darker: " darker

        A_Clipboard := theme
        MsgBox("Theme copied to clipboard!", "Success", "Icon! T2")
    }

    ApplyTheme(*) {
        demo := Gui(, "Theme Demo")
        demo.BackColor := "0xFFFFFF"

        demo.Add("Text", "w300 h40 +Center Background" lighter " cWhite", "Lighter Accent")
        demo.Add("Text", "w300 h40 +Center Background" base " cWhite", "Base Accent")
        demo.Add("Text", "w300 h40 +Center Background" darker " cWhite", "Darker Accent")

        demo.Show()
    }
}

;=============================================================================
; EXAMPLE 7: System Color Monitor
;=============================================================================
; Monitors system colors for changes (theme switching)
Example7_ColorMonitor() {
    ; Create GUI
    g := Gui("+AlwaysOnTop", "System Color Monitor")
    g.SetFont("s9")

    g.Add("Text", "w400", "Monitoring system colors for changes...")

    chkEnabled := g.Add("Checkbox", "xm Checked", "Enable Monitoring")

    txtLog := g.Add("Edit", "xm w400 h250 ReadOnly +Multi")

    ; Store initial colors
    lastColors := Map()

    colorIndices := [5, 8, 13, 14, 15]  ; Window, WindowText, Highlight, HighlightText, ButtonFace

    for index in colorIndices {
        lastColors[index] := DllCall("GetSysColor", "Int", index, "UInt")
    }

    Log("Monitoring started")
    Log("Initial colors recorded")

    ; Set up monitoring timer
    SetTimer(CheckColors, 2000)

    g.OnEvent("Close", (*) => (SetTimer(CheckColors, 0), g.Destroy()))
    g.Show()

    CheckColors() {
        if !chkEnabled.Value
            return

        changedCount := 0

        for index in colorIndices {
            currentColor := DllCall("GetSysColor", "Int", index, "UInt")

            if currentColor != lastColors[index] {
                Log("Color changed: Index " index " from " Format("0x{:06X}", lastColors[index])
                    " to " Format("0x{:06X}", currentColor))

                lastColors[index] := currentColor
                changedCount++
            }
        }

        if changedCount > 0
            Log("Total changes detected: " changedCount)
    }

    Log(msg) {
        timestamp := FormatTime(, "HH:mm:ss")
        txtLog.Value .= "[" timestamp "] " msg "`r`n"
        SendMessage(0x115, 7, 0, txtLog)
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    g := Gui(, "SysGet System Colors Examples")
    g.SetFont("s10")

    g.Add("Text", "w450", "System Colors Examples:")

    g.Add("Button", "w450", "Example 1: Basic System Colors").OnEvent("Click", (*) => Example1_BasicSystemColors())
    g.Add("Button", "w450", "Example 2: Color Palette Viewer").OnEvent("Click", (*) => Example2_ColorPaletteViewer())
    g.Add("Button", "w450", "Example 3: Theme-Aware GUI").OnEvent("Click", (*) => Example3_ThemeAwareGUI())
    g.Add("Button", "w450", "Example 4: Contrast Checker").OnEvent("Click", (*) => Example4_ContrastChecker())
    g.Add("Button", "w450", "Example 5: Dark/Light Mode Detector").OnEvent("Click", (*) => Example5_DarkModeDetector())
    g.Add("Button", "w450", "Example 6: Custom Theme Generator").OnEvent("Click", (*) => Example6_ThemeGenerator())
    g.Add("Button", "w450", "Example 7: System Color Monitor").OnEvent("Click", (*) => Example7_ColorMonitor())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
