#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_DPI_02_Scaling.ahk
 * 
 * DESCRIPTION:
 * Advanced DPI scaling techniques for AutoHotkey v2 applications. Demonstrates
 * how to properly scale UI elements, fonts, images, and layouts to maintain
 * consistent appearance across different DPI settings.
 * 
 * FEATURES:
 * - Automatic DPI scaling
 * - Font size scaling
 * - Control size scaling
 * - Image scaling
 * - Layout scaling
 * - Dynamic rescaling
 * - Scale factor utilities
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * Windows DPI Scaling Guidelines
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - DPI-aware sizing calculations
 * - Dynamic control sizing
 * - Proportional scaling
 * - Font scaling
 * - GUI layout adaptation
 * 
 * LEARNING POINTS:
 * 1. All sizes should scale proportionally with DPI
 * 2. Calculate scale factor: currentDPI / 96
 * 3. Apply scaling to: width, height, fonts, spacing
 * 4. Round scaled values to avoid fractional pixels
 * 5. Test at 100%, 125%, 150%, and 200% scaling
 * 6. Maintain aspect ratios when scaling
 * 7. Use relative sizing where possible
 */

;=============================================================================
; HELPER: Get DPI and Scale Factor
;=============================================================================
GetDPIInfo() {
    hDC := DllCall("GetDC", "Ptr", 0, "Ptr")
    dpi := DllCall("GetDeviceCaps", "Ptr", hDC, "Int", 88, "Int")
    DllCall("ReleaseDC", "Ptr", 0, "Ptr", hDC)

    return { DPI: dpi, Scale: dpi / 96, Percent: Round(dpi / 96 * 100) }
}

ScaleValue(value) {
    return Round(value * GetDPIInfo().Scale)
}

;=============================================================================
; EXAMPLE 1: Basic Element Scaling
;=============================================================================
; Demonstrates scaling individual GUI elements
Example1_ElementScaling() {
    dpiInfo := GetDPIInfo()

    ; Define base sizes (at 96 DPI / 100%)
    baseButtonW := 100
    baseButtonH := 30
    baseTextBoxW := 200
    baseFontSize := 10
    baseSpacing := 10

    ; Calculate scaled sizes
    buttonW := ScaleValue(baseButtonW)
    buttonH := ScaleValue(baseButtonH)
    textBoxW := ScaleValue(baseTextBoxW)
    fontSize := ScaleValue(baseFontSize)
    spacing := ScaleValue(baseSpacing)

    ; Create GUI
    g := Gui(, "Basic Element Scaling Demo")
    g.SetFont("s" fontSize)

    g.Add("Text", "w" textBoxW, "All elements scale with DPI!")

    g.Add("GroupBox", "xm w" (textBoxW + 20) " h" ScaleValue(120) " Section", "Scaled Elements")

    g.Add("Text", "xs+" spacing " ys+25", "DPI: " dpiInfo.DPI)
    g.Add("Text", "xs+" spacing, "Scale: " Round(dpiInfo.Scale, 2) "x")
    g.Add("Text", "xs+" spacing, "Percentage: " dpiInfo.Percent "%")

    g.Add("Button", "xm w" buttonW " h" buttonH, "Scaled Button")
    g.Add("Edit", "xm w" textBoxW, "Scaled text box")

    info := "`nBase sizes (100%):`n"
    info .= "  Button: " baseButtonW "×" baseButtonH "`n"
    info .= "  Text Box: " baseTextBoxW " wide`n"
    info .= "  Font: " baseFontSize " pt`n`n"

    info .= "Scaled sizes (" dpiInfo.Percent "%):`n"
    info .= "  Button: " buttonW "×" buttonH "`n"
    info .= "  Text Box: " textBoxW " wide`n"
    info .= "  Font: " fontSize " pt"

    g.Add("Text", "xm w" (textBoxW + 20), info)

    g.Show()
}

