#Requires AutoHotkey v2.0
/**
 * BuiltIn_DllCall_User32_05_SystemMetrics.ahk
 *
 * DESCRIPTION:
 * Demonstrates retrieving system metrics and parameters using Windows API.
 * Shows how to get screen dimensions, window sizes, system colors, UI metrics,
 * and various system configuration values.
 *
 * FEATURES:
 * - Screen and display metrics
 * - Window sizing metrics (title bar, borders, scrollbars)
 * - System colors and UI element colors
 * - Mouse and keyboard metrics
 * - Icon and cursor sizes
 * - System parameters (animation, focus, etc.)
 * - Multi-monitor information
 *
 * SOURCE:
 * AutoHotkey v2 Documentation - DllCall
 * https://www.autohotkey.com/docs/v2/lib/DllCall.htm
 * Microsoft GetSystemMetrics API
 * https://docs.microsoft.com/en-us/windows/win32/api/winuser/nf-winuser-getsystemmetrics
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - DllCall() with GetSystemMetrics
 * - GetSysColor for system colors
 * - SystemParametersInfo for advanced settings
 * - EnumDisplayMonitors for multi-monitor setups
 * - Structure handling for NONCLIENTMETRICS
 *
 * LEARNING POINTS:
 * 1. How to query system metrics using GetSystemMetrics
 * 2. Retrieving system colors with GetSysColor
 * 3. Getting advanced parameters with SystemParametersInfo
 * 4. Working with multi-monitor configurations
 * 5. Understanding non-client area metrics
 * 6. Detecting system capabilities and features
 * 7. Querying UI animation and visual effects settings
 */

;==============================================================================
; EXAMPLE 1: Basic Screen and Display Metrics
;==============================================================================
; Demonstrates getting screen dimensions and display information

Example1_ScreenMetrics() {
    ; System metric constants
    SM_CXSCREEN := 0          ; Screen width
    SM_CYSCREEN := 1          ; Screen height
    SM_CXVIRTUALSCREEN := 78  ; Virtual screen width (all monitors)
    SM_CYVIRTUALSCREEN := 79  ; Virtual screen height (all monitors)
    SM_XVIRTUALSCREEN := 76   ; Virtual screen left
    SM_YVIRTUALSCREEN := 77   ; Virtual screen top
    SM_CMONITORS := 80        ; Number of monitors
    SM_SAMEDISPLAYFORMAT := 81 ; All monitors same color format

    ; Get metrics
    screenWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXSCREEN, "Int")
    screenHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYSCREEN, "Int")
    virtualWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXVIRTUALSCREEN, "Int")
    virtualHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYVIRTUALSCREEN, "Int")
    virtualLeft := DllCall("User32.dll\GetSystemMetrics", "Int", SM_XVIRTUALSCREEN, "Int")
    virtualTop := DllCall("User32.dll\GetSystemMetrics", "Int", SM_YVIRTUALSCREEN, "Int")
    monitorCount := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CMONITORS, "Int")
    sameFormat := DllCall("User32.dll\GetSystemMetrics", "Int", SM_SAMEDISPLAYFORMAT, "Int")

    info := Format("
    (
        Screen Metrics:
        ===============

        Primary Monitor:
        - Width: {} pixels
        - Height: {} pixels
        - Resolution: {}x{}

        Virtual Screen (All Monitors):
        - Width: {} pixels
        - Height: {} pixels
        - Left: {}
        - Top: {}
        - Total Resolution: {}x{}

        Multi-Monitor:
        - Monitor Count: {}
        - Same Display Format: {}
    )",
    screenWidth, screenHeight, screenWidth, screenHeight,
    virtualWidth, virtualHeight, virtualLeft, virtualTop, virtualWidth, virtualHeight,
    monitorCount, sameFormat ? "Yes" : "No")

    MsgBox(info, "Screen Metrics")

    ; Get DPI awareness
    dpi := DllCall("User32.dll\GetDpiForSystem", "UInt")
    scaleFactor := (dpi / 96.0) * 100

    MsgBox(Format("DPI Information:`n`nSystem DPI: {}`nScale Factor: {:.0f}%", dpi, scaleFactor), "DPI Info")
}

;==============================================================================
; EXAMPLE 2: Window Sizing Metrics
;==============================================================================
; Shows metrics for window elements (borders, title bars, etc.)

