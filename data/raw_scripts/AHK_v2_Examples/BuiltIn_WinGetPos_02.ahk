/**
 * @file BuiltIn_WinGetPos_02.ahk
 * @description Advanced window monitoring and position management examples using WinGetPos in AutoHotkey v2
 * @author AutoHotkey Foundation
 * @version 2.0
 * @date 2024-01-15
 *
 * @section EXAMPLES
 * Example 1: Window position change monitor
 * Example 2: Window size change detector
 * Example 3: Automatic window organizer
 * Example 4: Window collision detector
 * Example 5: Dynamic window grid layout
 * Example 6: Window position history with playback
 *
 * @section FEATURES
 * - Real-time position monitoring
 * - Change detection
 * - Automatic organization
 * - Collision detection
 * - Grid layouts
 * - Position history
 */

#Requires AutoHotkey v2.0

; ========================================
; Example 1: Window Position Change Monitor
; ========================================

/**
 * @class WindowChangeMonitor
 * @description Monitor windows for position and size changes
 */
class WindowChangeMonitor {
    static monitors := Map()
    static checkInterval := 500

    /**
     * @method StartMonitoring
     * @description Begin monitoring a window for changes
     * @param WinTitle Window to monitor
     * @param callback Function to call on change
     */
    static StartMonitoring(WinTitle, callback) {
        try {
            ; Get initial position
            WinGetPos(&x, &y, &width, &height, WinTitle)

            monitorData := {
                WinTitle: WinTitle,
                LastX: x,
                LastY: y,
                LastWidth: width,
                LastHeight: height,
                Callback: callback,
                ChangeCount: 0,
                LastChange: 0
            }

            this.monitors[WinTitle] := monitorData

            ; Start check timer if not already running
            if this.monitors.Count = 1 {
                SetTimer(() => this.CheckAllWindows(), this.checkInterval)
            }

            return true

        } catch as err {
            return false
        }
    }

    /**
     * @method StopMonitoring
     * @description Stop monitoring a window
     * @param WinTitle Window identifier
     */
    static StopMonitoring(WinTitle) {
        this.monitors.Delete(WinTitle)

        if this.monitors.Count = 0 {
            SetTimer(() => this.CheckAllWindows(), 0)
        }
    }

    /**
     * @method CheckAllWindows
     * @description Check all monitored windows for changes
     */
    static CheckAllWindows() {
        for winTitle, data in this.monitors {
            this.CheckWindow(winTitle, data)
        }
    }

    /**
     * @method CheckWindow
     * @description Check a specific window for changes
     * @param WinTitle Window identifier
     * @param data Monitor data
     */
    static CheckWindow(WinTitle, data) {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            changed := false
            changes := {
                Position: false,
                Size: false,
                X: 0,
                Y: 0,
                Width: 0,
                Height: 0
            }

            ; Check for position change
            if x != data.LastX || y != data.LastY {
                changed := true
                changes.Position := true
                changes.X := x - data.LastX
                changes.Y := y - data.LastY
            }

            ; Check for size change
            if width != data.LastWidth || height != data.LastHeight {
                changed := true
                changes.Size := true
                changes.Width := width - data.LastWidth
                changes.Height := height - data.LastHeight
            }

            if changed {
                data.ChangeCount++
                data.LastChange := A_TickCount

                ; Call callback
                data.Callback({
                    WinTitle: WinTitle,
                    Old: {X: data.LastX, Y: data.LastY, Width: data.LastWidth, Height: data.LastHeight},
                    New: {X: x, Y: y, Width: width, Height: height},
                    Changes: changes,
                    ChangeCount: data.ChangeCount
                })

                ; Update stored position
                data.LastX := x
                data.LastY := y
                data.LastWidth := width
                data.LastHeight := height
            }

        } catch {
            ; Window no longer exists
            this.StopMonitoring(WinTitle)
        }
    }
}

