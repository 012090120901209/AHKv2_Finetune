#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Monitor Control Examples - thqby/ahk2_lib
 * 
 * Monitor brightness, contrast, multi-monitor management
 * Library: https://github.com/thqby/ahk2_lib/blob/master/Monitor.ahk
 */

/**
 * Example 1: Get Monitor Brightness
 */
GetBrightnessExample() {
    MsgBox("Get Current Monitor Brightness`n`n"
        . "monitor := Monitor()`n"
        . "brightness := monitor.GetBrightness()`n"
        . 'MsgBox("Current brightness: " brightness "%")')
}

/**
 * Example 2: Set Monitor Brightness
 */
SetBrightnessExample() {
    MsgBox("Set Monitor Brightness`n`n"
        . "monitor := Monitor()`n"
        . "monitor.SetBrightness(50)  ; Set to 50%`n"
        . 'MsgBox("Brightness set to 50%")`n`n'
        . "Sleep(2000)`n"
        . "monitor.SetBrightness(80)  ; Increase to 80%`n"
        . 'MsgBox("Brightness set to 80%")')
}

/**
 * Example 3: Adjust Brightness Gradually
 */
GradualBrightnessExample() {
    MsgBox("Gradually Adjust Brightness`n`n"
        . "monitor := Monitor()`n"
        . "current := monitor.GetBrightness()`n`n"
        . "; Fade to 30%`n"
        . "target := 30`n"
        . "step := (target - current) / 10`n"
        . "loop 10 {`n"
        . "    current += step`n"
        . "    monitor.SetBrightness(Round(current))`n"
        . "    Sleep(50)`n"
        . "}`n`n"
        . 'MsgBox("Brightness faded to 30%")')
}

/**
 * Example 4: Get Monitor Contrast
 */
GetContrastExample() {
    MsgBox("Get Current Monitor Contrast`n`n"
        . "monitor := Monitor()`n"
        . "contrast := monitor.GetContrast()`n"
        . 'MsgBox("Current contrast: " contrast "%")')
}

/**
 * Example 5: Set Monitor Contrast
 */
SetContrastExample() {
    MsgBox("Set Monitor Contrast`n`n"
        . "monitor := Monitor()`n"
        . "monitor.SetContrast(75)  ; Set to 75%`n"
        . 'MsgBox("Contrast set to 75%")`n`n'
        . "Sleep(2000)`n"
        . "monitor.SetContrast(50)  ; Reset to 50%`n"
        . 'MsgBox("Contrast reset to 50%")')
}

/**
 * Example 6: List All Monitors
 */
ListMonitorsExample() {
    MsgBox("List All Connected Monitors`n`n"
        . "monitors := Monitor.GetMonitors()`n"
        . "info := 'Connected Monitors:`n`n'`n`n"
        . "for index, mon in monitors {`n"
        . "    info .= 'Monitor ' index ':`n'`n"
        . "    info .= '  Name: ' mon.name '`n'`n"
        . "    info .= '  Width: ' mon.width '`n'`n"
        . "    info .= '  Height: ' mon.height '`n'`n"
        . "    info .= '  Primary: ' (mon.primary ? 'Yes' : 'No') '`n`n'`n"
        . "}`n"
        . "MsgBox(info)")
}

/**
 * Example 7: Control Specific Monitor
 */
ControlSpecificMonitorExample() {
    MsgBox("Control Specific Monitor`n`n"
        . "monitors := Monitor.GetMonitors()`n`n"
        . "; Control first monitor`n"
        . "if (monitors.Length >= 1) {`n"
        . "    monitor1 := Monitor(1)  ; Monitor index 1`n"
        . "    monitor1.SetBrightness(60)`n"
        . "}`n`n"
        . "; Control second monitor`n"
        . "if (monitors.Length >= 2) {`n"
        . "    monitor2 := Monitor(2)  ; Monitor index 2`n"
        . "    monitor2.SetBrightness(80)`n"
        . "}`n`n"
        . 'MsgBox("Different brightness on each monitor")')
}

/**
 * Example 8: Monitor Hotkeys for Brightness
 */
