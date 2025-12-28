#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Easing Functions - Animation interpolation curves
; Demonstrates mathematical easing for smooth animations

class Easing {
    ; Linear
    static Linear(t) => t

    ; Quadratic
    static EaseInQuad(t) => t * t
    static EaseOutQuad(t) => t * (2 - t)
    static EaseInOutQuad(t) => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t

    ; Cubic
    static EaseInCubic(t) => t * t * t
    static EaseOutCubic(t) => (--t) * t * t + 1
    static EaseInOutCubic(t) => t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1

    ; Sine
    static EaseInSine(t) => 1 - Cos(t * 3.14159 / 2)
    static EaseOutSine(t) => Sin(t * 3.14159 / 2)
    static EaseInOutSine(t) => -(Cos(3.14159 * t) - 1) / 2

    ; Exponential
    static EaseInExpo(t) => t = 0 ? 0 : 2 ** (10 * t - 10)
    static EaseOutExpo(t) => t = 1 ? 1 : 1 - 2 ** (-10 * t)

    ; Elastic
    static EaseOutElastic(t) {
        if t = 0 || t = 1
            return t
        return 2 ** (-10 * t) * Sin((t * 10 - 0.75) * 2.094) + 1
    }

    ; Bounce
    static EaseOutBounce(t) {
        if t < 1 / 2.75
            return 7.5625 * t * t
        if t < 2 / 2.75
            return 7.5625 * (t -= 1.5 / 2.75) * t + 0.75
        if t < 2.5 / 2.75
            return 7.5625 * (t -= 2.25 / 2.75) * t + 0.9375
        return 7.5625 * (t -= 2.625 / 2.75) * t + 0.984375
    }

    ; Back (overshoot)
    static EaseOutBack(t) {
        c1 := 1.70158
        c3 := c1 + 1
        return 1 + c3 * (t - 1) ** 3 + c1 * (t - 1) ** 2
    }
}

; Tween - animates a value from start to end
class Tween {
    __New(from, to, duration, easing := "") {
        this.from := from
        this.to := to
        this.duration := duration
        this.easing := easing ? easing : Easing.Linear
        this.startTime := 0
        this.running := false
        this.onUpdate := ""
        this.onComplete := ""
    }

    Start() {
        this.startTime := A_TickCount
        this.running := true
        this.callback := this.Update.Bind(this)
        SetTimer(this.callback, 16)
        return this
    }

    Update() {
        elapsed := A_TickCount - this.startTime
        progress := Min(1, elapsed / this.duration)
        easedProgress := this.easing(progress)

        current := this.from + (this.to - this.from) * easedProgress

        if this.onUpdate
            this.onUpdate(current, progress)

        if progress >= 1 {
            this.running := false
            SetTimer(this.callback, 0)
            if this.onComplete
                this.onComplete()
        }
    }

    Stop() {
        this.running := false
        SetTimer(this.callback, 0)
    }
}

; Demo - show easing curves
easings := [
    ["Linear", Easing.Linear],
    ["EaseOutQuad", Easing.EaseOutQuad],
    ["EaseOutCubic", Easing.EaseOutCubic],
    ["EaseOutElastic", Easing.EaseOutElastic],
    ["EaseOutBounce", Easing.EaseOutBounce]
]

result := "Easing Values (t=0.5):`n"
for pair in easings {
    name := pair[1]
    fn := pair[2]
    result .= name ": " Round(fn(0.5), 3) "`n"
}

MsgBox(result)

; Animated tween demo
myTween := Tween(0, 100, 1000, Easing.EaseOutElastic)
myTween.onUpdate := (val, progress) => ToolTip("Value: " Round(val) " (" Round(progress * 100) "%)")
myTween.onComplete := () => (ToolTip(), MsgBox("Animation complete!"))
myTween.Start()
