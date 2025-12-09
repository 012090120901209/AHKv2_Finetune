#Requires AutoHotkey v2.0
#SingleInstance Force
; Unit Converter
convGui := Gui()
convGui.Title := "Unit Converter"

convGui.Add("Text", "x10 y10", "Category:")
categoryDDL := convGui.Add("DropDownList", "x80 y7 w200", ["Length", "Weight", "Temperature", "Speed"])
categoryDDL.Choose(1)
categoryDDL.OnEvent("Change", UpdateUnits)

convGui.Add("Text", "x10 y45", "Value:")
valueInput := convGui.Add("Edit", "x80 y42 w200 Number", "1")

convGui.Add("Text", "x10 y80", "From:")
fromUnit := convGui.Add("DropDownList", "x80 y77 w200")

convGui.Add("Text", "x10 y115", "To:")
toUnit := convGui.Add("DropDownList", "x80 y112 w200")

convGui.Add("Button", "x80 y150 w200", "Convert").OnEvent("Click", Convert)

resultText := convGui.Add("Edit", "x10 y185 w270 h30 ReadOnly")
resultText.SetFont("s12 Bold")

convGui.Show("w290 h230")

UpdateUnits()

UpdateUnits(*) {
    category := categoryDDL.Text

    fromUnit.Delete()
    toUnit.Delete()

    Switch category {
        case "Length":
        units := ["Meters", "Kilometers", "Miles", "Feet", "Inches"]
        case "Weight":
        units := ["Kilograms", "Pounds", "Ounces", "Grams"]
        case "Temperature":
        units := ["Celsius", "Fahrenheit", "Kelvin"]
        case "Speed":
        units := ["km/h", "mph", "m/s"]
    }

    for unit in units {
        fromUnit.Add([unit])
        toUnit.Add([unit])
    }

    fromUnit.Choose(1)
    toUnit.Choose(2)
}

Convert(*) {
    value := Float(valueInput.Value)
    category := categoryDDL.Text
    from := fromUnit.Text
    to := toUnit.Text

    if (from = to) {
        resultText.Value := value
        return
    }

    result := ConvertValue(value, category, from, to)
    resultText.Value := Round(result, 4)
}

ConvertValue(value, category, from, to) {
    ; Simplified conversion - in real app would have comprehensive tables
    Switch category {
        case "Length":
        ; Convert to meters first
        Switch from {
            case "Meters": base := value
            case "Kilometers": base := value * 1000
            case "Miles": base := value * 1609.34
            case "Feet": base := value * 0.3048
            case "Inches": base := value * 0.0254
        }
        ; Then convert from meters
        Switch to {
            case "Meters": return base
            case "Kilometers": return base / 1000
            case "Miles": return base / 1609.34
            case "Feet": return base / 0.3048
            case "Inches": return base / 0.0254
        }
        case "Temperature":
        ; Convert to Celsius
        Switch from {
            case "Celsius": base := value
            case "Fahrenheit": base := (value - 32) * 5/9
            case "Kelvin": base := value - 273.15
        }
        ; Convert from Celsius
        Switch to {
            case "Celsius": return base
            case "Fahrenheit": return base * 9/5 + 32
            case "Kelvin": return base + 273.15
        }
    }
    return value
}
