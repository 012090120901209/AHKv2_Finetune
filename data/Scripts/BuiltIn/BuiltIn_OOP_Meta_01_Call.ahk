#Requires AutoHotkey v2.0

/**
 * BuiltIn_OOP_Meta_01_Call.ahk
 * 
 * DESCRIPTION:
 * Demonstrates the __Call meta-function in AutoHotkey v2. __Call is invoked when
 * an undefined method is called on an object, enabling dynamic method handling,
 * method forwarding, and flexible API patterns.
 * 
 * FEATURES:
 * - __Call meta-function basics
 * - Dynamic method handling
 * - Method forwarding
 * - Fluent interface implementation
 * - Method name pattern matching
 * - Default method behavior
 * - Call logging and debugging
 * 
 * SOURCE:
 * AutoHotkey v2 Documentation - Objects
 * 
 * KEY V2 FEATURES DEMONSTRATED:
 * - __Call(name, params) signature
 * - Accessing method name via parameter
 * - Variadic params array
 * - Method existence checking
 * - Dynamic dispatch patterns
 * - Meta-function inheritance
 * 
 * LEARNING POINTS:
 * 1. __Call catches undefined method calls
 * 2. First parameter is the method name
 * 3. Remaining parameters are method arguments
 * 4. Enables dynamic method creation
 * 5. Useful for proxy and wrapper patterns
 * 6. Can forward calls to other objects
 * 7. Allows flexible DSL-like syntax
 */

; ========================================
; EXAMPLE 1: Basic __Call Usage
; ========================================
; Understanding how __Call intercepts undefined methods

class MethodLogger {
    CallHistory := []

    __Call(name, params) {
        ; Log the method call
        call := {
            Method: name,
            Params: params,
            Time: A_Now
        }

        this.CallHistory.Push(call)

        ; Return information about the call
        paramStr := ""
        for param in params {
            paramStr .= param
            if (A_Index < params.Length)
                paramStr .= ", "
        }

        return "Called " name "(" paramStr ")"
    }

    GetHistory() {
        history := "=== Call History ===`n`n"

        for index, call in this.CallHistory {
            paramList := ""
            for param in call.Params {
                paramList .= param
                if (A_Index < call.Params.Length)
                    paramList .= ", "
            }

            history .= index ". " call.Method "(" paramList ")`n"
            history .= "   Time: " FormatTime(call.Time, "HH:mm:ss") "`n`n"
        }

        return history
    }

    ClearHistory() {
        this.CallHistory := []
    }
}

; Create logger
logger := MethodLogger()

; Call undefined methods - all caught by __Call
MsgBox(logger.DoSomething("hello", 123))
MsgBox(logger.ProcessData("data", "more data"))
MsgBox(logger.Calculate(10, 20, 30))
MsgBox(logger.Whatever())

; Show history
MsgBox(logger.GetHistory())

; ========================================
; EXAMPLE 2: Method Forwarding Pattern
; ========================================
; Forwarding method calls to wrapped objects

class DatabaseProxy {
    _connection := ""
    _queryCount := 0

    __New(connection) {
        this._connection := connection
    }

    __Call(name, params) {
        ; Log the query
        this._queryCount++

        ; Forward to actual connection
        if (this._connection.HasOwnProp(name)) {
            result := this._connection.%name%(params*)
            return "Query #" this._queryCount ": " result
        }

        throw Error("Method '" name "' not found on connection")
    }

    GetQueryCount() {
        return this._queryCount
    }
}

class MockDatabase {
    Query(sql) {
        return "Executing: " sql
    }

    Insert(table, data) {
        return "Inserting into " table ": " data
    }

    Update(table, data, where) {
        return "Updating " table " SET " data " WHERE " where
    }

    Delete(table, where) {
        return "Deleting from " table " WHERE " where
    }
}

; Create proxy
db := MockDatabase()
proxy := DatabaseProxy(db)

; Calls are forwarded and logged
MsgBox(proxy.Query("SELECT * FROM users"))
MsgBox(proxy.Insert("users", "name='John'"))
MsgBox(proxy.Update("users", "age=30", "id=1"))
MsgBox(proxy.Delete("users", "id=5"))

MsgBox("Total queries: " proxy.GetQueryCount())

; ========================================
; EXAMPLE 3: Fluent Interface Builder
; ========================================
; Building fluent APIs with __Call

class QueryBuilder {
    _query := Map()
    _type := ""

    __Call(name, params) {
        ; Handle method name patterns
        if (name = "select") {
            this._type := "SELECT"
            this._query["fields"] := params.Length > 0 ? params : ["*"]
            return this
        }
        else if (name = "from") {
            this._query["table"] := params[1]
            return this
        }
        else if (name = "where") {
            if (!this._query.Has("where"))
                this._query["where"] := []
            this._query["where"].Push(params[1])
            return this
        }
        else if (name = "orderBy") {
            this._query["order"] := params[1]
            return this
        }
        else if (name = "limit") {
            this._query["limit"] := params[1]
            return this
        }
        else if (name = "build") {
            return this._BuildQuery()
        }

        throw Error("Unknown method: " name)
    }

