#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Particle System - Simple particle simulation
; Demonstrates game-like particle effects

class Particle {
    __New(x, y, options := "") {
        this.x := x
        this.y := y
        this.vx := options.Has("vx") ? options["vx"] : 0
        this.vy := options.Has("vy") ? options["vy"] : 0
        this.ax := options.Has("ax") ? options["ax"] : 0
        this.ay := options.Has("ay") ? options["ay"] : 0
        this.life := options.Has("life") ? options["life"] : 1.0
        this.maxLife := this.life
        this.size := options.Has("size") ? options["size"] : 5
        this.color := options.Has("color") ? options["color"] : 0xFFFFFF
        this.alpha := options.Has("alpha") ? options["alpha"] : 1.0
        this.decay := options.Has("decay") ? options["decay"] : 1.0
        this.friction := options.Has("friction") ? options["friction"] : 1.0
    }

    Update(dt) {
        ; Apply acceleration
        this.vx += this.ax * dt
        this.vy += this.ay * dt
        
        ; Apply friction
        this.vx *= this.friction
        this.vy *= this.friction
        
        ; Update position
        this.x += this.vx * dt
        this.y += this.vy * dt
        
        ; Decay life
        this.life -= dt * this.decay
        
        ; Update alpha based on life
        this.alpha := Max(0, this.life / this.maxLife)
    }

    IsAlive() => this.life > 0
}

class ParticleEmitter {
    __New(x, y, options := "") {
        this.x := x
        this.y := y
        this.particles := []
        this.emitRate := options.Has("emitRate") ? options["emitRate"] : 10
        this.maxParticles := options.Has("maxParticles") ? options["maxParticles"] : 100
        this.particleOptions := options.Has("particleOptions") ? options["particleOptions"] : Map()
        this.emitAccumulator := 0
        this.active := true
    }

    SetPosition(x, y) {
        this.x := x
        this.y := y
    }

    Emit(count := 1) {
        Loop count {
            if this.particles.Length >= this.maxParticles
                break
            
            opts := Map()
            for k, v in this.particleOptions
                opts[k] := IsObject(v) && v.Has("min") 
                         ? v["min"] + Random() * (v["max"] - v["min"])
                         : v
            
            this.particles.Push(Particle(this.x, this.y, opts))
        }
    }

    Update(dt) {
        ; Emit new particles
        if this.active {
            this.emitAccumulator += this.emitRate * dt
            while this.emitAccumulator >= 1 {
                this.Emit(1)
                this.emitAccumulator--
            }
        }

        ; Update existing particles
        i := this.particles.Length
        while i >= 1 {
            this.particles[i].Update(dt)
            if !this.particles[i].IsAlive()
                this.particles.RemoveAt(i)
            i--
        }
    }

    GetParticles() => this.particles
    Count() => this.particles.Length
    Clear() => this.particles := []
}

; Predefined emitter configurations
class ParticlePresets {
    static Fire() {
        return Map(
            "emitRate", 30,
            "maxParticles", 200,
            "particleOptions", Map(
                "vx", Map("min", -20, "max", 20),
                "vy", Map("min", -80, "max", -40),
                "ay", -50,
                "life", Map("min", 0.5, "max", 1.5),
                "size", Map("min", 3, "max", 8),
                "color", 0xFF4500,
                "decay", 1.0,
                "friction", 0.98
            )
        )
    }

    static Explosion() {
        return Map(
            "emitRate", 0,  ; Burst only
            "maxParticles", 100,
            "particleOptions", Map(
                "vx", Map("min", -200, "max", 200),
                "vy", Map("min", -200, "max", 200),
                "ay", 100,
                "life", Map("min", 0.5, "max", 2.0),
                "size", Map("min", 2, "max", 6),
                "color", 0xFFFF00,
                "decay", 0.8,
                "friction", 0.95
            )
        )
    }

    static Snow() {
        return Map(
            "emitRate", 20,
            "maxParticles", 300,
            "particleOptions", Map(
                "vx", Map("min", -10, "max", 10),
                "vy", Map("min", 30, "max", 60),
                "ax", Map("min", -5, "max", 5),
                "life", Map("min", 3, "max", 5),
                "size", Map("min", 2, "max", 5),
                "color", 0xFFFFFF,
                "decay", 0.3,
                "friction", 1.0
            )
        )
    }

    static Sparkle() {
        return Map(
            "emitRate", 15,
            "maxParticles", 50,
            "particleOptions", Map(
                "vx", Map("min", -50, "max", 50),
                "vy", Map("min", -50, "max", 50),
                "life", Map("min", 0.3, "max", 0.8),
                "size", Map("min", 1, "max", 3),
                "color", 0xFFD700,
                "decay", 2.0,
                "friction", 0.9
            )
        )
    }
}

; Demo - Simulate particle system
MsgBox("Particle System Demo`n`nSimulating different particle effects...")

; Fire emitter
fireEmitter := ParticleEmitter(200, 300, ParticlePresets.Fire())

result := "Fire Particle Simulation:`n`n"
Loop 5 {
    fireEmitter.Update(0.1)  ; 100ms timestep
    result .= Format("t={:.1f}s: {} particles`n", A_Index * 0.1, fireEmitter.Count())
    
    ; Show some particle positions
    if fireEmitter.particles.Length > 0 {
        p := fireEmitter.particles[1]
        result .= Format("  First: ({:.1f}, {:.1f}) life={:.2f}`n", p.x, p.y, p.life)
    }
}

MsgBox(result)

; Explosion burst
explosionEmitter := ParticleEmitter(300, 200, ParticlePresets.Explosion())
explosionEmitter.Emit(50)  ; Burst of particles

result := "Explosion Simulation:`n`n"
result .= "Burst: " explosionEmitter.Count() " particles`n`n"

Loop 10 {
    explosionEmitter.Update(0.1)
    alive := explosionEmitter.Count()
    bar := ""
    Loop Round(alive / 2)
        bar .= "█"
    result .= Format("t={:.1f}s: {:3} {}`n", A_Index * 0.1, alive, bar)
}

MsgBox(result)

; Snow effect stats
snowEmitter := ParticleEmitter(0, 0, ParticlePresets.Snow())

result := "Snow Particle Stats:`n`n"
Loop 10 {
    snowEmitter.Update(0.2)
}

result .= "After 2 seconds:`n"
result .= "  Active particles: " snowEmitter.Count() "`n"

if snowEmitter.particles.Length > 0 {
    avgY := 0
    for p in snowEmitter.particles
        avgY += p.y
    avgY /= snowEmitter.particles.Length
    result .= "  Average Y position: " Round(avgY, 1) "`n"
}

MsgBox(result)
