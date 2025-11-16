#Requires AutoHotkey v2.0
/**
 * BuiltIn_SoundVolume_02.ahk
 *
 * DESCRIPTION:
 * Advanced volume control including mute, profiles, and automation
 *
 * FEATURES:
 * - Mute/unmute functionality
 * - Volume profiles and scenes
 * - Time-based volume automation
 * - Application-specific volume memory
 * - Advanced volume control systems
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SoundGetVolume.htm
 * https://www.autohotkey.com/docs/v2/lib/SoundSetVolume.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - Volume mute/unmute patterns
 * - State management
 * - Timer-based automation
 * - Profile systems
 * - Hotkey integration
 *
 * LEARNING POINTS:
 * 1. Mute = setting volume to 0 (no dedicated mute function)
 * 2. Store previous volume to unmute correctly
 * 3. Create volume profiles for different scenarios
 * 4. Automate volume based on time/events
 * 5. Remember per-application volume settings
 * 6. Build comprehensive audio management systems
 */

; ============================================================
; Example 1: Mute/Unmute System
; ============================================================

/**
 * Simple mute/unmute toggle
 */
class MuteController {
    static isMuted := false
    static savedVolume := 0

    /**
     * Toggle mute state
     */
    static Toggle() {
        if this.isMuted {
            this.Unmute()
        } else {
            this.Mute()
        }
    }

    /**
     * Mute audio
     */
    static Mute() {
        if this.isMuted {
            MsgBox("Audio is already muted", "Info", "Iconi T1")
            return
        }

        try {
            ; Save current volume
            this.savedVolume := SoundGetVolume()

            ; Set volume to 0
            SoundSetVolume(0)

            this.isMuted := true

            ToolTip("🔇 MUTED (was " Round(this.savedVolume) "%)")
            SetTimer(() => ToolTip(), -2000)

        } catch as err {
            MsgBox("Error muting:`n" err.Message, "Error", "Iconx")
        }
    }

    /**
     * Unmute audio
     */
    static Unmute() {
        if !this.isMuted {
            MsgBox("Audio is not muted", "Info", "Iconi T1")
            return
        }

        try {
            ; Restore saved volume
            restoreLevel := this.savedVolume > 0 ? this.savedVolume : 50

            SoundSetVolume(restoreLevel)

            this.isMuted := false

            ToolTip("🔊 UNMUTED (restored to " Round(restoreLevel) "%)")
            SetTimer(() => ToolTip(), -2000)

        } catch as err {
            MsgBox("Error unmuting:`n" err.Message, "Error", "Iconx")
        }
    }

    /**
     * Get current mute status
     */
    static GetStatus() {
        status := this.isMuted ? "MUTED" : "UNMUTED"
        currentVolume := SoundGetVolume()

        MsgBox("Mute Status: " status "`n"
             . "Current Volume: " Round(currentVolume) "%`n"
             . "Saved Volume: " Round(this.savedVolume) "%",
             "Mute Status", "Iconi")
    }
}

; Test mute controller
; MuteController.Toggle()  ; Mute
; MuteController.Toggle()  ; Unmute
; MuteController.GetStatus()

; Setup mute hotkey: Ctrl+Alt+M
; ^!m::MuteController.Toggle()

; ============================================================
; Example 2: Volume Profiles
; ============================================================

/**
 * Manage different volume profiles for various scenarios
 */
class VolumeProfiles {
    /**
     * Initialize with default profiles
     */
    __New() {
        this.currentProfile := "Normal"
        this.profiles := Map(
            "Silent", 0,
            "Meeting", 15,
            "Work", 35,
            "Normal", 50,
            "Entertainment", 65,
            "Gaming", 75,
            "Party", 90
        )
    }

    /**
     * Apply a profile
     *
     * @param {String} profileName - Name of profile to apply
     */
    ApplyProfile(profileName) {
        if !this.profiles.Has(profileName) {
            MsgBox("Profile not found: " profileName, "Error", "Iconx")
            return false
        }

        try {
            level := this.profiles[profileName]
            oldVolume := SoundGetVolume()

            SoundSetVolume(level)

            this.currentProfile := profileName

            MsgBox("Profile Applied: " profileName "`n`n"
                 . "Previous: " Round(oldVolume) "%`n"
                 . "New: " level "%",
                 "Profile", "Iconi T2")

            return true

        } catch as err {
            MsgBox("Error applying profile:`n" err.Message,
                   "Error", "Iconx")
            return false
        }
    }

