#Requires AutoHotkey v2.0
/**
 * BuiltIn_SoundPlay_01.ahk
 *
 * DESCRIPTION:
 * Basic usage examples of SoundPlay() function for playing audio files and system sounds
 *
 * FEATURES:
 * - Play WAV files
 * - Play system sounds (asterisk, beep, question, etc.)
 * - Synchronous and asynchronous playback
 * - Audio notifications
 * - Error handling for missing files
 *
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SoundPlay.htm
 *
 * KEY V2 FEATURES DEMONSTRATED:
 * - SoundPlay() function
 * - Try/Catch error handling
 * - File existence checking
 * - System sound aliases
 * - Wait parameter for synchronous playback
 *
 * LEARNING POINTS:
 * 1. SoundPlay() can play WAV files and system sounds
 * 2. Use "*" prefix for system sounds (e.g., "*64" for question sound)
 * 3. Wait parameter controls synchronous vs asynchronous playback
 * 4. Always check file existence before playing
 * 5. Proper error handling prevents script crashes
 * 6. Can be used for audio notifications and alerts
 */

; ============================================================
; Example 1: Playing System Sounds
; ============================================================

/**
 * Demonstrates built-in Windows system sounds
 * System sounds don't require external files
 */
PlaySystemSounds() {
    MsgBox("Playing system sounds demonstration`n`n"
         . "Each sound will play one after another",
         "System Sounds", "Icon!")

    ; System sound codes:
    ; *16 or *-1 = Hand/Stop/Error
    ; *32 = Question
    ; *48 = Exclamation
    ; *64 = Asterisk/Information

    SoundPlay("*16")  ; Error/Hand sound
    Sleep(1000)

    SoundPlay("*32")  ; Question sound
    Sleep(1000)

    SoundPlay("*48")  ; Exclamation/Warning sound
    Sleep(1000)

    SoundPlay("*64")  ; Information/Asterisk sound
    Sleep(1000)

    MsgBox("System sounds demo complete!", "Complete", "Icon!")
}

; Uncomment to run:
; PlaySystemSounds()

; ============================================================
; Example 2: Simple Notification Sound Function
; ============================================================

/**
 * Play notification sounds for different event types
 *
 * @param {String} eventType - Type of notification (success, error, warning, info)
 */
NotifyWithSound(eventType) {
    switch eventType {
        case "success":
            SoundPlay("*64")  ; Asterisk - positive sound
            MsgBox("Operation completed successfully!", "Success", "Icon!")

        case "error":
            SoundPlay("*16")  ; Hand - error sound
            MsgBox("An error occurred!", "Error", "Icon!")

        case "warning":
            SoundPlay("*48")  ; Exclamation - warning sound
            MsgBox("Warning: Please review this action", "Warning", "Icon!")

        case "question":
            SoundPlay("*32")  ; Question - inquiry sound
            result := MsgBox("Do you want to continue?", "Question", "YesNo Icon?")
            return result

        default:
            SoundPlay("*64")
            MsgBox("Notification: " eventType, "Info", "Icon!")
    }
}

; Test different notification types
; NotifyWithSound("success")
; NotifyWithSound("error")
; NotifyWithSound("warning")
; NotifyWithSound("question")

; ============================================================
; Example 3: Playing WAV Files (Asynchronous)
; ============================================================

/**
 * Play a WAV file asynchronously (non-blocking)
 * The script continues while the sound plays
 */
PlayWavFileAsync() {
    ; Example with Windows default sounds
    ; These paths work on most Windows systems

    wavFiles := [
        "C:\Windows\Media\Windows Notify.wav",
        "C:\Windows\Media\Windows Error.wav",
        "C:\Windows\Media\chimes.wav"
    ]

    for index, wavPath in wavFiles {
        if FileExist(wavPath) {
            MsgBox("Playing: " wavPath "`n`nSound plays in background (async)",
                   "Playing Sound " index, "T2")

            ; Play asynchronously (Wait parameter = 0 or omitted)
            SoundPlay(wavPath)

            ; Script continues immediately - sound plays in background
            Sleep(2000)  ; Wait a bit before next sound
        } else {
            MsgBox("File not found: " wavPath, "File Missing", "Icon!")
        }
    }
}

; Uncomment to test:
; PlayWavFileAsync()

; ============================================================
; Example 4: Playing WAV Files (Synchronous)
; ============================================================

/**
 * Play a WAV file synchronously (blocking)
 * Script waits until sound finishes before continuing
 */
