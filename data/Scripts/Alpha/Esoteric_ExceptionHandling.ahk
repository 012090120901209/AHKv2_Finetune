#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Exception Handling - Try/catch/finally edge cases and patterns
; Demonstrates advanced error handling in AHK v2

; =============================================================================
; 1. Exception Hierarchy
; =============================================================================

; Built-in exception types:
; Error - base class
;   ├── MemoryError
;   ├── OSError
;   ├── TargetError
;   ├── TimeoutError
;   ├── TypeError
;   ├── UnsetError (when accessing unset variable/item)
;   ├── ValueError
;   │   └── IndexError
;   ├── PropertyError
;   └── MethodError

; Custom exceptions
class AppError extends Error {
    __New(message, code := 0, extra := "") {
        super.__New(message, extra)
        this.code := code
    }
}

class ValidationError extends AppError {
    __New(field, message) {
        super.__New(message, 400)
        this.field := field
    }
}

class NetworkError extends AppError {
    __New(message, statusCode := 0) {
        super.__New(message, statusCode)
    }
    
    IsRetryable => this.code >= 500 || this.code = 408
}

; =============================================================================
; 2. Try/Catch/Finally Behavior
; =============================================================================

; Finally always runs, even with return
TestFinally() {
    try {
        return "try result"
    } finally {
        ; This WILL execute before return completes
        FileAppend("Finally ran`n", "*")
    }
}

; Finally runs even with throw
TestFinallyWithThrow() {
    try {
        try {
            throw Error("Inner error")
        } finally {
            ; Still runs despite throw
            FileAppend("Inner finally`n", "*")
        }
    } catch Error as e {
        return "Caught: " e.Message
    }
}

; Nested try blocks
NestedTry() {
    try {
        try {
            throw ValueError("Level 2")
        } catch TypeError {
            ; Won't catch ValueError
            return "Caught TypeError"
        }
        ; ValueError propagates here
    } catch ValueError as e {
        return "Caught ValueError: " e.Message
    }
}

; =============================================================================
; 3. Catch Type Filtering
; =============================================================================

; Catch specific types
HandleError(fn) {
    try {
        return {success: true, value: fn()}
    } catch TypeError as e {
        return {success: false, type: "type", error: e}
    } catch ValueError as e {
        return {success: false, type: "value", error: e}
    } catch OSError as e {
        return {success: false, type: "os", error: e}
    } catch Error as e {
        return {success: false, type: "generic", error: e}
    }
}

; Catch multiple types (re-throw pattern)
ProcessData(data) {
    try {
        return Transform(data)
    } catch TypeError as e {
        throw AppError("Invalid data type", 400, e.Message)
    } catch ValueError as e {
        throw AppError("Invalid data value", 400, e.Message)
    }
}

Transform(data) {
    if !IsObject(data)
        throw TypeError("Expected object")
    if !data.HasOwnProp("value")
        throw ValueError("Missing 'value' property")
    return data.value * 2
}

; =============================================================================
; 4. Error Context and Stack Traces
; =============================================================================

; Capture call stack
class StackTrace {
    static Capture() {
        ; Use Error to capture stack
        err := Error()
        return err.Stack
    }
    
    static Parse(stack) {
        lines := StrSplit(stack, "`n")
        frames := []
        
        for line in lines {
            if line = ""
                continue
            
            ; Parse format: "► FuncName @ File.ahk (123) : code"
            if RegExMatch(line, "► (\w+)\s*@\s*(.+?)\s*\((\d+)\)", &m)
                frames.Push({func: m[1], file: m[2], line: m[3]})
        }
        
        return frames
    }
}

; Enhanced error with context
class ContextualError extends Error {
    __New(message, context := Map()) {
        super.__New(message)
        this.context := context
        this.timestamp := A_Now
        this.stackFrames := StackTrace.Parse(this.Stack)
    }
    
    ToString() {
        s := this.Message "`n`nContext:`n"
        for key, value in this.context
            s .= "  " key ": " String(value) "`n"
        s .= "`nTime: " this.timestamp
        return s
    }
}

; =============================================================================
; 5. Error Recovery Strategies
; =============================================================================

