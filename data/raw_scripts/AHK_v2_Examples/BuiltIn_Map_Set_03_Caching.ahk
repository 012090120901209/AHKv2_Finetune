#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Set_03_Caching.ahk
 *
 * @description Map.Set() for implementing caching systems
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 *
 * @overview
 * Demonstrates using Map.Set() to implement various caching strategies
 * including LRU cache, time-based expiration, size limits, and more.
 */

;=============================================================================
; Example 1: Simple Cache with Expiration
;=============================================================================

/**
 * @class SimpleCache
 * @description Basic cache with time-based expiration
 */
class SimpleCache {
    cache := Map()
    ttl := 60000  ; Time to live: 60 seconds in milliseconds

    /**
     * @method Set
     * @description Store value in cache with timestamp
     * @param {String} key - Cache key
     * @param {Any} value - Value to cache
     */
    Set(key, value) {
        this.cache.Set(key, Map(
            "value", value,
            "timestamp", A_TickCount
        ))
    }

    /**
     * @method Get
     * @description Retrieve cached value if not expired
     * @param {String} key - Cache key
     * @returns {Any} Cached value or empty string if expired/missing
     */
    Get(key) {
        if (!this.cache.Has(key))
            return ""

        entry := this.cache[key]
        age := A_TickCount - entry["timestamp"]

        if (age > this.ttl) {
            this.cache.Delete(key)
            return ""
        }

        return entry["value"]
    }

    /**
     * @method GetStats
     * @description Get cache statistics
     * @returns {String} Cache statistics
     */
    GetStats() {
        valid := 0
        expired := 0

        for key, entry in this.cache {
            age := A_TickCount - entry["timestamp"]
            if (age > this.ttl)
                expired++
            else
                valid++
        }

        return "Total entries: " this.cache.Count "`nValid: " valid "`nExpired: " expired
    }
}

Example1_SimpleCache() {
    cache := SimpleCache()

    ; Store some values
    cache.Set("user:123", "John Doe")
    cache.Set("user:456", "Jane Smith")
    cache.Set("product:abc", "Laptop")

    output := "=== Simple Cache Example ===`n`n"
    output .= "Cached values:`n"
    output .= "user:123 = " cache.Get("user:123") "`n"
    output .= "user:456 = " cache.Get("user:456") "`n"
    output .= "product:abc = " cache.Get("product:abc") "`n`n"
    output .= cache.GetStats()

    MsgBox(output, "Simple Cache")
}

;=============================================================================
; Example 2: LRU (Least Recently Used) Cache
;=============================================================================

/**
 * @class LRUCache
 * @description Least Recently Used cache with size limit
 */
class LRUCache {
    cache := Map()
    accessOrder := []
    maxSize := 5

    /**
     * @method Set
     * @description Add item to cache, evicting LRU if at capacity
     * @param {String} key - Cache key
     * @param {Any} value - Value to cache
     */
    Set(key, value) {
        ; If key already exists, remove it from access order
        if (this.cache.Has(key)) {
            this.RemoveFromOrder(key)
        }
        ; If at capacity, evict least recently used
        else if (this.cache.Count >= this.maxSize) {
            this.EvictLRU()
        }

        ; Add to cache and mark as recently used
        this.cache.Set(key, value)
        this.accessOrder.Push(key)
    }

    /**
     * @method Get
     * @description Retrieve value and update access order
     * @param {String} key - Cache key
     * @returns {Any} Cached value
     */
    Get(key) {
        if (!this.cache.Has(key))
            return ""

        ; Update access order
        this.RemoveFromOrder(key)
        this.accessOrder.Push(key)

        return this.cache[key]
    }

    /**
     * @method RemoveFromOrder
     * @description Remove key from access order array
     * @param {String} key - Cache key
     */
    RemoveFromOrder(key) {
        newOrder := []
        for item in this.accessOrder {
            if (item != key)
                newOrder.Push(item)
        }
        this.accessOrder := newOrder
    }

    /**
     * @method EvictLRU
     * @description Evict least recently used item
     */
    EvictLRU() {
        if (this.accessOrder.Length = 0)
            return

        lruKey := this.accessOrder[1]
        this.cache.Delete(lruKey)
        this.accessOrder.RemoveAt(1)
    }

