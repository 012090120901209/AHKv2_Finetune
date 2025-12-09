#Requires AutoHotkey v2.0

/**
* BuiltIn_SoundBeep_02.ahk
*
* DESCRIPTION:
* Advanced SoundBeep() examples including Morse code, complex melodies, and rhythm patterns
*
* FEATURES:
* - Morse code encoder and player
* - Musical melody composition
* - Rhythm and pattern generation
* - DTMF tone generation
* - Game sound effects
* - Advanced notification systems
*
* SOURCE:
* AutoHotkey v2 Documentation
* https://www.autohotkey.com/docs/v2/lib/SoundBeep.htm
*
* KEY V2 FEATURES DEMONSTRATED:
* - Complex SoundBeep() sequences
* - Map data structures for encoding
* - Rhythm and timing patterns
* - Class-based sound generators
* - String parsing and conversion
*
* LEARNING POINTS:
* 1. Create complex audio patterns with simple beeps
* 2. Encode data as audio (Morse code)
* 3. Generate musical compositions
* 4. Implement rhythm patterns
* 5. Create game sound effects
* 6. Build communication systems with audio
*/

; ============================================================
; Example 1: Morse Code System
; ============================================================

/**
* Morse code encoder and player
*/
class MorseCode {
    /**
    * Initialize Morse code system
    */
    static __New() {
        ; Morse code alphabet mapping
        this.morseMap := Map(
        "A", ".-",    "B", "-...",  "C", "-.-.",  "D", "-..",
        "E", ".",     "F", "..-.",  "G", "--.",   "H", "....",
        "I", "..",    "J", ".---",  "K", "-.-",   "L", ".-..",
        "M", "--",    "N", "-.",    "O", "---",   "P", ".--.",
        "Q", "--.-",  "R", ".-.",   "S", "...",   "T", "-",
        "U", "..-",   "V", "...-",  "W", ".--",   "X", "-..-",
        "Y", "-.--",  "Z", "--..",

        "0", "-----", "1", ".----", "2", "..---", "3", "...--",
        "4", "....-", "5", ".....", "6", "-....", "7", "--...",
        "8", "---..", "9", "----.",

        ".", ".-.-.-", ",", "--..--", "?", "..--..",
        "!", "-.-.--", "/", "-..-.",  " ", "/"
        )

        ; Timing (WPM: Words Per Minute, standard = 20 WPM)
        this.dotDuration := 60       ; Duration of dot in ms
        this.dashDuration := 180     ; Duration of dash (3x dot)
        this.symbolGap := 60         ; Gap between dots/dashes
        this.letterGap := 180        ; Gap between letters
        this.wordGap := 420          ; Gap between words

        this.frequency := 800        ; Tone frequency
    }

    /**
    * Convert text to Morse code string
    *
    * @param {String} text - Text to convert
    * @returns {String} - Morse code representation
    */
    static TextToMorse(text) {
        morse := ""
        text := StrUpper(text)

        Loop Parse, text {
            char := A_LoopField

            if this.morseMap.Has(char) {
                if morse != ""
                morse .= " "
                morse .= this.morseMap[char]
            }
        }

        return morse
    }

    /**
    * Play Morse code sequence
    *
    * @param {String} morseCode - Morse code string (dots, dashes, spaces)
    */
    static PlayMorse(morseCode) {
        Loop Parse, morseCode {
            char := A_LoopField

            switch char {
                case ".":
                ; Play dot
                SoundBeep(this.frequency, this.dotDuration)
                Sleep(this.symbolGap)

                case "-":
                ; Play dash
                SoundBeep(this.frequency, this.dashDuration)
                Sleep(this.symbolGap)

                case " ":
                ; Letter gap (subtract symbol gap already added)
                Sleep(this.letterGap - this.symbolGap)

                case "/":
                ; Word gap
                Sleep(this.wordGap)
            }
        }
    }

