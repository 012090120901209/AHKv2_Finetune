#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * WinMove Examples - Part 2: Resize Window
 * ============================================================================
 * 
 * This script demonstrates window resizing with WinMove.
 * Covers various resizing techniques and presets.
 * 
 * @description Comprehensive window resizing examples
 * @author AutoHotkey Community
 * @version 2.0.0
 * @requires AutoHotkey v2.0+
 */

; ============================================================================
; Example 1: Standard Size Presets
; ============================================================================

/**
 * Resizes window to standard preset sizes
 * 
 * @hotkey F1 - Show resize presets
 */
F1:: {
    ShowResizePresets()
}

ShowResizePresets() {
    static resGui := ""

    if resGui {
        try resGui.Destroy()
    }

    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    resGui := Gui("+AlwaysOnTop", "Resize Presets")
    resGui.SetFont("s10", "Segoe UI")

    resGui.Add("Text", "w300", "Select size preset:")

    presets := [
        "800x600 (4:3 Small)",
        "1024x768 (4:3 Medium)",
        "1280x720 (16:9 HD)",
        "1920x1080 (16:9 Full HD)",
        "Half Screen Width",
        "Full Screen Height"
    ]

    presetList := resGui.Add("ListBox", "w300 h150 vPreset")
    presetList.Add(presets)
    presetList.Choose(1)

    resGui.Add("Button", "w145 Default", "Apply").OnEvent("Click", Apply)
    resGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => resGui.Destroy())

    resGui.Show()

    Apply(*) {
        submitted := resGui.Submit()

        MonitorGetWorkArea(1, &left, &top, &right, &bottom)
        screenW := right - left
        screenH := bottom - top

        switch submitted.Preset {
            case 1: WinMove(, , 800, 600, "A")
            case 2: WinMove(, , 1024, 768, "A")
            case 3: WinMove(, , 1280, 720, "A")
            case 4: WinMove(, , 1920, 1080, "A")
            case 5: WinMove(, , screenW // 2, , "A")
            case 6: WinMove(, , , screenH, "A")
        }

        resGui.Destroy()
        ToolTip("Window resized to: " presets[submitted.Preset])
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Example 2: Percentage-Based Resizing
; ============================================================================

/**
 * Resizes window to percentage of screen size
 * 
 * @hotkey F2 - Percentage resize
 */
F2:: {
    PercentageResize()
}

PercentageResize() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    static pctGui := ""

    if pctGui {
        try pctGui.Destroy()
    }

    pctGui := Gui("+AlwaysOnTop", "Percentage Resize")
    pctGui.SetFont("s10", "Segoe UI")

    pctGui.Add("Text", "w300", "Width (% of screen):")
    widthSlider := pctGui.Add("Slider", "w300 vWidth Range25-100 ToolTip", 50)
    widthText := pctGui.Add("Text", "w300 vWidthText", "50%")

    pctGui.Add("Text", "w300", "Height (% of screen):")
    heightSlider := pctGui.Add("Slider", "w300 vHeight Range25-100 ToolTip", 50)
    heightText := pctGui.Add("Text", "w300 vHeightText", "50%")

    widthSlider.OnEvent("Change", (*) => widthText.Value := widthSlider.Value "%")
    heightSlider.OnEvent("Change", (*) => heightText.Value := heightSlider.Value "%")

    pctGui.Add("Button", "w145 Default", "Apply").OnEvent("Click", Apply)
    pctGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => pctGui.Destroy())

    pctGui.Show()

    Apply(*) {
        submitted := pctGui.Submit()

        MonitorGetWorkArea(1, &left, &top, &right, &bottom)

        newW := Round((right - left) * submitted.Width / 100)
        newH := Round((bottom - top) * submitted.Height / 100)

        WinMove(, , newW, newH, "A")

        pctGui.Destroy()
        MsgBox("Resized to " submitted.Width "% x " submitted.Height "%", "Success", 64)
    }
}

; ============================================================================
; Example 3: Incremental Resize
; ============================================================================

/**
 * Increases or decreases window size incrementally
 * 
 * @hotkey F3 - Incremental resize menu
 */
