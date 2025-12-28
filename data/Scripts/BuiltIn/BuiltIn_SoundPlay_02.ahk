#Requires AutoHotkey v2.0

/**
 * BuiltIn_SoundPlay_02.ahk
 * 
 * DESCRIPTION:
 * Advanced usage of SoundPlay() for complex audio notification systems and automation
 * 
 * FEATURES:
 * - Multi-sound sequences and patterns
 * - Audio feedback for hotkeys and automation
 * - Background music and ambient sounds
 * - Event-driven sound systems
 * - Custom sound libraries and managers
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SoundPlay.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - Advanced SoundPlay() patterns
 * - Class-based sound management
 * - Hotkey integration with audio
 * - Asynchronous sound playback
 * - Sound queuing systems
 * 
 * LEARNING POINTS:
 * 1. Create complex sound sequences for rich feedback
 * 2. Integrate sounds with hotkeys and automation
 * 3. Build reusable sound management systems
 * 4. Queue sounds for organized playback
 * 5. Combine visual and audio feedback
 * 6. Create accessible user interfaces with sound
 */

; ============================================================
; Example 1: Sound Sequence Generator
; ============================================================

/**
 * Generate various sound patterns and sequences
 */
class SoundSequencer {
    /**
     * Play ascending alert pattern
     */
    static Ascending() {
        sounds := ["*64", "*32", "*48", "*16"]
        delays := [300, 300, 300, 300]

        MsgBox("Playing ascending alert pattern", "Pattern", "T1")

        for index, sound in sounds {
            SoundPlay(sound)
            Sleep(delays[index])
        }
    }

    /**
     * Play descending pattern
     */
    static Descending() {
        sounds := ["*16", "*48", "*32", "*64"]
        delays := [300, 300, 300, 300]

        MsgBox("Playing descending pattern", "Pattern", "T1")

        for index, sound in sounds {
            SoundPlay(sound)
            Sleep(delays[index])
        }
    }

    /**
     * Play urgent alert pattern
     */
    static UrgentAlert() {
        MsgBox("Playing URGENT alert pattern!", "URGENT", "Icon! T1")

        Loop 3 {
            SoundPlay("*16")
            Sleep(150)
            SoundPlay("*48")
            Sleep(150)
        }
    }

    /**
     * Play success jingle
     */
    static SuccessJingle() {
        MsgBox("Playing success jingle", "Success", "Iconi T1")

        sounds := ["*64", "*64", "*64"]
        delays := [100, 100, 200]

        for index, sound in sounds {
            SoundPlay(sound)
            Sleep(delays[index])
        }
    }

    /**
     * Play attention grabber
     */
    static AttentionGrabber() {
        MsgBox("Getting your attention!", "Attention", "T1")

        Loop 5 {
            SoundPlay("*48")
            Sleep(250)
        }
    }
}

; Test sequences
; SoundSequencer.Ascending()
; SoundSequencer.Descending()
; SoundSequencer.UrgentAlert()
; SoundSequencer.SuccessJingle()
; SoundSequencer.AttentionGrabber()

; ============================================================
; Example 2: Hotkey Audio Feedback System
; ============================================================

/**
 * Add audio feedback to hotkeys for better UX
 */
class HotkeyWithSound {
    /**
     * Initialize hotkey sound system
     */
    static __New() {
        this.enabled := true
    }

    /**
     * Example: Clipboard operations with sound
     */
    static SetupClipboardHotkeys() {
        ; Ctrl+C - Copy with sound
        ^c:: {
            Send("^c")
            if HotkeyWithSound.enabled {
                SoundPlay("*64")
                ToolTip("Copied to clipboard")
                SetTimer(() => ToolTip(), -1000)
            }
        }

        ; Ctrl+V - Paste with sound
        ^v:: {
            Send("^v")
            if HotkeyWithSound.enabled {
                SoundPlay("*48")
                ToolTip("Pasted from clipboard")
                SetTimer(() => ToolTip(), -1000)
            }
        }

        ; Ctrl+X - Cut with sound
        ^x:: {
            Send("^x")
            if HotkeyWithSound.enabled {
                SoundPlay("*32")
                ToolTip("Cut to clipboard")
                SetTimer(() => ToolTip(), -1000)
            }
        }
    }

