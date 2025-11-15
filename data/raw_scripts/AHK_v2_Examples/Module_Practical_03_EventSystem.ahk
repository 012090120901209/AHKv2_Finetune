#Requires AutoHotkey v2.1-alpha.17
/**
 * Practical Module Example 03: Event System Module
 *
 * This demonstrates a real-world event emitter system for:
 * - Event-driven architecture
 * - Observer pattern
 * - Pub/sub messaging
 * - Decoupled components
 *
 * @module EventSystem
 */

#Module EventSystem

/**
 * Event Emitter class
 * Implements observer pattern for event-driven programming
 *
 * @class EventEmitter
 * @export
 */
Export class EventEmitter {
    listeners := Map()

    /**
     * Register event listener
     * @param event {String} - Event name
     * @param handler {Func} - Callback function
     * @returns {EventEmitter} - this (for chaining)
     */
    On(event, handler) {
        if !this.listeners.Has(event)
            this.listeners[event] := []

        this.listeners[event].Push(handler)
        return this
    }

    /**
     * Register one-time event listener
     * Handler is automatically removed after first call
     *
     * @param event {String} - Event name
     * @param handler {Func} - Callback function
     * @returns {EventEmitter} - this (for chaining)
     */
    Once(event, handler) {
        ; Wrap handler to remove itself after execution
        wrapper := (args*) => {
            handler(args*)
            this.Off(event, wrapper)
        }

        return this.On(event, wrapper)
    }

    /**
     * Remove event listener
     * @param event {String} - Event name
     * @param handler {Func} - Handler to remove
     * @returns {EventEmitter} - this (for chaining)
     */
    Off(event, handler) {
        if !this.listeners.Has(event)
            return this

        handlers := this.listeners[event]
        newHandlers := []

        for h in handlers {
            if h != handler
                newHandlers.Push(h)
        }

        this.listeners[event] := newHandlers
        return this
    }

    /**
     * Remove all listeners for event
     * @param event {String} - Event name (optional)
     * @returns {EventEmitter} - this (for chaining)
     */
    RemoveAllListeners(event := "") {
        if event = "" {
            this.listeners := Map()
        } else if this.listeners.Has(event) {
            this.listeners.Delete(event)
        }
        return this
    }

    /**
     * Emit event to all listeners
     * @param event {String} - Event name
     * @param args* {Any} - Arguments to pass to handlers
     * @returns {EventEmitter} - this (for chaining)
     */
    Emit(event, args*) {
        if !this.listeners.Has(event)
            return this

        ; Clone handlers array in case listener modifies it
        handlers := this.listeners[event].Clone()

        for handler in handlers
            handler(args*)

        return this
    }

    /**
     * Get listener count for event
     * @param event {String} - Event name
     * @returns {Number} - Number of listeners
     */
    ListenerCount(event) {
        if !this.listeners.Has(event)
            return 0
        return this.listeners[event].Length
    }

    /**
     * Get all event names
     * @returns {Array} - Array of event names
     */
    EventNames() {
        names := []
        for event in this.listeners
            names.Push(event)
        return names
    }
}

/**
 * Global event bus singleton
 * Shared event emitter for application-wide events
 *
 * @export
 */
Export EventBus := EventEmitter()

/**
 * Create new event emitter instance
 * @returns {EventEmitter} - New emitter
 * @export
 */
Export CreateEventEmitter() {
    return EventEmitter()
}

/**
 * Event middleware class
 * Allows transformation/filtering of events
 *
 * @class EventMiddleware
 * @export
 */
Export class EventMiddleware extends EventEmitter {
    middlewares := []

    /**
     * Add middleware function
     * Middleware receives (event, args, next)
     *
     * @param fn {Func} - Middleware function
     * @returns {EventMiddleware} - this
     */
    Use(fn) {
        this.middlewares.Push(fn)
        return this
    }

    /**
     * Emit event through middleware chain
     * @param event {String} - Event name
     * @param args* {Any} - Event arguments
     * @returns {EventMiddleware} - this
     */
    Emit(event, args*) {
        this.RunMiddleware(event, args, 1)
        return this
    }

    /**
     * Run middleware chain
     * @param event {String} - Event name
     * @param args {Array} - Arguments
     * @param index {Number} - Current middleware index
     * @private
     */
    RunMiddleware(event, args, index) {
        if index > this.middlewares.Length {
            ; All middleware done, emit to listeners
            super.Emit(event, args*)
            return
        }

        middleware := this.middlewares[index]

        ; Create next function
        next := (*) => this.RunMiddleware(event, args, index + 1)

        ; Call middleware
        middleware(event, args, next)
    }
}

/**
 * Typed event system
 * Ensures type safety for event payloads
 *
 * @class TypedEvents
 * @export
 */
Export class TypedEvents extends EventEmitter {
    eventTypes := Map()

    /**
     * Define event type with validator
     * @param event {String} - Event name
     * @param validator {Func} - Validation function
     */
    DefineEvent(event, validator) {
        this.eventTypes[event] := validator
    }

    /**
     * Emit typed event
     * @param event {String} - Event name
     * @param args* {Any} - Event arguments
     */
    Emit(event, args*) {
        if this.eventTypes.Has(event) {
            validator := this.eventTypes[event]
            if !validator(args*) {
                throw Error("Event '" event "' validation failed")
            }
        }

        return super.Emit(event, args*)
    }
}

/**
 * Event queue for deferred/batched processing
 *
 * @class EventQueue
 * @export
 */
Export class EventQueue {
    queue := []
    processing := false

    /**
     * Add event to queue
     * @param event {String} - Event name
     * @param args* {Any} - Event arguments
     */
    Enqueue(event, args*) {
        this.queue.Push({event: event, args: args})
    }

    /**
     * Process all queued events
     * @param emitter {EventEmitter} - Emitter to use
     */
    Process(emitter) {
        if this.processing
            return

        this.processing := true

        while this.queue.Length > 0 {
            item := this.queue.RemoveAt(1)
            emitter.Emit(item.event, item.args*)
        }

        this.processing := false
    }

    /**
     * Clear queue without processing
     */
    Clear() {
        this.queue := []
    }

    /**
     * Get queue size
     * @returns {Number} - Number of queued events
     */
    Size() {
        return this.queue.Length
    }
}