;=============================================================================
; EXAMPLE 2: Layout Scaling System
;=============================================================================
; Complete layout scaling with proportional spacing
Example2_LayoutScaling() {
    dpiInfo := GetDPIInfo()
    scale := dpiInfo.Scale

    ; Define base layout (at 100%)
    layout := {
        Width: 500,
        Height: 400,
        Margin: 10,
        Padding: 15,
        ColumnGap: 20,
        RowGap: 10,
        ButtonHeight: 30,
        HeaderHeight: 40,
        FooterHeight: 50
    }

    ; Scale all layout values
    for key, value in layout.OwnProps()
        layout.%key% := Round(value * scale)

    ; Create GUI
    g := Gui(, "Layout Scaling System")
    g.SetFont("s" ScaleValue(10))

    ; Header
    g.Add("Text", "x" layout.Margin " y" layout.Margin " w" (layout.Width - layout.Margin * 2) " h" layout.HeaderHeight " +Center +Border",
        "Scaled Layout Demo - " dpiInfo.Percent "%")

    ; Content area
    contentY := layout.Margin + layout.HeaderHeight + layout.RowGap

    ; Left column
    leftX := layout.Margin
    leftW := (layout.Width - layout.Margin * 2 - layout.ColumnGap) // 2

    g.Add("GroupBox", "x" leftX " y" contentY " w" leftW " h" ScaleValue(150), "Left Column")
    g.Add("Text", "x" (leftX + layout.Padding) " y" (contentY + layout.Padding + 20), "Scaled content")
    g.Add("Button", "x" (leftX + layout.Padding) " w" (leftW - layout.Padding * 2) " h" layout.ButtonHeight, "Action 1")

    ; Right column
    rightX := leftX + leftW + layout.ColumnGap

    g.Add("GroupBox", "x" rightX " y" contentY " w" leftW " h" ScaleValue(150), "Right Column")
    g.Add("Text", "x" (rightX + layout.Padding) " y" (contentY + layout.Padding + 20), "More content")
    g.Add("Button", "x" (rightX + layout.Padding) " w" (leftW - layout.Padding * 2) " h" layout.ButtonHeight, "Action 2")

    ; Footer
    footerY := layout.Height - layout.FooterHeight - layout.Margin

    g.Add("Text", "x" layout.Margin " y" footerY " w" (layout.Width - layout.Margin * 2) " h" layout.FooterHeight " +Center +Border",
        "Footer - All spacing and sizes scale proportionally")

    g.Show("w" layout.Width " h" layout.Height)
}

;=============================================================================
; EXAMPLE 3: Font Scaling Best Practices
;=============================================================================
; Demonstrates proper font scaling
Example3_FontScaling() {
    dpiInfo := GetDPIInfo()

    ; Define base font sizes
    baseFonts := {
        Title: 16,
        Header: 14,
        Normal: 10,
        Small: 8,
        Tiny: 7
    }

    ; Create GUI
    g := Gui(, "Font Scaling Best Practices")

    g.Add("Text", "w450", "Font Scaling Examples (" dpiInfo.Percent "%)")

    ; Show each font size
    for name, baseSize in baseFonts.OwnProps() {
        scaledSize := ScaleValue(baseSize)

        g.SetFont("s" scaledSize)
        g.Add("Text", "xm", name " - Base: " baseSize "pt → Scaled: " scaledSize "pt")
        g.Add("Text", "xm", "The quick brown fox jumps over the lazy dog")
        g.Add("Text", "xm", "")  ; Spacer
    }

    ; Guidelines
    g.SetFont("s" ScaleValue(9))
    g.Add("Text", "xm w450", "`nGuidelines:`n• Scale all font sizes with DPI`n• Maintain font size ratios`n• Test readability at all scales`n• Consider minimum readable sizes")

    g.Show()
}

