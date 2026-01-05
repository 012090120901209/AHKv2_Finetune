#Requires AutoHotkey v2.0
#SingleInstance Force
; OOP GUI: Tabs Manager
; Demonstrates: Tab organization, dynamic content

class TabPage {
    __New(title) => (this.title := title, this.controls := [])
    AddControl(ctrl) => (this.controls.Push(ctrl), this)
}

class TabsManager {
    __New(title) => (this.title := title, this.pages := [], this.gui := "", this.tab := "")

    AddPage(page) => (this.pages.Push(page), this)

    Build() {
        this.gui := Gui(, this.title)
        this.tab := this.gui.Add("Tab3", "x10 y10 w500 h300", this.pages.Map((p) => p.title))

        loop this.pages.Length {
            this.tab.UseTab(A_Index)
            for ctrl in this.pages[A_Index].controls
                this.gui.Add(ctrl.type, ctrl.options, ctrl.text)
        }

        this.tab.UseTab()
        this.gui.Show()
        return this
    }
}

; Usage
tabs := TabsManager("Settings")

generalPage := TabPage("General")
generalPage.AddControl({ type: "Text", options: "x30 y50", text: "Application Name:" })
    .AddControl({ type: "Edit", options: "x150 y47 w200", text: "" })

advancedPage := TabPage("Advanced")
advancedPage.AddControl({ type: "Checkbox", options: "x30 y50", text: "Enable Debug Mode" })
    .AddControl({ type: "Checkbox", options: "x30 y80", text: "Auto-update" })

tabs.AddPage(generalPage).AddPage(advancedPage).Build()