    /**
    * Play text as Morse code
    *
    * @param {String} text - Text to transmit
    */
    static Transmit(text) {
        morse := this.TextToMorse(text)

        MsgBox("Transmitting: " text "`n`n"
        . "Morse: " morse,
        "Morse Code", "T2")

        this.PlayMorse(morse)

        MsgBox("Transmission complete!", "Done", "Iconi")
    }

    /**
    * Set transmission speed
    *
    * @param {Integer} wpm - Words per minute (5-40)
    */
    static SetSpeed(wpm) {
        ; Standard: 1 dot = 1.2 / WPM seconds
        this.dotDuration := Round((1200 / wpm))
        this.dashDuration := this.dotDuration * 3
        this.symbolGap := this.dotDuration
        this.letterGap := this.dotDuration * 3
        this.wordGap := this.dotDuration * 7

        MsgBox("Morse code speed set to " wpm " WPM", "Speed", "Iconi T1")
    }

    /**
    * Demonstrate SOS signal
    */
    static SOS() {
        MsgBox("Transmitting SOS distress signal!", "SOS", "Icon! T2")

        ; SOS = ... --- ...
        Loop 3 {
            this.PlayMorse("... --- ...")
            Sleep(1000)
        }

        MsgBox("SOS transmission complete", "SOS", "Icon!")
    }
}

; Test Morse code
; MorseCode.Transmit("HELLO")
; MorseCode.Transmit("SOS")
; MorseCode.Transmit("AUTOHOTKEY")
; MorseCode.SOS()
; MorseCode.SetSpeed(30)  ; Faster
; MorseCode.Transmit("FAST")

; ============================================================
; Example 2: DTMF Tone Generator (Phone Keypad)
; ============================================================

/**
* Generate DTMF (Dual-Tone Multi-Frequency) tones
* Used in telephone keypads
*/
class DTMFGenerator {
    /**
    * Initialize DTMF frequencies
    */
    static __New() {
        ; DTMF uses two simultaneous tones
        ; We'll simulate by playing them sequentially quickly

        this.frequencies := Map(
        "1", [697, 1209],  "2", [697, 1336],  "3", [697, 1477],
        "4", [770, 1209],  "5", [770, 1336],  "6", [770, 1477],
        "7", [852, 1209],  "8", [852, 1336],  "9", [852, 1477],
        "*", [941, 1209],  "0", [941, 1336],  "#", [941, 1477]
        )
    }

    /**
    * Play DTMF tone for a key
    *
    * @param {String} key - Key to play (0-9, *, #)
    */
    static PlayKey(key) {
        if !this.frequencies.Has(key)
        return

        freqs := this.frequencies[key]

        ; Simulate dual-tone by alternating quickly
        Loop 5 {
            SoundBeep(freqs[1], 20)
            SoundBeep(freqs[2], 20)
        }
    }

    /**
    * Dial a phone number
    *
    * @param {String} number - Phone number to dial
    */
    static DialNumber(number) {
        MsgBox("Dialing: " number, "DTMF Dialer", "T1")

        Loop Parse, number {
            char := A_LoopField

            if char = " " or char = "-" {
                Sleep(300)
                continue
            }

            this.PlayKey(char)
            ToolTip("Dialing: " char)
            Sleep(300)
        }

        ToolTip()
        MsgBox("Dialing complete!", "Done", "Iconi")
    }
}

; Test DTMF dialer
; DTMFGenerator.DialNumber("1234567890")
; DTMFGenerator.DialNumber("555-0123")
; DTMFGenerator.PlayKey("5")

; ============================================================
; Example 3: Game Sound Effects
; ============================================================

/**
* Create retro game sound effects using beeps
*/
class GameSounds {
    /**
    * Coin collection sound
    */
    static Coin() {
        SoundBeep(988, 100)   ; B5
        Sleep(50)
        SoundBeep(1319, 150)  ; E6
    }