; Example callback function
OnWindowChange(changeData) {
    msg := "Window Changed!`n`n"

    if changeData.Changes.Position {
        msg .= "Position: (" changeData.Old.X ", " changeData.Old.Y ") -> "
        msg .= "(" changeData.New.X ", " changeData.New.Y ")`n"
        msg .= "Delta: (" changeData.Changes.X ", " changeData.Changes.Y ")`n`n"
    }

    if changeData.Changes.Size {
        msg .= "Size: " changeData.Old.Width "x" changeData.Old.Height " -> "
        msg .= changeData.New.Width "x" changeData.New.Height "`n"
        msg .= "Delta: " changeData.Changes.Width "x" changeData.Changes.Height
    }

    ToolTip(msg)
    SetTimer(() => ToolTip(), -3000)
}

; Hotkey: Ctrl+Shift+W - Start monitoring active window
^+w:: {
    title := WinGetTitle("A")
    WindowChangeMonitor.StartMonitoring("A", OnWindowChange)
    TrayTip("Now monitoring: " title, "Monitor Started", "Icon!")
}

; ========================================
; Example 2: Window Size Change Detector
; ========================================

/**
 * @class SizeChangeDetector
 * @description Specialized detector for window size changes with history
 */
class SizeChangeDetector {
    static sizeHistory := Map()

    /**
     * @method RecordSize
     * @description Record current window size
     * @param WinTitle Window identifier
     */
    static RecordSize(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            if !this.sizeHistory.Has(WinTitle) {
                this.sizeHistory[WinTitle] := []
            }

            history := this.sizeHistory[WinTitle]
            history.Push({
                Width: width,
                Height: height,
                Area: width * height,
                AspectRatio: Round(width / height, 3),
                Timestamp: A_Now
            })

            ; Keep only last 50 entries
            if history.Length > 50 {
                history.RemoveAt(1)
            }

        } catch as err {
            throw Error("Failed to record size: " err.Message)
        }
    }

    /**
     * @method GetSizeStatistics
     * @description Get statistics about size changes
     * @param WinTitle Window identifier
     * @returns {Object} Size statistics
     */
    static GetSizeStatistics(WinTitle) {
        if !this.sizeHistory.Has(WinTitle) || this.sizeHistory[WinTitle].Length = 0 {
            return {Error: "No size history available"}
        }

        history := this.sizeHistory[WinTitle]

        minWidth := minHeight := 999999
        maxWidth := maxHeight := 0
        totalArea := 0

        for entry in history {
            minWidth := Min(minWidth, entry.Width)
            minHeight := Min(minHeight, entry.Height)
            maxWidth := Max(maxWidth, entry.Width)
            maxHeight := Max(maxHeight, entry.Height)
            totalArea += entry.Area
        }

        current := history[-1]

        return {
            Current: current,
            MinSize: {Width: minWidth, Height: minHeight},
            MaxSize: {Width: maxWidth, Height: maxHeight},
            Range: {Width: maxWidth - minWidth, Height: maxHeight - minHeight},
            AverageArea: Round(totalArea / history.Length),
            SampleCount: history.Length,
            ChangeCount: history.Length - 1
        }
    }

    /**
     * @method DetectPattern
     * @description Detect resize patterns (e.g., repeated sizes)
     * @param WinTitle Window identifier
     * @returns {Object} Pattern analysis
     */
    static DetectPattern(WinTitle) {
        if !this.sizeHistory.Has(WinTitle) {
            return {Error: "No history available"}
        }

        history := this.sizeHistory[WinTitle]
        sizeFrequency := Map()

        ; Count frequency of each size
        for entry in history {
            key := entry.Width "x" entry.Height
            if !sizeFrequency.Has(key) {
                sizeFrequency[key] := {Count: 0, Width: entry.Width, Height: entry.Height}
            }
            sizeFrequency[key].Count++
        }

        ; Find most common size
        mostCommon := {Count: 0}
        for key, data in sizeFrequency {
            if data.Count > mostCommon.Count {
                mostCommon := data
            }
        }

        return {
            UniqueCount: sizeFrequency.Count,
            MostCommon: mostCommon,
            IsStable: (mostCommon.Count / history.Length > 0.7),
            AllSizes: sizeFrequency
        }
    }
}