PlayWavFileSync() {
    wavPath := "C:\Windows\Media\tada.wav"

    if FileExist(wavPath) {
        MsgBox("Playing sound synchronously...`n`n"
             . "The script will wait until sound finishes",
             "Synchronous Playback", "Icon!")

        startTime := A_TickCount

        ; Play synchronously (Wait parameter = 1)
        SoundPlay(wavPath, 1)

        elapsed := A_TickCount - startTime

        MsgBox("Sound finished playing!`n"
             . "Time elapsed: " elapsed " ms",
             "Playback Complete", "Icon!")
    } else {
        MsgBox("Windows sound file not found: " wavPath, "Error", "Icon!")
    }
}

; Uncomment to test:
; PlayWavFileSync()

; ============================================================
; Example 5: Audio Notification System
; ============================================================

/**
 * Comprehensive audio notification system with multiple sound types
 */
class AudioNotifier {
    /**
     * Initialize the audio notifier
     */
    __New() {
        this.soundsEnabled := true
    }

    /**
     * Play notification based on severity level
     *
     * @param {String} message - Message to display
     * @param {String} level - Severity level (critical, high, medium, low, info)
     */
    Notify(message, level := "info") {
        if !this.soundsEnabled
            return

        switch level {
            case "critical":
                ; Play error sound 3 times for critical alerts
                Loop 3 {
                    SoundPlay("*16")
                    Sleep(300)
                }
                MsgBox(message, "CRITICAL ALERT", "Icon! T10")

            case "high":
                ; Play error sound twice
                Loop 2 {
                    SoundPlay("*16")
                    Sleep(300)
                }
                MsgBox(message, "High Priority", "Iconx T8")

            case "medium":
                ; Play warning sound
                SoundPlay("*48")
                MsgBox(message, "Warning", "Icon! T5")

            case "low":
                ; Play info sound
                SoundPlay("*64")
                MsgBox(message, "Notice", "Iconi T3")

            case "info":
                ; Gentle info sound
                SoundPlay("*64")
                MsgBox(message, "Information", "Iconi T2")

            default:
                MsgBox(message, "Notification", "T2")
        }
    }

    /**
     * Toggle sound notifications on/off
     */
    ToggleSounds() {
        this.soundsEnabled := !this.soundsEnabled
        status := this.soundsEnabled ? "enabled" : "disabled"
        MsgBox("Audio notifications are now " status, "Settings", "Icon!")
    }

    /**
     * Play custom success sequence
     */
    PlaySuccess() {
        if !this.soundsEnabled
            return

        SoundPlay("*64")
        Sleep(100)
        SoundPlay("*64")
        MsgBox("Operation completed successfully!", "Success", "Iconi T2")
    }
}

; Create notifier instance and test
notifier := AudioNotifier()

; Test different notification levels
; notifier.Notify("System startup complete", "info")
; notifier.Notify("Low disk space", "low")
; notifier.Notify("High CPU usage detected", "medium")
; notifier.Notify("Security threat detected", "high")
; notifier.Notify("SYSTEM FAILURE IMMINENT", "critical")
; notifier.PlaySuccess()

; ============================================================
; Example 6: Timer-Based Sound Alerts
; ============================================================

/**
 * Timer that plays sound alerts at intervals
 */
class SoundTimer {
    /**
     * Initialize timer
     *
     * @param {Integer} minutes - Minutes until alert
     * @param {String} message - Alert message
     */
    __New(minutes, message := "Time's up!") {
        this.minutes := minutes
        this.message := message
        this.isRunning := false
    }

    /**
     * Start the timer
     */
    Start() {
        if this.isRunning {
            MsgBox("Timer is already running!", "Error", "Icon!")
            return
        }

        this.isRunning := true
        milliseconds := this.minutes * 60 * 1000

        MsgBox("Timer started for " this.minutes " minute(s)!`n`n"
             . "You will hear a sound when time is up.",
             "Timer Started", "Iconi")

        ; Set timer to fire once
        SetTimer(() => this.TimerAlert(), -milliseconds)
    }

    /**
     * Called when timer expires
     */
    TimerAlert() {
        ; Play alert sound 5 times
        Loop 5 {
            SoundPlay("*48")
            Sleep(500)
        }

        MsgBox(this.message, "TIMER ALERT", "Icon! T0")
        this.isRunning := false
    }
}

; Create and start a timer (example: 0.1 minutes for testing)
; timer := SoundTimer(0.1, "Your break time is over!")
; timer.Start()

; ============================================================
; Example 7: Error Handling and File Validation
; ============================================================

/**
 * Safe sound player with comprehensive error handling
 */
