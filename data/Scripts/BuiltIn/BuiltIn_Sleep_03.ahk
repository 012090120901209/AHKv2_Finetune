/**
* @file BuiltIn_Sleep_03.ahk
* @description Animations and visual effects with Sleep in AutoHotkey v2
* @author AutoHotkey v2 Examples Collection
* @version 1.0.0
* @date 2024-01-15
*
* Creative use of Sleep for animations, smooth transitions, visual effects,
* progress indicators, and interactive UI animations.
*
* @syntax Sleep Delay
* @see https://www.autohotkey.com/docs/v2/lib/Sleep.htm
* @requires AutoHotkey v2.0+
*/

#Requires AutoHotkey v2.0
#SingleInstance Force

; ============================================================================
; EXAMPLE 1: Progress Bar Animations
; ============================================================================
/**
* Demonstrates smooth progress bar animations with Sleep
* Shows different animation speeds and patterns
*/
Example1_ProgressAnimations() {
    myGui := Gui("+AlwaysOnTop", "Example 1: Progress Bar Animations")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Smooth Progress Bar Animations")

    ; Progress bars
    myGui.Add("Text", "xm", "Linear Progress:")
    linearBar := myGui.Add("Progress", "w500 h30 vLinear BackgroundGreen", 0)

    myGui.Add("Text", "xm", "`nAccelerated Progress:")
    accelBar := myGui.Add("Progress", "w500 h30 vAccel BackgroundBlue", 0)

    myGui.Add("Text", "xm", "`nDecelerated Progress:")
    decelBar := myGui.Add("Progress", "w500 h30 vDecel BackgroundPurple", 0)

    myGui.Add("Text", "xm", "`nBounce Progress:")
    bounceBar := myGui.Add("Progress", "w500 h30 vBounce BackgroundOrange", 0)

    ; Status
    statusText := myGui.Add("Text", "w500 Center vStatus", "Ready")

    ; Controls
    myGui.Add("Text", "xm", "`nAnimation Controls:")
    linearBtn := myGui.Add("Button", "w160", "Linear Fill")
    accelBtn := myGui.Add("Button", "w160 x+10", "Accelerated")
    decelBtn := myGui.Add("Button", "w160 x+10", "Decelerated")
    bounceBtn := myGui.Add("Button", "w160 xm", "Bounce Fill")
    allBtn := myGui.Add("Button", "w160 x+10", "All Animations")
    resetBtn := myGui.Add("Button", "w160 x+10", "Reset All")

    ; Linear animation
    linearBtn.OnEvent("Click", (*) => AnimateLinear())
    AnimateLinear() {
        statusText.Value := "Animating: Linear"
        linearBar.Value := 0

        Loop 100 {
            linearBar.Value := A_Index
            Sleep(20)  ; Constant speed
        }

        statusText.Value := "Complete: Linear"
    }

    ; Accelerated animation (easing in)
    accelBtn.OnEvent("Click", (*) => AnimateAccel())
    AnimateAccel() {
        statusText.Value := "Animating: Accelerated"
        accelBar.Value := 0

        Loop 100 {
            accelBar.Value := A_Index

            ; Delay decreases as we progress (speeds up)
            delay := 50 - Round((A_Index / 100) * 45)
            Sleep(delay)
        }

        statusText.Value := "Complete: Accelerated"
    }

    ; Decelerated animation (easing out)
    decelBtn.OnEvent("Click", (*) => AnimateDecel())
    AnimateDecel() {
        statusText.Value := "Animating: Decelerated"
        decelBar.Value := 0

        Loop 100 {
            decelBar.Value := A_Index

            ; Delay increases as we progress (slows down)
            delay := 5 + Round((A_Index / 100) * 45)
            Sleep(delay)
        }

        statusText.Value := "Complete: Decelerated"
    }

    ; Bounce animation
    bounceBtn.OnEvent("Click", (*) => AnimateBounce())
    AnimateBounce() {
        statusText.Value := "Animating: Bounce"
        bounceBar.Value := 0

        ; Forward
        Loop 100 {
            bounceBar.Value := A_Index
            Sleep(10)
        }

        ; Bounce back slightly
        Loop 20 {
            bounceBar.Value := 100 - A_Index
            Sleep(10)
        }

        ; Settle forward
        Loop 20 {
            bounceBar.Value := 80 + A_Index
            Sleep(15)
        }

        statusText.Value := "Complete: Bounce"
    }

    ; All animations simultaneously
    allBtn.OnEvent("Click", (*) => AnimateAll())
    AnimateAll() {
        statusText.Value := "Animating: All"

        linearBar.Value := 0
        accelBar.Value := 0
        decelBar.Value := 0
        bounceBar.Value := 0

        Loop 100 {
            i := A_Index

            linearBar.Value := i

            accelBar.Value := i

            decelBar.Value := i

            bounceBar.Value := i

            Sleep(30)
        }

        statusText.Value := "Complete: All"
    }

    ; Reset all
    resetBtn.OnEvent("Click", (*) => ResetAll())
    ResetAll() {
        linearBar.Value := 0
        accelBar.Value := 0
        decelBar.Value := 0
        bounceBar.Value := 0
        statusText.Value := "Ready"
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    myGui.Show()
}

; ============================================================================
; EXAMPLE 2: Text Typing Animation
; ============================================================================
/**
* Creates typewriter effect animations
* Simulates text appearing character by character
*/
Example2_TypewriterEffect() {
    myGui := Gui("+AlwaysOnTop", "Example 2: Typewriter Effect")
    myGui.SetFont("s10")
    myGui.Add("Text", "w550 Center", "Typewriter Text Animation")

    ; Display area
    myGui.SetFont("s12")
    displayText := myGui.Add("Text", "w550 h150 Border vDisplay")
    myGui.SetFont("s10")

    ; Preset texts
    presetTexts := [
    "Hello, World! This is a typewriter animation.",
    "AutoHotkey v2 makes automation easy and powerful.",
    "Watch as each character appears one at a time...",
    "Creating engaging user interfaces with smooth animations!"
    ]

    ; Controls
    myGui.Add("Text", "xm", "Preset Messages:")
    preset1 := myGui.Add("Button", "w130", "Message 1")
    preset2 := myGui.Add("Button", "w130 x+10", "Message 2")
    preset3 := myGui.Add("Button", "w130 x+10", "Message 3")
    preset4 := myGui.Add("Button", "w130 x+10", "Message 4")

    myGui.Add("Text", "xm", "`nSpeed Control:")
    speedSlider := myGui.Add("Slider", "w400 Range10-200 TickInterval50 vSpeed", 50)
    speedText := myGui.Add("Text", "w400 vSpeedText", "Speed: 50ms per character")

    speedSlider.OnEvent("Change", (*) => UpdateSpeed())
    UpdateSpeed() {
        speedText.Value := "Speed: " speedSlider.Value "ms per character"
    }

    customInput := myGui.Add("Edit", "xm w400", "Type your custom message here...")
    customBtn := myGui.Add("Button", "x+10 w140", "Animate Custom")

    clearBtn := myGui.Add("Button", "xm w270", "Clear Display")

    static isTyping := false

    ; Typewriter animation function
    TypewriterAnimate(text, delay) {
        if (isTyping)
        return

        isTyping := true
        displayText.Value := ""

        Loop Parse text {
            if (!isTyping)
            break

            displayText.Value .= A_LoopField
            Sleep(delay)
        }

        isTyping := false
    }

    ; Preset buttons
    preset1.OnEvent("Click", (*) => TypewriterAnimate(presetTexts[1], speedSlider.Value))
    preset2.OnEvent("Click", (*) => TypewriterAnimate(presetTexts[2], speedSlider.Value))
    preset3.OnEvent("Click", (*) => TypewriterAnimate(presetTexts[3], speedSlider.Value))
    preset4.OnEvent("Click", (*) => TypewriterAnimate(presetTexts[4], speedSlider.Value))

    ; Custom text
    customBtn.OnEvent("Click", (*) => TypewriterAnimate(customInput.Value, speedSlider.Value))

    ; Clear
    clearBtn.OnEvent("Click", (*) => ClearDisplay())
    ClearDisplay() {
        isTyping := false
        displayText.Value := ""
    }

    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        isTyping := false
        myGui.Destroy()
    }

    myGui.Show()
}

