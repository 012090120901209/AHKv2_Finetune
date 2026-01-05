#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Circuit Breaker Pattern - Prevents cascading failures
; Demonstrates fault tolerance with automatic recovery

class CircuitBreaker {
    __New(threshold := 3, resetTimeout := 5000) {
        this.threshold := threshold
        this.resetTimeout := resetTimeout
        this.failures := 0
        this.state := "closed"  ; closed, open, half-open
        this.lastFailure := 0
    }

    Execute(action) {
        ; Check if circuit should try to recover
        if this.state = "open" {
            if A_TickCount - this.lastFailure > this.resetTimeout {
                this.state := "half-open"
                OutputDebug("[Circuit] Entering half-open state`n")
            } else {
                throw Error("Circuit is open - service unavailable")
            }
        }

        try {
            result := action()
            this.OnSuccess()
            return result
        } catch as e {
            this.OnFailure()
            throw e
        }
    }

    OnSuccess() {
        this.failures := 0
        if this.state = "half-open" {
            this.state := "closed"
            OutputDebug("[Circuit] Recovered - closing circuit`n")
        }
    }

    OnFailure() {
        this.failures++
        this.lastFailure := A_TickCount

        if this.failures >= this.threshold {
            this.state := "open"
            OutputDebug("[Circuit] Threshold reached - opening circuit`n")
        }
    }

    GetState() => this.state
    GetFailures() => this.failures
}

; Demo
breaker := CircuitBreaker(3, 2000)
callCount := 0
results := []

; Simulate unreliable service
UnreliableService() {
    global callCount
    callCount++
    if callCount <= 4
        throw Error("Service unavailable")
    return "Success!"
}

; Try multiple calls
Loop 8 {
    try {
        result := breaker.Execute(UnreliableService)
        results.Push("Call " A_Index ": " result)
    } catch as e {
        results.Push("Call " A_Index ": " e.Message " [State: " breaker.GetState() "]")
    }
    Sleep(600)  ; Wait between calls
}

output := ""
for r in results
    output .= r "`n"

MsgBox(output)
