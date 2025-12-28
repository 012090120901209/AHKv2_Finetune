#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Write-Through and Write-Behind Cache - Persistence patterns
; Demonstrates cache synchronization strategies

; Base cache store interface
class CacheStore {
    Get(key) => ""
    Set(key, value) => ""
    Delete(key) => ""
    Has(key) => false
}

; In-memory store
class MemoryStore extends CacheStore {
    __New() => this.data := Map()
    Get(key) => this.data.Has(key) ? this.data[key] : ""
    Set(key, value) => this.data[key] := value
    Delete(key) => this.data.Delete(key)
    Has(key) => this.data.Has(key)
    Clear() => this.data := Map()
}

; Simulated persistent store (like a database)
class PersistentStore extends CacheStore {
    __New() {
        this.data := Map()
        this.writeLatency := 50  ; Simulated write delay
        this.readLatency := 30   ; Simulated read delay
    }

    Get(key) {
        Sleep(this.readLatency)
        return this.data.Has(key) ? this.data[key] : ""
    }

    Set(key, value) {
        Sleep(this.writeLatency)
        this.data[key] := value
        return value
    }

    Delete(key) {
        Sleep(this.writeLatency)
        return this.data.Delete(key)
    }

    Has(key) {
        Sleep(this.readLatency)
        return this.data.Has(key)
    }
}

; Write-Through Cache - Writes go to both cache and store synchronously
class WriteThroughCache {
    cache := Map()  ; Direct Map usage avoids type inference issues

    __New(backingStore) {
        this.store := backingStore
    }

    Get(key) {
        ; Try cache first
        if this.cache.Has(key)
            return this.cache[key]

        ; Miss - fetch from store
        value := this.store.Get(key)
        if value != ""
            this.cache[key] := value

        return value
    }

    Set(key, value) {
        ; Write to both synchronously
        this.store.Set(key, value)
        this.cache[key] := value
        return value
    }

    Delete(key) {
        this.store.Delete(key)
        this.cache.Delete(key)
    }

    Invalidate(key) {
        this.cache.Delete(key)
    }
}

; Write-Behind Cache - Writes are buffered and flushed asynchronously
class WriteBehindCache {
    cache := Map()  ; Direct Map usage
    writeBuffer := Map()

    __New(backingStore, options := "") {
        this.store := backingStore
        this.maxBufferSize := (options && options.Has("maxBufferSize")) ? options["maxBufferSize"] : 100
        this.flushInterval := (options && options.Has("flushInterval")) ? options["flushInterval"] : 1000
        this.lastFlush := A_TickCount
    }

    Get(key) {
        ; Check write buffer first (most recent)
        if this.writeBuffer.Has(key)
            return this.writeBuffer[key]["value"]

        ; Then cache
        if this.cache.Has(key)
            return this.cache[key]

        ; Finally backing store
        value := this.store.Get(key)
        if value != ""
            this.cache[key] := value

        return value
    }

    Set(key, value) {
        ; Update cache immediately
        this.cache[key] := value

        ; Buffer the write
        this.writeBuffer[key] := Map("value", value, "timestamp", A_TickCount)

        ; Check if flush needed
        if this.writeBuffer.Count >= this.maxBufferSize
            this.Flush()

        return value
    }

    Flush() {
        if !this.writeBuffer.Count
            return 0

        count := 0
        for key, entry in this.writeBuffer {
            this.store.Set(key, entry["value"])
            count++
        }

        this.writeBuffer := Map()
        this.lastFlush := A_TickCount
        return count
    }

    GetPendingWrites() => this.writeBuffer.Count

    Delete(key) {
        this.cache.Delete(key)
        this.writeBuffer.Delete(key)
        this.store.Delete(key)
    }
}

; Read-Through Cache - Automatically loads missing entries
class ReadThroughCache {
    cache := Map()  ; Direct Map usage

    __New(loader) {
        this.loader := loader  ; Function to load missing data
    }

    Get(key) {
        if this.cache.Has(key)
            return this.cache[key]

        ; Load from source
        value := this.loader(key)
        if value != ""
            this.cache[key] := value

        return value
    }

    Invalidate(key) => this.cache.Delete(key)
    Clear() => this.cache := Map()
}

; Demo - Write-Through
MsgBox("Cache Pattern Demo`n`nTesting Write-Through, Write-Behind, and Read-Through caches...")

myStore := PersistentStore()
wtCache := WriteThroughCache(myStore)

result := "Write-Through Cache:`n`n"

; Write (synchronous to both)
start := A_TickCount
wtCache.Set("user:1", Map("name", "Alice", "email", "alice@test.com"))
writeTime := A_TickCount - start
result .= "Write time: " writeTime "ms (includes store write)`n"

; Read (from cache)
start := A_TickCount
data := wtCache.Get("user:1")
readTime := A_TickCount - start
result .= "Read time (cached): " readTime "ms`n"

; Invalidate and read (from store)
wtCache.Invalidate("user:1")
start := A_TickCount
data := wtCache.Get("user:1")
readTime := A_TickCount - start
result .= "Read time (store): " readTime "ms`n"

MsgBox(result)

; Demo - Write-Behind
wbCache := WriteBehindCache(PersistentStore(), Map("maxBufferSize", 5))

result := "Write-Behind Cache:`n`n"

; Multiple writes (fast - buffered)
start := A_TickCount
Loop 4 {
    wbCache.Set("item:" A_Index, "value" A_Index)
}
writeTime := A_TickCount - start
result .= "4 writes buffered in: " writeTime "ms`n"
result .= "Pending writes: " wbCache.GetPendingWrites() "`n"

; Flush to store
start := A_TickCount
flushed := wbCache.Flush()
flushTime := A_TickCount - start
result .= "Flushed " flushed " writes in: " flushTime "ms`n"
result .= "Pending after flush: " wbCache.GetPendingWrites() "`n"

MsgBox(result)

; Demo - Read-Through
; Simulated data loader
dataLoader := (key) {
    Sleep(40)  ; Simulate fetch
    if key = "config"
        return Map("theme", "dark", "language", "en")
    return "data for " key
}

rtCache := ReadThroughCache(dataLoader)

result := "Read-Through Cache:`n`n"

; First read (loads from source)
start := A_TickCount
data := rtCache.Get("config")
loadTime := A_TickCount - start
result .= "First read: " loadTime "ms (loaded)`n"

; Second read (cached)
start := A_TickCount
data := rtCache.Get("config")
cacheTime := A_TickCount - start
result .= "Second read: " cacheTime "ms (cached)`n"

; Invalidate and read
rtCache.Invalidate("config")
start := A_TickCount
data := rtCache.Get("config")
reloadTime := A_TickCount - start
result .= "After invalidate: " reloadTime "ms (reloaded)`n"

MsgBox(result)
