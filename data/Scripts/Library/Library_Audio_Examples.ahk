#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Audio Control Library Examples - thqby/ahk2_lib
 * 
 * System audio control, volume management, audio sessions
 * Library: https://github.com/thqby/ahk2_lib/blob/master/Audio.ahk
 */

/**
 * Example 1: Get and Set Master Volume
 */
MasterVolumeExample() {
    MsgBox("Get and Set Master Volume`n`n"
        . "; Get default audio endpoint`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "device := enumerator.GetDefaultAudioEndpoint(0, 0)  ; Render, Console`n"
        . "volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "; Get current volume (0.0 to 1.0)`n"
        . "current := volume.GetMasterVolumeLevelScalar()`n"
        . 'MsgBox("Current volume: " Round(current * 100) "%")`n`n'
        . "; Set volume to 50%`n"
        . "volume.SetMasterVolumeLevelScalar(0.5)")
}

/**
 * Example 2: Mute and Unmute Audio
 */
MuteControlExample() {
    MsgBox("Mute and Unmute System Audio`n`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "; Check if muted`n"
        . "isMuted := volume.GetMute()`n"
        . 'MsgBox("Currently muted: " (isMuted ? "Yes" : "No"))`n`n'
        . "; Toggle mute`n"
        . "volume.SetMute(!isMuted)")
}

/**
 * Example 3: Volume Hotkeys
 */
VolumeHotkeysExample() {
    MsgBox("Custom Volume Hotkeys`n`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "; Volume Up (Ctrl+Alt+Up)`n"
        . "^!Up:: {`n"
        . "    current := volume.GetMasterVolumeLevelScalar()`n"
        . "    new := Min(current + 0.05, 1.0)`n"
        . "    volume.SetMasterVolumeLevelScalar(new)`n"
        . "    ToolTip('Volume: ' Round(new * 100) '%')`n"
        . "    SetTimer(() => ToolTip(), -1000)`n"
        . "}`n`n"
        . "; Volume Down (Ctrl+Alt+Down)`n"
        . "^!Down:: {`n"
        . "    current := volume.GetMasterVolumeLevelScalar()`n"
        . "    new := Max(current - 0.05, 0.0)`n"
        . "    volume.SetMasterVolumeLevelScalar(new)`n"
        . "    ToolTip('Volume: ' Round(new * 100) '%')`n"
        . "    SetTimer(() => ToolTip(), -1000)`n"
        . "}`n`n"
        . "; Mute Toggle (Ctrl+Alt+M)`n"
        . "^!M:: {`n"
        . "    isMuted := volume.GetMute()`n"
        . "    volume.SetMute(!isMuted)`n"
        . "    ToolTip(isMuted ? 'Unmuted' : 'Muted')`n"
        . "    SetTimer(() => ToolTip(), -1000)`n"
        . "}")
}

/**
 * Example 4: List Audio Devices
 */
ListAudioDevicesExample() {
    MsgBox("List All Audio Devices`n`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "collection := enumerator.EnumAudioEndpoints(0, 1)  ; Render, Active`n`n"
        . "count := collection.GetCount()`n"
        . "devices := 'Audio Devices:`n`n'`n`n"
        . "loop count {`n"
        . "    device := collection.Item(A_Index - 1)`n"
        . "    props := device.OpenPropertyStore(0)`n"
        . "    name := props.GetValue(PKEY_Device_FriendlyName)`n"
        . "    devices .= A_Index '. ' name '`n'`n"
        . "}`n"
        . "MsgBox(devices)")
}

/**
 * Example 5: Per-Channel Volume Control
 */
ChannelVolumeExample() {
    MsgBox("Control Individual Audio Channels`n`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "; Get channel count`n"
        . "channelCount := volume.GetChannelCount()`n"
        . 'MsgBox("Channels: " channelCount)`n`n'
        . "; Set left channel (0) to 70%`n"
        . "volume.SetChannelVolumeLevelScalar(0, 0.7)`n`n"
        . "; Set right channel (1) to 90%`n"
        . "volume.SetChannelVolumeLevelScalar(1, 0.9)")
}

/**
 * Example 6: Volume Slider GUI
 */
