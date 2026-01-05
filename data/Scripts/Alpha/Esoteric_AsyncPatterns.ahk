#Requires AutoHotkey v2.1-alpha.17
#SingleInstance Force

; Esoteric Async Patterns - Cooperative concurrency without threads
; Demonstrates async-like patterns and coroutines in AHK v2

; =============================================================================
; 1. Promise Implementation
; =============================================================================

class Promise {
    static _pending := "pending"
    static _fulfilled := "fulfilled"
    static _rejected := "rejected"

    __New(executor := "") {
        this._state := Promise._pending
        this._value := ""
        this._handlers := []

        if executor
            executor(
                (value) => this._resolve(value),
                (reason) => this._reject(reason)
            )
    }

    ; Static constructors
    static Resolve(value) {
        p := Promise()
        p._resolve(value)
        return p
    }

    static Reject(reason) {
        p := Promise()
        p._reject(reason)
        return p
    }

    ; Wait for all promises
    static All(promises) {
        return Promise(_CreateAllExecutor(promises))
    }

    ; First to resolve wins
    static Race(promises) {
        return Promise(_CreateRaceExecutor(promises))
    }

    ; Settle all (never rejects)
    static AllSettled(promises) {
        wrapped := []
        for p in promises {
            wrapped.Push(
                p.Then(
                    (v) => ({ status: "fulfilled", value: v }),
                    (e) => ({ status: "rejected", reason: e })
                )
            )
        }
        return Promise.All(wrapped)
    }

    _resolve(value) {
        if this._state != Promise._pending
            return

        ; Handle promise chaining
        if value is Promise {
            value.Then(
                (v) => this._resolve(v),
                (r) => this._reject(r)
            )
            return
        }

        this._state := Promise._fulfilled
        this._value := value
        this._notify()
    }

    _reject(reason) {
        if this._state != Promise._pending
            return

        this._state := Promise._rejected
        this._value := reason
        this._notify()
    }

    Then(onFulfilled := "", onRejected := "") {
        return Promise(_CreateThenExecutor(this, onFulfilled, onRejected))
    }

    Catch(onRejected) => this.Then("", onRejected)

    Finally(onFinally) {
        return this.Then(
            (value) => (onFinally(), value),
            (reason) => (onFinally(), _ThrowError(reason))
        )
    }

    _notify() {
        for handler in this._handlers {
            try {
                if this._state = Promise._fulfilled {
                    if handler.fulfill {
                        result := handler.fulfill(this._value)
                        handler.resolve(result)
                    } else {
                        handler.resolve(this._value)
                    }
                } else if this._state = Promise._rejected {
                    if handler.reject_ {
                        result := handler.reject_(this._value)
                        handler.resolve(result)
                    } else {
                        handler.reject(this._value)
                    }
                }
            } catch Error as e {
                handler.reject(e)
            }
        }
        this._handlers := []
    }

    State => this._state
    IsPending => this._state = Promise._pending
}