    _BuildQuery() {
        if (this._type = "SELECT") {
            query := "SELECT "

            ; Fields
            if (this._query.Has("fields")) {
                fields := ""
                for field in this._query["fields"] {
                    fields .= field
                    if (A_Index < this._query["fields"].Length)
                        fields .= ", "
                }
                query .= fields
            }

            ; Table
            if (this._query.Has("table"))
                query .= " FROM " this._query["table"]

            ; Where
            if (this._query.Has("where")) {
                query .= " WHERE "
                for index, condition in this._query["where"] {
                    query .= condition
                    if (A_Index < this._query["where"].Length)
                        query .= " AND "
                }
            }

            ; Order
            if (this._query.Has("order"))
                query .= " ORDER BY " this._query["order"]

            ; Limit
            if (this._query.Has("limit"))
                query .= " LIMIT " this._query["limit"]

            return query
        }

        return ""
    }
}

; Build queries fluently
qb := QueryBuilder()
query := qb.select("id", "name", "email")
    .from("users")
    .where("age > 18")
    .where("active = 1")
    .orderBy("name ASC")
    .limit(10)
    .build()

MsgBox("Generated Query:`n" query)

; Another query
qb2 := QueryBuilder()
query2 := qb2.select()
    .from("products")
    .where("price < 100")
    .build()

MsgBox("Generated Query:`n" query2)

; ========================================
; EXAMPLE 4: Magic Getters/Setters Pattern
; ========================================
; Dynamic property-like methods

class SmartObject {
    _data := Map()

    __Call(name, params) {
        ; Check for "get" prefix
        if (SubStr(name, 1, 3) = "get") {
            propName := SubStr(name, 4)
            return this._GetProperty(propName)
        }

        ; Check for "set" prefix
        if (SubStr(name, 1, 3) = "set") {
            propName := SubStr(name, 4)
            if (params.Length > 0)
                return this._SetProperty(propName, params[1])
            throw Error("set" propName " requires a value parameter")
        }

        ; Check for "has" prefix
        if (SubStr(name, 1, 3) = "has") {
            propName := SubStr(name, 4)
            return this._HasProperty(propName)
        }

        ; Check for "clear" prefix
        if (SubStr(name, 1, 5) = "clear") {
            propName := SubStr(name, 6)
            return this._ClearProperty(propName)
        }

        throw Error("Unknown method: " name)
    }

    _GetProperty(name) {
        if (this._data.Has(name))
            return this._data[name]
        return ""
    }

    _SetProperty(name, value) {
        this._data[name] := value
        return this
    }

    _HasProperty(name) {
        return this._data.Has(name)
    }

    _ClearProperty(name) {
        if (this._data.Has(name))
            this._data.Delete(name)
        return this
    }

    GetAllProperties() {
        props := "Properties:`n"
        for key, value in this._data {
            props .= "- " key ": " value "`n"
        }
        return props
    }
}

; Use magic methods
obj := SmartObject()

; Set properties dynamically
obj.setName("John Doe")
obj.setAge(30)
obj.setEmail("john@example.com")
obj.setCity("New York")

; Get properties
MsgBox("Name: " obj.getName())
MsgBox("Age: " obj.getAge())

; Check properties
MsgBox("Has Email? " obj.hasEmail())
MsgBox("Has Phone? " obj.hasPhone())

; Show all properties
MsgBox(obj.GetAllProperties())

; Clear property
obj.clearCity()
MsgBox("After clearing City:`n" obj.GetAllProperties())

; ========================================
; EXAMPLE 5: Event Emitter Pattern
; ========================================
; Dynamic event registration and firing

class EventEmitter {
    _events := Map()

    __Call(name, params) {
        ; Handle "on" prefix - register event
        if (SubStr(name, 1, 2) = "on") {
            eventName := SubStr(name, 3)
            if (params.Length > 0)
                return this._RegisterEvent(eventName, params[1])
            throw Error("on" eventName " requires a callback parameter")
        }

        ; Handle "emit" prefix - fire event
        if (SubStr(name, 1, 4) = "emit") {
            eventName := SubStr(name, 5)
            return this._EmitEvent(eventName, params*)
        }

        ; Handle "off" prefix - unregister event
        if (SubStr(name, 1, 3) = "off") {
            eventName := SubStr(name, 4)
            return this._UnregisterEvent(eventName)
        }

        throw Error("Unknown method: " name)
    }

    _RegisterEvent(eventName, callback) {
        if (!this._events.Has(eventName))
            this._events[eventName] := []

        this._events[eventName].Push(callback)
        return "Registered event: " eventName
    }

    _EmitEvent(eventName, params*) {
        if (!this._events.Has(eventName))
            return "No handlers for event: " eventName

        results := []
        for callback in this._events[eventName] {
            result := callback.Call(params*)
            results.Push(result)
        }

        return results
    }

    _UnregisterEvent(eventName) {
        if (this._events.Has(eventName)) {
            this._events.Delete(eventName)
            return "Unregistered event: " eventName
        }
        return "Event not found: " eventName
    }

