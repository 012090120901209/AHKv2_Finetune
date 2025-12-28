#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; TTL Cache - Time-based cache expiration
; Demonstrates cache with automatic expiration

class TTLCache {
    __New(defaultTTL := 60000) {
        this.cache := Map()
        this.defaultTTL := defaultTTL
    }

    Set(key, value, ttl := "") {
        ttl := ttl ?? this.defaultTTL
        this.cache[key] := Map(
            "value", value,
            "expires", A_TickCount + ttl,
            "created", A_TickCount
        )
        return this
    }

    Get(key, defaultValue := "") {
        if !this.cache.Has(key)
            return defaultValue

        entry := this.cache[key]

        ; Check expiration
        if A_TickCount > entry["expires"] {
            this.cache.Delete(key)
            return defaultValue
        }

        return entry["value"]
    }

    Has(key) {
        if !this.cache.Has(key)
            return false

        if A_TickCount > this.cache[key]["expires"] {
            this.cache.Delete(key)
            return false
        }

        return true
    }

    Delete(key) => this.cache.Delete(key)
    Clear() => this.cache := Map()

    ; Refresh TTL without changing value
    Touch(key, ttl := "") {
        if this.Has(key) {
            ttl := ttl ?? this.defaultTTL
            this.cache[key]["expires"] := A_TickCount + ttl
            return true
        }
        return false
    }

    ; Get remaining TTL
    GetTTL(key) {
        if !this.Has(key)
            return -1
        return Max(0, this.cache[key]["expires"] - A_TickCount)
    }

    ; Remove expired entries
    Prune() {
        now := A_TickCount
        expired := []

        for key, entry in this.cache
            if now > entry["expires"]
                expired.Push(key)

        for key in expired
            this.cache.Delete(key)

        return expired.Length
    }

    Stats() {
        valid := 0
        expired := 0
        now := A_TickCount

        for key, entry in this.cache {
            if now > entry["expires"]
                expired++
            else
                valid++
        }

        return Map(
            "total", this.cache.Count,
            "valid", valid,
            "expired", expired
        )
    }

    Keys() {
        keys := []
        for key, _ in this.cache
            if this.Has(key)
                keys.Push(key)
        return keys
    }
}

; Memoize with TTL
class MemoizeTTL {
    __New(fn, ttl := 60000) {
        this.fn := fn
        this.cache := TTLCache(ttl)
    }

    Call(args*) {
        key := this._makeKey(args)

        if this.cache.Has(key)
            return this.cache.Get(key)

        result := this.fn(args*)
        this.cache.Set(key, result)
        return result
    }

    _makeKey(args) {
        key := ""
        for arg in args
            key .= String(arg) "|"
        return key
    }

    Invalidate(args*) {
        key := this._makeKey(args)
        this.cache.Delete(key)
    }

    Clear() => this.cache.Clear()
}

; Demo
cache := TTLCache(1000)  ; 1 second default TTL

cache.Set("fast", "expires quickly", 500)
cache.Set("normal", "normal expiration")
cache.Set("slow", "expires slowly", 3000)

result := "TTL Cache Demo:`n`n"
result .= "Initial state:`n"
for key in cache.Keys()
    result .= "  " key ": TTL=" cache.GetTTL(key) "ms`n"

MsgBox(result)

; Wait and check
Sleep(600)

result := "After 600ms:`n`n"
result .= "Has 'fast': " cache.Has("fast") "`n"
result .= "Has 'normal': " cache.Has("normal") "`n"
result .= "Has 'slow': " cache.Has("slow") "`n"
result .= "`nRemaining TTLs:`n"
for key in ["normal", "slow"] {
    if cache.Has(key)
        result .= "  " key ": " cache.GetTTL(key) "ms`n"
}

MsgBox(result)

; Demo - Memoization
expensiveFunction := (x) {
    Sleep(100)  ; Simulate expensive computation
    return x * x
}

memo := MemoizeTTL(expensiveFunction, 2000)

result := "Memoization Demo:`n`n"

; First call - slow
start := A_TickCount
res1 := memo.Call(5)
time1 := A_TickCount - start
result .= "First call (5): " res1 " in " time1 "ms`n"

; Second call - fast (cached)
start := A_TickCount
res2 := memo.Call(5)
time2 := A_TickCount - start
result .= "Second call (5): " res2 " in " time2 "ms (cached)`n"

; Different argument - slow
start := A_TickCount
res3 := memo.Call(10)
time3 := A_TickCount - start
result .= "New call (10): " res3 " in " time3 "ms`n"

MsgBox(result)

; Stats demo
statCache := TTLCache(100)
Loop 10
    statCache.Set("key" A_Index, "value" A_Index, Random(50, 200))

Sleep(120)

stats := statCache.Stats()
result := "Cache Stats:`n"
result .= "  Total: " stats["total"] "`n"
result .= "  Valid: " stats["valid"] "`n"
result .= "  Expired: " stats["expired"] "`n"

pruned := statCache.Prune()
result .= "`nPruned: " pruned " entries"

MsgBox(result)
