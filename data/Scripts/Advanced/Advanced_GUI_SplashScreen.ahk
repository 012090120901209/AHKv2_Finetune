#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: Animated Splash Screen with Loading Bar
; Demonstrates: Borderless GUI, transparency, timers, delayed loading

; Create splash screen
splash := Gui("-Caption +AlwaysOnTop +ToolWindow")
splash.BackColor := "0x1a1a1a"
splash.SetFont("s14 cWhite", "Segoe UI")

; Add title
splash.Add("Text", "x0 y30 w400 Center", "MyApplication v2.0")

; Add subtitle
splash.SetFont("s9 cSilver", "Segoe UI")
splash.Add("Text", "x0 y65 w400 Center", "Professional Edition")

; Add progress bar
progress := splash.Add("Progress", "x50 y110 w300 h8 -Smooth Background333333 cBlue")

; Add status text
splash.SetFont("s9 cSilver", "Segoe UI")
statusText := splash.Add("Text", "x0 y130 w400 Center", "Initializing...")

; Add version info
splash.SetFont("s8 c888888", "Segoe UI")
splash.Add("Text", "x0 y180 w400 Center", "Â© 2025 MyCompany. All rights reserved.")

splash.Show("w400 h210 Center")

; Make window semi-transparent
WinSetTransparent(245, splash.Hwnd)

; Loading simulation
global loadSteps := ["Initializing modules...", "Loading configuration...", "Connecting to database...", "Loading user preferences...", "Preparing interface...", "Almost ready...", "Complete!"]
global currentStep := 0
global maxSteps := loadSteps.Length

SetTimer(UpdateLoading, 300)

UpdateLoading() {
    global currentStep, maxSteps, loadSteps, statusText, progress

    currentStep++

    if (currentStep > maxSteps) {
        SetTimer(UpdateLoading, 0)

        ; Fade out splash screen
        Loop 24 {
            trans := 245 - (A_Index * 10)
            WinSetTransparent(trans > 0 ? trans : 0, splash.Hwnd)
            Sleep(20)
        }

        splash.Destroy()
        ShowMainApp()
        return
    }

    ; Update progress
    percent := Round((currentStep / maxSteps) * 100)
    progress.Value := percent

    ; Update status text
    statusText.Value := loadSteps[currentStep]
}

ShowMainApp() {
    ; Main application GUI
    mainGui := Gui()
    mainGui.Title := "MyApplication v2.0"
    mainGui.Add("Text", "x10 y10 w460 h100 Center", "Application loaded successfully!`n`nThe splash screen has been dismissed.`n`nThis is your main application window.")
    mainGui.Add("Button", "x190 y120 w100", "OK").OnEvent("Click", (*) => ExitApp())
    mainGui.Show("w480 h160")
}
