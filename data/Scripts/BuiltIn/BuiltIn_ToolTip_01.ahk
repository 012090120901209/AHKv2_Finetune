#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * ============================================================================
 * ToolTip Basic Examples - Part 1
 * ============================================================================
 * 
 * Comprehensive examples demonstrating ToolTip usage in AutoHotkey v2.
 * 
 * @description This file covers fundamental ToolTip functionality including:
 *              - Basic tooltip display
 *              - Positioning and placement
 *              - Auto-hide with timers
 *              - Multiple tooltips
 *              - Tooltip formatting
 * 
 * @author AutoHotkey Foundation
 * @version 2.0
 * @see https://www.autohotkey.com/docs/v2/lib/ToolTip.htm
 * 
 * ============================================================================
 */

; ============================================================================
; EXAMPLE 1: Basic ToolTip Display
; ============================================================================
/**
 * Demonstrates basic tooltip creation and display.
 * 
 * @description Shows how to display simple tooltips and clear them.
 */
Example1_BasicDisplay() {
    ; Simple tooltip
    ToolTip "This is a basic tooltip"
    Sleep 2000
    ToolTip  ; Clear tooltip

    ; Tooltip with line breaks
    ToolTip "Line 1`nLine 2`nLine 3"
    Sleep 2000
    ToolTip

    ; Tooltip with variables
    userName := "John Doe"
    userAge := 30
    ToolTip "User: " . userName . "`nAge: " . userAge
    Sleep 2000
    ToolTip

    ; Formatted tooltip
    ToolTip Format("Name: {1}`nAge: {2}`nStatus: Active", userName, userAge)
    Sleep 2000
    ToolTip

    ; Long text tooltip
    longText := "This is a longer tooltip message that demonstrates "
        . "how ToolTip handles extended text content. "
        . "The tooltip will automatically size to fit the content."
    ToolTip longText
    Sleep 3000
    ToolTip

    ; Dynamic tooltip content
    Loop 5 {
        ToolTip "Counter: " . A_Index . "/5"
        Sleep 1000
    }
    ToolTip

    ; Tooltip with special characters
    ToolTip "Special: © ® ™ • → ← ↑ ↓"
    Sleep 2000
    ToolTip
}

; ============================================================================
; EXAMPLE 2: ToolTip Positioning
; ============================================================================
/**
 * Shows different tooltip positioning options.
 * 
 * @description Demonstrates how to position tooltips at specific
 *              screen coordinates.
 * 
 * Syntax: ToolTip(Text, X, Y, WhichToolTip)
 */
Example2_Positioning() {
    ; Center of screen
    screenWidth := A_ScreenWidth
    screenHeight := A_ScreenHeight
    ToolTip "Center of screen", screenWidth // 2, screenHeight // 2
    Sleep 2000
    ToolTip

    ; Top-left corner
    ToolTip "Top-left corner", 10, 10
    Sleep 2000
    ToolTip

    ; Top-right corner
    ToolTip "Top-right corner", screenWidth - 200, 10
    Sleep 2000
    ToolTip

    ; Bottom-left corner
    ToolTip "Bottom-left corner", 10, screenHeight - 100
    Sleep 2000
    ToolTip

    ; Bottom-right corner
    ToolTip "Bottom-right corner", screenWidth - 200, screenHeight - 100
    Sleep 2000
    ToolTip

    ; Follow mouse cursor
    MsgBox "Move your mouse - tooltip will follow"
    Loop 50 {
        MouseGetPos &mouseX, &mouseY
        ToolTip "Following cursor`nX: " . mouseX . " Y: " . mouseY, mouseX + 20, mouseY + 20
        Sleep 100
    }
    ToolTip

    ; Fixed position tooltip
    ToolTip "Fixed at (500, 300)", 500, 300
    Sleep 2000
    ToolTip
}

; ============================================================================
; EXAMPLE 3: Multiple ToolTips
; ============================================================================
/**
 * Demonstrates using multiple tooltips simultaneously.
 * 
 * @description Shows how to display up to 20 tooltips at once
 *              using the WhichToolTip parameter (1-20).
 */
