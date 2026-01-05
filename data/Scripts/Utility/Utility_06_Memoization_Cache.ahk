#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * Memoization and Caching
 * 
 * Demonstrates memoization for expensive computations and a simple
 * cache manager with TTL (time-to-live) expiration.
 * 
 * Source: AHK_Notes/Snippets/advanced-caching.md
 */

; Test memoized fibonacci
MsgBox("Computing Fibonacci(35) with memoization...", , "T1")
start := A_TickCount
result := MemoizedFib(35)
elapsed := A_TickCount - start

MsgBox("Memoized Fibonacci(35) = " result "`nTime: " elapsed "ms", , "T3")

; Test cache manager
cache := CacheManager()
cache.Set("user:123", { name: "Alice", role: "Admin" }, 5000)  ; 5 second TTL

MsgBox("Cache Test:`n`n"
    . "Set user:123 (TTL: 5s)`n"
    . "Get user:123: " cache.Get("user:123").name, , "T2")

Sleep(2000)
MsgBox("After 2 seconds:`n"
    . "Get user:123: " cache.Get("user:123").name, , "T2")

Sleep(4000)
MsgBox("After 6 seconds total:`n"
    . "Get user:123: " (cache.Get("user:123") == "" ? "Expired!" : "Still cached"), , "T2")

/**
 * Memoized Fibonacci
 * Caches previously computed values
 */
MemoizedFib(n) {
    static cache := Map()

    if (cache.Has(n))
        return cache[n]

    if (n <= 1) {
        result := n
    } else {
        result := MemoizedFib(n - 1) + MemoizedFib(n - 2)
    }

    cache[n] := result
    return result
}

/**
 * CacheManager - Simple cache with TTL
 */
class CacheManager {
    cache := Map()

    /**
     * Set cache value with optional TTL
     * @param {string} key - Cache key
     * @param {any} value - Value to cache
     * @param {int} ttl - Time to live in milliseconds (0 = no expiration)
     */
    Set(key, value, ttl := 0) {
        entry := {
            value: value,
            created: A_TickCount,
            ttl: ttl,
            hits: 0
        }

        this.cache[key] := entry
    }

    /**
     * Get cached value if not expired
     * @param {string} key - Cache key
     * @return {any} Cached value or empty string if not found/expired
     */
    Get(key) {
        if (!this.cache.Has(key))
            return ""

        entry := this.cache[key]

        ; Check expiration
        if (entry.ttl > 0) {
            age := A_TickCount - entry.created
            if (age > entry.ttl) {
                this.cache.Delete(key)
                return ""
            }
        }

        entry.hits++
        return entry.value
    }

    /**
     * Get value or compute if not cached
     * @param {string} key - Cache key
     * @param {func} computeFunc - Function to compute value if missing
     * @param {int} ttl - Time to live
     * @return {any} Cached or computed value
     */
    GetOrCompute(key, computeFunc, ttl := 0) {
        value := this.Get(key)

        if (value == "") {
            value := computeFunc()
            this.Set(key, value, ttl)
        }

        return value
    }

    /**
     * Remove expired entries
     */
    Cleanup() {
        toRemove := []

        for key, entry in this.cache {
            if (entry.ttl > 0) {
                age := A_TickCount - entry.created
                if (age > entry.ttl)
                    toRemove.Push(key)
            }
        }

        for key in toRemove
            this.cache.Delete(key)
    }

    /**
     * Clear all cache
     */
    Clear() {
        this.cache := Map()
    }

    /**
     * Get cache statistics
     */
    GetStats() {
        stats := {
            count: this.cache.Count,
            totalHits: 0
        }

        for key, entry in this.cache {
            stats.totalHits += entry.hits
        }

        return stats
    }
}

/*
* Key Concepts:
*
* 1. Memoization:
*    static cache := Map()  ; Persistent across calls
*    if (cache.Has(n)) return cache[n]
*    Store computed results
*
* 2. TTL (Time To Live):
*    created: A_TickCount  ; Store creation time
*    age := A_TickCount - entry.created
*    if (age > ttl) expire entry
*
* 3. GetOrCompute Pattern:
*    Check cache first
*    If miss, compute and store
*    Return cached/computed value
*
* 4. Cache Metadata:
*    - value: The cached data
*    - created: Timestamp
*    - ttl: Expiration time
*    - hits: Access counter
*
* 5. Use Cases:
*    ✅ Expensive calculations (Fibonacci, etc)
*    ✅ API responses
*    ✅ File operations
*    ✅ Database queries
*
* 6. Performance:
*    Fibonacci(35) without cache: ~2000ms
*    Fibonacci(35) with cache: <10ms
*    Huge speedup for recursive algorithms
*
* 7. Cleanup Strategies:
*    ⏰ TTL-based expiration
*    📦 Size-based eviction (LRU)
*    🧹 Manual cleanup
*/

