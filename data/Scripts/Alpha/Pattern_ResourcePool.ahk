#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Resource Pool - Generic resource pooling
; Demonstrates connection/resource management pattern

class ResourcePool {
    __New(factory, options := "") {
        this.factory := factory
        this.minSize := options.Has("minSize") ? options["minSize"] : 0
        this.maxSize := options.Has("maxSize") ? options["maxSize"] : 10
        this.idleTimeout := options.Has("idleTimeout") ? options["idleTimeout"] : 30000
        this.acquireTimeout := options.Has("acquireTimeout") ? options["acquireTimeout"] : 5000

        this.available := []
        this.inUse := []
        this.waitQueue := []
        this.totalCreated := 0

        ; Pre-populate with minimum resources
        this._warmup()
    }

    _warmup() {
        Loop this.minSize {
            resource := this._createResource()
            this.available.Push(resource)
        }
    }

    _createResource() {
        if this.totalCreated >= this.maxSize
            return ""

        resource := this.factory()
        this.totalCreated++
        return Map(
            "resource", resource,
            "createdAt", A_TickCount,
            "lastUsed", A_TickCount
        )
    }

    Acquire() {
        ; Try to get from available pool
        if this.available.Length {
            wrapper := this.available.Pop()
            wrapper["lastUsed"] := A_TickCount
            this.inUse.Push(wrapper)
            return wrapper["resource"]
        }

        ; Try to create new resource
        if this.totalCreated < this.maxSize {
            wrapper := this._createResource()
            if wrapper {
                this.inUse.Push(wrapper)
                return wrapper["resource"]
            }
        }

        ; Pool exhausted
        return ""
    }

    Release(resource) {
        ; Find in inUse
        for i, wrapper in this.inUse {
            if wrapper["resource"] = resource {
                this.inUse.RemoveAt(i)
                wrapper["lastUsed"] := A_TickCount

                ; Process wait queue if any
                if this.waitQueue.Length {
                    callback := this.waitQueue.RemoveAt(1)
                    wrapper["lastUsed"] := A_TickCount
                    this.inUse.Push(wrapper)
                    callback(wrapper["resource"])
                } else {
                    this.available.Push(wrapper)
                }
                return true
            }
        }
        return false
    }

    ; Async acquire with callback
    AcquireAsync(callback) {
        resource := this.Acquire()
        if resource {
            callback(resource)
        } else {
            this.waitQueue.Push(callback)
        }
    }

    ; Execute with auto-release
    Use(fn) {
        resource := this.Acquire()
        if !resource
            throw Error("Could not acquire resource")

        try {
            return fn(resource)
        } finally {
            this.Release(resource)
        }
    }

    ; Clean up idle resources
    Prune() {
        now := A_TickCount
        pruned := 0

        i := this.available.Length
        while i >= 1 {
            wrapper := this.available[i]
            if now - wrapper["lastUsed"] > this.idleTimeout
                && this.available.Length > this.minSize {
                this.available.RemoveAt(i)
                this.totalCreated--
                pruned++
            }
            i--
        }

        return pruned
    }

    Stats() {
        return Map(
            "available", this.available.Length,
            "inUse", this.inUse.Length,
            "total", this.totalCreated,
            "waiting", this.waitQueue.Length,
            "maxSize", this.maxSize
        )
    }

    Shutdown() {
        this.available := []
        this.inUse := []
        this.waitQueue := []
        this.totalCreated := 0
    }
}

; Connection Pool - Specialized for database-like connections
class ConnectionPool extends ResourcePool {
    __New(connectionFactory, options := "") {
        super.__New(connectionFactory, options)
        this.healthCheck := options.Has("healthCheck") ? options["healthCheck"] : ""
    }

    Query(sql, callback := "") {
        return this.Use((conn) {
            ; Simulate query execution
            result := conn.Execute(sql)
            if callback
                callback(result)
            return result
        })
    }
}

; Mock connection for demo
class MockConnection {
    static idCounter := 0

    __New() {
        MockConnection.idCounter++
        this.id := MockConnection.idCounter
        OutputDebug("[Connection " this.id "] Created`n")
    }

    Execute(sql) {
        OutputDebug("[Connection " this.id "] Executing: " sql "`n")
        return Map("rows", Random(1, 100), "sql", sql)
    }
}

; Demo
pool := ResourcePool(
    () => MockConnection(),
    Map("minSize", 2, "maxSize", 5)
)

result := "Resource Pool Demo:`n`n"
result .= "Initial stats: " StatsToString(pool.Stats()) "`n`n"

; Acquire some resources
resources := []
Loop 3 {
    r := pool.Acquire()
    if r
        resources.Push(r)
}

result .= "After acquiring 3:`n" StatsToString(pool.Stats()) "`n`n"

; Release one
if resources.Length {
    pool.Release(resources.Pop())
    result .= "After releasing 1:`n" StatsToString(pool.Stats()) "`n`n"
}

; Use with auto-release
useResult := pool.Use((conn) {
    return "Used connection " conn.id
})
result .= "Use() result: " useResult "`n"
result .= "After Use():`n" StatsToString(pool.Stats()) "`n`n"

; Release remaining
for r in resources
    pool.Release(r)

result .= "After releasing all:`n" StatsToString(pool.Stats())

MsgBox(result)

; Helper
StatsToString(stats) {
    return Format("Available: {}, InUse: {}, Total: {}/{}",
        stats["available"], stats["inUse"],
        stats["total"], stats["maxSize"])
}