Example2_WindowMetrics() {
    ; Window metric constants
    SM_CXBORDER := 5          ; Window border width
    SM_CYBORDER := 6          ; Window border height
    SM_CXDLGFRAME := 7        ; Dialog frame width
    SM_CYDLGFRAME := 8        ; Dialog frame height
    SM_CYCAPTION := 4         ; Caption height
    SM_CXSIZE := 30           ; Window sizing border width
    SM_CYSIZE := 31           ; Window sizing border height
    SM_CXFRAME := 32          ; Resizable window border width
    SM_CYFRAME := 33          ; Resizable window border height
    SM_CXPADDEDBORDER := 92   ; Padded border width (Win Vista+)

    ; Scrollbar metrics
    SM_CXVSCROLL := 2         ; Vertical scrollbar width
    SM_CYHSCROLL := 3         ; Horizontal scrollbar height
    SM_CXHSCROLL := 21        ; Width of arrow on horizontal scrollbar
    SM_CYVSCROLL := 20        ; Height of arrow on vertical scrollbar

    ; Get metrics
    borderWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXBORDER, "Int")
    borderHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYBORDER, "Int")
    dlgFrameWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXDLGFRAME, "Int")
    dlgFrameHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYDLGFRAME, "Int")
    captionHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYCAPTION, "Int")
    frameWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXFRAME, "Int")
    frameHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYFRAME, "Int")
    vScrollWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXVSCROLL, "Int")
    hScrollHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYHSCROLL, "Int")

    info := Format("
    (
        Window Element Metrics:
        =======================

        Borders:
        - Border Width: {} px
        - Border Height: {} px
        - Dialog Frame Width: {} px
        - Dialog Frame Height: {} px
        - Resizable Frame Width: {} px
        - Resizable Frame Height: {} px

        Window Elements:
        - Caption/Title Bar Height: {} px

        Scrollbars:
        - Vertical Scrollbar Width: {} px
        - Horizontal Scrollbar Height: {} px
    )",
    borderWidth, borderHeight, dlgFrameWidth, dlgFrameHeight, frameWidth, frameHeight,
    captionHeight, vScrollWidth, hScrollHeight)

    MsgBox(info, "Window Metrics")
}

;==============================================================================
; EXAMPLE 3: System Colors
;==============================================================================
; Demonstrates retrieving system color scheme values

Example3_SystemColors() {
    ; System color constants
    COLOR_SCROLLBAR := 0
    COLOR_BACKGROUND := 1
    COLOR_ACTIVECAPTION := 2
    COLOR_INACTIVECAPTION := 3
    COLOR_MENU := 4
    COLOR_WINDOW := 5
    COLOR_WINDOWFRAME := 6
    COLOR_MENUTEXT := 7
    COLOR_WINDOWTEXT := 8
    COLOR_CAPTIONTEXT := 9
    COLOR_ACTIVEBORDER := 10
    COLOR_INACTIVEBORDER := 11
    COLOR_BTNFACE := 15
    COLOR_BTNSHADOW := 16
    COLOR_BTNTEXT := 18
    COLOR_BTNHIGHLIGHT := 20
    COLOR_HIGHLIGHT := 13
    COLOR_HIGHLIGHTTEXT := 14

    ; Function to convert color to hex
    ColorToHex := (colorRef) {
        r := colorRef & 0xFF
        g := (colorRef >> 8) & 0xFF
        b := (colorRef >> 16) & 0xFF
        return Format("#{:02X}{:02X}{:02X}", r, g, b)
    }

    ; Get various system colors
    colors := Map(
        "Window Background", COLOR_WINDOW,
        "Window Text", COLOR_WINDOWTEXT,
        "Active Caption", COLOR_ACTIVECAPTION,
        "Active Caption Text", COLOR_CAPTIONTEXT,
        "Inactive Caption", COLOR_INACTIVECAPTION,
        "Menu Background", COLOR_MENU,
        "Menu Text", COLOR_MENUTEXT,
        "Button Face", COLOR_BTNFACE,
        "Button Text", COLOR_BTNTEXT,
        "Highlight", COLOR_HIGHLIGHT,
        "Highlight Text", COLOR_HIGHLIGHTTEXT,
        "Desktop Background", COLOR_BACKGROUND
    )

    info := "System Colors:`n" . "=" . StrRepeat("=", 40) . "`n`n"

    for name, colorIndex in colors {
        colorRef := DllCall("User32.dll\GetSysColor", "Int", colorIndex, "UInt")
        hexColor := ColorToHex(colorRef)
        info .= Format("{,-25} {}`n", name . ":", hexColor)
    }

    MsgBox(info, "System Colors")

    ; Demonstrate color in a GUI
    ShowColorDemo()
}