; Hotkey: Ctrl+Shift+Z - Show size statistics
^+z:: {
    title := "ahk_id " WinExist("A")
    SizeChangeDetector.RecordSize(title)

    stats := SizeChangeDetector.GetSizeStatistics(title)
    if stats.HasOwnProp("Error") {
        MsgBox(stats.Error, "Error", "IconX")
        return
    }

    output := "=== Size Change Statistics ===`n`n"
    output .= "Current: " stats.Current.Width "x" stats.Current.Height "`n"
    output .= "Min Size: " stats.MinSize.Width "x" stats.MinSize.Height "`n"
    output .= "Max Size: " stats.MaxSize.Width "x" stats.MaxSize.Height "`n"
    output .= "Range: " stats.Range.Width "x" stats.Range.Height "`n"
    output .= "Average Area: " stats.AverageArea " sq px`n"
    output .= "Changes Recorded: " stats.ChangeCount

    MsgBox(output, "Size Statistics", "Icon!")
}

; ========================================
; Example 3: Automatic Window Organizer
; ========================================

/**
 * @class WindowOrganizer
 * @description Automatically organize windows on screen
 */
class WindowOrganizer {
    /**
     * @method OrganizeTiled
     * @description Organize windows in a tile layout
     * @param windowList Array of window titles
     */
    static OrganizeTiled(windowList) {
        if windowList.Length = 0
            return

        ; Get work area
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        workWidth := right - left
        workHeight := bottom - top

        ; Calculate grid dimensions
        cols := Ceil(Sqrt(windowList.Length))
        rows := Ceil(windowList.Length / cols)

        tileWidth := workWidth // cols
        tileHeight := workHeight // rows

        ; Position each window
        for index, winTitle in windowList {
            try {
                row := (index - 1) // cols
                col := Mod(index - 1, cols)

                x := left + (col * tileWidth)
                y := top + (row * tileHeight)

                WinMove(x, y, tileWidth, tileHeight, winTitle)
            }
        }
    }

    /**
     * @method OrganizeCascade
     * @description Organize windows in cascade layout
     * @param windowList Array of window titles
     */
    static OrganizeCascade(windowList) {
        if windowList.Length = 0
            return

        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)

        ; Calculate window size (80% of work area)
        winWidth := (right - left) * 0.8
        winHeight := (bottom - top) * 0.8

        ; Cascade offset
        offset := 30

        for index, winTitle in windowList {
            try {
                x := left + ((index - 1) * offset)
                y := top + ((index - 1) * offset)

                WinMove(x, y, winWidth, winHeight, winTitle)
            }
        }
    }

    /**
     * @method OrganizeBySize
     * @description Organize windows by size (largest to smallest)
     * @param windowList Array of window titles
     */
    static OrganizeBySize(windowList) {
        if windowList.Length = 0
            return

        ; Get window sizes
        windowData := []
        for winTitle in windowList {
            try {
                WinGetPos(&x, &y, &width, &height, winTitle)
                windowData.Push({
                    Title: winTitle,
                    Width: width,
                    Height: height,
                    Area: width * height
                })
            }
        }

        ; Sort by area (largest first)
        SortArray(windowData, (a, b) => b.Area - a.Area)

        ; Organize sorted windows
        sortedTitles := []
        for data in windowData {
            sortedTitles.Push(data.Title)
        }

        this.OrganizeTiled(sortedTitles)
    }
}

; Helper function to sort arrays
SortArray(arr, compareFunc) {
    ; Simple bubble sort
    n := arr.Length
    Loop n - 1 {
        i := A_Index
        Loop n - i {
            j := A_Index
            if compareFunc(arr[j], arr[j + 1]) > 0 {
                temp := arr[j]
                arr[j] := arr[j + 1]
                arr[j + 1] := temp
            }
        }
    }
}

; Hotkey: Ctrl+Shift+O - Organize all windows in tile layout
^+o:: {
    windows := WinGetList()
    titles := []

    for id in windows {
        ; Skip invisible and tool windows
        if WinExist("ahk_id " id) {
            style := WinGetStyle("ahk_id " id)
            if (style & 0x10000000) && !(style & 0x08000000) {  ; WS_VISIBLE and not WS_DISABLED
                titles.Push("ahk_id " id)
            }
        }
    }

    if titles.Length > 0 {
        WindowOrganizer.OrganizeTiled(titles)
        TrayTip("Organized " titles.Length " windows", "Organization Complete", "Icon!")
    }
}

