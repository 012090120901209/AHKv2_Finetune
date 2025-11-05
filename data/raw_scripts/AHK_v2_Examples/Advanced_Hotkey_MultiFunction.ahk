#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Hotkey Example: Multi-Function Keys (Tap vs Hold)
; Demonstrates: Timing-based key behavior, tap/hold detection

; CapsLock: Tap = Escape, Hold = Control
CapsLock::
{
    KeyWait("CapsLock", "T0.2")  ; Wait 0.2 seconds

    if (ErrorLevel) {  ; Key is still held
        ; Act as Control modifier
        KeyWait("CapsLock")  ; Wait for release
        return
    } else {
        ; Was a tap - send Escape
        Send("{Escape}")
    }
}

; Enhanced CapsLock as Control when held with other keys
#HotIf GetKeyState("CapsLock", "P")
a::Send("^a")  ; CapsLock + a = Ctrl+A (Select All)
c::Send("^c")  ; CapsLock + c = Ctrl+C (Copy)
v::Send("^v")  ; CapsLock + v = Ctrl+V (Paste)
x::Send("^x")  ; CapsLock + x = Ctrl+X (Cut)
z::Send("^z")  ; CapsLock + z = Ctrl+Z (Undo)
f::Send("^f")  ; CapsLock + f = Ctrl+F (Find)
s::Send("^s")  ; CapsLock + s = Ctrl+S (Save)
#HotIf

; Space: Tap = Space, Hold = Show window switcher
~Space::
{
    if (A_PriorHotkey = "~Space" && A_TimeSincePriorHotkey < 200) {
        ; Double-tap detected
        Send("#tab")  ; Show task view
        return
    }

    KeyWait("Space", "T0.3")

    if (ErrorLevel) {
        ; Space held - show alt-tab
        Send("{Alt Down}{Tab}")
        KeyWait("Space")
        Send("{Alt Up}")
    }
}

; F1: Tap = Help, Hold = Show app help menu
F1::
{
    startTime := A_TickCount

    KeyWait("F1")

    holdTime := A_TickCount - startTime

    if (holdTime < 300) {
        ; Quick tap - normal F1
        Send("{F1}")
    } else {
        ; Long press - custom help menu
        ShowHelpMenu()
    }
}

ShowHelpMenu() {
    helpMenu := Menu()
    helpMenu.Add("Keyboard Shortcuts", (*) => ShowShortcuts())
    helpMenu.Add("Mouse Gestures", (*) => ShowGestures())
    helpMenu.Add("Text Expansion", (*) => ShowTextExpansion())
    helpMenu.Add("About", (*) => MsgBox("Advanced AHK v2 Hotkeys`nVersion 1.0", "About"))

    helpMenu.Show()
}

ShowShortcuts() {
    MsgBox("Common keyboard shortcuts are active.", "Shortcuts")
}

ShowGestures() {
    MsgBox("Mouse gestures are available.", "Gestures")
}

ShowTextExpansion() {
    MsgBox("Text expansion shortcuts are active.", "Text Expansion")
}

; Semicolon: Tap = Semicolon, Hold+Key = Special commands
`;::
{
    KeyWait("`;", "T0.3")

    if (ErrorLevel) {
        ; Still held - wait for next key
        ih := InputHook("L1 T2")
        ih.Start()
        ih.Wait()

        if (ih.EndReason = "EndKey") {
            Switch ih.Input {
                case "h":
                    Send("{Home}")
                case "e":
                    Send("{End}")
                case "j":
                    Send("{Down}")
                case "k":
                    Send("{Up}")
                case "l":
                    Send("{Right}")
                case "h":
                    Send("{Left}")
                default:
                    Send(";" ih.Input)
            }
        }
    } else {
        ; Was a tap
        Send(";")
    }
}

; Tab: Tap = Tab, Double-tap = Switch to previous window
~Tab::
{
    static lastTap := 0

    currentTime := A_TickCount

    if (currentTime - lastTap < 300) {
        ; Double-tap detected
        Send("!{Escape}")  ; Alt+Esc = cycle windows
        lastTap := 0
    } else {
        lastTap := currentTime
    }
}

; Ctrl: Triple-tap = Show clipboard history (if available)
~Ctrl::
{
    static tapCount := 0
    static lastTap := 0

    currentTime := A_TickCount

    if (currentTime - lastTap < 400) {
        tapCount++
    } else {
        tapCount := 1
    }

    lastTap := currentTime

    if (tapCount >= 3) {
        Send("#v")  ; Windows clipboard history (Win+V)
        tapCount := 0
    }
}

; Win key: Tap = Start Menu, Hold = Show custom launcher
~LWin::
{
    KeyWait("LWin", "T0.5")

    if (ErrorLevel) {
        ; Long press
        KeyWait("LWin")
        ShowQuickLauncher()
    }
}

ShowQuickLauncher() {
    launcher := Menu()
    launcher.Add("Calculator", (*) => Run("calc.exe"))
    launcher.Add("Notepad", (*) => Run("notepad.exe"))
    launcher.Add("Task Manager", (*) => Run("taskmgr.exe"))
    launcher.Add("Control Panel", (*) => Run("control.exe"))
    launcher.Add("Command Prompt", (*) => Run("cmd.exe"))

    MouseGetPos(&mx, &my)
    launcher.Show(mx, my)
}

; Show current configuration
^!F1::
{
    config := "
    (
    Multi-Function Key Configuration
    =================================

    CapsLock:
    - Tap: Escape
    - Hold + key: Control modifier

    Space:
    - Tap: Space
    - Double-tap: Task View
    - Hold: Alt-Tab switcher

    F1:
    - Tap: Help
    - Hold: Custom help menu

    Semicolon:
    - Tap: ;
    - Hold + hjkl: Arrow keys (Vim-style)

    Tab:
    - Tap: Tab
    - Double-tap: Cycle windows

    Ctrl:
    - Triple-tap: Clipboard history

    Win:
    - Tap: Start menu
    - Hold: Quick launcher
    )"

    MsgBox(config, "Multi-Function Keys")
}
