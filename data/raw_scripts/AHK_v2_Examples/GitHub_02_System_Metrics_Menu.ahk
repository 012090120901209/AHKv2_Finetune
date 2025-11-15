#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * System Metrics Quick Launch Menu
 *
 * Demonstrates a quick launch menu with real-time system metrics
 * (CPU, RAM, Battery) triggered by double-tapping Shift.
 *
 * Source: JWCow/AHK-Collection - Windows AHK Startup Keys V2
 * Inspired by: https://github.com/JWCow/AHK-Collection
 */

; Configuration
global DOUBLE_TAP_THRESHOLD := 300  ; milliseconds
global lastShiftPress := 0

MsgBox("System Metrics Quick Launch`n`n"
     . "Double-tap RIGHT SHIFT to open menu`n`n"
     . "Features:`n"
     . "- Real-time CPU usage`n"
     . "- Memory usage (RAM)`n"
     . "- Battery status`n"
     . "- Quick launch buttons`n`n"
     . "Try double-tapping Right Shift!", , "T5")

; ===============================================
; DOUBLE-TAP SHIFT DETECTION
; ===============================================

/**
 * Detect double-tap of Right Shift key
 */
~RShift::
{
    global lastShiftPress, DOUBLE_TAP_THRESHOLD

    currentTime := A_TickCount

    ; Check if this is a double-tap
    if (currentTime - lastShiftPress < DOUBLE_TAP_THRESHOLD) {
        ShowQuickLaunchMenu()
        lastShiftPress := 0  ; Reset to prevent triple-tap
    } else {
        lastShiftPress := currentTime
    }
}

; ===============================================
; QUICK LAUNCH MENU
; ===============================================

/**
 * Show quick launch menu with system metrics
 */
ShowQuickLaunchMenu() {
    ; Create GUI
    menuGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Quick Launch")
    menuGui.BackColor := "0x1E1E1E"
    menuGui.SetFont("s10 cWhite", "Segoe UI")

    ; Title
    menuGui.Add("Text", "w400 Center", "⚡ QUICK LAUNCH MENU").SetFont("s14 Bold")

    ; System Metrics Section
    menuGui.Add("Text", "w400 y+10", "─────────────── SYSTEM METRICS ───────────────").SetFont("s9")

    ; CPU Usage
    cpuUsage := GetCPUUsage()
    cpuText := menuGui.Add("Text", "w400 y+5", "🖥 CPU: " cpuUsage "%")
    cpuProgress := menuGui.Add("Progress", "w400 h20 Background0x2D2D30 c0x0078D4", cpuUsage)

    ; Memory Usage
    memUsage := GetMemoryUsage()
    memText := menuGui.Add("Text", "w400 y+10", "💾 RAM: " memUsage.percent "% (" memUsage.used " GB / " memUsage.total " GB)")
    memProgress := menuGui.Add("Progress", "w400 h20 Background0x2D2D30 c0x0078D4", memUsage.percent)

    ; Battery Status
    batteryInfo := GetBatteryStatus()
    if (batteryInfo.exists) {
        battText := menuGui.Add("Text", "w400 y+10", "🔋 Battery: " batteryInfo.percent "% " batteryInfo.status)
        battProgress := menuGui.Add("Progress", "w400 h20 Background0x2D2D30 c" batteryInfo.color, batteryInfo.percent)
    } else {
        menuGui.Add("Text", "w400 y+10", "🔌 No battery detected (Desktop PC)")
    }

    ; Quick Launch Section
    menuGui.Add("Text", "w400 y+15", "─────────────── QUICK LAUNCH ─────────────────").SetFont("s9")

    ; Launch buttons (2 columns)
    menuGui.Add("Button", "x20 y+10 w185 h40", "📁 File Explorer").OnEvent("Click", (*) => (Run("explorer.exe"), menuGui.Destroy()))
    menuGui.Add("Button", "x+10 w185 h40", "⚙ Settings").OnEvent("Click", (*) => (Run("ms-settings:"), menuGui.Destroy()))

    menuGui.Add("Button", "x20 y+5 w185 h40", "💻 Task Manager").OnEvent("Click", (*) => (Run("taskmgr.exe"), menuGui.Destroy()))
    menuGui.Add("Button", "x+10 w185 h40", "📝 Notepad").OnEvent("Click", (*) => (Run("notepad.exe"), menuGui.Destroy()))

    menuGui.Add("Button", "x20 y+5 w185 h40", "🌐 Browser").OnEvent("Click", (*) => (Run("chrome.exe"), menuGui.Destroy()))
    menuGui.Add("Button", "x+10 w185 h40", "📊 Calculator").OnEvent("Click", (*) => (Run("calc.exe"), menuGui.Destroy()))

    ; Refresh and Close buttons
    menuGui.Add("Button", "x20 y+15 w185 h35", "🔄 Refresh Metrics").OnEvent("Click", (*) => (menuGui.Destroy(), ShowQuickLaunchMenu()))
    menuGui.Add("Button", "x+10 w185 h35", "❌ Close (ESC)").OnEvent("Click", (*) => menuGui.Destroy())

    ; Show centered on screen
    menuGui.Show("w420 Center")

    ; Close on ESC
    menuGui.OnEvent("Escape", (*) => menuGui.Destroy())
}