    /**
     * List all profiles
     */
    ListProfiles() {
        output := "VOLUME PROFILES:`n`n"
        output .= "Current: " this.currentProfile "`n`n"

        for name, level in this.profiles {
            marker := (name = this.currentProfile) ? "→ " : "  "
            output .= marker name ": " level "%`n"
        }

        MsgBox(output, "Profiles", "Iconi")
    }

    /**
     * Create or update profile
     *
     * @param {String} name - Profile name
     * @param {Number} level - Volume level (0-100)
     */
    SaveProfile(name, level := "") {
        ; Use current volume if not specified
        if level = "" {
            try {
                level := SoundGetVolume()
            } catch {
                level := 50
            }
        }

        ; Validate
        level := Max(0, Min(100, level))

        this.profiles[name] := Round(level)

        MsgBox("Profile Saved:`n`n"
             . "Name: " name "`n"
             . "Level: " Round(level) "%",
             "Profile Saved", "Iconi T2")
    }

    /**
     * Delete a profile
     *
     * @param {String} name - Profile name to delete
     */
    DeleteProfile(name) {
        if !this.profiles.Has(name) {
            MsgBox("Profile not found: " name, "Error", "Iconx")
            return
        }

        result := MsgBox("Delete profile '" name "'?",
                        "Confirm Delete", "YesNo Icon?")

        if result = "Yes" {
            this.profiles.Delete(name)
            MsgBox("Profile deleted: " name, "Deleted", "Iconi T2")
        }
    }

    /**
     * Quick profile switching hotkeys
     */
    SetupHotkeys() {
        MsgBox("Profile Hotkeys Setup:`n`n"
             . "Ctrl+Alt+1 : Silent`n"
             . "Ctrl+Alt+2 : Meeting`n"
             . "Ctrl+Alt+3 : Work`n"
             . "Ctrl+Alt+4 : Normal`n"
             . "Ctrl+Alt+5 : Entertainment`n"
             . "Ctrl+Alt+6 : Gaming`n"
             . "Ctrl+Alt+P : Show Profiles",
             "Hotkeys", "Iconi")

        ^!1::this.ApplyProfile("Silent")
        ^!2::this.ApplyProfile("Meeting")
        ^!3::this.ApplyProfile("Work")
        ^!4::this.ApplyProfile("Normal")
        ^!5::this.ApplyProfile("Entertainment")
        ^!6::this.ApplyProfile("Gaming")
        ^!p::this.ListProfiles()
    }
}

; Create and test profiles
profiles := VolumeProfiles()

; Test profile system
; profiles.ListProfiles()
; profiles.ApplyProfile("Gaming")
; profiles.ApplyProfile("Meeting")
; profiles.SaveProfile("Custom", 42)
; profiles.SetupHotkeys()

; ============================================================
; Example 3: Time-Based Volume Automation
; ============================================================

/**
 * Automatically adjust volume based on time of day
 */
class VolumeScheduler {
    /**
     * Initialize scheduler
     */
    __New() {
        this.isActive := false
        this.schedules := []

        ; Default schedule
        this.AddSchedule("08:00", 40, "Morning - Work volume")
        this.AddSchedule("12:00", 50, "Lunch - Normal volume")
        this.AddSchedule("18:00", 60, "Evening - Entertainment")
        this.AddSchedule("22:00", 30, "Night - Quiet mode")
    }

    /**
     * Add a scheduled volume change
     *
     * @param {String} time - Time in HH:MM format
     * @param {Number} volume - Volume level (0-100)
     * @param {String} description - Description of schedule
     */
    AddSchedule(time, volume, description := "") {
        this.schedules.Push({
            time: time,
            volume: volume,
            description: description
        })
    }

    /**
     * Start the scheduler
     */
    Start() {
        if this.isActive {
            MsgBox("Scheduler is already running", "Info", "Iconi T1")
            return
        }

        this.isActive := true

        MsgBox("Volume Scheduler Started`n`n"
             . "Schedules: " this.schedules.Length "`n"
             . "Check interval: Every minute",
             "Scheduler Active", "Iconi")

        ; Check every minute
        SetTimer(() => this.CheckSchedule(), 60000)

        ; Check immediately
        this.CheckSchedule()
    }

    /**
     * Stop the scheduler
     */
    Stop() {
        this.isActive := false
        SetTimer(() => this.CheckSchedule(), 0)

        MsgBox("Volume Scheduler Stopped", "Scheduler", "Iconi T2")
    }

