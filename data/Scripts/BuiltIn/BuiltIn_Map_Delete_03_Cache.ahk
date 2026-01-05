#Requires AutoHotkey v2.0
#SingleInstance Force

/**
 * BuiltIn_Map_Delete_03_Cache.ahk
 * 
 * @description Map.Delete() for cache invalidation and management
 * @author AutoHotkey v2 Examples Collection
 * @version 1.0.0
 * @date 2025-11-16
 * 
 * @overview
 * Using Map.Delete() for cache invalidation patterns, TTL management,
 * selective cache clearing, and cache consistency maintenance.
 */

;=============================================================================
; Example 1: TTL Cache with Auto-Expiration
;=============================================================================

Example1_TTLCache() {
    cache := Map()

    Set(key, value, ttl := 5000) {
        cache.Set(key, Map(
            "value", value,
            "expires", A_TickCount + ttl
        ))
    }

    Get(key) {
        if (!cache.Has(key))
            return ""

        item := cache[key]
        if (A_TickCount > item["expires"]) {
            cache.Delete(key)
            return ""
        }

        return item["value"]
    }

    CleanExpired() {
        toDelete := []
        for key, item in cache {
            if (A_TickCount > item["expires"])
                toDelete.Push(key)
        }

        for key in toDelete {
            cache.Delete(key)
        }

        return toDelete.Length
    }

    output := "=== TTL Cache ===`n`n"

    Set("short", "Expires soon", 100)
    Set("long", "Expires later", 10000)
    Set("medium", "Medium TTL", 2000)

    output .= "Cached 3 items`n"
    output .= "Initial cache size: " cache.Count "`n`n"

    Sleep(150)
    cleaned := CleanExpired()

    output .= "After 150ms:`n"
    output .= "Expired and removed: " cleaned "`n"
    output .= "Remaining: " cache.Count "`n"

    MsgBox(output, "TTL Cache")
}

;=============================================================================
; Example 2: Tag-Based Cache Invalidation
;=============================================================================

Example2_TagBasedInvalidation() {
    cache := Map()
    tags := Map()  ; tag -> [keys]

    SetWithTags(key, value, tagList) {
        cache.Set(key, value)

        for tag in tagList {
            if (!tags.Has(tag))
                tags.Set(tag, [])
            tags[tag].Push(key)
        }
    }

    InvalidateTag(tag) {
        if (!tags.Has(tag))
            return 0

        keys := tags[tag]
        count := 0

        for key in keys {
            if (cache.Delete(key) != "")
                count++
        }

        tags.Delete(tag)
        return count
    }

    output := "=== Tag-Based Invalidation ===`n`n"

    SetWithTags("user:1", "Alice", ["users", "active"])
    SetWithTags("user:2", "Bob", ["users", "active"])
    SetWithTags("product:1", "Laptop", ["products"])
    SetWithTags("product:2", "Mouse", ["products", "electronics"])

    output .= "Initial cache: " cache.Count " items`n`n"

    invalidated := InvalidateTag("users")
    output .= "Invalidated 'users' tag: " invalidated " items`n"
    output .= "Remaining: " cache.Count " items`n`n"

    invalidated := InvalidateTag("products")
    output .= "Invalidated 'products' tag: " invalidated " items`n"
    output .= "Remaining: " cache.Count " items`n"

    MsgBox(output, "Tag-Based Invalidation")
}

;=============================================================================
; Example 3: Pattern-Based Cache Invalidation
;=============================================================================