    /**
     * Window management with audio feedback
     */
    static SetupWindowHotkeys() {
        ; Win+Up - Maximize with sound
        #Up:: {

            WinMaximize("A")
            if HotkeyWithSound.enabled {
                SoundPlay("*64")
                ToolTip("Window Maximized")
                SetTimer(() => ToolTip(), -800)
            }
        }

        ; Win+Down - Minimize with sound
        #Down:: {

            WinMinimize("A")
            if HotkeyWithSound.enabled {
                SoundPlay("*48")
                ToolTip("Window Minimized")
                SetTimer(() => ToolTip(), -800)
            }
        }
    }

    /**
     * Toggle audio feedback
     */
    static Toggle() {
        this.enabled := !this.enabled
        status := this.enabled ? "enabled" : "disabled"

        SoundPlay(this.enabled ? "*64" : "*48")
        MsgBox("Hotkey audio feedback is " status, "Settings", "Iconi T2")
    }
}

; Setup hotkeys with sound (commented out to avoid conflicts)
; HotkeyWithSound.SetupClipboardHotkeys()
; HotkeyWithSound.SetupWindowHotkeys()

; Toggle hotkey: Ctrl+Alt+S
; ^!s::HotkeyWithSound.Toggle()

; ============================================================
; Example 3: Audio Notification Manager
; ============================================================

/**
 * Comprehensive notification system with sound categories
 */
class NotificationManager {
    /**
     * Initialize notification manager
     */
    __New() {
        this.soundEnabled := true
        this.visualEnabled := true
        this.notificationLog := []
    }

    /**
     * Send notification with sound and visual feedback
     * 
     * @param {String} title - Notification title
     * @param {String} message - Notification message
     * @param {String} type - Type: info, success, warning, error, critical
     * @param {Integer} duration - Display duration in seconds (0 = must close)
     */
    Notify(title, message, type := "info", duration := 3) {
        ; Log notification
        this.notificationLog.Push({
            time: A_Now,
            title: title,
            message: message,
            type: type
        })

        ; Play sound based on type
        if this.soundEnabled {
            this.PlayNotificationSound(type)
        }

        ; Show visual notification
        if this.visualEnabled {
            icon := this.GetIcon(type)
            timeout := duration > 0 ? "T" duration : ""
            MsgBox(message, title, icon " " timeout)
        }
    }

    /**
     * Play appropriate sound for notification type
     * 
     * @param {String} type - Notification type
     */
    PlayNotificationSound(type) {
        switch type {
            case "info":
                SoundPlay("*64")

            case "success":
                Loop 2 {
                    SoundPlay("*64")
                    Sleep(100)
                }

            case "warning":
                SoundPlay("*48")

            case "error":
                Loop 2 {
                    SoundPlay("*16")
                    Sleep(200)
                }

            case "critical":
                Loop 4 {
                    SoundPlay("*16")
                    Sleep(150)
                }

            default:
                SoundPlay("*64")
        }
    }

    /**
     * Get appropriate icon for message box
     * 
     * @param {String} type - Notification type
     * @returns {String} - Icon code
     */
    GetIcon(type) {
        switch type {
            case "info": return "Iconi"
            case "success": return "Iconi"
            case "warning": return "Icon!"
            case "error": return "Iconx"
            case "critical": return "Iconx"
            default: return "Iconi"
        }
    }

