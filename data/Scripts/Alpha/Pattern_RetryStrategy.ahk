#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Retry Strategy - Resilient operation execution
; Demonstrates exponential backoff and retry patterns

class RetryStrategy {
    __New(options := "") {
        this.maxAttempts := options.Has("maxAttempts") ? options["maxAttempts"] : 3
        this.baseDelay := options.Has("baseDelay") ? options["baseDelay"] : 1000
        this.maxDelay := options.Has("maxDelay") ? options["maxDelay"] : 30000
        this.backoffMultiplier := options.Has("backoffMultiplier") ? options["backoffMultiplier"] : 2
        this.jitter := options.Has("jitter") ? options["jitter"] : true
        this.retryOn := options.Has("retryOn") ? options["retryOn"] : ""
    }

    ; Calculate delay with exponential backoff
    GetDelay(attempt) {
        delay := this.baseDelay * (this.backoffMultiplier ** (attempt - 1))
        delay := Min(delay, this.maxDelay)

        ; Add jitter (0-25% random variation)
        if this.jitter {
            jitterAmount := delay * 0.25 * Random()
            delay += jitterAmount
        }

        return Round(delay)
    }

    ; Check if error should be retried
    ShouldRetry(err, attempt) {
        if attempt >= this.maxAttempts
            return false

        if this.retryOn {
            return this.retryOn(err)
        }

        ; Default: retry all errors
        return true
    }
}

class RetryExecutor {
    __New(strategy := "") {
        this.strategy := strategy ?? RetryStrategy()
        this.onRetry := ""
        this.onSuccess := ""
        this.onFailure := ""
    }

    Execute(operation) {
        attempt := 1
        lastError := ""

        while attempt <= this.strategy.maxAttempts {
            try {
                result := operation()

                if this.onSuccess
                    this.onSuccess(result, attempt)

                return Map(
                    "success", true,
                    "result", result,
                    "attempts", attempt
                )
            } catch Error as e {
                lastError := e

                if !this.strategy.ShouldRetry(e, attempt) {
                    break
                }

                if this.onRetry
                    this.onRetry(e, attempt, this.strategy.GetDelay(attempt))

                if attempt < this.strategy.maxAttempts
                    Sleep(this.strategy.GetDelay(attempt))

                attempt++
            }
        }

        if this.onFailure
            this.onFailure(lastError, attempt)

        return Map(
            "success", false,
            "error", lastError,
            "attempts", attempt
        )
    }
}

; Circuit Breaker Pattern
class CircuitBreaker {
    __New(options := "") {
        this.failureThreshold := options.Has("failureThreshold") ? options["failureThreshold"] : 5
        this.recoveryTimeout := options.Has("recoveryTimeout") ? options["recoveryTimeout"] : 30000
        this.successThreshold := options.Has("successThreshold") ? options["successThreshold"] : 2

        this.state := "CLOSED"  ; CLOSED, OPEN, HALF_OPEN
        this.failures := 0
        this.successes := 0
        this.lastFailure := 0
    }

    Execute(operation) {
        switch this.state {
            case "OPEN":
                if A_TickCount - this.lastFailure >= this.recoveryTimeout {
                    this.state := "HALF_OPEN"
                    this.successes := 0
                } else {
                    throw Error("Circuit breaker is OPEN")
                }

            case "HALF_OPEN":
                ; Allow test request
        }

        try {
            result := operation()
            this._recordSuccess()
            return result
        } catch Error as e {
            this._recordFailure()
            throw e
        }
    }

    _recordSuccess() {
        this.failures := 0

        if this.state = "HALF_OPEN" {
            this.successes++
            if this.successes >= this.successThreshold {
                this.state := "CLOSED"
                this.successes := 0
            }
        }
    }

    _recordFailure() {
        this.failures++
        this.lastFailure := A_TickCount

        if this.state = "HALF_OPEN" || this.failures >= this.failureThreshold {
            this.state := "OPEN"
        }
    }

    State() => this.state
    Failures() => this.failures
}

; Demo - Basic retry
strategy := RetryStrategy(Map(
    "maxAttempts", 3,
    "baseDelay", 100,
    "backoffMultiplier", 2
))

executor := RetryExecutor(strategy)
logs := []

executor.onRetry := (err, attempt, delay) => logs.Push(Format("Retry #{} after {}ms: {}", attempt, delay, err.Message))
executor.onSuccess := (result, attempts) => logs.Push(Format("Success after {} attempts: {}", attempts, result))
executor.onFailure := (err, attempts) => logs.Push(Format("Failed after {} attempts: {}", attempts, err.Message))

; Simulate operation that fails twice then succeeds
attemptCount := 0
result := executor.Execute(() {
    global attemptCount
    attemptCount++
    if attemptCount < 3
        throw Error("Temporary failure")
    return "Success!"
})

output := "Retry Strategy Demo:`n`n"
for log in logs
    output .= log "`n"
output .= "`nFinal result: " (result["success"] ? result["result"] : "Failed")

MsgBox(output)

; Demo - Exponential backoff delays
strategy2 := RetryStrategy(Map(
    "maxAttempts", 6,
    "baseDelay", 100,
    "maxDelay", 5000,
    "backoffMultiplier", 2,
    "jitter", false
))

output := "Exponential Backoff Delays:`n`n"
output .= "Base: 100ms, Multiplier: 2x, Max: 5000ms`n`n"

Loop 6
    output .= Format("Attempt {}: {}ms delay`n", A_Index, strategy2.GetDelay(A_Index))

MsgBox(output)

; Demo - Circuit Breaker
breaker := CircuitBreaker(Map(
    "failureThreshold", 3,
    "recoveryTimeout", 500,
    "successThreshold", 2
))

logs := []
logs.Push("Initial state: " breaker.State())

; Simulate failures
Loop 4 {
    try {
        breaker.Execute(() {
            throw Error("Service unavailable")
        })
    } catch Error as e {
        logs.Push(Format("Call {}: {} (state: {})", A_Index, e.Message, breaker.State()))
    }
}

; Wait for recovery timeout
logs.Push("")
logs.Push("Waiting for recovery timeout...")
Sleep(600)

; Try again (HALF_OPEN)
try {
    breaker.Execute(() => "Success!")
    logs.Push("Recovery call 1: Success (state: " breaker.State() ")")
} catch {
}

try {
    breaker.Execute(() => "Success!")
    logs.Push("Recovery call 2: Success (state: " breaker.State() ")")
} catch {
}

output := "Circuit Breaker Demo:`n`n"
for log in logs
    output .= log "`n"

MsgBox(output)

; Demo - Retry with conditional retry
conditionalStrategy := RetryStrategy(Map(
    "maxAttempts", 5,
    "retryOn", (err) => InStr(err.Message, "retry") > 0
))

executor2 := RetryExecutor(conditionalStrategy)
logs := []

executor2.onRetry := (err, attempt, delay) => logs.Push(Format("Retrying: {}", err.Message))

; This will retry
try {
    executor2.Execute(() {
        throw Error("Please retry later")
    })
} catch {
    logs.Push("Failed (retryable error)")
}

; This won't retry
logs.Push("")
try {
    executor2.Execute(() {
        throw Error("Invalid input")
    })
} catch {
    logs.Push("Failed (non-retryable error)")
}

output := "Conditional Retry Demo:`n`n"
for log in logs
    output .= log "`n"

MsgBox(output)