; ===============================================
; SYSTEM METRICS FUNCTIONS
; ===============================================

/**
 * Get current CPU usage percentage
 */
GetCPUUsage() {
    ; Quick estimation using ComObject
    try {
        wmi := ComObject("WbemScripting.SWbemLocator")
        service := wmi.ConnectServer()
        cpu := service.ExecQuery("SELECT LoadPercentage FROM Win32_Processor").ItemIndex(0)
        return Round(cpu.LoadPercentage)
    } catch {
        return 0
    }
}

/**
 * Get memory usage information
 */
GetMemoryUsage() {
    try {
        wmi := ComObject("WbemScripting.SWbemLocator")
        service := wmi.ConnectServer()

        ; Get total and available memory
        os := service.ExecQuery("SELECT TotalVisibleMemorySize, FreePhysicalMemory FROM Win32_OperatingSystem").ItemIndex(0)

        totalMB := Round(os.TotalVisibleMemorySize / 1024)
        freeMB := Round(os.FreePhysicalMemory / 1024)
        usedMB := totalMB - freeMB

        totalGB := Round(totalMB / 1024, 1)
        usedGB := Round(usedMB / 1024, 1)

        percent := Round((usedMB / totalMB) * 100)

        return {
            total: totalGB,
            used: usedGB,
            percent: percent
        }
    } catch {
        return {total: 0, used: 0, percent: 0}
    }
}

/**
 * Get battery status and percentage
 */
GetBatteryStatus() {
    try {
        wmi := ComObject("WbemScripting.SWbemLocator")
        service := wmi.ConnectServer()

        batteries := service.ExecQuery("SELECT * FROM Win32_Battery")

        ; Check if battery exists
        if (batteries.Count == 0)
            return {exists: false}

        battery := batteries.ItemIndex(0)
        percent := battery.EstimatedChargeRemaining

        ; Determine status
        batteryStatus := battery.BatteryStatus
        switch batteryStatus {
            case 1:  status := "🔌 Charging"
            case 2:  status := "🔋 On AC"
            case 3:  status := "⚡ Fully Charged"
            default: status := "🔋 On Battery"
        }

        ; Color based on percentage
        if (percent > 50)
            color := "0x00A000"  ; Green
        else if (percent > 20)
            color := "0xFFA500"  ; Orange
        else
            color := "0xFF0000"  ; Red

        return {
            exists: true,
            percent: percent,
            status: status,
            color: color
        }
    } catch {
        return {exists: false}
    }
}

/*
 * Key Concepts:
 *
 * 1. Double-Tap Detection:
 *    Track last press time
 *    Compare with threshold (300ms)
 *    Reset after detection
 *
 * 2. System Metrics via WMI:
 *    Win32_Processor - CPU usage
 *    Win32_OperatingSystem - Memory
 *    Win32_Battery - Battery status
 *
 * 3. ComObject WMI Access:
 *    ComObject("WbemScripting.SWbemLocator")
 *    ConnectServer() - Connect to WMI
 *    ExecQuery() - Run WQL query
 *    ItemIndex(0) - Get first result
 *
 * 4. GUI Styling:
 *    Dark theme (0x1E1E1E background)
 *    Progress bars for metrics
 *    Emoji icons for visual appeal
 *    Centered display
 *
 * 5. Use Cases:
 *    ✅ System monitoring
 *    ✅ Quick app launcher
 *    ✅ Battery awareness
 *    ✅ Resource tracking
 *    ✅ Productivity dashboard
 *
 * 6. Double-Tap Pattern:
 *    ~ prefix - Don't block original key
 *    A_TickCount - Millisecond timer
 *    Threshold check - 300ms window
 *    State reset - Prevent triple-tap
 *
 * 7. WQL Queries:
 *    SELECT LoadPercentage FROM Win32_Processor
 *    SELECT * FROM Win32_OperatingSystem
 *    SELECT * FROM Win32_Battery
 *    SQL-like syntax for WMI
 *
 * 8. Battery Status Codes:
 *    1 = Discharging
 *    2 = AC connected
 *    3 = Fully charged
 *    Others = Various states
 *
 * 9. Progress Bars:
 *    Range 0-100 by default
 *    Background color
 *    Foreground color (c option)
 *    Dynamic updates
 *
 * 10. Memory Calculations:
 *     WMI returns KB
 *     Divide by 1024 for MB
 *     Divide again for GB
 *     Round for display
 *
 * 11. Best Practices:
 *     ✅ Try/catch for WMI access
 *     ✅ Handle missing hardware (battery)
 *     ✅ Refresh option
 *     ✅ ESC to close
 *     ✅ Visual feedback
 *
 * 12. Enhanced Features:
 *     - Disk usage
 *     - Network speed
 *     - Temperature monitoring
 *     - Process list
 *     - Custom app shortcuts
 *
 * 13. Performance:
 *     WMI queries are slow (100-500ms)
 *     Cache results if frequent updates
 *     Don't query on every keystroke
 *     Use timers for auto-refresh
 *
 * 14. Alternatives:
 *     - Performance counters (PDH)
 *     - Direct API calls
 *     - External tools (HWiNFO)
 */
