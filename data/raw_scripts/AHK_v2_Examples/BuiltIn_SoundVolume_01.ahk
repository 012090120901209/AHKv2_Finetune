#Requires AutoHotkey v2.0
/**
 * BuiltIn_SoundVolume_01.ahk
 *
 * DESCRIPTION:
 * Basic usage of SoundGetVolume() and SoundSetVolume() for audio control
 *
 * FEATURES:
 * - Get current system volume levels
 * - Set volume programmatically
 * - Control different audio components
 * - Volume validation and limits
 * - Component detection
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SoundGetVolume.htm
 * https://www.autohotkey.com/docs/v2/lib/SoundSetVolume.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - SoundGetVolume() function
 * - SoundSetVolume() function
 * - Audio component types
 * - Try/Catch error handling
 * - Number validation
 *
 * LEARNING POINTS:
 * 1. SoundGetVolume() returns volume as percentage (0-100)
 * 2. SoundSetVolume() sets volume (0-100 or +/-N for relative)
 * 3. Component types: Master, Wave, Synth, CD, Microphone, etc.
 * 4. Empty/omitted component = Master volume (Windows Vista+)
 * 5. Use Try/Catch for component availability checking
 * 6. Volume changes are system-wide
 */

; ============================================================
; Example 1: Get Current Volume
; ============================================================

/**
 * Retrieve and display current master volume
 */
GetMasterVolume() {
    try {
        ; Get master volume (component omitted = master)
        volume := SoundGetVolume()

        MsgBox("Current Master Volume: " Round(volume) "%`n`n"
             . "Full precision: " volume "%",
             "Volume Level", "Iconi")

        return volume

    } catch as err {
        MsgBox("Error getting volume:`n" err.Message,
               "Error", "Iconx")
        return -1
    }
}

; Uncomment to test:
; GetMasterVolume()

; ============================================================
; Example 2: Set Master Volume
; ============================================================

/**
 * Set master volume to a specific level
 *
 * @param {Number} level - Volume level (0-100)
 * @returns {Boolean} - Success status
 */
SetMasterVolume(level) {
    ; Validate input
    if !IsNumber(level) {
        MsgBox("Invalid volume level: " level "`nMust be a number",
               "Error", "Iconx")
        return false
    }

    ; Clamp to valid range
    if level < 0
        level := 0
    else if level > 100
        level := 100

    try {
        ; Get current volume for confirmation
        oldVolume := SoundGetVolume()

        ; Set new volume
        SoundSetVolume(level)

        ; Verify change
        newVolume := SoundGetVolume()

        MsgBox("Volume Changed:`n`n"
             . "Old: " Round(oldVolume) "%`n"
             . "New: " Round(newVolume) "%`n"
             . "Requested: " level "%",
             "Volume Set", "Iconi")

        return true

    } catch as err {
        MsgBox("Error setting volume:`n" err.Message,
               "Error", "Iconx")
        return false
    }
}

; Test volume setting
; SetMasterVolume(50)
; SetMasterVolume(75)
; SetMasterVolume(100)

; ============================================================
; Example 3: Relative Volume Adjustment
; ============================================================

/**
 * Adjust volume relative to current level
 *
 * @param {Number} delta - Amount to change (+/- percentage)
 */
AdjustVolume(delta) {
    try {
        oldVolume := SoundGetVolume()

        ; Use +/- prefix for relative adjustment
        if delta > 0
            SoundSetVolume("+" delta)
        else if delta < 0
            SoundSetVolume(delta)  ; Already has minus sign

        newVolume := SoundGetVolume()

        MsgBox("Volume Adjusted:`n`n"
             . "Previous: " Round(oldVolume) "%`n"
             . "Change: " (delta > 0 ? "+" : "") delta "%`n"
             . "Current: " Round(newVolume) "%",
             "Volume Adjustment", "Iconi")

    } catch as err {
        MsgBox("Error adjusting volume:`n" err.Message,
               "Error", "Iconx")
    }
}

; Test volume adjustment
; AdjustVolume(10)   ; Increase by 10%
; AdjustVolume(-10)  ; Decrease by 10%
; AdjustVolume(5)    ; Increase by 5%