;=============================================================================
; EXAMPLE 4: Dynamic Rescaling
;=============================================================================
; GUI that rescales when DPI changes
Example4_DynamicRescaling() {
    currentScale := GetDPIInfo().Scale

    CreateScaledGUI()

    ; Monitor for DPI changes
    SetTimer(CheckForDPIChange, 2000)

    CheckForDPIChange() {
        newScale := GetDPIInfo().Scale

        if newScale != currentScale {
            currentScale := newScale
            ; Would normally recreate GUI here
            TrayTip("DPI Changed", "New scaling: " Round(newScale * 100) "%", "Mute")
        }
    }

    CreateScaledGUI() {
        dpiInfo := GetDPIInfo()

        global g := Gui(, "Dynamic Rescaling Demo - " dpiInfo.Percent "%")
        g.SetFont("s" ScaleValue(10))

        g.Add("Text", "w" ScaleValue(400), "This GUI scales with DPI")

        g.Add("GroupBox", "xm w" ScaleValue(400) " h" ScaleValue(100) " Section", "Current Scaling")

        g.Add("Text", "xs+10 ys+25", "DPI: " dpiInfo.DPI)
        g.Add("Text", "xs+10", "Scale Factor: " Round(dpiInfo.Scale, 2) "x")
        g.Add("Text", "xs+10", "Percentage: " dpiInfo.Percent "%")

        g.Add("Button", "xm w" ScaleValue(150) " h" ScaleValue(30), "Scaled Button")

        g.Add("Text", "xm", "`nMove this window to a monitor`nwith different DPI settings")

        g.OnEvent("Close", (*) => (SetTimer(CheckForDPIChange, 0), ExitApp()))

        g.Show()
    }
}

;=============================================================================
; EXAMPLE 5: Image Scaling
;=============================================================================
; Demonstrates scaling images with DPI
Example5_ImageScaling() {
    dpiInfo := GetDPIInfo()

    ; Base image size
    baseImageSize := 64

    ; Scaled sizes
    smallSize := ScaleValue(32)
    mediumSize := ScaleValue(64)
    largeSize := ScaleValue(128)

    ; Create GUI
    g := Gui(, "Image Scaling Demo")
    g.SetFont("s" ScaleValue(10))

    g.Add("Text", "w" ScaleValue(400), "Image Scaling at " dpiInfo.Percent "%")

    ; Note: In real usage, you would load actual images here
    ; This demo shows the sizing
    g.Add("GroupBox", "xm w" ScaleValue(400) " h" ScaleValue(200) " Section", "Scaled Image Sizes")

    g.Add("Text", "xs+10 ys+25", "Small (" smallSize "×" smallSize "):")
    g.Add("Progress", "xs+10 w" smallSize " h" smallSize " BackgroundBlue", 100)

    g.Add("Text", "xs+10", "Medium (" mediumSize "×" mediumSize "):")
    g.Add("Progress", "xs+10 w" mediumSize " h" mediumSize " BackgroundGreen", 100)

    g.Add("Text", "xs+10", "Large (" largeSize "×" largeSize "):")
    g.Add("Progress", "xs+10 w" largeSize " h" largeSize " BackgroundRed", 100)

    info := "`nImage Scaling Guidelines:`n"
    info .= "• Provide multiple image sizes if possible`n"
    info .= "• Use vector graphics when available`n"
    info .= "• Scale bitmaps proportionally`n"
    info .= "• Consider using icon fonts for UI icons"

    g.Add("Text", "xm w" ScaleValue(400), info)

    g.Show()
}

;=============================================================================
; EXAMPLE 6: Responsive Layout Scaling
;=============================================================================
; Adapts layout based on DPI and window size
Example6_ResponsiveScaling() {
    dpiInfo := GetDPIInfo()

    ; Create GUI with responsive layout
    g := Gui("+Resize", "Responsive Layout Scaling")
    g.SetFont("s" ScaleValue(10))

    ; Base dimensions
    baseMinWidth := 400
    baseMinHeight := 300

    minWidth := ScaleValue(baseMinWidth)
    minHeight := ScaleValue(baseMinHeight)

    g.Add("Text", "w" ScaleValue(500), "Resize window to see responsive scaling")

    ; Content that scales
    global statusText := g.Add("Text", "xm w500 h100 +Border")

    UpdateLayout()

    g.OnEvent("Size", (*) => UpdateLayout())
    g.Show("w" ScaleValue(500) " h" ScaleValue(400))

    UpdateLayout() {
        try {
            g.GetPos(, , &winW, &winH)

            info := "Window Size: " winW "×" winH "`n"
            info .= "DPI: " dpiInfo.DPI " (" dpiInfo.Percent "%)`n"
            info .= "Min Size: " minWidth "×" minHeight "`n`n"

            if winW < minWidth || winH < minHeight
                info .= "⚠ Below minimum size!"
            else
                info .= "✓ Size OK"

            statusText.Value := info
        }
    }
}