F3:: {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    static incGui := ""

    if incGui {
        try incGui.Destroy()
    }

    incGui := Gui("+AlwaysOnTop", "Incremental Resize")
    incGui.SetFont("s10", "Segoe UI")

    WinGetPos(&x, &y, &w, &h, "A")

    incGui.Add("Text", "w300", "Current: " w " x " h)
    incGui.Add("Text", "w300", "Increment (pixels):")
    incEdit := incGui.Add("Edit", "w300 vIncrement Number", "50")

    incGui.Add("Button", "w90", "Width +").OnEvent("Click", (*) => ChangeSize(incEdit.Value, 0))
    incGui.Add("Button", "w90 x+5 yp", "Width -").OnEvent("Click", (*) => ChangeSize(-incEdit.Value, 0))
    incGui.Add("Button", "w90 x+5 yp", "Height +").OnEvent("Click", (*) => ChangeSize(0, incEdit.Value))

    incGui.Add("Button", "w90 xm", "Height -").OnEvent("Click", (*) => ChangeSize(0, -incEdit.Value))
    incGui.Add("Button", "w90 x+5 yp", "Both +").OnEvent("Click", (*) => ChangeSize(incEdit.Value, incEdit.Value))
    incGui.Add("Button", "w90 x+5 yp", "Both -").OnEvent("Click", (*) => ChangeSize(-incEdit.Value, -incEdit.Value))

    incGui.Add("Button", "w300 xm", "Close").OnEvent("Click", (*) => incGui.Destroy())

    incGui.Show()

    ChangeSize(deltaW, deltaH) {
        WinGetPos(, , &curW, &curH, "A")
        newW := Max(200, curW + Integer(deltaW))
        newH := Max(150, curH + Integer(deltaH))
        WinMove(, , newW, newH, "A")
        ToolTip("Resized to " newW " x " newH)
        SetTimer(() => ToolTip(), -1000)
    }
}

; ============================================================================
; Example 4: Aspect Ratio Resizing
; ============================================================================

/**
 * Resizes while maintaining aspect ratio
 * 
 * @hotkey F4 - Aspect ratio resize
 */
F4:: {
    AspectRatioResize()
}

AspectRatioResize() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    static arGui := ""

    if arGui {
        try arGui.Destroy()
    }

    arGui := Gui("+AlwaysOnTop", "Aspect Ratio Resize")
    arGui.SetFont("s10", "Segoe UI")

    WinGetPos(, , &w, &h, "A")

    arGui.Add("Text", "w300", "Current size: " w " x " h)
    arGui.Add("Text", "w300", "Select aspect ratio:")

    ratios := [
        "16:9 (Widescreen)",
        "16:10 (WXGA)",
        "4:3 (Standard)",
        "21:9 (Ultrawide)",
        "1:1 (Square)"
    ]

    ratioList := arGui.Add("ListBox", "w300 h120 vRatio")
    ratioList.Add(ratios)
    ratioList.Choose(1)

    arGui.Add("Text", "w300", "Target width:")
    widthEdit := arGui.Add("Edit", "w300 vTargetWidth Number", w)

    arGui.Add("Button", "w145 Default", "Apply").OnEvent("Click", Apply)
    arGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => arGui.Destroy())

    arGui.Show()

    Apply(*) {
        submitted := arGui.Submit()
        targetW := Integer(submitted.TargetWidth)

        ratioMap := [[16, 9], [16, 10], [4, 3], [21, 9], [1, 1]]
        ratio := ratioMap[submitted.Ratio]

        targetH := Round(targetW * ratio[2] / ratio[1])

        WinMove(, , targetW, targetH, "A")

        arGui.Destroy()
        MsgBox("Resized to " targetW " x " targetH " (" ratios[submitted.Ratio] ")", "Success", 64)
    }
}

; ============================================================================
; Example 5: Match Another Window Size
; ============================================================================

/**
 * Copies size from another window
 * 
 * @hotkey F5 - Match window size
 */
F5:: {
    MatchWindowSize()
}