; ========================================
; Example 4: Window Collision Detector
; ========================================

/**
 * @class CollisionDetector
 * @description Detect and handle window collisions/overlaps
 */
class CollisionDetector {
    /**
     * @method CheckCollision
     * @description Check if two windows overlap
     * @param WinTitle1 First window
     * @param WinTitle2 Second window
     * @returns {Object} Collision information
     */
    static CheckCollision(WinTitle1, WinTitle2) {
        try {
            WinGetPos(&x1, &y1, &w1, &h1, WinTitle1)
            WinGetPos(&x2, &y2, &w2, &h2, WinTitle2)

            ; Calculate bounds
            left1 := x1
            right1 := x1 + w1
            top1 := y1
            bottom1 := y1 + h1

            left2 := x2
            right2 := x2 + w2
            top2 := y2
            bottom2 := y2 + h2

            ; Check for overlap
            overlapping := !(right1 < left2 || left1 > right2 || bottom1 < top2 || top1 > bottom2)

            result := {
                Overlapping: overlapping,
                Window1: {X: x1, Y: y1, Width: w1, Height: h1},
                Window2: {X: x2, Y: y2, Width: w2, Height: h2}
            }

            if overlapping {
                ; Calculate overlap area
                overlapLeft := Max(left1, left2)
                overlapRight := Min(right1, right2)
                overlapTop := Max(top1, top2)
                overlapBottom := Min(bottom1, bottom2)

                overlapWidth := overlapRight - overlapLeft
                overlapHeight := overlapBottom - overlapTop

                result.Overlap := {
                    X: overlapLeft,
                    Y: overlapTop,
                    Width: overlapWidth,
                    Height: overlapHeight,
                    Area: overlapWidth * overlapHeight,
                    PercentOfWin1: Round((overlapWidth * overlapHeight) / (w1 * h1) * 100, 1),
                    PercentOfWin2: Round((overlapWidth * overlapHeight) / (w2 * h2) * 100, 1)
                }
            }

            return result

        } catch as err {
            return {Error: err.Message}
        }
    }

    /**
     * @method FindAllCollisions
     * @description Find all overlapping windows
     * @returns {Array} List of collisions
     */
    static FindAllCollisions() {
        windows := WinGetList()
        collisions := []

        ; Check each pair of windows
        for i, id1 in windows {
            for j, id2 in windows {
                if i >= j
                    continue

                result := this.CheckCollision("ahk_id " id1, "ahk_id " id2)
                if result.HasOwnProp("Overlapping") && result.Overlapping {
                    collisions.Push({
                        Win1: id1,
                        Win2: id2,
                        OverlapArea: result.Overlap.Area,
                        OverlapPercent: Max(result.Overlap.PercentOfWin1, result.Overlap.PercentOfWin2)
                    })
                }
            }
        }

        return collisions
    }

    /**
     * @method ResolveCollision
     * @description Automatically resolve collision by moving windows
     * @param WinTitle1 First window
     * @param WinTitle2 Second window
     */
    static ResolveCollision(WinTitle1, WinTitle2) {
        try {
            WinGetPos(&x1, &y1, &w1, &h1, WinTitle1)
            WinGetPos(&x2, &y2, &w2, &h2, WinTitle2)

            ; Move second window to the right of first
            newX := x1 + w1 + 20
            WinMove(newX, y2, , , WinTitle2)

        } catch as err {
            throw Error("Failed to resolve collision: " err.Message)
        }
    }
}

; Hotkey: Ctrl+Shift+C - Check for window collisions
^+c:: {
    collisions := CollisionDetector.FindAllCollisions()

    if collisions.Length = 0 {
        MsgBox("No window collisions detected", "Collision Check", "Icon!")
    } else {
        output := "Found " collisions.Length " collision(s):`n`n"

        for index, collision in collisions {
            if index > 5  ; Limit output
                break

            title1 := WinGetTitle("ahk_id " collision.Win1)
            title2 := WinGetTitle("ahk_id " collision.Win2)

            output .= index ". " SubStr(title1, 1, 20) " <-> " SubStr(title2, 1, 20) "`n"
            output .= "   Overlap: " collision.OverlapArea " px² (" collision.OverlapPercent "%)`n`n"
        }

        MsgBox(output, "Collisions Detected", "Icon!")
    }
}