VolumeSliderExample() {
    MsgBox("Volume Control GUI`n`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "gui := Gui(, 'Volume Control')`n"
        . "gui.SetFont('s10')`n`n"
        . "current := Round(volume.GetMasterVolumeLevelScalar() * 100)`n"
        . "gui.Add('Text', 'x10 y10', 'Master Volume:')`n"
        . "slider := gui.Add('Slider', 'x10 y35 w300 Range0-100 ToolTip', current)`n"
        . "valueText := gui.Add('Text', 'x320 y35 w40', current '%')`n"
        . "muteBtn := gui.Add('Button', 'x10 y70 w100', 'Mute')`n`n"
        . "slider.OnEvent('Change', (*) => {`n"
        . "    value := slider.Value`n"
        . "    volume.SetMasterVolumeLevelScalar(value / 100)`n"
        . "    valueText.Value := value '%'`n"
        . "})`n`n"
        . "muteBtn.OnEvent('Click', (*) => {`n"
        . "    isMuted := volume.GetMute()`n"
        . "    volume.SetMute(!isMuted)`n"
        . "    muteBtn.Text := isMuted ? 'Mute' : 'Unmute'`n"
        . "})`n`n"
        . "gui.Show()")
}

/**
 * Example 7: Get Audio Meter Information
 */
AudioMeterExample() {
    MsgBox("Audio Level Meter`n`n"
        . "enumerator := IMMDeviceEnumerator()`n"
        . "device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "meter := device.Activate(IAudioMeterInformation.IID)`n`n"
        . "; Get current peak value (0.0 to 1.0)`n"
        . "peak := meter.GetPeakValue()`n"
        . 'MsgBox("Current audio level: " Round(peak * 100) "%")`n`n'
        . "; Monitor in real-time`n"
        . "SetTimer(() => {`n"
        . "    peak := meter.GetPeakValue()`n"
        . "    bars := Round(peak * 20)`n"
        . "    ToolTip('Audio: [' StrRepeat('|', bars) StrRepeat(' ', 20 - bars) ']')`n"
        . "}, 100)")
}

/**
 * Example 8: Control Application-Specific Volume
 */
AppVolumeExample() {
    MsgBox("Control Application-Specific Volume`n`n"
        . "; Find audio session by process name`n"
        . "FindSessionByProcess(processName) {`n"
        . "    enumerator := IMMDeviceEnumerator()`n"
        . "    device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "    sessionManager := device.Activate(IAudioSessionManager2.IID)`n"
        . "    sessions := sessionManager.GetSessionEnumerator()`n`n"
        . "    count := sessions.GetCount()`n"
        . "    loop count {`n"
        . "        session := sessions.GetSession(A_Index - 1)`n"
        . "        control := session.QueryInterface(IAudioSessionControl2.IID)`n"
        . "        pid := control.GetProcessId()`n"
        . "        name := ProcessGetName(pid)`n"
        . "        if (InStr(name, processName))`n"
        . "            return session`n"
        . "    }`n"
        . "    return ''`n"
        . "}`n`n"
        . "; Set Firefox volume to 50%`n"
        . "session := FindSessionByProcess('firefox.exe')`n"
        . "if (session) {`n"
        . "    volume := session.QueryInterface(ISimpleAudioVolume.IID)`n"
        . "    volume.SetMasterVolume(0.5)`n"
        . "}")
}

/**
 * Example 9: Audio Device Switcher
 */
