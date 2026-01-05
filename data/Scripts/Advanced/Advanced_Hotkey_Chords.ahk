#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced Hotkey Example: Keyboard Chords (Simultaneous Key Presses)
; Demonstrates: Chord detection, simultaneous key combinations

; Install InputHook for chord detection
global chordTimeout := 100  ; milliseconds

; Home row chords (both hands on home row)

; F+J = Copy (index fingers)
*f::
*j::
{
    if (GetKeyState("f", "P") && GetKeyState("j", "P")) {
        ExecuteChord("f+j")
        KeyWait("f")
        KeyWait("j")
    }
}

; D+K = Paste (middle fingers)
*d::
*k::
{
    if (GetKeyState("d", "P") && GetKeyState("k", "P")) {
        ExecuteChord("d+k")
        KeyWait("d")
        KeyWait("k")
    }
}

; S+L = Save (ring fingers)
*s::
*l::
{
    if (GetKeyState("s", "P") && GetKeyState("l", "P")) {
        ExecuteChord("s+l")
        KeyWait("s")
        KeyWait("l")
    } else if (!GetKeyState("l", "P")) {
        Send("{s}")
    }
}

; A+; = Select All (pinky fingers)
*a::
*`;::
{
    if (GetKeyState("a", "P") && GetKeyState(";", "P")) {
        ExecuteChord("a+;")
        KeyWait("a")
        KeyWait("`;")
    } else if (!GetKeyState("`;", "P")) {
        Send("{a}")
    }
}

; Number row chords

; 1+2 = Open Calculator
*1::
*2::
{
    if (GetKeyState("1", "P") && GetKeyState("2", "P")) {
        ExecuteChord("1+2")
        KeyWait("1")
        KeyWait("2")
    }
}

; 3+4 = Open Notepad
*3::
*4::
{
    if (GetKeyState("3", "P") && GetKeyState("4", "P")) {
        ExecuteChord("3+4")
        KeyWait("3")
        KeyWait("4")
    }
}

; 7+8 = Volume Up
*7::
*8::
{
    if (GetKeyState("7", "P") && GetKeyState("8", "P")) {
        ExecuteChord("7+8")
        KeyWait("7")
        KeyWait("8")
    }
}

; 9+0 = Volume Down
*9::
*0::
{
    if (GetKeyState("9", "P") && GetKeyState("0", "P")) {
        ExecuteChord("9+0")
        KeyWait("9")
        KeyWait("0")
    }
}

; Arrow key chords

; Left+Right = Home
*Left::
*Right::
{
    if (GetKeyState("Left", "P") && GetKeyState("Right", "P")) {
        ExecuteChord("Left+Right")
        KeyWait("Left")
        KeyWait("Right")
    }
}

; Up+Down = End
*Up::
*Down::
{
    if (GetKeyState("Up", "P") && GetKeyState("Down", "P")) {
        ExecuteChord("Up+Down")
        KeyWait("Up")
        KeyWait("Down")
    }
}

; Three-key chords

; Q+W+E = Close window
*q::
*w::
*e::
{
    if (GetKeyState("q", "P") && GetKeyState("w", "P") && GetKeyState("e", "P")) {
        ExecuteChord("q+w+e")
        KeyWait("q")
        KeyWait("w")
        KeyWait("e")
    } else if (!GetKeyState("w", "P") && !GetKeyState("e", "P")) {
        Send("{q}")
    }
}

; Execute chord actions
ExecuteChord(chord) {
    ShowChordFeedback(chord)

    Switch chord {
        case "f+j":
            Send("^c")  ; Copy

        case "d+k":
            Send("^v")  ; Paste

        case "s+l":
            Send("^s")  ; Save

        case "a+;":
            Send("^a")  ; Select All

        case "1+2":
            Run("calc.exe")

        case "3+4":
            Run("notepad.exe")

        case "7+8":
            SoundSetVolume("+5")
            vol := Round(SoundGetVolume())
            ShowChordFeedback("Volume: " vol "%")

        case "9+0":
            SoundSetVolume("-5")
            vol := Round(SoundGetVolume())
            ShowChordFeedback("Volume: " vol "%")

        case "Left+Right":
            Send("{Home}")

        case "Up+Down":
            Send("{End}")

        case "q+w+e":
            WinClose("A")

        default:
            ShowChordFeedback("Unknown chord")
    }
}

; Visual feedback for chord execution
ShowChordFeedback(text) {
    ToolTip(text)
    SetTimer(() => ToolTip(), -800)
}

; Display chord reference
^!c::
{
    reference := "
    (
    Keyboard Chord Reference
    ========================

    HOME ROW (simultaneous press):
    F + J = Copy
    D + K = Paste
    S + L = Save
    A + ; = Select All

    NUMBER ROW:
    1 + 2 = Calculator
    3 + 4 = Notepad
    7 + 8 = Volume Up
    9 + 0 = Volume Down

    ARROW KEYS:
    Left + Right = Home
    Up + Down = End

    THREE-KEY:
    Q + W + E = Close Window

    Press Ctrl+Alt+C for this reference.
    )"

    MsgBox(reference, "Keyboard Chords")
}

; Toggle chord mode on/off
^!+c::
{
    static chordsEnabled := true

    chordsEnabled := !chordsEnabled

    if (chordsEnabled) {
        Suspend(false)
        TrayTip("Chords Enabled", "Keyboard chords are now active", "Iconi")
    } else {
        Suspend(true)
        TrayTip("Chords Disabled", "Keyboard chords are disabled", "Iconi")
    }
}