; ========================================
; Example 5: Dynamic Window Grid Layout
; ========================================

/**
 * @class GridLayoutManager
 * @description Manage windows in a dynamic grid layout
 */
class GridLayoutManager {
    static grid := Map()
    static columns := 3
    static rows := 2

    /**
     * @method SetGridSize
     * @description Set grid dimensions
     * @param cols Number of columns
     * @param rows Number of rows
     */
    static SetGridSize(cols, rows) {
        this.columns := cols
        this.rows := rows
    }

    /**
     * @method AssignToCell
     * @description Assign window to specific grid cell
     * @param WinTitle Window identifier
     * @param col Column (1-based)
     * @param row Row (1-based)
     */
    static AssignToCell(WinTitle, col, row) {
        if col < 1 || col > this.columns || row < 1 || row > this.rows {
            throw Error("Invalid grid position")
        }

        ; Get work area
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        workWidth := right - left
        workHeight := bottom - top

        ; Calculate cell dimensions
        cellWidth := workWidth // this.columns
        cellHeight := workHeight // this.rows

        ; Calculate position
        x := left + ((col - 1) * cellWidth)
        y := top + ((row - 1) * cellHeight)

        ; Move window
        WinMove(x, y, cellWidth, cellHeight, WinTitle)

        ; Store assignment
        cellKey := row "," col
        this.grid[cellKey] := WinTitle
    }

    /**
     * @method ShowGrid
     * @description Display grid overlay
     */
    static ShowGrid() {
        MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
        workWidth := right - left
        workHeight := bottom - top

        cellWidth := workWidth // this.columns
        cellHeight := workHeight // this.rows

        ; Create GUI for each cell
        Loop this.rows {
            row := A_Index
            Loop this.columns {
                col := A_Index

                x := left + ((col - 1) * cellWidth)
                y := top + ((row - 1) * cellHeight)

                gui := Gui("+ToolWindow +AlwaysOnTop -Caption +E0x20", "GridCell")
                gui.BackColor := "0x00FF00"
                WinSetTransparent(50, gui)
                gui.Add("Text", "x10 y10 c0xFFFFFF", "Cell " row "," col)
                gui.Show("x" x " y" y " w" cellWidth " h" cellHeight " NoActivate")

                ; Auto-close after 3 seconds
                SetTimer(() => gui.Destroy(), -3000)
            }
        }
    }

    /**
     * @method SnapToGrid
     * @description Snap window to nearest grid cell
     * @param WinTitle Window identifier
     */
    static SnapToGrid(WinTitle := "A") {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            ; Get work area
            MonitorGetWorkArea(MonitorGetPrimary(), &left, &top, &right, &bottom)
            workWidth := right - left
            workHeight := bottom - top

            cellWidth := workWidth // this.columns
            cellHeight := workHeight // this.rows

            ; Find nearest cell
            centerX := x + (width // 2)
            centerY := y + (height // 2)

            col := Ceil((centerX - left) / cellWidth)
            row := Ceil((centerY - top) / cellHeight)

            ; Constrain to grid
            col := Max(1, Min(col, this.columns))
            row := Max(1, Min(row, this.rows))

            ; Assign to cell
            this.AssignToCell(WinTitle, col, row)

        } catch as err {
            MsgBox("Snap failed: " err.Message, "Error", "IconX")
        }
    }
}

; Hotkey: Ctrl+Shift+G - Show grid layout
^+g:: {
    GridLayoutManager.ShowGrid()
}

; Hotkey: Ctrl+Shift+S - Snap active window to grid
^+s:: {
    GridLayoutManager.SnapToGrid("A")
}

; ========================================
; Example 6: Window Position History with Playback
; ========================================

/**
 * @class PositionHistory
 * @description Record and playback window position changes
 */
class PositionHistory {
    static recordings := Map()
    static isRecording := false
    static currentRecording := ""
    static recordTimer := 0