    /**
     * Check and apply schedules
     */
    CheckSchedule() {
        if !this.isActive
            return

        currentTime := FormatTime(, "HH:mm")

        for schedule in this.schedules {
            if schedule.time = currentTime {
                try {
                    oldVolume := SoundGetVolume()
                    SoundSetVolume(schedule.volume)

                    desc := schedule.description != "" ? "`n" schedule.description : ""

                    MsgBox("Scheduled Volume Change`n`n"
                         . "Time: " schedule.time "`n"
                         . "Old: " Round(oldVolume) "%`n"
                         . "New: " schedule.volume "%" desc,
                         "Schedule", "Iconi T3")

                } catch as err {
                    ; Log error but continue
                }
            }
        }
    }

    /**
     * Show all schedules
     */
    ShowSchedules() {
        output := "VOLUME SCHEDULES:`n`n"
        output .= "Status: " (this.isActive ? "ACTIVE" : "INACTIVE") "`n`n"

        for index, schedule in this.schedules {
            output .= schedule.time " → " schedule.volume "%"
            if schedule.description != ""
                output .= " (" schedule.description ")"
            output .= "`n"
        }

        MsgBox(output, "Schedules", "Iconi")
    }
}

; Create and test scheduler
; scheduler := VolumeScheduler()
; scheduler.ShowSchedules()
; scheduler.Start()
; Sleep(120000)  ; Run for 2 minutes
; scheduler.Stop()

; ============================================================
; Example 4: Application-Specific Volume Memory
; ============================================================

/**
 * Remember volume settings per application
 */
class AppVolumeManager {
    /**
     * Initialize with storage
     */
    __New() {
        this.appVolumes := Map()
        this.isMonitoring := false
        this.currentApp := ""
    }

    /**
     * Save current volume for active application
     */
    SaveForCurrentApp() {
        try {
            activeWindow := WinGetTitle("A")
            activeProcess := WinGetProcessName("A")
            volume := SoundGetVolume()

            this.appVolumes[activeProcess] := {
                volume: volume,
                title: activeWindow
            }

            MsgBox("Saved volume for:`n`n"
                 . "App: " activeProcess "`n"
                 . "Window: " activeWindow "`n"
                 . "Volume: " Round(volume) "%",
                 "Volume Saved", "Iconi T2")

        } catch as err {
            MsgBox("Error saving volume:`n" err.Message,
                   "Error", "Iconx")
        }
    }

    /**
     * Restore volume for active application
     */
    RestoreForCurrentApp() {
        try {
            activeProcess := WinGetProcessName("A")

            if !this.appVolumes.Has(activeProcess) {
                MsgBox("No saved volume for: " activeProcess,
                       "Info", "Iconi T2")
                return
            }

            data := this.appVolumes[activeProcess]
            SoundSetVolume(data.volume)

            MsgBox("Restored volume for:`n`n"
                 . "App: " activeProcess "`n"
                 . "Volume: " Round(data.volume) "%",
                 "Volume Restored", "Iconi T2")

        } catch as err {
            MsgBox("Error restoring volume:`n" err.Message,
                   "Error", "Iconx")
        }
    }

    /**
     * Start automatic volume switching
     */
    StartAutoSwitch() {
        if this.isMonitoring {
            MsgBox("Auto-switch already active", "Info", "Iconi T1")
            return
        }

        this.isMonitoring := true

        MsgBox("Automatic volume switching enabled`n`n"
             . "Volume will auto-adjust when switching apps",
             "Auto-Switch Active", "Iconi")

        ; Monitor active window changes
        SetTimer(() => this.MonitorAppSwitch(), 1000)
    }

    /**
     * Stop automatic volume switching
     */
    StopAutoSwitch() {
        this.isMonitoring := false
        SetTimer(() => this.MonitorAppSwitch(), 0)

        MsgBox("Automatic volume switching disabled",
               "Auto-Switch", "Iconi T2")
    }

    /**
     * Monitor application switches
     */
    MonitorAppSwitch() {
        if !this.isMonitoring
            return

        try {
            activeProcess := WinGetProcessName("A")

            ; Check if app changed
            if activeProcess != this.currentApp {
                this.currentApp := activeProcess

                ; If we have saved volume for this app, restore it
                if this.appVolumes.Has(activeProcess) {
                    data := this.appVolumes[activeProcess]
                    SoundSetVolume(data.volume)

                    ToolTip("Volume: " Round(data.volume) "% for " activeProcess)
                    SetTimer(() => ToolTip(), -1500)
                }
            }

        } catch {
            ; Ignore errors during monitoring
        }
    }

