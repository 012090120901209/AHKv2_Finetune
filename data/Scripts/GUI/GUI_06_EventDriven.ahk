#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Event-Driven GUI Architecture
 * 
 * Demonstrates decoupled component communication using custom event
 * system with publish/subscribe pattern.
 * 
 * Source: AHK_Notes/Snippets/event-driven-gui.md
 */

app := EventDrivenApp()
app.Show()

/**
 * EventBus - Central event system for component communication
 */
class EventBus {
    subscribers := Map()

    /**
     * Subscribe to event
     * @param {string} eventName - Event to listen for
     * @param {func} callback - Function to call when event fires
     */
    Subscribe(eventName, callback) {
        if (!this.subscribers.Has(eventName))
            this.subscribers[eventName] := []

        this.subscribers[eventName].Push(callback)
    }

    /**
     * Unsubscribe from event
     */
    Unsubscribe(eventName, callback) {
        if (!this.subscribers.Has(eventName))
            return

        callbacks := this.subscribers[eventName]
        for index, cb in callbacks {
            if (cb == callback) {
                callbacks.RemoveAt(index)
                break
            }
        }
    }

    /**
     * Publish event to all subscribers
     * @param {string} eventName - Event to trigger
     * @param {any} data - Data to pass to subscribers
     */
    Publish(eventName, data := "") {
        if (!this.subscribers.Has(eventName))
            return

        for callback in this.subscribers[eventName] {
            try {
                callback(data)
            } catch as err {
                MsgBox("Event handler error: " err.Message)
            }
        }
    }
}

/**
 * EventDrivenApp - Main application using event-driven architecture
 */
class EventDrivenApp {
    gui := ""
    bus := EventBus()
    components := Map()

    __New() {
        this.gui := Gui("+Resize", "Event-Driven Architecture Demo")

        ; Create components
        this.components["display"] := TextDisplay(this.gui, this.bus)
        this.components["input"] := TextInput(this.gui, this.bus)
        this.components["controls"] := ControlPanel(this.gui, this.bus)

        ; Controller subscribes to events
        this.bus.Subscribe("text.update", ObjBindMethod(this, "OnTextUpdate"))
        this.bus.Subscribe("clear.all", ObjBindMethod(this, "OnClearAll"))
        this.bus.Subscribe("app.close", ObjBindMethod(this, "OnClose"))
    }

    /**
     * Event handlers
     */
    OnTextUpdate(text) {
        ; Publish to display component
        this.bus.Publish("display.update", "Text: " text)
    }

    OnClearAll(*) {
        this.bus.Publish("display.update", "")
        this.bus.Publish("input.clear")
    }

    OnClose(*) {
        this.gui.Destroy()
    }

    Show() {
        this.gui.Show()
    }
}

/**
 * TextDisplay - Component displaying text
 */
class TextDisplay {
    control := ""

    __New(parentGui, bus) {
        parentGui.Add("Text", "w400", "Display Component")
        this.control := parentGui.Add("Edit", "w400 h100 ReadOnly")

        ; Subscribe to display updates
        bus.Subscribe("display.update", ObjBindMethod(this, "Update"))
    }

    Update(text) {
        this.control.Value := text
    }
}

/**
 * TextInput - Component for text input
 */
class TextInput {
    control := ""
    bus := ""

    __New(parentGui, bus) {
        this.bus := bus

        parentGui.Add("Text", "xm y+20 w400", "Input Component")
        this.control := parentGui.Add("Edit", "w400")
        this.control.OnEvent("Change", ObjBindMethod(this, "OnChange"))

        ; Subscribe to clear events
        bus.Subscribe("input.clear", ObjBindMethod(this, "Clear"))
    }

    OnChange(ctrl, *) {
        ; Publish text update event
        this.bus.Publish("text.update", ctrl.Value)
    }

    Clear(*) {
        this.control.Value := ""
    }
}

/**
 * ControlPanel - Component with action buttons
 */
class ControlPanel {
    bus := ""

    __New(parentGui, bus) {
        this.bus := bus

        parentGui.Add("Text", "xm y+20 w400", "Control Component")

        btn1 := parentGui.Add("Button", "w190", "Clear All")
        btn1.OnEvent("Click", (*) => bus.Publish("clear.all"))

        btn2 := parentGui.Add("Button", "x+20 w190", "Close App")
        btn2.OnEvent("Click", (*) => bus.Publish("app.close"))
    }
}

/*
* Key Concepts:
*
* 1. Event Bus Pattern:
*    Central EventBus class
*    Subscribe(eventName, callback)
*    Publish(eventName, data)
*    Decoupled communication
*
* 2. Component Architecture:
*    Each component is self-contained
*    Components don't know about each other
*    Communicate only through events
*
* 3. Event Naming Convention:
*    "component.action" format
*    "text.update", "display.update"
*    Self-documenting event names
*
* 4. Controller Layer:
*    App class acts as controller
*    Subscribes to events
*    Coordinates component updates
*    Business logic lives here
*
* 5. Data Flow:
*    User interacts with component
*    Component publishes event
*    Controller handles event
*    Controller publishes updates
*    Components receive updates
*
* 6. Benefits:
*    ✅ Loose coupling
*    ✅ Easy to add/remove components
*    ✅ Testable components
*    ✅ Clear event flow
*    ✅ Scalable architecture
*
* 7. Event Types:
*    text.update - Text changed
*    display.update - Update display
*    input.clear - Clear input
*    clear.all - Clear everything
*    app.close - Close application
*
* 8. Use Cases:
*    ✅ Complex GUIs with many components
*    ✅ Plugin architectures
*    ✅ Reactive applications
*    ✅ Multi-component coordination
*/