;=============================================================================
; EXAMPLE 7: Multi-DPI Preview Tool
;=============================================================================
; Shows how UI looks at different DPI settings
Example7_MultiDPIPreview() {
    ; Create main GUI
    g := Gui(, "Multi-DPI Preview Tool")
    g.SetFont("s10")

    g.Add("Text", "w600", "Preview how sizes look at different DPI settings")

    g.Add("Text", "xm Section", "Base Size (at 100%):")
    edtBaseSize := g.Add("Edit", "xs w80", "100")

    g.Add("Button", "xm w150", "Generate Preview").OnEvent("Click", GeneratePreview)

    txtPreview := g.Add("Text", "xm w600 h300 +Border")

    g.Show()

    GeneratePreview(*) {
        baseSize := Integer(edtBaseSize.Value)

        preview := "MULTI-DPI PREVIEW FOR " baseSize " PIXELS`n"
        preview .= "═══════════════════════════════════════════`n`n"

        dpiSettings := [{
            DPI: 96, Percent: 100, Name: "Standard" }, {
                DPI: 120, Percent: 125, Name: "Medium" }, {
                    DPI: 144, Percent: 150, Name: "Large" }, {
                        DPI: 192, Percent: 200, Name: "Very Large"
                    }
        ]

        for setting in dpiSettings {
            scaleFactor := setting.DPI / 96
            scaledSize := Round(baseSize * scaleFactor)

            preview .= setting.Percent "% Scaling (" setting.DPI " DPI)`n"
            preview .= "  Scaled to: " scaledSize " pixels`n"
            preview .= "  Factor: " Round(scaleFactor, 2) "x`n"

            ; Visual representation
            barChars := Min(Round(scaledSize / 10), 50)
            preview .= "  Visual: "
            Loop barChars
                preview .= "█"
            preview .= "`n`n"
        }

        preview .= "TIP: Test your UI at all common DPI settings!"

        txtPreview.Value := preview
    }
}

;=============================================================================
; MAIN MENU
;=============================================================================
CreateMainMenu() {
    dpiInfo := GetDPIInfo()

    g := Gui(, "DPI Scaling Examples")
    g.SetFont("s" ScaleValue(10))

    g.Add("Text", "w450", "Current DPI: " dpiInfo.DPI " (" dpiInfo.Percent "%)")
    g.Add("Text", "w450", "DPI Scaling Examples:")

    g.Add("Button", "w450", "Example 1: Basic Element Scaling").OnEvent("Click", (*) => Example1_ElementScaling())
    g.Add("Button", "w450", "Example 2: Layout Scaling System").OnEvent("Click", (*) => Example2_LayoutScaling())
    g.Add("Button", "w450", "Example 3: Font Scaling").OnEvent("Click", (*) => Example3_FontScaling())
    g.Add("Button", "w450", "Example 4: Dynamic Rescaling").OnEvent("Click", (*) => Example4_DynamicRescaling())
    g.Add("Button", "w450", "Example 5: Image Scaling").OnEvent("Click", (*) => Example5_ImageScaling())
    g.Add("Button", "w450", "Example 6: Responsive Scaling").OnEvent("Click", (*) => Example6_ResponsiveScaling())
    g.Add("Button", "w450", "Example 7: Multi-DPI Preview").OnEvent("Click", (*) => Example7_MultiDPIPreview())

    g.Add("Button", "w450", "Exit").OnEvent("Click", (*) => ExitApp())

    g.Show()
}

CreateMainMenu()