    /**
     * Show saved volumes
     */
    ShowSavedVolumes() {
        output := "SAVED APPLICATION VOLUMES:`n`n"

        if this.appVolumes.Count = 0 {
            output .= "No saved volumes yet"
        } else {
            for app, data in this.appVolumes {
                output .= app ": " Round(data.volume) "%`n"
            }
        }

        MsgBox(output, "Saved Volumes", "Iconi")
    }
}

; Create and test app volume manager
appVol := AppVolumeManager()

; Test app-specific volumes
; appVol.SaveForCurrentApp()
; appVol.RestoreForCurrentApp()
; appVol.ShowSavedVolumes()
; appVol.StartAutoSwitch()

; ============================================================
; Example 5: Volume Fade Effects
; ============================================================

/**
 * Create smooth volume transitions and fades
 */
class VolumeFader {
    /**
     * Fade volume to target level
     *
     * @param {Number} targetVolume - Target volume (0-100)
     * @param {Integer} durationMs - Fade duration in milliseconds
     */
    static FadeTo(targetVolume, durationMs := 2000) {
        try {
            startVolume := SoundGetVolume()
            difference := targetVolume - startVolume
            steps := 30
            stepSize := difference / steps
            stepDelay := durationMs / steps

            Loop steps {
                newVolume := startVolume + (stepSize * A_Index)
                SoundSetVolume(newVolume)

                ToolTip("Fading: " Round(newVolume) "%")
                Sleep(stepDelay)
            }

            ; Ensure exact target
            SoundSetVolume(targetVolume)
            ToolTip()

        } catch as err {
            MsgBox("Error during fade:`n" err.Message,
                   "Error", "Iconx")
        }
    }

    /**
     * Fade out (to silence)
     *
     * @param {Integer} durationMs - Fade duration
     */
    static FadeOut(durationMs := 3000) {
        MsgBox("Fading out audio...", "Fade Out", "T1")
        this.FadeTo(0, durationMs)
        MsgBox("Fade out complete - Audio muted", "Done", "Iconi T2")
    }

    /**
     * Fade in (from silence to level)
     *
     * @param {Number} targetVolume - Target volume
     * @param {Integer} durationMs - Fade duration
     */
    static FadeIn(targetVolume := 50, durationMs := 3000) {
        ; Set to 0 first
        SoundSetVolume(0)
        Sleep(100)

        MsgBox("Fading in audio to " targetVolume "%...",
               "Fade In", "T1")

        this.FadeTo(targetVolume, durationMs)

        MsgBox("Fade in complete", "Done", "Iconi T2")
    }

    /**
     * Cross-fade between two volumes
     *
     * @param {Number} volume1 - First volume
     * @param {Number} volume2 - Second volume
     * @param {Integer} durationMs - Duration per fade
     */
    static CrossFade(volume1, volume2, durationMs := 2000) {
        MsgBox("Cross-fading:`n"
             . volume1 "% → " volume2 "% → " volume1 "%",
             "Cross Fade", "T1")

        this.FadeTo(volume1, durationMs)
        Sleep(500)
        this.FadeTo(volume2, durationMs)
        Sleep(500)
        this.FadeTo(volume1, durationMs)
    }

    /**
     * Pulse effect (fade in/out repeatedly)
     *
     * @param {Integer} pulses - Number of pulses
     * @param {Number} highVolume - High volume level
     * @param {Number} lowVolume - Low volume level
     */
    static Pulse(pulses := 3, highVolume := 70, lowVolume := 30) {
        MsgBox("Starting pulse effect: " pulses " pulses",
               "Pulse", "T1")

        Loop pulses {
            this.FadeTo(highVolume, 1000)
            Sleep(200)
            this.FadeTo(lowVolume, 1000)
            Sleep(200)
        }

        ; Return to mid-level
        this.FadeTo(50, 1000)
    }
}

; Test volume fades
; VolumeFader.FadeTo(30, 3000)
; VolumeFader.FadeOut(3000)
; VolumeFader.FadeIn(60, 3000)
; VolumeFader.CrossFade(30, 80, 2000)
; VolumeFader.Pulse(3, 70, 30)

; ============================================================
; Example 6: Smart Volume Adjuster
; ============================================================

