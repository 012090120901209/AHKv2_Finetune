#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Tween and Animation Engine
; Demonstrates animation timing and interpolation

class Tween {
    __New(target, property, endValue, duration, easing := "") {
        this.target := target
        this.property := property
        this.startValue := target.%property%
        this.endValue := endValue
        this.duration := duration
        this.easing := easing ?? Easing.Linear
        this.elapsed := 0
        this.isComplete := false
        this.onUpdate := ""
        this.onComplete := ""
    }

    Update(deltaTime) {
        if this.isComplete
            return

        this.elapsed += deltaTime
        progress := Min(this.elapsed / this.duration, 1)
        easedProgress := this.easing(progress)

        newValue := this.startValue + (this.endValue - this.startValue) * easedProgress
        this.target.%this.property% := newValue

        if this.onUpdate
            this.onUpdate(this, newValue, progress)

        if progress >= 1 {
            this.isComplete := true
            if this.onComplete
                this.onComplete(this)
        }
    }

    OnUpdate(callback) {
        this.onUpdate := callback
        return this
    }

    OnComplete(callback) {
        this.onComplete := callback
        return this
    }
}

; Animation sequence for chaining tweens
class TweenSequence {
    __New() {
        this.tweens := []
        this.currentIndex := 1
        this.isComplete := false
    }

    Add(tween) {
        this.tweens.Push(tween)
        return this
    }

    Update(deltaTime) {
        if this.isComplete || this.currentIndex > this.tweens.Length
            return

        current := this.tweens[this.currentIndex]
        current.Update(deltaTime)

        if current.isComplete {
            this.currentIndex++
            if this.currentIndex > this.tweens.Length
                this.isComplete := true
        }
    }
}

; Parallel animation group
class TweenGroup {
    __New() {
        this.tweens := []
        this.isComplete := false
    }

    Add(tween) {
        this.tweens.Push(tween)
        return this
    }

    Update(deltaTime) {
        allComplete := true
        for tw in this.tweens {
            tw.Update(deltaTime)
            if !tw.isComplete
                allComplete := false
        }
        this.isComplete := allComplete
    }
}

; Easing functions
class Easing {
    static Linear(t) => t

    static EaseInQuad(t) => t * t
    static EaseOutQuad(t) => t * (2 - t)
    static EaseInOutQuad(t) => t < 0.5 ? 2 * t * t : -1 + (4 - 2 * t) * t

    static EaseInCubic(t) => t * t * t
    static EaseOutCubic(t) => (--t) * t * t + 1
    static EaseInOutCubic(t) => t < 0.5 ? 4 * t * t * t : (t - 1) * (2 * t - 2) * (2 * t - 2) + 1

    static EaseInElastic(t) {
        if t = 0 || t = 1
            return t
        return -2 ** (10 * (t - 1)) * Sin((t - 1.1) * 5 * 3.14159)
    }

    static EaseOutElastic(t) {
        if t = 0 || t = 1
            return t
        return 2 ** (-10 * t) * Sin((t - 0.1) * 5 * 3.14159) + 1
    }

    static EaseOutBounce(t) {
        if t < 1 / 2.75
            return 7.5625 * t * t
        else if t < 2 / 2.75
            return 7.5625 * (t -= 1.5 / 2.75) * t + 0.75
        else if t < 2.5 / 2.75
            return 7.5625 * (t -= 2.25 / 2.75) * t + 0.9375
        return 7.5625 * (t -= 2.625 / 2.75) * t + 0.984375
    }
}

; Demo object
class AnimatedObject {
    __New() {
        this.x := 0
        this.y := 0
        this.alpha := 1
        this.scale := 1
    }
}

; Demo
obj := AnimatedObject()

; Create tweens
xTween := Tween(obj, "x", 100, 1.0, Easing.EaseOutQuad)
yTween := Tween(obj, "y", 50, 1.0, Easing.EaseOutBounce)

; Group for parallel animation
group := TweenGroup()
group.Add(xTween).Add(yTween)

; Simulate animation frames
result := "Animation Simulation (parallel x and y):`n`n"
frameTime := 0.1

Loop 12 {
    group.Update(frameTime)
    result .= Format("t={:.1f}s: x={:.1f}, y={:.1f}`n", 
                     A_Index * frameTime, obj.x, obj.y)
    
    if group.isComplete
        break
}

MsgBox(result)

; Demo - Sequence animation
obj2 := AnimatedObject()

sequence := TweenSequence()
sequence.Add(Tween(obj2, "x", 100, 0.5, Easing.EaseInOutQuad))
sequence.Add(Tween(obj2, "y", 100, 0.5, Easing.EaseInOutQuad))
sequence.Add(Tween(obj2, "scale", 2, 0.3, Easing.EaseOutElastic))

result := "Sequential Animation:`n`n"
Loop 15 {
    sequence.Update(frameTime)
    result .= Format("t={:.1f}s: x={:.1f}, y={:.1f}, scale={:.2f}`n",
                     A_Index * frameTime, obj2.x, obj2.y, obj2.scale)
    
    if sequence.isComplete
        break
}

MsgBox(result)