Example3_MultipleToolTips() {
    ; Display 3 tooltips at different positions
    ToolTip "Tooltip 1 - Top", 100, 100, 1
    ToolTip "Tooltip 2 - Middle", 100, 300, 2
    ToolTip "Tooltip 3 - Bottom", 100, 500, 3
    Sleep 3000

    ; Clear specific tooltips
    ToolTip , , , 2  ; Clear tooltip #2
    Sleep 1000
    ToolTip , , , 1  ; Clear tooltip #1
    Sleep 1000
    ToolTip , , , 3  ; Clear tooltip #3

    ; Multiple data displays
    ToolTip "CPU: 45%", 10, 10, 1
    ToolTip "RAM: 60%", 10, 50, 2
    ToolTip "Disk: 75%", 10, 90, 3
    ToolTip "Network: Active", 10, 130, 4
    Sleep 3000

    ; Clear all
    Loop 4 {
        ToolTip , , , A_Index
    }

    ; Status bar style tooltips
    ToolTip "Status: Ready", 10, A_ScreenHeight - 50, 1
    ToolTip "Time: " . FormatTime(, "HH:mm:ss"), 200, A_ScreenHeight - 50, 2
    ToolTip "User: Admin", 400, A_ScreenHeight - 50, 3
    Sleep 3000

    Loop 3 {
        ToolTip , , , A_Index
    }

    ; Updating multiple tooltips
    Loop 10 {
        ToolTip "Count 1: " . A_Index, 100, 100, 1
        ToolTip "Count 2: " . (A_Index * 2), 100, 140, 2
        ToolTip "Count 3: " . (A_Index * 3), 100, 180, 3
        Sleep 500
    }

    Loop 3 {
        ToolTip , , , A_Index
    }
}

; ============================================================================
; EXAMPLE 4: Auto-Hide ToolTips with SetTimer
; ============================================================================
/**
 * Shows how to auto-hide tooltips after a delay.
 * 
 * @description Demonstrates using SetTimer to automatically
 *              clear tooltips after a specified duration.
 */
Example4_AutoHide() {
    ; Simple auto-hide (2 seconds)
    ShowTimedToolTip("This will disappear in 2 seconds", 2000)
    Sleep 2500

    ; Different durations
    ShowTimedToolTip("Quick message (1 second)", 1000)
    Sleep 1500

    ShowTimedToolTip("Longer message (5 seconds)", 5000)
    Sleep 5500

    ; Positioned auto-hide tooltip
    ShowTimedToolTip("Top-right notification", 3000, A_ScreenWidth - 250, 50)
    Sleep 3500

    ; Multiple auto-hide tooltips
    ShowTimedToolTip("Message 1", 2000, 100, 100, 1)
    Sleep 500
    ShowTimedToolTip("Message 2", 2000, 100, 140, 2)
    Sleep 500
    ShowTimedToolTip("Message 3", 2000, 100, 180, 3)
    Sleep 2500

    ; Progress notification
    Loop 5 {
        ShowTimedToolTip("Processing step " . A_Index . "/5", 800)
        Sleep 1000
    }

    ; Success notification
    ShowTimedToolTip("✓ All steps completed!", 2000, , , , "green")
}

/**
 * Shows a tooltip that auto-hides after specified duration.
 * 
 * @param {String} text The tooltip text
 * @param {Integer} duration How long to show (milliseconds)
 * @param {Integer} x X position (optional)
 * @param {Integer} y Y position (optional)
 * @param {Integer} whichToolTip Tooltip number 1-20 (optional)
 */
ShowTimedToolTip(text, duration := 2000, x := "", y := "", whichToolTip := 1) {
    if (x = "" || y = "")
        ToolTip text, , , whichToolTip
    else
        ToolTip text, x, y, whichToolTip

    ; Set timer to clear tooltip
    ClearFunc := (*) => ToolTip("", , , whichToolTip)
    SetTimer ClearFunc, -duration  ; Negative for one-time execution
}

; ============================================================================
; EXAMPLE 5: Status Display Tooltips
; ============================================================================
/**
 * Creates status display tooltips for monitoring.
 * 
 * @description Shows real-time status information using tooltips.
 */
