#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: Tab Control with Multiple Pages
; Demonstrates: Tab control, organizing controls, different control types per tab

myGui := Gui()
myGui.Title := "Settings Manager"

; Create tab control
tabs := myGui.Add("Tab3", "x10 y10 w480 h400", ["General", "Display", "Advanced"])

; Tab 1: General
tabs.UseTab(1)
myGui.Add("Text", "x30 y50", "Username:")
myGui.Add("Edit", "x120 y47 w200 vUsername", "DefaultUser")
myGui.Add("Text", "x30 y80", "Email:")
myGui.Add("Edit", "x120 y77 w300 vEmail", "user@example.com")
myGui.Add("Checkbox", "x30 y110 vStartup", "Run at startup")
myGui.Add("Checkbox", "x30 y135 vNotifications", "Enable notifications")
myGui.Add("DropDownList", "x30 y165 w200 vLanguage", ["English", "Spanish", "French", "German"])

; Tab 2: Display
tabs.UseTab(2)
myGui.Add("Text", "x30 y50", "Theme:")
myGui.Add("Radio", "x30 y75 vThemeLight Checked", "Light")
myGui.Add("Radio", "x30 y100 vThemeDark", "Dark")
myGui.Add("Radio", "x30 y125 vThemeAuto", "Auto")
myGui.Add("Text", "x30 y160", "Font Size:")
myGui.Add("Slider", "x30 y185 w300 Range8-24 TickInterval2 vFontSize", 12)
fontLabel := myGui.Add("Text", "x340 y185 w40", "12")
myGui.Add("Checkbox", "x30 y220 vShowIcons", "Show icons")
myGui.Add("Checkbox", "x30 y245 vAnimations", "Enable animations")

; Tab 3: Advanced
tabs.UseTab(3)
myGui.Add("GroupBox", "x30 y50 w430 h120", "Performance")
myGui.Add("Text", "x50 y75", "Cache Size (MB):")
myGui.Add("Edit", "x180 y72 w80 Number vCacheSize", "256")
myGui.Add("UpDown", "vCacheSizeUD Range0-2048", 256)
myGui.Add("Checkbox", "x50 y105 vHardwareAccel Checked", "Enable hardware acceleration")
myGui.Add("Checkbox", "x50 y130 vAutoUpdate", "Automatic updates")

myGui.Add("GroupBox", "x30 y180 w430 h100", "Privacy")
myGui.Add("Checkbox", "x50 y205 vTelemetry", "Send usage statistics")
myGui.Add("Checkbox", "x50 y230 vCrashReports", "Send crash reports")
myGui.Add("Button", "x50 y255 w150", "Clear Cache").OnEvent("Click", ClearCache)

; End tab definitions
tabs.UseTab()

; Bottom buttons (outside tabs)
myGui.Add("Button", "x250 y420 w80", "Save").OnEvent("Click", SaveSettings)
myGui.Add("Button", "x340 y420 w80", "Cancel").OnEvent("Click", (*) => myGui.Destroy())
myGui.Add("Button", "x430 y420 w60", "Apply").OnEvent("Click", ApplySettings)

myGui.Show("w500 h460")

SaveSettings(*) {
    saved := myGui.Submit(false)
    settings := ""
    for name, value in saved.OwnProps()
    settings .= name ": " value "`n"
    MsgBox("Settings saved!`n`n" settings, "Success")
    myGui.Destroy()
}

ApplySettings(*) {
    saved := myGui.Submit(false)
    MsgBox("Settings applied (not saved)", "Applied")
}

ClearCache(*) {
    result := MsgBox("Clear all cached data?", "Confirm", "YesNo Icon?")
    if (result = "Yes")
    MsgBox("Cache cleared!", "Success")
}