    GetEventList() {
        events := "Registered Events:`n"
        for eventName, callbacks in this._events {
            events .= "- " eventName " (" callbacks.Length " handlers)`n"
        }
        return events
    }
}

; Create emitter
emitter := EventEmitter()

; Register event handlers dynamically
emitter.onClick((*) => "Button was clicked!")
emitter.onClick((*) => "Another click handler")
emitter.onHover((*) => "Mouse hovering")
emitter.onSubmit((data) => "Form submitted with: " data)

; Show registered events
MsgBox(emitter.GetEventList())

; Emit events
clickResults := emitter.emitClick()
MsgBox("Click results:`n" clickResults[1] "`n" clickResults[2])

submitResults := emitter.emitSubmit("username=john")
MsgBox(submitResults[1])

; ========================================
; EXAMPLE 6: Method Aliasing
; ========================================
; Creating aliases for methods

class MathOperations {
    Add(a, b) {
        return a + b
    }

    Subtract(a, b) {
        return a - b
    }

    Multiply(a, b) {
        return a * b
    }

    Divide(a, b) {
        if (b = 0)
            throw Error("Division by zero")
        return a / b
    }

    __Call(name, params) {
        ; Define aliases
        aliases := Map(
            "plus", "Add",
            "sum", "Add",
            "minus", "Subtract",
            "sub", "Subtract",
            "times", "Multiply",
            "mult", "Multiply",
            "div", "Divide"
        )

        ; Check if name is an alias
        if (aliases.Has(name)) {
            realMethod := aliases[name]
            if (this.HasOwnProp(realMethod)) {
                return this.%realMethod%(params*)
            }
        }

        throw Error("Unknown method or alias: " name)
    }
}

; Use both real names and aliases
math := MathOperations()

MsgBox("Add(5, 3): " math.Add(5, 3))
MsgBox("plus(5, 3): " math.plus(5, 3))
MsgBox("sum(5, 3): " math.sum(5, 3))

MsgBox("Multiply(4, 5): " math.Multiply(4, 5))
MsgBox("times(4, 5): " math.times(4, 5))
MsgBox("mult(4, 5): " math.mult(4, 5))

MsgBox("Subtract(10, 3): " math.Subtract(10, 3))
MsgBox("minus(10, 3): " math.minus(10, 3))

; ========================================
; EXAMPLE 7: Debugging and Logging Wrapper
; ========================================
; Wrapping objects with call logging

class DebugWrapper {
    _target := ""
    _log := []
    _enabled := true

    __New(target) {
        this._target := target
    }

    __Call(name, params) {
        ; Check if method exists on target
        if (!this._target.HasOwnProp(name))
            throw Error("Method '" name "' not found on target object")

        ; Log the call
        if (this._enabled) {
            paramStr := ""
            for param in params {
                paramStr .= param
                if (A_Index < params.Length)
                    paramStr .= ", "
            }

            logEntry := {
                Method: name,
                Params: paramStr,
                Time: A_Now,
                Timestamp: FormatTime(A_Now, "HH:mm:ss.000")
            }

            this._log.Push(logEntry)
        }

        ; Execute actual method
        startTime := A_TickCount
        result := this._target.%name%(params*)
        duration := A_TickCount - startTime

        ; Log result
        if (this._enabled) {
            this._log[this._log.Length].Result := result
            this._log[this._log.Length].Duration := duration
        }

        return result
    }

    GetLog() {
        output := "=== Debug Log ===`n`n"

        for index, entry in this._log {
            output .= index ". " entry.Method "(" entry.Params ")`n"
            output .= "   Time: " entry.Timestamp "`n"
            output .= "   Result: " entry.Result "`n"
            output .= "   Duration: " entry.Duration "ms`n`n"
        }

        return output
    }

    ClearLog() {
        this._log := []
    }

    EnableLogging() {
        this._enabled := true
    }

    DisableLogging() {
        this._enabled := false
    }
}

class Calculator {
    Square(n) {
        return n * n
    }

    Cube(n) {
        return n * n * n
    }

    Factorial(n) {
        if (n <= 1)
            return 1
        return n * this.Factorial(n - 1)
    }
}

; Wrap calculator with debug wrapper
calc := Calculator()
debugCalc := DebugWrapper(calc)

; Make some calls
debugCalc.Square(5)
debugCalc.Cube(3)
debugCalc.Factorial(5)
debugCalc.Square(10)

; Show log
MsgBox(debugCalc.GetLog())

; Disable logging
debugCalc.DisableLogging()
debugCalc.Square(100)  ; Not logged

debugCalc.EnableLogging()
debugCalc.Cube(4)  ; Logged

MsgBox(debugCalc.GetLog())

MsgBox("=== OOP __Call Meta-Function Examples Complete ===`n`n"
    . "This file demonstrated:`n"
    . "- Basic __Call interception`n"
    . "- Method forwarding pattern`n"
    . "- Fluent interface builder`n"
    . "- Magic getters/setters`n"
    . "- Event emitter pattern`n"
    . "- Method aliasing`n"
    . "- Debugging wrapper")