    /**
     * @method StartRecording
     * @description Begin recording window positions
     * @param WinTitle Window to record
     * @param name Recording name
     */
    static StartRecording(WinTitle, name := "Recording") {
        this.currentRecording := name
        this.recordings[name] := {
            WinTitle: WinTitle,
            Frames: [],
            StartTime: A_TickCount
        }

        this.isRecording := true
        this.recordTimer := SetTimer(() => this.RecordFrame(WinTitle, name), 100)

        TrayTip("Recording started: " name, "Position Recorder", "Icon!")
    }

    /**
     * @method StopRecording
     * @description Stop recording
     */
    static StopRecording() {
        if !this.isRecording
            return

        this.isRecording := false
        if this.recordTimer {
            SetTimer(this.recordTimer, 0)
            this.recordTimer := 0
        }

        recording := this.recordings[this.currentRecording]
        duration := (A_TickCount - recording.StartTime) / 1000

        TrayTip("Recording stopped: " recording.Frames.Length " frames, " Round(duration, 1) "s", "Position Recorder", "Icon!")
    }

    /**
     * @method RecordFrame
     * @description Record a single frame
     * @param WinTitle Window identifier
     * @param name Recording name
     */
    static RecordFrame(WinTitle, name) {
        try {
            WinGetPos(&x, &y, &width, &height, WinTitle)

            recording := this.recordings[name]
            recording.Frames.Push({
                X: x,
                Y: y,
                Width: width,
                Height: height,
                Time: A_TickCount - recording.StartTime
            })

        } catch {
            ; Window closed
            this.StopRecording()
        }
    }

    /**
     * @method PlaybackRecording
     * @description Playback recorded positions
     * @param name Recording name
     * @param WinTitle Target window
     * @param speed Playback speed (1.0 = normal)
     */
    static PlaybackRecording(name, WinTitle := "A", speed := 1.0) {
        if !this.recordings.Has(name) {
            MsgBox("Recording '" name "' not found", "Error", "IconX")
            return
        }

        recording := this.recordings[name]
        frames := recording.Frames

        if frames.Length = 0
            return

        TrayTip("Playing back: " name, "Position Playback", "Icon!")

        ; Playback each frame
        startTime := A_TickCount
        for index, frame in frames {
            ; Calculate when to show this frame
            targetTime := frame.Time / speed
            currentTime := A_TickCount - startTime

            ; Wait if we're ahead
            if currentTime < targetTime {
                Sleep(targetTime - currentTime)
            }

            ; Move window
            try {
                WinMove(frame.X, frame.Y, frame.Width, frame.Height, WinTitle)
            } catch {
                break
            }
        }

        TrayTip("Playback complete", "Position Playback", "Icon!")
    }
}

; Hotkey: Ctrl+Shift+R - Start/Stop recording
^+r:: {
    if !PositionHistory.isRecording {
        name := InputBox("Enter recording name:", "Start Recording", "w300", "MyRecording").Value
        if name != "" {
            PositionHistory.StartRecording("A", name)
        }
    } else {
        PositionHistory.StopRecording()
    }
}

; Hotkey: Ctrl+Shift+P - Playback recording
^+b:: {
    name := InputBox("Enter recording name to playback:", "Playback").Value
    if name != "" {
        PositionHistory.PlaybackRecording(name, "A", 1.0)
    }
}

; ========================================
; Script Initialization
; ========================================

; Show help on startup
if A_Args.Length = 0 && !A_IsCompiled {
    help := "
    (
    WinGetPos Advanced Examples - Hotkeys:

    Ctrl+Shift+W  - Monitor window changes
    Ctrl+Shift+Z  - Show size statistics
    Ctrl+Shift+O  - Organize windows (tile)
    Ctrl+Shift+C  - Check collisions
    Ctrl+Shift+G  - Show grid layout
    Ctrl+Shift+S  - Snap to grid
    Ctrl+Shift+R  - Record/Stop position
    Ctrl+Shift+B  - Playback recording
    )"

    TrayTip(help, "WinGetPos Advanced Ready", "Icon!")
}
