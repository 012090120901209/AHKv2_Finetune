#Requires AutoHotkey v2.1-alpha.17
/**
 * Practical Module Example 04: Using Event System
 *
 * Demonstrates event-driven programming patterns
 *
 * USAGE: Run this file directly
 *
 * @requires Module_Practical_03_EventSystem.ahk
 */

#SingleInstance Force

Import {
    EventEmitter,
    EventBus,
    CreateEventEmitter,
    EventMiddleware,
    TypedEvents,
    EventQueue
} from EventSystem

; ============================================================
; Example 1: Basic Event Emitter
; ============================================================

emitter := CreateEventEmitter()

; Register event listeners
emitter.On("hello", (name) => MsgBox("Hello, " name "!"))
emitter.On("hello", (name) => ToolTip("Greeted " name))

; Emit event
emitter.Emit("hello", "World")
Sleep(1000)
ToolTip()

; ============================================================
; Example 2: Multiple Listeners
; ============================================================

counter := 0

incrementer := CreateEventEmitter()

; Add multiple listeners
incrementer.On("increment", (*) => {
    global counter
    counter++
})

incrementer.On("increment", (*) => {
    global counter
    OutputDebug("Counter incremented to: " counter)
})

incrementer.On("increment", (*) => {
    global counter
    if Mod(counter, 5) = 0
        ToolTip("Reached " counter "!")
})

; Emit multiple times
Loop 10 {
    incrementer.Emit("increment")
    Sleep(100)
}

ToolTip()
MsgBox("Final counter value: " counter, "Multiple Listeners", "Icon!")

; ============================================================
; Example 3: Once Listener (One-time event)
; ============================================================

notifier := CreateEventEmitter()

; This will only fire once
notifier.Once("startup", (*) => {
    MsgBox("Application started (this shows once)", "Startup", "Icon!")
})

; Regular listener fires every time
notifier.On("startup", (*) => {
    OutputDebug("Startup event fired")
})

; Emit three times
notifier.Emit("startup")  ; Shows MsgBox
notifier.Emit("startup")  ; No MsgBox
notifier.Emit("startup")  ; No MsgBox

; ============================================================
; Example 4: Removing Listeners
; ============================================================

logger := CreateEventEmitter()

; Define named handler so we can remove it
logHandler := (message) => OutputDebug("LOG: " message)

logger.On("log", logHandler)
logger.On("log", (msg) => ToolTip("Log: " msg))

; Emit with both listeners
logger.Emit("log", "First message")
Sleep(500)

; Remove first handler
logger.Off("log", logHandler)

; Emit with only second listener
logger.Emit("log", "Second message")
Sleep(500)
ToolTip()

; ============================================================
; Example 5: Global Event Bus
; ============================================================

; Module A publishes events
class ModuleA {
    static DoSomething() {
        OutputDebug("Module A: Doing something...")
        EventBus.Emit("moduleA:action", "Task completed")
    }
}

; Module B subscribes to events
class ModuleB {
    static Initialize() {
        EventBus.On("moduleA:action", (msg) => {
            MsgBox("Module B received: " msg, "Event Bus", "Icon!")
        })
    }
}

; Set up and trigger
ModuleB.Initialize()
ModuleA.DoSomething()

; ============================================================
; Example 6: Event Data Object
; ============================================================

userEvents := CreateEventEmitter()

userEvents.On("user:login", (userData) => {
    msg := "User logged in:`n`n"
    msg .= "Name: " userData.name "`n"
    msg .= "Email: " userData.email "`n"
    msg .= "Time: " userData.timestamp
    MsgBox(msg, "User Login Event", "Icon!")
})

userEvents.Emit("user:login", {
    name: "John Doe",
    email: "john@example.com",
    timestamp: FormatTime(, "yyyy-MM-dd HH:mm:ss")
})

; ============================================================
; Example 7: Event Middleware
; ============================================================

middleware := EventMiddleware()

; Add logging middleware
middleware.Use((event, args, next) => {
    OutputDebug("BEFORE: " event)
    next()
    OutputDebug("AFTER: " event)
})

; Add timestamp middleware
middleware.Use((event, args, next) => {
    timestamp := FormatTime(, "HH:mm:ss")
    ; Modify args to include timestamp
    args.Push(timestamp)
    next()
})