    /**
     * @method GetStatus
     * @description Get cache status
     * @returns {String} Cache status information
     */
    GetStatus() {
        output := "Cache size: " this.cache.Count "/" this.maxSize "`n"
        output .= "Access order (MRU to LRU): "

        ; Reverse order to show most recent first
        for i in Range(this.accessOrder.Length, 1, -1) {
            output .= this.accessOrder[i]
            if (i > 1)
                output .= " -> "
        }

        return output
    }
}

Range(start, end, step := 1) {
    arr := []
    if (step > 0) {
        Loop {
            if (start > end)
                break
            arr.Push(start)
            start += step
        }
    } else {
        Loop {
            if (start < end)
                break
            arr.Push(start)
            start += step
        }
    }
    return arr
}

Example2_LRUCache() {
    cache := LRUCache()

    output := "=== LRU Cache Example ===`n`n"

    ; Add items to cache
    cache.Set("A", "Value A")
    output .= "Added A`n" cache.GetStatus() "`n`n"

    cache.Set("B", "Value B")
    cache.Set("C", "Value C")
    cache.Set("D", "Value D")
    cache.Set("E", "Value E")
    output .= "Added B, C, D, E (cache full)`n" cache.GetStatus() "`n`n"

    ; Access A to make it most recently used
    cache.Get("A")
    output .= "Accessed A`n" cache.GetStatus() "`n`n"

    ; Add F - should evict B (least recently used)
    cache.Set("F", "Value F")
    output .= "Added F (B should be evicted)`n" cache.GetStatus() "`n`n"

    ; Check if B was evicted
    output .= "Get B: " (cache.Get("B") = "" ? "NOT FOUND (evicted)" : "Found") "`n"

    MsgBox(output, "LRU Cache")
}

;=============================================================================
; Example 3: Memoization Cache for Function Results
;=============================================================================

/**
 * @class MemoCache
 * @description Cache for expensive function results
 */
class MemoCache {
    cache := Map()
    hitCount := 0
    missCount := 0

    /**
     * @method Memoize
     * @description Get cached result or compute and cache
     * @param {String} funcName - Function identifier
     * @param {Array} args - Function arguments
     * @param {Func} computeFunc - Function to call on cache miss
     * @returns {Any} Function result
     */
    Memoize(funcName, args, computeFunc) {
        key := this.MakeKey(funcName, args)

        if (this.cache.Has(key)) {
            this.hitCount++
            return this.cache[key]
        }

        this.missCount++
        result := computeFunc.Call(args*)
        this.cache.Set(key, result)

        return result
    }

    /**
     * @method MakeKey
     * @description Create cache key from function name and arguments
     * @param {String} funcName - Function name
     * @param {Array} args - Arguments
     * @returns {String} Cache key
     */
    MakeKey(funcName, args) {
        key := funcName
        for arg in args {
            key .= ":" arg
        }
        return key
    }

    /**
     * @method GetStats
     * @description Get cache statistics
     * @returns {String} Statistics string
     */
    GetStats() {
        total := this.hitCount + this.missCount
        hitRate := total > 0 ? Round((this.hitCount / total) * 100, 2) : 0

        return "Cache hits: " this.hitCount
            . "`nCache misses: " this.missCount
            . "`nHit rate: " hitRate "%"
            . "`nCached results: " this.cache.Count
    }

    /**
     * @method Clear
     * @description Clear cache and statistics
     */
    Clear() {
        this.cache := Map()
        this.hitCount := 0
        this.missCount := 0
    }
}

; Expensive calculation (Fibonacci)
Fibonacci(n) {
    if (n <= 1)
        return n
    return Fibonacci(n - 1) + Fibonacci(n - 2)
}

; Factorial calculation
Factorial(n) {
    if (n <= 1)
        return 1
    return n * Factorial(n - 1)
}

Example3_MemoizationCache() {
    memo := MemoCache()

    output := "=== Memoization Cache Example ===`n`n"

    ; Calculate Fibonacci numbers with memoization
    output .= "Computing Fibonacci(10)...`n"
    startTime := A_TickCount
    result1 := memo.Memoize("fib", [10], Fibonacci)
    time1 := A_TickCount - startTime
    output .= "Result: " result1 " (took " time1 "ms)`n`n"

    output .= "Computing Fibonacci(10) again (should be cached)...`n"
    startTime := A_TickCount
    result2 := memo.Memoize("fib", [10], Fibonacci)
    time2 := A_TickCount - startTime
    output .= "Result: " result2 " (took " time2 "ms)`n`n"

    output .= "Computing Factorial(10)...`n"
    result3 := memo.Memoize("fact", [10], Factorial)
    output .= "Result: " result3 "`n`n"

    output .= memo.GetStats()

    MsgBox(output, "Memoization Cache")
}

