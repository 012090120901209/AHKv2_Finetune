#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Color - Value object for color manipulation
; Demonstrates immutable operations and format conversions

class Color {
    __New(r, g, b, a := 255) {
        this.r := Mod(r, 256)
        this.g := Mod(g, 256)
        this.b := Mod(b, 256)
        this.a := Mod(a, 256)
    }

    static FromHex(hex) {
        hex := StrReplace(hex, "#", "")
        return Color(
            Integer("0x" SubStr(hex, 1, 2)),
            Integer("0x" SubStr(hex, 3, 2)),
            Integer("0x" SubStr(hex, 5, 2)),
            StrLen(hex) >= 8 ? Integer("0x" SubStr(hex, 7, 2)) : 255
        )
    }

    static FromHSL(h, s, l) {
        s := s / 100
        l := l / 100

        c := (1 - Abs(2 * l - 1)) * s
        x := c * (1 - Abs(Mod(h / 60, 2) - 1))
        m := l - c / 2

        if h < 60
            r := c, g := x, b := 0
        else if h < 120
            r := x, g := c, b := 0
        else if h < 180
            r := 0, g := c, b := x
        else if h < 240
            r := 0, g := x, b := c
        else if h < 300
            r := x, g := 0, b := c
        else
            r := c, g := 0, b := x

        return Color(
            Round((r + m) * 255),
            Round((g + m) * 255),
            Round((b + m) * 255)
        )
    }

    ToHex() => Format("#{:02X}{:02X}{:02X}", this.r, this.g, this.b)
    ToRGB() => Format("rgb({}, {}, {})", this.r, this.g, this.b)
    ToRGBA() => Format("rgba({}, {}, {}, {})", this.r, this.g, this.b, Round(this.a / 255, 2))

    Lighten(amount := 0.1) {
        return Color(
            Min(255, this.r + 255 * amount),
            Min(255, this.g + 255 * amount),
            Min(255, this.b + 255 * amount),
            this.a
        )
    }

    Darken(amount := 0.1) {
        return Color(
            Max(0, this.r - 255 * amount),
            Max(0, this.g - 255 * amount),
            Max(0, this.b - 255 * amount),
            this.a
        )
    }

    Mix(other, weight := 0.5) {
        return Color(
            Round(this.r * (1 - weight) + other.r * weight),
            Round(this.g * (1 - weight) + other.g * weight),
            Round(this.b * (1 - weight) + other.b * weight),
            Round(this.a * (1 - weight) + other.a * weight)
        )
    }

    Invert() {
        return Color(255 - this.r, 255 - this.g, 255 - this.b, this.a)
    }

    Grayscale() {
        gray := Round(this.r * 0.299 + this.g * 0.587 + this.b * 0.114)
        return Color(gray, gray, gray, this.a)
    }
}

; Demo
primary := Color.FromHex("#3498db")
secondary := Color(231, 76, 60)

MsgBox("Primary: " primary.ToHex() "`n"
    . "Lightened: " primary.Lighten(0.2).ToHex() "`n"
    . "Darkened: " primary.Darken(0.2).ToHex() "`n`n"
    . "Secondary: " secondary.ToRGB() "`n"
    . "Inverted: " secondary.Invert().ToHex() "`n"
    . "Grayscale: " secondary.Grayscale().ToHex() "`n`n"
    . "Mixed: " primary.Mix(secondary, 0.5).ToHex())
