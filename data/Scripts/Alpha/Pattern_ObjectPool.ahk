#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Object Pool Pattern - Reuses expensive objects instead of creating new ones
; Demonstrates resource management with acquire/release semantics

class ObjectPool {
    __New(factory, maxSize := 10) {
        this.factory := factory
        this.maxSize := maxSize
        this.available := []
        this.inUse := []
        this.created := 0
    }

    Acquire() {
        obj := ""

        if this.available.Length {
            obj := this.available.Pop()
        } else {
            obj := this.factory()
            this.created++
        }

        this.inUse.Push(obj)
        return obj
    }

    Release(obj) {
        for i, o in this.inUse {
            if o = obj {
                this.inUse.RemoveAt(i)
                if this.available.Length < this.maxSize
                    this.available.Push(obj)
                return true
            }
        }
        return false
    }

    GetStats() {
        return "Created: " this.created "`n"
            . "Available: " this.available.Length "`n"
            . "In Use: " this.inUse.Length
    }
}

; Demo - expensive connection objects
connectionId := 0
ConnectionFactory() {
    global connectionId
    connectionId++
    ; Simulate expensive creation
    Sleep(10)
    return { id: connectionId, created: A_TickCount }
}

pool := ObjectPool(ConnectionFactory, 5)

; Acquire several connections
connections := []
Loop 3
    connections.Push(pool.Acquire())

MsgBox("After acquiring 3:`n" pool.GetStats())

; Release 2 back to pool
pool.Release(connections[1])
pool.Release(connections[2])

MsgBox("After releasing 2:`n" pool.GetStats())

; Acquire again - should reuse
c := pool.Acquire()
MsgBox("Reused connection ID: " c.id "`n`n" pool.GetStats())