Example5_StatusDisplay() {
    ; Simple status indicator
    ToolTip "Status: Initializing..."
    Sleep 1000
    ToolTip "Status: Loading modules..."
    Sleep 1000
    ToolTip "Status: Ready"
    Sleep 1000
    ToolTip

    ; Progress indicator
    total := 100
    Loop total {
        percent := (A_Index / total) * 100
        bar := CreateProgressBar(percent, 20)
        ToolTip Format("Progress: {1}%`n{2}", Round(percent), bar)
        Sleep 50
    }
    ToolTip

    ; Multi-line status
    ShowStatus("Connecting", "Server", "api.example.com")
    Sleep 1500
    ShowStatus("Authenticated", "User", "admin")
    Sleep 1500
    ShowStatus("Connected", "Status", "Active")
    Sleep 1500
    ToolTip

    ; Real-time clock tooltip
    MsgBox "Showing real-time clock for 5 seconds"
    startTime := A_TickCount
    Loop {
        ToolTip FormatTime(, "HH:mm:ss")
        Sleep 100
        if (A_TickCount - startTime > 5000)
            break
    }
    ToolTip

    ; System info display
    ShowSystemInfo()
    Sleep 3000
    ToolTip

    ; Counter with status
    Loop 10 {
        status := (A_Index <= 5) ? "⚠️ Warning" : "✓ OK"
        ToolTip Format("Item {1}/10`nStatus: {2}", A_Index, status)
        Sleep 500
    }
    ToolTip
}

/**
 * Creates a text-based progress bar.
 */
CreateProgressBar(percent, width := 20) {
    filled := Round((percent / 100) * width)
    bar := ""

    Loop width {
        bar .= (A_Index <= filled) ? "█" : "░"
    }

    return bar
}

/**
 * Shows formatted status message.
 */
ShowStatus(action, label, value) {
    ToolTip Format("{1}...`n`n{2}: {3}", action, label, value)
}

/**
 * Shows system information tooltip.
 */
ShowSystemInfo() {
    info := "=== System Info ===`n`n"
        . "Computer: " . A_ComputerName . "`n"
        . "User: " . A_UserName . "`n"
        . "OS: " . A_OSVersion . "`n"
        . "Screen: " . A_ScreenWidth . "x" . A_ScreenHeight

    ToolTip info
}

; ============================================================================
; EXAMPLE 6: Interactive ToolTips
; ============================================================================
/**
 * Creates interactive tooltips that respond to events.
 * 
 * @description Shows tooltips that update based on user actions.
 */
Example6_InteractiveToolTips() {
    ; Mouse position tracker
    MsgBox "Move mouse to see coordinates (5 seconds)"
    startTime := A_TickCount
    Loop {
        MouseGetPos &x, &y
        ToolTip Format("Mouse Position`nX: {1}`nY: {2}", x, y), x + 20, y + 20
        Sleep 50
        if (A_TickCount - startTime > 5000)
            break
    }
    ToolTip

    ; Key press counter
    global keyPressCount := 0
    MsgBox "Press any key 5 times (or wait 10 seconds)"

    ShowKeyCounter()

    ; Hover timer
    MsgBox "Tooltip will show hover duration"
    hoverStart := A_TickCount
    Loop 50 {
        elapsed := Round((A_TickCount - hoverStart) / 1000, 1)
        ToolTip Format("Hover time: {1}s", elapsed)
        Sleep 100
    }
    ToolTip

    ; Context-aware tooltip
    Loop 3 {
        mode := (A_Index = 1) ? "Reading" : (A_Index = 2) ? "Writing" : "Processing"
        icon := (A_Index = 1) ? "📖" : (A_Index = 2) ? "✍️" : "⚙️"
        ToolTip Format("{1} Mode: {2}", icon, mode)
        Sleep 2000
    }
    ToolTip
}

/**
 * Shows key press counter.
 */