; Retry with exponential backoff
Retry(fn, maxAttempts := 3, baseDelay := 100) {
    lastError := ""
    
    loop maxAttempts {
        try {
            return fn()
        } catch Error as e {
            lastError := e
            if A_Index < maxAttempts
                Sleep(baseDelay * (2 ** (A_Index - 1)))
        }
    }
    
    throw Error("Max retries exceeded", lastError.Message)
}

; Fallback chain
Fallback(fns*) {
    errors := []
    
    for fn in fns {
        try {
            return fn()
        } catch Error as e {
            errors.Push(e)
        }
    }
    
    ; All failed
    messages := []
    for e in errors
        messages.Push(e.Message)
    throw Error("All fallbacks failed: " _JoinStr(messages, "; "))
}

_JoinStr(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") . v
    return result
}

; Circuit breaker pattern
class CircuitBreaker {
    __New(threshold := 5, resetTimeout := 30000) {
        this.threshold := threshold
        this.resetTimeout := resetTimeout
        this.failures := 0
        this.state := "closed"  ; closed, open, half-open
        this.openedAt := 0
    }
    
    Execute(fn) {
        if this.state = "open" {
            if A_TickCount - this.openedAt > this.resetTimeout {
                this.state := "half-open"
            } else {
                throw Error("Circuit breaker is open")
            }
        }
        
        try {
            result := fn()
            this._onSuccess()
            return result
        } catch Error as e {
            this._onFailure()
            throw e
        }
    }
    
    _onSuccess() {
        this.failures := 0
        this.state := "closed"
    }
    
    _onFailure() {
        this.failures++
        if this.failures >= this.threshold {
            this.state := "open"
            this.openedAt := A_TickCount
        }
    }
    
    State => this.state
}

; =============================================================================
; 6. Resource Management (RAII Pattern)
; =============================================================================

; Disposable wrapper
class Using {
    static Run(resource, fn) {
        try {
            return fn(resource)
        } finally {
            if HasMethod(resource, "Dispose")
                resource.Dispose()
            else if HasMethod(resource, "Close")
                resource.Close()
        }
    }
    
    ; Multiple resources
    static RunAll(resources, fn) {
        try {
            return fn(resources*)
        } finally {
            ; Dispose in reverse order
            loop resources.Length {
                r := resources[resources.Length - A_Index + 1]
                try {
                    if HasMethod(r, "Dispose")
                        r.Dispose()
                    else if HasMethod(r, "Close")
                        r.Close()
                }
            }
        }
    }
}

; Example resource
class ManagedResource {
    __New(name) {
        this.name := name
        this.isOpen := true
        FileAppend("Opened: " name "`n", "*")
    }
    
    DoWork() {
        if !this.isOpen
            throw Error("Resource is closed")
        return "Working with " this.name
    }
    
    Dispose() {
        if this.isOpen {
            this.isOpen := false
            FileAppend("Disposed: " this.name "`n", "*")
        }
    }
}

; =============================================================================
; 7. Result Type (Error as Value)
; =============================================================================

class Result {
    __New(isOk, value) {
        this._isOk := isOk
        this._value := value
    }
    
    static Ok(value) => Result(true, value)
    static Err(error) => Result(false, error)
    
    IsOk => this._isOk
    IsErr => !this._isOk
    
    ; Unwrap or throw
    Unwrap() {
        if !this._isOk
            throw this._value is Error ? this._value : Error(String(this._value))
        return this._value
    }
    
    ; Unwrap with default
    UnwrapOr(default) => this._isOk ? this._value : default
    
    ; Map success value
    Map(fn) {
        return this._isOk ? Result.Ok(fn(this._value)) : this
    }
    
    ; Map error value
    MapErr(fn) {
        return this._isOk ? this : Result.Err(fn(this._value))
    }
    
    ; Chain operations
    AndThen(fn) {
        return this._isOk ? fn(this._value) : this
    }
    
    ; Handle both cases
    Match(onOk, onErr) {
        return this._isOk ? onOk(this._value) : onErr(this._value)
    }
}

; Wrap throwing function
TryResult(fn) {
    try {
        return Result.Ok(fn())
    } catch Error as e {
        return Result.Err(e)
    }
}

; =============================================================================
; 8. Aggregate Exceptions
; =============================================================================

class AggregateError extends Error {
    __New(message, errors) {
        super.__New(message)
        this.errors := errors
    }
    
    Count => this.errors.Length
    
