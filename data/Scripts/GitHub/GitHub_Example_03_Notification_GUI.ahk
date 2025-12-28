#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Custom Notification System
 * Source: github.com/pa-0/workingexamples-ah2
 * 
 * Demonstrates:
 * - GUI creation with custom styling
 * - AlwaysOnTop, borderless windows (+ToolWindow -Caption)
 * - SetTimer for delayed execution
 * - WinMove for precise positioning
 * - GUI.Destroy() for cleanup
 */

ShowNotification(text, duration := 3000, xPos := 1650, yPos := 985) {
    ; Create borderless, always-on-top window
    MyNotif := Gui("+AlwaysOnTop -Caption +ToolWindow")
    MyNotif.BackColor := "EEEEEE"
    MyNotif.SetFont("s18 w1000", "Arial")
    MyNotif.AddText("cBlack w230 Left", text)
    MyNotif.Show("NoActivate")

    ; Position the notification
    WinMove(xPos, yPos, , , MyNotif)

    ; Auto-close after duration
    SetTimer(() => MyNotif.Destroy(), duration * -1)
}

; Examples - show notifications
ShowNotification("Hello from AHK!", 2000, 1650, 50)
Sleep(2500)

ShowNotification("Task completed successfully", 3000, 1650, 150)
Sleep(3500)

ShowNotification("Low battery warning", 5000, 1650, 250)