; ============================================================================
; EXAMPLE 3: Fade In/Out Effects
; ============================================================================
/**
* Creates fade animations by changing window transparency
* Demonstrates smooth visual transitions
*/
Example3_FadeEffects() {
    myGui := Gui("+AlwaysOnTop", "Example 3: Fade Effects")
    myGui.SetFont("s10")
    myGui.Add("Text", "w450 Center", "Window Fade In/Out Animations")

    ; Create a separate window for fade demos
    demoGui := Gui("+AlwaysOnTop +ToolWindow", "Fade Demo")
    demoGui.SetFont("s16 Bold")
    demoGui.Add("Text", "w300 h150 Center Border", "Watch me fade!")
    demoGui.BackColor := "0x3399FF"

    ; Status
    statusText := myGui.Add("Text", "w450 Center vStatus", "Demo window created")

    ; Controls
    myGui.Add("Text", "xm", "Fade Controls:")
    fadeInBtn := myGui.Add("Button", "w140", "Fade In")
    fadeOutBtn := myGui.Add("Button", "w140 x+10", "Fade Out")
    pulseBtn := myGui.Add("Button", "w140 x+10", "Pulse")

    myGui.Add("Text", "xm", "`nSpeed Controls:")
    speedCombo := myGui.Add("DropDownList", "w200", ["Very Fast", "Fast", "Normal", "Slow", "Very Slow"])
    speedCombo.Choose(3)

    showDemoBtn := myGui.Add("Button", "xm w220", "Show Demo Window")
    hideDemoBtn := myGui.Add("Button", "w220 x+10", "Hide Demo Window")

    ; Fade in animation
    fadeInBtn.OnEvent("Click", (*) => FadeIn())
    FadeIn() {
        statusText.Value := "Fading in..."

        ; Get delay based on speed
        delays := [5, 10, 20, 40, 80]
        delay := delays[speedCombo.Value]

        ; Start from transparent
        WinSetTransparent(0, demoGui)
        demoGui.Show("NA")

        ; Fade in
        Loop 255 {
            WinSetTransparent(A_Index, demoGui)
            Sleep(delay)
        }

        WinSetTransparent("Off", demoGui)
        statusText.Value := "Fade in complete"
    }

    ; Fade out animation
    fadeOutBtn.OnEvent("Click", (*) => FadeOut())
    FadeOut() {
        statusText.Value := "Fading out..."

        delays := [5, 10, 20, 40, 80]
        delay := delays[speedCombo.Value]

        WinSetTransparent(255, demoGui)

        ; Fade out
        Loop 255 {
            opacity := 255 - A_Index
            WinSetTransparent(opacity, demoGui)
            Sleep(delay)
        }

        demoGui.Hide()
        WinSetTransparent("Off", demoGui)
        statusText.Value := "Fade out complete"
    }

    ; Pulse animation
    pulseBtn.OnEvent("Click", (*) => Pulse())
    Pulse() {
        statusText.Value := "Pulsing..."

        demoGui.Show("NA")

        Loop 3 {  ; 3 pulses
        ; Fade to 50%
        Loop 128 {
            opacity := 255 - A_Index
            WinSetTransparent(opacity, demoGui)
            Sleep(10)
        }

        ; Fade back to 100%
        Loop 128 {
            opacity := 127 + A_Index
            WinSetTransparent(opacity, demoGui)
            Sleep(10)
        }
    }

    WinSetTransparent("Off", demoGui)
    statusText.Value := "Pulse complete"
}

; Show/hide demo window
showDemoBtn.OnEvent("Click", (*) => ShowDemo())
ShowDemo() {
    WinSetTransparent("Off", demoGui)
    demoGui.Show()
    statusText.Value := "Demo window shown"
}

hideDemoBtn.OnEvent("Click", (*) => HideDemo())
HideDemo() {
    demoGui.Hide()
    statusText.Value := "Demo window hidden"
}

; Cleanup
myGui.OnEvent("Close", (*) => Cleanup())
Cleanup() {
    demoGui.Destroy()
    myGui.Destroy()
}

myGui.Show()
demoGui.Show()
}

