#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Spring Physics - Damped harmonic oscillator
; Demonstrates physics-based animation

class Spring {
    __New(options := "") {
        this.stiffness := options.Has("stiffness") ? options["stiffness"] : 100
        this.damping := options.Has("damping") ? options["damping"] : 10
        this.mass := options.Has("mass") ? options["mass"] : 1
        this.velocity := 0
        this.value := 0
        this.target := 0
    }

    SetTarget(target) {
        this.target := target
        return this
    }

    Update(deltaTime) {
        ; F = -kx - cv (Hooke's law + damping)
        displacement := this.value - this.target
        springForce := -this.stiffness * displacement
        dampingForce := -this.damping * this.velocity

        acceleration := (springForce + dampingForce) / this.mass
        this.velocity += acceleration * deltaTime
        this.value += this.velocity * deltaTime

        return this.value
    }

    IsAtRest(threshold := 0.001) {
        return Abs(this.value - this.target) < threshold
            && Abs(this.velocity) < threshold
    }

    Reset(value := 0) {
        this.value := value
        this.velocity := 0
        this.target := value
    }
}

; 2D Spring for position
class Spring2D {
    __New(options := "") {
        this.springX := Spring(options)
        this.springY := Spring(options)
    }

    SetValue(x, y) {
        this.springX.value := x
        this.springY.value := y
        return this
    }

    SetTarget(x, y) {
        this.springX.SetTarget(x)
        this.springY.SetTarget(y)
        return this
    }

    Update(deltaTime) {
        return Map(
            "x", this.springX.Update(deltaTime),
            "y", this.springY.Update(deltaTime)
        )
    }

    IsAtRest(threshold := 0.001) {
        return this.springX.IsAtRest(threshold) && this.springY.IsAtRest(threshold)
    }

    GetPosition() => Map("x", this.springX.value, "y", this.springY.value)
}

; Spring presets
class SpringPresets {
    static Gentle := Map("stiffness", 50, "damping", 15, "mass", 1)
    static Wobbly := Map("stiffness", 180, "damping", 12, "mass", 1)
    static Stiff := Map("stiffness", 300, "damping", 20, "mass", 1)
    static Slow := Map("stiffness", 30, "damping", 8, "mass", 1)
    static Molasses := Map("stiffness", 60, "damping", 35, "mass", 1)
}

; Demo - Basic spring
mySpring := Spring(Map("stiffness", 100, "damping", 10))
mySpring.value := 0
mySpring.SetTarget(100)

result := "Spring Animation (target: 100):`n`n"
dt := 0.016  ; ~60fps

Loop 30 {
    value := mySpring.Update(dt)
    bar := ""
    Loop Round(value / 2)
        bar .= "█"
    result .= Format("t={:4.2f}: {:6.2f} {}`n", A_Index * dt, value, bar)

    if mySpring.IsAtRest()
        break
}

MsgBox(result)

; Demo - Compare presets
presets := Map(
    "Gentle", SpringPresets.Gentle,
    "Wobbly", SpringPresets.Wobbly,
    "Stiff", SpringPresets.Stiff
)

result := "Spring Preset Comparison (target: 100):`n`n"

for name, preset in presets {
    s := Spring(preset)
    s.SetTarget(100)

    result .= name ":`n"
    Loop 20 {
        value := s.Update(0.02)
        if Mod(A_Index, 4) = 0
            result .= Format("  t={:.2f}: {:.1f}`n", A_Index * 0.02, value)
    }
    result .= "`n"
}

MsgBox(result)

; Demo - 2D Spring
mySpring2D := Spring2D(SpringPresets.Wobbly)
mySpring2D.SetValue(0, 0).SetTarget(100, 50)

result := "2D Spring Animation:`n`n"
Loop 15 {
    pos := mySpring2D.Update(0.03)
    result .= Format("t={:.2f}: ({:.1f}, {:.1f})`n", A_Index * 0.03, pos["x"], pos["y"])

    if mySpring2D.IsAtRest()
        break
}

MsgBox(result)
