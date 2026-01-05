#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: Simple Calculator
; Demonstrates: GUI creation, button events, Edit control, error handling

calc := Gui()
calc.Title := "AHK v2 Calculator"
calc.Add("Text", "x10 y10", "Enter Expression:")
display := calc.Add("Edit", "x10 y30 w250 r1 vDisplay ReadOnly", "0")
result := calc.Add("Edit", "x10 y60 w250 r1 vResult ReadOnly", "")

; Number buttons
buttons := ["7", "8", "9", "/", "4", "5", "6", "*", "1", "2", "3", "-", "0", ".", "=", "+"]
x := 10, y := 90
for btn in buttons {
    calc.Add("Button", "x" x " y" y " w55 h40", btn).OnEvent("Click", ButtonClick)
    x += 60
    if (Mod(A_Index, 4) = 0) {
        x := 10
        y += 45
    }
}

; Clear and Backspace buttons
calc.Add("Button", "x10 y280 w115 h40", "Clear").OnEvent("Click", ClearClick)
calc.Add("Button", "x145 y280 w115 h40", "Backspace").OnEvent("Click", BackspaceClick)

calc.Show("w270 h330")

ButtonClick(GuiCtrl, *) {
    global display, result
    if (GuiCtrl.Text = "=") {
        try {
            calcResult := Evaluate(display.Value)
            result.Value := "= " calcResult
        } catch Error as err {
            result.Value := "Error: " err.Message
        }
    } else {
        display.Value .= GuiCtrl.Text
    }
}

ClearClick(*) {
    global display, result
    display.Value := ""
    result.Value := ""
}

BackspaceClick(*) {
    global display
    if (StrLen(display.Value) > 0)
        display.Value := SubStr(display.Value, 1, -1)
}

Evaluate(expr) {
    ; Simple expression evaluation using AHK's built-in expression parser
    return %expr%
}
