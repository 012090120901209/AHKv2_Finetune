#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Rate Limiter - Sliding window token bucket
; Demonstrates API rate limiting protection

class RateLimiter {
    __New(maxRequests, windowMs) {
        this.maxRequests := maxRequests
        this.windowMs := windowMs
        this.requests := []
    }

    TryAcquire() {
        now := A_TickCount
        this.Cleanup(now)

        if this.requests.Length >= this.maxRequests
            return false

        this.requests.Push(now)
        return true
    }

    Cleanup(now) {
        while this.requests.Length && now - this.requests[1] > this.windowMs
            this.requests.RemoveAt(1)
    }

    GetWaitTime() {
        if this.requests.Length < this.maxRequests
            return 0
        
        this.Cleanup(A_TickCount)
        if this.requests.Length < this.maxRequests
            return 0
            
        return this.windowMs - (A_TickCount - this.requests[1])
    }
    
    GetRemaining() {
        this.Cleanup(A_TickCount)
        return this.maxRequests - this.requests.Length
    }
}

; Demo - 5 requests per 2 seconds
limiter := RateLimiter(5, 2000)
results := []

Loop 10 {
    if limiter.TryAcquire() {
        results.Push("Request " A_Index ": ALLOWED (remaining: " limiter.GetRemaining() ")")
    } else {
        wait := limiter.GetWaitTime()
        results.Push("Request " A_Index ": BLOCKED (wait " wait "ms)")
    }
    Sleep(200)
}

output := "Rate Limit: 5 requests per 2 seconds`n`n"
for r in results
    output .= r "`n"

MsgBox(output)
