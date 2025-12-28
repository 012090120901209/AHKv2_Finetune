/**
 * @file BuiltIn_WinGetPos_01.ahk
 * @description Comprehensive examples demonstrating WinGetPos function for retrieving window position and size information in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Basic window position retrieval
 * Example 2: Window dimension calculator
 * Example 3: Window position tracker with real-time updates
 * Example 4: Save and restore window positions
 * Example 5: Multi-monitor window position detector
 * Example 6: Window alignment checker
 * Example 7: Window bounds validator
 * 
 * @section FEATURES
 * - Get window X, Y coordinates
 * - Retrieve window width and height
 * - Calculate window centers
 * - Track window movements
 * - Save/restore positions
 * - Multi-monitor support
 * - Position validation
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Basic Window Position Retrieval
; ========================================

/**
 * @function GetWindowPositionBasic
 * @description Demonstrates basic usage of WinGetPos to retrieve window coordinates and dimensions
 * @param WinTitle The title or criteria of the window
 * @returns {Object} Window position data
 */
GetWindowPositionBasic(WinTitle := "A") {
    try {
        ; Get window position and size
        WinGetPos(&x, &y, &width, &height, WinTitle)

        ; Create result object
        result := {
            X: x,
            Y: y,
            Width: width,
            Height: height,
            Area: width * height,
            AspectRatio: Round(width / height, 2)
        }

        return result
    } catch as err {
        MsgBox("Error getting window position: " err.Message)
        return false
    }
}

; Hotkey: Ctrl+Shift+P - Get active window position
^+p:: {
    pos := GetWindowPositionBasic("A")
    if pos {
        info := "Window Position Information:`n`n"
        info .= "X: " pos.X " pixels`n"
        info .= "Y: " pos.Y " pixels`n"
        info .= "Width: " pos.Width " pixels`n"
        info .= "Height: " pos.Height " pixels`n"
        info .= "Area: " pos.Area " sq pixels`n"
        info .= "Aspect Ratio: " pos.AspectRatio
        MsgBox(info, "Window Position", "Icon!")
    }
}

; ========================================
; Example 2: Window Dimension Calculator
; ========================================

/**
 * @class WindowDimensionCalculator
 * @description Advanced window dimension analyzer with various calculations
 */