/**
 * Intelligent volume adjustment based on context
 */
class SmartVolumeAdjuster {
    /**
     * Initialize smart adjuster
     */
    __New() {
        this.quietHoursStart := "22:00"
        this.quietHoursEnd := "08:00"
        this.quietHoursVolume := 25
        this.normalVolume := 50
    }

    /**
     * Check if currently in quiet hours
     *
     * @returns {Boolean} - True if in quiet hours
     */
    IsQuietHours() {
        currentTime := FormatTime(, "HH:mm")
        return (currentTime >= this.quietHoursStart or
                currentTime < this.quietHoursEnd)
    }

    /**
     * Apply appropriate volume for current context
     */
    ApplyContextVolume() {
        if this.IsQuietHours() {
            SoundSetVolume(this.quietHoursVolume)
            MsgBox("Quiet Hours Active`n`n"
                 . "Volume set to: " this.quietHoursVolume "%",
                 "Quiet Hours", "Iconi T2")
        } else {
            SoundSetVolume(this.normalVolume)
            MsgBox("Normal Hours`n`n"
                 . "Volume set to: " this.normalVolume "%",
                 "Normal", "Iconi T2")
        }
    }

    /**
     * Adjust volume based on window type
     */
    AdjustForWindow() {
        try {
            activeTitle := WinGetTitle("A")
            activeProcess := WinGetProcessName("A")

            ; Gaming apps - higher volume
            if InStr(activeProcess, "game") or
               InStr(activeTitle, "Game") {
                SoundSetVolume(75)
                ToolTip("Gaming volume: 75%")
            }
            ; Video players - medium-high
            else if InStr(activeProcess, "vlc") or
                    InStr(activeProcess, "wmplayer") {
                SoundSetVolume(60)
                ToolTip("Video volume: 60%")
            }
            ; Browsers - medium
            else if InStr(activeProcess, "chrome") or
                    InStr(activeProcess, "firefox") {
                SoundSetVolume(50)
                ToolTip("Browser volume: 50%")
            }
            ; Default - normal
            else {
                SoundSetVolume(45)
                ToolTip("Default volume: 45%")
            }

            SetTimer(() => ToolTip(), -2000)

        } catch {
            ; Ignore errors
        }
    }

    /**
     * Setup smart volume automation
     */
    EnableSmartMode() {
        MsgBox("Smart Volume Mode Enabled`n`n"
             . "• Auto-adjusts for quiet hours`n"
             . "• Context-aware volume`n"
             . "• Window-based adjustment",
             "Smart Mode", "Iconi")

        ; Check every 5 minutes
        SetTimer(() => this.ApplyContextVolume(), 300000)

        ; Apply immediately
        this.ApplyContextVolume()
    }
}

; Test smart adjuster
; smartVol := SmartVolumeAdjuster()
; smartVol.ApplyContextVolume()
; smartVol.AdjustForWindow()
; smartVol.EnableSmartMode()

; ============================================================
; Example 7: Complete Volume Control Panel
; ============================================================

/**
 * Comprehensive volume control system
 */
class VolumeControlPanel {
    /**
     * Initialize control panel
     */
    __New() {
        this.muted := false
        this.savedVolume := 50
    }

    /**
     * Show control panel menu
     */
    ShowMenu() {
        try {
            currentVolume := Round(SoundGetVolume())
            status := this.muted ? "MUTED" : "ACTIVE"

            menu := "
            (
            VOLUME CONTROL PANEL

            Current: " currentVolume "% [" status "]

            1. Set Volume
            2. Mute/Unmute
            3. Fade Out
            4. Fade In
            5. Volume Presets
            6. Save Current
            7. Quick Adjustments
            8. Exit

            Enter choice (1-8):
            )"

            choice := InputBox(menu, "Volume Control", "w300 h400")

            if choice.Result = "Cancel"
                return

            this.ProcessChoice(choice.Value)

        } catch as err {
            MsgBox("Error: " err.Message, "Error", "Iconx")
        }
    }

    /**
     * Process menu choice
     *
     * @param {String} choice - User's menu choice
     */
    ProcessChoice(choice) {
        switch choice {
            case "1": this.SetVolume()
            case "2": this.ToggleMute()
            case "3": VolumeFader.FadeOut(3000)
            case "4": VolumeFader.FadeIn(50, 3000)
            case "5": this.ShowPresets()
            case "6": this.SaveCurrent()
            case "7": this.QuickAdjust()
            case "8": return
            default: MsgBox("Invalid choice", "Error", "Iconx T2")
        }

        ; Show menu again
        this.ShowMenu()
    }

