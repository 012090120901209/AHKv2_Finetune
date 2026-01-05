#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_SoundBeep_01.ahk
 * 
 * DESCRIPTION:
 * Basic usage examples of SoundBeep() function for generating programmable beep tones
 * 
 * FEATURES:
 * - Generate beeps at specific frequencies
 * - Control beep duration
 * - Create alert sounds and notifications
 * - Simple melodies and patterns
 * - Frequency and duration relationships
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation
 * https://www.autohotkey.com/docs/v2/lib/SoundBeep.htm
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - SoundBeep() function
 * - Frequency and duration parameters
 * - Musical note frequencies
 * - Loop-based sound patterns
 * - Timer integration for beeps
 * 
 * LEARNING POINTS:
 * 1. SoundBeep(Frequency, Duration) generates programmable tones
 * 2. Frequency: 37 to 32767 Hz (default 523 Hz)
 * 3. Duration: in milliseconds (default 150 ms)
 * 4. Can create musical notes and melodies
 * 5. Useful for alerts, notifications, and accessibility
 * 6. More portable than sound files
 */

; ============================================================
; Example 1: Basic Beep Sounds
; ============================================================

/**
 * Demonstrates basic SoundBeep usage with different frequencies
 */
BasicBeeps() {
    MsgBox("Basic beep demonstration`n`n"
        . "You'll hear beeps at different frequencies",
        "Basic Beeps", "Icon!")

    ; Default beep (523 Hz, 150 ms)
    SoundBeep()
    Sleep(500)

    ; Low frequency beep (200 Hz, 300 ms)
    SoundBeep(200, 300)
    Sleep(500)

    ; Medium frequency (800 Hz, 200 ms)
    SoundBeep(800, 200)
    Sleep(500)

    ; High frequency (1500 Hz, 250 ms)
    SoundBeep(1500, 250)
    Sleep(500)

    ; Very high frequency (3000 Hz, 100 ms)
    SoundBeep(3000, 100)

    MsgBox("Basic beeps complete!", "Done", "Iconi")
}

; Uncomment to run:
; BasicBeeps()

; ============================================================
; Example 2: Alert Notification Beeps
; ============================================================

/**
 * Create different alert sounds using beeps
 * 
 * @param {String} alertType - Type of alert (info, warning, error, success)
 */
AlertBeep(alertType := "info") {
    switch alertType {
        case "info":
            ; Single medium beep
            SoundBeep(800, 200)
            MsgBox("Information alert", "Info", "Iconi T2")

        case "warning":
            ; Two quick beeps
            SoundBeep(1000, 150)
            Sleep(100)
            SoundBeep(1000, 150)
            MsgBox("Warning alert", "Warning", "Icon! T2")

        case "error":
            ; Three harsh low beeps
            Loop 3 {
                SoundBeep(200, 200)
                Sleep(150)
            }
            MsgBox("Error alert", "Error", "Iconx T2")

        case "success":
            ; Ascending beep pattern
            SoundBeep(600, 100)
            Sleep(50)
            SoundBeep(800, 100)
            Sleep(50)
            SoundBeep(1000, 150)
            MsgBox("Success alert", "Success", "Iconi T2")

        case "attention":
            ; Rapid alternating beeps
            Loop 5 {
                SoundBeep(1500, 100)
                Sleep(100)
            }
            MsgBox("Attention alert", "Attention", "Icon! T2")

        default:
            SoundBeep()
            MsgBox("Default alert", "Alert", "T2")
    }
}

; Test different alert types
; AlertBeep("info")
; AlertBeep("warning")
; AlertBeep("error")
; AlertBeep("success")
; AlertBeep("attention")

; ============================================================
; Example 3: Musical Note Frequencies
; ============================================================

/**
 * Musical note frequency reference and playback
 */