; Helper to show colors visually
ShowColorDemo() {
    colorGui := Gui(, "System Color Demo")
    colorGui.SetFont("s10")

    ; Show a few key colors
    COLOR_WINDOW := 5
    COLOR_WINDOWTEXT := 8
    COLOR_BTNFACE := 15

    winColor := DllCall("User32.dll\GetSysColor", "Int", COLOR_WINDOW, "UInt")
    textColor := DllCall("User32.dll\GetSysColor", "Int", COLOR_WINDOWTEXT, "UInt")
    btnColor := DllCall("User32.dll\GetSysColor", "Int", COLOR_BTNFACE, "UInt")

    colorGui.Add("Text", "w300", "Window Background Color:")
    colorGui.Add("Progress", Format("w300 h30 Background{:06X}", winColor), 100)

    colorGui.Add("Text", "w300", "`nButton Face Color:")
    colorGui.Add("Progress", Format("w300 h30 Background{:06X}", btnColor), 100)

    colorGui.Add("Button", "w300", "Close").OnEvent("Click", (*) => colorGui.Destroy())
    colorGui.Show()
}

; Helper function
StrRepeat(str, count) {
    result := ""
    Loop count
        result .= str
    return result
}

;==============================================================================
; EXAMPLE 4: Mouse and Keyboard Metrics
;==============================================================================
; Shows input device metrics and capabilities

Example4_InputMetrics() {
    ; Mouse metrics
    SM_CMOUSEBUTTONS := 43    ; Number of mouse buttons
    SM_SWAPBUTTON := 23       ; Mouse buttons swapped
    SM_CXDOUBLECLK := 36      ; Double-click X tolerance
    SM_CYDOUBLECLK := 37      ; Double-click Y tolerance
    SM_MOUSEPRESENT := 19     ; Mouse present
    SM_MOUSEWHEELPRESENT := 75 ; Mouse wheel present
    SM_MOUSEHORIZONTALWHEELPRESENT := 91

    ; Keyboard metrics
    SM_SECURE := 44           ; Secure desktop active
    SM_IMMENABLED := 82       ; IME enabled

    mouseButtons := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CMOUSEBUTTONS, "Int")
    swappedButtons := DllCall("User32.dll\GetSystemMetrics", "Int", SM_SWAPBUTTON, "Int")
    doubleClickX := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXDOUBLECLK, "Int")
    doubleClickY := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYDOUBLECLK, "Int")
    mousePresent := DllCall("User32.dll\GetSystemMetrics", "Int", SM_MOUSEPRESENT, "Int")
    wheelPresent := DllCall("User32.dll\GetSystemMetrics", "Int", SM_MOUSEWHEELPRESENT, "Int")
    hWheelPresent := DllCall("User32.dll\GetSystemMetrics", "Int", SM_MOUSEHORIZONTALWHEELPRESENT, "Int")

    info := Format("
    (
        Input Device Metrics:
        =====================

        Mouse:
        - Number of Buttons: {}
        - Buttons Swapped: {}
        - Double-Click Tolerance: {} x {} pixels
        - Mouse Present: {}
        - Mouse Wheel Present: {}
        - Horizontal Wheel Present: {}

        Mouse Speed Settings:
    )",
    mouseButtons,
    swappedButtons ? "Yes (Left-handed)" : "No",
    doubleClickX, doubleClickY,
    mousePresent ? "Yes" : "No",
    wheelPresent ? "Yes" : "No",
    hWheelPresent ? "Yes" : "No")

    ; Get additional mouse parameters
    SPI_GETMOUSESPEED := 0x0070
    mouseSpeed := Buffer(4, 0)
    DllCall("User32.dll\SystemParametersInfoW"
        , "UInt", SPI_GETMOUSESPEED
        , "UInt", 0
        , "Ptr", mouseSpeed.Ptr
        , "UInt", 0
        , "Int")
    speed := NumGet(mouseSpeed, 0, "Int")

    info .= "`n- Mouse Speed: " . speed . " (1-20 scale)"

    MsgBox(info, "Input Metrics")
}

;==============================================================================
; EXAMPLE 5: Icon and Cursor Metrics
;==============================================================================
; Shows icon sizes and cursor dimensions

