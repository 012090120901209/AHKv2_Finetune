#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Custom Notification System
 * 
 * Demonstrates creating a custom GUI-based notification system with
 * positioning, duration control, and auto-close functionality.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

; Test notifications with different positions and durations
MsgBox("Notification System Demo`n`n"
    . "Will show notifications in different positions", , "T3")

; Example 1: Top-right notification (default)
ShowNotification("Hello! This is a notification", 2000)
Sleep(2500)

; Example 2: Bottom-right notification
ShowNotification("This notification appears at bottom-right", 3000, "right", "bottom")
Sleep(3500)

; Example 3: Top-left notification
ShowNotification("Top-left notification", 2000, "left", "top")
Sleep(2500)

; Example 4: Center notification
ShowNotification("Centered notification", 2000, "center", "center")
Sleep(2500)

; Example 5: Long message
ShowNotification("This is a longer notification message that demonstrates how the notification system handles multi-line text and longer content.", 4000)
Sleep(4500)

MsgBox("Notification demo complete!", , "T2")

/**
 * ShowNotification - Display custom GUI notification
 * @param {string} text - Message to display
 * @param {int} duration - Display duration in milliseconds (default: 2000)
 * @param {string} xAxis - Horizontal position: "left", "center", "right" (default: "right")
 * @param {string} yAxis - Vertical position: "top", "center", "bottom" (default: "top")
 */
ShowNotification(text, duration := 2000, xAxis := "right", yAxis := "top") {
    static notifGui := ""

    ; Close existing notification
    if (notifGui)
        CloseNotification()

    ; Create GUI
    notifGui := Gui("+AlwaysOnTop -Caption +ToolWindow", "Notification")
    notifGui.SetFont("s10", "Segoe UI")
    notifGui.BackColor := "0x2D2D30"
    notifGui.MarginX := 15
    notifGui.MarginY := 10

    ; Add text with wrapping
    textCtrl := notifGui.Add("Text", "cWhite w300", text)

    ; Show GUI to get dimensions
    notifGui.Show("Hide")

    ; Get GUI size
    notifGui.GetPos(, , &guiWidth, &guiHeight)

    ; Calculate position
    pos := CalculatePosition(xAxis, yAxis, guiWidth, guiHeight)

    ; Show at calculated position
    notifGui.Show("x" pos.x " y" pos.y " NoActivate")

    ; Auto-close after duration
    SetTimer(() => CloseNotification(), -duration)

    CloseNotification() {
        if (notifGui) {
            notifGui.Destroy()
            notifGui := ""
        }
    }
}

/**
 * CalculatePosition - Calculate notification position on screen
 */
CalculatePosition(xAxis, yAxis, width, height) {
    ; Get screen dimensions
    MonitorGetWorkArea(, &left, &top, &right, &bottom)
    screenWidth := right - left
    screenHeight := bottom - top

    ; Calculate X position
    switch xAxis {
        case "left":
            x := left + 20
        case "center":
            x := left + (screenWidth - width) // 2
        case "right":
            x := right - width - 20
        default:
            x := right - width - 20
    }

    ; Calculate Y position
    switch yAxis {
        case "top":
            y := top + 20
        case "center":
            y := top + (screenHeight - height) // 2
        case "bottom":
            y := bottom - height - 20
        default:
            y := top + 20
    }

    return { x: x, y: y }
}

/*
* Key Concepts:
*
* 1. Custom Notifications:
*    Alternative to TrayTip (deprecated in v2)
*    Full control over appearance
*    Customizable positioning
*
* 2. GUI Options:
*    +AlwaysOnTop - Stay above other windows
*    -Caption - No title bar
*    +ToolWindow - No taskbar button
*    NoActivate - Don't steal focus
*
* 3. Positioning:
*    MonitorGetWorkArea() - Get screen dimensions
*    Calculate based on alignment
*    Account for taskbar
*
* 4. Auto-Close:
*    SetTimer with negative delay
*    Timer runs once after delay
*    Destroys GUI automatically
*
* 5. Static Variables:
*    static notifGui - Persist across calls
*    Only one notification at a time
*    Previous notification closes
*
* 6. Color Scheme:
*    BackColor: 0x2D2D30 (dark gray)
*    Text: White
*    Modern, professional look
*
* 7. Use Cases:
*    ✅ Script feedback
*    ✅ Status updates
*    ✅ Clipboard operations
*    ✅ Hotkey confirmations
*    ✅ Process completion
*
* 8. Advantages:
*    ✅ No Windows 10 Action Center
*    ✅ Consistent appearance
*    ✅ Custom duration
*    ✅ Position control
*    ✅ No notification sound
*
* 9. Positioning Options:
*    X: left, center, right
*    Y: top, center, bottom
*    9 total combinations
*
* 10. Best Practices:
*     ✅ Keep messages concise
*     ✅ Use appropriate duration
*     ✅ Don't spam notifications
*     ✅ Test on different resolutions
*     ✅ Consider multiple monitors
*
* 11. Enhancements:
*     - Add icons
*     - Click to dismiss
*     - Stack multiple notifications
*     - Fade in/out animations
*     - Sound effects
*     - Action buttons
*
* 12. Real-World Usage:
*     ShowNotification("File saved successfully", 2000)
*     ShowNotification("Clipboard copied", 1500)
*     ShowNotification("Script reloaded", 1000)
*/