class WindowDimensionCalculator {
    /**
     * @method GetFullDimensions
     * @description Get comprehensive dimension information for a window
     * @param WinTitle Window identifier
     * @returns {Object} Complete dimension data
     */
    static GetFullDimensions(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            return {
                Position: { X: x, Y: y },
                Size: { Width: width, Height: height },
                Center: {
                    X: x + (width // 2),
                    Y: y + (height // 2)
                },
                Corners: {
                    TopLeft: { X: x, Y: y },
                    TopRight: { X: x + width, Y: y },
                    BottomLeft: { X: x, Y: y + height },
                    BottomRight: { X: x + width, Y: y + height }
                },
                Bounds: {
                    Left: x,
                    Top: y,
                    Right: x + width,
                    Bottom: y + height
                },
                Metrics: {
                    Area: width * height,
                    Perimeter: (width + height) * 2,
                    Diagonal: Round(Sqrt(width ** 2 + height ** 2), 2),
                    AspectRatio: Round(width / height, 3)
                }
            }
        } catch as err {
            throw Error("Failed to get window dimensions: " err.Message)
        }
    }

    /**
     * @method CompareWindows
     * @description Compare dimensions of two windows
     * @param WinTitle1 First window
     * @param WinTitle2 Second window
     * @returns {Object} Comparison data
     */
    static CompareWindows(WinTitle1, WinTitle2) {
        dim1 := this.GetFullDimensions(WinTitle1)
        dim2 := this.GetFullDimensions(WinTitle2)

        return {
            Window1: dim1,
            Window2: dim2,
            Differences: {
                XOffset: dim2.Position.X - dim1.Position.X,
                YOffset: dim2.Position.Y - dim1.Position.Y,
                WidthDiff: dim2.Size.Width - dim1.Size.Width,
                HeightDiff: dim2.Size.Height - dim1.Size.Height,
                AreaDiff: dim2.Metrics.Area - dim1.Metrics.Area
            },
            Overlap: this.CheckOverlap(dim1, dim2)
        }
    }

    /**
     * @method CheckOverlap
     * @description Check if two windows overlap
     * @param dim1 First window dimensions
     * @param dim2 Second window dimensions
     * @returns {Boolean} True if windows overlap
     */
    static CheckOverlap(dim1, dim2) {
        return !(dim1.Bounds.Right < dim2.Bounds.Left ||
            dim1.Bounds.Left > dim2.Bounds.Right ||
            dim1.Bounds.Bottom < dim2.Bounds.Top ||
            dim1.Bounds.Top > dim2.Bounds.Bottom)
    }
}

; Hotkey: Ctrl+Shift+D - Show dimension calculator
^+d:: {
    dims := WindowDimensionCalculator.GetFullDimensions("A")

    output := "=== Window Dimension Analysis ===`n`n"
    output .= "Position: (" dims.Position.X ", " dims.Position.Y ")`n"
    output .= "Size: " dims.Size.Width "x" dims.Size.Height "`n"
    output .= "Center: (" dims.Center.X ", " dims.Center.Y ")`n`n"
    output .= "Corners:`n"
    output .= "  Top-Left: (" dims.Corners.TopLeft.X ", " dims.Corners.TopLeft.Y ")`n"
    output .= "  Top-Right: (" dims.Corners.TopRight.X ", " dims.Corners.TopRight.Y ")`n"
    output .= "  Bottom-Left: (" dims.Corners.BottomLeft.X ", " dims.Corners.BottomLeft.Y ")`n"
    output .= "  Bottom-Right: (" dims.Corners.BottomRight.X ", " dims.Corners.BottomRight.Y ")`n`n"
    output .= "Metrics:`n"
    output .= "  Area: " dims.Metrics.Area " sq pixels`n"
    output .= "  Perimeter: " dims.Metrics.Perimeter " pixels`n"
    output .= "  Diagonal: " dims.Metrics.Diagonal " pixels`n"
    output .= "  Aspect Ratio: " dims.Metrics.AspectRatio

    MsgBox(output, "Dimension Calculator", "Icon!")
}

; ========================================
; Example 3: Window Position Tracker
; ========================================

/**
 * @class WindowPositionTracker
 * @description Real-time window position tracking with history
 */
class WindowPositionTracker {
    static tracking := false
    static trackTimer := 0
    static positionHistory := []
    static maxHistory := 50
    static targetWindow := ""
    static trackerGui := ""

    /**
     * @method StartTracking
     * @description Begin tracking a window's position
     * @param WinTitle Window to track
     * @param interval Update interval in milliseconds
     */
    static StartTracking(WinTitle := "A", interval := 100) {
        this.targetWindow := WinTitle
        this.positionHistory := []
        this.tracking := true

        ; Create tracker GUI
        this.CreateTrackerGui()

        ; Start tracking timer
        this.trackTimer := SetTimer(() => this.UpdatePosition(), interval)
    }

    /**
     * @method StopTracking
     * @description Stop tracking and cleanup
     */
    static StopTracking() {
        this.tracking := false
        if this.trackTimer {
            SetTimer(this.trackTimer, 0)
            this.trackTimer := 0
        }
        if this.trackerGui {
            this.trackerGui.Destroy()
            this.trackerGui := ""
        }
    }

    /**
     * @method UpdatePosition
     * @description Update current position and history
     */
    static UpdatePosition() {
        try {
            WinGetPos(&x, &y, &width, &height, this.targetWindow)

            currentPos := {
                X: x,
                Y: y,
                Width: width,
                Height: height,
                Timestamp: A_TickCount
            }

            ; Add to history
            this.positionHistory.Push(currentPos)
            if this.positionHistory.Length > this.maxHistory {
                this.positionHistory.RemoveAt(1)
            }

            ; Update GUI
            this.UpdateTrackerGui(currentPos)

        } catch {
            this.StopTracking()
            MsgBox("Window closed or inaccessible", "Tracker Stopped")
        }
    }

