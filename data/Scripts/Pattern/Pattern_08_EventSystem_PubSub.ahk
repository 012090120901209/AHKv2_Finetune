#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Event System - Pub/Sub Pattern
 * 
 * Demonstrates a static EventSystem for decoupled event handling.
 * Components publish events, subscribers react without direct coupling.
 * 
 * Source: AHK_Notes/Snippets/event-driven-gui.md
 */

; Subscribe to events
EventSystem.Subscribe("user.login", OnUserLogin)
EventSystem.Subscribe("user.login", LogEvent)
EventSystem.Subscribe("data.changed", OnDataChanged)

; Publish events
MsgBox("Publishing user.login event...", , "T2")
EventSystem.Publish("user.login", "john_doe", "192.168.1.1")

Sleep(1000)

MsgBox("Publishing data.changed event...", , "T2")
EventSystem.Publish("data.changed", "config", { theme: "dark", fontSize: 12 })

/**
 * EventSystem Class
 * Static pub/sub implementation for loose coupling
 */
class EventSystem {
    static Subscribers := Map()

    /**
     * Subscribe to an event
     * @param {string} eventName - Event to subscribe to
     * @param {func} callback - Function to call when event fires
     */
    static Subscribe(eventName, callback) {
        if (!this.Subscribers.Has(eventName))
            this.Subscribers[eventName] := []
        this.Subscribers[eventName].Push(callback)
        return true
    }

    /**
     * Publish an event
     * @param {string} eventName - Event to publish
     * @param {any} params - Parameters to pass to subscribers
     */
    static Publish(eventName, params*) {
        if (!this.Subscribers.Has(eventName))
            return false
        for callback in this.Subscribers[eventName]
            callback(params*)
        return true
    }

    /**
     * Unsubscribe from an event
     */
    static Unsubscribe(eventName, callback) {
        if (!this.Subscribers.Has(eventName))
            return false
        for i, cb in this.Subscribers[eventName] {
            if (cb = callback) {
                this.Subscribers[eventName].RemoveAt(i)
                return true
            }
        }
        return false
    }
}

/**
 * Event Handlers
 */
OnUserLogin(username, ip) {
    MsgBox("User logged in:`n`nUsername: " username "`nIP: " ip, , "T2")
}

LogEvent(params*) {
    msg := "Event logged: "
    for param in params
        msg .= param " "
    ToolTip(msg)
    SetTimer(() => ToolTip(), -2000)
}

OnDataChanged(key, value) {
    MsgBox("Data changed:`n`nKey: " key "`nValue: " Type(value), , "T2")
}

/*
* Key Concepts:
*
* 1. Pub/Sub Pattern:
*    - Publishers don't know subscribers
*    - Subscribers don't know publishers
*    - EventSystem mediates all communication
*
* 2. Benefits:
*    ✅ Loose coupling
*    ✅ Easy to add/remove listeners
*    ✅ No circular dependencies
*    ✅ Testable components
*
* 3. Use Cases:
*    - GUI events
*    - State changes
*    - User actions
*    - Data updates
*/