DeviceSwitcherExample() {
    MsgBox("Switch Default Audio Device`n`n"
        . "class AudioDeviceSwitcher {`n"
        . "    enumerator := '`'`n"
        . "    devices := []`n`n"
        . "    __New() {`n"
        . "        this.enumerator := IMMDeviceEnumerator()`n"
        . "        this.RefreshDevices()`n"
        . "    }`n`n"
        . "    RefreshDevices() {`n"
        . "        collection := this.enumerator.EnumAudioEndpoints(0, 1)`n"
        . "        count := collection.GetCount()`n"
        . "        this.devices := []`n"
        . "        loop count {`n"
        . "            device := collection.Item(A_Index - 1)`n"
        . "            this.devices.Push(device)`n"
        . "        }`n"
        . "    }`n`n"
        . "    SwitchToNext() {`n"
        . "        currentId := this.GetDefaultDevice().GetId()`n"
        . "        for index, device in this.devices {`n"
        . "            if (device.GetId() = currentId) {`n"
        . "                nextIndex := Mod(index, this.devices.Length) + 1`n"
        . "                this.SetDefaultDevice(this.devices[nextIndex])`n"
        . "                return`n"
        . "            }`n"
        . "        }`n"
        . "    }`n`n"
        . "    GetDefaultDevice() {`n"
        . "        return this.enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "    }`n"
        . "}")
}

/**
 * Example 10: Volume Fade Effect
 */
VolumeFadeExample() {
    MsgBox("Fade Volume In/Out`n`n"
        . "FadeVolume(targetVolume, duration := 1000) {`n"
        . "    enumerator := IMMDeviceEnumerator()`n"
        . "    device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "    volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "    currentVolume := volume.GetMasterVolumeLevelScalar()`n"
        . "    steps := 20`n"
        . "    stepSize := (targetVolume - currentVolume) / steps`n"
        . "    delay := duration / steps`n`n"
        . "    loop steps {`n"
        . "        currentVolume += stepSize`n"
        . "        volume.SetMasterVolumeLevelScalar(currentVolume)`n"
        . "        Sleep(delay)`n"
        . "    }`n"
        . "}`n`n"
        . "; Fade out to 0%`n"
        . "FadeVolume(0.0, 2000)`n"
        . "; Fade in to 80%`n"
        . "FadeVolume(0.8, 2000)")
}

/**
 * Example 11: Audio Profile Manager
 */