    /**
     * Set volume interactively
     */
    SetVolume() {
        result := InputBox("Enter volume level (0-100):",
                          "Set Volume", , "50")

        if result.Result = "OK" {
            level := Integer(result.Value)
            level := Max(0, Min(100, level))
            SoundSetVolume(level)
            MsgBox("Volume set to " level "%", "Done", "Iconi T1")
        }
    }

    /**
     * Toggle mute
     */
    ToggleMute() {
        MuteController.Toggle()
        this.muted := !this.muted
    }

    /**
     * Show volume presets
     */
    ShowPresets() {
        result := InputBox("Select preset:`n`n"
                         . "1. Silent (0%)`n"
                         . "2. Low (25%)`n"
                         . "3. Medium (50%)`n"
                         . "4. High (75%)`n"
                         . "5. Maximum (100%)",
                         "Presets", , "3")

        if result.Result = "OK" {
            switch result.Value {
                case "1": SoundSetVolume(0)
                case "2": SoundSetVolume(25)
                case "3": SoundSetVolume(50)
                case "4": SoundSetVolume(75)
                case "5": SoundSetVolume(100)
            }
        }
    }

    /**
     * Save current volume
     */
    SaveCurrent() {
        this.savedVolume := SoundGetVolume()
        MsgBox("Saved volume: " Round(this.savedVolume) "%",
               "Saved", "Iconi T2")
    }

    /**
     * Quick volume adjustments
     */
    QuickAdjust() {
        result := InputBox("Quick Adjust:`n`n"
                         . "1. +10%`n"
                         . "2. +5%`n"
                         . "3. -5%`n"
                         . "4. -10%",
                         "Quick Adjust")

        if result.Result = "OK" {
            switch result.Value {
                case "1": SoundSetVolume("+10")
                case "2": SoundSetVolume("+5")
                case "3": SoundSetVolume("-5")
                case "4": SoundSetVolume("-10")
            }
        }
    }
}

; Create control panel
; controlPanel := VolumeControlPanel()
; controlPanel.ShowMenu()

; Or bind to hotkey: Ctrl+Alt+V
; ^!v::controlPanel.ShowMenu()

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED VOLUME CONTROL TECHNIQUES:

Mute Implementation:
  • No built-in mute function
  • Mute = Save volume, then set to 0
  • Unmute = Restore saved volume
  • Track mute state separately

Volume Profiles:
  • Different volumes for scenarios
  • Quick switching between profiles
  • Save/load custom profiles
  • Hotkey assignment

Time-Based Automation:
  • Schedule volume changes
  • Quiet hours (night/early morning)
  • Work/break schedules
  • Event-triggered changes

App-Specific Volumes:
  • Remember per-application settings
  • Auto-switch when changing apps
  • Gaming vs work profiles
  • Media player preferences

Fade Effects:
  • Smooth transitions
  • Fade in/out
  • Cross-fades
  • Pulse effects
  • Gradual changes (not jarring)

Smart Adjustments:
  • Context-aware volume
  • Window type detection
  • Time-of-day awareness
  • Environmental adaptation

Complete Systems:
  • Combine all features
  • User-friendly interfaces
  • Hotkey integration
  • Status monitoring
  • Profile management

Best Practices:
  ✓ Always save volume before muting
  ✓ Validate all user inputs
  ✓ Provide visual feedback
  ✓ Use smooth transitions
  ✓ Consider hearing safety
  ✓ Test on different systems
  ✓ Handle errors gracefully
  ✓ Save user preferences

Common Patterns:
  • Quick mute: Save + Set 0
  • Quick unmute: Restore saved
  • Profile switch: Direct set
  • Fade: Gradual steps
  • Schedule: Timer-based
  • Smart: Context detection

Implementation Tips:
  1. Use classes for organization
  2. Separate concerns (mute, fade, etc.)
  3. Provide both GUI and hotkeys
  4. Add tooltips for feedback
  5. Log changes for debugging
  6. Allow user customization
  7. Test edge cases

Safety Considerations:
  • Maximum volume limits
  • Warnings for high volumes
  • Gradual increases
  • Hearing protection reminders
  • Child-safe defaults
)"

MsgBox(info, "Advanced Volume Control Reference", "Icon!")
