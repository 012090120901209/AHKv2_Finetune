#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Throttle and Debounce - Control function execution rate
; Demonstrates rate limiting for event handlers

class Throttle {
    __New(fn, delay) {
        this.fn := fn
        this.delay := delay
        this.lastCall := 0
    }

    Call(args*) {
        now := A_TickCount
        if now - this.lastCall >= this.delay {
            this.lastCall := now
            return this.fn(args*)
        }
    }
}

class Debounce {
    __New(fn, delay) {
        this.fn := fn
        this.delay := delay
        this.timer := ""
    }

    Call(args*) {
        if this.timer
            SetTimer(this.timer, 0)
        this.timer := this.CreateTimer(args)
        SetTimer(this.timer, -this.delay)
    }

    CreateTimer(args) {
        return () => this.fn(args*)
    }

    Cancel() {
        if this.timer
            SetTimer(this.timer, 0)
    }
}

; Memoization - Cache function results
class Memoize {
    __New(fn) {
        this.fn := fn
        this.cache := Map()
    }

    Call(args*) {
        key := this.MakeKey(args)
        if !this.cache.Has(key)
            this.cache[key] := this.fn(args*)
        return this.cache[key]
    }

    MakeKey(args) {
        key := ""
        for arg in args
            key .= String(arg) "|"
        return key
    }

    ClearCache() => this.cache := Map()
}

; Demo
logCount := 0
throttledLog := Throttle((msg) {
    global logCount
    logCount++
    OutputDebug("[" logCount "] " msg "`n")
}, 100)

; Call many times rapidly - only some will execute
Loop 20 {
    throttledLog.Call("Message " A_Index)
    Sleep(20)
}

MsgBox("Called 20 times, executed: " logCount)

; Memoization demo
ExpensiveCalc(n) {
    Sleep(100)  ; Simulate expensive operation
    return n * n
}

memoized := Memoize(ExpensiveCalc)

start := A_TickCount
result1 := memoized.Call(5)
time1 := A_TickCount - start

start := A_TickCount
result2 := memoized.Call(5)  ; Cached
time2 := A_TickCount - start

MsgBox("First call: " time1 "ms`nSecond call (cached): " time2 "ms")