BrightnessHotkeysExample() {
    MsgBox("Brightness Control Hotkeys`n`n"
        . "monitor := Monitor()`n`n"
        . "; Increase brightness (Ctrl+Alt+Up)`n"
        . "^!Up:: {`n"
        . "    current := monitor.GetBrightness()`n"
        . "    new := Min(current + 10, 100)`n"
        . "    monitor.SetBrightness(new)`n"
        . "    ToolTip('Brightness: ' new '%')`n"
        . "    SetTimer(() => ToolTip(), -1000)`n"
        . "}`n`n"
        . "; Decrease brightness (Ctrl+Alt+Down)`n"
        . "^!Down:: {`n"
        . "    current := monitor.GetBrightness()`n"
        . "    new := Max(current - 10, 0)`n"
        . "    monitor.SetBrightness(new)`n"
        . "    ToolTip('Brightness: ' new '%')`n"
        . "    SetTimer(() => ToolTip(), -1000)`n"
        . "}")
}

/**
 * Example 9: Auto-Adjust Based on Time
 */
TimeBasedBrightnessExample() {
    MsgBox("Auto-Adjust Brightness by Time`n`n"
        . "monitor := Monitor()`n`n"
        . "AdjustBrightness() {`n"
        . "    hour := A_Hour`n`n"
        . "    ; Morning (6-12): 80%`n"
        . "    if (hour >= 6 && hour < 12)`n"
        . "        monitor.SetBrightness(80)`n"
        . "    ; Afternoon (12-18): 100%`n"
        . "    else if (hour >= 12 && hour < 18)`n"
        . "        monitor.SetBrightness(100)`n"
        . "    ; Evening (18-22): 60%`n"
        . "    else if (hour >= 18 && hour < 22)`n"
        . "        monitor.SetBrightness(60)`n"
        . "    ; Night (22-6): 30%`n"
        . "    else`n"
        . "        monitor.SetBrightness(30)`n"
        . "}`n`n"
        . "AdjustBrightness()`n"
        . "SetTimer(AdjustBrightness, 3600000)  ; Check every hour")
    }

    /**
     * Example 10: Brightness Slider GUI
     */
    BrightnessSliderExample() {
        MsgBox("Brightness Control GUI`n`n"
            . "monitor := Monitor()`n"
            . "gui := Gui(, 'Monitor Brightness')`n"
            . "gui.SetFont('s10')`n`n"
            . "current := monitor.GetBrightness()`n"
            . "gui.Add('Text', 'x10 y10', 'Brightness:')`n"
            . "slider := gui.Add('Slider', 'x10 y35 w300 Range0-100 ToolTip', current)`n"
            . "valueText := gui.Add('Text', 'x320 y35 w40', current '%')`n`n"
            . "slider.OnEvent('Change', (*) => {`n"
            . "    value := slider.Value`n"
            . "    monitor.SetBrightness(value)`n"
            . "    valueText.Value := value '%'`n"
            . "})`n`n"
            . "gui.Show()")
    }

    /**
     * Example 11: Save and Restore Settings
     */
    SaveRestoreSettingsExample() {
        MsgBox("Save and Restore Monitor Settings`n`n"
            . "class MonitorSettings {`n"
            . "    static configFile := A_ScriptDir '\\\\monitor_config.ini'`n`n"
            . "    static Save() {`n"
            . "        monitor := Monitor()`n"
            . "        brightness := monitor.GetBrightness()`n"
            . "        contrast := monitor.GetContrast()`n`n"
            . "        IniWrite(brightness, this.configFile, 'Display', 'Brightness')`n"
            . "        IniWrite(contrast, this.configFile, 'Display', 'Contrast')`n"
            . "    }`n`n"
            . "    static Restore() {`n"
            . "        if (!FileExist(this.configFile))`n"
            . "            return false`n`n"
            . "        monitor := Monitor()`n"
            . "        brightness := IniRead(this.configFile, 'Display', 'Brightness', 50)`n"
            . "        contrast := IniRead(this.configFile, 'Display', 'Contrast', 50)`n`n"
            . "        monitor.SetBrightness(brightness)`n"
            . "        monitor.SetContrast(contrast)`n"
            . "        return true`n"
            . "    }`n"
            . "}`n`n"
            . "; Save current settings`n"
            . "MonitorSettings.Save()`n"
            . "; Restore settings`n"
            . "MonitorSettings.Restore()")
    }

    /**
     * Example 12: Monitor Power Management
     */
    PowerManagementExample() {
        MsgBox("Monitor Power Management`n`n"
            . "class MonitorPower {`n"
            . "    static TurnOff() {`n"
            . "        SendMessage(0x112, 0xF170, 2, , 'Program Manager')`n"
            . "    }`n`n"
            . "    static TurnOn() {`n"
            . "        SendMessage(0x112, 0xF170, -1, , 'Program Manager')`n"
            . "    }`n`n"
            . "    static Standby() {`n"
            . "        SendMessage(0x112, 0xF170, 1, , 'Program Manager')`n"
            . "    }`n"
            . "}`n`n"
            . "; Turn off monitor`n"
            . "MonitorPower.TurnOff()`n"
            . "; Wake up on mouse move`n"
            . "KeyWait('LButton', 'D')`n"
            . "MonitorPower.TurnOn()")
    }

    /**
     * Example 13: Multi-Monitor Brightness Sync
     */
    SyncMultiMonitorExample() {
        MsgBox("Sync Brightness Across All Monitors`n`n"
            . "class MonitorSync {`n"
            . "    static SetAllBrightness(brightness) {`n"
            . "        monitors := Monitor.GetMonitors()`n"
            . "        for index, mon in monitors {`n"
            . "            monitor := Monitor(index)`n"
            . "            monitor.SetBrightness(brightness)`n"
            . "        }`n"
            . "    }`n`n"
            . "    static SetAllContrast(contrast) {`n"
            . "        monitors := Monitor.GetMonitors()`n"
            . "        for index, mon in monitors {`n"
            . "            monitor := Monitor(index)`n"
            . "            monitor.SetContrast(contrast)`n"
            . "        }`n"
            . "    }`n"
            . "}`n`n"
            . "; Set all monitors to 70% brightness`n"
            . "MonitorSync.SetAllBrightness(70)")
    }

    /**
     * Example 14: Adaptive Brightness Profile
     */
    AdaptiveBrightnessExample() {
        MsgBox("Adaptive Brightness Profile`n`n"
            . "class BrightnessProfile {`n"
            . "    profiles := Map()`n"
            . "    monitor := '`'`n`n"
            . "    __New() {`n"
            . "        this.monitor := Monitor()`n"
            . "        ; Define profiles`n"
            . "        this.profiles['work'] := {brightness: 80, contrast: 60}`n"
            . "        this.profiles['movie'] := {brightness: 40, contrast: 70}`n"
            . "        this.profiles['gaming'] := {brightness: 90, contrast: 65}`n"
            . "        this.profiles['reading'] := {brightness: 50, contrast: 55}`n"
            . "    }`n`n"
            . "    Apply(profileName) {`n"
            . "        if (!this.profiles.Has(profileName))`n"
            . "            return false`n`n"
            . "        profile := this.profiles[profileName]`n"
            . "        this.monitor.SetBrightness(profile.brightness)`n"
            . "        this.monitor.SetContrast(profile.contrast)`n"
            . "        return true`n"
            . "    }`n"
            . "}`n`n"
            . "bp := BrightnessProfile()`n"
            . "bp.Apply('work')  ; Apply work profile")
        }

        /**
         * Example 15: Monitor VCP Features
         */
        VCPFeaturesExample() {
            MsgBox("Access Monitor VCP Features`n`n"
                . "; VCP (VESA Control Protocol) allows low-level monitor control`n"
                . "monitor := Monitor()`n`n"
                . "; Get VCP feature value`n"
                . "; 0x10 = Brightness`n"
                . "; 0x12 = Contrast`n"
                . "; 0x60 = Input Source`n"
                . "brightness := monitor.GetVCPFeature(0x10)`n"
                . "contrast := monitor.GetVCPFeature(0x12)`n"
                . "inputSource := monitor.GetVCPFeature(0x60)`n`n"
                . 'MsgBox("Brightness: " brightness "`nContrast: " contrast)`n`n'
                . "; Set VCP feature value`n"
                . "monitor.SetVCPFeature(0x10, 75)  ; Set brightness to 75`n"
                . "monitor.SetVCPFeature(0x12, 60)  ; Set contrast to 60")
            }

            MsgBox("Monitor Control Library Examples Loaded`n`n"
                . "Note: These are conceptual examples.`n"
                . "To use, you need to include:`n"
                . "#Include <Monitor>`n`n"
                . "Available Examples:`n"
                . "- GetBrightnessExample()`n"
                . "- SetBrightnessExample()`n"
                . "- GradualBrightnessExample()`n"
                . "- ListMonitorsExample()`n"
                . "- BrightnessSliderExample()`n"
                . "- TimeBasedBrightnessExample()`n"
                . "- PowerManagementExample()`n"
                . "- AdaptiveBrightnessExample()")

            ; Uncomment to view examples:
            ; GetBrightnessExample()
            ; SetBrightnessExample()
            ; GradualBrightnessExample()
            ; ListMonitorsExample()
            ; BrightnessSliderExample()