ShowKeyCounter() {
    global keyPressCount
    keyPressCount := 0

    Loop 50 {  ; Check for 5 seconds
        ToolTip Format("Key presses: {1}/5`nPress any key", keyPressCount)
        Sleep 100

        if (keyPressCount >= 5)
            break
    }
    ToolTip
}

; Monitor key presses (example - would need hotkeys in practice)
; ~*a::keyPressCount++

; ============================================================================
; EXAMPLE 7: Formatted and Styled ToolTips
; ============================================================================
/**
 * Shows various tooltip formatting techniques.
 * 
 * @description Demonstrates text formatting within tooltips.
 */
Example7_FormattedToolTips() {
    ; Aligned columns
    data := [
        ["Name", "John Doe"],
        ["Age", "30"],
        ["City", "New York"],
        ["Status", "Active"]
    ]

    formatted := ""
    for row in data {
        formatted .= Format("{1}: {2}`n", row[1], row[2])
    }

    ToolTip formatted
    Sleep 3000
    ToolTip

    ; Table-like format
    table := "╔═══════════════════╗`n"
        . "║   System Status   ║`n"
        . "╠═══════════════════╣`n"
        . "║ CPU:    45%       ║`n"
        . "║ Memory: 60%       ║`n"
        . "║ Disk:   75%       ║`n"
        . "╚═══════════════════╝"

    ToolTip table
    Sleep 3000
    ToolTip

    ; List format
    list := "Shopping List:`n"
        . "  • Milk`n"
        . "  • Bread`n"
        . "  • Eggs`n"
        . "  • Butter`n"
        . "  • Coffee"

    ToolTip list
    Sleep 3000
    ToolTip

    ; Numbered list
    numbered := "Installation Steps:`n`n"
        . "1. Download installer`n"
        . "2. Run setup.exe`n"
        . "3. Accept license`n"
        . "4. Choose destination`n"
        . "5. Complete installation"

    ToolTip numbered
    Sleep 3000
    ToolTip

    ; Indented hierarchy
    hierarchy := "Project Structure:`n"
        . "├─ src/`n"
        . "│  ├─ main.ahk`n"
        . "│  └─ lib/`n"
        . "├─ docs/`n"
        . "└─ tests/"

    ToolTip hierarchy
    Sleep 3000
    ToolTip

    ; Statistics display
    stats := "=== Statistics ===`n`n"
        . "Total:    1,234`n"
        . "Success:  1,100 (89%)`n"
        . "Failed:     134 (11%)`n"
        . "Pending:      0 (0%)`n`n"
        . "Average: 12.5 sec"

    ToolTip stats
    Sleep 3000
    ToolTip

    ; Multi-section format
    sections := "▼ Section 1: Overview`n"
        . "   Status: Complete`n`n"
        . "▼ Section 2: Details`n"
        . "   Items: 45`n`n"
        . "▼ Section 3: Summary`n"
        . "   Result: Success"

    ToolTip sections
    Sleep 3000
    ToolTip
}

; ============================================================================
; Hotkey Triggers
; ============================================================================

^1:: Example1_BasicDisplay()
^2:: Example2_Positioning()
^3:: Example3_MultipleToolTips()
^4:: Example4_AutoHide()
^5:: Example5_StatusDisplay()
^6:: Example6_InteractiveToolTips()
^7:: Example7_FormattedToolTips()
^0:: ExitApp

/**
 * ============================================================================
 * SUMMARY
 * ============================================================================
 * 
 * ToolTip fundamentals covered:
 * 1. Basic tooltip display and clearing
 * 2. Positioning tooltips at specific coordinates
 * 3. Using multiple tooltips simultaneously (up to 20)
 * 4. Auto-hiding tooltips with SetTimer
 * 5. Status display and monitoring tooltips
 * 6. Interactive tooltips responding to events
 * 7. Formatted and styled tooltip content
 * 
 * Key Points:
 * - ToolTip with no parameters clears the tooltip
 * - Position with X, Y coordinates
 * - Use WhichToolTip (1-20) for multiple tooltips
 * - Combine with SetTimer for auto-hide functionality
 * - Great for non-intrusive status displays
 * - Can display formatted text with line breaks
 * 
 * ============================================================================
 */