    /**
     * Show notification history
     */
    ShowHistory() {
        if this.notificationLog.Length = 0 {
            MsgBox("No notifications in history", "History", "Iconi")
            return
        }

        output := "NOTIFICATION HISTORY:`n`n"
        count := Min(10, this.notificationLog.Length)

        Loop count {
            index := this.notificationLog.Length - A_Index + 1
            notif := this.notificationLog[index]

            output .= FormatTime(notif.time, "HH:mm:ss") " - "
            output .= "[" StrUpper(notif.type) "] "
            output .= notif.title "`n"
        }

        MsgBox(output, "Notification History", "Iconi")
    }

    /**
     * Clear notification history
     */
    ClearHistory() {
        this.notificationLog := []
        SoundPlay("*64")
        MsgBox("Notification history cleared", "History", "Iconi T2")
    }
}

; Create and test notification manager
nm := NotificationManager()

; Test different notification types
; nm.Notify("Welcome", "Application started successfully", "success", 2)
; nm.Notify("Update Available", "A new version is available", "info", 3)
; nm.Notify("Low Memory", "System memory is running low", "warning", 4)
; nm.Notify("Connection Failed", "Could not connect to server", "error", 5)
; nm.Notify("SYSTEM CRITICAL", "Immediate action required!", "critical", 0)
; nm.ShowHistory()

; ============================================================
; Example 4: Task Completion Audio Feedback
; ============================================================

/**
 * Provide audio feedback for long-running tasks
 */
class TaskRunner {
    /**
     * Run a task with progress sounds
     * 
     * @param {String} taskName - Name of the task
     * @param {Integer} steps - Number of steps in task
     */
    static RunWithAudio(taskName, steps := 5) {
        MsgBox("Starting task: " taskName "`n"
            . "Steps: " steps "`n`n"
            . "You'll hear sounds as progress is made",
            "Task Starting", "Iconi T2")

        ; Start sound
        SoundPlay("*64")
        Sleep(500)

        Loop steps {
            ; Simulate work
            MsgBox("Processing step " A_Index " of " steps "...",
                taskName, "T1")
            Sleep(1000)

            ; Progress sound
            if A_Index < steps {
                SoundPlay("*32")  ; Question sound for progress
            }
        }

        ; Completion sound sequence
        Loop 3 {
            SoundPlay("*64")
            Sleep(150)
        }

        MsgBox("Task completed successfully!`n`n"
            . "Task: " taskName "`n"
            . "Steps completed: " steps,
            "Task Complete", "Iconi")
    }

    /**
     * Run task with error handling and audio
     * 
     * @param {String} taskName - Name of the task
     * @param {Boolean} simulateError - Whether to simulate an error
     */
    static RunWithErrorHandling(taskName, simulateError := false) {
        try {
            SoundPlay("*64")  ; Start sound
            MsgBox("Starting: " taskName, "Task", "T1")

            ; Simulate work
            Loop 3 {
                Sleep(800)
                if simulateError and A_Index = 2 {
                    throw Error("Simulated task error at step 2")
                }
            }

            ; Success sounds
            Loop 2 {
                SoundPlay("*64")
                Sleep(100)
            }
            MsgBox("Success: " taskName, "Complete", "Iconi T2")

        } catch as err {
            ; Error sound sequence
            Loop 3 {
                SoundPlay("*16")
                Sleep(200)
            }
            MsgBox("Error in task: " taskName "`n`n"
                . "Error: " err.Message,
                "Task Failed", "Iconx")
        }
    }
}

; Test task runner
; TaskRunner.RunWithAudio("Data Processing", 5)
; TaskRunner.RunWithErrorHandling("File Upload", false)  ; Success
; TaskRunner.RunWithErrorHandling("File Upload", true)   ; Error

; ============================================================
; Example 5: Sound Library Manager
; ============================================================

/**
 * Manage a library of custom sounds for application
 */
class SoundLibrary {
    /**
     * Initialize sound library
     */
    __New() {
        this.sounds := Map()
        this.basePath := A_ScriptDir "\Sounds\"
        this.InitializeDefaultSounds()
    }