MatchWindowSize() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    targetHwnd := WinGetID("A")

    static matchGui := ""

    if matchGui {
        try matchGui.Destroy()
    }

    matchGui := Gui("+AlwaysOnTop", "Match Window Size")
    matchGui.SetFont("s10", "Segoe UI")

    matchGui.Add("Text", "w400", "Select window to match size:")

    lv := matchGui.Add("ListView", "w400 h250 vWinList", ["Title", "Size"])

    windows := []
    allWindows := WinGetList()

    for hwnd in allWindows {
        if hwnd != targetHwnd {
            try {
                title := WinGetTitle(hwnd)
                if title != "" {
                    WinGetPos(, , &w, &h, hwnd)
                    lv.Add("", title, w " x " h)
                    windows.Push(hwnd)
                }
            }
        }
    }

    lv.ModifyCol(1, 300)
    lv.ModifyCol(2, "AutoHdr")

    matchGui.Add("Button", "w195 Default", "Match Size").OnEvent("Click", Match)
    matchGui.Add("Button", "w195 x+10 yp", "Cancel").OnEvent("Click", (*) => matchGui.Destroy())

    matchGui.Show()

    Match(*) {
        selectedRow := lv.GetNext()
        if selectedRow = 0 {
            MsgBox("Please select a window.", "Error", 16)
            return
        }

        sourceHwnd := windows[selectedRow]
        WinGetPos(, , &w, &h, sourceHwnd)
        WinMove(, , w, h, targetHwnd)

        matchGui.Destroy()
        MsgBox("Matched size: " w " x " h, "Success", 64)
    }
}

; ============================================================================
; Example 6: Golden Ratio Resizing
; ============================================================================

/**
 * Resizes using golden ratio (1.618:1)
 * 
 * @hotkey F6 - Golden ratio resize
 */
F6:: {
    GoldenRatioResize()
}

GoldenRatioResize() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    result := InputBox("Enter width (height will be calculated):", "Golden Ratio", "w300 h130", "1000")

    if result.Result != "OK" || !IsNumber(result.Value) {
        return
    }

    width := Integer(result.Value)
    height := Round(width / 1.618)

    WinMove(, , width, height, "A")
    MsgBox("Resized to golden ratio: " width " x " height, "Success", 64)
}

; ============================================================================
; Example 7: Maximize to Partial Screen
; ============================================================================

/**
 * Maximizes to portion of screen
 * 
 * @hotkey F7 - Partial maximize
 */
F7:: {
    PartialMaximize()
}

PartialMaximize() {
    if !WinExist("A") {
        MsgBox("No active window.", "Error", 16)
        return
    }

    static partGui := ""

    if partGui {
        try partGui.Destroy()
    }

    partGui := Gui("+AlwaysOnTop", "Partial Maximize")
    partGui.SetFont("s10", "Segoe UI")

    partGui.Add("Text", "w300", "Select screen portion:")

    portions := [
        "Left Half",
        "Right Half",
        "Top Half",
        "Bottom Half",
        "Top-Left Quarter",
        "Top-Right Quarter",
        "Bottom-Left Quarter",
        "Bottom-Right Quarter"
    ]

    portionList := partGui.Add("ListBox", "w300 h180 vPortion")
    portionList.Add(portions)
    portionList.Choose(1)

    partGui.Add("Button", "w145 Default", "Apply").OnEvent("Click", Apply)
    partGui.Add("Button", "w145 x+10 yp", "Cancel").OnEvent("Click", (*) => partGui.Destroy())

    partGui.Show()

    Apply(*) {
        submitted := partGui.Submit()

        MonitorGetWorkArea(1, &left, &top, &right, &bottom)
        w := right - left
        h := bottom - top

        switch submitted.Portion {
            case 1: WinMove(left, top, w // 2, h, "A")
            case 2: WinMove(left + w // 2, top, w // 2, h, "A")
            case 3: WinMove(left, top, w, h // 2, "A")
            case 4: WinMove(left, top + h // 2, w, h // 2, "A")
            case 5: WinMove(left, top, w // 2, h // 2, "A")
            case 6: WinMove(left + w // 2, top, w // 2, h // 2, "A")
            case 7: WinMove(left, top + h // 2, w // 2, h // 2, "A")
            case 8: WinMove(left + w // 2, top + h // 2, w // 2, h // 2, "A")
        }

        partGui.Destroy()
        ToolTip("Maximized to: " portions[submitted.Portion])
        SetTimer(() => ToolTip(), -1500)
    }
}

; ============================================================================
; Cleanup and Help
; ============================================================================

Esc:: ExitApp()

^F1:: {
    help := "
    (
    WinMove Examples - Part 2 (Resize Window)
    ==========================================

    Hotkeys:
    F1 - Standard size presets
    F2 - Percentage-based resizing
    F3 - Incremental resize
    F4 - Aspect ratio resizing
    F5 - Match another window size
    F6 - Golden ratio resize
    F7 - Partial maximize
    Esc - Exit script

    Ctrl+F1 - Show this help
    )"

    MsgBox(help, "Help", 64)
}