;=============================================================================
; Example 4: Multi-Level Cache
;=============================================================================

/**
 * @class MultiLevelCache
 * @description Two-level cache (L1: fast/small, L2: slower/large)
 */
class MultiLevelCache {
    l1Cache := Map()  ; Fast, small cache
    l2Cache := Map()  ; Slower, larger cache
    l1MaxSize := 3
    l2MaxSize := 10
    stats := Map("l1Hits", 0, "l2Hits", 0, "misses", 0)

    /**
     * @method Set
     * @description Store value in both cache levels
     * @param {String} key - Cache key
     * @param {Any} value - Value to cache
     */
    Set(key, value) {
        ; Add to L1 cache
        if (this.l1Cache.Count >= this.l1MaxSize) {
            ; Remove oldest from L1
            for k in this.l1Cache {
                this.l1Cache.Delete(k)
                break
            }
        }
        this.l1Cache.Set(key, value)

        ; Add to L2 cache
        if (this.l2Cache.Count >= this.l2MaxSize) {
            ; Remove oldest from L2
            for k in this.l2Cache {
                this.l2Cache.Delete(k)
                break
            }
        }
        this.l2Cache.Set(key, value)
    }

    /**
     * @method Get
     * @description Retrieve from cache, checking L1 then L2
     * @param {String} key - Cache key
     * @returns {Any} Cached value
     */
    Get(key) {
        ; Check L1 first
        if (this.l1Cache.Has(key)) {
            this.stats["l1Hits"]++
            return this.l1Cache[key]
        }

        ; Check L2
        if (this.l2Cache.Has(key)) {
            this.stats["l2Hits"]++
            value := this.l2Cache[key]

            ; Promote to L1
            this.l1Cache.Set(key, value)

            return value
        }

        ; Miss
        this.stats["misses"]++
        return ""
    }

    /**
     * @method GetStats
     * @description Get cache statistics
     * @returns {String} Statistics
     */
    GetStats() {
        total := this.stats["l1Hits"] + this.stats["l2Hits"] + this.stats["misses"]

        output := "=== Cache Statistics ===`n"
        output .= "L1 Cache: " this.l1Cache.Count "/" this.l1MaxSize " entries`n"
        output .= "L2 Cache: " this.l2Cache.Count "/" this.l2MaxSize " entries`n`n"
        output .= "L1 Hits: " this.stats["l1Hits"] "`n"
        output .= "L2 Hits: " this.stats["l2Hits"] "`n"
        output .= "Misses: " this.stats["misses"] "`n"

        if (total > 0) {
            hitRate := Round(((this.stats["l1Hits"] + this.stats["l2Hits"]) / total) * 100, 2)
            output .= "Overall hit rate: " hitRate "%"
        }

        return output
    }
}

Example4_MultiLevelCache() {
    cache := MultiLevelCache()

    ; Add multiple items
    Loop 15 {
        cache.Set("key" A_Index, "value" A_Index)
    }

    output := "=== Multi-Level Cache Example ===`n`n"
    output .= "Added 15 items to cache`n`n"

    ; Test access patterns
    cache.Get("key1")   ; Should be miss (evicted from L1)
    cache.Get("key13")  ; Should be in L1
    cache.Get("key14")  ; Should be in L1
    cache.Get("key15")  ; Should be in L1
    cache.Get("key5")   ; Should be in L2, promote to L1
    cache.Get("key5")   ; Should be in L1 now
    cache.Get("key99")  ; Miss

    output .= cache.GetStats()

    MsgBox(output, "Multi-Level Cache")
}

;=============================================================================
; Example 5: Write-Through Cache
;=============================================================================

/**
 * @class WriteThroughCache
 * @description Cache that writes to backend storage immediately
 */
class WriteThroughCache {
    cache := Map()
    storage := Map()  ; Simulated persistent storage
    writeCount := 0
    readCount := 0

    /**
     * @method Write
     * @description Write to cache and storage
     * @param {String} key - Data key
     * @param {Any} value - Data value
     */
    Write(key, value) {
        ; Write to cache
        this.cache.Set(key, value)

        ; Write through to storage
        this.storage.Set(key, value)
        this.writeCount++
    }

