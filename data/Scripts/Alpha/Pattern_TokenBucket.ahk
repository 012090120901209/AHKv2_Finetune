#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Token Bucket Rate Limiter - Advanced rate limiting
; Demonstrates token-based request throttling

class TokenBucket {
    __New(capacity, refillRate, refillInterval := 1000) {
        this.capacity := capacity      ; Max tokens
        this.tokens := capacity        ; Current tokens
        this.refillRate := refillRate  ; Tokens added per interval
        this.refillInterval := refillInterval  ; Interval in ms
        this.lastRefill := A_TickCount
    }

    _refill() {
        now := A_TickCount
        elapsed := now - this.lastRefill
        intervals := elapsed // this.refillInterval

        if intervals > 0 {
            this.tokens := Min(this.capacity, this.tokens + intervals * this.refillRate)
            this.lastRefill := now - Mod(elapsed, this.refillInterval)
        }
    }

    TryConsume(tokens := 1) {
        this._refill()

        if this.tokens >= tokens {
            this.tokens -= tokens
            return true
        }
        return false
    }

    ; How long until n tokens available
    WaitTime(tokens := 1) {
        this._refill()
        
        if this.tokens >= tokens
            return 0

        needed := tokens - this.tokens
        intervals := Ceil(needed / this.refillRate)
        
        elapsed := A_TickCount - this.lastRefill
        remaining := this.refillInterval - elapsed
        
        return remaining + (intervals - 1) * this.refillInterval
    }

    Available() {
        this._refill()
        return this.tokens
    }
}

; Sliding Window Rate Limiter
class SlidingWindowLimiter {
    __New(maxRequests, windowMs) {
        this.maxRequests := maxRequests
        this.windowMs := windowMs
        this.requests := []
    }

    _cleanup() {
        now := A_TickCount
        cutoff := now - this.windowMs
        
        while this.requests.Length && this.requests[1] < cutoff
            this.requests.RemoveAt(1)
    }

    TryRequest() {
        this._cleanup()

        if this.requests.Length < this.maxRequests {
            this.requests.Push(A_TickCount)
            return true
        }
        return false
    }

    Remaining() {
        this._cleanup()
        return Max(0, this.maxRequests - this.requests.Length)
    }

    ResetTime() {
        if !this.requests.Length
            return 0
        return Max(0, this.windowMs - (A_TickCount - this.requests[1]))
    }
}

; Leaky Bucket - Smooths burst traffic
class LeakyBucket {
    __New(capacity, leakRate) {
        this.capacity := capacity   ; Max queue size
        this.leakRate := leakRate   ; Items processed per second
        this.water := 0
        this.lastLeak := A_TickCount
    }

    _leak() {
        now := A_TickCount
        elapsed := (now - this.lastLeak) / 1000  ; Convert to seconds
        leaked := elapsed * this.leakRate
        
        this.water := Max(0, this.water - leaked)
        this.lastLeak := now
    }

    TryAdd(amount := 1) {
        this._leak()

        if this.water + amount <= this.capacity {
            this.water += amount
            return true
        }
        return false
    }

    CurrentLevel() {
        this._leak()
        return this.water
    }

    IsFull() {
        this._leak()
        return this.water >= this.capacity
    }
}

; Rate Limiter with multiple strategies
class RateLimiter {
    __New(strategy, options := "") {
        switch strategy {
            case "token":
                this.limiter := TokenBucket(
                    options["capacity"] ?? 10,
                    options["refillRate"] ?? 1,
                    options["refillInterval"] ?? 1000
                )
            case "sliding":
                this.limiter := SlidingWindowLimiter(
                    options["maxRequests"] ?? 10,
                    options["windowMs"] ?? 60000
                )
            case "leaky":
                this.limiter := LeakyBucket(
                    options["capacity"] ?? 10,
                    options["leakRate"] ?? 1
                )
            default:
                throw Error("Unknown strategy: " strategy)
        }
        this.strategy := strategy
    }

    Allow(cost := 1) {
        if this.strategy = "token"
            return this.limiter.TryConsume(cost)
        else if this.strategy = "sliding"
            return this.limiter.TryRequest()
        else
            return this.limiter.TryAdd(cost)
    }

    GetStatus() {
        switch this.strategy {
            case "token":
                return Map(
                    "available", this.limiter.Available(),
                    "waitTime", this.limiter.WaitTime()
                )
            case "sliding":
                return Map(
                    "remaining", this.limiter.Remaining(),
                    "resetTime", this.limiter.ResetTime()
                )
            case "leaky":
                return Map(
                    "level", this.limiter.CurrentLevel(),
                    "isFull", this.limiter.IsFull()
                )
        }
    }
}

; Demo - Token Bucket
bucket := TokenBucket(5, 1, 500)  ; 5 tokens, 1 per 500ms

result := "Token Bucket Demo:`n`n"
result .= "Initial tokens: " bucket.Available() "`n`n"

; Burst requests
result .= "Burst of 7 requests:`n"
Loop 7 {
    allowed := bucket.TryConsume()
    result .= "  Request " A_Index ": " (allowed ? "✓ allowed" : "✗ denied") "`n"
}

result .= "`nTokens after burst: " bucket.Available() "`n"
result .= "Wait time for 1 token: " bucket.WaitTime(1) "ms`n"

MsgBox(result)

; Simulate refill
Sleep(600)
result := "After 600ms wait:`n"
result .= "Tokens available: " bucket.Available() "`n"
result .= "Can consume 1: " bucket.TryConsume()

MsgBox(result)

; Demo - Sliding Window
slider := SlidingWindowLimiter(3, 1000)  ; 3 requests per second

result := "Sliding Window Demo:`n`n"
result .= "Limit: 3 requests per second`n`n"

; Make requests
Loop 5 {
    allowed := slider.TryRequest()
    result .= "Request " A_Index ": " (allowed ? "✓" : "✗") 
            . " (remaining: " slider.Remaining() ")`n"
}

result .= "`nReset in: " slider.ResetTime() "ms"

MsgBox(result)

; Demo - Rate Limiter factory
result := "Rate Limiter Factory Demo:`n`n"

strategies := ["token", "sliding", "leaky"]
for strat in strategies {
    limiter := RateLimiter(strat, Map("capacity", 3, "maxRequests", 3, "refillRate", 1, "leakRate", 1))
    
    result .= strat " strategy:`n"
    Loop 4 {
        allowed := limiter.Allow()
        result .= "  " (allowed ? "✓" : "✗")
    }
    
    status := limiter.GetStatus()
    result .= " | Status: "
    for k, v in status
        result .= k "=" v " "
    result .= "`n"
}

MsgBox(result)