; Helper functions for Promise (can't use fat arrows with blocks)
_CreateAllExecutor(promises) {
    return (resolve, reject) => _ExecuteAll(promises, resolve, reject)
}

_ExecuteAll(promises, resolve, reject) {
    results := []
    remaining := promises.Length

    if remaining = 0 {
        resolve(results)
        return
    }

    for i, p in promises {
        idx := i
        p.Then(
            _CreateAllResultHandler(results, idx, &remaining, resolve),
            reject
        )
    }
}

_CreateAllResultHandler(results, idx, &remaining, resolve) {
    return (v) => _HandleAllResult(results, idx, v, &remaining, resolve)
}

_HandleAllResult(results, idx, v, &remaining, resolve) {
    results.InsertAt(idx, v)
    remaining--
    if remaining <= 0
        resolve(results)
}

_CreateRaceExecutor(promises) {
    return (resolve, reject) => _ExecuteRace(promises, resolve, reject)
}

_ExecuteRace(promises, resolve, reject) {
    for p in promises
        p.Then(resolve, reject)
}

_CreateThenExecutor(promise, onFulfilled, onRejected) {
    return (resolve, reject) => _ExecuteThen(promise, onFulfilled, onRejected, resolve, reject)
}

_ExecuteThen(promise, onFulfilled, onRejected, resolve, reject) {
    promise._handlers.Push({
        fulfill: onFulfilled,
        reject_: onRejected,
        resolve: resolve,
        reject: reject
    })
    if promise._state != Promise._pending
        promise._notify()
}

_ThrowError(reason) {
    throw reason is Error ? reason : Error(String(reason))
}

; =============================================================================
; 2. Async Task Queue
; =============================================================================

class TaskQueue {
    __New(concurrency := 1) {
        this._concurrency := concurrency
        this._queue := []
        this._running := 0
        this._paused := false
    }

    ; Add task (returns promise)
    Add(taskFn, priority := 0) {
        p := Promise()

        this._queue.Push({
            fn: taskFn,
            priority: priority,
            promise: p
        })

        ; Sort by priority (higher first)
        this._queue := this._sortByPriority(this._queue)

        this._process()
        return p
    }

    _sortByPriority(arr) {
        ; Simple bubble sort
        n := arr.Length
        loop n - 1 {
            i := A_Index
            loop n - i {
                j := A_Index
                if arr[j].priority < arr[j + 1].priority {
                    temp := arr[j]
                    arr[j] := arr[j + 1]
                    arr[j + 1] := temp
                }
            }
        }
        return arr
    }

    _process() {
        if this._paused
            return

        while this._running < this._concurrency && this._queue.Length > 0 {
            task := this._queue.RemoveAt(1)
            this._running++

            try {
                result := task.fn()
                if result is Promise {
                    result.Then(
                        (v) => this._complete(task, true, v),
                        (e) => this._complete(task, false, e)
                    )
                } else {
                    this._complete(task, true, result)
                }
            } catch Error as e {
                this._complete(task, false, e)
            }
        }
    }

    _complete(task, success, value) {
        this._running--

        if success
            task.promise._resolve(value)
        else
            task.promise._reject(value)

        ; Schedule next task
        SetTimer(() => this._process(), -1)
    }

    Pause() => this._paused := true
    Resume() {
        this._paused := false
        this._process()
    }

    Clear() => this._queue := []

    QueueLength => this._queue.Length
    RunningCount => this._running
}

; =============================================================================
; 3. Simple Coroutine via Generators
; =============================================================================

class Coroutine {
    __New(genFn) {
        this._genFn := genFn
        this._state := "created"
        this._value := ""
        this._stepFn := ""
    }

    Start() {
        if this._state != "created"
            return this

        this._state := "running"
        this._iterator := this._createIterator()
        return this
    }

    _createIterator() {
        ; Simulated generator state
        return {
            steps: [],
            index: 1,
            addStep: (step) => this._iterator.steps.Push(step),
            next: () => this._iteratorNext()
        }
    }

    _iteratorNext() {
        if this._iterator.index <= this._iterator.steps.Length {
            result := this._iterator.steps[this._iterator.index]()
            this._iterator.index++
            return { value: result, done: false }
        }
        return { done: true }
    }

    ; Yield equivalent - call from generator
    Yield(value) {
        this._value := value
        return value
    }

    ; Step through coroutine
    Step() {
        if this._state != "running"
            return { done: true }

        return this._iterator.next()
    }

    State => this._state
    Value => this._value
}

; =============================================================================
; 4. Event Loop Simulation
; =============================================================================

class EventLoop {
    static _instance := ""
    static _microtasks := []
    static _macrotasks := []
    static _running := false

    static Get() {
        if !this._instance
            this._instance := EventLoop()
        return this._instance
    }

    ; Schedule microtask (high priority)
    static QueueMicrotask(fn) {
        this._microtasks.Push(fn)
        this._run()
    }

    ; Schedule macrotask (normal priority)
    static QueueMacrotask(fn, delay := 0) {
        if delay > 0 {
            SetTimer(() => this._macrotasks.Push(fn), -delay)
        } else {
            this._macrotasks.Push(fn)
        }
        this._run()
    }

    static _run() {
        if this._running
            return

        this._running := true
        SetTimer(ObjBindMethod(this, "_processLoop"), -1)
    }

    static _processLoop() {
        ; Process all microtasks first
        while this._microtasks.Length > 0 {
            task := this._microtasks.RemoveAt(1)
            try {
                task()
            }
        }

        ; Then one macrotask
        if this._macrotasks.Length > 0 {
            task := this._macrotasks.RemoveAt(1)
            try {
                task()
            }

            ; Schedule next iteration
            if this._macrotasks.Length > 0 || this._microtasks.Length > 0
                SetTimer(ObjBindMethod(this, "_processLoop"), -1)
        }

        this._running := false
    }

    static PendingCount => this._microtasks.Length + this._macrotasks.Length
}

; =============================================================================
; 5. Async/Await Simulation
; =============================================================================

; Await helper - blocks until promise resolves (via polling)
Await(promise, timeout := 5000) {
    if !(promise is Promise)
        return promise

    start := A_TickCount

    while promise.IsPending {
        if A_TickCount - start > timeout
            throw Error("Await timeout")
        Sleep(10)
    }

    if promise._state = Promise._rejected
        throw promise._value is Error ? promise._value : Error(String(promise._value))

    return promise._value
}

; Async function wrapper
Async(fn) {
    return _CreateAsyncWrapper(fn)
}

_CreateAsyncWrapper(fn) {
    return (args*) => Promise(_CreateAsyncExecutor(fn, args))
}

_CreateAsyncExecutor(fn, args) {
    return (resolve, reject) => _ExecuteAsync(fn, args, resolve, reject)
}

_ExecuteAsync(fn, args, resolve, reject) {
    try {
        result := fn(args*)
        resolve(result)
    } catch Error as e {
        reject(e)
    }
}

; =============================================================================
; 6. Channel (CSP-style communication)
; =============================================================================

class Channel {
    __New(bufferSize := 0) {
        this._buffer := []
        this._bufferSize := bufferSize
        this._sendWaiters := []
        this._recvWaiters := []
        this._closed := false
    }

    ; Send value (may block if buffer full)
    Send(value) {
        if this._closed
            throw Error("Cannot send on closed channel")

        ; If there's a waiting receiver, deliver directly
        if this._recvWaiters.Length > 0 {
            waiter := this._recvWaiters.RemoveAt(1)
            waiter.resolve(value)
            return Promise.Resolve(true)
        }

        ; If buffer has space, add to buffer
        if this._buffer.Length < this._bufferSize {
            this._buffer.Push(value)
            return Promise.Resolve(true)
        }

        ; Otherwise, wait
        capturedValue := value
        return Promise(_CreateSendWaiter(this, capturedValue))
    }

    ; Receive value (may block if buffer empty)
    Recv() {
        if this._closed && this._buffer.Length = 0
            return Promise.Resolve({ value: "", ok: false })

        ; If buffer has values, return from buffer
        if this._buffer.Length > 0 {
            value := this._buffer.RemoveAt(1)

            ; If senders waiting, move one to buffer
            if this._sendWaiters.Length > 0 {
                waiter := this._sendWaiters.RemoveAt(1)
                this._buffer.Push(waiter.value)
                waiter.resolve(true)
            }

            return Promise.Resolve({ value: value, ok: true })
        }

        ; If senders waiting, receive directly
        if this._sendWaiters.Length > 0 {
            waiter := this._sendWaiters.RemoveAt(1)
            waiter.resolve(true)
            return Promise.Resolve({ value: waiter.value, ok: true })
        }

        ; Otherwise, wait
        return Promise(_CreateRecvWaiter(this))
    }

    Close() {
        this._closed := true

        ; Wake all waiting receivers with closed signal
        for waiter in this._recvWaiters
            waiter.resolve({ value: "", ok: false })
        this._recvWaiters := []
    }

    IsClosed => this._closed
    Length => this._buffer.Length
}

_CreateSendWaiter(channel, value) {
    return (resolve, reject) => channel._sendWaiters.Push({ value: value, resolve: resolve })
}

_CreateRecvWaiter(channel) {
    return (resolve, reject) => channel._recvWaiters.Push({ resolve: (v) => resolve({ value: v, ok: true }) })
}

; =============================================================================
; 7. Semaphore
; =============================================================================

class Semaphore {
    __New(permits := 1) {
        this._permits := permits
        this._waiters := []
    }

    Acquire() {
        if this._permits > 0 {
            this._permits--
            return Promise.Resolve(true)
        }

        return Promise(_CreateSemaphoreWaiter(this))
    }

    Release() {
        if this._waiters.Length > 0 {
            waiter := this._waiters.RemoveAt(1)
            waiter(true)
        } else {
            this._permits++
        }
    }

    ; Run with automatic acquire/release
    WithLock(fn) {
        return this.Acquire().Then(_CreateLockHandler(this, fn))
    }

    AvailablePermits => this._permits
    WaitingCount => this._waiters.Length
}

_CreateSemaphoreWaiter(sem) {
    return (resolve, reject) => sem._waiters.Push(resolve)
}

_CreateLockHandler(sem, fn) {
    return (granted) => _ExecuteWithLock(sem, fn)
}

_ExecuteWithLock(sem, fn) {
    try {
        return fn()
    } finally {
        sem.Release()
    }
}

; =============================================================================
; 8. Deferred Execution
; =============================================================================

class Deferred {
    __New() {
        this._promise := Promise()
    }

    Resolve(value) => this._promise._resolve(value)
    Reject(reason) => this._promise._reject(reason)
    Promise => this._promise
}

; =============================================================================
; Demo
; =============================================================================

; Basic promise
p := Promise((resolve, reject) => resolve("Hello Promise!"))
p.Then((v) => MsgBox("Promise resolved: " v))

; Promise chaining
Promise.Resolve(5)
    .Then((x) => x * 2)
    .Then((x) => x + 10)
    .Then((x) => MsgBox("Promise chain: 5 * 2 + 10 = " x))

; Promise.All
Promise.All([
    Promise.Resolve(1),
    Promise.Resolve(2),
    Promise.Resolve(3)
]).Then((values) => MsgBox("Promise.All: " _ArrayJoin(values, ", ")))

; Task queue with priority
queue := TaskQueue(2)  ; 2 concurrent tasks

queue.Add(() => (Sleep(100), "Low"), 0)
queue.Add(() => (Sleep(50), "High"), 10)
queue.Add(() => (Sleep(75), "Medium"), 5)

MsgBox("Task Queue:`n`nQueue length: " queue.QueueLength "`nRunning: " queue.RunningCount)

; Event loop simulation
EventLoop.QueueMacrotask(() => MsgBox("Macrotask 1"))
EventLoop.QueueMicrotask(() => MsgBox("Microtask 1 (runs first)"))
EventLoop.QueueMacrotask(() => MsgBox("Macrotask 2"))

; Semaphore
sem := Semaphore(2)
MsgBox("Semaphore:`n`nAvailable permits: " sem.AvailablePermits)

Await(sem.Acquire())
MsgBox("After acquire: " sem.AvailablePermits " permits")

sem.Release()
MsgBox("After release: " sem.AvailablePermits " permits")

; Channel
ch := Channel(2)  ; Buffer size 2

; Send some values
ch.Send(1)
ch.Send(2)
MsgBox("Channel buffer length: " ch.Length)

; Receive
r1 := Await(ch.Recv())
r2 := Await(ch.Recv())
MsgBox("Channel received: " r1.value ", " r2.value)

; Deferred
d := Deferred()
d.Promise.Then((v) => MsgBox("Deferred resolved: " v))
d.Resolve("Later!")

; Async wrapper
asyncFn := Async((x) => x * 2)
asyncFn(21).Then((v) => MsgBox("Async result: " v))

_ArrayJoin(arr, sep) {
    result := ""
    for i, v in arr
        result .= (i > 1 ? sep : "") . String(v)
    return result
}
