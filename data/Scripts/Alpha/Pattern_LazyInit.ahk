#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Lazy Initialization Pattern - Defers object creation until first use
; Demonstrates computed properties with cached values

class LazyValue {
    __New(initializer) {
        this.initializer := initializer
        this.computed := false
        this.cache := ""
    }

    Value {
        get {
            if !this.computed {
                this.cache := this.initializer()
                this.computed := true
            }
            return this.cache
        }
    }

    IsComputed() => this.computed

    Reset() {
        this.computed := false
        this.cache := ""
    }
}

class Config {
    static settings := LazyValue(() => Config.LoadFromFile())
    static users := LazyValue(() => Config.LoadUsers())

    static LoadFromFile() {
        ; Simulate expensive file read
        Sleep(50)
        return Map("theme", "dark", "lang", "en", "debug", true)
    }

    static LoadUsers() {
        ; Simulate database query
        Sleep(50)
        return ["Alice", "Bob", "Charlie"]
    }
}

; Demo - values computed only when accessed
start := A_TickCount
MsgBox("Settings computed: " Config.settings.IsComputed())

settings := Config.settings.Value
elapsed := A_TickCount - start

MsgBox("Theme: " settings["theme"] "`n"
    . "Computed in: " elapsed "ms`n`n"
    . "Second access (cached)...")

start := A_TickCount
settings := Config.settings.Value
elapsed := A_TickCount - start

MsgBox("Second access: " elapsed "ms (instant from cache)")
