#Requires AutoHotkey v2.0
#SingleInstance Force
; Advanced GUI Example: RGB Color Picker
; Demonstrates: Slider controls, dynamic color preview, hex conversion, clipboard

myGui := Gui()
myGui.Title := "RGB Color Picker"
myGui.BackColor := "White"

; Color preview box
preview := myGui.Add("Progress", "x10 y10 w280 h100 Background000000")

; Red slider
myGui.Add("Text", "x10 y120", "Red:")
redSlider := myGui.Add("Slider", "x60 y117 w180 Range0-255 TickInterval16 vRed", 0)
redSlider.OnEvent("Change", UpdateColor)
redValue := myGui.Add("Edit", "x250 y115 w40 Number ReadOnly", "0")

; Green slider
myGui.Add("Text", "x10 y150", "Green:")
greenSlider := myGui.Add("Slider", "x60 y147 w180 Range0-255 TickInterval16 vGreen", 0)
greenSlider.OnEvent("Change", UpdateColor)
greenValue := myGui.Add("Edit", "x250 y145 w40 Number ReadOnly", "0")

; Blue slider
myGui.Add("Text", "x10 y180", "Blue:")
blueSlider := myGui.Add("Slider", "x60 y177 w180 Range0-255 TickInterval16 vBlue", 0)
blueSlider.OnEvent("Change", UpdateColor)
blueValue := myGui.Add("Edit", "x250 y175 w40 Number ReadOnly", "0")

; Hex output
myGui.Add("Text", "x10 y215", "Hex:")
hexValue := myGui.Add("Edit", "x60 y212 w100 ReadOnly", "#000000")

; RGB output
myGui.Add("Text", "x10 y245", "RGB:")
rgbValue := myGui.Add("Edit", "x60 y242 w230 ReadOnly", "rgb(0, 0, 0)")

; Buttons
myGui.Add("Button", "x10 y275 w90", "Copy Hex").OnEvent("Click", CopyHex)
myGui.Add("Button", "x110 y275 w90", "Copy RGB").OnEvent("Click", CopyRGB)
myGui.Add("Button", "x210 y275 w80", "Random").OnEvent("Click", RandomColor)

myGui.Show("w300 h315")

UpdateColor(*) {
    r := redSlider.Value
    g := greenSlider.Value
    b := blueSlider.Value

    ; Update value displays
    redValue.Value := r
    greenValue.Value := g
    blueValue.Value := b

    ; Convert to hex
    hex := Format("#{:02X}{:02X}{:02X}", r, g, b)
    hexValue.Value := hex

    ; RGB format
    rgbValue.Value := "rgb(" r ", " g ", " b ")"

    ; Update preview color
    color := Format("{:02X}{:02X}{:02X}", r, g, b)
    preview.Opt("Background" color)
}

CopyHex(*) {
    A_Clipboard := hexValue.Value
    ToolTip("Hex color copied!")
    SetTimer(() => ToolTip(), -1000)
}

CopyRGB(*) {
    A_Clipboard := rgbValue.Value
    ToolTip("RGB color copied!")
    SetTimer(() => ToolTip(), -1000)
}

RandomColor(*) {
    redSlider.Value := Random(0, 255)
    greenSlider.Value := Random(0, 255)
    blueSlider.Value := Random(0, 255)
    UpdateColor()
}
