#Requires AutoHotkey v2.0
#SingleInstance Force
; Secure Password Generator
passGui := Gui()
passGui.Title := "Password Generator"

passGui.Add("Text", "x10 y10", "Length:")
lengthInput := passGui.Add("Edit", "x70 y7 w60 Number", "16")
passGui.Add("UpDown", "Range8-128", 16)

passGui.Add("Checkbox", "x10 y40 vUseUpper Checked", "Uppercase (A-Z)")
passGui.Add("Checkbox", "x10 y65 vUseLower Checked", "Lowercase (a-z)")
passGui.Add("Checkbox", "x10 y90 vUseDigits Checked", "Digits (0-9)")
passGui.Add("Checkbox", "x10 y115 vUseSymbols Checked", "Symbols (!@#$...)")

passGui.Add("Button", "x10 y145 w150", "Generate Password").OnEvent("Click", GeneratePassword)

resultText := passGui.Add("Edit", "x10 y180 w300 h30 ReadOnly")
resultText.SetFont("s12 Bold", "Consolas")

passGui.Add("Button", "x10 y220 w100", "Copy").OnEvent("Click", CopyPassword)
passGui.Add("Button", "x120 y220 w100", "Clear").OnEvent("Click", (*) => resultText.Value := "")

strengthText := passGui.Add("Text", "x10 y255 w300", "")

passGui.Show("w320 h290")

GeneratePassword(*) {
    length := Integer(lengthInput.Value)

    chars := ""
    if (passGui["UseUpper"].Value)
        chars .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    if (passGui["UseLower"].Value)
        chars .= "abcdefghijklmnopqrstuvwxyz"
    if (passGui["UseDigits"].Value)
        chars .= "0123456789"
    if (passGui["UseSymbols"].Value)
        chars .= "!@#$%^&*()-_=+[]{}|;:,.<>?"

    if (chars = "") {
        MsgBox("Select at least one character type!", "Error")
        return
    }

    password := ""
    Loop length {
        random := Random(1, StrLen(chars))
        password .= SubStr(chars, random, 1)
    }

    resultText.Value := password

    ; Calculate strength
    strength := CalculateStrength(password, chars)
    strengthText.Value := "Strength: " strength
}

CalculateStrength(password, chars) {
    score := 0

    if (StrLen(password) >= 12)
        score += 25
    if (StrLen(password) >= 16)
        score += 25
    if (InStr(chars, "A"))
        score += 15
    if (InStr(chars, "a"))
        score += 10
    if (InStr(chars, "0"))
        score += 15
    if (InStr(chars, "!"))
        score += 10

    if (score < 40)
        return "Weak"
    else if (score < 70)
        return "Medium"
    else
        return "Strong"
}

CopyPassword(*) {
    A_Clipboard := resultText.Value
    TrayTip("Password Copied", "Password copied to clipboard", "Iconi")
}