    /**
     * Setup default sound mappings
     */
    InitializeDefaultSounds() {
        ; Map friendly names to system sounds
        this.sounds["click"] := "*64"
        this.sounds["error"] := "*16"
        this.sounds["warning"] := "*48"
        this.sounds["question"] := "*32"
        this.sounds["success"] := "*64"

        ; Could add custom WAV files here:
        ; this.sounds["startup"] := this.basePath "startup.wav"
        ; this.sounds["shutdown"] := this.basePath "shutdown.wav"
    }

    /**
     * Register a custom sound
     * 
     * @param {String} name - Sound name/alias
     * @param {String} path - File path or system sound code
     */
    Register(name, path) {
        this.sounds[name] := path
        MsgBox("Registered sound: " name, "Sound Library", "Iconi T1")
    }

    /**
     * Play a sound by name
     * 
     * @param {String} name - Name of sound to play
     * @param {Integer} wait - Whether to wait for completion
     * @returns {Boolean} - Success status
     */
    Play(name, wait := 0) {
        if !this.sounds.Has(name) {
            MsgBox("Sound not found in library: " name, "Error", "Iconx T2")
            return false
        }

        soundPath := this.sounds[name]

        try {
            SoundPlay(soundPath, wait)
            return true
        } catch as err {
            MsgBox("Error playing sound: " name "`n" err.Message,
                "Playback Error", "Iconx")
            return false
        }
    }

    /**
     * List all available sounds
     */
    ListSounds() {
        output := "AVAILABLE SOUNDS:`n`n"

        for name, path in this.sounds {
            output .= "• " name " → " path "`n"
        }

        MsgBox(output, "Sound Library", "Iconi")
    }

    /**
     * Play a sequence of sounds by name
     * 
     * @param {Array} soundNames - Array of sound names
     * @param {Integer} delay - Delay between sounds in ms
     */
    PlaySequence(soundNames, delay := 500) {
        for name in soundNames {
            this.Play(name)
            Sleep(delay)
        }
    }
}

; Create and test sound library
soundLib := SoundLibrary()

; List available sounds
; soundLib.ListSounds()

; Play individual sounds
; soundLib.Play("click")
; soundLib.Play("success")
; soundLib.Play("error")

; Play sequence
; soundLib.PlaySequence(["click", "click", "success"], 300)

; Register custom sounds
; soundLib.Register("alarm", "*48")
; soundLib.Play("alarm")

; ============================================================
; Example 6: Automation Event Sounds
; ============================================================

/**
 * Audio feedback for automation events
 */
class AutomationSounds {
    /**
     * Play sound when automation starts
     */
    static OnStart() {
        SoundPlay("*64")
        ToolTip("Automation Started")
        SetTimer(() => ToolTip(), -1500)
    }

    /**
     * Play sound when automation completes
     */
    static OnComplete() {
        Loop 2 {
            SoundPlay("*64")
            Sleep(100)
        }
        ToolTip("Automation Complete")
        SetTimer(() => ToolTip(), -2000)
    }

    /**
     * Play sound on automation error
     */
    static OnError() {
        Loop 2 {
            SoundPlay("*16")
            Sleep(200)
        }
        ToolTip("Automation Error!")
        SetTimer(() => ToolTip(), -2000)
    }

    /**
     * Play sound on automation pause
     */
    static OnPause() {
        SoundPlay("*48")
        ToolTip("Automation Paused")
        SetTimer(() => ToolTip(), -1500)
    }

    /**
     * Play sound on automation resume
     */
    static OnResume() {
        SoundPlay("*32")
        ToolTip("Automation Resumed")
        SetTimer(() => ToolTip(), -1500)
    }

    /**
     * Example automation workflow with sounds
     */
    static DemoWorkflow() {
        this.OnStart()
        Sleep(2000)

        ; Simulate automation steps
        Loop 3 {
            MsgBox("Automation step " A_Index " of 3", "Working", "T1")
            SoundPlay("*32")  ; Progress sound
            Sleep(1000)
        }

        this.OnComplete()
    }
}