Example5_IconMetrics() {
    ; Icon metrics
    SM_CXICON := 11           ; Default icon width
    SM_CYICON := 12           ; Default icon height
    SM_CXSMICON := 49         ; Small icon width
    SM_CYSMICON := 50         ; Small icon height
    SM_CXCURSOR := 13         ; Cursor width
    SM_CYCURSOR := 14         ; Cursor height

    iconWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXICON, "Int")
    iconHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYICON, "Int")
    smallIconWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXSMICON, "Int")
    smallIconHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYSMICON, "Int")
    cursorWidth := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CXCURSOR, "Int")
    cursorHeight := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CYCURSOR, "Int")

    info := Format("
    (
        Icon and Cursor Metrics:
        ========================

        Icons:
        - Standard Icon Size: {} x {} pixels
        - Small Icon Size: {} x {} pixels

        Cursors:
        - Cursor Size: {} x {} pixels
    )",
    iconWidth, iconHeight,
    smallIconWidth, smallIconHeight,
    cursorWidth, cursorHeight)

    MsgBox(info, "Icon Metrics")

    ; Get icon spacing
    SPI_ICONHORIZONTALSPACING := 0x000D
    SPI_ICONVERTICALSPACING := 0x0018

    hSpacing := Buffer(4, 0)
    vSpacing := Buffer(4, 0)

    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_ICONHORIZONTALSPACING, "UInt", 0, "Ptr", hSpacing.Ptr, "UInt", 0, "Int")
    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_ICONVERTICALSPACING, "UInt", 0, "Ptr", vSpacing.Ptr, "UInt", 0, "Int")

    hSpace := NumGet(hSpacing, 0, "Int")
    vSpace := NumGet(vSpacing, 0, "Int")

    MsgBox(Format("Desktop Icon Spacing:`n`nHorizontal: {} pixels`nVertical: {} pixels", hSpace, vSpace), "Icon Spacing")
}

;==============================================================================
; EXAMPLE 6: System Capabilities and Features
;==============================================================================
; Shows system capabilities using GetSystemMetrics

Example6_SystemCapabilities() {
    ; Capability metrics
    SM_NETWORK := 63          ; Network present
    SM_CLEANBOOT := 67        ; Clean boot mode
    SM_TABLETPC := 86         ; Tablet PC
    SM_MEDIACENTER := 87      ; Media Center
    SM_STARTER := 88          ; Starter edition
    SM_SERVERR2 := 89         ; Server R2
    SM_REMOTESESSION := 0x1000 ; Remote desktop session
    SM_SHUTTINGDOWN := 0x2000  ; System is shutting down

    network := DllCall("User32.dll\GetSystemMetrics", "Int", SM_NETWORK, "Int")
    cleanBoot := DllCall("User32.dll\GetSystemMetrics", "Int", SM_CLEANBOOT, "Int")
    tabletPC := DllCall("User32.dll\GetSystemMetrics", "Int", SM_TABLETPC, "Int")
    mediaCenter := DllCall("User32.dll\GetSystemMetrics", "Int", SM_MEDIACENTER, "Int")
    starter := DllCall("User32.dll\GetSystemMetrics", "Int", SM_STARTER, "Int")
    remote := DllCall("User32.dll\GetSystemMetrics", "Int", SM_REMOTESESSION, "Int")

    info := Format("
    (
        System Capabilities:
        ====================

        - Network Present: {}
        - Clean Boot Mode: {}
        - Tablet PC: {}
        - Media Center Edition: {}
        - Starter Edition: {}
        - Remote Desktop Session: {}
    )",
    network ? "Yes" : "No",
    cleanBoot ? "Yes (Safe Mode)" : "No",
    tabletPC ? "Yes" : "No",
    mediaCenter ? "Yes" : "No",
    starter ? "Yes" : "No",
    remote ? "Yes" : "No")

    MsgBox(info, "System Capabilities")

    ; Additional system info
    SM_SLOWMACHINE := 73
    slowMachine := DllCall("User32.dll\GetSystemMetrics", "Int", SM_SLOWMACHINE, "Int")

    MsgBox("Slow Machine Mode: " . (slowMachine ? "Yes (Low resources)" : "No"), "Performance")
}

;==============================================================================
; EXAMPLE 7: Advanced System Parameters
;==============================================================================
; Shows SystemParametersInfo usage for detailed system settings

