#Requires AutoHotkey v2.0
#SingleInstance Force

/**
* ObjBindMethod - GUI Event Binding
*
* Demonstrates binding methods to GUI events with parameters.
* Shows both simple binding and pre-filled parameter binding.
*
* Source: AHK_Notes/Methods/objbindmethod.md
*/

app := MyApp()
app.Show()

/**
* MyApp Class
* GUI application with bound method event handlers
*/
class MyApp {
    gui := ""
    status := ""

    __New() {
        this.gui := Gui("+Resize", "ObjBindMethod Example")
        this.gui.SetFont("s10")

        ; Simple binding
        this.gui.Add("Button", "w200 h30", "Click Me")
        .OnEvent("Click", ObjBindMethod(this, "HandleClick"))

        this.status := this.gui.Add("Text", "w200 h30 y+10", "Status: Ready")

        ; Binding with pre-filled parameters
        this.gui.Add("Button", "w200 h30 y+10", "Say Hello")
        .OnEvent("Click", ObjBindMethod(this, "ShowMessage", "Hello", "World"))

        this.gui.Add("Button", "w200 h30 y+10", "Say Goodbye")
        .OnEvent("Click", ObjBindMethod(this, "ShowMessage", "Goodbye", "Friend"))
    }

    /**
    * Handle button click
    */
    HandleClick(ctrl, info) {
        this.status.Value := "Clicked at " FormatTime(, "HH:mm:ss")
    }

    /**
    * Show message with pre-filled parameters
    * @param {string} msg1 - Pre-filled first message
    * @param {string} msg2 - Pre-filled second message
    * @param {object} ctrl - From event (auto-filled)
    * @param {object} info - From event (auto-filled)
    */
    ShowMessage(msg1, msg2, ctrl := "", info := "") {
        MsgBox(msg1 " " msg2 "!")
        if (ctrl != "")
        this.status.Value := "Clicked: " ctrl.Text
    }

    Show() {
        this.gui.Show()
    }
}

/*
* Key Concepts:
*
* 1. Simple Binding:
*    ObjBindMethod(this, "HandleClick")
*    Event params passed directly to method
*
* 2. Pre-filled Parameters:
*    ObjBindMethod(this, "ShowMessage", "Hello", "World")
*    "Hello" and "World" pre-filled
*    Event params (ctrl, info) appended after
*
* 3. Parameter Order:
*    ShowMessage(msg1, msg2, ctrl, info)
*               ↑     ↑     ↑     ↑
*               Pre-filled  Event params
*
* 4. Benefits:
*    ✅ Configure behavior at binding time
*    ✅ Reuse same method with different data
*    ✅ Clean, maintainable code
*/