    /**
    * Power-up sound
    */
    static PowerUp() {
        frequencies := [523, 659, 784, 1047, 1319]
        for freq in frequencies {
            SoundBeep(freq, 80)
            Sleep(30)
        }
    }

    /**
    * Jump sound
    */
    static Jump() {
        Loop 8 {
            freq := 400 + (A_Index * 100)
            SoundBeep(freq, 30)
        }
    }

    /**
    * Game over sound
    */
    static GameOver() {
        SoundBeep(494, 200)   ; B
        Sleep(50)
        SoundBeep(466, 200)   ; A#
        Sleep(50)
        SoundBeep(440, 200)   ; A
        Sleep(50)
        SoundBeep(415, 200)   ; G#
        Sleep(50)
        SoundBeep(392, 400)   ; G
    }

    /**
    * Level complete sound
    */
    static LevelComplete() {
        notes := [523, 659, 784, 1047]
        Loop 2 {
            for freq in notes {
                SoundBeep(freq, 100)
                Sleep(30)
            }
        }
        SoundBeep(1319, 400)  ; Final high note
    }

    /**
    * Laser shoot sound
    */
    static Laser() {
        Loop 10 {
            freq := 2000 - (A_Index * 150)
            SoundBeep(freq, 20)
        }
    }

    /**
    * Explosion sound
    */
    static Explosion() {
        ; White noise simulation with random-ish frequencies
        Loop 15 {
            freq := 100 + Mod(A_Index * 137, 400)
            SoundBeep(freq, 30)
        }
    }

    /**
    * Victory fanfare
    */
    static Victory() {
        SoundBeep(523, 150)   ; C
        Sleep(50)
        SoundBeep(523, 150)   ; C
        Sleep(50)
        SoundBeep(523, 150)   ; C
        Sleep(50)
        SoundBeep(659, 400)   ; E
        Sleep(100)
        SoundBeep(523, 150)   ; C
        Sleep(50)
        SoundBeep(784, 400)   ; G
    }