    /**
     * @method CreateTrackerGui
     * @description Create the tracker display GUI
     */
    static CreateTrackerGui() {
        this.trackerGui := Gui("+AlwaysOnTop +ToolWindow", "Position Tracker")
        this.trackerGui.SetFont("s10", "Consolas")

        this.trackerGui.Add("Text", "w300", "Position Tracker - Real-time")
        this.trackerGui.Add("Text", "w300 vPosX", "X: ---")
        this.trackerGui.Add("Text", "w300 vPosY", "Y: ---")
        this.trackerGui.Add("Text", "w300 vPosW", "Width: ---")
        this.trackerGui.Add("Text", "w300 vPosH", "Height: ---")
        this.trackerGui.Add("Text", "w300 vVelocity", "Velocity: ---")
        this.trackerGui.Add("Button", "w300", "Stop Tracking").OnEvent("Click", (*) => this.StopTracking())

        this.trackerGui.Show()
    }

    /**
     * @method UpdateTrackerGui
     * @description Update tracker GUI with current data
     * @param pos Current position data
     */
    static UpdateTrackerGui(pos) {
        if !this.trackerGui
            return

        this.trackerGui["PosX"].Value := "X: " pos.X " pixels"
        this.trackerGui["PosY"].Value := "Y: " pos.Y " pixels"
        this.trackerGui["PosW"].Value := "Width: " pos.Width " pixels"
        this.trackerGui["PosH"].Value := "Height: " pos.Height " pixels"

        ; Calculate velocity if we have history
        if this.positionHistory.Length >= 2 {
            prev := this.positionHistory[-2]
            curr := this.positionHistory[-1]

            dx := curr.X - prev.X
            dy := curr.Y - prev.Y
            dt := curr.Timestamp - prev.Timestamp

            if dt > 0 {
                velocity := Round(Sqrt(dx ** 2 + dy ** 2) / (dt / 1000), 2)
                this.trackerGui["Velocity"].Value := "Velocity: " velocity " px/s"
            }
        }
    }

    /**
     * @method GetStatistics
     * @description Get statistics from tracking history
     * @returns {Object} Position statistics
     */
    static GetStatistics() {
        if this.positionHistory.Length = 0
            return {}

        minX := minY := 999999
        maxX := maxY := -999999
        totalMovement := 0

        for i, pos in this.positionHistory {
            minX := Min(minX, pos.X)
            minY := Min(minY, pos.Y)
            maxX := Max(maxX, pos.X)
            maxY := Max(maxY, pos.Y)

            if i > 1 {
                prev := this.positionHistory[i - 1]
                totalMovement += Sqrt((pos.X - prev.X) ** 2 + (pos.Y - prev.Y) ** 2)
            }
        }

        return {
            MinPosition: { X: minX, Y: minY },
            MaxPosition: { X: maxX, Y: maxY },
            Range: { X: maxX - minX, Y: maxY - minY },
            TotalMovement: Round(totalMovement, 2),
            SampleCount: this.positionHistory.Length
        }
    }
}

; Hotkey: Ctrl+Shift+T - Start tracking active window
^+t:: {
    WindowPositionTracker.StartTracking("A", 100)
}

; ========================================
; Example 4: Save and Restore Window Positions
; ========================================

/**
 * @class WindowPositionManager
 * @description Save and restore window positions across sessions
 */
class WindowPositionManager {
    static savedPositions := Map()
    static configFile := A_ScriptDir "\window_positions.ini"

    /**
     * @method SavePosition
     * @description Save current window position
     * @param WinTitle Window to save
     * @param name Name for this saved position
     * @returns {Boolean} Success status
     */
    static SavePosition(WinTitle := "A", name := "") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)
            windowTitle := WinGetTitle(WinTitle)

            if name = ""
                name := windowTitle

            posData := {
                X: x,
                Y: y,
                Width: width,
                Height: height,
                Title: windowTitle,
                SaveTime: A_Now
            }

            this.savedPositions[name] := posData
            this.WriteToFile(name, posData)

