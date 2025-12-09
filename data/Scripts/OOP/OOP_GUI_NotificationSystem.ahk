#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP GUI: Advanced Component
class AdvancedGUI {
    __New(name) => (this.name := name, this.gui := Gui(, name), this.Build())
    Build() => (this.gui.Add("Text", "w300", "Advanced OOP GUI: " . this.name), this.gui.Show())
}
AdvancedGUI("${file}").Build()