    ToString() {
        s := this.Message "`n"
        for i, e in this.errors
            s .= "  [" i "] " e.Message "`n"
        return s
    }
}

; Run all, collect errors
RunAll(fns*) {
    results := []
    errors := []
    
    for fn in fns {
        try {
            results.Push(fn())
        } catch Error as e {
            errors.Push(e)
        }
    }
    
    if errors.Length > 0
        throw AggregateError("Multiple operations failed", errors)
    
    return results
}

; =============================================================================
; 9. Async-like Error Handling
; =============================================================================

; Promise-like error handling
class AsyncResult {
    __New() {
        this._state := "pending"
        this._value := ""
        this._handlers := []
    }
    
    Resolve(value) {
        if this._state != "pending"
            return
        this._state := "fulfilled"
        this._value := value
        this._notify()
    }
    
    Reject(error) {
        if this._state != "pending"
            return
        this._state := "rejected"
        this._value := error
        this._notify()
    }
    
    Then(onFulfilled, onRejected := "") {
        handler := {fulfill: onFulfilled, reject: onRejected}
        this._handlers.Push(handler)
        
        if this._state != "pending"
            this._notify()
        
        return this
    }
    
    Catch(onRejected) => this.Then("", onRejected)
    
    _notify() {
        for handler in this._handlers {
            if this._state = "fulfilled" && handler.fulfill
                handler.fulfill(this._value)
            else if this._state = "rejected" && handler.reject
                handler.reject(this._value)
        }
    }
    
    State => this._state
}

; =============================================================================
; Demo
; =============================================================================

; Exception hierarchy
try {
    throw ValidationError("email", "Invalid email format")
} catch ValidationError as e {
    MsgBox("Validation Error:`n`nField: " e.field "`nMessage: " e.Message "`nCode: " e.code)
}

; Nested try/finally
result := NestedTry()
MsgBox("Nested Try: " result)

; Error type filtering
r1 := HandleError(() => (throw TypeError("type issue")))
r2 := HandleError(() => (throw ValueError("value issue")))
r3 := HandleError(() => 42)

MsgBox("Type Filtering:`n`n"
    . "TypeError: " r1.type "`n"
    . "ValueError: " r2.type "`n"
    . "Success: " r3.value)

; Retry pattern
retryCount := 0
try {
    Retry(() => (
        retryCount++,
        retryCount < 3 ? (throw Error("Not ready")) : "Success!"
    ), 5, 10)
    MsgBox("Retry succeeded after " retryCount " attempts")
}

; Fallback chain
value := Fallback(
    () => (throw Error("Primary failed")),
    () => (throw Error("Secondary failed")),
    () => "Tertiary succeeded!"
)
MsgBox("Fallback: " value)

; Resource management
Using.Run(ManagedResource("TestResource"), (r) => r.DoWork())
MsgBox("Resource was automatically disposed")

; Result type
divide := (a, b) => b = 0 ? Result.Err(Error("Division by zero")) : Result.Ok(a / b)

result1 := divide(10, 2)
    .Map((x) => x * 2)
    .UnwrapOr(0)

result2 := divide(10, 0)
    .Map((x) => x * 2)
    .MapErr((e) => Error("Modified: " e.Message))
    .Match(
        (v) => "Value: " v,
        (e) => "Error: " e.Message
    )

MsgBox("Result Type:`n`n"
    . "10/2 * 2 = " result1 "`n"
    . "10/0 = " result2)

; Aggregate errors
try {
    RunAll(
        () => "ok1",
        () => (throw Error("fail1")),
        () => "ok2",
        () => (throw Error("fail2"))
    )
} catch AggregateError as e {
    MsgBox("Aggregate Error:`n`n" e.ToString())
}

; Circuit breaker
breaker := CircuitBreaker(3, 1000)
failures := 0

loop 5 {
    try {
        breaker.Execute(() => (throw Error("Service unavailable")))
    } catch {
        failures++
    }
}
MsgBox("Circuit Breaker:`n`nState: " breaker.State "`nFailures: " failures)

; Stack trace
try {
    InnerFunc()
} catch Error as e {
    MsgBox("Stack Trace:`n`n" e.Stack)
}

InnerFunc() => MiddleFunc()
MiddleFunc() => DeepFunc()
DeepFunc() => (throw Error("Deep error"))