class MusicalNotes {
    /**
     * Get frequency for a musical note
     * 
     * @param {String} note - Note name (C, D, E, F, G, A, B)
     * @param {Integer} octave - Octave number (3-6)
     * @returns {Integer} - Frequency in Hz
     */
    static GetFrequency(note, octave := 4) {
        ; Base frequencies for octave 4 (Middle octave)
        static baseFrequencies := Map(
            "C", 261.63,
            "D", 293.66,
            "E", 329.63,
            "F", 349.23,
            "G", 392.00,
            "A", 440.00,
            "B", 493.88
        )

        if !baseFrequencies.Has(note) {
            return 523  ; Default frequency
        }

        baseFreq := baseFrequencies[note]

        ; Adjust for octave (each octave doubles/halves frequency)
        octaveDiff := octave - 4
        frequency := baseFreq * (2 ** octaveDiff)

        return Round(frequency)
    }

    /**
     * Play a musical note
     * 
     * @param {String} note - Note name
     * @param {Integer} octave - Octave number
     * @param {Integer} duration - Duration in ms
     */
    static PlayNote(note, octave := 4, duration := 300) {
        freq := this.GetFrequency(note, octave)
        SoundBeep(freq, duration)
    }

    /**
     * Play a scale
     * 
     * @param {Integer} octave - Octave to play
     */
    static PlayScale(octave := 4) {
        notes := ["C", "D", "E", "F", "G", "A", "B"]

        MsgBox("Playing musical scale in octave " octave, "Scale", "T1")

        for note in notes {
            this.PlayNote(note, octave, 300)
            Sleep(50)
        }

        ; Play octave note
        this.PlayNote("C", octave + 1, 400)
    }

    /**
     * Display frequency reference table
     */
    static ShowFrequencyTable() {
        notes := ["C", "D", "E", "F", "G", "A", "B"]
        output := "MUSICAL NOTE FREQUENCIES:`n`n"

        output .= "Note | Oct 3 | Oct 4 | Oct 5 | Oct 6`n"
        output .= "-----+-------+-------+-------+------`n"

        for note in notes {
            output .= note "    | "
            output .= this.GetFrequency(note, 3) " | "
            output .= this.GetFrequency(note, 4) " | "
            output .= this.GetFrequency(note, 5) " | "
            output .= this.GetFrequency(note, 6) "`n"
        }

        MsgBox(output, "Note Frequency Reference", "Icon!")
    }
}

; Test musical notes
; MusicalNotes.ShowFrequencyTable()
; MusicalNotes.PlayNote("C", 4, 500)  ; Middle C
; MusicalNotes.PlayNote("A", 4, 500)  ; A440 (standard tuning)
; MusicalNotes.PlayScale(4)  ; Play C major scale

; ============================================================
; Example 4: Simple Melodies
; ============================================================

/**
 * Play simple melodies using SoundBeep
 */