Example3_PatternInvalidation() {
    cache := Map(
        "user:1:profile", "Profile 1",
        "user:1:settings", "Settings 1",
        "user:2:profile", "Profile 2",
        "user:2:settings", "Settings 2",
        "product:100", "Product 100"
    )

    InvalidatePattern(pattern) {
        toDelete := []

        for key in cache {
            if (InStr(key, pattern))
                toDelete.Push(key)
        }

        for key in toDelete {
            cache.Delete(key)
        }

        return toDelete
    }

    output := "=== Pattern Invalidation ===`n`n"
    output .= "Initial cache: " cache.Count " items`n`n"

    ; Invalidate all cache for user:1
    deleted := InvalidatePattern("user:1")
    output .= "Deleted keys matching 'user:1': " deleted.Length "`n"
    for key in deleted {
        output .= "  " key "`n"
    }

    output .= "`nRemaining: " cache.Count " items`n"

    MsgBox(output, "Pattern Invalidation")
}

;=============================================================================
; Example 4: Dependency-Based Invalidation
;=============================================================================

Example4_DependencyInvalidation() {
    cache := Map()
    dependencies := Map()  ; key -> [dependent keys]

    SetWithDependencies(key, value, deps := []) {
        cache.Set(key, value)

        for dep in deps {
            if (!dependencies.Has(dep))
                dependencies.Set(dep, [])
            dependencies[dep].Push(key)
        }
    }

    InvalidateCascade(key) {
        toDelete := [key]
        deleted := []

        while (toDelete.Length > 0) {
            current := toDelete.RemoveAt(1)

            if (cache.Delete(current) != "")
                deleted.Push(current)

            ; Add dependent keys
            if (dependencies.Has(current)) {
                for dep in dependencies[current] {
                    toDelete.Push(dep)
                }
                dependencies.Delete(current)
            }
        }

        return deleted
    }

    output := "=== Dependency Invalidation ===`n`n"

    SetWithDependencies("user:1", "User data")
    SetWithDependencies("user:1:posts", "Posts", ["user:1"])
    SetWithDependencies("user:1:comments", "Comments", ["user:1"])
    SetWithDependencies("post:100", "Post data", ["user:1:posts"])

    output .= "Initial cache: " cache.Count " items`n`n"

    deleted := InvalidateCascade("user:1")
    output .= "Cascade delete from 'user:1': " deleted.Length " items`n"
    for key in deleted {
        output .= "  " key "`n"
    }

    output .= "`nRemaining: " cache.Count " items`n"

    MsgBox(output, "Dependency Invalidation")
}

;=============================================================================
; Example 5: Conditional Cache Invalidation
;=============================================================================

Example5_ConditionalInvalidation() {
    cache := Map(
        "item1", Map("value", "Data 1", "hits", 100, "size", 1024),
        "item2", Map("value", "Data 2", "hits", 5, "size", 2048),
        "item3", Map("value", "Data 3", "hits", 50, "size", 512),
        "item4", Map("value", "Data 4", "hits", 2, "size", 4096)
    )

    InvalidateWhere(condition) {
        toDelete := []

        for key, item in cache {
            if (condition.Call(item))
                toDelete.Push(key)
        }

        for key in toDelete {
            cache.Delete(key)
        }

        return toDelete
    }

    output := "=== Conditional Invalidation ===`n`n"
    output .= "Initial cache: " cache.Count " items`n`n"

    ; Invalidate low-hit items
    deleted := InvalidateWhere((item) => item["hits"] < 10)
    output .= "Deleted low-hit items (<10): " deleted.Length "`n"

    output .= "Remaining: " cache.Count " items`n"

    MsgBox(output, "Conditional Invalidation")
}

;=============================================================================
; Example 6: Write-Through Cache Invalidation
;=============================================================================

