#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Flyweight Pattern - Shares common state between multiple objects
; Demonstrates memory optimization through object pooling

class IconFactory {
    static cache := Map()
    static cacheHits := 0
    static cacheMisses := 0

    static Get(name) {
        if this.cache.Has(name) {
            this.cacheHits++
            return this.cache[name]
        }

        this.cacheMisses++
        this.cache[name] := Icon(name)
        return this.cache[name]
    }

    static GetStats() {
        return "Cache: " this.cache.Count " icons`n"
            . "Hits: " this.cacheHits "`n"
            . "Misses: " this.cacheMisses
    }
}

class Icon {
    __New(name) {
        this.name := name
        ; Simulate heavy pixel data
        this.pixels := "heavy_pixel_data_for_" name "_icon"
        this.created := A_TickCount
    }
}

; Demo - request same icons multiple times
icons := []
requests := ["folder", "file", "folder", "edit", "folder", "file", "save", "file"]

for name in requests
    icons.Push(IconFactory.Get(name))

MsgBox("Requested " requests.Length " icons`n`n" IconFactory.GetStats())