    /**
    * Demonstrate all game sounds
    */
    static DemoAll() {
        sounds := [
        {
            name: "Coin", func: (*) => this.Coin()},
            {
                name: "Power Up", func: (*) => this.PowerUp()},
                {
                    name: "Jump", func: (*) => this.Jump()},
                    {
                        name: "Laser", func: (*) => this.Laser()},
                        {
                            name: "Explosion", func: (*) => this.Explosion()},
                            {
                                name: "Level Complete", func: (*) => this.LevelComplete()},
                                {
                                    name: "Game Over", func: (*) => this.GameOver()},
                                    {
                                        name: "Victory", func: (*) => this.Victory()
                                    }
                                    ]

                                    for sound in sounds {
                                        MsgBox("Playing: " sound.name, "Game Sounds", "T1")
                                        sound.func.Call()
                                        Sleep(1000)
                                    }

                                    MsgBox("Game sounds demonstration complete!", "Done", "Iconi")
                                }
                            }

                            ; Test game sounds
                            ; GameSounds.Coin()
                            ; GameSounds.PowerUp()
                            ; GameSounds.Jump()
                            ; GameSounds.Laser()
                            ; GameSounds.Explosion()
                            ; GameSounds.LevelComplete()
                            ; GameSounds.GameOver()
                            ; GameSounds.Victory()
                            ; GameSounds.DemoAll()

                            ; ============================================================
                            ; Example 4: Rhythm Pattern Generator
                            ; ============================================================

                            /**
                            * Create rhythm patterns and beats
                            */
                            class RhythmGenerator {
                                /**
                                * Play a simple beat pattern
                                *
                                * @param {String} pattern - Pattern string (X=beat, -=rest)
                                * @param {Integer} tempo - BPM (beats per minute)
                                */
                                static PlayBeat(pattern, tempo := 120) {
                                    beatDuration := Round(60000 / tempo)  ; ms per beat

                                    MsgBox("Playing rhythm pattern:`n" pattern "`n`n"
                                    . "Tempo: " tempo " BPM",
                                    "Rhythm", "T1")

                                    Loop Parse, pattern {
                                        char := A_LoopField

                                        if char = "X" or char = "x" {
                                            ; Beat (low frequency for bass drum sound)
                                            SoundBeep(200, beatDuration // 2)
                                        } else if char = "S" or char = "s" {
                                            ; Snare (higher frequency)
                                            SoundBeep(800, beatDuration // 3)
                                        } else if char = "H" or char = "h" {
                                            ; Hi-hat (high frequency, short)
                                            SoundBeep(2000, beatDuration // 4)
                                        }
                                        ; Else rest (-) - just wait

                                        Sleep(beatDuration)
                                    }
                                }

                                /**
                                * Play drum pattern
                                */
                                static DrumPattern() {
                                    MsgBox("Playing drum pattern", "Drums", "T1")

                                    ; X = Kick, S = Snare, H = Hi-hat, - = Rest
                                    pattern := "X-H-S-H-X-H-S-H-"

                                    this.PlayBeat(pattern, 140)
                                }

                                /**
                                * Create metronome
                                *
                                * @param {Integer} bpm - Beats per minute
                                * @param {Integer} beats - Number of beats to play
                                */
                                static Metronome(bpm := 120, beats := 16) {
                                    MsgBox("Metronome: " bpm " BPM`n"
                                    . "Beats: " beats,
                                    "Metronome", "T1")

                                    interval := Round(60000 / bpm)

                                    Loop beats {
                                        ; Accent first beat of measure (every 4 beats)
                                        isAccent := Mod(A_Index - 1, 4) = 0

                                        if isAccent {
                                            SoundBeep(1200, 50)  ; Higher pitch for accent
                                        } else {
                                            SoundBeep(800, 50)   ; Normal pitch
                                        }

                                        ToolTip("Beat " A_Index " / " beats)
                                        Sleep(interval)
                                    }

                                    ToolTip()
                                    MsgBox("Metronome complete!", "Done", "Iconi")
                                }

                                /**
                                * Generate random rhythm
                                *
                                * @param {Integer} length - Pattern length
                                */
                                static RandomRhythm(length := 16) {
                                    pattern := ""

                                    Loop length {
                                        ; 60% chance of beat, 40% rest
                                        if Random(1, 100) <= 60
                                        pattern .= "X"
                                        else
                                        pattern .= "-"
                                    }

                                    MsgBox("Random rhythm pattern:`n" pattern, "Random", "T1")

                                    this.PlayBeat(pattern, 130)
                                }
                            }

                            ; Test rhythm patterns
                            ; RhythmGenerator.PlayBeat("X-X-X-X-", 120)
                            ; RhythmGenerator.DrumPattern()
                            ; RhythmGenerator.Metronome(120, 16)
                            ; RhythmGenerator.RandomRhythm(16)

                            ; ============================================================
                            ; Example 5: Musical Sequence Composer
                            ; ============================================================

                            /**
                            * Compose and play musical sequences
                            */
                            class MusicComposer {
                                /**
                                * Note frequencies (A4 = 440 Hz standard)
                                */
                                static notes := Map(
                                "C4", 262, "D4", 294, "E4", 330, "F4", 349,
                                "G4", 392, "A4", 440, "B4", 494,
                                "C5", 523, "D5", 587, "E5", 659, "F5", 698,
                                "G5", 784, "A5", 880, "B5", 988,
                                "C6", 1047
                                )

                                /**
                                * Parse and play musical notation
                                *
                                * @param {String} notation - Notes with durations (e.g., "C4:400 D4:200")
                                */
                                static Play(notation) {
                                    Loop Parse, notation, " " {
                                        if A_LoopField = ""
                                        continue

                                        parts := StrSplit(A_LoopField, ":")

                                        if parts.Length < 2
                                        continue

                                        note := parts[1]
                                        duration := Integer(parts[2])

                                        if this.notes.Has(note) {
                                            SoundBeep(this.notes[note], duration)
                                            Sleep(duration * 0.1)  ; Small gap between notes
                                        } else if note = "R" {  ; Rest
                                        Sleep(duration)
                                    }
                                }
                            }

                            /**
                            * Play major chord
                            *
                            * @param {String} root - Root note (e.g., "C4")
                            */
                            static MajorChord(root) {
                                if !this.notes.Has(root)
                                return

                                ; Simulate chord by playing notes in quick succession
                                rootFreq := this.notes[root]
                                third := Round(rootFreq * 1.26)   ; Major third
                                fifth := Round(rootFreq * 1.5)    ; Perfect fifth

                                SoundBeep(rootFreq, 400)
                                Sleep(50)
                                SoundBeep(third, 400)
                                Sleep(50)
                                SoundBeep(fifth, 400)
                            }

                            /**
                            * Play arpeggio
                            *
                            * @param {String} root - Root note
                            */
                            static Arpeggio(root) {
                                if !this.notes.Has(root)
                                return

                                rootFreq := this.notes[root]
                                third := Round(rootFreq * 1.26)
                                fifth := Round(rootFreq * 1.5)
                                octave := rootFreq * 2

                                freqs := [rootFreq, third, fifth, octave, fifth, third, rootFreq]

                                for freq in freqs {
                                    SoundBeep(freq, 200)
                                    Sleep(50)
                                }
                            }

                            /**
                            * Play Star Wars theme opening
                            */
                            static StarWars() {
                                MsgBox("Playing: Star Wars Theme", "Music", "T1")

                                ; Main motif
                                this.Play("G4:300 G4:300 G4:300 C5:600 G5:900")
                                Sleep(200)
                                this.Play("F5:600 E5:600 D5:600 C6:900 G5:400")
                                Sleep(200)
                                this.Play("F5:600 E5:600 D5:600 C6:900 G5:400")
                            }

                            /**
                            * Play Super Mario Bros theme
                            */
                            static SuperMario() {
                                MsgBox("Playing: Super Mario Bros Theme", "Music", "T1")

                                this.Play("E5:150 E5:150 R:150 E5:150 R:150 C5:150 E5:300")
                                Sleep(100)
                                this.Play("G5:400 R:400 G4:400")
                            }

                            /**
                            * Play Tetris theme
                            */
                            static Tetris() {
                                MsgBox("Playing: Tetris Theme", "Music", "T1")

                                this.Play("E5:400 B4:200 C5:200 D5:400 C5:200 B4:200")
                                Sleep(50)
                                this.Play("A4:400 A4:200 C5:200 E5:400 D5:200 C5:200")
                                Sleep(50)
                                this.Play("B4:600 C5:200 D5:400 E5:400")
                                Sleep(50)
                                this.Play("C5:400 A4:400 A4:400")
                            }
                        }

                        ; Test music composer
                        ; MusicComposer.MajorChord("C4")
                        ; MusicComposer.Arpeggio("C4")
                        ; MusicComposer.StarWars()
                        ; MusicComposer.SuperMario()
                        ; MusicComposer.Tetris()

                        ; ============================================================
                        ; Example 6: Alarm and Timer System
                        ; ============================================================

                        /**
                        * Advanced alarm system with custom patterns
                        */
                        class AlarmSystem {
                            /**
                            * Gentle wake-up alarm (gradually increasing volume simulation)
                            */
                            static GentleWakeup() {
                                MsgBox("Starting gentle wake-up alarm", "Alarm", "T1")

                                frequencies := [400, 500, 600, 700, 800]
                                Loop 3 {
                                    for freq in frequencies {
                                        SoundBeep(freq, 200)
                                        Sleep(300)
                                    }
                                    Sleep(500)
                                }
                            }

                            /**
                            * Urgent alarm
                            */
                            static UrgentAlarm() {
                                MsgBox("URGENT ALARM!", "URGENT", "Icon! T1")

                                Loop 10 {
                                    SoundBeep(2000, 100)
                                    Sleep(100)
                                    SoundBeep(1500, 100)
                                    Sleep(100)
                                }
                            }

                            /**
                            * Interval timer with beeps
                            *
                            * @param {Integer} intervals - Number of intervals
                            * @param {Integer} intervalSeconds - Seconds per interval
                            */
                            static IntervalTimer(intervals, intervalSeconds) {
                                MsgBox("Interval Timer Starting`n`n"
                                . "Intervals: " intervals "`n"
                                . "Duration: " intervalSeconds "s each",
                                "Timer", "T2")

                                Loop intervals {
                                    ; Countdown for this interval
                                    ToolTip("Interval " A_Index " / " intervals " - Starting...")
                                    Sleep(intervalSeconds * 1000)

                                    ; Interval complete sound
                                    Loop 3 {
                                        SoundBeep(1000, 100)
                                        Sleep(100)
                                    }

                                    if A_Index < intervals {
                                        MsgBox("Interval " A_Index " complete!`n"
                                        . "Starting interval " (A_Index + 1),
                                        "Interval", "T2")
                                    }
                                }

                                ToolTip()

                                ; Final completion alarm
                                Loop 5 {
                                    SoundBeep(1500, 200)
                                    Sleep(200)
                                }

                                MsgBox("All intervals complete!", "Timer Complete", "Iconi")
                            }

                            /**
                            * Pomodoro timer (25 min work, 5 min break)
                            * Shortened for demo purposes
                            */
                            static PomodoroDemo() {
                                MsgBox("Pomodoro Timer Demo`n`n"
                                . "(Shortened: 5s work, 3s break)",
                                "Pomodoro", "T2")

                                ; Work period
                                ToolTip("WORK TIME - Focus!")
                                Sleep(5000)

                                ; Work complete
                                Loop 2 {
                                    SoundBeep(800, 200)
                                    Sleep(200)
                                }

                                MsgBox("Work period complete!`nTake a break!", "Break Time", "Iconi T2")

                                ; Break period
                                ToolTip("BREAK TIME - Relax!")
                                Sleep(3000)

                                ; Break complete
                                Loop 3 {
                                    SoundBeep(1200, 150)
                                    Sleep(150)
                                }

                                ToolTip()
                                MsgBox("Break complete!`nReady for next session?", "Pomodoro", "Iconi")
                            }
                        }

                        ; Test alarm system
                        ; AlarmSystem.GentleWakeup()
                        ; AlarmSystem.UrgentAlarm()
                        ; AlarmSystem.IntervalTimer(3, 2)
                        ; AlarmSystem.PomodoroDemo()

                        ; ============================================================
                        ; Example 7: Communication Signals
                        ; ============================================================

                        /**
                        * Various communication signal patterns
                        */
                        class SignalPatterns {
                            /**
                            * SOS distress signal
                            */
                            static SOS() {
                                MsgBox("Broadcasting SOS!", "Distress Signal", "Icon! T1")

                                Loop 3 {
                                    ; ... (S)
                                    Loop 3
                                    SoundBeep(800, 100), Sleep(100)
                                    Sleep(200)

                                    ; --- (O)
                                    Loop 3
                                    SoundBeep(800, 300), Sleep(100)
                                    Sleep(200)

                                    ; ... (S)
                                    Loop 3
                                    SoundBeep(800, 100), Sleep(100)

                                    Sleep(2000)
                                }
                            }

                            /**
                            * Attention signal
                            */
                            static Attention() {
                                Loop 5 {
                                    SoundBeep(1500, 200)
                                    Sleep(200)
                                }
                            }

                            /**
                            * All clear signal
                            */
                            static AllClear() {
                                Loop 3 {
                                    SoundBeep(1000, 400)
                                    Sleep(600)
                                }
                            }

                            /**
                            * Warning siren
                            */
                            static WarningSiren() {
                                MsgBox("Warning Siren", "Warning", "Icon! T1")

                                Loop 5 {
                                    ; Rising tone
                                    Loop 20 {
                                        freq := 400 + (A_Index * 40)
                                        SoundBeep(freq, 50)
                                    }
                                    ; Falling tone
                                    Loop 20 {
                                        freq := 1200 - (A_Index * 40)
                                        SoundBeep(freq, 50)
                                    }
                                }
                            }

                            /**
                            * Victory horn
                            */
                            static VictoryHorn() {
                                SoundBeep(500, 400)
                                Sleep(100)
                                SoundBeep(600, 400)
                                Sleep(100)
                                SoundBeep(700, 800)
                            }
                        }

                        ; Test signal patterns
                        ; SignalPatterns.SOS()
                        ; SignalPatterns.Attention()
                        ; SignalPatterns.AllClear()
                        ; SignalPatterns.WarningSiren()
                        ; SignalPatterns.VictoryHorn()

                        ; ============================================================
                        ; Reference Information
                        ; ============================================================

                        info := "
                        (
                        ADVANCED SOUNDBEEP() APPLICATIONS:

                        Morse Code:
                        • Dots: Short beeps (~60ms)
                        • Dashes: Long beeps (~180ms, 3x dot)
                        • Symbol gap: 60ms
                        • Letter gap: 180ms
                        • Word gap: 420ms
                        • Standard speed: 20 WPM
                        • Can encode any text message

                        DTMF Tones (Phone):
                        • Dual frequencies per key
                        • Simulate by rapid alternation
                        • Standard phone keypad layout
                        • Useful for tone dialing simulation

                        Game Sound Effects:
                        • Coin: Rising pitch sequence
                        • Jump: Quick ascending tones
                        • Laser: Descending frequency sweep
                        • Explosion: Rapid random tones
                        • Power-up: Ascending scale
                        • Game over: Descending progression

                        Musical Composition:
                        • Map note names to frequencies
                        • Support duration notation
                        • Play melodies and themes
                        • Arpeggios and chord simulation
                        • Musical pattern playback

                        Rhythm Patterns:
                        • Beat patterns (X, S, H, -)
                        • Tempo control (BPM)
                        • Metronome functionality
                        • Drum pattern simulation
                        • Random rhythm generation

                        Alarm Systems:
                        • Gentle wake-up patterns
                        • Urgent alarms
                        • Interval timers
                        • Pomodoro technique
                        • Custom alert patterns

                        Signal Patterns:
                        • SOS distress signal
                        • Attention alerts
                        • Warning sirens
                        • All-clear signals
                        • Custom communication codes

                        Best Practices:
                        ✓ Use appropriate frequencies
                        ✓ Consider timing and rhythm
                        ✓ Add rests between sounds
                        ✓ Test on actual hardware
                        ✓ Provide volume warnings
                        ✓ Allow user control
                        ✓ Document patterns clearly

                        Frequency Selection:
                        • Bass/Drums: 100-300 Hz
                        • Mid tones: 400-1000 Hz
                        • Treble/Alerts: 1000-2500 Hz
                        • Musical notes: 262-1047 Hz
                        • Attention: 1500-3000 Hz

                        Timing Guidelines:
                        • Quick beep: 50-100ms
                        • Standard beep: 150-300ms
                        • Long beep: 400-800ms
                        • Gap between beeps: 50-200ms
                        • Between patterns: 500-1000ms

                        Creative Applications:
                        • Accessibility aids
                        • Audio feedback systems
                        • Teaching tools (music, morse)
                        • Game development
                        • Testing and debugging
                        • Timer and reminder systems
                        • Communication systems
                        )"

                        MsgBox(info, "Advanced SoundBeep() Reference", "Icon!")
