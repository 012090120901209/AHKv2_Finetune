#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * EventEmitter Pattern
 * 
 * Demonstrates implementing an EventEmitter base class for event-driven
 * programming with on(), once(), off(), and emit() methods.
 * 
 * Source: AHK_Notes/Classes/event-emitter.md
 */

; Test basic event emitter
emitter := EventEmitter()

; Register persistent listener
emitter.on("greet", (name) => MsgBox("Hello, " name "!", , "T2"))

; Register one-time listener
emitter.once("welcome", (name) => MsgBox("Welcome, " name "! (once)", , "T2"))

; Emit events
emitter.emit("greet", "Alice")
emitter.emit("welcome", "Bob")
emitter.emit("welcome", "Charlie")  ; Won't trigger (already fired once)
emitter.emit("greet", "David")

; Test FileReader with EventEmitter
MsgBox("FileReader Test - Creating test file...", , "T2")

; Create test file
testFile := "test_data.txt"
FileDelete(testFile)
FileAppend("Line 1`nLine 2`nLine 3", testFile)

; Use FileReader with event handlers
reader := FileReader()

reader.on("data", (line) => ToolTip("Data: " line))
    .on("end", (*) => MsgBox("File reading complete!", , "T3"))
    .on("error", (err) => MsgBox("Error: " err, , "T3"))

MsgBox("Reading file with events...", , "T2")
reader.ReadFile(testFile)

Sleep(2000)
ToolTip()
FileDelete(testFile)

/**
 * EventEmitter - Base class for event-driven objects
 */
class EventEmitter {
    _events := Map()

    /**
     * Register event listener
     * @param {string} eventName - Event to listen for
     * @param {func} callback - Function to call
     * @return {EventEmitter} this (for chaining)
     */
    on(eventName, callback) {
        if (!this._events.Has(eventName))
            this._events[eventName] := []

        this._events[eventName].Push({
            callback: callback,
            once: false
        })

        return this  ; Enable chaining
    }

    /**
     * Register one-time event listener
     * @param {string} eventName - Event to listen for
     * @param {func} callback - Function to call once
     * @return {EventEmitter} this (for chaining)
     */
    once(eventName, callback) {
        if (!this._events.Has(eventName))
            this._events[eventName] := []

        this._events[eventName].Push({
            callback: callback,
            once: true
        })

        return this
    }

    /**
     * Remove event listener(s)
     * @param {string} eventName - Event name
     * @param {func} callback - Specific callback to remove (optional)
     */
    off(eventName, callback := "") {
        if (!this._events.Has(eventName))
            return

        if (callback == "") {
            ; Remove all listeners for this event
            this._events.Delete(eventName)
        } else {
            ; Remove specific listener
            listeners := this._events[eventName]
            for index, listener in listeners {
                if (listener.callback == callback) {
                    listeners.RemoveAt(index)
                    break
                }
            }
        }
    }

    /**
     * Emit event to all listeners
     * @param {string} eventName - Event to emit
     * @param {any} args* - Arguments to pass to listeners
     */
    emit(eventName, args*) {
        if (!this._events.Has(eventName))
            return

        listeners := this._events[eventName]
        toRemove := []

        ; Call each listener
        for index, listener in listeners {
            try {
                listener.callback(args*)

                ; Mark once listeners for removal
                if (listener.once)
                    toRemove.Push(index)

            } catch as err {
                ; Handle errors without stopping other listeners
                MsgBox("Event handler error: " err.Message)
            }
        }

        ; Remove once listeners (in reverse order to maintain indices)
        Loop toRemove.Length {
            listeners.RemoveAt(toRemove[toRemove.Length - A_Index + 1])
        }
    }

    /**
     * Remove all listeners
     */
    removeAllListeners() {
        this._events := Map()
    }
}

/**
 * FileReader - Example class using EventEmitter
 */
class FileReader extends EventEmitter {
    /**
     * Read file and emit events
     */
    ReadFile(filePath) {
        try {
            if (!FileExist(filePath)) {
                this.emit("error", "File not found: " filePath)
                return
            }

            ; Read file line by line
            Loop Read, filePath {
                this.emit("data", A_LoopReadLine)
                Sleep(500)  ; Simulate async reading
            }

            this.emit("end")

        } catch as err {
            this.emit("error", err.Message)
        }
    }
}

/*
* Key Concepts:
*
* 1. EventEmitter Methods:
*    on(event, callback)      ; Register persistent listener
*    once(event, callback)    ; Register one-time listener
*    off(event, callback?)    ; Remove listener(s)
*    emit(event, args*)       ; Trigger event
*
* 2. Method Chaining:
*    emitter.on("data", handler)
*           .on("end", handler)
*           .on("error", handler)
*    Return 'this' to enable chaining
*
* 3. Listener Storage:
*    _events := Map()  ; eventName => Array of listeners
*    Each listener: {callback: func, once: bool}
*
* 4. Once Listeners:
*    Execute only once
*    Automatically removed after firing
*    Track with 'once' flag
*
* 5. Error Handling:
*    try/catch around each listener
*    One listener error doesn't stop others
*    Emit "error" events for problems
*
* 6. Inheritance Pattern:
*    class MyClass extends EventEmitter {
    *        ; Your class can now emit events
    *    }
    *
    * 7. Common Events:
    *    "data" - Data received
    *    "end" - Process complete
    *    "error" - Error occurred
    *    "change" - State changed
    *
    * 8. Use Cases:
    *    ✅ Async operations (file I/O, network)
    *    ✅ User interface events
    *    ✅ Data streams
    *    ✅ State change notifications
    *    ✅ Plugin systems
    *
    * 9. Memory Management:
    *    ⚠ Listeners create references
    *    ⚠ Can prevent garbage collection
    *    ✅ Call off() to remove listeners
    *    ✅ Use removeAllListeners() for cleanup
    *
    * 10. Benefits:
    *     ✅ Decoupled code
    *     ✅ Multiple handlers per event
    *     ✅ Easy to add/remove listeners
    *     ✅ Clean async patterns
*/

