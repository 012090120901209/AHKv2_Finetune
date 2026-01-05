#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * MVC Pattern - Basic Structure
 * 
 * Demonstrates the Model-View-Controller design pattern,
 * which separates data (Model), presentation (View), and logic (Controller).
 * 
 * Source: AHK_Notes/Patterns/MVC_Pattern.md
 */

; Initialize the application
MyMVCApp := MVCExampleApp()

class MVCExampleApp {
    /**
     * Application entry point
     * Creates Model, View, and Controller components
     */
    __New() {
        this.model := MVCModel()
        this.view := MVCView()
        this.controller := MVCController(this.model, this.view)
        this.view.Show()
    }
}

class MVCModel {
    /**
     * Model component - manages data
     * Stores application state and business logic
     */
    __New() {
        this.data := Map("count", 0)
    }

    IncrementCount() {
        this.data["count"]++
        return this.data["count"]
    }

    GetCount() {
        return this.data["count"]
    }
}

class MVCView {
    /**
     * View component - manages UI presentation
     * Handles display logic only, no business logic
     */
    __New() {
        this.gui := Gui("+Resize", "MVC Example")
        this.gui.SetFont("s10")
        this.counterText := this.gui.AddText("w200 h30", "Count: 0")
        this.incrementButton := this.gui.AddButton("w200", "Increment")
        this.onIncrementHandler := ""
    }

    UpdateCounter(count) {
        this.counterText.Value := "Count: " count
    }

    SetIncrementHandler(handler) {
        this.onIncrementHandler := handler
        this.incrementButton.OnEvent("Click", this.onIncrementHandler)
    }

    Show() {
        this.gui.Show()
    }
}

class MVCController {
    /**
     * Controller component - mediates between Model and View
     * Handles user input and updates Model/View accordingly
     */
    __New(model, view) {
        this.model := model
        this.view := view

        ; Bind controller method to view event
        this.view.SetIncrementHandler(this.HandleIncrement.Bind(this))
    }

    HandleIncrement(*) {
        ; Update model (business logic)
        newCount := this.model.IncrementCount()

        ; Update view (presentation)
        this.view.UpdateCounter(newCount)
    }
}

/*
* Key Concepts:
*
* 1. Separation of Concerns:
*    - Model: Data and business logic
*    - View: UI presentation
*    - Controller: Orchestration and event handling
*
* 2. Benefits:
*    - Testable: Each component can be tested independently
*    - Maintainable: Changes to one component don't affect others
*    - Reusable: Components can be reused in different contexts
*
* 3. Flow:
*    User clicks button → View triggers event → Controller handles event
*    → Controller updates Model → Controller updates View
*/