; Test automation sounds
; AutomationSounds.DemoWorkflow()
; AutomationSounds.OnError()
; AutomationSounds.OnPause()
; AutomationSounds.OnResume()

; ============================================================
; Example 7: Accessibility Audio Cues
; ============================================================

/**
 * Audio cues for accessibility and user guidance
 */
class AccessibilityAudio {
    /**
     * Provide audio guidance for navigation
     * 
     * @param {String} location - Current location/section
     */
    static AnnounceLocation(location) {
        SoundPlay("*64")
        MsgBox("Now at: " location, "Navigation", "Iconi T2")
    }

    /**
     * Indicate successful action
     */
    static ConfirmAction() {
        SoundPlay("*64")
        Sleep(100)
        SoundPlay("*64")
    }

    /**
     * Indicate invalid action
     */
    static InvalidAction() {
        SoundPlay("*48")
        MsgBox("That action is not available", "Invalid", "Icon! T2")
    }

    /**
     * Provide counting audio cues
     * 
     * @param {Integer} count - Number to count
     */
    static CountWithSound(count) {
        Loop count {
            SoundPlay("*32")
            MsgBox("Count: " A_Index, "Counting", "T0.5")
            Sleep(600)
        }

        ; Final completion sound
        Loop 2 {
            SoundPlay("*64")
            Sleep(150)
        }
        MsgBox("Counting complete: " count, "Done", "Iconi T2")
    }

    /**
     * Timer countdown with audio
     * 
     * @param {Integer} seconds - Seconds to count down
     */
    static CountdownTimer(seconds) {
        Loop seconds {
            remaining := seconds - A_Index + 1
            SoundPlay("*32")
            MsgBox(remaining "...", "Countdown", "T0.8")
            Sleep(1000)
        }

        ; Completion alarm
        Loop 5 {
            SoundPlay("*16")
            Sleep(200)
        }
        MsgBox("TIME'S UP!", "Countdown Complete", "Icon! T3")
    }
}

; Test accessibility features
; AccessibilityAudio.AnnounceLocation("Main Menu")
; AccessibilityAudio.ConfirmAction()
; AccessibilityAudio.InvalidAction()
; AccessibilityAudio.CountWithSound(5)
; AccessibilityAudio.CountdownTimer(5)

; ============================================================
; Reference Information
; ============================================================

info := "
(
ADVANCED SOUNDPLAY() TECHNIQUES:

Sound Sequences:
• Chain multiple sounds with delays
• Create patterns for different events
• Build custom sound 'melodies'
• Use loops for repeated sounds

Hotkey Integration:
• Add audio feedback to hotkeys
• Enhance user experience with sound
• Confirm actions audibly
• Improve accessibility

Notification Systems:
• Different sounds for severity levels
• Combine visual and audio cues
• Log notifications with timestamps
• Allow user to enable/disable sounds

Task Feedback:
• Start/progress/complete sounds
• Error audio alerts
• Countdown timers with sound
• Step-by-step audio guidance

Sound Management:
• Create sound libraries/registries
• Map friendly names to sounds
• Organize sounds by category
• Validate sounds before use

Best Practices:
✓ Don't overuse sounds (annoying!)
✓ Provide mute/disable option
✓ Use distinct sounds for different events
✓ Test sound sequences for timing
✓ Consider accessibility needs
✓ Volume should be reasonable
✓ Provide visual alternatives
✓ Test on different systems

Common Patterns:
• Success: 2-3 ascending/positive sounds
• Error: 2-3 harsh/negative sounds
• Warning: Single exclamation sound
• Info: Single gentle sound
• Critical: Rapid repeated error sounds
• Progress: Regular interval sounds
• Complete: Ascending sound sequence

Accessibility Considerations:
• Audio cues for navigation
• Confirmation sounds for actions
• Different sounds for different results
• Countdown timers with audio
• Sound alternatives to visual cues
• User control over sound settings
)"

MsgBox(info, "Advanced SoundPlay() Reference", "Icon!")
