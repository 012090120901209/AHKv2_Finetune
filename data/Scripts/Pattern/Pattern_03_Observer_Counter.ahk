#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Observer Pattern - Counter Application
 * 
 * Demonstrates Observer pattern with a practical counter application.
 * Multiple observers (GUI display, logger) react to counter changes.
 * 
 * Source: AHK_Notes/Patterns/observer-pattern.md
 */

; Initialize application
app := CreateCounterApp()

CreateCounterApp() {
    ; Create the subject (observable)
    counter := Counter()

    ; Create a GUI
    myGui := Gui("+Resize", "Observer Pattern Demo")
    myGui.SetFont("s12")

    myGui.Add("Text", "w300 vCounterText", "Counter: 0")
    myGui.Add("Button", "w100 vIncBtn", "Increment").OnEvent("Click", (*) => counter.Increment())
    myGui.Add("Button", "w100 x+10 vDecBtn", "Decrement").OnEvent("Click", (*) => counter.Decrement())
    myGui.Add("Button", "w100 x+10 vResetBtn", "Reset").OnEvent("Click", (*) => counter.Reset())

    ; Create observers
    display := CounterDisplay(myGui, "CounterText")
    logger := CounterLogger()

    ; Register observers with the subject
    counter.Subscribe(display)
        .Subscribe(logger)

    ; Show the GUI
    myGui.Show("w340 h100")

    return { Counter: counter, Gui: myGui }
}

/**
 * Observable Base Class
 */
class Observable {
    Observers := []

    Subscribe(observer) {
        this.Observers.Push(observer)
        return this
    }

    Unsubscribe(observer) {
        for i, registeredObserver in this.Observers {
            if (registeredObserver == observer) {
                this.Observers.RemoveAt(i)
                break
            }
        }
        return this
    }

    Notify(data := "") {
        for i, observer in this.Observers {
            observer.Update(data)
        }
    }
}

/**
 * Counter Subject
 * Extends Observable to notify observers of value changes
 */
class Counter extends Observable {
    Value := 0

    Increment() {
        this.Value++
        this.Notify(this.Value)  ; Notify all observers
        return this
    }

    Decrement() {
        this.Value--
        this.Notify(this.Value)  ; Notify all observers
        return this
    }

    Reset() {
        this.Value := 0
        this.Notify(this.Value)  ; Notify all observers
        return this
    }
}

/**
 * Observer Base Class
 */
class Observer {
    Update(data) {
        ; Abstract method
    }
}

/**
 * GUI Display Observer
 * Updates GUI when counter changes
 */
class CounterDisplay extends Observer {
    Gui := ""
    ControlID := ""

    __New(gui, controlID) {
        this.Gui := gui
        this.ControlID := controlID
    }

    Update(newValue) {
        this.Gui[this.ControlID].Value := "Counter: " newValue
    }
}

/**
 * Logger Observer
 * Logs counter changes to debug output
 */
class CounterLogger extends Observer {
    Update(newValue) {
        OutputDebug("Counter changed to: " newValue)
        ; Also show in tooltip for demonstration
        ToolTip("Logged: Counter = " newValue)
        SetTimer(() => ToolTip(), -1000)
    }
}

/*
* Key Concepts:
*
* 1. Multiple Observers:
*    - CounterDisplay: Updates GUI
*    - CounterLogger: Logs to output
*    - Both react to same event independently
*
* 2. Automatic Updates:
*    - Counter changes → All observers notified automatically
*    - No manual coordination needed
*
* 3. Easy Extension:
*    - Add new observers without modifying Counter class
*    - Example: Add EmailNotifier, DatabaseLogger, etc.
*
* 4. Practical Benefits:
*    - GUI stays in sync with data automatically
*    - Logging happens transparently
*    - Easy to add features (metrics, alerts, etc.)
*/