    /**
     * @method Read
     * @description Read from cache, fallback to storage
     * @param {String} key - Data key
     * @returns {Any} Data value
     */
    Read(key) {
        this.readCount++

        ; Try cache first
        if (this.cache.Has(key))
            return this.cache[key]

        ; Fallback to storage
        if (this.storage.Has(key)) {
            value := this.storage[key]
            this.cache.Set(key, value)  ; Populate cache
            return value
        }

        return ""
    }

    /**
     * @method GetStats
     * @description Get cache statistics
     * @returns {String} Statistics
     */
    GetStats() {
        return "Cache entries: " this.cache.Count
            . "`nStorage entries: " this.storage.Count
            . "`nWrites: " this.writeCount
            . "`nReads: " this.readCount
    }
}

Example5_WriteThroughCache() {
    cache := WriteThroughCache()

    output := "=== Write-Through Cache Example ===`n`n"

    ; Write some data
    cache.Write("config:theme", "dark")
    cache.Write("config:language", "en")
    cache.Write("user:name", "John Doe")

    output .= "After writes:`n" cache.GetStats() "`n`n"

    ; Read data
    theme := cache.Read("config:theme")
    lang := cache.Read("config:language")

    output .= "Read values:`n"
    output .= "  theme: " theme "`n"
    output .= "  language: " lang "`n`n"

    output .= "After reads:`n" cache.GetStats()

    MsgBox(output, "Write-Through Cache")
}

;=============================================================================
; Example 6: Cache with Statistics and Monitoring
;=============================================================================

/**
 * @class MonitoredCache
 * @description Cache with detailed monitoring and statistics
 */
class MonitoredCache {
    cache := Map()
    stats := Map(
        "sets", 0,
        "gets", 0,
        "hits", 0,
        "misses", 0,
        "evictions", 0
    )
    maxSize := 100
    keyStats := Map()  ; Per-key statistics

    /**
     * @method Set
     * @description Add to cache with monitoring
     * @param {String} key - Cache key
     * @param {Any} value - Cache value
     */
    Set(key, value) {
        this.stats["sets"]++

        ; Evict if at capacity
        if (!this.cache.Has(key) && this.cache.Count >= this.maxSize) {
            this.EvictRandom()
        }

        this.cache.Set(key, Map(
            "value", value,
            "createdAt", A_TickCount,
            "lastAccessed", A_TickCount,
            "accessCount", 0
        ))

        ; Initialize key stats
        if (!this.keyStats.Has(key)) {
            this.keyStats.Set(key, Map(
                "hits", 0,
                "sets", 1
            ))
        } else {
            this.keyStats[key]["sets"]++
        }
    }

    /**
     * @method Get
     * @description Retrieve from cache with monitoring
     * @param {String} key - Cache key
     * @returns {Any} Cached value
     */
    Get(key) {
        this.stats["gets"]++

        if (!this.cache.Has(key)) {
            this.stats["misses"]++
            return ""
        }

        this.stats["hits"]++
        entry := this.cache[key]
        entry["lastAccessed"] := A_TickCount
        entry["accessCount"]++

        this.keyStats[key]["hits"]++

        return entry["value"]
    }

    /**
     * @method EvictRandom
     * @description Evict random entry
     */
    EvictRandom() {
        for key in this.cache {
            this.cache.Delete(key)
            this.stats["evictions"]++
            break
        }
    }

    /**
     * @method GetReport
     * @description Get detailed cache report
     * @returns {String} Report
     */
    GetReport() {
        output := "=== Cache Monitoring Report ===`n`n"

        output .= "Overall Statistics:`n"
        output .= "  Current size: " this.cache.Count "/" this.maxSize "`n"
        output .= "  Total sets: " this.stats["sets"] "`n"
        output .= "  Total gets: " this.stats["gets"] "`n"
        output .= "  Hits: " this.stats["hits"] "`n"
        output .= "  Misses: " this.stats["misses"] "`n"
        output .= "  Evictions: " this.stats["evictions"] "`n"

        if (this.stats["gets"] > 0) {
            hitRate := Round((this.stats["hits"] / this.stats["gets"]) * 100, 2)
            output .= "  Hit rate: " hitRate "%`n"
        }

        output .= "`nMost Accessed Keys:`n"
        ; Get top 5 most accessed keys
        sorted := []
        for key, stats in this.keyStats {
            sorted.Push({key: key, hits: stats["hits"]})
        }

        ; Simple bubble sort
        Loop sorted.Length {
            i := A_Index
            Loop sorted.Length - i {
                j := A_Index
                if (sorted[j]["hits"] < sorted[j + 1]["hits"]) {
                    temp := sorted[j]
                    sorted[j] := sorted[j + 1]
                    sorted[j + 1] := temp
                }
            }
        }

        count := Min(5, sorted.Length)
        Loop count {
            item := sorted[A_Index]
            output .= "  " item["key"] ": " item["hits"] " hits`n"
        }

        return output
    }
}

