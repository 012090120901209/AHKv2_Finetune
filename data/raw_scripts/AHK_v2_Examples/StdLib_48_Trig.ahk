#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Sin(), Cos(), Tan() - Trigonometric functions
 *
 * Standard trigonometric functions (angles in radians).
 */

angle := 45
radians := angle * 3.14159 / 180  ; Convert to radians

MsgBox("Angle: " angle "° (" radians " radians)`n`n"
    . "Sin: " Round(Sin(radians), 4) "`n"
    . "Cos: " Round(Cos(radians), 4) "`n"
    . "Tan: " Round(Tan(radians), 4))