Example6_WriteThroughInvalidation() {
    cache := Map()
    storage := Map()

    Write(key, value) {
        ; Invalidate cache
        cache.Delete(key)
        ; Write to storage
        storage.Set(key, value)
    }

    Read(key) {
        ; Check cache
        if (cache.Has(key))
            return cache[key]

        ; Read from storage
        if (!storage.Has(key))
            return ""

        value := storage[key]
        cache.Set(key, value)
        return value
    }

    output := "=== Write-Through Cache ===`n`n"

    ; Initial write
    Write("key1", "value1")
    output .= "Wrote key1`n"

    ; Read (cache miss, then cached)
    val := Read("key1")
    output .= "Read key1: " val " (cached)`n`n"

    ; Update (invalidates cache)
    Write("key1", "updated value")
    output .= "Updated key1 (cache invalidated)`n"

    ; Read again (cache miss, re-cached)
    val := Read("key1")
    output .= "Read key1: " val " (re-cached)`n`n"

    output .= "Cache size: " cache.Count "`n"
    output .= "Storage size: " storage.Count "`n"

    MsgBox(output, "Write-Through Cache")
}

;=============================================================================
; Example 7: Cache Warming and Invalidation
;=============================================================================

Example7_CacheWarming() {
    cache := Map()
    storage := Map("id1", "Data 1", "id2", "Data 2", "id3", "Data 3")

    WarmCache(keys) {
        for key in keys {
            if (storage.Has(key))
                cache.Set(key, storage[key])
        }
    }

    InvalidateAll() {
        count := cache.Count
        cache.Clear()
        return count
    }

    InvalidateAndRewarm(invalidateKeys, rewarmKeys) {
        ; Invalidate specific keys
        for key in invalidateKeys {
            cache.Delete(key)
        }

        ; Rewarm with new keys
        WarmCache(rewarmKeys)
    }

    output := "=== Cache Warming ===`n`n"

    ; Warm cache
    WarmCache(["id1", "id2"])
    output .= "Warmed cache: " cache.Count " items`n`n"

    ; Invalidate and rewarm
    InvalidateAndRewarm(["id1"], ["id3"])
    output .= "After invalidate & rewarm:`n"
    output .= "  Cache size: " cache.Count "`n"

    output .= "  Cached keys: "
    for key in cache {
        output .= key " "
    }

    MsgBox(output, "Cache Warming")
}

;=============================================================================
; GUI Interface
;=============================================================================

CreateDemoGUI() {
    demoGui := Gui()
    demoGui.Title := "Map.Delete() - Cache Invalidation"

    demoGui.Add("Text", "x10 y10 w480 +Center", "Cache Invalidation with Map.Delete()")

    demoGui.Add("Button", "x10 y40 w230 h30", "Example 1: TTL Cache")
        .OnEvent("Click", (*) => Example1_TTLCache())

    demoGui.Add("Button", "x250 y40 w230 h30", "Example 2: Tag-Based")
        .OnEvent("Click", (*) => Example2_TagBasedInvalidation())

    demoGui.Add("Button", "x10 y80 w230 h30", "Example 3: Pattern-Based")
        .OnEvent("Click", (*) => Example3_PatternInvalidation())

    demoGui.Add("Button", "x250 y80 w230 h30", "Example 4: Dependency")
        .OnEvent("Click", (*) => Example4_DependencyInvalidation())

    demoGui.Add("Button", "x10 y120 w230 h30", "Example 5: Conditional")
        .OnEvent("Click", (*) => Example5_ConditionalInvalidation())

    demoGui.Add("Button", "x250 y120 w230 h30", "Example 6: Write-Through")
        .OnEvent("Click", (*) => Example6_WriteThroughInvalidation())

    demoGui.Add("Button", "x10 y160 w470 h30", "Example 7: Cache Warming")
        .OnEvent("Click", (*) => Example7_CacheWarming())

    demoGui.Add("Button", "x10 y200 w470 h30", "Run All Examples")
        .OnEvent("Click", RunAll)

    RunAll(*) {
        Example1_TTLCache()
        Example2_TagBasedInvalidation()
        Example3_PatternInvalidation()
        Example4_DependencyInvalidation()
        Example5_ConditionalInvalidation()
        Example6_WriteThroughInvalidation()
        Example7_CacheWarming()
        MsgBox("All examples completed!", "Finished")
    }

    demoGui.Show("w490 h240")
}

CreateDemoGUI()