; ============================================================
; Example 4: Volume Control Hotkeys
; ============================================================

/**
 * Setup hotkeys for volume control
 * Uses Ctrl+Alt+Up/Down for volume adjustment
 */
SetupVolumeHotkeys() {
    MsgBox("Volume Control Hotkeys Setup:`n`n"
         . "Ctrl+Alt+Up   : Volume Up (+5%)`n"
         . "Ctrl+Alt+Down : Volume Down (-5%)`n"
         . "Ctrl+Alt+M    : Show Current Volume`n`n"
         . "Hotkeys are now active!",
         "Hotkeys Active", "Iconi")

    ; Volume Up
    ^!Up:: {
        try {
            SoundSetVolume("+5")
            volume := SoundGetVolume()
            ToolTip("Volume: " Round(volume) "%")
            SetTimer(() => ToolTip(), -1500)
        }
    }

    ; Volume Down
    ^!Down:: {
        try {
            SoundSetVolume("-5")
            volume := SoundGetVolume()
            ToolTip("Volume: " Round(volume) "%")
            SetTimer(() => ToolTip(), -1500)
        }
    }

    ; Show Current Volume
    ^!m:: {
        try {
            volume := SoundGetVolume()
            MsgBox("Current Volume: " Round(volume) "%",
                   "Volume", "Iconi T2")
        }
    }
}

; Uncomment to activate hotkeys:
; SetupVolumeHotkeys()

; ============================================================
; Example 5: Volume Presets
; ============================================================

/**
 * Quick volume preset manager
 */
class VolumePresets {
    /**
     * Initialize with preset levels
     */
    __New() {
        this.presets := Map(
            "Silent", 0,
            "Very Low", 20,
            "Low", 35,
            "Medium", 50,
            "High", 70,
            "Very High", 85,
            "Maximum", 100
        )
    }

    /**
     * Apply a preset
     *
     * @param {String} presetName - Name of preset
     */
    ApplyPreset(presetName) {
        if !this.presets.Has(presetName) {
            MsgBox("Preset not found: " presetName, "Error", "Iconx")
            return
        }

        level := this.presets[presetName]

        try {
            oldVolume := SoundGetVolume()
            SoundSetVolume(level)
            newVolume := SoundGetVolume()

            MsgBox("Preset Applied: " presetName "`n`n"
                 . "Old Volume: " Round(oldVolume) "%`n"
                 . "New Volume: " Round(newVolume) "%",
                 "Preset", "Iconi T2")

        } catch as err {
            MsgBox("Error applying preset:`n" err.Message,
                   "Error", "Iconx")
        }
    }

    /**
     * Show all available presets
     */
    ShowPresets() {
        output := "VOLUME PRESETS:`n`n"

        for name, level in this.presets {
            output .= name ": " level "%`n"
        }

        MsgBox(output, "Available Presets", "Iconi")
    }

    /**
     * Create custom preset
     *
     * @param {String} name - Preset name
     * @param {Number} level - Volume level (0-100)
     */
    CreatePreset(name, level) {
        if level < 0 or level > 100 {
            MsgBox("Invalid volume level: " level "`nMust be 0-100",
                   "Error", "Iconx")
            return
        }

        this.presets[name] := level
        MsgBox("Preset created: " name " = " level "%",
               "Preset Created", "Iconi T2")
    }
}

; Create and test preset manager
volumePresets := VolumePresets()

; Test presets
; volumePresets.ShowPresets()
; volumePresets.ApplyPreset("Medium")
; volumePresets.ApplyPreset("Low")
; volumePresets.ApplyPreset("High")
; volumePresets.CreatePreset("Gaming", 65)
; volumePresets.ApplyPreset("Gaming")

; ============================================================
; Example 6: Volume Monitor
; ============================================================

/**
 * Monitor volume changes in real-time
 */
class VolumeMonitor {
    /**
     * Initialize monitor
     */
    __New() {
        this.isMonitoring := false
        this.lastVolume := 0
        this.checkInterval := 1000  ; Check every 1 second
    }