; Add listener
middleware.On("action", (data, timestamp) => {
    MsgBox("Action: " data "`nTime: " timestamp, "Middleware Event", "Icon!")
})

; Emit through middleware
middleware.Emit("action", "Test action")

; ============================================================
; Example 8: Typed Events
; ============================================================

typed := TypedEvents()

; Define event type with validator
typed.DefineEvent("user:created", (userData) => {
    ; Validate required fields
    return (
        IsObject(userData) &&
        ObjHasOwnProp(userData, "name") &&
        ObjHasOwnProp(userData, "email") &&
        userData.name != "" &&
        userData.email != ""
    )
})

; Add listener
typed.On("user:created", (user) => {
    MsgBox("Created user: " user.name, "Typed Event", "Icon!")
})

; Valid event - works
try {
    typed.Emit("user:created", {name: "Alice", email: "alice@example.com"})
} catch as err {
    MsgBox("Error: " err.Message)
}

; Invalid event - throws error
try {
    typed.Emit("user:created", {name: ""})  ; Missing email
} catch as err {
    MsgBox("Validation failed (expected):`n" err.Message, "Type Validation", "Icon!")
}

; ============================================================
; Example 9: Event Queue (Batched Processing)
; ============================================================

queue := EventQueue()
batchEmitter := CreateEventEmitter()

; Set up listener
messages := []
batchEmitter.On("message", (msg) => {
    global messages
    messages.Push(msg)
})

; Queue events (don't process immediately)
queue.Enqueue("message", "First")
queue.Enqueue("message", "Second")
queue.Enqueue("message", "Third")

MsgBox("Queued " queue.Size() " events", "Event Queue", "Icon!")

; Process all queued events
queue.Process(batchEmitter)

output := "Processed messages:`n`n"
for msg in messages
    output .= "• " msg "`n"
MsgBox(output, "Batch Processing", "Icon!")

; ============================================================
; Example 10: Real-World Application Events
; ============================================================

class Application {
    events := ""

    __New() {
        this.events := CreateEventEmitter()
        this.SetupEventListeners()
    }

    SetupEventListeners() {
        ; Application lifecycle events
        this.events.On("app:start", (*) => {
            OutputDebug("Application started")
        })

        this.events.On("app:stop", (*) => {
            OutputDebug("Application stopped")
        })

        ; User events
        this.events.On("user:action", (action) => {
            OutputDebug("User action: " action)
        })

        ; Error events
        this.events.On("error", (err) => {
            MsgBox("Error occurred: " err.message, "Application Error", "Icon!")
        })
    }

    Start() {
        this.events.Emit("app:start")
    }

    Stop() {
        this.events.Emit("app:stop")
    }

    HandleUserAction(action) {
        this.events.Emit("user:action", action)
    }

    HandleError(err) {
        this.events.Emit("error", err)
    }
}

app := Application()
app.Start()
app.HandleUserAction("clicked button")
app.HandleError({message: "Test error", code: 500})
app.Stop()

; ============================================================
; Summary
; ============================================================

summary := "
(
EVENT SYSTEM MODULE USAGE:

1. BASIC EVENTS
   emitter := CreateEventEmitter()
   emitter.On(event, handler)
   emitter.Emit(event, args*)

2. ONE-TIME EVENTS
   emitter.Once(event, handler)

3. REMOVE LISTENERS
   emitter.Off(event, handler)
   emitter.RemoveAllListeners(event)

4. GLOBAL EVENT BUS
   EventBus.On(event, handler)
   EventBus.Emit(event, args*)

5. EVENT MIDDLEWARE
   middleware := EventMiddleware()
   middleware.Use(middlewareFunc)

6. TYPED EVENTS
   typed := TypedEvents()
   typed.DefineEvent(event, validator)

7. EVENT QUEUE
   queue := EventQueue()
   queue.Enqueue(event, args*)
   queue.Process(emitter)

BENEFITS:
✓ Decoupled architecture
✓ Flexible communication
✓ Easy to extend
✓ Clean separation of concerns
✓ Testable components
)"

MsgBox(summary, "Event System Summary", "Icon!")