; ============================================================================
; EXAMPLE 4: Smooth Scrolling Animation
; ============================================================================
/**
* Creates smooth scrolling effects in list boxes
* Demonstrates animated content navigation
*/
Example4_SmoothScrolling() {
    myGui := Gui("+AlwaysOnTop", "Example 4: Smooth Scrolling")
    myGui.SetFont("s10")
    myGui.Add("Text", "w500 Center", "Smooth Scrolling Animation")

    ; Generate sample content
    contentList := myGui.Add("ListBox", "w500 h300 vContent")

    Loop 100 {
        contentList.Add("Item " A_Index " - This is sample content for scrolling demonstration")
    }

    ; Status
    statusText := myGui.Add("Text", "w500 Center vStatus", "Ready")

    ; Controls
    myGui.Add("Text", "xm", "Scroll Controls:")
    topBtn := myGui.Add("Button", "w160", "Scroll to Top")
    bottomBtn := myGui.Add("Button", "w160 x+10", "Scroll to Bottom")
    midBtn := myGui.Add("Button", "w160 x+10", "Scroll to Middle")

    gotoEdit := myGui.Add("Edit", "xm w100 Number", "50")
    myGui.Add("Text", "x+5", "(1-100)")
    gotoBtn := myGui.Add("Button", "x+10 w160", "Scroll to Item")

    ; Smooth scroll to position
    SmoothScroll(targetPos) {
        currentPos := contentList.Value

        if (currentPos = targetPos)
        return

        statusText.Value := "Scrolling from " currentPos " to " targetPos "..."

        steps := Abs(targetPos - currentPos)
        direction := (targetPos > currentPos) ? 1 : -1

        ; Animate scroll
        Loop steps {
            currentPos += direction
            contentList.Choose(currentPos)
            Sleep(10)  ; Smooth animation
        }

        statusText.Value := "Scrolled to item " targetPos
    }

    ; Scroll to top
    topBtn.OnEvent("Click", (*) => SmoothScroll(1))

    ; Scroll to bottom
    bottomBtn.OnEvent("Click", (*) => SmoothScroll(100))

    ; Scroll to middle
    midBtn.OnEvent("Click", (*) => SmoothScroll(50))

    ; Scroll to specific item
    gotoBtn.OnEvent("Click", (*) => GoToItem())
    GoToItem() {
        target := Integer(gotoEdit.Value)
        if (target >= 1 && target <= 100)
        SmoothScroll(target)
    }

    myGui.OnEvent("Close", (*) => myGui.Destroy())
    contentList.Choose(1)
    myGui.Show()
}

