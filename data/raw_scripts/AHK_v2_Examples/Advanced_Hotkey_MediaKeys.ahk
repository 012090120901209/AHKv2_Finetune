#Requires AutoHotkey v2.1-alpha.16
#SingleInstance Force
; Advanced Hotkey Example: Custom Media Controls
; Demonstrates: Media key handling, volume control, OSD display

; Create OSD (On-Screen Display) for visual feedback
ShowOSD(text, duration := 1000) {
    static osd := ""

    if (osd != "")
        try osd.Destroy()

    osd := Gui("-Caption +AlwaysOnTop +ToolWindow +E0x20")
    osd.BackColor := "0x1a1a1a"
    osd.SetFont("s20 cWhite Bold", "Segoe UI")

    osd.Add("Text", "x20 y20 w260 Center", text)
    osd.Show("x" (A_ScreenWidth - 300) " y50 w300 h80 NoActivate")

    WinSetTransparent(220, osd.Hwnd)

    ; Auto-hide after duration
    SetTimer(() => osd.Destroy(), -duration)
}

; Volume controls with visual feedback
^Up::
{
    SoundSetVolume("+5")
    vol := Round(SoundGetVolume())
    ShowOSD("Volume: " vol "%")
}

^Down::
{
    SoundSetVolume("-5")
    vol := Round(SoundGetVolume())
    ShowOSD("Volume: " vol "%")
}

^!m::
{
    static isMuted := false

    SoundSetMute(!isMuted)
    isMuted := !isMuted

    ShowOSD(isMuted ? "🔇 Muted" : "🔊 Unmuted")
}

; Media playback controls (if media keys don't exist on keyboard)
^!Space::
{
    Send("{Media_Play_Pause}")
    ShowOSD("⏯ Play/Pause")
}

^!Right::
{
    Send("{Media_Next}")
    ShowOSD("⏭ Next Track")
}

^!Left::
{
    Send("{Media_Prev}")
    ShowOSD("⏮ Previous Track")
}

^!s::
{
    Send("{Media_Stop}")
    ShowOSD("⏹ Stop")
}

; Brightness controls (requires monitor support)
#+Up::
{
    ; Increase brightness
    Run("powershell.exe -Command ""(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,100)""", , "Hide")
    ShowOSD("☀ Brightness: Max")
}

#+Down::
{
    ; Decrease brightness
    Run("powershell.exe -Command ""(Get-WmiObject -Namespace root/WMI -Class WmiMonitorBrightnessMethods).WmiSetBrightness(1,30)""", , "Hide")
    ShowOSD("☀ Brightness: Low")
}

; Quick audio device switcher
^!a::
{
    ; This is a simplified version - real implementation would enumerate audio devices
    MsgBox("Audio Device Switcher`n`nThis would show a list of available audio output devices.`n`n(Full implementation requires COM automation)", "Audio Devices")
}

; Volume mixer (open Windows volume mixer)
^!v::
{
    Run("sndvol.exe")
}

; Spotify/Music app controls (when app is active)
#HotIf WinExist("ahk_exe spotify.exe") || WinExist("ahk_exe iTunes.exe")

; Global media hotkeys that work even when app is not focused
^!l::
{
    ; Like/favorite current song
    if WinExist("ahk_exe spotify.exe") {
        WinActivate
        Send("^!l")
        ShowOSD("❤ Liked")
    }
}

#HotIf

; Quick sound scheme toggle
^!+s::
{
    static soundsEnabled := true

    if (soundsEnabled) {
        ; Disable system sounds
        Run("powershell.exe -Command ""Set-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.None'""", , "Hide")
        soundsEnabled := false
        ShowOSD("🔕 System Sounds OFF")
    } else {
        ; Enable system sounds (Windows default scheme)
        Run("powershell.exe -Command ""Set-ItemProperty -Path 'HKCU:\AppEvents\Schemes' -Name '(Default)' -Value '.Default'""", , "Hide")
        soundsEnabled := true
        ShowOSD("🔔 System Sounds ON")
    }
}

; Show current volume level
^!i::
{
    vol := Round(SoundGetVolume())
    muted := SoundGetMute()

    status := muted ? " (MUTED)" : ""
    ShowOSD("Volume: " vol "%" status, 2000)
}