    /**
     * Start monitoring volume changes
     */
    Start() {
        if this.isMonitoring {
            MsgBox("Monitor is already running!", "Info", "Iconi")
            return
        }

        this.isMonitoring := true
        this.lastVolume := SoundGetVolume()

        MsgBox("Volume monitoring started`n`n"
             . "Current volume: " Round(this.lastVolume) "%`n"
             . "Check interval: " this.checkInterval "ms`n`n"
             . "The monitor will detect volume changes.",
             "Monitor Active", "Iconi")

        ; Start monitoring loop
        SetTimer(() => this.CheckVolume(), this.checkInterval)
    }

    /**
     * Stop monitoring
     */
    Stop() {
        this.isMonitoring := false
        SetTimer(() => this.CheckVolume(), 0)

        MsgBox("Volume monitoring stopped", "Monitor", "Iconi T2")
    }

    /**
     * Check for volume changes
     */
    CheckVolume() {
        if !this.isMonitoring
            return

        try {
            currentVolume := SoundGetVolume()

            ; Check if volume changed significantly (more than 1%)
            if Abs(currentVolume - this.lastVolume) > 1 {
                change := currentVolume - this.lastVolume
                direction := change > 0 ? "increased" : "decreased"

                ToolTip("Volume " direction ": " Round(currentVolume) "%`n"
                      . "Change: " (change > 0 ? "+" : "") Round(change) "%")

                SetTimer(() => ToolTip(), -2000)

                this.lastVolume := currentVolume
            }

        } catch {
            ; Ignore errors during monitoring
        }
    }
}

; Create and test monitor
; volumeMonitor := VolumeMonitor()
; volumeMonitor.Start()
; Sleep(30000)  ; Monitor for 30 seconds
; volumeMonitor.Stop()

; ============================================================
; Example 7: Volume Validation and Safety
; ============================================================

/**
 * Safe volume control with validation and limits
 */
class SafeVolumeControl {
    /**
     * Initialize with safety limits
     */
    __New() {
        this.maxSafeVolume := 85  ; WHO recommendation for safe listening
        this.warnThreshold := 75   ; Warn before reaching high volume
    }

    /**
     * Safely set volume with warnings
     *
     * @param {Number} level - Desired volume level
     * @returns {Boolean} - Success status
     */
    SafeSet(level) {
        ; Validate input
        if !IsNumber(level) {
            MsgBox("Invalid volume level", "Error", "Iconx")
            return false
        }

        ; Clamp to 0-100
        level := Max(0, Min(100, level))

        ; Check if exceeds safe limit
        if level > this.maxSafeVolume {
            result := MsgBox("Warning: Volume level " level "% exceeds safe limit!`n`n"
                           . "Safe maximum: " this.maxSafeVolume "%`n"
                           . "Prolonged exposure to high volume can damage hearing.`n`n"
                           . "Continue anyway?",
                           "Safety Warning", "YesNo Icon! Default2")

            if result = "No"
                return false
        }
        ; Warn if approaching high volume
        else if level > this.warnThreshold {
            MsgBox("Notice: Setting volume to " level "%`n`n"
                 . "This is approaching high volume levels.`n"
                 . "Safe maximum: " this.maxSafeVolume "%",
                 "Volume Notice", "Iconi T3")
        }

        ; Set the volume
        try {
            SoundSetVolume(level)
            currentVolume := SoundGetVolume()

            MsgBox("Volume set to " Round(currentVolume) "%",
                   "Volume Set", "Iconi T2")

            return true

        } catch as err {
            MsgBox("Error setting volume:`n" err.Message,
                   "Error", "Iconx")
            return false
        }
    }

    /**
     * Get current volume with safety assessment
     */
    GetWithAssessment() {
        try {
            volume := SoundGetVolume()
            assessment := ""

            if volume = 0
                assessment := "Silent/Muted"
            else if volume <= 20
                assessment := "Very Low - Safe"
            else if volume <= 50
                assessment := "Low to Medium - Safe"
            else if volume <= 75
                assessment := "Medium to High - Safe"
            else if volume <= 85
                assessment := "High - Still Safe"
            else if volume <= 95
                assessment := "Very High - CAUTION"
            else
                assessment := "Maximum - DANGER"

            MsgBox("Current Volume: " Round(volume) "%`n`n"
                 . "Assessment: " assessment "`n`n"
                 . "Safe maximum: " this.maxSafeVolume "%",
                 "Volume Assessment", "Iconi")

            return volume

        } catch as err {
            MsgBox("Error getting volume:`n" err.Message,
                   "Error", "Iconx")
            return -1
        }
    }