class SafeSoundPlayer {
    /**
     * Play sound with full error handling
     *
     * @param {String} soundPath - Path to sound file or system sound code
     * @param {Integer} wait - Whether to wait for sound to finish (0 or 1)
     * @returns {Boolean} - Success status
     */
    static Play(soundPath, wait := 0) {
        try {
            ; Check if it's a system sound (starts with *)
            if SubStr(soundPath, 1, 1) = "*" {
                SoundPlay(soundPath, wait)
                return true
            }

            ; For file paths, validate existence
            if !FileExist(soundPath) {
                MsgBox("Sound file not found:`n" soundPath, "File Error", "Icon!")
                return false
            }

            ; Check file extension
            SplitPath(soundPath, , , &ext)
            validExts := ["wav", "mp3", "wma", "aac"]

            if !this.IsValidExtension(ext, validExts) {
                MsgBox("Unsupported audio format: ." ext "`n`n"
                     . "Supported formats: " this.JoinArray(validExts, ", "),
                     "Format Error", "Icon!")
                return false
            }

            ; Try to play the sound
            SoundPlay(soundPath, wait)
            return true

        } catch as err {
            MsgBox("Error playing sound:`n`n"
                 . "File: " soundPath "`n"
                 . "Error: " err.Message,
                 "Playback Error", "Icon!")
            return false
        }
    }

    /**
     * Check if file extension is valid
     *
     * @param {String} ext - File extension to check
     * @param {Array} validExts - Array of valid extensions
     * @returns {Boolean} - Whether extension is valid
     */
    static IsValidExtension(ext, validExts) {
        ext := StrLower(ext)
        for validExt in validExts {
            if ext = validExt
                return true
        }
        return false
    }

    /**
     * Join array elements with separator
     *
     * @param {Array} arr - Array to join
     * @param {String} separator - Separator string
     * @returns {String} - Joined string
     */
    static JoinArray(arr, separator := ",") {
        result := ""
        for index, item in arr {
            result .= item
            if index < arr.Length
                result .= separator
        }
        return result
    }

    /**
     * Play a sequence of sounds
     *
     * @param {Array} soundPaths - Array of sound file paths
     * @param {Integer} delay - Delay between sounds in ms
     */
    static PlaySequence(soundPaths, delay := 1000) {
        for index, soundPath in soundPaths {
            MsgBox("Playing sound " index " of " soundPaths.Length,
                   "Sequence", "T1")

            if this.Play(soundPath) {
                Sleep(delay)
            }
        }
        MsgBox("Sequence complete!", "Done", "Iconi")
    }
}

; Test the safe player
; SafeSoundPlayer.Play("*64")  ; System sound
; SafeSoundPlayer.Play("C:\Windows\Media\chimes.wav")  ; Valid file
; SafeSoundPlayer.Play("C:\NonExistent\sound.wav")  ; Missing file
; SafeSoundPlayer.Play("C:\SomeFile.xyz")  ; Invalid extension

; Test sequence
; sounds := ["*64", "*48", "*32", "*16"]
; SafeSoundPlayer.PlaySequence(sounds, 800)

; ============================================================
; Reference Information
; ============================================================

info := "
(
SOUNDPLAY() FUNCTION REFERENCE:

Syntax:
  SoundPlay(Filename [, Wait])

Parameters:
  Filename - Path to audio file or system sound code
  Wait     - 0 (async, default) or 1 (sync/wait)

System Sound Codes:
  *16 or *-1 → Error/Hand/Stop sound
  *32        → Question sound
  *48        → Warning/Exclamation sound
  *64        → Information/Asterisk sound

Supported Audio Formats:
  • WAV (recommended, best compatibility)
  • MP3 (Windows Media Player required)
  • WMA, AAC (codec dependent)

Key Features:
  ✓ Play system sounds without files
  ✓ Asynchronous (non-blocking) by default
  ✓ Synchronous mode with Wait parameter
  ✓ No volume control (use SoundSetVolume)
  ✓ Stops previous sound when new one plays

Common Uses:
  • User notifications and alerts
  • Error and warning sounds
  • Success confirmations
  • Timer and reminder alerts
  • Audio feedback for automation
  • Accessibility features

Error Handling:
  • Check file existence with FileExist()
  • Use Try/Catch for robust error handling
  • Validate file extensions before playing
  • Provide user feedback on errors

Best Practices:
  1. Always validate file paths
  2. Use system sounds for reliability
  3. Consider user preferences (mute option)
  4. Don't overuse sounds (annoying)
  5. Test on target Windows versions
  6. Provide visual alternatives
)"

MsgBox(info, "SoundPlay() Reference", "Icon!")