Min(a, b) => (a < b ? a : b)

Example6_MonitoredCache() {
    cache := MonitoredCache()

    ; Simulate cache usage
    cache.Set("user:1", "Alice")
    cache.Set("user:2", "Bob")
    cache.Set("user:3", "Carol")

    ; Simulate access pattern
    Loop 10
        cache.Get("user:1")
    Loop 5
        cache.Get("user:2")
    Loop 3
        cache.Get("user:3")

    cache.Get("user:4")  ; Miss

    MsgBox(cache.GetReport(), "Monitored Cache")
}

;=============================================================================
; Example 7: Distributed Cache Simulation
;=============================================================================

/**
 * @class DistributedCache
 * @description Simulates distributed cache with multiple nodes
 */
class DistributedCache {
    nodes := []
    nodeCount := 3

    __New() {
        ; Create cache nodes
        Loop this.nodeCount {
            this.nodes.Push(Map())
        }
    }

    /**
     * @method GetNodeIndex
     * @description Hash key to determine which node to use
     * @param {String} key - Cache key
     * @returns {Integer} Node index
     */
    GetNodeIndex(key) {
        ; Simple hash function
        hash := 0
        Loop Parse key {
            hash += Ord(A_LoopField)
        }
        return Mod(hash, this.nodeCount) + 1
    }

    /**
     * @method Set
     * @description Store in appropriate node
     * @param {String} key - Cache key
     * @param {Any} value - Cache value
     */
    Set(key, value) {
        nodeIdx := this.GetNodeIndex(key)
        this.nodes[nodeIdx].Set(key, value)
    }

    /**
     * @method Get
     * @description Retrieve from appropriate node
     * @param {String} key - Cache key
     * @returns {Any} Cached value
     */
    Get(key) {
        nodeIdx := this.GetNodeIndex(key)
        node := this.nodes[nodeIdx]
        return node.Has(key) ? node[key] : ""
    }

    /**
     * @method GetDistribution
     * @description Show how keys are distributed
     * @returns {String} Distribution info
     */
    GetDistribution() {
        output := "=== Distributed Cache Distribution ===`n`n"

        Loop this.nodeCount {
            nodeIdx := A_Index
            node := this.nodes[nodeIdx]
            output .= "Node " nodeIdx ": " node.Count " entries`n"

            for key, value in node {
                output .= "  " key " = " value "`n"
            }
            output .= "`n"
        }

        return output
    }
}

Example7_DistributedCache() {
    cache := DistributedCache()

    ; Add data
    cache.Set("user:alice", "Alice Johnson")
    cache.Set("user:bob", "Bob Smith")
    cache.Set("user:carol", "Carol White")
    cache.Set("product:laptop", "Laptop")
    cache.Set("product:mouse", "Mouse")
    cache.Set("order:1001", "Order 1001")
    cache.Set("order:1002", "Order 1002")

    MsgBox(cache.GetDistribution(), "Distributed Cache")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Set() - Caching Implementation Examples"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Caching Strategies with Map.Set()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: Simple Cache")
        .OnEvent("Click", (*) => Example1_SimpleCache())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: LRU Cache")
        .OnEvent("Click", (*) => Example2_LRUCache())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Memoization")
        .OnEvent("Click", (*) => Example3_MemoizationCache())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Multi-Level")
        .OnEvent("Click", (*) => Example4_MultiLevelCache())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Write-Through")
        .OnEvent("Click", (*) => Example5_WriteThroughCache())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Monitored")
        .OnEvent("Click", (*) => Example6_MonitoredCache())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Distributed Cache")
        .OnEvent("Click", (*) => Example7_DistributedCache())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_SimpleCache()
        Example2_LRUCache()
        Example3_MemoizationCache()
        Example4_MultiLevelCache()
        Example5_WriteThroughCache()
        Example6_MonitoredCache()
        Example7_DistributedCache()
        MsgBox("All caching examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