            MsgBox("Position saved: " name, "Position Saved", "Icon!")
            return true

        } catch as err {
            MsgBox("Failed to save position: " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method RestorePosition
     * @description Restore a saved window position
     * @param name Name of saved position
     * @param WinTitle Window to restore (default: active)
     * @returns {Boolean} Success status
     */
    static RestorePosition(name, WinTitle := "A") {
        if !this.savedPositions.Has(name) {
            this.LoadFromFile(name)
        }

        if !this.savedPositions.Has(name) {
            MsgBox("Position '" name "' not found", "Error", "IconX")
            return false
        }

        try {
            pos := this.savedPositions[name]
            WinMove(pos.X, pos.Y, pos.Width, pos.Height, WinTitle)
            MsgBox("Position restored: " name, "Success", "Icon!")
            return true
        } catch as err {
            MsgBox("Failed to restore position: " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method WriteToFile
     * @description Write position to INI file
     * @param name Position name
     * @param posData Position data
     */
    static WriteToFile(name, posData) {
        IniWrite(posData.X, this.configFile, name, "X")
        IniWrite(posData.Y, this.configFile, name, "Y")
        IniWrite(posData.Width, this.configFile, name, "Width")
        IniWrite(posData.Height, this.configFile, name, "Height")
        IniWrite(posData.Title, this.configFile, name, "Title")
        IniWrite(posData.SaveTime, this.configFile, name, "SaveTime")
    }

    /**
     * @method LoadFromFile
     * @description Load position from INI file
     * @param name Position name
     */
    static LoadFromFile(name) {
        try {
            posData := {
                X: Integer(IniRead(this.configFile, name, "X")),
                Y: Integer(IniRead(this.configFile, name, "Y")),
                Width: Integer(IniRead(this.configFile, name, "Width")),
                Height: Integer(IniRead(this.configFile, name, "Height")),
                Title: IniRead(this.configFile, name, "Title"),
                SaveTime: IniRead(this.configFile, name, "SaveTime")
            }
            this.savedPositions[name] := posData
        }
    }

    /**
     * @method ListSaved
     * @description List all saved positions
     * @returns {String} Formatted list
     */
    static ListSaved() {
        if this.savedPositions.Count = 0
            return "No saved positions"

        output := "Saved Window Positions:`n`n"
        for name, pos in this.savedPositions {
            output .= name " - " pos.Width "x" pos.Height " @ (" pos.X "," pos.Y ")`n"
        }
        return output
    }
}

; Hotkey: Ctrl+Alt+S - Save current window position
^!s:: {
    name := InputBox("Enter a name for this position:", "Save Position").Value
    if name != ""
        WindowPositionManager.SavePosition("A", name)
}

; Hotkey: Ctrl+Alt+R - Restore window position
^!r:: {
    list := WindowPositionManager.ListSaved()
    MsgBox(list, "Saved Positions")
    name := InputBox("Enter position name to restore:", "Restore Position").Value
    if name != ""
        WindowPositionManager.RestorePosition(name, "A")
}

; ========================================
; Example 5: Multi-Monitor Position Detector
; ========================================

/**
 * @class MultiMonitorHelper
 * @description Detect window positions relative to multiple monitors
 */
class MultiMonitorHelper {
    /**
     * @method GetMonitorFromWindow
     * @description Determine which monitor a window is on
     * @param WinTitle Window to check
     * @returns {Object} Monitor information
     */
    static GetMonitorFromWindow(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get window center point
            centerX := x + (width // 2)
            centerY := y + (height // 2)

            ; Check each monitor
            monitorCount := MonitorGetCount()

            Loop monitorCount {
                MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)

                if (centerX >= mLeft && centerX < mRight && centerY >= mTop && centerY < mBottom) {
                    MonitorGetWorkArea(A_Index, &wLeft, &wTop, &wRight, &wBottom)

                    return {
                        MonitorNumber: A_Index,
                        MonitorBounds: {
                            Left: mLeft,
                            Top: mTop,
                            Right: mRight,
                            Bottom: mBottom,
                            Width: mRight - mLeft,
                            Height: mBottom - mTop
                        },
                        WorkArea: {
                            Left: wLeft,
                            Top: wTop,
                            Right: wRight,
                            Bottom: wBottom,
                            Width: wRight - wLeft,
                            Height: wBottom - wTop
                        },
                        WindowPosition: {
                            X: x,
                            Y: y,
                            Width: width,
                            Height: height,
                            CenterX: centerX,
                            CenterY: centerY
                        },
                        RelativePosition: {
                            X: x - mLeft,
                            Y: y - mTop,
                            PercentX: Round((centerX - mLeft) / (mRight - mLeft) * 100, 1),
                            PercentY: Round((centerY - mTop) / (mBottom - mTop) * 100, 1)
                        }
                    }
                }
            }

            return { Error: "Window not found on any monitor" }

        } catch as err {
            return { Error: err.Message }
        }
    }

    /**
     * @method GetAllMonitors
     * @description Get information about all monitors
     * @returns {Array} Monitor data
     */
    static GetAllMonitors() {
        monitors := []
        monitorCount := MonitorGetCount()
        primary := MonitorGetPrimary()

        Loop monitorCount {
            MonitorGet(A_Index, &mLeft, &mTop, &mRight, &mBottom)
            MonitorGetWorkArea(A_Index, &wLeft, &wTop, &wRight, &wBottom)

            monitors.Push({
                Number: A_Index,
                IsPrimary: (A_Index = primary),
                Bounds: {
                    Left: mLeft,
                    Top: mTop,
                    Right: mRight,
                    Bottom: mBottom,
                    Width: mRight - mLeft,
                    Height: mBottom - mTop
                },
                WorkArea: {
                    Left: wLeft,
                    Top: wTop,
                    Right: wRight,
                    Bottom: wBottom,
                    Width: wRight - wLeft,
                    Height: wBottom - wTop
                }
            })
        }

        return monitors
    }
}

; Hotkey: Ctrl+Shift+M - Show monitor information for active window
^+m:: {
    info := MultiMonitorHelper.GetMonitorFromWindow("A")

    if info.HasOwnProp("Error") {
        MsgBox(info.Error, "Error", "IconX")
        return
    }

    output := "=== Multi-Monitor Information ===`n`n"
    output .= "Monitor: " info.MonitorNumber "`n"
    output .= "Monitor Size: " info.MonitorBounds.Width "x" info.MonitorBounds.Height "`n"
    output .= "Work Area: " info.WorkArea.Width "x" info.WorkArea.Height "`n`n"
    output .= "Window Position:`n"
    output .= "  Absolute: (" info.WindowPosition.X ", " info.WindowPosition.Y ")`n"
    output .= "  Relative: (" info.RelativePosition.X ", " info.RelativePosition.Y ")`n"
    output .= "  Percent: (" info.RelativePosition.PercentX "%, " info.RelativePosition.PercentY "%)`n"
    output .= "  Size: " info.WindowPosition.Width "x" info.WindowPosition.Height

    MsgBox(output, "Monitor Info", "Icon!")
}

; ========================================
; Example 6: Window Alignment Checker
; ========================================

/**
 * @class WindowAlignment
 * @description Check and enforce window alignment
 */
class WindowAlignment {
    /**
     * @method CheckAlignment
     * @description Check if window is aligned to screen edges or center
     * @param WinTitle Window to check
     * @param threshold Alignment threshold in pixels
     * @returns {Object} Alignment information
     */
    static CheckAlignment(WinTitle := "A", threshold := 10) {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get monitor info
            monitorInfo := MultiMonitorHelper.GetMonitorFromWindow(WinTitle)
            if monitorInfo.HasOwnProp("Error")
                throw Error(monitorInfo.Error)

            work := monitorInfo.WorkArea

            ; Calculate center positions
            winCenterX := x + (width // 2)
            winCenterY := y + (height // 2)
            screenCenterX := work.Left + (work.Width // 2)
            screenCenterY := work.Top + (work.Height // 2)

            ; Check alignments
            alignments := {
                Left: Abs(x - work.Left) <= threshold,
                Right: Abs((x + width) - work.Right) <= threshold,
                Top: Abs(y - work.Top) <= threshold,
                Bottom: Abs((y + height) - work.Bottom) <= threshold,
                CenterX: Abs(winCenterX - screenCenterX) <= threshold,
                CenterY: Abs(winCenterY - screenCenterY) <= threshold,
                Maximized: (width >= work.Width - threshold && height >= work.Height - threshold)
            }

            return {
                Position: { X: x, Y: y, Width: width, Height: height },
                Alignments: alignments,
                Summary: this.GetAlignmentSummary(alignments)
            }

        } catch as err {
            throw Error("Alignment check failed: " err.Message)
        }
    }

    /**
     * @method GetAlignmentSummary
     * @description Create human-readable alignment summary
     * @param alignments Alignment data
     * @returns {String} Summary text
     */
    static GetAlignmentSummary(alignments) {
        aligned := []

        if alignments.Maximized
            return "Maximized"

        if alignments.Left
            aligned.Push("Left")
        if alignments.Right
            aligned.Push("Right")
        if alignments.Top
            aligned.Push("Top")
        if alignments.Bottom
            aligned.Push("Bottom")
        if alignments.CenterX
            aligned.Push("Horizontal Center")
        if alignments.CenterY
            aligned.Push("Vertical Center")

        if aligned.Length = 0
            return "No alignment"

        return "Aligned to: " StrJoin(aligned, ", ")
    }

    /**
     * @method SnapToAlignment
     * @description Snap window to nearest alignment
     * @param WinTitle Window to snap
     * @param snapType Type of snap (left, right, top, bottom, center)
     */
    static SnapToAlignment(WinTitle := "A", snapType := "center") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)
            monitorInfo := MultiMonitorHelper.GetMonitorFromWindow(WinTitle)
            work := monitorInfo.WorkArea

            newX := x
            newY := y

            switch snapType {
                case "left":
                    newX := work.Left
                case "right":
                    newX := work.Right - width
                case "top":
                    newY := work.Top
                case "bottom":
                    newY := work.Bottom - height
                case "center":
                    newX := work.Left + (work.Width - width) // 2
                    newY := work.Top + (work.Height - height) // 2
                case "center-x":
                    newX := work.Left + (work.Width - width) // 2
                case "center-y":
                    newY := work.Top + (work.Height - height) // 2
            }

            WinMove(newX, newY, , , WinTitle)

        } catch as err {
            MsgBox("Snap failed: " err.Message, "Error", "IconX")
        }
    }
}

; Helper function to join array elements
StrJoin(arr, delimiter := ",") {
    result := ""
    for index, value in arr {
        result .= (index > 1 ? delimiter : "") value
    }
    return result
}

; Hotkey: Ctrl+Shift+A - Check window alignment
^+a:: {
    alignment := WindowAlignment.CheckAlignment("A", 10)

    output := "Window Alignment Analysis:`n`n"
    output .= "Position: (" alignment.Position.X ", " alignment.Position.Y ")`n"
    output .= "Size: " alignment.Position.Width "x" alignment.Position.Height "`n`n"
    output .= alignment.Summary

    MsgBox(output, "Alignment Check", "Icon!")
}

; Hotkey: Ctrl+NumpadClear - Center window
^Numpad5:: {
    WindowAlignment.SnapToAlignment("A", "center")
}

; ========================================
; Example 7: Window Bounds Validator
; ========================================

/**
 * @class WindowBoundsValidator
 * @description Validate window positions and ensure windows stay on screen
 */
class WindowBoundsValidator {
    /**
     * @method IsOnScreen
     * @description Check if window is fully visible on screen
     * @param WinTitle Window to check
     * @returns {Object} Validation result
     */
    static IsOnScreen(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get all monitors
            monitors := MultiMonitorHelper.GetAllMonitors()

            ; Check if window intersects with any monitor
            fullyVisible := false
            partiallyVisible := false
            visibleMonitors := []

            for monitor in monitors {
                b := monitor.Bounds

                ; Check for any intersection
                if !(x + width <= b.Left || x >= b.Right || y + height <= b.Top || y >= b.Bottom) {
                    partiallyVisible := true
                    visibleMonitors.Push(monitor.Number)

                    ; Check if fully within this monitor
                    if (x >= b.Left && x + width <= b.Right && y >= b.Top && y + height <= b.Bottom) {
                        fullyVisible := true
                    }
                }
            }

            return {
                FullyVisible: fullyVisible,
                PartiallyVisible: partiallyVisible,
                VisibleMonitors: visibleMonitors,
                Position: { X: x, Y: y, Width: width, Height: height },
                Status: fullyVisible ? "Fully On Screen" : (partiallyVisible ? "Partially On Screen" : "Off Screen")
            }

        } catch as err {
            return { Error: err.Message }
        }
    }

    /**
     * @method ConstrainToScreen
     * @description Move window to ensure it's fully on screen
     * @param WinTitle Window to constrain
     * @returns {Boolean} True if window was moved
     */
    static ConstrainToScreen(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get monitor for this window
            monitorInfo := MultiMonitorHelper.GetMonitorFromWindow(WinTitle)
            if monitorInfo.HasOwnProp("Error") {
                ; Window might be off screen, use primary monitor
                primary := MonitorGetPrimary()
                MonitorGet(primary, &mLeft, &mTop, &mRight, &mBottom)
            } else {
                b := monitorInfo.MonitorBounds
                mLeft := b.Left
                mTop := b.Top
                mRight := b.Right
                mBottom := b.Bottom
            }

            newX := x
            newY := y
            moved := false

            ; Constrain to monitor bounds
            if x < mLeft {
                newX := mLeft
                moved := true
            } else if x + width > mRight {
                newX := mRight - width
                moved := true
            }

            if y < mTop {
                newY := mTop
                moved := true
            } else if y + height > mBottom {
                newY := mBottom - height
                moved := true
            }

            if moved {
                WinMove(newX, newY, , , WinTitle)
            }

            return moved

        } catch as err {
            MsgBox("Constrain failed: " err.Message, "Error", "IconX")
            return false
        }
    }
}

; Hotkey: Ctrl+Shift+V - Validate window bounds
^+v:: {
    result := WindowBoundsValidator.IsOnScreen("A")

    if result.HasOwnProp("Error") {
        MsgBox(result.Error, "Error", "IconX")
        return
    }

    output := "Window Bounds Validation:`n`n"
    output .= "Status: " result.Status "`n"
    output .= "Fully Visible: " (result.FullyVisible ? "Yes" : "No") "`n"
    output .= "Partially Visible: " (result.PartiallyVisible ? "Yes" : "No") "`n"

    if result.VisibleMonitors.Length > 0 {
        output .= "Visible on monitors: "
        for i, mon in result.VisibleMonitors {
            output .= mon (i < result.VisibleMonitors.Length ? ", " : "")
        }
    }

    MsgBox(output, "Bounds Validation", "Icon!")

    ; Offer to constrain if not fully visible
    if !result.FullyVisible {
        response := MsgBox("Window is not fully on screen. Constrain it?", "Constrain?", "YesNo Icon?")
        if response = "Yes" {
            if WindowBoundsValidator.ConstrainToScreen("A") {
                MsgBox("Window has been constrained to screen", "Success", "Icon!")
            }
        }
    }
}

; ========================================
; Script Initialization
; ========================================

; Show help on startup
if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetPos Examples - Hotkeys:

    Ctrl+Shift+P  - Get active window position
    Ctrl+Shift+D  - Show dimension calculator
    Ctrl+Shift+T  - Start position tracking
    Ctrl+Alt+S    - Save window position
    Ctrl+Alt+R    - Restore window position
    Ctrl+Shift+M  - Show monitor information
    Ctrl+Shift+A  - Check window alignment
    Ctrl+Numpad5  - Center window on screen
    Ctrl+Shift+V  - Validate window bounds
    )"

    TrayTip(help, "WinGetPos Examples Ready", "Icon!")
}
