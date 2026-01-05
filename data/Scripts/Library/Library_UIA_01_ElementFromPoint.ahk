#Requires AutoHotkey v2.0
#SingleInstance Force

; Library: Descolada/UIA-v2
; Function: ElementFromPoint - Get UI element at cursor position
; Category: UI Automation
; Use Case: Inspect UI elements under mouse cursor

; Example: Get element under mouse cursor and show its properties
; Note: Requires UIA.ahk library from Descolada/UIA-v2

; Simulated UIA functionality (replace with actual #Include <UIA> when library is installed)
; #Include <UIA>

MsgBox("Move your mouse over any UI element and press Ctrl+Shift+I to inspect it")

; Hotkey to inspect element under cursor
^+i:: {
    ; Get current mouse position
    MouseGetPos(&x, &y)

    ; In real usage with UIA library:
    ; element := UIA.ElementFromPoint(x, y)
    ; info := "Name: " element.Name "`n"
    ; info .= "Type: " element.Type "`n"
    ; info .= "Value: " element.Value "`n"
    ; info .= "BoundingRectangle: " element.BoundingRectangle
    ; MsgBox(info, "UI Element Inspector")

    ; Demonstration output (without library)
    info := "Mouse Position: " x ", " y "`n"
    info .= "`nTo use real UIA functionality:`n"
    info .= "1. Install Descolada/UIA-v2 library`n"
    info .= "2. Add: #Include <UIA>`n"
    info .= "3. element := UIA.ElementFromPoint(x, y)`n"
    info .= "4. Access properties: element.Name, element.Type, etc."

    MsgBox(info, "UIA ElementFromPoint Demo")
}