class MelodyPlayer {
    /**
     * Play "Mary Had a Little Lamb"
     */
    static MaryHadALittleLamb() {
        MsgBox("Playing: Mary Had a Little Lamb", "Melody", "T1")

        ; Mary had a little lamb
        MusicalNotes.PlayNote("E", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 300)
        Sleep(50)

        ; little lamb, little lamb
        MusicalNotes.PlayNote("E", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("E", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("E", 4, 500)
        Sleep(200)

        MusicalNotes.PlayNote("D", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 500)
        Sleep(200)

        MusicalNotes.PlayNote("E", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("G", 4, 300)
        Sleep(50)
        MusicalNotes.PlayNote("G", 4, 500)
    }

    /**
     * Play "Twinkle Twinkle Little Star" opening
     */
    static TwinkleTwinkle() {
        MsgBox("Playing: Twinkle Twinkle Little Star", "Melody", "T1")

        ; Twinkle twinkle little star
        MusicalNotes.PlayNote("C", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("G", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("G", 4, 400)
        Sleep(50)

        MusicalNotes.PlayNote("A", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("A", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("G", 4, 600)
        Sleep(200)

        ; How I wonder what you are
        MusicalNotes.PlayNote("F", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("F", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("E", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("E", 4, 400)
        Sleep(50)

        MusicalNotes.PlayNote("D", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 600)
    }

    /**
     * Play "Happy Birthday" opening
     */
    static HappyBirthday() {
        MsgBox("Playing: Happy Birthday", "Melody", "T1")

        ; Happy birthday to you
        MusicalNotes.PlayNote("C", 4, 200)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 200)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 400)
        Sleep(50)

        MusicalNotes.PlayNote("F", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("E", 4, 600)
        Sleep(200)

        ; Happy birthday to you
        MusicalNotes.PlayNote("C", 4, 200)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 200)
        Sleep(50)
        MusicalNotes.PlayNote("D", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("C", 4, 400)
        Sleep(50)

        MusicalNotes.PlayNote("G", 4, 400)
        Sleep(50)
        MusicalNotes.PlayNote("F", 4, 600)
    }

    /**
     * Play startup jingle
     */
    static StartupJingle() {
        MsgBox("Playing: Startup Jingle", "Jingle", "T1")

        MusicalNotes.PlayNote("C", 4, 150)
        Sleep(30)
        MusicalNotes.PlayNote("E", 4, 150)
        Sleep(30)
        MusicalNotes.PlayNote("G", 4, 150)
        Sleep(30)
        MusicalNotes.PlayNote("C", 5, 300)
    }

    /**
     * Play shutdown jingle
     */
    static ShutdownJingle() {
        MsgBox("Playing: Shutdown Jingle", "Jingle", "T1")

        MusicalNotes.PlayNote("C", 5, 150)
        Sleep(30)
        MusicalNotes.PlayNote("G", 4, 150)
        Sleep(30)
        MusicalNotes.PlayNote("E", 4, 150)
        Sleep(30)
        MusicalNotes.PlayNote("C", 4, 300)
    }
}

; Test melodies
; MelodyPlayer.MaryHadALittleLamb()
; MelodyPlayer.TwinkleTwinkle()
; MelodyPlayer.HappyBirthday()
; MelodyPlayer.StartupJingle()
; MelodyPlayer.ShutdownJingle()

; ============================================================
; Example 5: Progress Indicator Beeps
; ============================================================

/**
 * Use beeps to indicate progress
 */
class ProgressBeeper {
    /**
     * Beep at regular intervals to show progress
     * 
     * @param {Integer} steps - Number of steps
     * @param {Integer} delayMs - Delay between steps
     */
    static BeepProgress(steps := 10, delayMs := 1000) {
        MsgBox("Starting progress with beeps`n"
            . "Steps: " steps "`n"
            . "Interval: " delayMs "ms",
            "Progress", "T2")

        Loop steps {
            ; Higher frequency as progress increases
            baseFreq := 500
            freqIncrement := 100
            frequency := baseFreq + (A_Index * freqIncrement)

            SoundBeep(frequency, 100)

            ToolTip("Progress: " A_Index " / " steps)
            Sleep(delayMs)
        }

        ToolTip()

        ; Completion beeps
        Loop 3 {
            SoundBeep(1500, 100)
            Sleep(100)
        }

        MsgBox("Progress complete!", "Done", "Iconi")
    }

    /**
     * Countdown with beeps
     * 
     * @param {Integer} seconds - Seconds to count down
     */
    static BeepCountdown(seconds := 10) {
        MsgBox("Starting countdown: " seconds " seconds", "Countdown", "T1")

        Loop seconds {
            remaining := seconds - A_Index + 1

            ; Frequency increases as time runs out
            frequency := 300 + (remaining * 50)
            SoundBeep(frequency, 200)

            ToolTip("Time remaining: " remaining "s")
            Sleep(1000)
        }

        ToolTip()

        ; Final alarm beeps
        Loop 5 {
            SoundBeep(2000, 200)
            Sleep(200)
        }

        MsgBox("TIME'S UP!", "Countdown", "Icon!")
    }

    /**
     * Loading indicator with beeps
     * 
     * @param {Integer} duration - Total duration in seconds
     */
    static LoadingBeeps(duration := 5) {
        MsgBox("Loading with audio feedback", "Loading", "T1")

        startTime := A_TickCount
        lastBeep := 0

        while (A_TickCount - startTime) < (duration * 1000) {
            elapsed := A_TickCount - startTime

            ; Beep every 500ms
            if (elapsed - lastBeep) >= 500 {
                progress := Round((elapsed / (duration * 1000)) * 100)
                frequency := 500 + (progress * 10)

                SoundBeep(frequency, 50)
                ToolTip("Loading: " progress "%")

                lastBeep := elapsed
            }

            Sleep(50)
        }

        ToolTip()
        SoundBeep(1500, 300)
        MsgBox("Loading complete!", "Done", "Iconi")
    }
}

; Test progress indicators
; ProgressBeeper.BeepProgress(10, 500)
; ProgressBeeper.BeepCountdown(5)
; ProgressBeeper.LoadingBeeps(5)

; ============================================================
; Example 6: Frequency Testing Tool
; ============================================================

/**
 * Tool to test different frequencies and durations
 */
class FrequencyTester {
    /**
     * Test a range of frequencies
     * 
     * @param {Integer} startFreq - Starting frequency
     * @param {Integer} endFreq - Ending frequency
     * @param {Integer} steps - Number of steps
     */
    static TestRange(startFreq := 200, endFreq := 2000, steps := 10) {
        MsgBox("Testing frequency range:`n"
            . "Start: " startFreq " Hz`n"
            . "End: " endFreq " Hz`n"
            . "Steps: " steps,
            "Frequency Test", "T2")

        increment := (endFreq - startFreq) / steps

        Loop steps {
            frequency := Round(startFreq + (A_Index * increment))

            ToolTip("Frequency: " frequency " Hz")
            SoundBeep(frequency, 300)
            Sleep(500)
        }

        ToolTip()
        MsgBox("Frequency test complete!", "Done", "Iconi")
    }

    /**
     * Test different durations at same frequency
     * 
     * @param {Integer} frequency - Frequency to test
     */
    static TestDurations(frequency := 800) {
        durations := [50, 100, 200, 400, 800, 1600]

        MsgBox("Testing durations at " frequency " Hz", "Duration Test", "T1")

        for duration in durations {
            ToolTip("Duration: " duration " ms")
            SoundBeep(frequency, duration)
            Sleep(duration + 300)
        }

        ToolTip()
        MsgBox("Duration test complete!", "Done", "Iconi")
    }

    /**
     * Play frequency spectrum demonstration
     */
    static SpectrumDemo() {
        MsgBox("Playing frequency spectrum demonstration", "Spectrum", "T1")

        ; Low frequencies
        MsgBox("LOW FREQUENCIES (Bass)", "Spectrum", "T1")
        Loop 5 {
            freq := 100 + (A_Index * 50)
            SoundBeep(freq, 200)
            Sleep(300)
        }

        ; Mid frequencies
        MsgBox("MID FREQUENCIES (Voice)", "Spectrum", "T1")
        Loop 5 {
            freq := 400 + (A_Index * 100)
            SoundBeep(freq, 200)
            Sleep(300)
        }

        ; High frequencies
        MsgBox("HIGH FREQUENCIES (Treble)", "Spectrum", "T1")
        Loop 5 {
            freq := 1000 + (A_Index * 300)
            SoundBeep(freq, 200)
            Sleep(300)
        }

        MsgBox("Spectrum demonstration complete!", "Done", "Iconi")
    }
}

; Test frequency tools
; FrequencyTester.TestRange(200, 2000, 10)
; FrequencyTester.TestDurations(800)
; FrequencyTester.SpectrumDemo()

; ============================================================
; Example 7: Interactive Beep Tester
; ============================================================

/**
 * Interactive tool to test custom frequencies and durations
 */
InteractiveBeepTester() {
    result := MsgBox("Beep Tester`n`n"
        . "Test different beep parameters?",
        "Interactive Tester", "YesNo Icon?")

    if result = "No"
        return

    ; Get frequency from user
    ib := InputBox("Enter frequency (37-32767 Hz):`n"
        . "Recommended: 200-2000`n`n"
        . "Examples:`n"
        . "  200  = Low bass tone`n"
        . "  440  = A note (concert pitch)`n"
        . "  800  = Alert tone`n"
        . "  1500 = High tone`n"
        . "  2000 = Very high tone",
        "Frequency", , "800")

    if ib.Result = "Cancel"
        return

    frequency := Integer(ib.Value)

    if frequency < 37 or frequency > 32767 {
        MsgBox("Invalid frequency! Using 800 Hz", "Error", "Icon!")
        frequency := 800
    }

    ; Get duration from user
    ib := InputBox("Enter duration (milliseconds):`n"
        . "Recommended: 100-1000`n`n"
        . "Examples:`n"
        . "  100  = Very short`n"
        . "  300  = Short`n"
        . "  500  = Medium`n"
        . "  1000 = Long",
        "Duration", , "300")

    if ib.Result = "Cancel"
        return

    duration := Integer(ib.Value)

    if duration < 1 {
        MsgBox("Invalid duration! Using 300 ms", "Error", "Icon!")
        duration := 300
    }

    ; Play the beep
    MsgBox("Playing beep:`n"
        . "Frequency: " frequency " Hz`n"
        . "Duration: " duration " ms",
        "Test", "T1")

    SoundBeep(frequency, duration)

    ; Ask if user wants to repeat
    result := MsgBox("Test another beep?", "Repeat", "YesNo Icon?")

    if result = "Yes"
        InteractiveBeepTester()
}

; Uncomment to run interactive tester:
; InteractiveBeepTester()

; ============================================================
; Reference Information
; ============================================================

info := "
(
SOUNDBEEP() FUNCTION REFERENCE:

Syntax:
SoundBeep [Frequency, Duration]

Parameters:
Frequency - Tone frequency in Hz (37-32767)
Default: 523 Hz
Duration  - Beep length in milliseconds
Default: 150 ms

Frequency Guidelines:
37-200   Hz → Very low bass tones
200-500  Hz → Low tones, error sounds
500-1000 Hz → Mid tones, alerts
1000-2000 Hz → High tones, success sounds
2000+ Hz → Very high tones, attention

Musical Notes (Octave 4):
C  = 262 Hz  |  E  = 330 Hz  |  G  = 392 Hz
D  = 294 Hz  |  F  = 349 Hz  |  A  = 440 Hz
|               |  B  = 494 Hz

Common Uses:
✓ Simple alerts and notifications
✓ Progress indicators
✓ Countdown timers
✓ Success/error feedback
✓ Simple melodies
✓ Accessibility audio cues
✓ Testing and debugging
✓ No external files needed

Advantages:
• No files required (portable)
• Precise control over sound
• Works on all Windows systems
• Lightweight and fast
• Predictable behavior

Limitations:
• Only simple tones (no complex sounds)
• Limited expressiveness
• Can be annoying if overused
• No volume control in function
• Blocking (waits for completion)

Best Practices:
1. Use appropriate frequencies for context
2. Keep durations reasonable (100-500ms)
3. Add delays between beeps
4. Don't spam rapid beeps
5. Provide mute option
6. Test on actual hardware
7. Consider accessibility

Frequency Selection:
• Error/Warning: 200-500 Hz (harsh, low)
• Info/Success: 800-1200 Hz (pleasant, mid)
• Attention: 1500-2500 Hz (sharp, high)
• Progress: Ascending frequencies
• Countdown: Descending frequencies
)"

MsgBox(info, "SoundBeep() Reference", "Icon!")