Example7_AdvancedParameters() {
    ; Get desktop wallpaper
    SPI_GETDESKWALLPAPER := 0x0073
    wallpaperBuf := Buffer(520, 0)
    DllCall("User32.dll\SystemParametersInfoW"
        , "UInt", SPI_GETDESKWALLPAPER
        , "UInt", 260
        , "Ptr", wallpaperBuf.Ptr
        , "UInt", 0
        , "Int")
    wallpaper := StrGet(wallpaperBuf.Ptr, "UTF-16")

    ; Get screensaver info
    SPI_GETSCREENSAVEACTIVE := 0x0010
    SPI_GETSCREENSAVETIMEOUT := 0x000E
    ssActive := Buffer(4, 0)
    ssTimeout := Buffer(4, 0)

    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_GETSCREENSAVEACTIVE, "UInt", 0, "Ptr", ssActive.Ptr, "UInt", 0, "Int")
    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_GETSCREENSAVETIMEOUT, "UInt", 0, "Ptr", ssTimeout.Ptr, "UInt", 0, "Int")

    active := NumGet(ssActive, 0, "Int")
    timeout := NumGet(ssTimeout, 0, "Int")

    ; Get animation settings
    SPI_GETANIMATION := 0x0048
    animInfo := Buffer(8, 0)
    NumPut("UInt", 8, animInfo, 0)  ; cbSize

    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_GETANIMATION, "UInt", 8, "Ptr", animInfo.Ptr, "UInt", 0, "Int")
    minAnimate := NumGet(animInfo, 4, "Int")

    ; Get work area
    SPI_GETWORKAREA := 0x0030
    workArea := Buffer(16, 0)
    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_GETWORKAREA, "UInt", 0, "Ptr", workArea.Ptr, "UInt", 0, "Int")

    waLeft := NumGet(workArea, 0, "Int")
    waTop := NumGet(workArea, 4, "Int")
    waRight := NumGet(workArea, 8, "Int")
    waBottom := NumGet(workArea, 12, "Int")

    info := Format("
    (
        Advanced System Parameters:
        ===========================

        Desktop:
        - Wallpaper: {}

        Screensaver:
        - Active: {}
        - Timeout: {} seconds

        Visual Effects:
        - Window Minimize/Restore Animation: {}

        Work Area (Taskbar excluded):
        - Left: {}, Top: {}
        - Right: {}, Bottom: {}
        - Size: {} x {}
    )",
    wallpaper ? wallpaper : "None",
    active ? "Yes" : "No",
    timeout,
    minAnimate ? "Enabled" : "Disabled",
    waLeft, waTop, waRight, waBottom,
    waRight - waLeft, waBottom - waTop)

    MsgBox(info, "Advanced Parameters")

    ; Get font smoothing
    SPI_GETFONTSMOOTHING := 0x004A
    SPI_GETFONTSMOOTHINGTYPE := 0x200A

    fontSmoothing := Buffer(4, 0)
    fontSmoothingType := Buffer(4, 0)

    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_GETFONTSMOOTHING, "UInt", 0, "Ptr", fontSmoothing.Ptr, "UInt", 0, "Int")
    DllCall("User32.dll\SystemParametersInfoW", "UInt", SPI_GETFONTSMOOTHINGTYPE, "UInt", 0, "Ptr", fontSmoothingType.Ptr, "UInt", 0, "Int")

    smoothing := NumGet(fontSmoothing, 0, "Int")
    smoothType := NumGet(fontSmoothingType, 0, "Int")

    typeNames := Map(1, "Standard", 2, "ClearType")
    typeName := typeNames.Has(smoothType) ? typeNames[smoothType] : "Unknown"

    MsgBox(Format("Font Smoothing:`n`nEnabled: {}`nType: {} ({})",
        smoothing ? "Yes" : "No",
        smoothType,
        typeName), "Font Settings")
}

;==============================================================================
; DEMO MENU
;==============================================================================

ShowDemoMenu() {
    menu := "
    (
    System Metrics DllCall Examples
    ================================

    1. Screen and Display Metrics
    2. Window Sizing Metrics
    3. System Colors
    4. Mouse and Keyboard Metrics
    5. Icon and Cursor Metrics
    6. System Capabilities
    7. Advanced System Parameters

    Enter choice (1-7) or 0 to exit:
    )"

    Loop {
        choice := InputBox(menu, "System Metrics Examples", "w400 h350").Value

        if (choice = "0" or choice = "")
            break

        switch choice {
            case "1": Example1_ScreenMetrics()
            case "2": Example2_WindowMetrics()
            case "3": Example3_SystemColors()
            case "4": Example4_InputMetrics()
            case "5": Example5_IconMetrics()
            case "6": Example6_SystemCapabilities()
            case "7": Example7_AdvancedParameters()
            default: MsgBox("Invalid choice! Please enter 1-7.", "Error", "IconX")
        }
    }
}

; Run the demo menu
ShowDemoMenu()
