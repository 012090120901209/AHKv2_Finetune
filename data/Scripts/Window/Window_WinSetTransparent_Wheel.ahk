#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Window Transparency Control
 * 
 * Demonstrates controlling window transparency using mouse wheel
 * with modifier keys and preset transparency levels.
 * 
 * Source: xypha/AHK-v2-scripts - Showcase.ahk
 * Inspired by: https://github.com/xypha/AHK-v2-scripts
 */

MsgBox("Window Transparency Demo`n`n"
    . "Hotkeys:`n"
    . "Ctrl+Shift+WheelUp/Down - Adjust transparency`n"
    . "F8 - Cycle preset transparency levels`n"
    . "Alt+Home - Reset to 100%% opaque`n`n"
    . "Try it on Notepad window...", , "T5")

; Open test window
Run("notepad.exe")
WinWait("ahk_exe notepad.exe", , 3)
WinActivate("ahk_exe notepad.exe")
Sleep(500)

; Hotkeys
^+WheelUp:: AdjustTransparency("up")
^+WheelDown:: AdjustTransparency("down")
F8:: CycleTransparency()
!Home:: ResetTransparency()

/**
 * Adjust window transparency with mouse wheel
 */
AdjustTransparency(direction) {
    ; Get window under mouse
    MouseGetPos(, , &winID)
    if (!winID)
        return

    ; Get current transparency (0-255, 255=opaque)
    currentTrans := WinGetTransparent(winID)

    ; If not set, default to 255 (opaque)
    if (currentTrans == "")
        currentTrans := 255

    ; Adjust by 15 units (about 6% per step)
    step := 15
    if (direction == "up")
        newTrans := Min(currentTrans + step, 255)
    else
        newTrans := Max(currentTrans - step, 30)  ; Minimum 30 for visibility

    ; Set new transparency
    WinSetTransparent(newTrans, winID)

    ; Calculate percentage
    percent := Round((newTrans / 255) * 100)

    ; Show tooltip
    ToolTip("Transparency: " percent "%")
    SetTimer(() => ToolTip(), -1000)
}

/**
 * Cycle through preset transparency levels
 */
CycleTransparency() {
    ; Preset levels (as 0-255 values)
    static presets := [255, 230, 204, 178, 153, 128]  ; 100%, 90%, 80%, 70%, 60%, 50%
    static currentIndex := 1

    ; Get active window
    winID := WinExist("A")
    if (!winID)
        return

    ; Get window title
    winTitle := WinGetTitle(winID)
    if (winTitle == "")
        winTitle := "Active Window"

    ; Apply preset
    transValue := presets[currentIndex]
    WinSetTransparent(transValue, winID)

    ; Calculate percentage
    percent := Round((transValue / 255) * 100)

    ; Show notification
    ToolTip(winTitle "`nTransparency: " percent "%")
    SetTimer(() => ToolTip(), -1500)

    ; Move to next preset
    currentIndex++
    if (currentIndex > presets.Length)
        currentIndex := 1
}

/**
 * Reset transparency to fully opaque
 */
ResetTransparency() {
    ; Get active window
    winID := WinExist("A")
    if (!winID)
        return

    ; Reset to opaque
    WinSetTransparent("Off", winID)

    ; Show notification
    ToolTip("Transparency reset to 100%")
    SetTimer(() => ToolTip(), -1000)
}

/*
* Key Concepts:
*
* 1. Window Transparency:
*    WinSetTransparent(value, winID)
*    value: 0-255 (0=invisible, 255=opaque)
*    "Off" to reset
*
* 2. Getting Current Value:
*    WinGetTransparent(winID)
*    Returns "" if not set
*    Default to 255 if unset
*
* 3. Window Under Mouse:
*    MouseGetPos(, , &winID)
*    Third parameter is window ID
*    Allows adjusting any window
*
* 4. Active Window:
*    WinExist("A") or WinGetID("A")
*    Currently focused window
*    For keyboard shortcuts
*
* 5. Incremental Adjustment:
*    Step size (15 = ~6% per scroll)
*    Min/Max bounds
*    Smooth control
*
* 6. Preset Levels:
*    Common transparency percentages
*    Quick access with single key
*    Cycle through options
*
* 7. Use Cases:
*    ✅ See-through windows
*    ✅ Overlay reference material
*    ✅ Monitor background activity
*    ✅ Multi-tasking
*    ✅ Video tutorials
*
* 8. Visibility Considerations:
*    Minimum: 30/255 (12%)
*    Too transparent = hard to read
*    Too opaque = defeats purpose
*
* 9. Best Practices:
*    ✅ Set reasonable min/max
*    ✅ Show visual feedback
*    ✅ Allow reset
*    ✅ Smooth increments
*
* 10. Common Presets:
*     100% - Fully opaque (default)
*     90% - Slight transparency
*     80% - Moderate
*     70% - Transparent
*     60% - Very transparent
*     50% - Half transparent
*
* 11. Enhancements:
*     - Per-application defaults
*     - Fade animations
*     - Remember window settings
*     - Exclude certain windows
*
* 12. Real-World Scenarios:
*     Coding with documentation overlay
*     Writing with reference visible
*     Gaming with chat visible
*     Monitoring multiple sources
*/

