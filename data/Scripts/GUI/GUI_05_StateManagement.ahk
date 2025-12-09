#Requires AutoHotkey v2.0
#SingleInstance Force
#Include JSON.ahk

/**
* GUI State Management
*
* Demonstrates separating GUI state from controls using a centralized
* state Map with reactive updates.
*
* Source: AHK_Notes/Concepts/GUI_State_Management.md
*/

app := StateManagementDemo()
app.Show()

/**
* StateManagementDemo - GUI with centralized state
*/
class StateManagementDemo {
    ; Default state configuration
    static DEFAULT_STATE := Map(
    "width", 600,
    "height", 400,
    "fontSize", 10,
    "darkMode", false,
    "userName", "Guest"
    )

    ; Application state (separate from UI)
    state := Map()

    ; GUI and control references
    gui := ""
    controls := Map()

    __New() {
        ; Initialize state from defaults
        this.ResetState()

        ; Create GUI
        this.gui := Gui("+Resize", "State Management Demo")
        this.gui.SetFont("s" this.state["fontSize"])

        ; Create controls
        this.controls["userName"] := this.gui.Add("Edit", "w300", this.state["userName"])
        this.controls["userName"].OnEvent("Change", ObjBindMethod(this, "OnUserNameChange"))

        this.controls["userLabel"] := this.gui.Add("Text", "w300", "User: " this.state["userName"])

        this.gui.Add("Text", "xm y+20", "Font Size:")
        this.controls["fontSize"] := this.gui.Add("Slider", "w300 Range8-16 TickInterval2", this.state["fontSize"])
        this.controls["fontSize"].OnEvent("Change", ObjBindMethod(this, "OnFontSizeChange"))
        this.controls["fontSizeLabel"] := this.gui.Add("Text", "x+10 yp", this.state["fontSize"])

        this.controls["darkMode"] := this.gui.Add("Checkbox", "xm y+20", "Dark Mode")
        this.controls["darkMode"].OnEvent("Click", ObjBindMethod(this, "OnDarkModeToggle"))

        this.gui.Add("Button", "xm y+20 w140", "Reset to Defaults").OnEvent("Click", ObjBindMethod(this, "OnReset"))
        this.gui.Add("Button", "x+10 w140", "Show State").OnEvent("Click", ObjBindMethod(this, "OnShowState"))

        ; Apply initial state to UI
        this.UpdateUI()
    }

    /**
    * Reset state to defaults
    */
    ResetState() {
        this.state := this.DEFAULT_STATE.Clone()
    }

    /**
    * Update all UI elements from state
    * Central reactive update method
    */
    UpdateUI() {
        ; Update font size across all controls
        this.gui.SetFont("s" this.state["fontSize"])

        ; Update colors based on dark mode
        if (this.state["darkMode"]) {
            this.gui.BackColor := "0x2b2b2b"
            this.gui.SetFont("cWhite")
        } else {
            this.gui.BackColor := "Default"
            this.gui.SetFont("cBlack")
        }

        ; Update control values
        if (this.controls.Has("fontSizeLabel"))
        this.controls["fontSizeLabel"].Value := this.state["fontSize"]

        if (this.controls.Has("userLabel"))
        this.controls["userLabel"].Value := "User: " this.state["userName"]

        ; Resize window if needed
        this.gui.Move(, , this.state["width"], this.state["height"])
    }

    /**
    * Event Handlers - Update state then refresh UI
    */
    OnUserNameChange(ctrl, *) {
        this.state["userName"] := ctrl.Value
        this.UpdateUI()
    }

    OnFontSizeChange(ctrl, *) {
        this.state["fontSize"] := ctrl.Value
        this.UpdateUI()
    }

    OnDarkModeToggle(ctrl, *) {
        this.state["darkMode"] := ctrl.Value
        this.UpdateUI()
    }

    OnReset(ctrl, *) {
        this.ResetState()

        ; Update control values to match state
        this.controls["userName"].Value := this.state["userName"]
        this.controls["fontSize"].Value := this.state["fontSize"]
        this.controls["darkMode"].Value := this.state["darkMode"]

        this.UpdateUI()
    }

    OnShowState(ctrl, *) {
        stateStr := "Current State:`n`n"
        for key, value in this.state {
            stateStr .= key ": " value "`n"
        }
        MsgBox(stateStr, , "T5")
    }

    Show() {
        this.gui.Show()
    }
}

/*
* Key Concepts:
*
* 1. State Separation:
*    state := Map()  ; Separate from GUI controls
*    Controls display state, don't own it
*    Single source of truth
*
* 2. Default State Pattern:
*    static DEFAULT_STATE := Map(...)
*    ResetState() { this.state := DEFAULT_STATE.Clone() }
*    Easy initialization and reset
*
* 3. Reactive Updates:
*    OnChange(ctrl, *) {
    *        this.state["key"] := ctrl.Value  ; Update state
    *        this.UpdateUI()                  ; Refresh UI
    *    }
    *
    * 4. Centralized UpdateUI():
    *    Apply all state changes to controls
    *    Called after every state modification
    *    Ensures UI always reflects state
    *
    * 5. Control References:
    *    controls := Map()  ; Store control references
    *    Access controls by name
    *    Clean, organized architecture
    *
    * 6. Benefits:
    *    ✅ State is serializable (Map to JSON)
    *    ✅ Easy to implement undo/redo
    *    ✅ Testable business logic
    *    ✅ Clear data flow
    *    ✅ No scattered state
    *
    * 7. State Persistence:
    *    SaveState() {
        *        json := JSON.Stringify(this.state)
        *        FileWrite(json, "state.json")
        *    }
        *
        *    LoadState() {
            *        json := FileRead("state.json")
            *        this.state := JSON.Parse(json)
            *        this.UpdateUI()
            *    }
            */