AudioProfileExample() {
    MsgBox("Audio Profile Manager`n`n"
        . "class AudioProfile {`n"
        . "    profiles := Map()`n"
        . "    volume := '`'`n`n"
        . "    __New() {`n"
        . "        enumerator := IMMDeviceEnumerator()`n"
        . "        device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
        . "        this.volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
        . "        ; Define profiles`n"
        . "        this.profiles['silent'] := 0.0`n"
        . "        this.profiles['quiet'] := 0.2`n"
        . "        this.profiles['normal'] := 0.5`n"
        . "        this.profiles['loud'] := 0.8`n"
        . "        this.profiles['max'] := 1.0`n"
        . "    }`n`n"
        . "    Apply(profileName) {`n"
        . "        if (!this.profiles.Has(profileName))`n"
        . "            return false`n"
        . "        this.volume.SetMasterVolumeLevelScalar(this.profiles[profileName])`n"
        . "        return true`n"
        . "    }`n`n"
        . "    SaveCurrent(profileName) {`n"
        . "        current := this.volume.GetMasterVolumeLevelScalar()`n"
        . "        this.profiles[profileName] := current`n"
        . "    }`n"
        . "}`n`n"
        . "profile := AudioProfile()`n"
        . "profile.Apply('normal')  ; Apply normal profile")
    }

    /**
     * Example 12: Audio Session Monitor
     */
    AudioSessionMonitorExample() {
        MsgBox("Monitor All Audio Sessions`n`n"
            . "GetActiveSessions() {`n"
            . "    enumerator := IMMDeviceEnumerator()`n"
            . "    device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
            . "    sessionManager := device.Activate(IAudioSessionManager2.IID)`n"
            . "    sessionEnum := sessionManager.GetSessionEnumerator()`n`n"
            . "    sessions := []`n"
            . "    count := sessionEnum.GetCount()`n"
            . "    loop count {`n"
            . "        session := sessionEnum.GetSession(A_Index - 1)`n"
            . "        control := session.QueryInterface(IAudioSessionControl2.IID)`n"
            . "        volume := session.QueryInterface(ISimpleAudioVolume.IID)`n`n"
            . "        sessions.Push({`n"
            . "            pid: control.GetProcessId(),`n"
            . "            name: ProcessGetName(control.GetProcessId()),`n"
            . "            volume: Round(volume.GetMasterVolume() * 100),`n"
            . "            muted: volume.GetMute()`n"
            . "        })`n"
            . "    }`n"
            . "    return sessions`n"
            . "}`n`n"
            . "sessions := GetActiveSessions()`n"
            . "for session in sessions`n"
            . "    MsgBox(session.name ': ' session.volume '% ' (session.muted ? '(Muted)' : ''))")
    }

    /**
     * Example 13: Volume Range Information
     */
    VolumeRangeExample() {
        MsgBox("Get Volume Range Information`n`n"
            . "enumerator := IMMDeviceEnumerator()`n"
            . "device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
            . "volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
            . "; Get volume range in decibels`n"
            . "minDB := volume.GetVolumeRangeMin()`n"
            . "maxDB := volume.GetVolumeRangeMax()`n"
            . "stepDB := volume.GetVolumeRangeStep()`n`n"
            . 'MsgBox("Volume Range:`n"`n'
            . "    . \" Min: \ " minDB \" dB`n\ "`n"
            . "    . \" Max: \ " maxDB \" dB`n\ "`n"
            . "    . \" Step: \ " stepDB \" dB\ ")")
    }

    /**
     * Example 14: Audio Balance Control
     */
    BalanceControlExample() {
        MsgBox("Control Audio Balance (Left/Right)`n`n"
            . "SetBalance(balance) {`n"
            . "    ; balance: -1.0 (left) to 1.0 (right), 0.0 is center`n"
            . "    enumerator := IMMDeviceEnumerator()`n"
            . "    device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
            . "    volume := device.Activate(IAudioEndpointVolume.IID)`n`n"
            . "    if (volume.GetChannelCount() < 2)`n"
            . "        return  ; Mono device`n`n"
            . "    ; Calculate left/right volumes`n"
            . "    if (balance < 0) {`n"
            . "        leftVol := 1.0`n"
            . "        rightVol := 1.0 + balance`n"
            . "    } else {`n"
            . "        leftVol := 1.0 - balance`n"
            . "        rightVol := 1.0`n"
            . "    }`n`n"
            . "    volume.SetChannelVolumeLevelScalar(0, leftVol)`n"
            . "    volume.SetChannelVolumeLevelScalar(1, rightVol)`n"
            . "}`n`n"
            . "SetBalance(-0.5)  ; More to left`n"
            . "SetBalance(0.5)   ; More to right`n"
            . "SetBalance(0.0)   ; Centered")
        }

        /**
         * Example 15: Auto-Ducking Manager
         */
        AutoDuckingExample() {
            MsgBox("Auto-Ducking for Communications`n`n"
                . "; When a communication app (Skype, Teams) becomes active,`n"
                . "; other audio is automatically reduced`n`n"
                . "class DuckingManager {`n"
                . "    normalVolume := 0.8`n"
                . "    duckedVolume := 0.3`n"
                . "    volume := '`'`n`n"
                . "    __New() {`n"
                . "        enumerator := IMMDeviceEnumerator()`n"
                . "        device := enumerator.GetDefaultAudioEndpoint(0, 0)`n"
                . "        this.volume := device.Activate(IAudioEndpointVolume.IID)`n"
                . "    }`n`n"
                . "    EnableDucking() {`n"
                . "        ; Lower volume when communication app is active`n"
                . "        if (WinExist('ahk_exe Teams.exe') || WinExist('ahk_exe Skype.exe'))`n"
                . "            this.volume.SetMasterVolumeLevelScalar(this.duckedVolume)`n"
                . "        else`n"
                . "            this.volume.SetMasterVolumeLevelScalar(this.normalVolume)`n"
                . "    }`n`n"
                . "    StartMonitoring() {`n"
                . "        SetTimer(() => this.EnableDucking(), 1000)`n"
                . "    }`n"
                . "}")
        }

        MsgBox("Audio Control Library Examples Loaded`n`n"
            . "Note: These are conceptual examples.`n"
            . "To use, you need to include:`n"
            . "#Include <Audio>`n`n"
            . "Available Examples:`n"
            . "- MasterVolumeExample()`n"
            . "- MuteControlExample()`n"
            . "- VolumeHotkeysExample()`n"
            . "- ListAudioDevicesExample()`n"
            . "- VolumeSliderExample()`n"
            . "- AudioMeterExample()`n"
            . "- AppVolumeExample()`n"
            . "- AudioProfileExample()")

        ; Uncomment to view examples:
        ; MasterVolumeExample()
        ; MuteControlExample()
        ; ListAudioDevicesExample()
        ; AudioMeterExample()

