#Requires AutoHotkey v2.0
/**
#SingleInstance Force
 * @file BuiltIn_WinGetPos_03.ahk
 * @description Window alignment, snapping, and smart positioning examples using WinGetPos in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 * 
 * @section EXAMPLES
 * Example 1: Smart window snapping system
 * Example 2: Magnetic window edges
 * Example 3: Window docking system
 * Example 4: Proportional window sizing
 * Example 5: Window aspect ratio manager
 * Example 6: Virtual desktop zones
 * Example 7: Window position presets
 * 
 * @section FEATURES
 * - Smart snapping
 * - Magnetic edges
 * - Docking system
 * - Proportional sizing
 * - Aspect ratio control
 * - Desktop zones
 * - Position presets
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Smart Window Snapping System
; ========================================

/**
 * @class SmartSnap
 * @description Intelligent window snapping with edge detection
 */
class SmartSnap {
    static snapThreshold := 20  ; Pixels for snap detection
    static enabled := true

    /**
     * @method SnapToEdges
     * @description Snap window to screen edges if close enough
     * @param WinTitle Window identifier
     * @returns {Boolean} True if snapped
     */
    static SnapToEdges(WinTitle := "A") {
        if !this.enabled
            return false

        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get work area
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            newX := x
            newY := y
            snapped := false

            ; Check left edge
            if Abs(x - left) <= this.snapThreshold {
                newX := left
                snapped := true
            }

            ; Check right edge
            if Abs((x + width) - right) <= this.snapThreshold {
                newX := right - width
                snapped := true
            }

            ; Check top edge
            if Abs(y - top) <= this.snapThreshold {
                newY := top
                snapped := true
            }

            ; Check bottom edge
            if Abs((y + height) - bottom) <= this.snapThreshold {
                newY := bottom - height
                snapped := true
            }

            if snapped {
                WinMove(newX, newY, , , WinTitle)
            }

            return snapped

        } catch as err {
            return false
        }
    }

    /**
     * @method SnapToWindow
     * @description Snap one window to another window's edges
     * @param SourceWin Window to snap
     * @param TargetWin Window to snap to
     * @returns {Boolean} True if snapped
     */
    static SnapToWindow(SourceWin, TargetWin) {
        try {
            WinGetPos(&sx, &sy, &sw, &sh, SourceWin)
            WinGetPos(&tx, &ty, &tw, &th, TargetWin)

            newX := sx
            newY := sy
            snapped := false

            ; Check snap to left edge of target
            if Abs(sx - tx) <= this.snapThreshold {
                newX := tx
                snapped := true
            }

            ; Check snap to right edge of target
            if Abs(sx - (tx + tw)) <= this.snapThreshold {
                newX := tx + tw
                snapped := true
            }

            ; Check snap to top edge of target
            if Abs(sy - ty) <= this.snapThreshold {
                newY := ty
                snapped := true
            }

            ; Check snap to bottom edge of target
            if Abs(sy - (ty + th)) <= this.snapThreshold {
                newY := ty + th
                snapped := true
            }

            if snapped {
                WinMove(newX, newY, , , SourceWin)
            }

            return snapped

        } catch as err {
            return false
        }
    }

    /**
     * @method QuickSnap
     * @description Snap window to predefined positions
     * @param WinTitle Window identifier
     * @param position Position name (left, right, top, bottom, etc.)
     */
    static QuickSnap(WinTitle := "A", position := "left") {
        try {
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
            WinGetPos(&x, &y, &width, &height, WinTitle)

            workWidth := right - left
            workHeight := bottom - top

            switch position {
                case "left":
                    WinMove(left, top, workWidth // 2, workHeight, WinTitle)
                case "right":
                    WinMove(left + workWidth // 2, top, workWidth // 2, workHeight, WinTitle)
                case "top":
                    WinMove(left, top, workWidth, workHeight // 2, WinTitle)
                case "bottom":
                    WinMove(left, top + workHeight // 2, workWidth, workHeight // 2, WinTitle)
                case "topleft":
                    WinMove(left, top, workWidth // 2, workHeight // 2, WinTitle)
                case "topright":
                    WinMove(left + workWidth // 2, top, workWidth // 2, workHeight // 2, WinTitle)
                case "bottomleft":
                    WinMove(left, top + workHeight // 2, workWidth // 2, workHeight // 2, WinTitle)
                case "bottomright":
                    WinMove(left + workWidth // 2, top + workHeight // 2, workWidth // 2, workHeight // 2, WinTitle)
                case "center":
                    WinMove(left + (workWidth - width) // 2, top + (workHeight - height) // 2, , , WinTitle)
                case "maximize":
                    WinMove(left, top, workWidth, workHeight, WinTitle)
            }

        } catch as err {
            MsgBox("Snap failed: " err.Message, "Error", "IconX")
        }
    }
}

; Hotkey: Win+Left - Snap left
#Left:: SmartSnap.QuickSnap("A", "left")

; Hotkey: Win+Right - Snap right
#Right:: SmartSnap.QuickSnap("A", "right")

; Hotkey: Win+Up - Snap top
#Up:: SmartSnap.QuickSnap("A", "top")

; Hotkey: Win+Down - Snap bottom
#Down:: SmartSnap.QuickSnap("A", "bottom")

; ========================================
; Example 2: Magnetic Window Edges
; ========================================

/**
 * @class MagneticEdges
 * @description Windows automatically snap when moved close to edges
 */
class MagneticEdges {
    static active := false
    static magneticStrength := 30
    static checkTimer := 0
    static monitoredWindow := ""

    /**
     * @method Enable
     * @description Enable magnetic edges for a window
     * @param WinTitle Window identifier
     */
    static Enable(WinTitle := "A") {
        this.monitoredWindow := "ahk_id " WinExist(WinTitle)
        this.active := true
        this.checkTimer := SetTimer(() => this.CheckPosition(), 50)
        TrayTip("Magnetic edges enabled", "Magnetic Mode", "Icon!")
    }

    /**
     * @method Disable
     * @description Disable magnetic edges
     */
    static Disable() {
        this.active := false
        if this.checkTimer {
            SetTimer(this.checkTimer, 0)
            this.checkTimer := 0
        }
        TrayTip("Magnetic edges disabled", "Magnetic Mode", "Icon!")
    }

    /**
     * @method CheckPosition
     * @description Check and apply magnetic effect
     */
    static CheckPosition() {
        if !this.active
            return

        try {
            ; Only apply when window is being moved
            if !GetKeyState("LButton", "P")
                return

            WinGetPos(&x, &y, &width, &height, this.monitoredWindow)

            ; Get work area
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            newX := x
            newY := y
            magnetic := false

            ; Apply magnetic force to edges
            distLeft := Abs(x - left)
            if distLeft > 0 && distLeft <= this.magneticStrength {
                newX := left
                magnetic := true
            }

            distRight := Abs((x + width) - right)
            if distRight > 0 && distRight <= this.magneticStrength {
                newX := right - width
                magnetic := true
            }

            distTop := Abs(y - top)
            if distTop > 0 && distTop <= this.magneticStrength {
                newY := top
                magnetic := true
            }

            distBottom := Abs((y + height) - bottom)
            if distBottom > 0 && distBottom <= this.magneticStrength {
                newY := bottom - height
                magnetic := true
            }

            if magnetic {
                WinMove(newX, newY, , , this.monitoredWindow)
            }

        } catch {
            this.Disable()
        }
    }

    /**
     * @method SetStrength
     * @description Set magnetic strength
     * @param pixels Magnetic distance in pixels
     */
    static SetStrength(pixels) {
        this.magneticStrength := pixels
    }
}

; Hotkey: Ctrl+Shift+M - Toggle magnetic edges
^+m:: {
    if !MagneticEdges.active {
        MagneticEdges.Enable("A")
    } else {
        MagneticEdges.Disable()
    }
}

; ========================================
; Example 3: Window Docking System
; ========================================

/**
 * @class WindowDock
 * @description Dock windows to screen edges with spacing
 */
class WindowDock {
    static dockedWindows := Map()
    static dockSpacing := 5

    /**
     * @method DockWindow
     * @description Dock window to specified edge
     * @param WinTitle Window identifier
     * @param edge Edge to dock to (left, right, top, bottom)
     * @param size Size of docked window (percentage or pixels)
     */
    static DockWindow(WinTitle := "A", edge := "left", size := 30) {
        try {
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            workWidth := right - left
            workHeight := bottom - top

            ; Calculate size
            if size <= 100 {  ; Percentage
                sizePixels := edge = "left" || edge = "right" ? (workWidth * size / 100) : (workHeight * size / 100)
            } else {  ; Absolute pixels
                sizePixels := size
            }

            ; Calculate position and size based on edge
            switch edge {
                case "left":
                    WinMove(left, top, sizePixels, workHeight, WinTitle)
                case "right":
                    WinMove(right - sizePixels, top, sizePixels, workHeight, WinTitle)
                case "top":
                    WinMove(left, top, workWidth, sizePixels, WinTitle)
                case "bottom":
                    WinMove(left, bottom - sizePixels, workWidth, sizePixels, WinTitle)
            }

            ; Store dock info
            winId := "ahk_id " WinExist(WinTitle)
            this.dockedWindows[winId] := {
                Edge: edge,
                Size: sizePixels,
                DockTime: A_TickCount
            }

            return true

        } catch as err {
            MsgBox("Dock failed: " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method UndockWindow
     * @description Remove window from dock
     * @param WinTitle Window identifier
     */
    static UndockWindow(WinTitle := "A") {
        winId := "ahk_id " WinExist(WinTitle)
        if this.dockedWindows.Has(winId) {
            this.dockedWindows.Delete(winId)
            TrayTip("Window undocked", "Dock System", "Icon!")
        }
    }

    /**
     * @method ArrangeWithDock
     * @description Arrange remaining windows around docked windows
     * @param WinTitle Window to arrange
     */
    static ArrangeWithDock(WinTitle := "A") {
        try {
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            workLeft := left
            workTop := top
            workRight := right
            workBottom := bottom

            ; Adjust for docked windows
            for winId, dockInfo in this.dockedWindows {
                if !WinExist(winId)
                    continue

                switch dockInfo.Edge {
                    case "left":
                        workLeft += dockInfo.Size + this.dockSpacing
                    case "right":
                        workRight -= dockInfo.Size + this.dockSpacing
                    case "top":
                        workTop += dockInfo.Size + this.dockSpacing
                    case "bottom":
                        workBottom -= dockInfo.Size + this.dockSpacing
                }
            }

            ; Position window in remaining space
            workWidth := workRight - workLeft
            workHeight := workBottom - workTop

            WinMove(workLeft, workTop, workWidth, workHeight, WinTitle)

        } catch as err {
            MsgBox("Arrange failed: " err.Message, "Error", "IconX")
        }
    }
}

; Hotkey: Ctrl+Alt+Left - Dock window to left
^!Left:: WindowDock.DockWindow("A", "left", 30)

; Hotkey: Ctrl+Alt+Right - Dock window to right
^!Right:: WindowDock.DockWindow("A", "right", 30)

; ========================================
; Example 4: Proportional Window Sizing
; ========================================

/**
 * @class ProportionalSize
 * @description Resize windows proportionally to screen size
 */
class ProportionalSize {
    /**
     * @method SetProportional
     * @description Set window size as percentage of screen
     * @param WinTitle Window identifier
     * @param widthPercent Width percentage (0-100)
     * @param heightPercent Height percentage (0-100)
     * @param center Center window after resize
     */
    static SetProportional(WinTitle := "A", widthPercent := 80, heightPercent := 80, center := true) {
        try {
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            workWidth := right - left
            workHeight := bottom - top

            newWidth := Integer(workWidth * widthPercent / 100)
            newHeight := Integer(workHeight * heightPercent / 100)

            if center {
                newX := left + (workWidth - newWidth) // 2
                newY := top + (workHeight - newHeight) // 2
                WinMove(newX, newY, newWidth, newHeight, WinTitle)
            } else {
                WinGetPos(&x, &y, , , WinTitle)
                WinMove(x, y, newWidth, newHeight, WinTitle)
            }

        } catch as err {
            MsgBox("Resize failed: " err.Message, "Error", "IconX")
        }
    }

    /**
     * @method GetProportions
     * @description Get current window size as percentage of screen
     * @param WinTitle Window identifier
     * @returns {Object} Width and height percentages
     */
    static GetProportions(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            workWidth := right - left
            workHeight := bottom - top

            return {
                WidthPercent: Round(width / workWidth * 100, 1),
                HeightPercent: Round(height / workHeight * 100, 1),
                XPercent: Round((x - left) / workWidth * 100, 1),
                YPercent: Round((y - top) / workHeight * 100, 1)
            }

        } catch as err {
            return { Error: err.Message }
        }
    }

    /**
     * @method ScaleRelative
     * @description Scale window by relative amount
     * @param WinTitle Window identifier
     * @param scaleFactor Scale factor (1.0 = 100%, 1.5 = 150%)
     */
    static ScaleRelative(WinTitle := "A", scaleFactor := 1.1) {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            newWidth := Integer(width * scaleFactor)
            newHeight := Integer(height * scaleFactor)

            ; Keep center point the same
            centerX := x + width // 2
            centerY := y + height // 2

            newX := centerX - newWidth // 2
            newY := centerY - newHeight // 2

            WinMove(newX, newY, newWidth, newHeight, WinTitle)

        } catch as err {
            MsgBox("Scale failed: " err.Message, "Error", "IconX")
        }
    }
}

; Hotkey: Ctrl+Shift+Plus - Scale window up
^+=:: ProportionalSize.ScaleRelative("A", 1.1)

; Hotkey: Ctrl+Shift+Minus - Scale window down
^+-:: ProportionalSize.ScaleRelative("A", 0.9)

; ========================================
; Example 5: Window Aspect Ratio Manager
; ========================================

/**
 * @class AspectRatioManager
 * @description Maintain or set window aspect ratios
 */
class AspectRatioManager {
    static lockedRatio := 0
    static lockedWindow := ""

    /**
     * @method LockAspectRatio
     * @description Lock current window aspect ratio
     * @param WinTitle Window identifier
     */
    static LockAspectRatio(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            this.lockedRatio := width / height
            this.lockedWindow := "ahk_id " WinExist(WinTitle)

            TrayTip("Aspect ratio locked: " Round(this.lockedRatio, 2) ":1", "Aspect Ratio", "Icon!")

        } catch as err {
            MsgBox("Lock failed: " err.Message, "Error", "IconX")
        }
    }

    /**
     * @method UnlockAspectRatio
     * @description Unlock aspect ratio
     */
    static UnlockAspectRatio() {
        this.lockedRatio := 0
        this.lockedWindow := ""
        TrayTip("Aspect ratio unlocked", "Aspect Ratio", "Icon!")
    }

    /**
     * @method SetAspectRatio
     * @description Set specific aspect ratio
     * @param WinTitle Window identifier
     * @param ratio Aspect ratio (width/height) or preset name
     */
    static SetAspectRatio(WinTitle := "A", ratio := "16:9") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Parse ratio
            numericRatio := 0
            if IsNumber(ratio) {
                numericRatio := ratio
            } else {
                ; Parse ratio string (e.g., "16:9")
                parts := StrSplit(ratio, ":")
                if parts.Length = 2 {
                    numericRatio := Float(parts[1]) / Float(parts[2])
                } else {
                    ; Preset ratios
                    switch ratio {
                        case "square": numericRatio := 1.0
                        case "widescreen": numericRatio := 16 / 9
                        case "ultrawide": numericRatio := 21 / 9
                        case "cinema": numericRatio := 2.39
                        case "standard": numericRatio := 4 / 3
                        case "portrait": numericRatio := 9 / 16
                        default: numericRatio := 16 / 9
                    }
                }
            }

            ; Calculate new dimensions maintaining area
            area := width * height
            newWidth := Sqrt(area * numericRatio)
            newHeight := newWidth / numericRatio

            ; Center the resized window
            centerX := x + width // 2
            centerY := y + height // 2

            newX := centerX - newWidth // 2
            newY := centerY - newHeight // 2

            WinMove(Integer(newX), Integer(newY), Integer(newWidth), Integer(newHeight), WinTitle)

        } catch as err {
            MsgBox("Set aspect ratio failed: " err.Message, "Error", "IconX")
        }
    }

    /**
     * @method ResizeKeepingRatio
     * @description Resize window while maintaining aspect ratio
     * @param WinTitle Window identifier
     * @param dimension Which dimension to change (width or height)
     * @param size New size for that dimension
     */
    static ResizeKeepingRatio(WinTitle := "A", dimension := "width", size := 1000) {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ratio := width / height

            if dimension = "width" {
                newWidth := size
                newHeight := size / ratio
            } else {
                newHeight := size
                newWidth := size * ratio
            }

            WinMove(x, y, Integer(newWidth), Integer(newHeight), WinTitle)

        } catch as err {
            MsgBox("Resize failed: " err.Message, "Error", "IconX")
        }
    }
}

; Hotkey: Ctrl+Shift+L - Lock aspect ratio
^+l:: AspectRatioManager.LockAspectRatio("A")

; Hotkey: Ctrl+Shift+U - Unlock aspect ratio
^+u:: AspectRatioManager.UnlockAspectRatio()

; ========================================
; Example 6: Virtual Desktop Zones
; ========================================

/**
 * @class VirtualZones
 * @description Create virtual zones on desktop for window organization
 */
class VirtualZones {
    static zones := []
    static zoneOverlay := []

    /**
     * @method DefineZone
     * @description Define a new zone
     * @param name Zone name
     * @param x X position (pixels or percentage)
     * @param y Y position (pixels or percentage)
     * @param width Width (pixels or percentage)
     * @param height Height (pixels or percentage)
     */
    static DefineZone(name, x, y, width, height) {
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

        workWidth := right - left
        workHeight := bottom - top

        ; Convert percentages to pixels
        if x <= 1.0
            x := left + Integer(workWidth * x)
        if y <= 1.0
            y := top + Integer(workHeight * y)
        if width <= 1.0
            width := Integer(workWidth * width)
        if height <= 1.0
            height := Integer(workHeight * height)

        this.zones.Push({
            Name: name,
            X: x,
            Y: y,
            Width: width,
            Height: height,
            Windows: []
        })

        return this.zones.Length
    }

    /**
     * @method MoveToZone
     * @description Move window to specified zone
     * @param WinTitle Window identifier
     * @param zoneName Zone name or index
     */
    static MoveToZone(WinTitle := "A", zoneName := 1) {
        zone := ""

        ; Find zone
        if IsNumber(zoneName) {
            if zoneName >= 1 && zoneName <= this.zones.Length {
                zone := this.zones[zoneName]
            }
        } else {
            for z in this.zones {
                if z.Name = zoneName {
                    zone := z
                    break
                }
            }
        }

        if zone = "" {
            MsgBox("Zone not found: " zoneName, "Error", "IconX")
            return
        }

        try {
            WinMove(zone.X, zone.Y, zone.Width, zone.Height, WinTitle)

            ; Add window to zone's window list
            winId := "ahk_id " WinExist(WinTitle)
            if !HasValue(zone.Windows, winId) {
                zone.Windows.Push(winId)
            }

        } catch as err {
            MsgBox("Move to zone failed: " err.Message, "Error", "IconX")
        }
    }

    /**
     * @method ShowZones
     * @description Display zone overlay
     * @param duration Duration to show in milliseconds (0 = permanent)
     */
    static ShowZones(duration := 3000) {
        this.HideZones()

        for index, zone in this.zones {
            gui := Gui("+ToolWindow +AlwaysOnTop -Caption +E0x20", "Zone" index)
            gui.BackColor := "0x0078D7"
            WinSetTransparent(80, gui)

            gui.Add("Text", "x10 y10 c0xFFFFFF w200", "Zone: " zone.Name)
            gui.Add("Text", "x10 y30 c0xFFFFFF w200", zone.Width "x" zone.Height)

            gui.Show("x" zone.X " y" zone.Y " w" zone.Width " h" zone.Height " NoActivate")

            this.zoneOverlay.Push(gui)
        }

        if duration > 0 {
            SetTimer(() => this.HideZones(), -duration)
        }
    }

    /**
     * @method HideZones
     * @description Hide zone overlay
     */
    static HideZones() {
        for gui in this.zoneOverlay {
            try gui.Destroy()
        }
        this.zoneOverlay := []
    }

    /**
     * @method CreateDefaultZones
     * @description Create a default set of zones
     */
    static CreateDefaultZones() {
        this.zones := []

        ; Left half
        this.DefineZone("Left", 0, 0, 0.5, 1.0)

        ; Right half
        this.DefineZone("Right", 0.5, 0, 0.5, 1.0)

        ; Top half
        this.DefineZone("Top", 0, 0, 1.0, 0.5)

        ; Bottom half
        this.DefineZone("Bottom", 0, 0.5, 1.0, 0.5)

        ; Center
        this.DefineZone("Center", 0.2, 0.2, 0.6, 0.6)

        ; Quadrants
        this.DefineZone("TopLeft", 0, 0, 0.5, 0.5)
        this.DefineZone("TopRight", 0.5, 0, 0.5, 0.5)
        this.DefineZone("BottomLeft", 0, 0.5, 0.5, 0.5)
        this.DefineZone("BottomRight", 0.5, 0.5, 0.5, 0.5)

        TrayTip("Created " this.zones.Length " default zones", "Virtual Zones", "Icon!")
    }
}

; Helper function
HasValue(arr, value) {
    for item in arr {
        if item = value
            return true
    }
    return false
}

; Initialize default zones
VirtualZones.CreateDefaultZones()

; Hotkey: Ctrl+Shift+1-9 - Move to zone
^+1:: VirtualZones.MoveToZone("A", 1)
^+2:: VirtualZones.MoveToZone("A", 2)
^+3:: VirtualZones.MoveToZone("A", 3)
^+4:: VirtualZones.MoveToZone("A", 4)
^+5:: VirtualZones.MoveToZone("A", 5)

; Hotkey: Ctrl+Shift+Z - Show zones
^+z:: VirtualZones.ShowZones(5000)

; ========================================
; Example 7: Window Position Presets
; ========================================

/**
 * @class PositionPresets
 * @description Save and apply window position presets
 */
class PositionPresets {
    static presets := Map()

    /**
     * @method SavePreset
     * @description Save current window position as preset
     * @param WinTitle Window identifier
     * @param name Preset name
     */
    static SavePreset(WinTitle := "A", name := "Default") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get monitor info for relative positioning
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

            workWidth := right - left
            workHeight := bottom - top

            preset := {
                Name: name,
                Absolute: { X: x, Y: y, Width: width, Height: height },
                Relative: {
                    XPercent: (x - left) / workWidth,
                    YPercent: (y - top) / workHeight,
                    WidthPercent: width / workWidth,
                    HeightPercent: height / workHeight
                },
                SaveTime: A_Now,
                Monitor: MonitorGetPrimary()
            }

            this.presets[name] := preset

            TrayTip("Preset saved: " name, "Position Presets", "Icon!")
            return true

        } catch as err {
            MsgBox("Save preset failed: " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method ApplyPreset
     * @description Apply saved preset to window
     * @param WinTitle Window identifier
     * @param name Preset name
     * @param useRelative Use relative positioning
     */
    static ApplyPreset(WinTitle := "A", name := "Default", useRelative := true) {
        if !this.presets.Has(name) {
            MsgBox("Preset not found: " name, "Error", "IconX")
            return false
        }

        preset := this.presets[name]

        try {
            if useRelative {
                ; Use relative positioning (adapts to screen size)
                MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

                workWidth := right - left
                workHeight := bottom - top

                x := left + Integer(workWidth * preset.Relative.XPercent)
                y := top + Integer(workHeight * preset.Relative.YPercent)
                width := Integer(workWidth * preset.Relative.WidthPercent)
                height := Integer(workHeight * preset.Relative.HeightPercent)

                WinMove(x, y, width, height, WinTitle)
            } else {
                ; Use absolute positioning
                WinMove(preset.Absolute.X, preset.Absolute.Y,
                    preset.Absolute.Width, preset.Absolute.Height, WinTitle)
            }

            TrayTip("Preset applied: " name, "Position Presets", "Icon!")
            return true

        } catch as err {
            MsgBox("Apply preset failed: " err.Message, "Error", "IconX")
            return false
        }
    }

    /**
     * @method ListPresets
     * @description List all saved presets
     * @returns {String} Formatted list
     */
    static ListPresets() {
        if this.presets.Count = 0
            return "No presets saved"

        output := "Saved Position Presets:`n`n"

        for name, preset in this.presets {
            output .= name ": "
            output .= preset.Absolute.Width "x" preset.Absolute.Height
            output .= " @ (" preset.Absolute.X "," preset.Absolute.Y ")`n"
        }

        return output
    }

    /**
     * @method DeletePreset
     * @description Delete a saved preset
     * @param name Preset name
     */
    static DeletePreset(name) {
        if this.presets.Has(name) {
            this.presets.Delete(name)
            TrayTip("Preset deleted: " name, "Position Presets", "Icon!")
            return true
        }
        return false
    }
}

; Hotkey: Ctrl+Alt+S - Save position preset
^!s:: {
    name := InputBox("Enter preset name:", "Save Preset", "w300").Value
    if name != ""
        PositionPresets.SavePreset("A", name)
}

; Hotkey: Ctrl+Alt+L - Load position preset
^!l:: {
    list := PositionPresets.ListPresets()
    MsgBox(list, "Saved Presets", "Icon!")

    name := InputBox("Enter preset name to load:", "Load Preset", "w300").Value
    if name != ""
        PositionPresets.ApplyPreset("A", name, true)
}

; ========================================
; Script Initialization
; ========================================

; Show help on startup
if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetPos Alignment Examples - Hotkeys:

    Win+Arrow Keys    - Quick snap (left/right/top/bottom)
    Ctrl+Shift+M      - Toggle magnetic edges
    Ctrl+Alt+Arrows   - Dock window
    Ctrl+Shift+Plus   - Scale window up
    Ctrl+Shift+Minus  - Scale window down
    Ctrl+Shift+L      - Lock aspect ratio
    Ctrl+Shift+1-5    - Move to zone
    Ctrl+Shift+Z      - Show zones
    Ctrl+Alt+S        - Save preset
    Ctrl+Alt+L        - Load preset
    )"

    TrayTip(help, "WinGetPos Alignment Ready", "Icon!")
}
