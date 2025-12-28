#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Display Control - Turn Monitor Off
 * 
 * Demonstrates turning the monitor off instantly to save power,
 * useful for quick privacy or energy saving.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Display Control Demo`n`n"
    . "Hotkey: Ctrl+Esc`n`n"
    . "Instantly turns off your monitor(s).`n"
    . "Move mouse or press any key to wake up.`n`n"
    . "Use cases:`n"
    . "- Quick privacy`n"
    . "- Power saving`n"
    . "- Leaving desk`n"
    . "- Listening to audio only`n`n"
    . "⚠ Press Ctrl+Esc to test (monitor will turn off!)`, , " T7 ")
    result := MsgBox("Ready to test monitor off?`n`n"
        . "Your monitor will turn off when you press Ctrl+Esc.`n"
        . "Move mouse or press a key to turn it back on.",
        "Confirm", "YesNo Icon?")
    if (result == "Yes") {
        ; Hotkey to turn off monitor
        ^Esc:: TurnOffMonitor()
    } else {
        MsgBox("Demo cancelled. Script will still work with Ctrl+Esc.", , "T2")
        ^Esc:: TurnOffMonitor()
    }
    /**
     * Turn off the monitor(s)
     */
    TurnOffMonitor() {
        ; Send monitor to low-power state
        ; WM_SYSCOMMAND (0x112) with SC_MONITORPOWER (0xF170)
        ; wParam: 2 = Power off, 1 = Low power, -1 = Power on

        SendMessage(0x112, 0xF170, 2, , "Program Manager")
    }
    /**
     * Alternative: Turn monitor on (if needed)
     */
    TurnOnMonitor() {
        SendMessage(0x112, 0xF170, -1, , "Program Manager")
    }
    /*
    * Key Concepts:
    *
    * 1. Monitor Power States:
    *    -1 = Power on
    *    1 = Low power (standby)
    *    2 = Power off
    *    Like pressing monitor button
    *
    * 2. WM_SYSCOMMAND:
    *    Message: 0x112
    *    System command messages
    *    SC_MONITORPOWER: 0xF170
    *    Sent to desktop window
    *
    * 3. SendMessage:
    *    SendMessage(msg, wParam, lParam, control, winTitle)
    *    Synchronous message
    *    "Program Manager" = Desktop
    *    Immediate effect
    *
    * 4. Wake Up:
    *    Any mouse movement
    *    Any keyboard input
    *    System events
    *    Automatic wake
    *
    * 5. Use Cases:
    *    ✅ Quick privacy (hide screen)
    *    ✅ Power saving (long tasks)
    *    ✅ Leaving desk briefly
    *    ✅ Audio-only tasks
    *    ✅ Presentations (dim during breaks)
    *
    * 6. Hotkey Selection:
    *    Ctrl+Esc - Accessible but safe
    *    Not used by most apps
    *    Easy to remember
    *    Hard to press accidentally
    *
    * 7. Differences from Sleep:
    *    Monitor off ≠ System sleep
    *    Computer stays active
    *    Programs keep running
    *    Downloads continue
    *
    * 8. Multi-Monitor:
    *    Turns off all monitors
    *    System-wide command
    *    Can't control individual displays
    *    Hardware dependent
    *
    * 9. Best Practices:
    *    ✅ Confirm before demo
    *    ✅ Explain wake-up method
    *    ✅ Use safe hotkey
    *    ⚠ Don't use for security
    *
    * 10. Security Note:
    *     ⚠ Monitor off ≠ Screen lock
    *     ⚠ Computer is still unlocked
    *     ⚠ Use Win+L to lock
    *     ⚠ This is NOT a security feature
    *
    * 11. Related Commands:
    *     SC_SCREENSAVE: 0xF140 - Start screensaver
    *     SC_MONITORPOWER: 0xF170 - Monitor power
    *     LockWorkStation() - Lock computer
    *     Shutdown command - System power
    *
    * 12. Enhancements:
    *     - Combine with screen lock (Win+L)
    *     - Timer-based auto-off
    *     - Idle detection
    *     - Per-monitor control (advanced)
    *     - Profile-based settings
    *     - Scheduled on/off times
    */