    /**
     * Gradually fade volume to target level
     *
     * @param {Number} targetLevel - Target volume
     * @param {Integer} durationMs - Fade duration in milliseconds
     */
    FadeToLevel(targetLevel, durationMs := 2000) {
        try {
            currentVolume := SoundGetVolume()
            difference := targetLevel - currentVolume
            steps := 20  ; Number of steps in fade
            stepSize := difference / steps
            stepDelay := durationMs / steps

            MsgBox("Fading volume:`n"
                 . "From: " Round(currentVolume) "%`n"
                 . "To: " targetLevel "%`n"
                 . "Duration: " durationMs "ms",
                 "Volume Fade", "T1")

            Loop steps {
                newLevel := currentVolume + (stepSize * A_Index)
                SoundSetVolume(newLevel)
                Sleep(stepDelay)
            }

            ; Ensure we end at exact target
            SoundSetVolume(targetLevel)

            MsgBox("Fade complete!`nCurrent volume: " Round(targetLevel) "%",
                   "Done", "Iconi T2")

        } catch as err {
            MsgBox("Error during fade:`n" err.Message,
                   "Error", "Iconx")
        }
    }
}

; Test safe volume control
safeVolume := SafeVolumeControl()

; Test various levels
; safeVolume.SafeSet(50)   ; Safe level
; safeVolume.SafeSet(80)   ; Warning level
; safeVolume.SafeSet(95)   ; Dangerous level
; safeVolume.GetWithAssessment()
; safeVolume.FadeToLevel(30, 3000)  ; Fade to 30% over 3 seconds

; ============================================================
; Reference Information
; ============================================================

info := "
(
SOUND VOLUME FUNCTIONS REFERENCE:

SoundGetVolume():
  Syntax: Volume := SoundGetVolume([Component, Device])
  Returns: Volume level as percentage (0.0-100.0)
  Default: Master volume (component omitted)

SoundSetVolume():
  Syntax: SoundSetVolume(NewVolume [, Component, Device])
  NewVolume: 0-100 (absolute) or +/-N (relative)
  Examples:
    SoundSetVolume(50)    → Set to 50%
    SoundSetVolume("+10") → Increase by 10%
    SoundSetVolume("-5")  → Decrease by 5%

Components (Vista+):
  • Empty/Omitted = Master Volume
  • "Wave" = Wave/Audio output
  • "Microphone" = Microphone input
  • Other components vary by system

Error Handling:
  • Use Try/Catch for reliability
  • Component may not exist on all systems
  • Returns empty string if error

Volume Levels:
  0%      → Silent/Muted
  1-20%   → Very low
  21-40%  → Low
  41-60%  → Medium
  61-80%  → High
  81-100% → Very high/Maximum

Safety Guidelines:
  • WHO recommends max 85% for safe listening
  • Warn users before high volumes
  • Implement volume limits
  • Consider hearing protection
  • Add gradual fade for comfort

Common Uses:
  ✓ Volume control hotkeys
  ✓ Application audio management
  ✓ Automatic volume adjustment
  ✓ Time-based volume changes
  ✓ Gaming audio profiles
  ✓ Accessibility features

Best Practices:
  1. Validate volume levels (0-100)
  2. Use relative adjustments for fine control
  3. Implement safety warnings
  4. Add visual/audio feedback
  5. Save user preferences
  6. Handle errors gracefully
  7. Test on different systems

Hotkey Ideas:
  • Volume up/down
  • Mute toggle
  • Preset volumes
  • Application-specific volumes
  • Time-based volume schedules
  • Meeting/presentation mode
)"

MsgBox(info, "Volume Control Reference", "Icon!")
