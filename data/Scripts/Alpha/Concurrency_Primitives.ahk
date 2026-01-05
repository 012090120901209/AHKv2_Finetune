#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Semaphore and Mutex - Concurrency primitives
; Demonstrates resource access control patterns

class Semaphore {
    __New(permits := 1) {
        this.permits := permits
        this.available := permits
        this.waiting := []
    }

    Acquire(callback := "") {
        if this.available > 0 {
            this.available--
            if callback
                callback()
            return true
        }

        if callback
            this.waiting.Push(callback)
        return false
    }

    Release() {
        if this.waiting.Length && this.available = 0 {
            callback := this.waiting.RemoveAt(1)
            callback()
        } else {
            this.available := Min(this.available + 1, this.permits)
        }
    }

    TryAcquire() {
        if this.available > 0 {
            this.available--
            return true
        }
        return false
    }

    GetAvailable() => this.available
    GetWaiting() => this.waiting.Length
}

class Mutex {
    __New() {
        this.locked := false
        this.waiting := []
    }

    Lock(callback := "") {
        if !this.locked {
            this.locked := true
            if callback
                callback()
            return true
        }

        if callback
            this.waiting.Push(callback)
        return false
    }

    Unlock() {
        if this.waiting.Length {
            callback := this.waiting.RemoveAt(1)
            callback()
        } else {
            this.locked := false
        }
    }

    TryLock() {
        if !this.locked {
            this.locked := true
            return true
        }
        return false
    }

    IsLocked() => this.locked
}

; Read-Write Lock - Multiple readers, single writer
class ReadWriteLock {
    __New() {
        this.readers := 0
        this.writer := false
        this.readWaiters := []
        this.writeWaiters := []
    }

    AcquireRead(callback := "") {
        if !this.writer && !this.writeWaiters.Length {
            this.readers++
            if callback
                callback()
            return true
        }

        if callback
            this.readWaiters.Push(callback)
        return false
    }

    ReleaseRead() {
        this.readers--
        if this.readers = 0 && this.writeWaiters.Length {
            this.writer := true
            callback := this.writeWaiters.RemoveAt(1)
            callback()
        }
    }

    AcquireWrite(callback := "") {
        if !this.writer && this.readers = 0 {
            this.writer := true
            if callback
                callback()
            return true
        }

        if callback
            this.writeWaiters.Push(callback)
        return false
    }

    ReleaseWrite() {
        this.writer := false

        ; Prefer readers
        while this.readWaiters.Length && !this.writeWaiters.Length {
            this.readers++
            callback := this.readWaiters.RemoveAt(1)
            callback()
        }

        if this.readers = 0 && this.writeWaiters.Length {
            this.writer := true
            callback := this.writeWaiters.RemoveAt(1)
            callback()
        }
    }
}

; Demo - Semaphore (limited resources)
sem := Semaphore(2)  ; 2 permits

logs := []
Loop 5 {
    i := A_Index
    if sem.TryAcquire()
        logs.Push("Task " i ": Acquired (available: " sem.GetAvailable() ")")
    else
        logs.Push("Task " i ": Blocked (waiting: " sem.GetWaiting() ")")
}

; Release some
sem.Release()
logs.Push("Released one (available: " sem.GetAvailable() ")")

result := "Semaphore Demo:`n"
for log in logs
    result .= log "`n"

MsgBox(result)

; Demo - Mutex
myMutex := Mutex()

myMutex.Lock()
MsgBox("Mutex locked: " myMutex.IsLocked() "`nTryLock again: " myMutex.TryLock())

mutex.Unlock()
MsgBox("Mutex unlocked: "!mutex.IsLocked())
