#Requires AutoHotkey v2.0
#SingleInstance Force

; Library: Descolada/Acc-v2
; Function: ElementFromPoint - Get accessible element at cursor
; Category: Accessibility (MSAA)
; Use Case: Automate legacy apps using Microsoft Active Accessibility

; Example: Get MSAA element under cursor
; Note: Requires Acc.ahk library from Descolada/Acc-v2

; #Include <Acc>

DemoAccElementFromPoint() {
    MsgBox("Acc ElementFromPoint Demonstration`n`n"
        "Get accessible elements using MSAA:`n`n"
        "Usage with Acc library:`n"
        "element := Acc.ElementFromPoint(x, y)`n"
        "name := element.Name`n"
        "role := element.Role`n"
        "value := element.Value`n`n"
        "When to use Acc vs UIA:`n"
        "- Use Acc for older Windows apps (pre-Vista)`n"
        "- Use UIA for modern apps (Windows 7+)`n"
        "- Some apps only support MSAA, not UIA`n`n"
        "Install: Download from Descolada/Acc-v2",
        "Acc Demo")
}

; Real implementation example (commented out, requires library):
/*
^+i:: {  ; Ctrl+Shift+I to inspect
MouseGetPos(&x, &y)

try {
    ; Get element at cursor
    element := Acc.ElementFromPoint(x, y)

    ; Display element properties
    info := "Name: " element.Name "`n"
    info .= "Role: " element.Role "`n"
    info .= "Value: " element.Value "`n"
    info .= "State: " element.State "`n"
    info .= "Location: " element.Location

    MsgBox(info, "MSAA Element Info")
} catch as err {
    MsgBox("Error: " err.Message)
}
}
*/

; Run demonstration
DemoAccElementFromPoint()
