#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP GUI Example
class Component {
    __New(title) => (this.title := title, this.gui := "")
    Build() => (this.gui := Gui(, this.title), this.gui.Add("Text", "", "OOP Component: " . this.title), this.gui.Show(), this)
}
Component("${file}").Build()