; ============================================================================
; EXAMPLE 5: Spinning/Rotating Loading Indicator
; ============================================================================
/**
* Creates rotating loading indicators using text characters
* Simulates spinner animations
*/
Example5_LoadingSpinner() {
    myGui := Gui("+AlwaysOnTop", "Example 5: Loading Spinners")
    myGui.SetFont("s10")
    myGui.Add("Text", "w450 Center", "Animated Loading Indicators")

    ; Spinner displays
    myGui.SetFont("s24 Bold")
    spinner1 := myGui.Add("Text", "w450 Center vSpinner1", "")
    myGui.SetFont("s16 Bold")
    spinner2 := myGui.Add("Text", "w450 Center vSpinner2", "")
    myGui.SetFont("s12 Bold")
    spinner3 := myGui.Add("Text", "w450 Center vSpinner3", "")

    myGui.SetFont("s10 Norm")

    ; Status
    statusText := myGui.Add("Text", "w450 Center vStatus", "Ready")

    ; Spinner patterns
    static spinners := Map(
    "dots", ["⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏"],
    "line", ["|", "/", "-", "\"],
    "arrows", ["←", "↖", "↑", "↗", "→", "↘", "↓", "↙"],
    "dots2", ["⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷"],
    "blocks", ["▁", "▂", "▃", "▄", "▅", "▆", "▇", "█", "▇", "▆", "▅", "▄", "▃", "▂"]
    )

    static isAnimating := false

    ; Animate spinners
    AnimateSpinners() {
        if (!isAnimating)
        return

        static frame := 0
        frame++

        ; Spinner 1 - dots
        pattern1 := spinners["dots"]
        idx1 := Mod(frame, pattern1.Length) + 1
        spinner1.Value := pattern1[idx1] " Loading..."

        ; Spinner 2 - line
        pattern2 := spinners["line"]
        idx2 := Mod(frame, pattern2.Length) + 1
        spinner2.Value := "Processing " pattern2[idx2]

        ; Spinner 3 - arrows
        pattern3 := spinners["arrows"]
        idx3 := Mod(frame, pattern3.Length) + 1
        spinner3.Value := "Please wait " pattern3[idx3]
    }

    ; Controls
    startBtn := myGui.Add("Button", "xm w140", "Start Animation")
    stopBtn := myGui.Add("Button", "w140 x+10", "Stop Animation")

    durationEdit := myGui.Add("Edit", "x+20 w100 Number", "5")
    myGui.Add("Text", "x+5", "seconds")
    timedBtn := myGui.Add("Button", "x+10 w140", "Timed Animation")

    ; Start animation
    startBtn.OnEvent("Click", (*) => StartAnimation())
    StartAnimation() {
        if (isAnimating)
        return

        isAnimating := true
        SetTimer(AnimateSpinners, 100)  ; Update every 100ms

        statusText.Value := "Animating..."
        startBtn.Enabled := false
        stopBtn.Enabled := true
    }

    ; Stop animation
    stopBtn.OnEvent("Click", (*) => StopAnimation())
    StopAnimation() {
        if (!isAnimating)
        return

        isAnimating := false
        SetTimer(AnimateSpinners, 0)

        spinner1.Value := ""
        spinner2.Value := ""
        spinner3.Value := ""

        statusText.Value := "Stopped"
        startBtn.Enabled := true
        stopBtn.Enabled := false
    }

    ; Timed animation
    timedBtn.OnEvent("Click", (*) => TimedAnimation())
    TimedAnimation() {
        duration := Integer(durationEdit.Value) * 1000

        StartAnimation()
        statusText.Value := "Animating for " durationEdit.Value " seconds..."

        Sleep(duration)

        StopAnimation()
        statusText.Value := "Timed animation complete"
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        SetTimer(AnimateSpinners, 0)
        myGui.Destroy()
    }

    stopBtn.Enabled := false
    myGui.Show()
}

; ============================================================================
; EXAMPLE 6: Slide In/Out Animations
; ============================================================================
/**
* Creates sliding window animations
* Windows move smoothly into and out of view
*/
Example6_SlideAnimations() {
    myGui := Gui("+AlwaysOnTop", "Example 6: Slide Animations")
    myGui.SetFont("s10")
    myGui.Add("Text", "w450 Center", "Window Slide In/Out Effects")

    ; Create demo window
    demoGui := Gui("+ToolWindow", "Sliding Panel")
    demoGui.SetFont("s12 Bold")
    demoGui.Add("Text", "w250 h200 Center Border BackgroundBlue c0xFFFFFF", "I slide around!")

    ; Status
    statusText := myGui.Add("Text", "w450 Center vStatus", "Demo window created (hidden)")

    ; Controls
    myGui.Add("Text", "xm", "Slide Direction:")
    slideLeftBtn := myGui.Add("Button", "w100", "← Slide Left")
    slideRightBtn := myGui.Add("Button", "w100 x+10", "Slide Right →")
    slideUpBtn := myGui.Add("Button", "w100 x+10", "↑ Slide Up")
    slideDownBtn := myGui.Add("Button", "w100 x+10", "Slide Down ↓")

    hideBtn := myGui.Add("Button", "xm w220", "Hide Demo Window")
    resetBtn := myGui.Add("Button", "w220 x+10", "Reset Position")

    ; Slide from right to center
    slideLeftBtn.OnEvent("Click", (*) => SlideLeft())
    SlideLeft() {
        statusText.Value := "Sliding left..."

        startX := A_ScreenWidth
        endX := (A_ScreenWidth - 250) // 2
        yPos := (A_ScreenHeight - 200) // 2

        demoGui.Show("NA x" startX " y" yPos)

        ; Animate
        steps := 50
        Loop steps {
            currentX := startX - Round((startX - endX) * (A_Index / steps))
            demoGui.Move(currentX, yPos)
            Sleep(10)
        }

        statusText.Value := "Slide complete"
    }

    ; Slide from left to center
    slideRightBtn.OnEvent("Click", (*) => SlideRight())
    SlideRight() {
        statusText.Value := "Sliding right..."

        startX := -250
        endX := (A_ScreenWidth - 250) // 2
        yPos := (A_ScreenHeight - 200) // 2

        demoGui.Show("NA x" startX " y" yPos)

        ; Animate
        steps := 50
        Loop steps {
            currentX := startX + Round((endX - startX) * (A_Index / steps))
            demoGui.Move(currentX, yPos)
            Sleep(10)
        }

        statusText.Value := "Slide complete"
    }

    ; Slide from top to center
    slideDownBtn.OnEvent("Click", (*) => SlideDown())
    SlideDown() {
        statusText.Value := "Sliding down..."

        xPos := (A_ScreenWidth - 250) // 2
        startY := -200
        endY := (A_ScreenHeight - 200) // 2

        demoGui.Show("NA x" xPos " y" startY)

        ; Animate
        steps := 50
        Loop steps {
            currentY := startY + Round((endY - startY) * (A_Index / steps))
            demoGui.Move(xPos, currentY)
            Sleep(10)
        }

        statusText.Value := "Slide complete"
    }

    ; Slide from bottom to center
    slideUpBtn.OnEvent("Click", (*) => SlideUp())
    SlideUp() {
        statusText.Value := "Sliding up..."

        xPos := (A_ScreenWidth - 250) // 2
        startY := A_ScreenHeight
        endY := (A_ScreenHeight - 200) // 2

        demoGui.Show("NA x" xPos " y" startY)

        ; Animate
        steps := 50
        Loop steps {
            currentY := startY - Round((startY - endY) * (A_Index / steps))
            demoGui.Move(xPos, currentY)
            Sleep(10)
        }

        statusText.Value := "Slide complete"
    }

    ; Hide demo window
    hideBtn.OnEvent("Click", (*) => demoGui.Hide())

    ; Reset position
    resetBtn.OnEvent("Click", (*) => ResetPosition())
    ResetPosition() {
        xPos := (A_ScreenWidth - 250) // 2
        yPos := (A_ScreenHeight - 200) // 2
        demoGui.Show("NA x" xPos " y" yPos)
        statusText.Value := "Position reset"
    }

    ; Cleanup
    myGui.OnEvent("Close", (*) => Cleanup())
    Cleanup() {
        demoGui.Destroy()
        myGui.Destroy()
    }

    myGui.Show()
}

; ============================================================================
; MAIN MENU
; ============================================================================
MainMenu := Gui(, "Sleep Examples - Animations")
MainMenu.SetFont("s10")
MainMenu.Add("Text", "w450 Center", "AutoHotkey v2 - Animation Examples")
MainMenu.Add("Text", "w450 Center", "Select an example to run:`n")

MainMenu.Add("Button", "w450", "Example 1: Progress Bar Animations").OnEvent("Click", (*) => Example1_ProgressAnimations())
MainMenu.Add("Button", "w450", "Example 2: Typewriter Effect").OnEvent("Click", (*) => Example2_TypewriterEffect())
MainMenu.Add("Button", "w450", "Example 3: Fade Effects").OnEvent("Click", (*) => Example3_FadeEffects())
MainMenu.Add("Button", "w450", "Example 4: Smooth Scrolling").OnEvent("Click", (*) => Example4_SmoothScrolling())
MainMenu.Add("Button", "w450", "Example 5: Loading Spinners").OnEvent("Click", (*) => Example5_LoadingSpinner())
MainMenu.Add("Button", "w450", "Example 6: Slide Animations").OnEvent("Click", (*) => Example6_SlideAnimations())

MainMenu.Add("Text", "w450 Center", "`n")
MainMenu.Add("Button", "w450", "Exit All").OnEvent("Click", (*) => ExitApp())

MainMenu.Show()
