#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Advanced Callback Patterns
 * 
 * Demonstrates different callback types: traditional functions,
 * bound methods, arrow functions, and error handling.
 * 
 * Source: AHK_Notes/Concepts/callback-functions.md
 */

; Test 1: Traditional function callback
MsgBox("Test 1: Traditional Function Callback", , "T2")
ExecuteWithCallback(TraditionalCallback, "Hello")

; Test 2: Bound method callback
MsgBox("Test 2: Bound Method Callback", , "T2")
obj := CallbackDemo()
obj.TestBoundMethod()

; Test 3: Arrow function callback
MsgBox("Test 3: Arrow Function Callback", , "T2")
ExecuteWithCallback((msg) => MsgBox("Arrow: " msg), "World")

; Test 4: Custom event system
MsgBox("Test 4: Event System with Multiple Callbacks", , "T2")
eventSys := CustomEventSystem()
eventSys.Demo()

/**
 * Execute function with callback
 */
ExecuteWithCallback(callback, data) {
    try {
        callback(data)
    } catch as err {
        MsgBox("Callback error: " err.Message)
    }
}

/**
 * Traditional callback function
 */
TraditionalCallback(msg) {
    MsgBox("Traditional: " msg, , "T2")
}

/**
 * CallbackDemo - Class demonstrating method callbacks
 */
class CallbackDemo {
    name := "Demo Object"

    /**
     * Test bound method as callback
     * ObjBindMethod preserves 'this' context
     */
    TestBoundMethod() {
        ; Without ObjBindMethod, 'this' would be undefined
        boundMethod := ObjBindMethod(this, "HandleCallback")

        ; Simulate delayed callback (like timer or GUI event)
        SetTimer(boundMethod, -1000)
    }

    HandleCallback() {
        MsgBox("Bound method callback from: " this.name, , "T2")
    }
}

/**
 * CustomEventSystem - Pub/Sub with multiple callbacks
 */
class CustomEventSystem {
    events := Map()

    /**
     * Subscribe callback to event
     */
    Subscribe(eventName, callback) {
        if (!this.events.Has(eventName))
            this.events[eventName] := []

        this.events[eventName].Push(callback)
    }

    /**
     * Unsubscribe callback from event
     */
    Unsubscribe(eventName, callback) {
        if (!this.events.Has(eventName))
            return

        callbacks := this.events[eventName]
        for index, cb in callbacks {
            if (cb == callback) {
                callbacks.RemoveAt(index)
                break
            }
        }
    }

    /**
     * Trigger event, calling all subscribed callbacks
     */
    Trigger(eventName, data := "") {
        if (!this.events.Has(eventName))
            return

        errors := []
        for callback in this.events[eventName] {
            try {
                callback(data)
            } catch as err {
                errors.Push(err.Message)
            }
        }

        if (errors.Length > 0)
            MsgBox("Callback errors: " errors.Join("`n"))
    }

    /**
     * Demonstration of event system
     */
    Demo() {
        ; Subscribe multiple callbacks to same event
        this.Subscribe("userLogin", (data) => MsgBox("Logger: User " data " logged in", , "T2"))
        this.Subscribe("userLogin", (data) => MsgBox("Analytics: Track login for " data, , "T2"))
        this.Subscribe("userLogin", (data) => MsgBox("Notifier: Send welcome to " data, , "T2"))

        ; Trigger event - all callbacks execute
        Sleep(500)
        this.Trigger("userLogin", "Alice")
    }
}

/*
* Key Concepts:
*
* 1. Callback Types:
*    - Traditional functions: FunctionName
*    - Bound methods: ObjBindMethod(obj, "Method")
*    - Arrow functions: (params) => expression
*    - Function objects: {Call: (params) => ...}
*
* 2. Context Preservation:
*    Method callbacks need ObjBindMethod
*    Arrow functions have lexical 'this'
*    Traditional functions have no context
*
* 3. Error Handling:
*    try/catch around callback execution
*    Errors in callbacks hard to trace
*    Collect and report errors
*
* 4. Event System Pattern:
*    Subscribe(event, callback)
*    Trigger(event, data)
*    Multiple callbacks per event
*
* 5. Common Uses:
*    ✅ GUI event handlers
*    ✅ Timer callbacks
*    ✅ Async operations
*    ✅ Custom event systems
*
* 6. Performance Notes:
*    ⚠ Arrow functions create new objects
*    ⚠ ObjBindMethod has overhead
*    ✅ Direct function refs fastest
*/

